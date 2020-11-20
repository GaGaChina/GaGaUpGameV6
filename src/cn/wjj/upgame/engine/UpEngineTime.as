package cn.wjj.upgame.engine 
{
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.upgame.common.RecordType;
	import cn.wjj.upgame.common.StatusEngineType;
	import cn.wjj.upgame.common.StatusTypeRole;
	import cn.wjj.upgame.common.UpGameEvent;
	import cn.wjj.upgame.data.CardInfoModel;
	import cn.wjj.upgame.data.UpGameData;
	import cn.wjj.upgame.report.UpReport;
	import cn.wjj.upgame.tools.GameReSet;
	import cn.wjj.upgame.tools.MovePhysPush;
	import cn.wjj.upgame.tools.ReleaseCard;
	import cn.wjj.upgame.UpGame;
	import cn.wjj.upgame.UpGameConfig;
	
	/**
	 * 驱动器的模拟时间模块
	 * 
	 * @author GaGa
	 */
	public class UpEngineTime 
	{
		/** 结束暂停需要的时间 **/
		private static const overStopTime:int = 3000;
		
		/** 父引用 **/
		public var u:UpGame;
		/** 驱动的引用 **/
		public var engine:UpEngine;
		/** 正在运行第几轮,从1开始 **/
		public var round:int = 0;
		/** 本轮是否运行完成 **/
		public var roundOver:Boolean = true;
		/** 记录每帧的crc信息 **/
		public var crcFrame:Array;
		/**
		 * 发动机运行数据的时候执行的是什么样的FPS
		 * 每次运行多少毫秒,比FPS60要快一些
		 */
		public var timeFrame:uint = 30;
		/** 启动的时间点,用engineTime - startTime 得到这个章节所使用的时间 **/
		public var timeStart:uint = 0;
		/** 在战斗中所累计战斗的时候 **/
		public var timeGame:uint = 0;
		/** 游戏运行时间 **/
		public var timeEngine:uint = 0;
		/** 是否启用时间校验, 严格追赶和等待时间 **/
		public var timeCheck:Boolean = false;
		/** 游戏开始的时候获取的系统的时间,并且会和服务器的时间进行核对(这个是真实时间) **/
		public var timeStartBase:Number = -1;
		/** 需要追加的时间数量,当欠时间的时候,就需要追加时间 **/
		public var timeEngineTo:int;
		/** 多少毫秒内忽略追加,防止频繁追加 **/
		internal var timeMiniTo:int = 90;
		
		/** (累计 timeGame)游戏的真实时间 **/
		public var timeReal:int = 0;
		/** (累计 timeGame)游戏的真实时间,临时累加用 **/
		private var timeRealTemp:Number = 0;
		/** 游戏里的真实时间和游戏时间的比例 **/
		public var timeScale:Number = 1;
		/** 游戏能量条的增长速度 **/
		public var timeEnergyScale:Number = 1;
		
		/** 死亡动画播放完毕的驱动时间 **/
		public var timeFollowUp:int = 0;
		/** 显示对象的播放速度 **/
		public var displaySpeed:Number = 1;
		/** 显示对象每次运行的时间 **/
		public var displayFrame:Number = 0;
		/** 显示驱动器上一次处理的时间 **/
		private var timePrev:Number = 0;
		/** 显示驱动器下一次处理的时间 **/
		private var timeNext:Number = 0;
		/** 是否已经清理了Camp内容,标识是否已经执行了结束战斗 **/
		private var clearCamp:Boolean = false;
		
		/** 到特定时间engineTime的时候执行特定函数 o[56789] = Function **/
		private var timeMethod:Object;
		/** 队列的数量 **/
		private var timeMethodLength:int = 0;
		/** 要重新运行到什么时间点 **/
		public var timeGameReGo:int = 0;
		/** 如果有心跳包,那么时间最多运行到什么时间点 **/
		public var timeHeartMax:uint;
		/** 心跳包的操作频率 **/
		public var timeHeartMethod:Function;
		/** 每个EnterFrame只能发一个心跳包 **/
		public var timeHeartFrame:Boolean = false;
		/** 现在服务器心跳包的ID **/
		public var timeHeartNext:uint;
		/** 心跳包对比CRC失败的时候触发函数 **/
		public var timeHeartErrorMethod:Function;
		
		public function UpEngineTime(u:UpGame, engine:UpEngine)
		{
			this.u = u;
			this.engine = engine;
			crcFrame = g.speedFact.n_array();
			setStageFPS();
		}
		
		/** 根据现在场景里的FPS来设置这个FPS **/
		public function setStageFPS(fps:Number = 0):void
		{
			if (fps == 0) fps = g.status.stageFPS;
			displayFrame = 1000 / fps;
		}
		
		/** 添加特定时间点timeGame,运行前需要执行的函数,并且自动删除 **/
		public function addTimeMethod(doTime:int, method:Function):void
		{
			if (timeMethod == null) timeMethod = new Object();
			if (timeMethod.hasOwnProperty(doTime))
			{
				if (timeMethod[doTime] is Function)
				{
					var a:Array = g.speedFact.n_array();
					a.push(timeMethod[doTime]);
					a.push(method);
					timeMethod[doTime] = a;
				}
				else
				{
					timeMethod[doTime].push(method);
				}
			}
			else
			{
				timeMethod[doTime] = method;
				timeMethodLength++;
			}
		}
		
		/**
		 * 服务器上的现在的时间
		 * @param	time
		 */
		public function serverTimes(time:int, crcIndex:uint = 0, crc:uint = 0):void
		{
			if (timeCheck)
			{
				timeEngineTo = int((new Date().time - timeStartBase) / timeFrame) * timeFrame;
			}
			timeHeartNext = int(time / timeFrame) * timeFrame;
			timeHeartMax = timeHeartNext + UpGameConfig.timeInfoSend;
			//心跳包是回包,下一次是这次的累加
			timeHeartNext = timeHeartNext + UpGameConfig.timeHeartSend;
			if (timeCheck)
			{
				if (timeEngineTo > time)
				{
					//查看超过多少,多了就有问题
					timeEngineTo = int(time / timeFrame) * timeFrame;
					timeStartBase = new Date().time - timeEngineTo;
				}
				else if (timeEngineTo < time)
				{
					timeEngineTo = int(time / timeFrame) * timeFrame;
					timeStartBase = new Date().time - timeEngineTo;
				}
			}
			if (crcIndex)
			{
				if (u.modeTurn)
				{
					engine.camp1.heartCRC[String(crcIndex)] = crc;
				}
				else
				{
					engine.camp2.heartCRC[String(crcIndex)] = crc;
				}
				checkTurn(crcIndex);
			}
		}
		
		/** 发送第一个心跳包 **/
		public function startSendHeart():void
		{
			if (timeHeartMethod != null && timeGame == 0)
			{
				timeHeartMethod();
				timeHeartNext = UpGameConfig.timeHeartSend;
				timeHeartMax = UpGameConfig.timeInfoSend;
			}
		}
		
		/** CRC校验失败 **/
		private function checkTurn(crcId:uint):void
		{
			if (engine.camp1.heartCRC.hasOwnProperty(crcId) && engine.camp2.heartCRC.hasOwnProperty(crcId)
			&& engine.camp1.heartCRC[String(crcId)] != engine.camp2.heartCRC[String(crcId)])
			{
				g.log.pushLog(this, LogType._ErrorLog, "战斗校验失败,暂停游戏:" + crcId + " " + engine.camp1.heartCRC[String(crcId)] + " " + engine.camp2.heartCRC[String(crcId)]);
				/*
				if (engine.type == StatusEngineType.start && engine.isGameOver == false && timeHeartMethod != null)
				{
					timeHeartMethod();
				}
				*/
				if (timeHeartErrorMethod != null)
				{
					timeHeartErrorMethod(crcId, engine.camp1.heartCRC[crcId], engine.camp2.heartCRC[crcId]);
					timeHeartErrorMethod = null;
				}
				//测试代码
				//throw new Error("出错啦");
			}
		}
		
		/** 终止游戏/结束游戏 **/
		internal function over():void
		{
			g.event.removeEnterFrame(enterFrame);
		}
		
		internal function checkOver():void
		{
			if (engine.isGameOver)
			{
				if (u.readerStart)
				{
					if (clearCamp == false)
					{
						clearCamp = true;
						engine.advanceWinCampId(engine.isWin);
						engine.type = StatusEngineType.live;
					}
					else if (timeFollowUp <= timeEngine)
					{
						if (engine.isTimeOver)
						{
							engine.timeover();
						}
						else
						{
							engine.over();
						}
					}
				}
				else
				{
					if (engine.isTimeOver)
					{
						engine.timeover();
					}
					else
					{
						engine.over();
					}
				}
			}
		}
		
		/** 运行全部的时间到达函数 **/
		internal function runAllTimeMethod():void
		{
			if (timeMethodLength)
			{
				var method:Function;
				for (var doTime:String in timeMethod)
				{
					if (timeMethod[doTime] is Function)
					{
						timeMethod[doTime]();
					}
					else
					{
						for each (method in timeMethod[doTime]) 
						{
							method();
						}
						g.speedFact.d_array(timeMethod[doTime]);
					}
					delete timeMethod[doTime];
					timeMethodLength--;
				}
				if (timeMethodLength == 0)
				{
					timeMethod = null;
				}
			}
		}
		
		/** 删除全部的未执行的操作函数 **/
		internal function removeAllTimeMethod():void
		{
			if (timeMethodLength)
			{
				var method:Function;
				for (var doTime:String in timeMethod)
				{
					if (timeMethod[doTime] is Array)
					{
						g.speedFact.d_array(timeMethod[doTime]);
					}
					delete timeMethod[doTime];
					timeMethodLength--;
				}
				if (timeMethodLength == 0)
				{
					timeMethod = null;
				}
			}
		}
		
		/** 运行下一帧 **/
		private function nextFrame():void
		{
			round++;
			timeEngine += timeFrame;
			var camp:EDCamp;
			if (engine.type == StatusEngineType.start)
			{
				crcFrame.push(u.report.crc);
				if (UpReport.startFrameCheck)
				{
					u.report.enterFrame();
				}
				timeGame += timeFrame;
				if (timeScale == 1)
				{
					timeReal = timeGame;
				}
				else
				{
					timeRealTemp += timeFrame * timeScale;
					timeReal = int(timeRealTemp);
				}
				if (engine.isGameOver == false)
				{
					if (u.modeAttack)
					{
						//发送心跳包
						if (timeHeartNext == timeGame && timeHeartMethod != null)
						{
							timeHeartNext = timeGame + UpGameConfig.timeHeartSend;
							if (timeHeartFrame == false)
							{
								timeHeartFrame = true;
								timeHeartMethod();
							}
						}
						var crcId:int = int((crcFrame.length - 1) / 33) * 33;
						if (u.modeTurn)
						{
							engine.camp2.heartCRC[crcId] = crcFrame[crcId];
						}
						else
						{
							engine.camp1.heartCRC[crcId] = crcFrame[crcId];
						}
						checkTurn(crcId);
						if (engine.campLib.length == 2)
						{
							var addEnergy:Number = timeFrame / timeEnergyScale / 1000;
							engine.camp1.addEnergy(addEnergy);
							engine.camp2.addEnergy(addEnergy);
						}
						else
						{
							throw new Error("未实现");
						}
					}
					//查看是否有怪物队列时间到了要刷出来
					if (engine.nextRoundMethod != null)
					{
						//按照时间循序进行自动刷怪
						var tempInt:int = 0;
						for (var i:int = 0; i < engine.roundGroupLength; i++) 
						{
							tempInt = engine.roundGroupTimeNext[i];
							if (tempInt != 0 && tempInt < timeEngine)
							{
								engine.roundGroupTimeNext[i] = 0;
								//本轮时间到了,需要刷新怪了
								tempInt = engine.roundGroupItemComplete[i];
								tempInt++;
								if (engine.roundGroupItemlength[i] > tempInt)
								{
									engine.roundGroupItemComplete[i] = tempInt;
									engine.nextRoundMethod(i, tempInt);
								}
							}
						}
					}
				}
			}
			//查看是否有特定要执行的函数
			if (timeMethodLength)
			{
				var method:Function;
				for (var doTime:String in timeMethod)
				{
					if (int(doTime) <= timeGame)
					{
						if (timeMethod[doTime] is Function)
						{
							timeMethod[doTime]();
						}
						else
						{
							for each (method in timeMethod[doTime]) 
							{
								method();
							}
							g.speedFact.d_array(timeMethod[doTime]);
						}
						delete timeMethod[doTime];
						timeMethodLength--;
					}
				}
				if (timeMethodLength == 0)
				{
					timeMethod = null;
				}
			}
			roundOver = false;
			//遍历全部的对象,看对象们都在干嘛
			var action:Object;
			if (u.recordStart && u.record.actionLength && u.record.action.hasOwnProperty(timeGame))
			{
				action = u.record.action[timeGame];
				delete u.record.action[timeGame];
				u.record.actionLength--;
			}
			//提前运算全部的对象,计算出各自的强行碰撞区域和,适量力量数据
			if (u.modeMovePhys) MovePhysPush.start(u);
			if (engine.campLib.length == 2)
			{
				if (action && action.hasOwnProperty("1"))
				{
					runAction(engine.camp1, action["1"]);
				}
				engine.camp1.aiRun();
				if (action && action.hasOwnProperty("2"))
				{
					runAction(engine.camp2, action["2"]);
				}
				engine.camp2.aiRun();
			}
			else
			{
				for each (camp in engine.campLib) 
				{
					if (action && action.hasOwnProperty(camp.camp))
					{
						runAction(camp, action[camp.camp]);
					}
					camp.aiRun();
				}
			}
			if (engine.isGameOver)
			{
				roundOver = true;
				//不停的检测任务是否完成
				if (u.taskStart && u.task.runLength)
				{
					u.task.enterFrame();
				}
			}
			else
			{
				if (engine.type == StatusEngineType.start)
				{
					if (engine.campLib.length == 2)
					{
						engine.camp1.aiTarget();
						if (engine.type == StatusEngineType.start)
						{
							engine.camp2.aiTarget();
						}
					}
					else
					{
						for each (camp in engine.campLib) 
						{
							//中途可能结束战斗,把子弹清理掉,不判断,容易挂掉
							if (engine.type == StatusEngineType.start)
							{
								camp.aiTarget();
							}
							else
							{
								break;
							}
						}
					}
				}
				roundOver = true;
				//不停的检测任务是否完成
				if (u.taskStart && u.task.runLength)
				{
					u.task.enterFrame();
				}
				engine.checkState();
				checkGameWin();
			}
		}
		
		/** 临时算碰撞的时候所用距离 **/
		private static var ax:Number;
		private static var ay:Number;
		private static var bx:Number;
		private static var by:Number;
		private static var dx:Number;
		private static var dy:Number;
		/** ab之间的碰撞体距离 **/
		private static var ab_hit_dist:uint;
		/** 碰撞的时候ab之间的距离 **/
		private static var ab_dist:Number;
		
		/** 飞行角度 **/
		private static var r:Number;
		/** 飞行曲度 **/
		private static var ra:Number;
		
		private static var outMax:uint = 20;
		private static var outRun:Number;
		
		/**
		 * a和b互相碰撞
		 * @param	a
		 * @param	b		被撞物体
		 * @param	same	质量是否相同,false:a质量大,true:相同
		 */
		private function collide(a:EDRole, b:EDRole, same:Boolean):void
		{
			if (a.hit_h == 0 && b.hit_h == 0)
			{
				//先改方向
				ax = a.x + a.hit_r_x;
				ay = a.y + a.hit_r_y;
				bx = b.x + b.hit_r_x;
				by = b.y + b.hit_r_y;
				dx = ax - bx;
				dy = ay - by;
				ab_hit_dist = a.hit_r + b.hit_r;
				ab_dist = ab_hit_dist - Math.sqrt(dx * dx + dy * dy);
				if (ab_dist > 10)
				{
					r = (Math.atan2(dy, dx) + Math.PI) * 180 / Math.PI;
					r = r % 360;
					if (r < 0) r += 360;
					ra = r / 180 * Math.PI;
					if (same)
					{
						//制作偏移方向
						if (r > a.angle)
						{
							if (r - 15 < a.angle)
							{
								r += 45;
							}
						}
						else if(r < a.angle)
						{
							if (r + 15 > a.angle)
							{
								r += 45;
							}
						}
						else
						{
							r += 45;
						}
						r = r % 360;
						if (r < 0) r += 360;
						ra = r / 180 * Math.PI;
						outRun = Math.ceil(ab_dist / 2);
						if (outRun > outMax / 2)
						{
							outRun = outMax / 2;
						}
					}
					else
					{
						outRun = Math.ceil(ab_dist);
						if (outRun > outMax)
						{
							outRun = outMax;
						}
					}
					if (same)
					{
						a.x = int( -Math.cos(ra) * outRun + a.x);
						a.y = int( -Math.sin(ra) * outRun + a.y);
						if (a.status == StatusTypeRole.move || a.status == StatusTypeRole.patrol)
						{
							b.ai.move.stop();
						}
					}
					b.x = int(Math.cos(ra) * outRun + b.x);
					b.y = int(Math.sin(ra) * outRun + b.y);
					if (b.status == StatusTypeRole.move || b.status == StatusTypeRole.patrol)
					{
						b.ai.move.stop();
					}
				}
			}
			else
			{
				g.log.pushLog(this, LogType._ErrorLog, "未实现本算法");
			}
		}
		
		/**
		 * 执行动作,并把完成的写入到日志里
		 * @param	camp
		 * @param	list
		 */
		private function runAction(camp:EDCamp, list:Array):void
		{
			for each (var item:Object in list) 
			{
				runActionItem(camp, item, timeGame);
			}
		}
		
		/**
		 * 执行动作,并把完成的写入到日志里
		 * @param	camp
		 * @param	item
		 * @param	time	加入日志的时间
		 */
		public function runActionItem(camp:EDCamp, item:Object, time:int):void
		{
			var role:EDRole;
			var target:EDRole;
			var live:Object;
			var liveList:Array;
			var isRun:Boolean = false;
			var skill:AIRoleSkill;
			var event:UpGameEvent;
			var player:EDCampPlayer;
			var camp:EDCamp;
			switch (item.type) 
			{
				case RecordType.ReleaseCard:
					if (item.xyType == 1)
					{
						ReleaseCard.callCardPosXY(u, item.id, 0, item.playerId, item.camp, item.x, item.y);
					}
					else if (item.xyType == 2)
					{
						ReleaseCard.callCardXY(u, item.id, 0, item.playerId, item.camp, item.x, item.y);
					}
					for each (camp in u.engine.campLib) 
					{
						if (camp.playerLength && camp.playerObj.hasOwnProperty(item.playerId))
						{
							player = camp.playerObj[item.playerId];
							if (player.using && item.del)
							{
								//进行扣费处理
								var cardInfo:CardInfoModel = UpGameData.cardInfo.getItem("card_id", item.id);
								if (cardInfo && cardInfo.ManaCost)
								{
									player.energyUse -= cardInfo.ManaCost;
									player.energyTemp -= cardInfo.ManaCost;
									player.energyValue -= cardInfo.ManaCost;
								}
							}
							break;
						}
					}
					isRun = true;
					break;
				case RecordType.ChangeCard:
					for each (camp in u.engine.campLib) 
					{
						if (camp.playerLength && camp.playerObj.hasOwnProperty(item.playerId))
						{
							player = camp.playerObj[item.playerId];
							if (player.using && item.id)
							{
								switch (item.id) 
								{
									case player.card1:
										player.card1 = player.cardNext;
										player.cardNext = item.next;
										player.card1Time = item.dtime;
										player.card1TimeUse = 0;
										break;
									case player.card2:
										player.card2 = player.cardNext;
										player.cardNext = item.next;
										player.card2Time = item.dtime;
										player.card2TimeUse = 0;
										break;
									case player.card3:
										player.card3 = player.cardNext;
										player.cardNext = item.next;
										player.card3Time = item.dtime;
										player.card3TimeUse = 0;
										break;
									case player.card4:
										player.card4 = player.cardNext;
										player.cardNext = item.next;
										player.card4Time = item.dtime;
										player.card4TimeUse = 0;
										break;
								}
							}
							break;
						}
					}
					break;
				case RecordType.SelectCard:
					if (u.modeRecord)
					{
						event = new UpGameEvent(UpGameEvent.selectCard);
						event.info = g.speedFact.n_object();
						event.info.playerId = item.playerId;
						event.info.index = item.index;
						event.info.camp = item.camp;
						u.dispatchEvent(event);
					}
					isRun = true;
					break;
				case RecordType.ChangeEnergyScale:
					timeEnergyScale = item.energyScaleSpeed;
					isRun = true;
					break;
				case RecordType.MovePoint:
					role = getEDRole(camp, item.id);
					if (role)
					{
						isRun = role.ai.move.movePoint(item.x, item.y, item.lock);
					}
					break;
				case RecordType.MoveStop:
					role = getEDRole(camp, item.id);
					if (role)
					{
						isRun = true;
						role.ai.move.stop();
					}
					break;
				case RecordType.ChangePoint:
					role = getEDRole(camp, item.id);
					if (role)
					{
						isRun = true;
						role.x = item.x;
						role.y = item.y;
						role.ai.startAppear();
					}
					break;
				case RecordType.SelectTarget:
					role = getEDRole(camp, item.id);
					target = getEDRole(camp, item.target);
					if (role && target && target.isLive)
					{
						isRun = true;
						role.ai.move.stop();
						role.ai.changeTarget(target);
						role.ai.hatred.priorityTarget = target;
					}
					break;
				case RecordType.FindHitRole:
					role = getEDRole(camp, item.id);
					if (role)
					{
						if (item.target)
						{
							target = getEDRole(camp, item.target);
							if (target && target.isLive)
							{
								isRun = true;
								role.ai.findHitRole(target);
							}
						}
						else
						{
							isRun = true;
							role.ai.findHitRole(target);
						}
					}
					break;
				case RecordType.ReleaseSkill:
					role = getEDRole(camp, item.id);
					if (role && role.ai.canFireIndex(item.index, true) == 0)
					{
						role.ai.move.stop();
						skill = role.ai.aiSkill[item.index];
						if (skill && role.ai.fireSkill(skill, true))
						{
							isRun = true;
						}
					}
					break;
				case RecordType.ClearHatred:
					role = getEDRole(camp, item.id);
					if (role && role.isLive && role.info.isAuto == false)
					{
						role.ai.hatred.removeAll();
						isRun = true;
					}
					break;
				default:
					g.log.pushLog(this, LogType._ErrorLog, "找不到操作日志类型:");
			}
			if (isRun)
			{
				if (u.record.live.hasOwnProperty(time) == false)
				{
					live = g.speedFact.n_object();
					u.record.live[time] = live;
				}
				else
				{
					live = u.record.live[time];
				}
				if (live.hasOwnProperty(camp.camp) == false)
				{
					liveList = g.speedFact.n_array();
					live[camp.camp] = liveList;
				}
				else
				{
					liveList = live[camp.camp];
				}
				liveList.push(item);
				u.record.liveLength++;
			}
		}
		
		
		/** 通过ServerID获取EDRole **/
		private function getEDRole(camp:EDCamp, serverId:uint):EDRole
		{
			if (camp.lengthRole)
			{
				for each (var role:EDRole in camp.listRole) 
				{
					if (role && role.info && role.info.serverId == serverId)
					{
						return role;
					}
				}
			}
			return null;
		}
		
		/** [只针对于阵营2目标]运行下一波怪物,成功召唤下波返回true,否则返回false **/
		internal function runNextRound():Boolean
		{
			var out:Boolean = false;
			if (engine.isGameOver == false && engine.nextRoundMethod != null && engine.roundGroupComplete < engine.roundGroupLength)
			{
				var round:int;
				for (var group:int = 0; group < engine.roundGroupLength; group++)
				{
					if (engine.roundGroupRoleLength[group] <= 0)
					{
						//本轮已经没有啦,要加新的
						round = engine.roundGroupItemComplete[group];
						round++;
						if (engine.roundGroupItemlength[group] > round)
						{
							engine.roundGroupItemComplete[group] = round;
							engine.nextRoundMethod(group, round);
							out = true;
						}
					}
				}
			}
			return out;
		}
		
		/**
		 * 时间的判断
		 * 
		 * 我方人员全部死亡(直接结束战斗)
		 * 杀死全部怪物(胜利,需要多重判断)
		 * 还要判断是否替补也全部没有了
		 * 
		 * 
		 * 时间为负数	: 坚持这么长时间(胜利,需要多重判断) engine.winLiveTime_OK = true
		 * 时间为0		: 时间任意,不用进行判断
		 * 时间为正数	: 时间到的时候就结束战斗,失败 engine.isTimeOver
		 * 
		 * 任务必须完成的已经完成 if (u.taskStart == false || u.task.lengthMust == 0)
		 * 
		 * 击杀必须要杀死的怪物 engine.winKillId_OK
		 * 
		 * 判断游戏是否结束,设置游戏是否胜利
		 * 
		 * 每个节点上的信息运行, true:结束了, false:还需要运行
		 * @return
		 */
		internal function checkGameWin():void
		{
			if (engine.winClient && engine.isGameOver == false && engine.type == StatusEngineType.start)
			{
				//使用新的算法,值看camp 1 和 camp 2 2个阵营
				//检测我方人员是否已经死光光
				if (engine.camp1.lengthRole == 0 && engine.camp1.benchLength == 0)
				{
					engine.isWin = 2;
					if (engine.camp1.benchTime < timeEngine)
					{
						engine.isGameOver = true;
						if (timeHeartMethod != null)
						{
							timeHeartMethod();
						}
						return;
					}
				}
				//检测敌方人员是否死光光
				var campClear:Boolean = false;
				if (engine.camp2.lengthRole == 0 && engine.camp2.benchLength == 0)
				{
					if (engine.camp2.benchTime < timeEngine)
					{
						//查看是否有下一波的怪物,如果没有怪物,并没有了剩余其他怪物,那我方胜利
						if (runNextRound())
						{
							campClear = false;
						}
						else
						{
							campClear = true;
						}
					}
				}
				//检测是否有必须完成的任务
				var task_OK:Boolean = false;
				if (u.taskStart == false || u.task.lengthMust == 0)
				{
					task_OK = true;
				}
				if (engine.winLiveTime)
				{
					//查看坚持时间是否到了
					if (engine.winLiveTime_OK == false && timeReal >= engine.winLiveTime)
					{
						engine.winLiveTime_OK = true;
						engine.isGameOver = true;
						if (engine.winKillId_OK && task_OK)
						{
							engine.isWin = 1;
							engine.advanceWinCampId(1);
						}
						else
						{
							engine.isWin = 2;
							engine.advanceWinCampId(2);
						}
					}
				}
				else if (engine.winOverTime != 0 && timeReal >= engine.winOverTime)
				{
					//胜利时间到了
					engine.isGameOver = true;
					engine.isTimeOver = true;
					if (u.modeAttack)
					{
						engine.advanceWinCampId(0);
					}
					else
					{
						engine.isWin = 2;
						engine.advanceWinCampId(2);
					}
				}
				else if (task_OK)
				{
					if (engine.winKillId != 0 && engine.winKillId_OK)
					{
						engine.isWin = 1;
						engine.isGameOver = true;
						engine.advanceWinCampId(1);
					}
					else if (campClear == true)
					{
						engine.isWin = 2;
						engine.isGameOver = true;
						engine.advanceWinCampId(2);
					}
				}
				if (engine.isGameOver == false && engine.winKillTower)
				{
					if (engine.camp1.towerCenter.isLive == false)
					{
						if (engine.camp2.towerCenter.isLive == false)
						{
							engine.isWin = 0;
							engine.isGameOver = true;
						}
						else
						{
							engine.isWin = 2;
							engine.isGameOver = true;
						}
					}
					else if(engine.camp2.towerCenter.isLive == false)
					{
						engine.isWin = 1;
						engine.isGameOver = true;
					}
					else if (timeGame >= engine.winKillTowerTime)
					{
						var c1:int = 0;
						var c2:int = 0;
						if (engine.camp1.towerLeft.isLive) c1++;
						if (engine.camp1.towerRight.isLive) c1++;
						if (engine.camp2.towerLeft.isLive) c2++;
						if (engine.camp2.towerRight.isLive) c2++;
						if (c1 > c2)
						{
							engine.isWin = 1;
							engine.isGameOver = true;
						}
						else if (c1 < c2)
						{
							engine.isWin = 2;
							engine.isGameOver = true;
						}
					}
				}
				if (engine.isGameOver && timeHeartMethod != null)
				{
					timeHeartMethod();
				}
			}
		}
		
		/** 屏幕刷新的时候,自动触发到显示内容模块去 **/
		internal function enterFrame():void
		{
			engine.changePlayLive = 0;
			engine.changePlayPause = 0;
			if(engine)
			{
				if (timeHeartFrame) timeHeartFrame = false;
				if (u.modeReDo && u.modeReIn == false)
				{
					g.log.pushLog(this, LogType._UserAction, "游戏重置重新启动");
					u.modeReIn = true;
					GameReSet.run(u, timeStartBase);
					var readerStart:Boolean = u.readerStart;
					u.readerStart = false;
					if (timeCheck)
					{
						while (timeGame <= timeEngineTo && engine.isGameOver == false)
						{
							nextFrame();
							checkOver();
							timeEngineTo = int((new Date().time - timeStartBase) / timeFrame) * timeFrame;
						}
					}
					else
					{
						while (engine.isGameOver == false)
						{
							nextFrame();
							checkOver();
						}
					}
					timePrev = timeGame;
					timeNext = timeGame + displayFrame * displaySpeed;
					u.readerStart = readerStart;
					//运行完毕了
					if (u && u.readerStart && u.reader)
					{
						u.reader.engineDisplay();
					}
					return;
				}
				//运行到下一个时间节点,如果不需要运行显示对象的,就直接绕过
				//************开始校对时间
				if (timeCheck)
				{
					timeEngineTo = int((new Date().time - timeStartBase) / timeFrame) * timeFrame;
				}
				//************结束校对时间
				var tempTime:int;
				if (engine.isGameOver)
				{
					//结束的时候,提供了先后延迟的动作
					while (timeEngine <= timeNext)
					{
						nextFrame();
						checkOver();
					}
					//把显示对象的时间调整过来
					timePrev = timeNext;
					timeNext += displayFrame * displaySpeed;
					checkOver();
				}
				else
				{
					if (u.readerStart)
					{
						if (timeHeartMethod == null || timeHeartMax > timeGame)
						{
							while (engine.isGameOver == false && timeNext > timePrev)
							{
								nextFrame();
								checkOver();
								//直接追到最近的时间
								if (timeCheck)
								{
									timeEngineTo = int((new Date().time - timeStartBase) / timeFrame) * timeFrame;
									if (timeNext < timeEngineTo)
									{
										timeNext = timeEngineTo;
									}
								}
								if (timeEngine > timeNext)
								{
									break;
								}
								if (timeHeartMethod != null && timeHeartMax <= timeGame)
								{
									break;
								}
							}
						}
						//把显示对象的时间调整过来
						timePrev = timeNext;
						timeNext += displayFrame * displaySpeed;
						//暂停下
						if (timeCheck && timeEngine - timeMiniTo > timeEngineTo)
						{
							timeNext = timePrev;
						}
					}
					else
					{
						//直接运行到游戏结束
						while (engine.isGameOver == false)
						{
							nextFrame();
						}
					}
				}
				//运行完毕了
				if (u && u.readerStart && u.reader)
				{
					u.reader.engineDisplay();
				}
			}
		}
		
		internal function clear():void
		{
			engine.isTimeOver = false;
			engine.isGameOver = false;
			clearCamp = false;
			if (timeGame != 0) timeGame = 0;
			if (timeReal != 0) timeReal = 0;
			if (timeRealTemp != 0) timeRealTemp = 0;
			timeStart = timeEngine;
			timePrev = timeEngine;
			timeNext = displayFrame * displaySpeed + timeEngine;
			if (crcFrame.length) crcFrame.length = 0;
		}
		
		/** 游戏重新开始 **/
		public function gameReSet():void
		{
			if (round != 0) round = 0;
			if (roundOver == false) roundOver = true;
			if (timeStart != 0) timeStart = 0;
			if (timeGame != 0) timeGame = 0;
			if (timeReal != 0) timeReal = 0;
			if (timeRealTemp != 0) timeRealTemp = 0;
			if (timeEngine != 0) timeEngine = 0;
			if (timePrev != 0) timePrev = 0;
			if (timeNext != 0) timeNext = 0;
			if (crcFrame.length) crcFrame.length = 0;
		}
		
		/** 要移除全部的游戏数据 **/
		internal function dispose():void
		{
			g.event.removeEnterFrame(enterFrame);
			gameReSet();
			if (this.u) this.u = null;
			if (this.engine) this.engine = null;
			if (timeHeartMethod != null) timeHeartMethod = null;
			if (timeHeartErrorMethod != null) timeHeartErrorMethod = null;
			if (crcFrame)
			{
				g.speedFact.d_array(crcFrame);
				crcFrame = null;
			}
		}
	}
}