package cn.wjj.upgame.render 
{
	import cn.wjj.upgame.engine.EDBullet;
	import cn.wjj.upgame.engine.EDRole;
	import cn.wjj.upgame.UpGame;
	import flash.display.DisplayObject;
	
	/**
	 * 对人物处理
	 * 
	 * @author GaGa
	 */
	public class EngineEDRole 
	{
		/** 是否显示人物 **/
		public static var hide:Boolean = false;
		/** 从场景外移除是否从场景中摧毁,否则不摧毁 **/
		public static var stageOutDispose:Boolean = false;
		
		private static var x:int;
		private static var y:int;
		private static var layer:DisplayLayer;
		
		public function EngineEDRole() { }
		
		/**
		 * 根据ED的数据来处理界面上的内容
		 * @param	upGame
		 * @param	ed
		 */
		public static function run(u:UpGame, ed:EDRole, core:int):void
		{
			if (EngineEDRole.hide) return;
			if (ed.info.typeProperty == 2)
			{
				if (layer != u.reader.map.layer_fly) layer = u.reader.map.layer_fly;
			}
			else
			{
				if (layer != u.reader.map.layer_ground) layer = u.reader.map.layer_ground;
			}
			var display:DisplayEDRole = u.reader.map.edToDisplay(ed) as DisplayEDRole;
			if (u.modeTurn)
			{
				x = int( -ed.x);
				y = int( -ed.y);
			}
			else
			{
				x = int(ed.x);
				y = int(ed.y);
			}
			if (layer.canInLayer(x, y, 400))
			{
				if (display == null) display = create(u, ed);
				if (display.boolmd && display.boolmd.isRefresh) display.boolmd.refresh();
				if (ed.uiStop == false)//uiBase 这里停掉
				{
					layer.reIndex = true;
					display.setSkin();
				}
				else if (display.x != x || display.y != y)
				{
					layer.reIndex = true;
					display.x = x;
					if (display.damage)
					{
						display.damage = false;
						display.y = y - 2;
					}
					else
					{
						display.y = y;
					}
					if (display.shadow) display.shadow.setSizeInfo( x, y);
				}
				else if (display.damage)
				{
					display.damage = false;
					display.y = y - 2;
				}
				//处理Buff
				if (ed.isLive && ed.ai.buff.length)
				{
					if (display.buff == null) display.buff = DisplayEDRoleBuff.instance();
					display.buff.reFresh(u, ed, display, ed.ai.buff.buffList, core);
				}
				else if(display.buff)
				{
					display.buff.dispose();
					display.buff = null;
				}
			}
			else
			{
				if (display)
				{
					if (EngineEDRole.stageOutDispose)
					{
						if(display.buff)
						{
							display.buff.dispose();
							display.buff = null;
						}
					}
					else
					{
						if (display.x != x || display.y != y)
						{
							display.x = x;
							if (display.damage)
							{
								display.damage = false;
								display.y = y - 2;
							}
							else
							{
								display.y = y;
							}
							if (display.shadow) display.shadow.setSizeInfo(x, y);
						}
						else if (display.damage)
						{
							display.damage = false;
							display.y = y - 2;
						}
					}
				}
				u.reader.map.edToDispose(ed);
			}
		}
		
		/**
		 * 添加DEBUG数据
		 * @param	upGame
		 * @param	camp
		 * @param	ed
		 */
		public static function addDebug(u:UpGame, ed:EDRole):void
		{
			var display:DisplayEDRole = u.reader.map.edToDisplay(ed) as DisplayEDRole;
			if (display) display.showDebug();
		}
		
		/**
		 * 移除DEBUG数据
		 * @param	upGame
		 * @param	camp
		 * @param	ed
		 */
		public static function removeDebug(u:UpGame, ed:EDRole):void
		{
			var display:DisplayEDRole = u.reader.map.edToDisplay(ed) as DisplayEDRole;
			if (display) display.hideDebug();
		}
		
		/** 通过ED数据来获取显示对象 **/
		private static function create(u:UpGame, ed:EDRole):DisplayEDRole
		{
			var display:DisplayEDRole = new DisplayEDRole(u, ed);
			u.reader.map.display_ed[ed] = display;
			var layer:DisplayLayer;
			if (ed.info.typeProperty == 2)
			{
				layer = u.reader.map.layer_fly;
			}
			else
			{
				layer = u.reader.map.layer_ground;
			}
			layer.addChild(display);
			layer.reIndex = true;
			return display;
		}
		
		/** 特效已经挂了,可以移除了 **/
		public static function die(u:UpGame, ed:EDBullet):void
		{
			var display:DisplayObject = u.reader.map.display_ed[ed];
			delete u.reader.map.display_ed[ed];
			if (display)
			{
				(display as Object).dispose();
				display = null;
			}
		}
		
		/** 收到伤害,并显示出伤害的数字 **/
		public static function damage(u:UpGame, ed:EDRole, dmg:int, isCrit:Boolean):void
		{
			var display:DisplayEDRole = u.reader.map.display_ed[ed];
			if (display)
			{
				if (display.boolmd)
				{
					display.boolmd.changeHP(true);
				}
				if (ed && ed.isLive && display.damage == false && (ed.info.typeProperty == 1 || ed.info.typeProperty == 2))
				{
					display.damage = true;
				}
			}
			EngineEffect.showDamageRole(u, ed, dmg, isCrit);
		}
		
		/** 收到伤害,只是改变血条的长度 **/
		public static function boolmdChangeHP(u:UpGame, ed:EDRole):void
		{
			var display:DisplayEDRole = u.reader.map.display_ed[ed];
			if (display && display.boolmd) display.boolmd.changeHP(false);
		}
	}
}