package cn.wjj.upgame.engine 
{
	import cn.wjj.upgame.common.StatusTypeRole;
	
	/**
	 * 被击飞的过程中
	 * 
	 * 有2种类型,一种是目标类型
	 * target : 移动到这个目标,达到射程就停掉
	 * point : 移动到这个坐标,到了也就停止了
	 * 
	 * @author GaGa
	 */
	public class AIRoleCollision
	{
		/** 引用 **/
		public var ed:EDRole;
		/** 起始点 **/
		private var _x:Number = 0;
		/** 起始点 **/
		private var _y:Number = 0;
		/** 目标点 **/
		private var x:int = 0;
		/** 目标点 **/
		private var y:int = 0;
		/** 起始时间 **/
		private var t:uint = 0;
		/** 飞行角度 **/
		private var r:Number = 0;
		/** 曲度 **/
		private var a:Number = 0;
		/** 距离 **/
		private var d:Number = 0;
		
		/** 击退的速度 **/
		private static const speed:int = 800;
		
		public function AIRoleCollision() { }
		
		/** 清理对象, 及里面的全部内容 **/
		public function clear():void
		{
			if (ed != null) ed = null;
		}
		
		/** 停止击退 **/
		public function stop():void { }
		
		/** 击退到固定的目标 **/
		public function collision(x:int, y:int):void
		{
			if (ed.status == StatusTypeRole.collision && this.x == x && this.y == y)
			{
				//不用执行
			}
			else
			{
				_x = ed.x - x;
				_y = ed.y - y;
				if (_x != 0 || _y != 0)
				{
					
					d = Math.sqrt(_x * _x + _y * _y);
					r = (Math.atan2(_y, _x) + Math.PI) * 180 / Math.PI;
					r = r % 360;
					if (r < 0) r += 360;
					a = r / 180 * Math.PI;
					_x = ed.x;
					_y = ed.y;
					t = ed.u.engine.time.timeGame;
					if (ed.ai.skillFire)
					{
						ed.ai.skillStop();
						ed.status = StatusTypeRole.idle;
						if (ed.uiStop == false)
						{
							EDRoleToolsSkin.changeSkin(ed, ed.u.modeTurn);
						}
					}
					ed.status = StatusTypeRole.collision;
					this.x = x;
					this.y = y;
				}
				else if(ed.status == StatusTypeRole.collision)
				{
					ed.status = StatusTypeRole.idle;
					if (ed.uiStop == false)
					{
						EDRoleToolsSkin.changeSkin(ed, ed.u.modeTurn);
					}
				}
			}
		}
		
		/** 如果在击退过程中,就执行击退过程的内容,返回是否完成 **/
		public function runFrame():Boolean
		{
			var h:Number = speed * (ed.u.engine.time.timeGame - t) / 1000;
			if (d < h)
			{
				ed.status = StatusTypeRole.idle;
				if (ed.uiStop == false)
				{
					EDRoleToolsSkin.changeSkin(ed, ed.u.modeTurn);
				}
				ed.x = x;
				ed.y = y;
				return true;
			}
			else
			{
				switch (r) 
				{
					case 0:
						ed.x = int(_x + h);
						break;
					case 90:
						ed.y = int(_y + h);
						break;
					case 180:
						ed.x = int(_x - h);
						break;
					case 270:
						ed.y = int(_y - h);
						break;
					default:
						ed.x = int(Math.cos(a) * h + _x);
						ed.y = int(Math.sin(a) * h + _y);
				}
			}
			return false;
		}
	}
}