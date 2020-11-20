package cn.wjj.upgame.engine
{
	import cn.wjj.display.MPoint;
	import cn.wjj.g;
	import cn.wjj.upgame.info.UpInfoAStar;
	import cn.wjj.upgame.UpGame;
	import flash.geom.Rectangle;
	
	/**
	 * 寻路
	 * 
	 * 地图数据
	 * 
	 * 二维数组(sMazeMap)
	 * 
	 * 地图用一种新的数组
	 * 里面的长和宽至少可以找到的
	 * 有无索引区域,可以随便闲逛的
	 * 对地图自动拆分区域
	 * 
	 * mapArray[x][y] = 1;
	 * 
	 */
	public class UpGameAStar
	{
		/** UpGame引用 **/
		public var u:UpGame;
		/** 数据的引用 **/
		public var info:UpInfoAStar;
		
		//A星寻路参数
		/** 直线花费 **/
		private var _straightCost:int;
		/** 斜线花费 **/
		private var _diagonalCost:int;
		/** 自动选择算法，为假的话，会始终使用最快的估价，否则在允许走斜线时会选用略慢的算法以提升路径质量 **/
		private var _autoAlgorithm:Boolean;
		/** 寻路步数限制，到此步数即停止寻路 **/
		private var _stepLimit:int;
		/** 是否重复使用路径数组，有助于节省内存，但无法产生副本 **/
		private var _reusePath:Boolean;
		
		//内存优化，开/闭列表，路径列表
		/** 开列表结构为：F估价和，G已消耗，H预消耗，节点X，节点Y，父节点X，父节点Y **/
		private var open:Array;
		/** 闭列表结构为：节点X，节点Y，父节点X，父节点Y **/
		private var close:Array;
		private var pathList:Array;
		
		/** 速度优化，节点访问情况列表，true在闭列表，false在开列表，undefined不在任何表 **/
		private var nodeList:Array;
		
		/** 二维数组记录地图数据 **/
		public var map:Array;
		/** (格子数量)地图宽度范围 **/
		public var width:int;
		/** (格子数量)地图高度范围 **/
		public var height:int;
		/** (像素)偏移起始点 **/
		public var offsetX:int = 0;
		/** (像素)偏移起始点 **/
		public var offsetY:int = 0;
		/** (像素)格子宽度 **/
		public var tileWidth:uint = 0;
		/** (像素)格子高度 **/
		public var tileHeight:uint = 0;
		
		/** 战场的战斗区域 **/
		public var hotStartX:int;
		/** 战场的战斗区域 **/
		public var hotEndX:int;
		/** 战场的战斗区域 **/
		public var hotStartY:int;
		/** 战场的战斗区域 **/
		public var hotEndY:int;
		/** 战场的战斗区域中心点 **/
		public var hotCenterX:int;
		/** 战场的战斗区域中心点 **/
		public var hotCenterY:int;
		
		/** 是否初始化过区域 **/
		private var noInitRect:Boolean = true;
		
		/** 强制向下右移动的区域 **/
		public var moveDownLeft:Rectangle = new Rectangle(0, 0, 12, 2);
		/** 强制向下左移动的区域 **/
		public var moveDownRight:Rectangle = new Rectangle(24, 0, 12, 2);
		/** 强制向上移动的区域 **/
		public var moveTopLeft:Rectangle = new Rectangle(0, 62, 12, 2);
		/** 强制向上移动的区域 **/
		public var moveTopRight:Rectangle = new Rectangle(24, 62, 12, 2);
		/** 强制上下右移动的区域 **/
		public var moveCenterLeft:Rectangle = new Rectangle(0, 30, 4, 4);
		/** 强制上下左右移动的区域 **/
		public var moveCenterCenter:Rectangle = new Rectangle(10, 30, 16, 4);
		/** 强制上下左移动的区域 **/
		public var moveCenterRight:Rectangle = new Rectangle(32, 30, 4, 4);
		
		/** 强制上下左右移动的区域 **/
		public var moveTower1:Rectangle = new Rectangle(5, 49, 4, 4);
		public var moveTower2:Rectangle = new Rectangle(27, 49, 4, 4);
		public var moveTower3:Rectangle = new Rectangle(15, 55, 6, 6);
		
		public var moveTower4:Rectangle = new Rectangle(27, 11, 4, 4);
		public var moveTower5:Rectangle = new Rectangle(5, 11, 4, 4);
		public var moveTower6:Rectangle = new Rectangle(15, 3, 6, 6);
		
		/** 特殊的阻挡区域 **/
		public var moveOther:Vector.<Rectangle> = new Vector.<Rectangle>();
		/** 特殊的阻挡区域的移动配置 **/
		public var moveOtherInfo:Vector.<Array> = new Vector.<Array>();
		
		/** 四面八方都可以移动的区域 **/
		public var moveAll:Vector.<Rectangle> = new Vector.<Rectangle>();
		
		/**
		 * 构造函数，用于设置A星寻路参数
		 * @param	u				架构引用
		 * @param	straightCost	直线花费
		 * @param	diagonalCost	斜线花费
		 * @param	autoAlgorithm	自动选择算法，为假的话，会始终使用最快的估价，否则在允许走斜线时会选用略慢的算法以提升路径质量
		 * @param	stepLimit		寻路步数限制，到此步数即停止寻路
		 * @param	reusePath		是否重复使用路径数组，有助于节省内存，但无法产生副本
		 */
		public function UpGameAStar(u:UpGame, straightCost:int = 10, diagonalCost:int = 14, autoAlgorithm:Boolean = true, stepLimit:int = 0, reusePath:Boolean = false):void
		{
			this.open = g.speedFact.n_array();
			this.close = g.speedFact.n_array();
			this.pathList = g.speedFact.n_array();
			this.nodeList = g.speedFact.n_array();
			setThis(u);
			this._straightCost = straightCost;
			this._diagonalCost = diagonalCost;
			this._autoAlgorithm = autoAlgorithm;
			this._stepLimit = stepLimit;
			this._reusePath = reusePath;
		}
		
		/**
		 * 对A*数据进行处理,获得区域内的A*数据
		 * 
		 * @param	upGame
		 * @param	startY	(未实现)坐标区间,包含此格子
		 * @param	endY	(未实现)坐标区间,包含此格子
		 */
		public function setThis(u:UpGame, startY:int = 0, endY:int = 0):void
		{
			var x:int, y:int;
			if (this.map)
			{
				if (this.map.length)
				{
					this.width = this.map.length;
					for (x = 0; x < this.width; x++)
					{
						g.speedFact.d_array(map[x]);
					}
					this.map.length = 0;
				}
			}
			else
			{
				this.map = g.speedFact.n_array();
			}
			this.u = u;
			this.info = u.info.aStar;
			this.width = info.xLength;
			this.height = info.yLength;
			this.offsetX = info.offsetX;
			this.offsetY = info.offsetY;
			this.tileWidth = info.tileWidth;
			this.tileHeight = info.tileHeight;
			if (startY != 0 || endY != 0)
			{
				this.offsetY += endY * this.tileHeight;
				this.height = startY - endY + 1;
				this.map = g.speedFact.n_array();
				for (x = 0; x < this.width; x++)
				{
					this.map[x] = g.speedFact.n_array();
					for (y = 0; y < this.height; y++)
					{
						this.map[x][y] = this.info.map[x][y + endY];
					}
				}
			}
			else
			{
				//战斗前复制出来AStar数据,以方便占位操作的需要
				for (x = 0; x < this.width; x++)
				{
					this.map[x] = g.speedFact.n_array();
					for (y = 0; y < this.height; y++)
					{
						this.map[x][y] = this.info.map[x][y];
					}
				}
			}
			this.hotStartX = this.offsetX;
			this.hotEndX = this.width * this.tileWidth + this.hotStartX;
			this.hotStartY = this.offsetY;
			this.hotEndY = this.height * this.tileHeight + this.hotStartY;
			this.hotCenterX = int((this.hotEndX - this.hotStartX) / 2 + this.hotStartX);
			this.hotCenterY = int((this.hotEndY - this.hotStartY) / 2 + this.hotStartY);
			
			initRect();
		}
		
		/** 初始化区域 **/
		private function initRect():void
		{
			if (noInitRect)
			{
				initRectTools(moveDownLeft);
				initRectTools(moveDownRight);
				initRectTools(moveTopLeft);
				initRectTools(moveTopRight);
				initRectTools(moveCenterLeft);
				initRectTools(moveCenterRight);
				
				initRectTools(moveCenterCenter);
				
				initRectTools(moveTower1);
				initRectTools(moveTower2);
				initRectTools(moveTower3);
				initRectTools(moveTower4);
				initRectTools(moveTower5);
				initRectTools(moveTower6);
			}
			var arr:Array;
			if (moveOtherInfo.length)
			{
				for each (arr in moveOtherInfo) 
				{
					g.speedFact.d_array(arr);
				}
				moveOtherInfo.length = 0;
			}
			
			//up:Boolean, down:Boolean, left:Boolean, right:Boolean
			
			moveOther.length = 0;
			moveOther.push(moveDownLeft);
			arr = g.speedFact.n_array();
			arr.push(false, true, false, false);//false, true, false, true
			moveOtherInfo.push(arr);
			
			moveOther.push(moveDownRight);
			arr = g.speedFact.n_array();
			arr.push(false, true, false, false);//false, true, true, false
			moveOtherInfo.push(arr);
			
			moveOther.push(moveTopLeft);
			arr = g.speedFact.n_array();
			arr.push(true, false, false, false);//true, false, false, true
			moveOtherInfo.push(arr);
			
			moveOther.push(moveTopRight);
			arr = g.speedFact.n_array();
			arr.push(true, false, false, false);//true, false, true, false
			moveOtherInfo.push(arr);
			
			moveOther.push(moveCenterLeft);
			arr = g.speedFact.n_array();
			arr.push(true, true, false, false);//true, true, false, true
			moveOtherInfo.push(arr);
			
			moveOther.push(moveCenterRight);
			arr = g.speedFact.n_array();
			arr.push(true, true, false, false);//true, true, true, false
			moveOtherInfo.push(arr);
			
			moveAll.length = 0;
			moveAll.push(moveCenterCenter);
			/*
			moveAll.push(moveTower1);
			moveAll.push(moveTower2);
			moveAll.push(moveTower3);
			moveAll.push(moveTower4);
			moveAll.push(moveTower5);
			moveAll.push(moveTower6);
			*/
			noInitRect = false;
		}
		
		/**
		 * 初始化区域为像素格子
		 * @param	astar
		 * @param	r
		 */
		private function initRectTools(r:Rectangle):void
		{
			r.x = r.x * tileWidth + offsetX;
			r.y = r.y * tileHeight + offsetY;
			r.width = r.width * tileWidth;
			r.height = r.height * tileHeight;
		}
		
		
		/** 摧毁 **/
		public function dispose():void
		{
			if (this.map)
			{
				if (this.map.length)
				{
					this.width = this.map.length;
					for (var x:int = 0; x < this.width; x++)
					{
						g.speedFact.d_array(map[x]);
					}
				}
				g.speedFact.d_array(this.map);
				this.map = null;
			}
			if (this.open)
			{
				g.speedFact.d_array(this.open);
				this.open = null;
			}
			if (this.close)
			{
				g.speedFact.d_array(this.close);
				this.close = null;
			}
			if (this.pathList)
			{
				g.speedFact.d_array(this.pathList);
				this.pathList = null;
			}
			if (this.nodeList)
			{
				g.speedFact.d_array(this.nodeList);
				this.nodeList = null;
			}
			if (this.u) this.u = null;
			if (this.info) this.info = null;
		}
		
		/**
		 * (像素)地图上的点是否能通过
		 * @param	map		地图信息
		 * @param	x		(像素)地图点
		 * @param	y		(像素)地图点
		 * @param	sBlock	不可通过表达法
		 * @return			true 可通过，false阻挡
		 */
		public function isPass(x:int, y:int, sBlock:Object = 1):Boolean
		{
			x = int((x - offsetX) / tileWidth);
			y = int((y - offsetY) / tileHeight);
			return isPassGrid(x, y, sBlock);
		}
		
		/**
		 * (格子)地图上的点是否能通过
		 * @param	map		地图信息
		 * @param	x		格子点
		 * @param	y		格子点
		 * @return			true 可通过，false阻挡
		 */
		public function isPassGrid(x:int, y:int, sBlock:Object = 1):Boolean
		{
			if (x < 0 || y < 0 || x >= width || y >= height)
			{
				return false;
			}
			else if (map[x][y] == 1)
			{
				return false;
			}
			return true;
		}
		
		/** 根绝地图的点找到Tile的点 **/
		public function getTilePoint(x:int, y:int):MPoint
		{
			x = int((x - offsetX) / tileWidth);
			y = int((y - offsetY) / tileHeight);
			return MPoint.instance(x, y);
		}
		
		/** 根据tile的点找到地图的点,格子的中心点 **/
		public function getMapPoint(x:int, y:int):MPoint
		{
			x = int(x * tileWidth + (tileWidth / 2) + offsetX);
			y = int(y * tileHeight + (tileHeight / 2) + offsetY);
			return MPoint.instance(x, y);
		}
		
		/**
		 * 简单寻路
		 * (提前处理不合规范的寻路,相同格子和超出范围)
		 * 
		 * @param	sBlock		不可通行的表示法
		 * @param	sx			起点X坐标（序号0自开始）
		 * @param	sy			起点Y坐标（序号0自开始）
		 * @param	fx			终点X坐标（序号0自开始）
		 * @param	fy			终点Y坐标（序号0自开始）
		 * @param	diagAble	是否可以走斜线
		 * @return
		 */
		public function pathfinding(sBlock:Object, sx:int, sy:int, fx:int, fy:int, diagAble:Boolean = true):Array
		{
			//清空列表
			open.length = 0;
			close.length = 0;
			nodeList.length = 0;
			//要使用的估价函数
			var hFunction:Function = (_autoAlgorithm && diagAble)?diagonal:manhattan;
			//将开始节点放入开列表
			open.splice(0, 0, 0, 0, 0, sx, sy, -1, -1);
			//A星寻路
			var currentNodeG:int = 0;
			var currentNodeX:int = 0;
			var currentNodeY:int = 0;
			var G:int = 0;
			var H:int = 0;
			Astar:while (true)
			{
				//找出开列表F最小的节点
				currentNodeG = open[1];
				currentNodeX = open[3];
				currentNodeY = open[4];
				//将该节点移入封闭列表
				close.push(currentNodeX);
				close.push(currentNodeY);
				close.push(open[5]);
				close.push(open[6]);
				nodeList[currentNodeY * width + currentNodeX] = true;
				popNode();
				//检查当前节点的邻节点
				for (var dx:int = -1; dx < 2; dx++)
				{
					var adjNodeX:int = currentNodeX + dx;
					if (adjNodeX < 0 || adjNodeX >= width)
					{
						continue;
					}
					for (var dy:int = -1; dy < 2; dy++)
					{
						if ((diagAble || dx == 0 || dy == 0) && (dx != 0 || dy != 0))
						{
							var adjNodeY:int = currentNodeY + dy;
							if(adjNodeY < 0 || adjNodeY >= height)
							{
								continue;
							}
							//检查是否抵达目的地
							if (adjNodeX == fx && adjNodeY == fy)
							{
								break Astar;
							}
							//排除障碍和闭节点
							if (map[adjNodeX][adjNodeY] == sBlock || nodeList[adjNodeY * width + adjNodeX])
							{
								continue;
							}
							//检查是否在开列表里
							G = currentNodeG + ((dx == 0 || dy == 0)?_straightCost:_diagonalCost);
							if (nodeList[adjNodeY * width + adjNodeX] == undefined)
							{
								//添加新节点
								H = hFunction(adjNodeX, adjNodeY, fx, fy);
								pushNode(G + H, G, H, adjNodeX, adjNodeY, currentNodeX, currentNodeY);
								nodeList[adjNodeY * width + adjNodeX] = false;
							}
							else
							{
								for (var i:int = open.length - 4; i >= 0; i -= 7)
								{
									if (open[i] == adjNodeX && open[i + 1] == adjNodeY)
									{
										break;
									}
								}
								if (G < open[i - 2])
								{
									raiseNode(i - 3, open[i - 1] + G, G, open[i - 1], adjNodeX, adjNodeY, currentNodeX, currentNodeY);
								}
								//更新已有节点
							}
						}
					}
				}
				//达到步数限制或者找不到路
				if (open.length == 0 || (_stepLimit && open.length > _stepLimit))
				{
					return null;
				}
			}
			return close;
		}
		
		/**
		 * (没有维护)加权寻路
		 * @param	sMazeMap	源迷宫数组
		 * @param	sBlock		源迷宫不可通行的表示法
		 * @param	startX		起点X坐标（序号0自开始）
		 * @param	startY		起点Y坐标（序号0自开始）
		 * @param	finishX		终点X坐标（序号0自开始）
		 * @param	finishY		终点Y坐标（序号0自开始）
		 * @param	diagAble	是否可以走斜线
		 * @return
		 */
		public function weightedPathfinding(paths:Vector.<MPoint>,astar:UpInfoAStar, sBlock:Object, startX:int, startY:int, finishX:int, finishY:int, diagAble:Boolean = true):Vector.<MPoint>
		{
			startX = int((startX - info.offsetX) / info.tileWidth);
			startY = int((startY - info.offsetY) / info.tileHeight);
			finishX = int((finishX - info.offsetX) / info.tileWidth);
			finishY = int((finishY - info.offsetY) / info.tileHeight);
			//排除不必要的寻路
			if (startX < 0 || finishX < 0 || startY < 0 || finishY < 0 || startX >= width || finishX >= width || startY >= height || finishY >= height || map[finishX][finishY] == sBlock)
			{
				return null;
			}
			else if (startX == finishX && startY == finishY)
			{
				paths.push(new MPoint(startX,startY));
				return paths;
			}
			//要使用的估价函数
			var hFunction:Function;
			if (_autoAlgorithm && diagAble)
			{
				hFunction = diagonal;
			}
			else
			{
				hFunction = manhattan;
			}
			//清空列表
			open.splice(0);
			close.splice(0);
			nodeList.splice(0);
			
			//将开始节点放入开列表
			open.splice(0, 0, 0, 0, 0, startX, startY, -1, -1);
			
			//A星寻路
			var currentNodeG:int = 0;
			var currentNodeX:int = 0;
			var currentNodeY:int = 0;
			var G:int = 0;
			var H:int = 0;
			var i:int;
			Astar:while (true)
			{
				//找出开列表F最小的节点
				currentNodeG = open[1];
				currentNodeX = open[3];
				currentNodeY = open[4];
				//将该节点移入封闭列表
				close.push(currentNodeX);
				close.push(currentNodeY);
				close.push(open[5]);
				close.push(open[6]);
				nodeList[currentNodeY * width + currentNodeX] = true;
				popNode();
				
				//检查当前节点的邻节点
				for (var dx:int = -1; dx < 2; dx++)
				{
					var adjNodeX:int = currentNodeX + dx;
					if(adjNodeX < 0 || adjNodeX >= width)
					{
						continue;
					}
					for (var dy:int = -1; dy < 2; dy++)
					{
						if ((diagAble || dx == 0 || dy == 0) && (dx != 0 || dy != 0))
						{
							var adjNodeY:int = currentNodeY + dy;
							if (adjNodeY < 0 || adjNodeY >= height)
							{
								continue;
							}
							//检查是否抵达目的地
							if (adjNodeX == finishX && adjNodeY == finishY)
							{
								break Astar;
							}
							//排除障碍和闭节点
							if (map[adjNodeX][adjNodeY] == sBlock || nodeList[adjNodeY * width + adjNodeX])
							{
								continue;
							}
							//检查是否在开列表里
							G = currentNodeG + ((dx == 0 || dy == 0)?_straightCost:_diagonalCost) + map[adjNodeX][adjNodeY];
							if (nodeList[adjNodeY * width + adjNodeX] == undefined)
							{
								//添加新节点
								H = hFunction(adjNodeX, adjNodeY, finishX, finishY);
								pushNode(G + H, G, H, adjNodeX, adjNodeY, currentNodeX, currentNodeY);
								nodeList[adjNodeY * width + adjNodeX] = false;
							}
							else
							{
								for (i = open.length - 4; i >= 0; i -= 7)
								{
									if (open[i] == adjNodeX && open[i + 1] == adjNodeY)
									{
										break;
									}
								}
								if (G < open[i - 2])
								{
									//更新已有节点
									raiseNode(i - 3, open[i - 1] + G, G, open[i - 1], adjNodeX, adjNodeY, currentNodeX, currentNodeY);
								}
							}
						}
					}
				}
				//达到步数限制或者找不到路
				if ((_stepLimit && open.length > _stepLimit) || open.length == 0)
				{
					return null;
				}
			}
			//输出路径
			//var path:Array;
			/*if (_reusePath)
			{
				path = pathList;
				path.splice(0);
			}
			else
			{
				path = new Array();
			}*/
			paths.unshift(getMapPoint(finishX, finishY));
			paths.unshift(getMapPoint(currentNodeX, currentNodeY));
			/*path.unshift(finishY);
			path.unshift(finishX);
			path.unshift(currentNodeY);
			path.unshift(currentNodeX);*/
			i = close.length - 4;
			while (i != 0)
			{
				paths.unshift(getMapPoint(close[i + 2],close[i + 3]));
				/*path.unshift(close[i + 3]);
				path.unshift(close[i + 2]);*/
				for (i -= 4; i >= 0; i -= 4)
				{
					if (close[i] == paths[0].x && close[i + 1] == paths[0].y)
					{
						break;
					}
				}
			}
			throw new Error();
			return paths;
		}
		
		/**
		 * manhattan估价算法，以直线距离为基准估价
		 * 作为优化，用?:代替了Math.abs与Math.min
		 * 
		 * @param	tx
		 * @param	ty
		 * @param	fx
		 * @param	fy
		 * @return
		 */
		private function manhattan(tx:int, ty:int, fx:int, fy:int):int
		{
			var x:int, y:int;
			if (tx < fx)
			{
				x = fx - tx;
			}
			else
			{
				x = tx - fx;
			}
			if (ty < fy)
			{
				y = fy - ty;
			}
			else
			{
				y = ty - fy;
			}
			return (x + y) * _straightCost;
		}
		
		/**
		 * diagonal估价算法，以对角线和直线距离为基准
		 * 作为优化，用?:代替了Math.abs与Math.min
		 * @param	tx
		 * @param	ty
		 * @param	fx
		 * @param	fy
		 * @return
		 */
		private function diagonal(tx:int, ty:int, fx:int, fy:int):int
		{
			var x:int, y:int, diag:int;
			if (tx < fx)
			{
				x = fx - tx;
			}
			else
			{
				x = tx - fx;
			}
			if (ty < fy)
			{
				y = fy - ty;
			}
			else
			{
				y = ty - fy;
			}
			if (x < y)
			{
				diag = x;
			}
			else
			{
				diag = y;
			}
			return diag * _diagonalCost + _straightCost * (x + y - 2 * diag);
		}
		
		//=======二叉堆（开表）的操作=======
		/**
		 * 添加节点
		 * @param	F
		 * @param	G
		 * @param	H
		 * @param	x
		 * @param	y
		 * @param	px
		 * @param	py
		 */
		private function pushNode(F:int, G:int, H:int, x:int, y:int, px:int, py:int):void
		{
			//把这个元素和根节点比较并交换
			var t:int = 0;
			for (var i:int = open.length; i > 0; i = t)
			{
				t = ((i / 7 - 1) >> 1) * 7;
				if (F < open[t])
				{
					open[i] = open[t];
					open[i + 1] = open[t + 1];
					open[i + 2] = open[t + 2];
					open[i + 3] = open[t + 3];
					open[i + 4] = open[t + 4];
					open[i + 5] = open[t + 5];
					open[i + 6] = open[t + 6];
				}
				else
				{
					break;
				}
			} 
			open[i] = F;
			open[i + 1] = G;
			open[i + 2] = H;
			open[i + 3] = x;
			open[i + 4] = y;
			open[i + 5] = px;
			open[i + 6] = py;
		}
		
		/** 删除节点 **/
		private function popNode():void
		{
			//和左右子树中较小的比较并交换
			var t:int = 7;
			var len:int = open.length - 7;
			for (var i:int = 0; t < len; )
			{
				if (t + 7 < len && open[t + 7] < open[t])
				{
					t += 7;
				}
				if (open[t] < open[len])
				{
					open[i] = open[t];
					open[i + 1] = open[t + 1];
					open[i + 2] = open[t + 2];
					open[i + 3] = open[t + 3];
					open[i + 4] = open[t + 4];
					open[i + 5] = open[t + 5];
					open[i + 6] = open[t + 6];
				}
				else
				{
					break;
				}
				i = t;
				t = ((i / 7) * 2 + 1) * 7;
			} 
			open[i] = open[len];
			open[i + 1] = open[len + 1];
			open[i + 2] = open[len + 2];
			open[i + 3] = open[len + 3];
			open[i + 4] = open[len + 4];
			open[i + 5] = open[len + 5];
			open[i + 6] = open[len + 6];
			open.length = len;
		}
		
		/** 修改节点 **/
		private function raiseNode(index:int, F:int, G:int, H:int, x:int, y:int, px:int, py:int):void
		{
			//把这个元素和根节点比较并交换
			var t:int = 0;
			for (var i:int = index; i > 0; i = t)
			{
				t = ((i / 7 - 1) >> 1) * 7;
				if (F < open[t])
				{
					open[i] = open[t];
					open[i + 1] = open[t + 1];
					open[i + 2] = open[t + 2];
					open[i + 3] = open[t + 3];
					open[i + 4] = open[t + 4];
					open[i + 5] = open[t + 5];
					open[i + 6] = open[t + 6];
				}
				else
				{
					break;
				} 
			} 
			open[i] = F;
			open[i + 1] = G;
			open[i + 2] = H;
			open[i + 3] = x;
			open[i + 4] = y;
			open[i + 5] = px;
			open[i + 6] = py;
		}
	}
}