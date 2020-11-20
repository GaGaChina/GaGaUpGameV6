package cn.wjj.upgame.tools 
{
	import cn.wjj.upgame.engine.EDRole;
	import cn.wjj.upgame.engine.UpGameAStar;
	import flash.geom.Rectangle;
	
	/**
	 * 计算连线的区域是否和区域产生碰撞
	 * @author GaGa
	 */
	public class LineInRect
	{
		private static var radian:Number;
		private static var hitX:Number;
		
		public function LineInRect() { }
		
		/**
		 * 地图上现成的不可移动区域,如果撞上,先移动这些区域
		 * true  : 和阻挡区发生了碰撞
		 * false : 非发生碰撞
		 * @return	返回现在应该去那个坐标
		 */
		public static function pointLine(astar:UpGameAStar, x1:int, y1:int, target:EDRole, range:int):Boolean
		{
			
			var x2:Number = target.x + target.hit_r_x;
			var y2:Number = target.y + target.hit_r_y;
			if (target.hit_h)
			{
				x2 = target.hit_r / 2 + x2;
				y2 = target.hit_h / 2 + y2;
			}
			for each (var r:Rectangle in astar.moveOther) 
			{
				if (LineInRect.runPoint(x1, y1, x2, y2, range, r))
				{
					return true;
				}
			}
			for each (r in astar.moveAll) 
			{
				if (target.info.sizeRect == r)
				{
					continue;
				}
				if (LineInRect.runPoint(x1, y1, x2, y2, range, r))
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 2点连线是否在区域内
		 * true  : 和阻挡区发生了碰撞
		 * false : 连线未和阻挡区碰撞,或者可以站在边缘攻击
		 * @param	x1		发起方位置
		 * @param	y1		发起方位置
		 * @param	x2		发起方位置
		 * @param	y2		发起方位置
		 * @param	range	射程
		 * @param	r
		 * @return
		 */
		public static function runPoint(x1:int, y1:int, x2:int, y2:int, range:int, r:Rectangle):Boolean
		{
			if (x1 < r.x && x2 < r.x)//2个点的X坐标都在区域左侧
			{
				return false;
			}
			else if (x1 > r.right && x2 > r.right)//2个点的X坐标都在区域右侧
			{
				return false;
			}
			else if (y1 < r.y && y2 < r.y)//2个点的Y坐标都在区域上方
			{
				return false;
			}
			else if (y1 > r.bottom && y2 > r.bottom)//2个点的Y坐标都在区域下方
			{
				return false;
			}
			else
			{
				//找出弧度
				radian = Math.atan2(y1 - y2, x1 - x2);
				radian = Math.tan(radian);
				hitX = (r.y - y1) / radian + x1;
				if (hitX < r.x && hitX > r.right)
				{
					return false;
				}
				else
				{
					hitX = (r.bottom - y1) / radian + x1;
					if (hitX < r.x && hitX > r.right)
					{
						return false;
					}
					else
					{
						return true;
					}
				}
			}
			return false;
		}
	}
}