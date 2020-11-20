package cn.wjj.upgame.engine 
{
	import cn.wjj.display.MPoint;
	import cn.wjj.upgame.common.StatusTypeRole;
	import cn.wjj.upgame.common.SystemValue;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 寻路,通过AStar的方式
	 * 
	 * 不参与MathRandom的运行
	 * 
	 * @author GaGa
	 */
	public class AIRoleMoveAStar 
	{
		/** 目标坐标刷新时间周期 **/
		private static const targetRefresh:uint = 1000;
		/** 交换缓存 **/
		private static var temp:Vector.<AIRoleMovePoint>;
		
		
		/** 引用 **/
		public var ed:EDRole;
		/** 现在正在移动的点 **/
		public var point:AIRoleMovePoint;
		/** 要移动到的位置 **/
		public var path:Vector.<AIRoleMovePoint> = new Vector.<AIRoleMovePoint>();
		/** 要移动到的位置 **/
		private var pathFind:Vector.<AIRoleMovePoint> = new Vector.<AIRoleMovePoint>();
		
		/** 计算移动开始时间 **/
		private var startTime:int = 0;
		/** 移动所使用的时间,推算出的累计时间,用于计算人物移动动作 **/
		private var uiMoveTime:Number = 0;
		/** 某一个节点移动前的人物坐标 **/
		private var _x:Number = 0;
		/** 某一个节点移动前的人物坐标 **/
		private var _y:Number = 0;
		private var _a:Number;
		/** 移动者的攻击范围 **/
		private var range:uint;
		/** 移动到一个射程范围内的对象 **/
		private var target:EDRole;
		/** 上一次目标坐标刷新的时间 **/
		private var targetTime:uint;
		/** 缓存目标的X坐标 **/
		private var targetX:int = 9999999;
		/** 缓存目标的Y坐标 **/
		private var targetY:int = 9999999;
		
		
		public function AIRoleMoveAStar() { }
		
		public function setThis(ed:EDRole):void
		{
			this.ed = ed;
		}
		
		/** 清理对象, 及里面的全部内容 **/
		internal function clear():void
		{
			if (ed != null) ed = null;
			if (range != 0) range = 0;
			if (target != null) target = null;
			if (targetX != 9999999) targetX = 9999999;
			if (targetY != 9999999) targetY = 9999999;
			if (startTime != 0) startTime = 0;
			if (uiMoveTime != 0) uiMoveTime = 0;
			var p:AIRoleMovePoint;
			if (path.length)
			{
				for each (p in path) 
				{
					p.dispose();
				}
				path.length = 0;
			}
			if (pathFind.length)
			{
				for each (p in pathFind) 
				{
					p.dispose();
				}
				pathFind.length = 0;
			}
			if (point)
			{
				point.dispose();
				point = null;
			}
		}
		
		/** 停止移动 **/
		internal function stop():void
		{
			if (range != 0) range = 0;
			if (target != null) target = null;
			if (targetX != 9999999) targetX = 9999999;
			if (targetY != 9999999) targetY = 9999999;
			if (startTime != 0) startTime = 0;
			if (uiMoveTime != 0) uiMoveTime = 0;
			var p:AIRoleMovePoint;
			if (path.length)
			{
				for each (p in path) 
				{
					p.dispose();
				}
				path.length = 0;
			}
			if (pathFind.length)
			{
				for each (p in pathFind) 
				{
					p.dispose();
				}
				pathFind.length = 0;
			}
			if (point)
			{
				point.dispose();
				point = null;
			}
			ed.lock = false;
			if (ed.status == StatusTypeRole.move)
			{
				ed.changeStatus(StatusTypeRole.idle);
			}
		}
		
		/** 提前走入场景里 **/
		internal function moveBlank():void
		{
			if (ed.info.speed > 0 && ed.inHot == false && point == null && ed.canHit)
			{
				if (ed.info.typeProperty == 1)
				{
					//找到格子的一些参数
					var gsx:int = int((ed.x - ed.u.engine.astar.offsetX) / ed.u.engine.astar.tileWidth);
					var gsy:int = int((ed.y - ed.u.engine.astar.offsetY) / ed.u.engine.astar.tileHeight);
					var changeX:Boolean = false;
					var changeY:Boolean = false;
					//站在不能走的地方,先移动出来
					if (gsx < 0 || gsy < 0 || gsx >= ed.u.engine.astar.width || gsy >= ed.u.engine.astar.height || ed.u.engine.astar.map[gsx][gsy] == 1)
					{
						//范围太夸张就先移动到最近的地方,然后在找
						if(gsx < 0)
						{
							gsx = 0;
							changeX = true;
						}
						else if(gsx >= ed.u.engine.astar.width)
						{
							gsx = ed.u.engine.astar.width - 1;
							changeX = true;
						}
						if(gsy < 0)
						{
							gsy = 0;
							changeY = true;
						}
						else if(gsy >= ed.u.engine.astar.height)
						{
							gsy = ed.u.engine.astar.height - 1;
							changeY = true;
						}
						var blank:AIRoleMovePoint = AIRoleMoveTool.gotoBlankGrid(ed.u.engine.astar, gsx, gsy, 1);
						if (blank)
						{
							//清理地图数据
							if (path.length)
							{
								for each (var p:AIRoleMovePoint in path)
								{
									p.dispose();
								}
								path.length = 0;
							}
							if (gsx == blank.x && changeX == false)
							{
								blank.x = ed.x;
							}
							else
							{
								blank.x = blank.x * ed.u.engine.astar.tileWidth + ed.u.engine.astar.offsetX;
								if(ed.x > blank.x)
								{
									blank.x = ed.u.engine.astar.tileWidth + blank.x - 1;
								}
							}
							if (gsy == blank.y && changeY == false)
							{
								blank.y = ed.y;
							}
							else
							{
								blank.y = blank.y * ed.u.engine.astar.tileHeight + ed.u.engine.astar.offsetY;
								if(ed.y > blank.y)
								{
									blank.y = ed.u.engine.astar.tileHeight + blank.y - 1;
								}
							}
							AIRoleMoveTool.setPointInfo(ed , null, blank);
							this.targetX = blank.x;
							this.targetY = blank.y;
							if (target != null) target = null;
							if (uiMoveTime != 0) uiMoveTime = 0;
							//移动的时候不能释放技能
							if (ed.ai.skillFire)
							{
								ed.ai.skillStop();
							}
							ed.ai.oldSkill = null;
							ed.lock = true;
							point = blank;
							if (int(point.angle) != ed.angle)
							{
								ed.angle = int(point.angle);
								if (ed.status != StatusTypeRole.move) ed.status = StatusTypeRole.move;
								EDRoleToolsSkin.changeSkin(ed, ed.u.modeTurn);
							}
							else if (ed.status != StatusTypeRole.move)
							{
								ed.status = StatusTypeRole.move;
								EDRoleToolsSkin.changeSkin(ed, ed.u.modeTurn);
							}
							//通过运行的时间,来算出距离,用距离和角度,算出每次叠加的x,y轴的距离,每次运行都加值
							this._x = ed.x;
							this._y = ed.y;
							this.startTime = ed.u.engine.time.timeGame;
						}
					}
					else if (ed.inHot == false)
					{
						ed.inHot = true;
					}
				}
				else if (ed.inHot == false)
				{
					ed.inHot = true;
				}
			}
		}
		
		/**
		 * 使用自动控制来移动到特定坐标位置
		 * 
		 * 中途变化的时候,如果点从格子变化另外的格子,连线会发生变化
		 * @param	x
		 * @param	y
		 * @param	lock
		 * @return	是否成功运行,还是本命令无效
		 */
		internal function movePoint(x:int, y:int, lock:Boolean = false):Boolean
		{
			//技能需要全部播放完毕
			if (ed.info.speed > 0 && ed._aiStop == false && ed._aiStun == false && ed.canHit && ed.status != StatusTypeRole.collision && (ed.ai.skillFire == null || ed.ai.skillFire.action == null || ed.ai.skillFire.action.lockPlay == false))
			{
				//如果正在移动,并且目标也是自己,就不用在计算这个了
				if(ed.status != StatusTypeRole.move || targetX != x || targetY != y)
				{
					if (target == null && path.length > 1)
					{
						var oldx:int = int((targetX - ed.u.engine.astar.offsetX) / ed.u.engine.astar.tileWidth);
						var oldy:int = int((targetY - ed.u.engine.astar.offsetY) / ed.u.engine.astar.tileHeight);
						var newx:int = int((x - ed.u.engine.astar.offsetX) / ed.u.engine.astar.tileWidth);
						var newy:int = int((y - ed.u.engine.astar.offsetY) / ed.u.engine.astar.tileHeight);
						if (oldx == newx && oldy == newy && AIRoleMoveTool.canLinePoint(ed.u.engine.astar, x, y, path[1].x, path[1].y, 1, true))
						{
							targetX = x;
							targetY = y;
							path[0].x = x;
							path[0].y = y;
							AIRoleMoveTool.setPointInfo(ed, path[1], path[0]);
							return false;
						}
					}
					if (pathFind.length)
					{
						for each (p in pathFind) 
						{
							p.dispose();
						}
						pathFind.length = 0;
					}
					AIRoleMoveTool.findPoint(ed.u, ed, pathFind, x, y, 1, true);
					if (pathFind.length)
					{
						targetX = x;
						targetY = y;
						if (target != null) target = null;
						if (uiMoveTime != 0) uiMoveTime = 0;
						if (path.length)
						{
							for each (var p:AIRoleMovePoint in path) 
							{
								p.dispose();
							}
							path.length = 0;
						}
						temp = path;
						path = pathFind;
						pathFind = temp;
						//移动的时候不能释放技能
						if (ed.ai.skillFire)
						{
							ed.ai.skillStop();
						}
						ed.ai.oldSkill = null;
						ed.lock = lock;
						point = path.pop();
						if (int(point.angle) != ed.angle)
						{
							ed.angle = int(point.angle);
							if (ed.status != StatusTypeRole.move) ed.status = StatusTypeRole.move;
							EDRoleToolsSkin.changeSkin(ed, ed.u.modeTurn);
						}
						else if (ed.status != StatusTypeRole.move)
						{
							ed.status = StatusTypeRole.move;
							EDRoleToolsSkin.changeSkin(ed, ed.u.modeTurn);
						}
						//通过运行的时间,来算出距离,用距离和角度,算出每次叠加的x,y轴的距离,每次运行都加值
						_x = ed.x;
						_y = ed.y;
						this.startTime = ed.u.engine.time.timeGame;
						return true;
					}
				}
			}
			return false;
		}
		
		/**
		 * 跟踪敌人移动到攻击范围,中途不停的校验是否已经到达目标,不停的改变方向等
		 * 通过运行的时间,来算出距离,用距离和角度,算出每次叠加的x,y轴的距离,每次运行都加值
		 * @param	target
		 * @param	range
		 * @param	lock
		 */
		internal function moveTarget(target:EDRole, range:uint, lock:Boolean = false):void
		{
			//技能需要全部播放完毕
			if (ed.info.speed > 0 && ed._aiStop == false && ed._aiStun == false && ed.canHit && ed.status != StatusTypeRole.collision && (ed.ai.skillFire == null || ed.ai.skillFire.action == null || ed.ai.skillFire.action.lockPlay == false))
			{
				//如果正在移动,并且目标也是自己,就不用在计算这个了
				if(!(ed.status == StatusTypeRole.move && this.target == target))
				{
					//算出距离
					var dist:int, short:int;
					var x:Number = ed.x + ed.hit_r_x;
					var y:Number = ed.y + ed.hit_r_y;
					if (ed.hit_h)
					{
						x = ed.hit_r / 2 + x;
						y = ed.hit_h / 2 + y;
						short = SystemValue.ShortenRangeRect;
					}
					else
					{
						short = SystemValue.ShortenRangeCircle;
					}
					dist = SearchTargetRole.pointHitRangeCountInt(x, y, target) + short;
					if (dist > range)
					{
						var targetPoint:MPoint;
						if (range)
						{
							targetPoint = AIRoleMoveTool.hitTargetPoint(ed.u.engine.astar, ed.x, ed.y, target.x, target.y, dist, range, 1);
						}
						else
						{
							targetPoint = MPoint.instance(target.x, target.y);
						}
						if (targetPoint)
						{
							if (pathFind.length)
							{
								for each (p in pathFind) 
								{
									p.dispose();
								}
								pathFind.length = 0;
							}
							AIRoleMoveTool.findPoint(ed.u, ed, pathFind, targetPoint.x, targetPoint.y, 1, true);
							targetPoint.dispose();
							targetPoint = null;
							if(pathFind.length)
							{
								this.startTime = ed.u.engine.time.timeGame;
								_x = ed.x;
								_y = ed.y;
								if (uiMoveTime != 0) uiMoveTime = 0;
								if (path.length)
								{
									for each (var p:AIRoleMovePoint in path) 
									{
										p.dispose();
									}
									path.length = 0;
								}
								temp = path;
								path = pathFind;
								pathFind = temp;
								//移动的时候不能释放技能
								if (ed.ai.skillFire)
								{
									ed.ai.skillStop();
								}
								ed.ai.oldSkill = null;
								this.target = target;
								this.targetTime = this.startTime;
								this.targetX = target.x;
								this.targetY = target.y;
								this.range = range;
								ed.lock = lock;
								point = path.pop();
								if (int(point.angle) != ed.angle)
								{
									ed.angle = int(point.angle);
									if (ed.status != StatusTypeRole.move) ed.status = StatusTypeRole.move;
									EDRoleToolsSkin.changeSkin(ed, ed.u.modeTurn);
								}
								else if (ed.status != StatusTypeRole.move)
								{
									ed.status = StatusTypeRole.move;
									EDRoleToolsSkin.changeSkin(ed, ed.u.modeTurn);
								}
							}
						}
					}
				}
			}
		}
		
		/** 使用AIRoleMovePoint点数据角度和设置角色显示的状态 **/
		private function usePointToUI(angle:int):void
		{
			if (angle != ed.angle)
			{
				ed.angle = angle;
				if (ed.status != StatusTypeRole.move)
				{
					ed.status = StatusTypeRole.move;
				}
				EDRoleToolsSkin.changeSkin(ed, ed.u.modeTurn);
			}
			else if (ed.status != StatusTypeRole.move)
			{
				ed.status = StatusTypeRole.move;
				EDRoleToolsSkin.changeSkin(ed, ed.u.modeTurn);
			}
		}
		
		/**
		 * 不停的移动
		 * @param	doTarget	是否要处理攻击对象
		 * @return	移动完毕后的一个时间,如果是true,没有移动完毕
		 */
		internal function moveFrame(u:UpGame, doTarget:Boolean = true):Boolean 
		{
			if (ed.info.speed > 0)
			{
				if (startTime == 0)
				{
					startTime = u.engine.time.timeGame;
				}
				else if (startTime != u.engine.time.timeGame)
				{
					//本次移动的时间
					var h:Number, x:Number, y:Number, dist:int, short:int, moveTime:uint;
					if (doTarget && target)
					{
						if (target.isLive)
						{
							if ((u.engine.time.timeGame - targetTime) > AIRoleMoveAStar.targetRefresh)
							{
								targetTime = u.engine.time.timeGame;
								if (targetX != target.x || targetY != target.y)
								{
									//算出距离
									if (ed.hit_h)
									{
										x = ed.hit_r / 2 + _x + ed.hit_r_x;
										y = ed.hit_h / 2 + _y + ed.hit_r_y;
										short = SystemValue.ShortenRangeRect;
									}
									else
									{
										x = _x + ed.hit_r_x;
										y = _y + ed.hit_r_y;
										short = SystemValue.ShortenRangeCircle;
									}
									dist = SearchTargetRole.pointHitRangeCountInt(x, y, target) + short;
									if (dist > range)
									{
										var targetPoint:MPoint;
										if (range)
										{
											targetPoint = AIRoleMoveTool.hitTargetPoint(u.engine.astar, ed.x, ed.y, target.x, target.y, dist, range, 1);
										}
										else
										{
											targetPoint = MPoint.instance(target.x, target.y);
										}
										if (targetPoint)
										{
											if (pathFind.length)
											{
												for each (p in pathFind) 
												{
													p.dispose();
												}
												pathFind.length = 0;
											}
											AIRoleMoveTool.findPoint(u, ed, pathFind, targetPoint.x, targetPoint.y, 1, true);
											targetPoint.dispose();
											targetPoint = null;
											if(pathFind.length)
											{
												if (path.length)
												{
													for each (var p:AIRoleMovePoint in path) 
													{
														p.dispose();
													}
													path.length = 0;
												}
												temp = path;
												path = pathFind;
												pathFind = temp;
												_x = ed.x;
												_y = ed.y;
												this.targetX = target.x;
												this.targetY = target.y;
												startTime = u.engine.time.timeGame - ed.u.engine.time.timeFrame;
												point = path.pop();
												usePointToUI(int(point.angle));
											}
										}
										else
										{
											stop();
											return false;
										}
									}
									else
									{
										stop();
										return false;
									}
								}
							}
						}
						else
						{
							stop();
							return false;
						}
					}
					if (point)
					{
						x = point.x - _x;
						y = point.y - _y;
						//还剩余的距离
						if (point.angle == 90 || point.angle == 270) { }
						else if (point.angle > 90 && point.angle < 270)//向右,点在人物的左边,但是人物已经跑到点左边,修正
						{
							if (x > 0)
							{
								x = 0;
								_x = ed.x;
								point.x = _x;
								AIRoleMoveTool.setPointInfo(ed, null, point);
							}
						}
						else
						{
							if (x < 0)
							{
								x = 0;
								_x = ed.x;
								point.x = _x;
								AIRoleMoveTool.setPointInfo(ed, null, point);
							}
						}
						if (point.angle == 0 || point.angle == 180) { }
						else if (point.angle > 0 && point.angle < 180)//向下走,点在人物的下面
						{
							if (y < 0)
							{
								y = 0;
								_y = ed.y;
								point.y = _y;
								AIRoleMoveTool.setPointInfo(ed, null, point);
							}
						}
						else
						{
							if (y > 0)
							{
								y = 0;
								_y = ed.y;
								point.y = _y;
								AIRoleMoveTool.setPointInfo(ed, null, point);
							}
						}
						if (x == 0 && y == 0)
						{
							dist = 0;
						}
						else if (x == 0)
						{
							if (y < 0)
							{
								dist = -y;
							}
							else
							{
								dist = y;
							}
						}
						else if (y == 0)
						{
							if (x < 0)
							{
								dist = -x;
							}
							else
							{
								dist = x;
							}
						}
						else
						{
							dist = Math.sqrt(x * x + y * y);
						}
						if (dist > 0)
						{
							moveTime = dist / ed.info.speed * 1000;
							if ((startTime + moveTime) < u.engine.time.timeGame)//还剩余时间
							{
								ed.x = point.x;
								ed.y = point.y;
								usePointToUI(int(point.angle));
								if (path.length)
								{
									point = path.pop();
									_x = ed.x;
									_y = ed.y;
									startTime = startTime + moveTime;
									return moveFrame(u, false);
								}
								else
								{
									stop();
									return false;
								}
							}
							else//没有剩余时间,继续走
							{
								moveTime = u.engine.time.timeGame - startTime;
								h = ed.info.speed * moveTime / 1000;
								switch (point.angle) 
								{
									case 0:
										_x = _x + h;
										break;
									case 90:
										_y = _y + h;
										break;
									case 180:
										_x = _x - h;
										break;
									case 270:
										_y = _y - h;
										break;
									default:
										_x = Math.cos(point.radian) * h + _x;
										_y = Math.sin(point.radian) * h + _y;
								}
								//还剩余的距离
								ed.x = int(_x);
								if ((_x - ed.x) > 0.5) ed.x = ed.x + 1;
								ed.y = int(_y);
								if ((_y - ed.y)  > 0.5) ed.y = ed.y + 1;
								this.startTime = u.engine.time.timeGame;
								usePointToUI(int(point.angle));
							}
						}
						else
						{
							ed.x = point.x;
							ed.y = point.y;
							if (point.angle != ed.angle)
							{
								ed.angle = point.angle;
								EDRoleToolsSkin.changeSkin(ed, u.modeTurn);
							}
							if (path.length)
							{
								point = path.pop();
								_x = ed.x;
								_y = ed.y;
								startTime = u.engine.time.timeGame - u.engine.time.timeFrame;
								return moveFrame(u, false);
							}
							else
							{
								stop();
								return false;
							}
						}
					}
				}
			}
			else
			{
				stop();
			}
			return true;
		}
	}
}