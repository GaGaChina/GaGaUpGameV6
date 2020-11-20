package cn.wjj.upgame.tools 
{
	import cn.wjj.display.MRectangle;
	import cn.wjj.upgame.common.EDType;
	import cn.wjj.upgame.common.StatusTypeRole;
	import cn.wjj.upgame.engine.EDBase;
	import cn.wjj.upgame.engine.EDCamp;
	import cn.wjj.upgame.engine.EDRole;
	import cn.wjj.upgame.engine.UpEngine;
	import cn.wjj.upgame.UpGame;
	import flash.geom.Point;
	/**
	 * 判断一个全局的坐标点,是否和人物元件的某一个范围发生碰撞
	 * 
	 * @author GaGa
	 */
	public class MouseHitMapRole 
	{
		
		public function MouseHitMapRole() { }
		
		/**
		 * 检测是否和Map的ground层某一个坐标碰撞的对象
		 * @param	game
		 * @param	campId
		 * @param	groundPoint
		 * @return
		 */
		public static function GroundHitRole(game:UpGame, campId:int, groundPoint:Point):EDRole
		{
			var engine:UpEngine = game.engine;
			if (engine.camp.hasOwnProperty(campId))
			{
				var r:MRectangle = MRectangle.instance();
				var camp:EDCamp = engine.camp[campId] as EDCamp;
				if (camp.length)
				{
					var role:EDRole;
					var x:Number, y:Number, dist:Number;
					for each (var base:EDBase in camp.list) 
					{
						if (base.isLive && base.type == EDType.role)
						{
							role = base as EDRole;
							if (role && (role.camp == 1 || role.activate))
							{
								r.x = role.x + role.model.dragX;
								r.y = role.y + role.model.dragY;
								r.width = r.x + role.model.dragWidth;
								r.height = r.y + role.model.dragHeight;
								if (role.model.dragType == 1)
								{
									if (groundPoint.x < r.x || groundPoint.y < r.y || groundPoint.x > r.width || groundPoint.y > r.height)
									{
										//没碰上
									}
									else
									{
										r.dispose();
										r = null;
										return role;
									}
								}
								else
								{
									x = role.x - r.x;
									y = role.y - r.y;
									dist = Math.sqrt(x * x + y * y);
									if (dist <= r.width)
									{
										r.dispose();
										r = null;
										return role;
									}
								}
							}
						}
					}
				}
				r.dispose();
				r = null;
			}
			return null;
		}
		
		/**
		 * 检测是否和Map的ground层某一个坐标发生role发生碰撞
		 * @param	game
		 * @param	role
		 * @param	groundPoint
		 * @return
		 */
		public static function GroundHitTarget(game:UpGame, role:EDRole, groundPoint:Point):Boolean
		{
			if (role && role.isLive)
			{
				var x:Number, y:Number, dist:Number;
				var r:MRectangle = MRectangle.instance();
				r.x = role.x + role.model.dragX;
				r.y = role.y + role.model.dragY;
				r.width = r.x + role.model.dragWidth;
				r.height = r.y + role.model.dragHeight;
				if (role.model.dragType == 1)
				{
					if (groundPoint.x < r.x || groundPoint.y < r.y || groundPoint.x > r.width || groundPoint.y > r.height)
					{
						//没碰上
					}
					else
					{
						r.dispose();
						r = null;
						return true;
					}
				}
				else
				{
					x = role.x - r.x;
					y = role.y - r.y;
					dist = Math.sqrt(x * x + y * y);
					if (dist > r.width)
					{
						//距离比较大就挂了
					}
					else
					{
						r.dispose();
						r = null;
						return true;
					}
				}
			}
			return false;
		}
	}

}