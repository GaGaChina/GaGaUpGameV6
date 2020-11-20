package cn.wjj.upgame.tools 
{
	import cn.wjj.display.MPoint;
	import cn.wjj.upgame.common.StatusTypeRole;
	import cn.wjj.upgame.engine.AIRoleMoveTool;
	import cn.wjj.upgame.engine.EDCamp;
	import cn.wjj.upgame.engine.EDRole;
	import cn.wjj.upgame.engine.UpEngine;
	import cn.wjj.upgame.engine.UpGameAStar;
	
	/**
	 * 群体移动的工具类
	 * 
	 * @author GaGa
	 */
	public class MovePlayerTool 
	{
		public function MovePlayerTool() { }
		
		/**
		 * 返回三个坐标,是集体移动的坐标
		 * @param	engine
		 * @param	pfx
		 * @param	pfy
		 * @param	lineup	1.密集型, 2.普通型, 3.Y密集型(两个角色在前，1个角色在后), 4.一字型,2号最上面间距80
		 * @return
		 */
		public static function movePlayerList(engine:UpEngine, pfx:int, pfy:int, lineup:int = 1):Vector.<MPoint>
		{
			var astar:UpGameAStar = engine.astar;
			var gfx:int = int((pfx - astar.offsetX) / astar.tileWidth);
			var gfy:int = int((pfy - astar.offsetY) / astar.tileHeight);
			//如果目标点不可移动,先修正目标点
			if (gfx < 0 || gfy < 0 || gfx >= astar.width || gfy >= astar.height || astar.map[gfx][gfy] == 1)
			{
				var f:MPoint = AIRoleMoveTool.getRecentlyPoint(astar, pfx, pfy, 1, 25);
				if (f)
				{
					pfx = f.x;
					pfy = f.y;
					gfx = int((pfx - astar.offsetX) / astar.tileWidth);
					gfy = int((pfy - astar.offsetY) / astar.tileHeight);
				}
				else
				{
					return null;
				}
			}
			//找出3个点来
			var list:Vector.<MPoint> = new Vector.<MPoint>();
			var point:MPoint;
			for (var i:int = 0; i < 3; i++) 
			{
				point = getPoint(engine.astar, i + 1, pfx, pfy, lineup);
				list.push(point);
				//role.ai.move.movePoint(point.x, point.y, true);
			}
			if (list.length) return list;
			return null;
		}
		
		/**
		 * 获取一起移动的可移动点
		 * 
		 * @param	info	地图数据
		 * @param	type	类型(1,上面的点25像素, 2,左边的点,x-35像素,3右边的点,x+35像素)
		 * @return
		 */
		private static function getPoint(astar:UpGameAStar, type:int, x:int, y:int, lineup:int):MPoint
		{
			var tx:int, ty:int;
			var point:MPoint = MPoint.instance();
			switch (lineup) 
			{
				case 1:
					switch (type) 
					{
						case 1:
							tx = x;
							ty = y - 30;//40
							break;
						case 2:
							tx = x - 75;//50
							ty = y + 30;
							break;
						case 3:
							tx = x + 75;//50
							ty = y + 30;
							break;
					}
					break;
				case 2:
					switch (type) 
					{
						case 1:
							tx = x;
							ty = y - 75;
							break;
						case 2:
							tx = x - 88;
							ty = y + 75;
							break;
						case 3:
							tx = x + 88;
							ty = y + 75;
							break;
					}
					break;
				case 3:
					switch (type) 
					{
						case 1:
							tx = x;
							ty = y + 75;
							break;
						case 2:
							tx = x - 88;
							ty = y - 75;
							break;
						case 3:
							tx = x + 88;
							ty = y - 75;
							break;
					}
					break;
				case 4:
					switch (type) 
					{
						case 1:
							tx = x;
							ty = y - 80;
							break;
						case 2:
							tx = x;
							ty = y;
							break;
						case 3:
							tx = x;
							ty = y + 80;
							break;
					}
					break;
			}
			if (astar.isPass(tx, ty))
			{
				point.x = tx;
				point.y = ty;
				return point;
			}
			else
			{
				//找出合适移动的点
				var old:MPoint = astar.getTilePoint(x, y);
				var tile:MPoint = astar.getTilePoint(tx, ty);
				while (true)
				{
					switch (type)
					{
						case 1:
							tile.y = tile.y + 1;
							ty = tile.y * astar.tileHeight + astar.offsetY;
							break;
						case 2:
							tile.x = tile.x + 1;
							tx = tile.x * astar.tileWidth + astar.offsetX;
							break;
						case 3:
							tile.x = tile.x - 1;
							tx = tile.x * astar.tileWidth + astar.offsetX + astar.tileWidth - 1;
							break;
					}
					if (astar.isPassGrid(tile.x, tile.y))
					{
						point.x = tx;
						point.y = ty;
						return point;
					}
					else
					{
						switch (type)
						{
							case 1:
								if (ty > y)
								{
									point.x = x;
									point.y = old.y * astar.tileHeight + astar.offsetY;
									return point;
								}
								break;
							case 2:
								if (tx > x)
								{
									point.x = old.x * astar.tileWidth + astar.offsetX;
									point.y = y;
									return point;
								}
								break;
							case 3:
								if (tx < x)
								{
									point.x = old.x * astar.tileWidth + astar.offsetX + astar.tileWidth - 1;
									point.y = y;
									return point;
								}
								break;
						}
					}
				}
				return point;
			}
			point.x = x;
			point.y = y;
			return point;
		}
		
		/** 停止多对象移动 **/
		public static function movePlayerStop(engine:UpEngine):void
		{
			if (engine.campLib)
			{
				var role:EDRole;
				for each (var camp:EDCamp in engine.campLib)
				{
					if (camp.lengthRole)
					{
						for each (role in camp.listRole)
						{
							if (role.isLive && role.status == StatusTypeRole.move)
							{
								role.ai.move.stop();
							}
						}
					}
				}
			}
		}
	}
}