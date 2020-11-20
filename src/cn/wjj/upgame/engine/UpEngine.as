package cn.wjj.upgame.engine 
{
	import cn.wjj.g;
	import cn.wjj.upgame.common.EDType;
	import cn.wjj.upgame.common.StatusEngineType;
	import cn.wjj.upgame.common.StatusTypeRole;
	import cn.wjj.upgame.common.UpGameEvent;
	import cn.wjj.upgame.data.UpGameWarMap;
	import cn.wjj.upgame.UpGame;
	import flash.utils.getTimer;
	
	/**
	 * 游戏逻辑层
	 * 
	 * @author GaGa
	 */
	public class UpEngine
	{
		/** 是否属于活动模式 **/
		public var isLive:Boolean = true;
		/** 是否是第一次启动 **/
		private var initStart:Boolean = false;
		/** 父引用 **/
		public var u:UpGame;
		/** 地图的 A星 数据 **/
		public var astar:UpGameAStar;
		/** 驱动器的模拟时间 **/
		public var time:UpEngineTime;
		/** 发动机运行加速的比例 **/
		public var speed:Number = 1;
		/** 现在游戏的状态 **/
		public var type:int = StatusEngineType.no;
		
		/** 战场信息 **/
		public var warMapInfo:UpGameWarMap;
		
		/** 阵营列表,可以在这里设置优先攻击循序, 0, 为无阵营,1, 自己阵营, 2, 敌方阵营 **/
		public var campLib:Vector.<EDCamp>;
		/** 通过阵营列表反射阵营 **/
		public var camp:Object;
		/** 默认的阵营(我方阵营) **/
		public var camp1:EDCamp;
		/** 默认的阵营(敌方阵营) **/
		public var camp2:EDCamp;
		/** 在第几节运转 **/
		public var section:int = 0;
		
		/** 播放和暂停之间的切换模式 **/
		public var changePlayPause:int = 0;
		/** 播放和待机之间的切换模式 **/
		public var changePlayLive:int = 0;
		
		/** 已经完成了多少队列 **/
		public var roundGroupComplete:uint = 0;
		/** 总共有多少个队列 **/
		public var roundGroupLength:uint = 0;
		/** 本组刷怪波次的下一波刷怪时间点 **/
		public var roundGroupTimeNext:Array;
		/** 本组刷怪波次的已经召唤完成波次 **/
		public var roundGroupItemComplete:Array;
		/** 本组总共要刷多少波次 **/
		public var roundGroupItemlength:Array;
		/** 本轮波次里还有多少存活的角色 **/
		public var roundGroupRoleLength:Array;
		
		
		/** 下一波怪物需要运行的函数 (group:int, round:int) **/
		public var nextRoundMethod:Function;
		
		/** 是否胜利, 0 平局, 1 camp1胜利, 2 camp2失败 **/
		public var isWin:int = 0;
		/** 是否游戏结束 **/
		public var isGameOver:Boolean = false;
		/** 是否是游戏时间结束 **/
		public var isTimeOver:Boolean = false;
		/** 召唤怪物所使用的函数 callMonster(召唤发动角色:EDRole, 召唤怪物ID:int, , 坐标点:int, 坐标点:int):EDRole **/
		public var callMonster:Function;
		/** 要显示在顶端的血条回调函数 methodTopBoolmd(角色信息:EDRole):void **/
		public var methodTopBoolmd:Function;
		
		/** 玩家列表 **/
		public var playerList:Vector.<EDRole>;
		/** 玩家的数量 **/
		public var playerLength:int = 0;
		/** 玩家助战NPC列表 **/
		public var playerNPCList:Vector.<EDRole>;
		/** 玩家助战NPC数量 **/
		public var playerNPCLength:int = 0;
		/** 玩家助战好友列表 **/
		public var playerFriendList:Vector.<EDRole>;
		/** 玩家助战好友数量 **/
		public var playerFriendLength:int = 0;
		/** 玩家召唤角色列表 **/
		public var playerCallList:Vector.<EDRole>;
		/** 玩家召唤角色数量 **/
		public var playerCallLength:int = 0;
		
		/** 使用客户端判断胜利条件 **/
		public var winClient:Boolean = true;
		/** 条件(失败) : 我方某一个NPC被击杀就失败 **/
		public var winNPC:int = 0;
		/** 条件(胜利) : 击杀BOSS, 杀死ID为胜利条件 **/
		public var winKillId:uint = 0;
		/** 条件(胜利) : 是否开启检测塔胜利条件 **/
		public var winKillTower:Boolean = false;
		/** 条件(胜利) : 在这个时间后打一个塔就可以胜利 **/
		public var winKillTowerTime:uint = 0;
		/** 是否已经击杀BOSS **/
		public var winKillId_OK:Boolean = false;
		/** 条件(失败) : 关卡时间结束点,0无限时间处理,其他是有时间限制,2分钟,当然也可以做最长时间限制 **/
		public var winOverTime:uint = 120000;
		/** 条件(胜利) : 坚持够时间为胜利, 0:不处理这个值 **/
		public var winLiveTime:uint = 0;
		/** 是否已经坚持了这么长时间 **/
		public var winLiveTime_OK:Boolean = false;
		/** 召唤怪物的序号ID,callId[99423439] = 3587,这样来生成编号 **/
		public var callId:Object;
		
		/** 开启互推模式的重量列表 **/
		public var pushWeightList:Array;
		/** 开启互推模式的重量数量 **/
		public var pushWeightLength:int;
		/** 开启互推模式的对象列表 **/
		public var pushEdList:Object;
		
		public function UpEngine(u:UpGame) 
		{
			this.u = u;
			time = new UpEngineTime(u, this);
			astar = new UpGameAStar(u);
			camp = g.speedFact.n_object();
			callId = g.speedFact.n_object();
			roundGroupTimeNext = g.speedFact.n_array();
			roundGroupItemComplete = g.speedFact.n_array();
			roundGroupItemlength = g.speedFact.n_array();
			roundGroupRoleLength = g.speedFact.n_array();
			playerList = g.speedFact.n_vector(EDRole);
			if (playerList == null)
			{
				playerList = new Vector.<EDRole>();
			}
			playerNPCList = g.speedFact.n_vector(EDRole);
			if (playerNPCList == null)
			{
				playerNPCList = new Vector.<EDRole>();
			}
			playerFriendList = g.speedFact.n_vector(EDRole);
			if (playerFriendList == null)
			{
				playerFriendList = new Vector.<EDRole>();
			}
			playerCallList = g.speedFact.n_vector(EDRole);
			if (playerCallList == null)
			{
				playerCallList = new Vector.<EDRole>();
			}
			campLib = new Vector.<EDCamp>();
			camp1 = new EDCamp(this);
			camp1.camp = 1;
			camp[1] = camp1;
			camp2 = new EDCamp(this);
			camp2.camp = 2;
			camp[2] = camp2;
			campLib.push(camp1);
			campLib.push(camp2);
			pushWeightList = g.speedFact.n_array();
			pushEdList = g.speedFact.n_object();
			pushWeightLength = 0;
		}
		
		/** 初始化游戏中的阵营 **/
		public function reSetEngine():void
		{
			type = StatusEngineType.no;
			clear();
		}
		
		/** 清理战斗中的时间等信息 **/
		public function clearTime():void
		{
			if (type == StatusEngineType.live)
			{
				time.clear();
			}
		}
		
		/**
		 * 根据changePlayPause, changePlayLive检测运行状态,让游戏在中途进行各种停顿
		 * 第一次启动也使用这个函数
		 */
		public function checkState():void
		{
			if (time.timeStartBase < 0)
			{
				time.timeStartBase = new Date().time;
			}
			if (changePlayPause > 0)
			{
				if (type != StatusEngineType.pause)
				{
					type = StatusEngineType.pause;
					g.event.removeEnterFrame(time.enterFrame);
					u.dispatchEvent(new UpGameEvent(UpGameEvent.pause));
				}
			}
			else if (changePlayLive > 0)
			{
				if (type != StatusEngineType.live)
				{
					//clearGameOther(false);
					//将改变现在角色的状态,从而导致不同步的问题
					type = StatusEngineType.live;
					if (time.displayFrame)
					{
						g.event.addEnterFrame(time.enterFrame);
					}
					else
					{
						new Error();
					}
				}
			}
			else if (type != StatusEngineType.start)
			{
				type = StatusEngineType.start;
				if (initStart == false)
				{
					initStart = true;
					if (u.modeAttack)
					{
						camp1.heartCRC = new Object();
						camp2.heartCRC = new Object();
					}
					//先把所有的人物等激活
					var ed:EDRole;
					if (campLib)
					{
						if (campLib.length == 2)
						{
							if (camp1.lengthRole)
							{
								for each (ed in camp1.listRole) 
								{
									if (ed.inHot == false && astar.isPass(ed.x, ed.y))
									{
										ed.inHot = true;
									}
								}
							}
							//先把怪物召唤出来
							if (camp2.lengthRole == 0 && camp2.benchLength == 0)
							{
								if (camp2.benchTime < time.timeGame)
								{
									time.runNextRound();
								}
							}
							if (camp2.lengthRole)
							{
								for each (ed in camp2.listRole) 
								{
									if (ed.inHot == false && astar.isPass(ed.x, ed.y))
									{
										ed.inHot = true;
									}
								}
							}
						}
						else
						{
							for each (var camp:EDCamp in campLib) 
							{
								if (camp.lengthRole == 0 && camp.benchLength == 0)
								{
									if (camp.benchTime < time.timeGame)
									{
										time.runNextRound();
									}
								}
								if (camp.lengthRole)
								{
									for each (ed in camp.listRole) 
									{
										if (ed.inHot == false && astar.isPass(ed.x, ed.y))
										{
											ed.inHot = true;
										}
									}
								}
							}
						}
					}
				}
				time.timeStartBase = new Date().time;
				if (time.displayFrame)
				{
					g.event.addEnterFrame(time.enterFrame);
				}
				else
				{
					new Error();
				}
				u.dispatchEvent(new UpGameEvent(UpGameEvent.start));
			}
		}
		
		/**
		 * 添加物品进入阵营
		 * @param	ed
		 */
		public function addED(ed:EDBase):EDCamp
		{
			var item:EDCamp;
			var id:int = ed.camp;
			if (ed.type == EDType.role)
			{
				var role:EDRole = ed as EDRole;
				if (role.info.typeProperty == 1)
				{
					if (u.modeMovePhys)
					{
						var list:Vector.<EDRole>;
						if (pushWeightLength == 0 || pushWeightList.indexOf(role.info.weight) == -1)
						{
							pushWeightLength++;
							pushWeightList.push(role.info.weight);
							list = g.speedFact.n_vector(EDRole);
							if (list == null) list = new Vector.<EDRole>();
							pushEdList[String(role.info.weight)] = list;
							pushWeightList.sort(Array.NUMERIC);
						}
						else
						{
							list = pushEdList[String(role.info.weight)];
						}
						list.push(role);
					}
				}
				else if (role.info.typeProperty == 3 || role.info.typeProperty == 4)
				{
					
				}
				if (id != 1)
				{
					var group:int = role.group;
					if (group != -1)
					{
						roundGroupRoleLength[group]++;
					}
				}
			}
			if (id == 2)
			{
				camp2.addED(ed);
				return camp2;
			}
			else if (id == 1)
			{
				camp1.addED(ed);
				return camp1;
			}
			else
			{
				if (camp.hasOwnProperty(id))
				{
					item = camp[id] as EDCamp;
					item.addED(ed);
				}
				else
				{
					item = new EDCamp(this);
					camp[id] = item;
					if (time.roundOver)
					{
						item.round = time.round;
					}
					else
					{
						item.round = time.round--;
					}
					item.camp = id;
					item.addED(ed);
					campLib.push(item);
				}
			}
			return item;
		}
		
		/**
		 * 移除物品退出阵营
		 * @param	ed
		 * @return
		 */
		public function removeED(ed:EDBase):void
		{
			if (ed.camp == 2)
			{
				camp2.removeED(ed);
			}
			else if (ed.camp == 1)
			{
				camp1.removeED(ed);
			}
			else if (camp.hasOwnProperty(ed.camp))
			{
				(camp[ed.camp] as EDCamp).removeED(ed);
			}
			if (u.readerStart) u.reader.removeED(ed);
			//清理列表,判断胜利条件
			if (ed.type == EDType.role)
			{
				var role:EDRole = ed as EDRole;
				if (isGameOver == false && time.timeHeartMethod != null && role.info.typeProperty == 4)
				{
					time.timeHeartMethod();
				}
				var index:int;
				if (pushWeightLength && role.info.typeProperty != 2 && pushWeightList.indexOf(role.info.weight) != -1)
				{
					var list:Vector.<EDRole> = pushEdList[String(role.info.weight)];
					index = list.indexOf(role);
					if (index != -1)
					{
						list.splice(index, 1);
					}
					if (list.length == 0)
					{
						g.speedFact.d_vector(EDRole, list);
						delete pushEdList[String(role.info.weight)];
						index = pushWeightList.indexOf(role.info.weight);
						pushWeightList.splice(index, 1);
						pushWeightLength--;
					}
				}
				if (this.type == StatusEngineType.start && u.taskStart && u.task.listenerEDRoleKill)
				{
					u.task.killEDRole(role);
				}
				if (role.camp == 1)
				{
					if (playerLength)
					{
						if (playerList)
						{
							index = playerList.indexOf(role);
							if (index != -1)
							{
								playerList.splice(index, 1);
								playerLength--;
							}
						}
						else
						{
							playerLength = 0;
						}
					}
					if (playerFriendLength)
					{
						if (playerFriendList)
						{
							index = playerFriendList.indexOf(role);
							if (index != -1)
							{
								playerFriendList.splice(index, 1);
								playerFriendLength--;
							}
						}
						else
						{
							playerFriendLength = 0;
						}
					}
					if (playerNPCLength)
					{
						if (playerNPCList)
						{
							index = playerNPCList.indexOf(role);
							if (index != -1)
							{
								playerNPCList.splice(index, 1);
								playerNPCLength--;
								if (this.winClient && this.type == StatusEngineType.start && role.info.idType == 2)
								{
									if (winNPC == -1)
									{
										//己方的NPC已经死了,战斗结束
										isWin = 2;
										over();
									}
									else if (winNPC && role.info.id == winNPC)
									{
										//己方的NPC已经死了,战斗结束
										isWin = 2;
										over();
									}
								}
							}
						}
						else
						{
							playerNPCLength = 0;
						}
					}
					if (playerCallLength)
					{
						if (playerCallList)
						{
							index = playerCallList.indexOf(role);
							if (index != -1)
							{
								playerCallList.splice(index, 1);
								playerCallLength--;
							}
						}
						else
						{
							playerCallLength = 0;
						}
					}
				}
				else
				{
					if (this.type == StatusEngineType.start && winKillId != 0 && role.info.idType == 2 && role.info.id == winKillId)
					{
						winKillId_OK = true;
						time.checkGameWin();
						if (isGameOver) time.checkOver();
					}
					if (isGameOver == false && this.type == StatusEngineType.start && role.group != -1 && nextRoundMethod != null)
					{
						roundGroupRoleLength[role.group]--;
						if (roundGroupRoleLength[role.group] <= 0)
						{
							//刷下一波啦
							roundGroupItemComplete[role.group]++;
							var round:int = roundGroupItemComplete[role.group];
							if (roundGroupItemlength[role.group] > round)
							{
								nextRoundMethod(role.group, round);
							}
							else
							{
								roundGroupComplete++;
								if (roundGroupLength <= roundGroupComplete)
								{
									//已经没有怪物了
									time.checkGameWin();
									if (isGameOver) time.checkOver();
								}
							}
						}
					}
				}
			}
		}
		
		/** 清理,重置一下 **/
		public function clear():void
		{
			//驱动时间
			time.clear();
			if (playerLength)
			{
				playerList.length = 0;
				playerLength = 0;
			}
			if (playerNPCLength)
			{
				playerNPCList.length = 0;
				playerNPCLength = 0;
			}
			if (playerFriendLength)
			{
				playerFriendList.length = 0;
				playerFriendLength = 0;
			}
			if (playerCallLength)
			{
				playerCallList.length = 0;
				playerCallLength = 0;
			}
			if (campLib)
			{
				if (campLib.length == 2)
				{
					camp1.claer();
					camp2.claer();
				}
				else
				{
					var item:EDCamp;
					for each (item in campLib) 
					{
						if (item != camp1 && item != camp2)
						{
							item.dispose();
						}
						else
						{
							item.claer();
						}
					}
					item = null;
					campLib.length = 0;
					campLib.push(camp1);
					campLib.push(camp2);
					for (var key:String in camp) 
					{
						delete camp[key];
					}
					camp[1] = camp1;
					camp[2] = camp2;
				}
			}
			roundGroupLength = 0;
			roundGroupComplete = 0;
			roundGroupTimeNext.length = 0;
			roundGroupRoleLength.length = 0;
			roundGroupItemlength.length = 0;
			roundGroupItemComplete.length = 0;
		}
		
		/**
		 * 清理地图中用到的子弹,特效,等元素,只留下人物来
		 * 清理地面的内容
		 * 清理人物的BUFF
		 * 清理飞行的弹道
		 * 去特效哪里清理特效
		 */
		private function clearGameOther(disposeRole:Boolean):void
		{
			//把没有运行刷出的人物,提前刷出来
			time.removeAllTimeMethod();
			if (campLib)
			{
				if (campLib.length == 2)
				{
					clearGameCamp(camp1, disposeRole);
					clearGameCamp(camp2, disposeRole);
				}
				else
				{
					for each (var camp:EDCamp in campLib) 
					{
						clearGameCamp(camp, disposeRole);
					}
				}
			}
		}
		
		/**
		 * 清理一个对列的内容
		 */
		private function clearGameCamp(camp:EDCamp, disposeRole:Boolean):void
		{
			if (camp && camp.length)
			{
				var item:EDBase;
				var i:int = camp.list.length;
				while(--i > -1)
				{
					item = camp.list[i];
					clearGameItem(item, disposeRole);
				}
				if (camp.aiRunCreateLength)
				{
					i = camp.aiRunCreateLength;
					while(--i > -1)
					{
						item = camp.aiRunCreate[i];
						clearGameItem(item, disposeRole);
					}
					//camp.aiRunCreate.length = 0;
					//camp.aiRunCreateLength = 0;
				}
				if (camp.aiTargetCreateLength)
				{
					i = camp.aiTargetCreateLength;
					while(--i > -1)
					{
						item = camp.aiTargetCreate[i];
						clearGameItem(item, disposeRole);
					}
					//camp.aiTargetCreate.length = 0;
					//camp.aiTargetCreateLength = 0;
				}
			}
		}
		
		/**
		 * 提前结束战斗,提前的胜利条件达到
		 * 将里面人物全部干掉,未刷出的也干掉
		 * @param	campId	胜利方的ID(0 平局)
		 */
		public function advanceWinCampId(winId:int):void
		{
			if (campLib)
			{
				var camp:EDCamp;
				if (u.modeAttack)
				{
					if (campLib.length == 2)
					{
						clearGameCamp(camp1, false);
						clearGameCamp(camp2, false);
					}
					else
					{
						for each (camp in campLib) 
						{
							clearGameCamp(camp, false);
						}
					}
				}
				else
				{
					if (campLib.length == 2)
					{
						if (winId == 0)
						{
							clearGameCamp(camp1, false);
							clearGameCamp(camp2, false);
						}
						else if (winId == 1)
						{
							clearGameCamp(camp1, false);
							clearGameCamp(camp2, true);
						}
						else
						{
							clearGameCamp(camp1, false);
							clearGameCamp(camp2, true);
						}
					}
					else
					{
						for each (camp in campLib) 
						{
							if (winId == 0)
							{
								clearGameCamp(camp, false);
							}
							else if (camp.camp != winId)
							{
								clearGameCamp(camp, true);
							}
						}
					}
				}
			}
		}
		
		/**
		 * 清理对象
		 * @param	item			要处理的对象
		 * @param	disposeRole		是否摧毁role对象
		 */
		private function clearGameItem(item:EDBase, disposeRole:Boolean):void
		{
			if (isLive && item)
			{
				if(disposeRole)
				{
					item.dispose();
				}
				else
				{
					switch (item.type) 
					{
						case EDType.bullet:
						case EDType.skillContinue:
							item.dispose();
							break;
						case EDType.role:
							var role:EDRole = item as EDRole;
							if (role.isLive)
							{
								role.aiStop = false;
								role.aiStun = false;
								role.ai.move.stop();
								if (role.ai.skillFire)
								{
									role.ai.skillStop();
								}
								role.ai.oldSkill = null;
								role.ai.buff.clearBuff();
								role.changeStatus(StatusTypeRole.idle);
							}
							break;
					}
				}
			}
		}
		
		/** 终止游戏运行 **/
		public function over():void
		{
			if (type != StatusEngineType.over && type != StatusEngineType.timeover)
			{
				/*
				if (u.net)
				{
					u.net.gameOver();
				}
				*/
				clearGameOther(false);
				type = StatusEngineType.over;
				time.over();
				isGameOver = false;
				u.dispatchEvent(new UpGameEvent(UpGameEvent.over));
			}
		}
		
		/** 游戏时间到结束游戏 **/
		internal function timeover():void
		{
			if (type != StatusEngineType.over && type != StatusEngineType.timeover)
			{
				/*
				if (u.net)
				{
					u.net.gameOver();
				}
				*/
				clearGameOther(false);
				type = StatusEngineType.timeover;
				time.over();
				isGameOver = false;
				u.dispatchEvent(new UpGameEvent(UpGameEvent.over));
			}
		}
		
		/** 把一个阵营直接获胜,清理场景里的多余的内容和子弹 **/
		public function campWin(campId:uint):void
		{
			if (campLib.length == 2)
			{
				if (campId == 1)
				{
					camp2.claer();
				}
				else
				{
					camp1.claer();
				}
			}
			else
			{
				var item:EDCamp;
				for (var id:* in campLib) 
				{
					item = campLib[id];
					if (item.camp != campId)
					{
						if (item.camp == 1 || item.camp == 2)
						{
							item.claer();
						}
						else
						{
							camp[item.camp] = null;
							delete camp[item.camp];
							item.dispose();
							campLib.splice(id, 1);
						}
					}
				}
			}
			over();
		}
		
		/** 移除,清理,并回收 **/
		public function dispose():void
		{
			if (isLive) isLive = false;
			over();
			g.speedFact.d_vector(EDRole, playerList);
			playerList = null;
			g.speedFact.d_vector(EDRole, playerNPCList);
			playerNPCList = null;
			g.speedFact.d_vector(EDRole, playerFriendList);
			playerFriendList = null;
			g.speedFact.d_vector(EDRole, playerCallList);
			playerCallList = null;
			for each (var item:EDCamp in campLib) 
			{
				item.dispose();
			}
			item = null;
			campLib.length = 0;
			campLib = null;
			camp1 = null;
			camp2 = null;
			for (var key:String in camp) 
			{
				delete camp[key];
			}
			g.speedFact.d_object(camp);
			camp = null;
			if (time)
			{
				time.dispose();
				time = null;
			}
			if (astar)
			{
				astar.dispose();
				astar = null;
			}
			u = null;
			warMapInfo = null;
			roundGroupLength = 0;
			roundGroupComplete = 0;
			g.speedFact.d_array(roundGroupTimeNext);
			roundGroupTimeNext = null;
			g.speedFact.d_array(roundGroupRoleLength);
			roundGroupRoleLength = null;
			g.speedFact.d_array(roundGroupItemlength);
			roundGroupItemlength = null;
			g.speedFact.d_array(roundGroupItemComplete);
			roundGroupItemComplete = null;
			for (key in callId) 
			{
				delete callId[key];
			}
			g.speedFact.d_object(callId);
			callId = null;
			if (nextRoundMethod != null) nextRoundMethod = null;
			if (callMonster != null) callMonster = null;
			if (methodTopBoolmd != null) methodTopBoolmd = null;
			if (pushWeightLength)
			{
				var weightList:Vector.<EDRole>;
				for each (var weight:int in pushWeightList) 
				{
					weightList = pushEdList[String(weight)];
					g.speedFact.d_vector(EDRole, weightList);
					delete pushEdList[String(weight)];
				}
				g.speedFact.d_object(pushEdList);
				pushEdList = null;
				g.speedFact.d_array(pushWeightList);
				pushWeightList = null;
				pushWeightLength = 0;
			}
		}
	}
}