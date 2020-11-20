package cn.wjj.upgame.engine 
{
	import cn.wjj.display.MPoint;
	import cn.wjj.tool.MathTools;
	import cn.wjj.upgame.common.StatusTypeRole;
	import cn.wjj.upgame.tools.LineInRect;
	import cn.wjj.upgame.tools.MovePhysPatrol;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 物理引擎驱动的寻路
	 * 
	 * 阻挡区域的向量最大.
	 * 碰撞区域的向量次之
	 * 目标向量和巡逻向量相当
	 * 
	 * 找出最终的向量和方向,在进行前面
	 * 合并碰撞区域向量 , 叠加进巡逻等向量, 最后合并阻挡区向量 ->  然后在行走
	 * 
	 * @author GaGa
	 */
	public class AIRoleMovePhys 
	{
		/** 交换缓存 **/
		private static var temp:Vector.<AIRoleMovePoint>;
		private static var p:AIRoleMovePoint;
		/** 引用 **/
		public var ed:EDRole;
		/** 引用 **/
		public var astar:UpGameAStar;
		
		/** 计算移动开始时间 **/
		private var timeStart:int = 0;
		
		/** 现在移动的角度 **/
		private var angle:Number;
		/** 现在移动的弧度 **/
		private var radian:Number;
		
		/** 是否在被墙等建筑物顶住(碰撞期间不执行互推) **/
		public var inNeed:Boolean = false;
		/** 是否被别人挤压 **/
		public var inPhys:Boolean = false;
		
		/** 上一次强制移动的区域 **/
		public var dragOldNeedX:Number = 0;
		/** 上一次强制移动的区域 **/
		public var dragOldNeedY:Number = 0;
		
		/** (非移动区域 88888888 锁定某一个方向)必须移动的力量水平方向(负数向左像素距离,正数向右像素距离) **/
		public var dragNeedX:Number = 0;
		/** (非移动区域 88888888 锁定某一个方向)必须移动的力量垂直方向(负数向上像素距离,正数向下像素距离) **/
		public var dragNeedY:Number = 0;
		/** 物理挤压方向(被挤压到的像素点) **/
		public var dragPhysX:Number = 0;
		/** 物理挤压方向(被挤压到的像素点) **/
		public var dragPhysY:Number = 0;
		/** 寻找目标,巡逻,移动目标点的Y力量方向(根据速度推算出来的距离) **/
		public var dragGoX:Number = 0;
		/** 寻找目标,巡逻,移动目标点的Y力量方向(根据速度推算出来的距离) **/
		public var dragGoY:Number = 0;
		
		/** 玩家被击退的角度 **/
		public var dragAngle:Number = 0;
		/** 被击退需要退多大距离,即使一个方向被阻挡,也要减去阻挡掉的距离,否则推滑向另一个方向 **/
		public var dragOutDist:Number = 0;
		
		/** 移动者的攻击范围 **/
		private var range:uint;
		/** 运行巡逻的坐标点时间 **/
		public var patrolPointTime:uint = 0;
		/** 巡逻的坐标点 **/
		public var patrolPoint:MPoint;
		/** 移动到一个射程范围内的对象 **/
		public var target:EDRole;
		/** 缓存目标的X坐标 **/
		public var targetX:int = 9999999;
		/** 缓存目标的Y坐标 **/
		public var targetY:int = 9999999;
		
		private var _x:Number;
		private var _y:Number;
		
		public function AIRoleMovePhys() { }
		
		public function setThis(ed:EDRole):void
		{
			this.ed = ed;
			this.astar = ed.u.engine.astar;
			if (this.patrolPoint == null)
			{
				this.patrolPoint = MPoint.instance();
			}
			else if (patrolPoint.x != 9999999)
			{
				patrolPoint.x = 9999999;
			}
		}
		
		/** 清理对象, 及里面的全部内容 **/
		internal function clear():void
		{
			clearMin();
			if (ed != null) ed = null;
			if (inNeed) inNeed = false;
			if (inPhys) inPhys = false;
			if (dragNeedX != 0) dragNeedX = 0;
			if (dragNeedY != 0) dragNeedY = 0;
			if (dragPhysX != 0) dragPhysX = 0;
			if (dragPhysY != 0) dragPhysY = 0;
			if (dragGoX != 0) dragGoX = 0;
			if (dragGoY != 0) dragGoY = 0;
			if (dragAngle != 0) dragAngle = 0;
			if (dragOutDist != 0) dragOutDist = 0;
			if (patrolPoint)
			{
				patrolPoint.dispose();
				patrolPoint = null;
			}
		}
		
		/** 停止移动 **/
		internal function stop():void
		{
			clearMin();
			if (ed.lock) ed.lock = false;
			if (ed.status == StatusTypeRole.move || ed.status == StatusTypeRole.patrol)
			{
				ed.changeStatus(StatusTypeRole.idle);
			}
		}
		
		/** 简单的处理 **/
		private function clearMin():void
		{
			if (range != 0) range = 0;
			if (target != null) target = null;
			if (targetX != 9999999) targetX = 9999999;
			if (targetY != 9999999) targetY = 9999999;
			if (timeStart != 0) timeStart = 0;
			if (patrolPointTime != 0) patrolPointTime = 0;
			if (patrolPoint.x != 9999999) patrolPoint.x = 9999999;
		}
		
		/** 是否允许移动 **/
		private function canMove():Boolean
		{
			if (ed._aiStop || ed._aiStun)
			{
				return false;
			}
			if (ed.status == StatusTypeRole.appear || ed.status == StatusTypeRole.collision)
			{
				return false;
			}
			if (ed.ai.skillFire && ed.ai.skillFire.action && ed.ai.skillFire.action.lockPlay)
			{
				return false;
			}
			if (ed.info.speed > 0)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * 根据位置进行巡逻
		 * 专门为对打制作的寻路
		 * 
		 * 保持y轴,然后去找竖着的路
		 * 
		 * 野猪跳跃的情况
		 * 飞机飞跃的情况
		 * 人和人的挤压情况
		 * 
		 * 全用45度角走上去的方式
		 * @param	runFrame	是否运行本帧
		 */
		internal function patrol(u:UpGame, runFrame:Boolean = false):void
		{
			if (canMove())
			{
				if (patrolPointTime != ed.u.engine.time.timeGame)
				{
					//算出新的角度值
					MovePhysPatrol.getPoint(ed, patrolPoint);
					if (patrolPoint.x != 9999999)
					{
						patrolPointTime = ed.u.engine.time.timeGame;
					}
					else if (patrolPointTime)
					{
						patrolPointTime = 0;
					}
				}
				if (patrolPoint.x != 9999999)
				{
					if (range != 0) range = 0;
					if (ed.lock) ed.lock = false;
					if (target != null) target = null;
					if (targetX != 9999999) targetX = 9999999;
					if (targetY != 9999999) targetY = 9999999;
					//移动的时候不能释放技能
					if (ed.ai.skillFire)
					{
						ed.ai.skillStop();
					}
					ed.ai.oldSkill = null;
					//找出角度
					getLineAngle(patrolPoint.x, patrolPoint.y, false);
					if (runFrame)
					{
						this.timeStart = ed.u.engine.time.timeGame - ed.u.engine.time.timeFrame;
						moveFrame(u);
					}
					else
					{
						this.timeStart = ed.u.engine.time.timeGame;
					}
				}
			}
		}
		
		/**
		 * 使用自动控制来移动到特定坐标位置
		 * 
		 * 中途变化的时候,如果点从格子变化另外的格子,连线会发生变化
		 * @param	x
		 * @param	y
		 * @return	是否成功运行,还是本命令无效
		 */
		internal function movePoint(x:int, y:int):Boolean
		{
			//技能需要全部播放完毕
			if (canMove())
			{
				//如果正在移动,并且目标也是自己,就不用在计算这个了
				if (ed.status != StatusTypeRole.move || targetX != x || targetY != y)
				{
					if (range != 0) range = 0;
					if (ed.lock) ed.lock = false;
					if (target != null) target = null;
					targetX = x;
					targetY = y;
					//移动的时候不能释放技能
					if (ed.ai.skillFire)
					{
						ed.ai.skillStop();
					}
					ed.ai.oldSkill = null;
					getLineAngle(x, y, true);
					this.timeStart = ed.u.engine.time.timeGame;
					return true;
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
			if (canMove())
			{
				//如果正在移动,并且目标也是自己,就不用在计算这个了
				if(ed.status != StatusTypeRole.move || this.target != target)
				{
					dragGoX = ed.x + ed.hit_r_x;
					dragGoY = ed.y + ed.hit_r_y;
					if (ed.hit_h)
					{
						dragGoX = ed.hit_r / 2 + dragGoX;
						dragGoY = ed.hit_h / 2 + dragGoY;
					}
					//算出距离
					var dist:int = SearchTargetRole.pointHitRangeCountInt(dragGoX, dragGoY, target);
					if (dist > range)
					{
						//不能跳跃,并且是地面目标
						if (ed.info.typeProperty == 1 && ed.info.canJump == false)
						{
							//查看中间是否有障碍物,如果连线有,就不去攻击这个目标
							if (LineInRect.pointLine(ed.u.engine.astar, dragGoX, dragGoY, target, range))
							{
								ed.ai.hatred.removeAll();
								stop();
								return;
							}
						}
						var x:Number = target.x + target.hit_r_x;
						var y:Number = target.y + target.hit_r_y;
						if (target.hit_h)
						{
							x = target.hit_r / 2 + x;
							y = target.hit_h / 2 + y;
						}
						getLineAngle(x, y, true);
						this.timeStart = ed.u.engine.time.timeGame;
						//移动的时候不能释放技能
						if (ed.ai.skillFire)
						{
							ed.ai.skillStop();
						}
						ed.ai.oldSkill = null;
						ed.lock = lock;
						this.target = target;
						this.range = range;
						if (targetX != 9999999) targetX = 9999999;
						if (targetY != 9999999) targetY = 9999999;
					}
				}
			}
		}
		
		/**
		 * 将本物体和目标连线,获取角度和弧度
		 * @param	x
		 * @param	y
		 */
		private function getLineAngle(x:int, y:int, isMove:Boolean):void
		{
			//射程离目标距离远,就走过去,产生一个方向的速度向量
			if (ed.x == x && ed.y == y)
			{
				//可以绕过
				angle = ed.angle;
				radian = MathTools.PI180 * angle;
			}
			else if (ed.x == x)//竖着相等
			{
				if (ed.y < y)// 向下走
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
			else if (ed.y == y)//横向相等
			{
				if (ed.x < x)//向右走
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
				radian = Math.atan2(ed.y - y, ed.x - x) + Math.PI;
				angle = radian * MathTools.PI1802;
				angle = angle % 360;
				if (angle < 0) angle += 360;
			}
			if (isMove)
			{
				if (int(angle) != ed.angle)
				{
					ed.angle = int(angle);
					if (ed.status != StatusTypeRole.move)
					{
						ed.status = StatusTypeRole.move;
						ed.displayStartTime = ed.u.engine.time.timeGame;
					}
					EDRoleToolsSkin.changeSkin(ed, ed.u.modeTurn);
				}
				else if (ed.status != StatusTypeRole.move)
				{
					ed.status = StatusTypeRole.move;
					ed.displayStartTime = ed.u.engine.time.timeGame;
					EDRoleToolsSkin.changeSkin(ed, ed.u.modeTurn);
				}
			}
			else
			{
				if (int(angle) != ed.angle)
				{
					ed.angle = int(angle);
					if (ed.status != StatusTypeRole.patrol)
					{
						ed.status = StatusTypeRole.patrol;
						ed.displayStartTime = ed.u.engine.time.timeGame;
					}
					EDRoleToolsSkin.changeSkin(ed, ed.u.modeTurn);
				}
				else if (ed.status != StatusTypeRole.patrol)
				{
					ed.status = StatusTypeRole.patrol;
					ed.displayStartTime = ed.u.engine.time.timeGame;
					EDRoleToolsSkin.changeSkin(ed, ed.u.modeTurn);
				}
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
				if (timeStart == 0)
				{
					timeStart = u.engine.time.timeGame;
				}
				else if (timeStart != u.engine.time.timeGame)
				{
					if (doTarget && target)
					{
						if (target.isLive)
						{
							//算出距离
							dragGoX = ed.x + ed.hit_r_x;
							dragGoY = ed.y + ed.hit_r_y;
							if (ed.hit_h)
							{
								dragGoX += ed.hit_r / 2;
								dragGoY += ed.hit_h / 2;
							}
							if (SearchTargetRole.pointHitRangeCountInt(dragGoX, dragGoY, target) > range)
							{
								//不能跳跃,并且是地面目标
								//查看中间是否有障碍物,如果连线有,就不去攻击这个目标
								var x:Number = target.x + target.hit_r_x;
								var y:Number = target.y + target.hit_r_y;
								if (target.hit_h)
								{
									x = target.hit_r / 2 + x;
									y = target.hit_h / 2 + y;
								}
								if (ed.info.typeProperty == 1 && ed.info.canJump == false)
								{
									if (LineInRect.pointLine(u.engine.astar, dragGoX, dragGoY, target, range))
									{
										ed.ai.hatred.removeAll();
										stop();
										return false;
									}
								}
								//执行围对象的算法
								dragGoX = x;
								dragGoY = y;
								getLineAngle(x, y, true);
								if (moveHandle(u))
								{
									return true;//没有移动完毕
								}
								else
								{
									stop();//已经移动完毕,所以可以停下来
									return false;
								}
							}
							else
							{
								stop();//已经在射程内,可以攻击,所以停止
								return false;
							}
						}
						else
						{
							stop();//怪物已经死亡
							return false;
						}
					}
					else if (targetX != 9999999 || targetY != 9999999)
					{
						//算出新的角度值
						getLineAngle(targetX, targetY, true);
						dragGoX = targetX;
						dragGoY = targetY;
						if (moveHandle(u))
						{
							return true;
						}
						else
						{
							stop();
							return false;
						}
					}
					else if (patrolPoint.x != 9999999)
					{
						if (patrolPointTime != u.engine.time.timeGame)
						{
							//算出新的角度值
							MovePhysPatrol.getPoint(ed, patrolPoint);
							if (patrolPoint.x != 9999999)
							{
								patrolPointTime = u.engine.time.timeGame;
							}
							else if (patrolPointTime)
							{
								patrolPointTime = 0;
							}
						}
						if (patrolPoint.x != 9999999)
						{
							getLineAngle(patrolPoint.x, patrolPoint.y, false);
							dragGoX = patrolPoint.x;
							dragGoY = patrolPoint.y;
							if (moveHandle(u))
							{
								return true;
							}
						}
						stop();
						return false;
					}
				}
			}
			else
			{
				stop();
			}
			return false;
		}
		
		/**
		 * 运行行走的算法
		 * 会计算撞到的对象
		 * @param	moveDistMax		还剩余可以行走的距离,或者是最大行走距离
		 * @return	是否运行完毕, 如果是true,没有移动完毕
		 */
		private function moveHandle(u:UpGame, moveDistMax:Number = -1, maxDo:Boolean = false):Boolean
		{
			if (moveDistMax == -1)
			{
				moveDistMax = ed.info.speedDist;
			}
			//先要处理击退
			if (dragOutDist)
			{
				//被挤压是最高优先级,然后才是击退
				//dragAngle
				//dragOutDist
				throw new Error("还未完成");
				return false;
			}
			else
			{
				if (inNeed)
				{
					_x = dragNeedX;
					_y = dragNeedY;
				}
				else
				{
					if (dragPhysX)
					{
						_x = dragPhysX;
					}
					else
					{
						_x = dragGoX - ed.x;
					}
					if (dragPhysY)
					{
						_y = dragPhysY;
					}
					else
					{
						_y = dragGoY - ed.y;
					}
				}
				/*
				if (dragNeedX)
				{
					_x = dragNeedX;
				}
				else if (dragPhysX)
				{
					_x = dragPhysX;
				}
				else
				{
					_x = dragGoX - ed.x;
				}
				if (dragNeedY)
				{
					_y = dragNeedY;
				}
				else if (dragPhysY)
				{
					_y = dragPhysY;
				}
				else
				{
					_y = dragGoY - ed.y;
				}
				*/
				//对XY,进行运算
				var dist:Number;
				if (_x == 0 && _y == 0)
				{
					dist = 0;
				}
				else if (_x == 0)
				{
					if (_y < 0)
					{
						dist = -_y;
					}
					else
					{
						dist = _y;
					}
				}
				else if (_y == 0)
				{
					if (_x < 0)
					{
						dist = -_x;
					}
					else
					{
						dist = _x;
					}
				}
				else
				{
					dist = Math.sqrt(_x * _x + _y * _y);
				}
				if (dist != 0)
				{
					if (dist > moveDistMax)
					{
						//distMax 使用这个值算距离
						if (_x)
						{
							_x = moveDistMax / dist * _x;
						}
						if (_y)
						{
							_y = moveDistMax / dist * _y;
						}
						dist = moveDistMax;
						moveDistMax = 0;
					}
					else
					{
						//dist 使用这个值算距离
						moveDistMax = moveDistMax - dist;
						if (moveDistMax < MovePhysPatrol.space)
						{
							moveDistMax = 0;
						}
					}
					//根据是否可以通行来运算出是否设置这个坐标值
					if (ed.info.typeProperty == 1)
					{
						if (_y)
						{
							ed.y = ed.y + _y;
						}
						if (_x)
						{
							if (dragNeedX)
							{
								ed.x = ed.x + _x;
							}
							else
							{
								if (astar.isPass(ed.x, ed.y, 1) == false)
								{
									ed.x = ed.x + _x;
								}
								else if (astar.isPass(ed.x + _x, ed.y, 1))
								{
									ed.x = ed.x + _x;
								}
								else
								{
									ed.x = ed.x + _x;
								}
							}
						}
					}
					else
					{
						if (_x) ed.x = ed.x + _x;
						if (_y) ed.y = ed.y + _y;
					}
					//算出开始的行走比例,然后
					if (targetX != 9999999 || targetY != 9999999)
					{
						if ((int(ed.x) == targetX || Math.ceil(ed.x) == targetX || Math.floor(ed.x) == targetX) && (int(ed.y) == targetY || Math.ceil(ed.y) == targetY || Math.floor(ed.y) == targetY))
						{
							ed.x = targetX;
							ed.y = targetY;
							return false;
						}
						else
						{
							return true;
						}
					}
				}
			}
			return false;
		}
		
		/** 只运行挤压部分 **/
		internal function moveNeed(u:UpGame):void
		{
			//先要处理击退
			if(dragOutDist == 0)
			{
				if (inNeed)
				{
					_x = dragNeedX;
					_y = dragNeedY;
				}
				else if(inPhys)
				{
					_x = dragPhysX;
					_y = dragPhysY;
				}
				else
				{
					return;
				}
				var dist:Number = Math.sqrt(_x * _x + _y * _y);
				if (dist > ed.info.speedDist)
				{
					//distMax 使用这个值算距离
					if (_x)
					{
						_x = ed.info.speedDist / dist * _x;
					}
					if (_y)
					{
						_y = ed.info.speedDist / dist * _y;
					}
					dist = ed.info.speedDist;
				}
				//根据是否可以通行来运算出是否设置这个坐标值
				if (dist)
				{
					if (ed.info.typeProperty == 1)
					{
						if (u.random > 0.5)
						{
							if (_x)
							{
								if (astar.isPass(ed.x, ed.y, 1) == false)
								{
									ed.x = ed.x + _x;
								}
								else if (astar.isPass(ed.x + _x, ed.y, 1))
								{
									ed.x = ed.x + _x;
								}
								else
								{
									_y += _x;
								}
							}
							if (_y)
							{
								ed.y = ed.y + _y;
							}
						}
						else
						{
							if (_y)
							{
								if (astar.isPass(ed.x, ed.y, 1) == false)
								{
									ed.y = ed.y + _y;
								}
								else if (astar.isPass(ed.x, ed.y + _y, 1))
								{
									ed.y = ed.y + _y;
								}
								else
								{
									_x += _y;
								}
							}
							if (_x)
							{
								ed.x = ed.x + _x;
							}
						}
					}
					else
					{
						if (_x) ed.x = ed.x + _x;
						if (_y) ed.y = ed.y + _y;
					}
				}
			}
		}
	}
}