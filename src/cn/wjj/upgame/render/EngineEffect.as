package cn.wjj.upgame.render 
{
	import cn.wjj.upgame.common.StatusTypeRole;
	import cn.wjj.upgame.engine.EDBullet;
	import cn.wjj.upgame.engine.EDCamp;
	import cn.wjj.upgame.engine.EDRole;
	import cn.wjj.upgame.engine.EDSkillBuff;
	import cn.wjj.upgame.UpGame;
	import flash.display.DisplayObject;
	
	/**
	 * 伤害展示
	 * 
	 * @author GaGa
	 */
	public class EngineEffect 
	{
		/** 伤害数字的显示0,不显示, 1显示全部, 2,显示爆击,加血,MISS **/
		public static var show:int = 1;
		
		/** 临时变量 **/
		private static var _x:int;
		/** 临时变量 **/
		private static var _y:int;
		
		public function EngineEffect() { }
		
		/**
		 * 通过坐标显示出丢失的MISS
		 * @param	u		游戏框架
		 * @param	x		坐标点X
		 * @param	y		坐标点Y
		 */
		public static function showMissPoint(u:UpGame, x:int, y:int):void
		{
			if (EngineEffect.show != 0 && u.reader.map.layer_flyHarm)
			{
				var miss:DisplayAttackMISS;
				if (u.modeTurn)
				{
					miss = DisplayAttackMISS.instance(-x, -y);
				}
				else
				{
					miss = DisplayAttackMISS.instance(x, y);
				}
				u.reader.map.layer_flyHarm.addChild(miss);
			}
		}
		
		/**
		 * 通过角色显示出MISS
		 * @param	u		游戏框架
		 * @param	ed		显示MISS的角色
		 */
		public static function showMissRole(u:UpGame, ed:EDRole):void
		{
			if (EngineEffect.show != 0 && u.reader.map.layer_flyHarm)
			{
				_x = ed.x + ed.hit_r_x;
				_y = ed.y + ed.hit_r_y;
				if (ed.hit_h)
				{
					_x = int(ed.hit_r / 2 + _x);
				}
				else
				{
					_y = _y - ed.hit_r;
				}
				var miss:DisplayAttackMISS;
				if (u.modeTurn)
				{
					miss = DisplayAttackMISS.instance(-_x, -_y);
				}
				else
				{
					miss = DisplayAttackMISS.instance(_x, _y);
				}
				u.reader.map.layer_flyHarm.addChild(miss);
			}
		}
		
		/**
		 * 
		 * @param	upGame
		 * @param	ed
		 * @param	dmg
		 * @param	crit
		 */
		public static function showDamageRole(u:UpGame, ed:EDRole, dmg:int, crit:Boolean):void
		{
			if (u.reader.map.layer_flyHarm)
			{
				if (EngineEffect.show == 1 || (EngineEffect.show == 2 && (crit == true || dmg > 0)))
				{
					_x = ed.x + ed.hit_r_x;
					_y = ed.y + ed.hit_r_y;
					if (ed.hit_h)
					{
						_x = int(ed.hit_r / 2 + _x);
					}
					else
					{
						_y = _y - ed.hit_r;
					}
					var damage:DisplayAttackNumber;
					if (u.modeTurn)
					{
						damage = DisplayAttackNumber.instance(dmg, crit, -_x, -_y);
					}
					else
					{
						damage = DisplayAttackNumber.instance(dmg, crit, _x, _y);
					}
					u.reader.map.layer_flyHarm.addChild(damage);
				}
			}
		}
	}
}