package cn.wjj.upgame.tools 
{
	import cn.wjj.g;
	import cn.wjj.display.MPoint;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.upgame.data.CardInfoModel;
	import cn.wjj.upgame.data.RoleCardModel;
	import cn.wjj.upgame.data.UpGameData;
	import cn.wjj.upgame.engine.AIRoleMoveTool;
	import cn.wjj.upgame.engine.UpGameAStar;

	/**
	 * 召唤数量和位置之间的关系
	 * @author GaGa
	 */
	public class ReleaseCardMPoint 
	{
		
		public function ReleaseCardMPoint() { }
		
		/**
		 * 根据要获取的点的数量,来获取不同的坐标
		 * 需要获取到卡牌的类型,来修正坐标的中心点
		 * @param	astar
		 * @param	card
		 * @param	camp	阵营
		 * @param	x		(像素)中心点坐标
		 * @param	y		(像素)中心点坐标
		 * @return
		 */
		public static function getPoint(astar:UpGameAStar, card:CardInfoModel, camp:int, x:int, y:int):Vector.<MPoint>
		{
			var typeProperty:int = 0;
			switch (card.CardType) 
			{
				case 1://部队
					var role:RoleCardModel = UpGameData.cardRole.getItem("card_id", card.SummonCharacter);
					if (role)
					{
						if (role.FlyingHeight == 0)
						{
							typeProperty = 1;
						}
						else
						{
							typeProperty = 2;
						}
					}
					else
					{
						typeProperty = 1;
					}
					break;
				case 2://法术
					break;
				case 3://建筑
					typeProperty = 3;
					break;
				case 4://主塔,副塔
					break;
			}
			var p:MPoint = revisePoint(astar, x, y, typeProperty);
			switch (card.SummonNumber) 
			{
				case 2:
					return getPoint2(astar, camp, p.x, p.y);
					break;
				case 3:
					return getPoint3(astar, camp, p.x, p.y);
					break;
				case 4:
					return getPoint4(astar, camp, p.x, p.y);
					break;
				case 6:
					return getPoint6(astar, camp, p.x, p.y);
					break;
				default:
					return getPointX(astar, camp, p.x, p.y, card.SummonNumber);
					//return getPointRX(astar, p.x, p.y, card.SummonNumber);
			}
			return null;
		}
		
		/**
		 * 
		 * @param	num		获取点数量
		 * @param	range	范围大小
		 * @param	x		中心点坐标
		 * @param	y		中心点坐标
		 * @return
		 */
		public static function getRangePoint(num:int, range:int, x:int, y:int):Vector.<MPoint>
		{
			return null;
		}
		
		/**
		 * 把要移动的位置预先处理到可以移动的位置
		 * @param	astar
		 * @param	x
		 * @param	y
		 * @param	typeProperty	移动主体(0 未知, 1 陆地, 2 空中, 3 建筑)
		 * @return
		 */
		private static function revisePoint(astar:UpGameAStar, x:int, y:int, typeProperty:int = 0):MPoint
		{
			var gfx:int = int((x - astar.offsetX) / astar.tileWidth);
			var gfy:int = int((y - astar.offsetY) / astar.tileHeight);
			//如果目标点不可移动,先修正目标点
			if (gfx < 0 || gfy < 0 || gfx >= astar.width || gfy >= astar.height || (typeProperty != 2 && astar.map[gfx][gfy] == 1))
			{
				g.log.pushLog(ReleaseCardMPoint, LogType._ErrorLog, "玩家可能BUG了,否则不可能出现本情况");
				var f:MPoint = AIRoleMoveTool.getRecentlyPoint(astar, x, y, 1, 25, typeProperty);
				if (f)
				{
					x = f.x;
					y = f.y;
					return MPoint.instance(x, y);
				}
				return null;
			}
			return MPoint.instance(x, y);
		}
		
		
		/**
		 * 检查坐标是否可以行走
		 * @param	astar
		 * @param	point
		 * @param	type	方位1左上,2右上,3左下,4右下
		 * @return
		 */
		private static function checkPoint(astar:UpGameAStar, point:MPoint, type:int):MPoint
		{
			return point;
			if (astar.isPass(point.x, point.y))
			{
				return point;
			}
			else
			{
				var tx:int;
				var ty:int;
				var x:int = point.x;
				var y:int = point.y;
				
				//找出合适移动的点
				var old:MPoint = astar.getTilePoint(point.x, point.y);
				var tile:MPoint = MPoint.instance(old.x, old.y);
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
						case 4:
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
			return point;
		}
		
		private static function getPoint2(astar:UpGameAStar, camp:int, x:int, y:int):Vector.<MPoint>
		{
			var list:Vector.<MPoint> = new Vector.<MPoint>();
			var point:MPoint;
			
			if (camp == 1)
			{
				point = MPoint.instance();
				point.x = x - 20;
				point.y = y;
				list.push(point);
				
				point = MPoint.instance();
				point.x = x + 20;
				point.y = y;
				list.push(point);
			}
			else
			{
				point = MPoint.instance();
				point.x = x + 20;
				point.y = y;
				list.push(point);
				
				point = MPoint.instance();
				point.x = x - 20;
				point.y = y;
				list.push(point);
			}
			return list;
		}
		
		private static function getPoint3(astar:UpGameAStar, camp:int, x:int, y:int):Vector.<MPoint>
		{
			var list:Vector.<MPoint> = new Vector.<MPoint>();
			var point:MPoint;
			if (camp == 1)
			{
				point = MPoint.instance();
				point.x = x;
				point.y = y - 10;
				list.push(point);
				
				point = MPoint.instance();
				point.x = x - 20;
				point.y = y + 10;
				list.push(point);
				
				point = MPoint.instance();
				point.x = x + 20;
				point.y = y + 10;
				list.push(point);
			}
			else
			{
				point = MPoint.instance();
				point.x = x;
				point.y = y + 10;
				list.push(point);
				
				point = MPoint.instance();
				point.x = x + 20;
				point.y = y - 10;
				list.push(point);
				
				point = MPoint.instance();
				point.x = x - 20;
				point.y = y - 10;
				list.push(point);
			}
			return list;
		}
		
		private static function getPoint4(astar:UpGameAStar, camp:int, x:int, y:int):Vector.<MPoint>
		{
			var list:Vector.<MPoint> = new Vector.<MPoint>();
			var point:MPoint;
			
			if (camp == 1)
			{
				point = MPoint.instance();
				point.x = x - 20;
				point.y = y - 20;
				list.push(point);
				
				point = MPoint.instance();
				point.x = x + 20;
				point.y = y - 20;
				list.push(point);
				
				point = MPoint.instance();
				point.x = x - 20;
				point.y = y + 20;
				list.push(point);
				
				point = MPoint.instance();
				point.x = x + 20;
				point.y = y + 20;
				list.push(point);
			}
			else
			{
				point = MPoint.instance();
				point.x = x + 20;
				point.y = y + 20;
				list.push(point);
				
				point = MPoint.instance();
				point.x = x - 20;
				point.y = y + 20;
				list.push(point);
				
				point = MPoint.instance();
				point.x = x + 20;
				point.y = y - 20;
				list.push(point);
				
				point = MPoint.instance();
				point.x = x - 20;
				point.y = y - 20;
				list.push(point);
			}
			return list;
		}
		
		private static function getPoint6(astar:UpGameAStar, camp:int, x:int, y:int):Vector.<MPoint>
		{
			var list:Vector.<MPoint> = new Vector.<MPoint>();
			var point:MPoint;
			
			if (camp == 1)
			{
				point = MPoint.instance();
				point.x = x - 15;
				point.y = y - 25;
				list.push(point);
				
				point = MPoint.instance();
				point.x = x + 15;
				point.y = y - 25;
				list.push(point);
				
				point = MPoint.instance();
				point.x = x - 30;
				point.y = y;
				list.push(point);
				
				point = MPoint.instance();
				point.x = x + 30;
				point.y = y;
				list.push(point);
				
				point = MPoint.instance();
				point.x = x - 15;
				point.y = y + 25;
				list.push(point);
				
				point = MPoint.instance();
				point.x = x + 15;
				point.y = y + 25;
				list.push(point);
			}
			else
			{
				point = MPoint.instance();
				point.x = x + 15;
				point.y = y + 25;
				list.push(point);
				
				point = MPoint.instance();
				point.x = x - 15;
				point.y = y + 25;
				list.push(point);
				
				point = MPoint.instance();
				point.x = x + 30;
				point.y = y;
				list.push(point);
				
				point = MPoint.instance();
				point.x = x - 30;
				point.y = y;
				list.push(point);
				
				point = MPoint.instance();
				point.x = x + 15;
				point.y = y - 25;
				list.push(point);
				
				point = MPoint.instance();
				point.x = x - 15;
				point.y = y - 25;
				list.push(point);
			}
			return list;
		}
		
		/** 骷髅兵的座位 **/
		private static function getPoint20(astar:UpGameAStar, x:int, y:int):Vector.<MPoint>
		{
			return null;
		}
		
		/**
		 * 按照要刷出的数量来分配刷多个人物
		 * @param	astar
		 * @param	x
		 * @param	y			像素位置
		 * @param	num			要找到多少个点
		 * @return
		 */
		private static function getPointX(astar:UpGameAStar, camp:int, x:int, y:int, num:int):Vector.<MPoint>
		{
			var list:Vector.<MPoint> = new Vector.<MPoint>();
			var point:MPoint;
			var lengthX:int = int(Math.sqrt(num));
			var lengthY:int = Math.ceil(num / lengthX);
			//偏移的坐标
			var ox:int = (lengthX - 1) * 30;
			if (ox)
			{
				if (camp == 1)
				{
					ox = int( -ox / 2);
				}
				else
				{
					ox = int( ox / 2);
				}
			}
			var oy:int = (lengthY - 1) * 30;
			if (oy)
			{
				if (camp == 1)
				{
					oy = int( -oy / 2);
				}
				else
				{
					oy = int( oy / 2);
				}
			}
			//修正四个角的边界
			if ((ox + x) < astar.hotStartX)
			{
				ox = astar.hotStartX - x;
			}
			else if (((lengthX - 1) * 30 + ox + x) >= astar.hotEndX)
			{
				ox = astar.hotEndX - ((lengthX - 1) * 30) - x;
			}
			if ((oy + y) < astar.hotStartY)
			{
				oy = astar.hotStartY - y;
			}
			else if (((lengthY - 1) * 30 + oy + y) >= astar.hotEndY)
			{
				oy = astar.hotEndY - ((lengthY - 1) * 30) - y;
			}
			var _x:int, _y:int;
			var length:int = 0;
			for (_y = 0; _y < lengthY; _y++) 
			{
				for (_x = 0; _x < lengthX; _x++) 
				{
					point = MPoint.instance();
					if (camp == 1)
					{
						point.x = x + _x * 30 + ox;
						point.y = y + _y * 30 + oy;
					}
					else
					{
						point.x = x - _x * 30 + ox;
						point.y = y - _y * 30 + oy;
					}
					list.push(point);
					length++;
					if (length >= num)
					{
						break;
					}
				}
			}
			return list;
		}
		
		/**
		 * 获取圆形的区域
		 * @param	astar		A星
		 * @param	x			像素坐标
		 * @param	y			像素坐标
		 * @param	num			总共多少人
		 * @param	numStart	起始圈的数量
		 * @param	numAdd		每圈增加数量
		 * @param	range		每圈增加距离
		 * @return
		 */
		private static function getPointRX(astar:UpGameAStar, x:int, y:int, num:int, numStart:int = 4, numAdd:int = 4, range:int = 20):Vector.<MPoint>
		{
			var list:Vector.<MPoint> = new Vector.<MPoint>();
			var point:MPoint;
			//算出总共的圈数
			var circle:int = 1;
			var numCircle:int = numStart;
			var numMax:int = numStart;
			while (numMax < num)
			{
				circle++;
				numCircle += numAdd;
				numMax += numCircle;
			}
			//偏移的坐标
			var ox:int = -circle * range;
			var oy:int = ox;
			//修正四个角的边界
			if ((ox + x) < astar.hotStartX)
			{
				ox = astar.hotStartX - x;
			}
			else if ((x - ox) >= astar.hotEndX)
			{
				ox = x - astar.hotEndX;
			}
			if ((oy + y) < astar.hotStartY)
			{
				oy = astar.hotStartY - y;
			}
			else if ((y - oy) >= astar.hotEndY)
			{
				oy = y - astar.hotEndY;
			}
			//本圈的数量
			var theCircleNum:int = 0;
			//没圈中,间隔增加的角度
			var circleAddAngle:Number = 0;
			var j:int, angle:Number, angleTemp:Number;
			var distRange:int = 0;
			for (var i:int = 1; i <= circle; i++)
			{
				distRange += range;
				if (i == 1)
				{
					//第一圈
					if (num < numStart)
					{
						numCircle = num;
						numMax = numCircle;
						theCircleNum = numMax;
					}
					else
					{
						numCircle = numStart;
						numMax = numCircle;
						theCircleNum = numMax;
					}
				}
				else if (i == circle)
				{
					//最后一圈
					theCircleNum = num - numMax;
				}
				else
				{
					//开始累加
					numCircle += numAdd;
					numMax += numCircle;
					theCircleNum = numCircle;
				}
				angle = 0;
				circleAddAngle = 360 / theCircleNum;
				for (j = 0; j < theCircleNum; j++) 
				{
					angle = j * circleAddAngle;
					//计算出坐标
					point = MPoint.instance();
					angleTemp = angle / 180 * Math.PI;
					point.x = int(Math.cos(angleTemp) * distRange + x + ox);
					point.y = int(Math.sin(angleTemp) * distRange + y + oy);
					list.push(point);
				}
			}
			//开始调整坐标顺序
			return list;
		}
	}

}