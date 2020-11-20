package cn.wjj.upgame.engine 
{
	import cn.wjj.display.MPoint;
	import cn.wjj.upgame.common.EDType;
	import cn.wjj.upgame.common.StatusTypeRole;
	/**
	 * 碰撞运行方法
	 * @author GaGa
	 */
	public class AIRoleSkillToolCollision
	{
		
		public function AIRoleSkillToolCollision() { }
		
		/**
		 * a物体碰撞b物体, b物体发生移动
		 * @param	a		可能是人或子弹,buff,地面燃烧
		 * @param	ax		a对象的碰撞发出点
		 * @param	ay		a对象的碰撞发出点
		 * @param	dist	弹开的距离
		 * @param	b		只能是人物
		 * @return			a物体是否被弹开,导致不能继续冲刺
		 */
		internal static function Collision(astar:UpGameAStar, a:EDBase, ax:Number, ay:Number, dist:int, b:EDRole):Boolean
		{
			//冲锋方向的角度
			var angle:int;
			var px:Number = b.x + b.hit_r_x;
			var py:Number = b.y + b.hit_r_y;
			if (b.hit_h)
			{
				px = b.hit_r / 2 + px;
				py = b.hit_h / 2 + py;
			}
			px = ax - px;
			py = ay - py;
			if (px != 0 || py != 0)
			{
				angle = (Math.atan2(py, px) + Math.PI) * 180 / Math.PI;
				angle = angle % 360;
				if (angle < 0) angle += 360;
			}
			else
			{
				angle = b.angle;
				if (a)
				{
					if (a.type == EDType.role)
					{
						angle = (a as EDRole).angle;
					}
					else if (a.type == EDType.bullet)
					{
						angle = (a as EDBullet).angle;
					}
				}
				else
				{
					angle = b.angle + 180;
				}
			}
			if(b.isLive)
			{
				if (a && a.isLive && a.type == EDType.role)
				{
					if (b.ai.skillFire && b.ai.skillFire.skill && b.ai.skillFire.skill.specialType == 5)
					{
						Bounce(astar, a as EDRole, angle, dist, b);
						//b被弹开,并且b不能冲锋,被停下
						if (b.ai.skillFire)
						{
							b.ai.skillStop();
						}
						b.status = StatusTypeRole.idle;
						EDRoleToolsSkin.changeSkin(b, b.u.modeTurn);
						return true;
					}
					else
					{
						flick(astar, angle, dist, b);
					}
				}
				else
				{
					if (b.ai.skillFire && b.ai.skillFire.skill && b.ai.skillFire.skill.specialType == 5)
					{
						//当b被子弹搞中不能被弹开
					}
					else
					{
						flick(astar, angle, dist, b);
					}
				}
			}
			return false;
		}
		
		/**
		 * 当A冲锋和B冲锋碰撞,A和B发生互相弹开
		 * @param	a		只能是人物
		 * @param	angle	产生的角度
		 * @param	ax		碰撞者的坐标
		 * @param	ay		碰撞者的坐标
		 * @param	dist	撞开的距离
		 * @param	b		只能是人物
		 */
		private static function Bounce(astar:UpGameAStar, a:EDRole, angle:int, dist:int, b:EDRole):void
		{
			if (b.ai.skillFire.otherSkill && b.ai.skillFire.otherSkill is AIRoleSkillTypeAssaultPoint)
			{
				var bx:Number = b.x + b.hit_r_x;
				var by:Number = b.y + b.hit_r_y;
				if (b.hit_h)
				{
					bx = b.hit_r / 2 + bx;
					by = b.hit_h / 2 + by;
				}
				var ba:int = a.angle + 180;
				ba = ba % 360;
				if (ba < 0) ba += 360;
				var bd:int = (b.ai.skillFire.otherSkill as AIRoleSkillTypeAssaultPoint).dist;
				flick(astar, ba, bd, a);
			}
			flick(astar, angle, dist, b);
		}
		
		/**
		 * 将对象弹开
		 * @param	angle	起始角度
		 * @param	x		发起起始点
		 * @param	y		发起起始点
		 * @param	h		弹开的距离
		 * @param	role	被弹开的对象
		 */
		private static function flick(astar:UpGameAStar, angle:int, dist:int, ed:EDRole):void
		{
			var x:Number = ed.x;
			var y:Number = ed.y;
			var _a:Number = angle / 180 * Math.PI;
			switch (angle) 
			{
				case 0:
					x = int(x + dist);
					break;
				case 90:
					y = int(y + dist);
					break;
				case 180:
					x = int(x - dist);
					break;
				case 270:
					y = int(y - dist);
					break;
				default:
					x = int(Math.cos(_a) * dist + x);
					y = int(Math.sin(_a) * dist + y);
			}
			//距离要慢慢使用~~>_<
			if (ed.isLive)
			{
				if (ed.status == StatusTypeRole.move || ed.status == StatusTypeRole.patrol)
				{
					ed.ai.move.stop();
				}
				if (ed.ai.skillFire)
				{
					ed.ai.skillStop();
					ed.status = StatusTypeRole.idle;
					if (ed.uiStop == false)
					{
						EDRoleToolsSkin.changeSkin(ed, ed.u.modeTurn);
					}
				}
			}
			if (AIRoleMoveTool.canLinePoint(astar, ed.x, ed.y, x, y, 1))
			{
				//role.x = x;
				//role.y = y;
				ed.ai.collision.collision(x, y);
			}
			else
			{
				//计算看看撞哪里了,反推
				var p:MPoint = AIRoleMoveTool.moveLinePoint(astar, ed.x, ed.y, angle, dist, 1);
				if (p)
				{
					//role.x = p.x;
					//role.y = p.y;
					ed.ai.collision.collision(p.x, p.y);
				}
			}
		}
	}
}