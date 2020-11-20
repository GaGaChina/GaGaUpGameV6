package cn.wjj.upgame.engine 
{
	import cn.wjj.g;
	import cn.wjj.display.MPoint;
	import cn.wjj.tool.MathTools;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 人物移动的静态方法
	 * 
	 * @author GaGa
	 */
	public class AIRoleMoveTool
	{
		
		/** 临时MPoint变量 **/
		private static var _p:MPoint;
		
		public function AIRoleMoveTool() { }
		
		/**
		 * 找到路径,直接操作 role 里的移动路径参数
		 * @param	u
		 * @param	role			移动的目标
		 * @param	pfx				(像素)目标坐标点
		 * @param	pfy				(像素)目标坐标点
		 * @param	sBlock			不可通行表示法
		 * @param	diagAble		是否可以走斜线
		 */
		public static function findPoint(u:UpGame, role:EDRole, path:Vector.<AIRoleMovePoint>, pfx:int, pfy:int, sBlock:Object, diagAble:Boolean = true):void
		{
			var astar:UpGameAStar = u.engine.astar;
			if (role.x != pfx || role.y != pfy)
			{
				var p:AIRoleMovePoint;
				//清理地图数据
				if (path.length)
				{
					for each (p in path)
					{
						p.dispose();
					}
					path.length = 0;
				}
				//人物现在在的格子
				var gsx:int = int((role.x - astar.offsetX) / astar.tileWidth);
				var gsy:int = int((role.y - astar.offsetY) / astar.tileHeight);
				//目标点
				var gfx:int = int((pfx - astar.offsetX) / astar.tileWidth);
				var gfy:int = int((pfy - astar.offsetY) / astar.tileHeight);
				//如果目标点不可移动,先修正目标点
				if (gfx < 0 || gfy < 0 || gfx >= astar.width || gfy >= astar.height || astar.map[gfx][gfy] == sBlock)
				{
					_p = getRecentlyPoint(astar, pfx, pfy, sBlock, 25, role.info.typeProperty);
					if (_p)
					{
						pfx = _p.x;
						pfy = _p.y;
						gfx = int((pfx - astar.offsetX) / astar.tileWidth);
						gfy = int((pfy - astar.offsetY) / astar.tileHeight);
					}
					else
					{
						return;
					}
				}
				//站在不能走的地方,先移动出来
				//范围太夸张就先移动到最近的地方,然后在找
				if(gsx < 0)
				{
					gsx = 0;
				}
				else if(gsx >= astar.width)
				{
					gsx = astar.width - 1;
				}
				if(gsy < 0)
				{
					gsy = 0;
				}
				else if(gsy >= astar.height)
				{
					gsy = astar.height - 1;
				}
				//看下是否先要去可以移动的点上去
				var blank:AIRoleMovePoint;
				if (astar.map[gsx][gsy] == sBlock)
				{
					blank = gotoBlank(astar, role, gsx, gsy, sBlock, pfx, pfy);
					if (blank == null)
					{
						return;
					}
					else
					{
						gsx = int((blank.x - astar.offsetX) / astar.tileWidth);
						gsy = int((blank.y - astar.offsetY) / astar.tileHeight);
					}
				}
				if (gsx == gfx && gsy == gfy)
				{
					path.push(AIRoleMovePoint.instance(pfx, pfy));
					if (blank)
					{
						path.push(blank);
						setPointInfo(role , null, blank);
						setPointInfo(role , blank, path[1]);
					}
					else
					{
						setPointInfo(role , null, path[0]);
					}
				}
				else if(role.info.typeProperty == 2 || canLinePoint(astar, role.x, role.y, pfx, pfy, sBlock, diagAble))
				{
					path.push(AIRoleMovePoint.instance(pfx, pfy));
					if (blank)
					{
						path.push(blank);
						setPointInfo(role , null, blank);
						setPointInfo(role , blank, path[1]);
					}
					else
					{
						setPointInfo(role , null, path[0]);
					}
				}
				else
				{
					var close:Array = u.engine.astar.pathfinding(sBlock, gsx, gsy, gfx, gfy, diagAble);
					if (close)
					{
						//标识上一个点是否是个斜角
						//老的方向,0,初始化, 1横向移动, 2纵向操作,(斜线操作)左上 3 右上 4 右下 5 左下 6
						var oldR:int = 0;
						//新的方向,0,初始化, 1横向移动, 2纵向操作,(斜线操作)左上 3 右上 4 右下 5 左下 6
						var newR:int = 0;
						var ax:Number = astar.tileWidth / 2 + astar.offsetX;
						var ay:Number = astar.tileHeight / 2 + astar.offsetY;
						var p1:AIRoleMovePoint = AIRoleMovePoint.instance(pfx, pfy);
						var p2:AIRoleMovePoint;
						var p3:AIRoleMovePoint;
						path.push(p1);
						var i:int = close.length - 4;
						//上一个点
						var cx:int = close[i];
						var cy:int = close[i + 1];
						p1 = AIRoleMovePoint.instance(cx * astar.tileWidth + ax, cy * astar.tileHeight + ay);
						path.push(p1);
						var x:int = cx;
						var y:int = cy;
						var pl:int = 2;
						while (i > 0)
						{
							cx = close[i + 2];
							cy = close[i + 3];
							if (cx == x)
							{
								newR = 1;
							}
							else if (cy == y)
							{
								newR = 2;
							}
							else if (cy > y)//上方
							{
								if (cx < x)//左
								{
									newR = 3;
								}
								else
								{
									newR = 4;
								}
							}
							else//下方
							{
								if (cx < x)//左
								{
									newR = 6;
								}
								else
								{
									newR = 5;
								}
							}
							if (newR == oldR)
							{
								if (x != cx)
								{
									x = cx;
									p1.x = x * astar.tileWidth + ax;
								}
								if (y != cy)
								{
									y = cy;
									p1.y = y * astar.tileWidth + ay;
								}
							}
							else
							{
								oldR = newR;
								x = cx;
								y = cy;
								p1 = AIRoleMovePoint.instance(x * astar.tileWidth + ax, y * astar.tileHeight + ay);
								path.push(p1);
								pl++;
							}
							for (i -= 4; i >= 0; i -= 4)
							{
								if (close[i] == cx && close[i + 1] == cy)
								{
									break;
								}
							}
						}
						if (blank)
						{
							path.push(blank);
							pl++;
						}
						while (--pl > -1)
						{
							p3 = path[pl];
							//p1 和 p3 是否可以连起来
							if (p1 && p2 && p2 != blank && canLinePoint(astar, p1.x, p1.y, p3.x, p3.y, sBlock, diagAble))
							{
								setPointInfo(role, p1, p3);
								p2 = p3;
								path.splice(pl + 1, 1);
							}
							else
							{
								setPointInfo(role, p2, p3);
								p1 = p2;
								p2 = p3;
							}
						}
					}
				}
			}
		}
		
		/**
		 * 将对象移动到一个可以移动的区域内
		 * 返回一个可以通行的点
		 * @param	astar
		 * @param	role
		 * @param	gsx			格子的ID号
		 * @param	gsy			格子的ID号
		 * @param	pfx			目标点的像素点
		 * @param	pfy			目标点的像素点
		 * @param	sBlock
		 */
		public static function gotoBlank(astar:UpGameAStar, role:EDRole, gsx:int, gsy:int, sBlock:Object, pfx:int, pfy:int):AIRoleMovePoint
		{
			//找到最近的行走点,先走过来
			var x:int, y:int, list:Array;
			for (var range:int = 1; range < 30; range++) 
			{
				list = getAroundList(astar, gsx, gsy, sBlock, range, false);
				if (list)
				{
					x = list[0] * astar.tileWidth + astar.offsetX;
					y = list[1] * astar.tileHeight + astar.offsetY;
					if (x < pfx)
					{
						if ((astar.tileWidth + x - 1) < pfx)
						{
							x = astar.tileWidth + x - 1;
						}
						else
						{
							x = pfx;
						}
					}
					if (y < pfy)
					{
						if ((astar.tileHeight + y - 1) < pfy)
						{
							y = astar.tileHeight + y - 1;
						}
						else
						{
							y = pfy;
						}
					}
					g.speedFact.d_array(list);
					return AIRoleMovePoint.instance(x, y);
				}
			}
			return null;
		}
		
		/**
		 * 将对象移动到一个可以移动的区域内
		 * 返回一个可以通行的点
		 * @param	astar
		 * @param	gsx			格子的ID号
		 * @param	gsy			格子的ID号
		 * @param	sBlock
		 */
		public static function gotoBlankGrid(astar:UpGameAStar, gsx:int, gsy:int, sBlock:Object):AIRoleMovePoint
		{
			//找到最近的行走点,先走过来
			var list:Array;
			var p:AIRoleMovePoint
			for (var range:int = 1; range < 30; range++)
			{
				list = getAroundList(astar, gsx, gsy, sBlock, range, false);
				if (list)
				{
					p = AIRoleMovePoint.instance(list[0], list[1]);
					g.speedFact.d_array(list);
					return p;
				}
			}
			return null;
		}
		
		/**
		 * 返回一个将要去的坐标,如果坐标不能通行,将找到直径上最近的一个可通过点
		 * 
		 * 根据移动的主体现在的位置来决定要去那个点比较近,否则不知道那个近
		 * 
		 * @param	astar
		 * @param	tx				[像素]目标坐标
		 * @param	ty				[像素]目标坐标
		 * @param	sBlock			不可通行表示法
		 * @param	maxRange		遍历周边多少个位置
		 * @param	typeProperty	移动主体(0 未知, 1 陆地, 2 空中, 3 建筑)
		 * @return					[map实际坐标]转换后的要去的坐标
		 */
		public static function getRecentlyPoint(s:UpGameAStar, tx:int, ty:int, sBlock:Object, maxRange:int, typeProperty:int = 0):MPoint
		{
			_p = MPoint.instance();
			var x:int = int((tx - s.offsetX) / s.tileWidth);
			var y:int = int((ty - s.offsetY) / s.tileHeight);
			if (x < 0)
			{
				x = 0;
				tx = s.offsetX;
			}
			else if (x >= s.width)
			{
				x = s.width - 1;
				tx = x * s.tileWidth + s.offsetX + s.tileWidth - 1;
			}
			if (y < 0)
			{
				y = 0;
				ty = s.offsetY;
			}
			else if (y >= s.height)
			{
				y = s.height - 1;
				ty = y * s.tileHeight + s.offsetY + s.tileHeight - 1;
			}
			if (typeProperty != 2 && s.map[x][y] == sBlock)
			{
				var list:Array;
				for (var range:int = 1; range < maxRange; range++) 
				{
					list = getAroundList(s, x, y, sBlock, range, false);
					if (list)
					{
						_p.x = list[0] * s.tileWidth + int(s.tileWidth / 2) + s.offsetX;
						_p.y = list[1] * s.tileHeight + int(s.tileHeight / 2) + s.offsetY;
						//这里有错误,不能使用距离不能走的点最近的,要距离人物最近的地方,这样才是最近
						if(_p.x < tx)
						{
							_p.x = s.tileWidth + _p.x - 1;
						}
						if(_p.y < ty)
						{
							_p.y = s.tileHeight + _p.y - 1;
						}
						g.speedFact.d_array(list);
						return _p;
					}
				}
				return null;
			}
			else
			{
				_p.x = tx;
				_p.y = ty;
			}
			return _p;
		}
		
		/**
		 * 获取周围的可行走点的列表
		 * 连续数组, [0],[1] 2位组成一个坐标
		 * @param	astar		A星数据
		 * @param	x			格子的ID号
		 * @param	y			格子的ID号
		 * @param	sBlock		不可通行表示法
		 * @param	range		周边多大的格子范围
		 * @param	outList		返回一个true列表,还是一个false点
		 * @return
		 */
		public static function getAroundList(s:UpGameAStar, x:int, y:int, sBlock:Object, range:uint, outList:Boolean):Array
		{
			var a:Array, i:int;
			if (range == 0)
			{
				if (x > -1 && y > -1 && x < s.width && y < s.height && s.map[x][y] != sBlock)
				{
					if (a == null) a = g.speedFact.n_array();
					a.push(rx);
					a.push(ry);
					if (outList == false) return a;
				}
			}
			else
			{
				//4个顶点
				var rx:int, ry:int;
				rx = x - range;
				ry = y - range;
				if (rx > -1 && ry > -1 && rx < s.width && ry < s.height && s.map[rx][ry] != sBlock)
				{
					if (a == null) a = g.speedFact.n_array();
					a.push(rx);
					a.push(ry);
					if (outList == false) return a;
				}
				rx = x + range;
				if (rx > -1 && ry > -1 && rx < s.width && ry < s.height && s.map[rx][ry] != sBlock)
				{
					if (a == null) a = g.speedFact.n_array();
					a.push(rx);
					a.push(ry);
					if (outList == false) return a;
				}
				ry = y + range;
				if (rx > -1 && ry > -1 && rx < s.width && ry < s.height && s.map[rx][ry] != sBlock)
				{
					if (a == null) a = g.speedFact.n_array();
					a.push(rx);
					a.push(ry);
					if (outList == false) return a;
				}
				rx = x - range;
				if (rx > -1 && ry > -1 && rx < s.width && ry < s.height && s.map[rx][ry] != sBlock)
				{
					if (a == null) a = g.speedFact.n_array();
					a.push(rx);
					a.push(ry);
					if (outList == false) return a;
				}
				//y固定2个值,然后改变x的值
				//上面一排的内容
				if (i != 0) i = 0;
				ry = y - range;
				while (i < range)
				{
					i++;
					rx = x - range + i;
					if (rx > -1 && ry > -1 && rx < s.width && ry < s.height && s.map[rx][ry] != sBlock)
					{
						if (a == null) a = g.speedFact.n_array();
						a.push(rx);
						a.push(ry);
						if (outList == false) return a;
					}
				}
				//右面一排
				if (i != 0) i = 0;
				rx = x + range;
				while (i < range)
				{
					i++;
					ry = y - range + i;
					if (rx > -1 && ry > -1 && rx < s.width && ry < s.height && s.map[rx][ry] != sBlock)
					{
						if (a == null) a = g.speedFact.n_array();
						a.push(rx);
						a.push(ry);
						if (outList == false) return a;
					}
				}
				//下面一排
				if (i != range) i = range;
				ry = y + range;
				while (i > 0)
				{
					rx = x - range + i;
					if (rx > -1 && ry > -1 && rx < s.width && ry < s.height && s.map[rx][ry] != sBlock)
					{
						if (a == null) a = g.speedFact.n_array();
						a.push(rx);
						a.push(ry);
						if (outList == false) return a;
					}
					i--;
				}
				//左面一排
				if (i != range) i = range;
				rx = x - range;
				while (i > 0)
				{
					ry = y - range + i;
					if (rx > -1 && ry > -1 && rx < s.width && ry < s.height && s.map[rx][ry] != sBlock)
					{
						if (a == null) a = g.speedFact.n_array();
						a.push(rx);
						a.push(ry);
						if (outList == false) return a;
					}
					i--;
				}
			}
			return a;
			/*
			var a:Array;
			var rw:int = x - range;
			var rh:int = y - range;
			var rx:int, ry:int;
			for (rx = x + range; rx >= rw; rx--)
			{
				for (ry = y + range; ry >= rh; ry--)
				{
					if (rx != x || ry != y)
					{
						if (rx > -1 && ry > -1 && rx < s.width && ry < s.height && s.map[rx][ry] != sBlock)
						{
							if (a == null) a = g.speedFact.n_array();
							a.push(rx);
							a.push(ry);
							if (outList == false) return a;
						}
					}
				}
			}
			return a;
			*/
		}
		
		/** 临时变量:斜边 **/
		private static var c:Number;
		/** 临时变量:取整 **/
		private static var n:Number;
		
		/**
		 * 获取射程内最近的一个行走目标点
		 * @param	astar
		 * @param	startX		地图实际坐标
		 * @param	startY		地图实际坐标
		 * @param	endX		地图实际坐标
		 * @param	endY		地图实际坐标
		 * @param	sBlock		不可通行表示法
		 * @param	range		射程
		 * @return
		 */
		public static function hitTargetPoint(s:UpGameAStar, startX:int, startY:int, endX:int, endY:int, dist:Number, range:int, sBlock:Object):MPoint
		{
			//找出角度
			var x:int = startX - endX;
			var y:int = startY - endY;
			var a:Number = Math.atan2(y, x);
			var aSin:Number = Math.sin(a);
			var aCos:Number = Math.cos(a);
			var gfx:int, gfy:int;
			while (true)
			{
				c = dist - range;
				if (x < 0)
				{
					x = int(-aCos * c + startX);
				}
				else
				{
					n = -aCos * c + startX;
					if (n < 0)
					{
						x = Math.floor(n);
					}
					else
					{
						x = Math.ceil(n);
					}
				}
				if (y < 0)
				{
					y = int(-aSin * c + startY);
				}
				else
				{
					n = -aSin * c + startY;
					if (n < 0)
					{
						x = Math.floor(n);
					}
					else
					{
						x = Math.ceil(n);
					}
				}
				gfx = int((x - s.offsetX) / s.tileWidth);
				gfy = int((y - s.offsetY) / s.tileHeight);
				//检查新的刨除距离坐标点是否可以移动上去
				if (gfx < 0 || gfy < 0 || gfx >= s.width || gfy >= s.height || s.map[gfx][gfy] == sBlock)
				{
					range = range - s.tileWidth;
					if (range < 0)
					{
						break;
					}
				}
				else
				{
					endX = x;
					endY = y;
					break;
				}
			}
			return MPoint.instance(endX, endY);
		}
		
		/**
		 * 查看是否可以连成一条直线
		 * @param	astar
		 * @param	startX		地图实际坐标
		 * @param	startY		地图实际坐标
		 * @param	endX		地图实际坐标
		 * @param	endY		地图实际坐标
		 * @param	sBlock		不可通行表示法
		 * @param	diagAble	(没有用)是否可以走斜线
		 * @return
		 */
		public static function canLinePoint(astar:UpGameAStar, startX:int, startY:int, endX:int, endY:int, sBlock:Object, diagAble:Boolean = true):Boolean
		{
			//找出角度
			var x:int = startX - endX;
			var y:int = startY - endY;
			//a = y / x;
			var a:Number = Math.atan2(y, x);
			var aTan:Number = Math.tan(a);
			//实际的角度
			//g.log.pushLog(AIRoleMoveTool, LogType._UserAction, "开始坐标 : " + startX + ":" + startY + " 结束坐标 : " + endX + ":" + endY + " 角度 : " + r);
			//要叠加算出距离
			var gfx:int = int((endX - astar.offsetX) / astar.tileWidth);
			var gfy:int = int((endY - astar.offsetY) / astar.tileHeight);
			//[斜线不能通过]如果是属于顶点,算出下个点所经过的格子,然后判断,2边的格子,判断是否可以通过
			//换算出每个点,递归x和递归y,判断是经过的格子
			//找到下个点的坐标,就可以运算出要通过的格子
			var gsx:int = int((startX - astar.offsetX) / astar.tileWidth);
			var gsy:int = int((startY - astar.offsetY) / astar.tileHeight);
			var gid:int;//格子坐标
			// x = gsx * astar.tileWidth + astar.offsetX - startX;
			// y = gsy * astar.tileHeight + astar.offsetY - startY;
			var ax:Number = astar.offsetX - startX;
			var ay:Number = astar.offsetY - startY;
			while (gsx != gfx)
			{
				if (gsx < gfx)
				{
					gsx++;
				}
				else
				{
					gsx--;
				}
				gid = int((aTan * (gsx * astar.tileWidth + ax) - ay) / astar.tileHeight);
				if (gsx < 0 || gid < 0 || gsx >= astar.width || gid >= astar.height || astar.map[gsx][gid] == sBlock || ((gsx - 1) > -1 && astar.map[(gsx - 1)][gid] == sBlock))
				{
					return false;
				}
			}
			while (gsy != gfy)
			{
				if (gsy < gfy)
				{
					gsy++;
				}
				else
				{
					gsy--;
				}
				gid = int(((gsy * astar.tileHeight + ay) / aTan - ax) / astar.tileWidth);
				if (gid < 0 || gsy < 0 || gid >= astar.width || gsy >= astar.height || astar.map[gid][gsy] == sBlock || ((gsy - 1) > -1 && astar.map[gid][(gsy - 1)] == sBlock))
				{
					return false;
				}
			}
			return true;
		}
		
		/**
		 * 获取起始点,延一个角度,延长一个距离,最后停留的坐标
		 * @param	astar
		 * @param	startX
		 * @param	startY
		 * @param	angle
		 * @param	dist
		 * @param	sBlock
		 * @param	diagAble
		 * @return
		 */
		public static function moveLinePoint(astar:UpGameAStar, startX:int, startY:int, angle:int, dist:int, sBlock:Object, diagAble:Boolean = true):MPoint
		{
			var _a:Number = angle * MathTools.PI180;
			var aTan:Number = Math.tan(_a);
			//算出弧度
			var x:Number = startX;
			var y:Number = startY;
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
			if (x < astar.hotStartX)
			{
				x = astar.hotStartX + 1;
			}
			else if(x > astar.hotEndX)
			{
				x = astar.hotEndX - 1;
			}
			if (y < astar.hotStartY)
			{
				y = astar.hotStartY + 1;
			}
			else if (y > astar.hotEndY)
			{
				y = astar.hotEndY - 1;
			}
			var endX:int = int(x);
			var endY:int = int(y);
			//要叠加算出距离
			var gfx:int = int((endX - astar.offsetX) / astar.tileWidth);
			var gfy:int = int((endY - astar.offsetY) / astar.tileHeight);
			var gsx:int = int((startX - astar.offsetX) / astar.tileWidth);
			var gsy:int = int((startY - astar.offsetY) / astar.tileHeight);
			var gid:int;//格子坐标
			var ax:Number = astar.offsetX - startX;
			var ay:Number = astar.offsetY - startY;
			var xx:int = gsx;
			var xy:int = gsy;
			var xRun:Boolean = false;
			var xDist:Number;
			var yx:int = gsx;
			var yy:int = gsy;
			var yRun:Boolean = false;
			var yDist:Number;
			while (gsx != gfx)
			{
				if (gsx < gfx)
				{
					gsx++;
				}
				else
				{
					gsx--;
				}
				gid = int((aTan * (gsx * astar.tileWidth + ax) - ay) / astar.tileHeight);
				if (gsx < 0 || gid < 0 || gsx >= astar.width || gid >= astar.height || astar.map[gsx][gid] == sBlock || ((gsx - 1) > -1 && astar.map[(gsx - 1)][gid] == sBlock))
				{
					break;
				}
				else
				{
					if (gsx < gfx)
					{
						x = gsx * astar.tileWidth + astar.offsetX + astar.tileWidth - 1;
					}
					else
					{
						x = gsx * astar.tileWidth + astar.offsetX + 1;
					}
					if (gid < gfy)
					{
						y = gid * astar.tileHeight + astar.offsetY + astar.tileHeight - 1;
					}
					else
					{
						y = gid * astar.tileHeight + astar.offsetY + 1;
					}
					x = startX - x;
					y = startY - y;
					y = Math.sqrt(x * x + y * y);
					if(y > dist)
					{
						break;
					}
					else
					{
						xx = gsx;
						xy = gid;
						xRun = true;
						xDist = y;
					}
				}
			}
			while (gsy != gfy)
			{
				if (gsy < gfy)
				{
					gsy++;
				}
				else
				{
					gsy--;
				}
				gid = int(((gsy * astar.tileHeight + ay) / aTan - ax) / astar.tileWidth);
				if (gid < 0 || gsy < 0 || gid >= astar.width || gsy >= astar.height || astar.map[gid][gsy] == sBlock || ((gsy - 1) > -1 && astar.map[gid][(gsy - 1)] == sBlock))
				{
					break;
				}
				else
				{
					if (gid < gfx)
					{
						x = gid * astar.tileWidth + astar.offsetX + astar.tileWidth - 1;
					}
					else
					{
						x = gid * astar.tileWidth + astar.offsetX + 1;
					}
					if (gsy < gfy)
					{
						y = gsy * astar.tileHeight + astar.offsetY + astar.tileHeight - 1;
					}
					else
					{
						y = gsy * astar.tileHeight + astar.offsetY + 1;
					}
					x = startX - x;
					y = startY - y;
					y = Math.sqrt(x * x + y * y);
					if(y > dist)
					{
						break;
					}
					else
					{
						yx = gid;
						yy = gsy;
						yRun = true;
						yDist = y;
					}
				}
			}
			//找到边缘值,查询2个那个更远
			if (xx == gfx && xy == gfy)
			{
				return MPoint.instance(endX, endY);
			}
			else if(yx == gfx && yy == gfy)
			{
				return MPoint.instance(endX, endY);
			}
			else if(xRun && yRun)
			{
				if(xDist > yDist)
				{
					if (xx < gfx)
					{
						endX = xx * astar.tileWidth + astar.offsetX + astar.tileWidth - 1;
					}
					else
					{
						endX = xx * astar.tileWidth + astar.offsetX + 1;
					}
					if (xy < gfy)
					{
						endY = xy * astar.tileHeight + astar.offsetY + astar.tileHeight - 1;
					}
					else
					{
						endY = xy * astar.tileHeight + astar.offsetY + 1;
					}
					return MPoint.instance(endX, endY);
				}
				else
				{
					if (yx < gfx)
					{
						endX = yx * astar.tileWidth + astar.offsetX + astar.tileWidth - 1;
					}
					else
					{
						endX = yx * astar.tileWidth + astar.offsetX + 1;
					}
					if (yy < gfy)
					{
						endY = yy * astar.tileHeight + astar.offsetY + astar.tileHeight - 1;
					}
					else
					{
						endY = yy * astar.tileHeight + astar.offsetY + 1;
					}
					return MPoint.instance(endX, endY);
				}
			}
			else if(xRun)
			{
				if (xx < gfx)
				{
					endX = xx * astar.tileWidth + astar.offsetX + astar.tileWidth - 1;
				}
				else
				{
					endX = xx * astar.tileWidth + astar.offsetX + 1;
				}
				if (xy < gfy)
				{
					endY = xy * astar.tileHeight + astar.offsetY + astar.tileHeight - 1;
				}
				else
				{
					endY = xy * astar.tileHeight + astar.offsetY + 1;
				}
				return MPoint.instance(endX, endY);
			}
			else if(yRun)
			{
				if (yx < gfx)
				{
					endX = yx * astar.tileWidth + astar.offsetX + astar.tileWidth - 1;
				}
				else
				{
					endX = yx * astar.tileWidth + astar.offsetX + 1;
				}
				if (yy < gfy)
				{
					endY = yy * astar.tileHeight + astar.offsetY + astar.tileHeight - 1;
				}
				else
				{
					endY = yy * astar.tileHeight + astar.offsetY + 1;
				}
				return MPoint.instance(endX, endY);
			}
			return null;
		}
		
		/**
		 * 设置P的路径,镜像情况,使用下一个坐标的数据
		 * 使用前一个的坐标来设置本个的坐标
		 * @param	role
		 * @param	pre		上一个坐标
		 * @param	p		设置的方向
		 */
		public static function setPointInfo(role:EDRole, pre:AIRoleMovePoint, p:AIRoleMovePoint):void
		{
			var angle:Number, radian:Number, x:int, y:int;
			if (pre)
			{
				x = pre.x;
				y = pre.y;
			}
			else
			{
				x = role.x;
				y = role.y;
			}
			if (x == p.x && y == p.y)
			{
				//可以绕过
				angle = role.angle;
				radian = MathTools.PI180 * angle;
			}
			else if (x == p.x)//竖着相等
			{
				if (y < p.y)// 向下走
				{
					angle = 90;
					radian = MathTools.PI2;
				}
				else// 向上走
				{
					angle = 270;
					radian = MathTools.PI180270;
				}
			}
			else if (y == p.y)//横向相等
			{
				if (x < p.x)//向右走
				{
					angle = 0;
					radian = 0;
				}
				else//向左走
				{
					angle = 180;
					radian = Math.PI;
				}
			}
			else
			{
				//正常数据
				radian = Math.atan2(y - p.y, x - p.x) + Math.PI;
				angle = radian * MathTools.PI1802;
				angle = angle % 360;
				if (angle < 0) angle += 360;
			}
			p.angle = angle;
			p.radian = radian;
		}
	}

}