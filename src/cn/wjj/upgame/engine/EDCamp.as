package cn.wjj.upgame.engine 
{
	import cn.wjj.g;
	import cn.wjj.upgame.common.EDType;
	import cn.wjj.upgame.common.StatusEngineType;
	import cn.wjj.upgame.UpGameConfig;
	
	/**
	 * 阵营列表
	 * @author GaGa
	 */
	public class EDCamp 
	{
		/** 游戏逻辑层 **/
		public var engine:UpEngine;
		/** 正在执行第几轮 **/
		public var round:int = 0;
		/** 阵营的ID, 0, 为无阵营,1, 自己阵营, 2, 敌方阵营 **/
		public var camp:int = 0;
		/** 阵营里的全部内容 **/
		public var list:Array;
		/** 阵营中内容的数量 **/
		public var length:int = 0;
		/** 阵容中全部的人物对象 **/
		public var listRole:Array;
		/** 阵营中人物内容的数量 **/
		public var lengthRole:int = 0;
		/** 阵营中的全部的英雄对象 **/
		public var listHero:Array;
		/** 阵营中的英雄 **/
		public var lengthHero:int = 0;
		/** 通过ID来获取玩家 **/
		public var playerObj:Object;
		/** 阵营中的玩家 **/
		public var playerList:Vector.<EDCampPlayer>;
		/** 阵营中的玩家数量 **/
		public var playerLength:int = 0;
		/** AI运行中创建的新物件,运行完毕后需要被加回到list列表中 **/
		public var aiRunCreate:Array;
		public var aiRunCreateLength:int = 0;
		/** AI运行中创建的新物件,运行完毕后需要被加回到list列表中 **/
		public var aiTargetCreate:Array;
		public var aiTargetCreateLength:int = 0;
		/** aiRun 是否已经结束 **/
		private var overAiRun:Boolean = true;
		/** aiRun 是否已经结束 **/
		private var overAiTarget:Boolean = true;
		/** 替补数量,胜利的时候还必须没有替补 **/
		public var benchLength:int = 0;
		/** 当有替补的时候,我放有人员死亡,触发函数,可以在程序控制的地方添加内容function(ed:EDRole) **/
		public var benchMethod:Function;
		/** 当有替补要出来,但是需要倒计时,所以这个时间前,都不能使用时间来判定本方失败 **/
		public var benchTime:int = 0;
		/** 召唤的长度 **/
		public var callLength:int = 0;
		/** 允许在本阵容中出现的最多数量(好像是召唤) **/
		public var callMax:int = 0;
		/** 运行的临时变量 **/
		private var aTemp:Array;
		
		/** 我方伤害统计 **/
		public var count_damage:int = 0;
		/** 我方伤害统计(BOSS的) **/
		public var count_damage_boss:int = 0;
		
		/** 中间的塔 **/
		public var towerCenter:EDRole;
		/** (朝向的方位)左边的塔(上方会被镜像) **/
		public var towerLeft:EDRole;
		/** (朝向的方位)右边的塔(上方会被镜像) **/
		public var towerRight:EDRole;
		/** 辅助生成服务器ID,从0开始,每次重置重头开始 **/
		public var serverCount:int = 0;
		
		/** 记录全部的CRC内容 = object;o[time]=crc;然后对比 **/
		public var heartCRC:Object;
		
		public function EDCamp(engine:UpEngine) 
		{
			this.engine = engine;
			aTemp = new Array();
			list = new Array();
			listHero = new Array();
			listRole = new Array();
			playerList = new Vector.<EDCampPlayer>();
			playerObj = new Object();
			aiRunCreate = new Array();
			aiTargetCreate = new Array();
		}
		
		/** 为本阵营里的英雄增加经验值 **/
		public function addExp(val:uint):void
		{
			if (lengthHero)
			{
				for each (var role:EDRole in listHero) 
				{
					if (role.isLive)
					{
						role.addExp(val);
					}
				}
			}
		}
		
		/** 添加一个阵营内容 **/
		public function addED(ed:EDBase):void
		{
			if (list.indexOf(ed) == -1 && aiRunCreate.indexOf(ed) == -1 && aiTargetCreate.indexOf(ed) == -1)
			{
				length++;
				var role:EDRole;
				if (ed.type == EDType.role)
				{
					lengthRole++;
					role = ed as EDRole;
					if (role.dieAuto)
					{
						callLength++;
					}
				}
				if (overAiRun && overAiTarget)
				{
					list.push(ed);
					if (role)
					{
						listRole.push(role);
						if (role.info.hero)
						{
							listHero.push(role);
							lengthHero++;
						}
					}
				}
				else if (overAiRun == false)
				{
					aiRunCreate[aiRunCreateLength++] = ed;
				}
				else if (overAiTarget == false)
				{
					aiTargetCreate[aiTargetCreateLength++] = ed;
					ed.aiRun();
				}
			}
			else
			{
				new Error();
			}
		}
		
		/** 移除一个阵营的内容 **/
		public function removeED(ed:EDBase):void
		{
			if(length)
			{
				var index:int;
				var isDo:Boolean = false;
				var role:EDRole;
				if (ed.type == EDType.role)
				{
					role = ed as EDRole;
					//唤醒主塔
					if (towerLeft == role || towerRight == role)
					{
						if (towerCenter && towerCenter.isLive) towerCenter.wakeUp();
					}
					if (role.dieAuto)
					{
						callLength--;
					}
				}
				index = list.indexOf(ed);
				if (index != -1)
				{
					list.splice(index, 1);
					isDo = true;
				}
				//删除人物的内容
				if (role)
				{
					index = listRole.indexOf(role);
					if (index != -1)
					{
						listRole.splice(index, 1);
					}
					//删除英雄里的人物内容
					index = listHero.indexOf(role);
					if (index != -1)
					{
						listHero.splice(index, 1);
					}
				}
				index = aiRunCreate.indexOf(ed);
				if (index != -1)
				{
					aiRunCreate.splice(index, 1);
					isDo = true;
					aiRunCreateLength--;
				}
				index = aiTargetCreate.indexOf(ed);
				if (index != -1)
				{
					aiTargetCreate.splice(index, 1);
					isDo = true;
					aiTargetCreateLength--;
				}
				if (isDo)
				{
					length--;
					if (role)
					{
						lengthRole--;
						//添加替补
						if (benchLength && benchMethod != null && role.isLive == false && engine.isGameOver == false && role.dieAuto == 0)
						{
							//(这些只有cmap==1才记录)召唤生物,助战NPC,好友不能添加NPC,起始这里只检查cmap == 1就可以,当然,benchLength只有1才有
							isDo = true;
							if (engine.playerFriendLength && engine.playerFriendList.indexOf(role) != -1)
							{
								isDo = false;
							}
							if (isDo && engine.playerNPCLength && engine.playerNPCList.indexOf(role) != -1)
							{
								isDo = false;
							}
							if (isDo && engine.playerCallLength && engine.playerCallList.indexOf(role) != -1)
							{
								isDo = false;
							}
							if (isDo) benchMethod(ed);
						}
					}
				}
			}
		}
		
		/** 增加能量值,如果有playerId将必须和EDCampPlayer中的playerId对应,如果为-1就都增加 **/
		public function addEnergy(value:Number, playerId:int = -1):Boolean
		{
			if (playerLength)
			{
				var isComplete:Boolean = false;
				for each (var player:EDCampPlayer in playerList) 
				{
					if (player.using && (playerId == -1 || player.playerId == playerId))
					{
						if (player.energyTemp < UpGameConfig.energyMax)
						{
							isComplete = true;
							player.energyTemp += value;
							if (player.energyTemp > UpGameConfig.energyMax)
							{
								player.energyTemp = UpGameConfig.energyMax;
							}
							player.energyValue = int(player.energyTemp);
						}
					}
				}
				return isComplete;
			}
			return false;
		}
		
		/** 清理,不回收 **/
		public function claer():void
		{
			var i:int;
			var item:EDBase;
			if (length)
			{
				length = 0;
				lengthRole = 0;
				aTemp.push.apply(null, list);
				list.length = 0;
				listRole.length = 0;
				for each (item in aTemp) 
				{
					item.dispose();
				}
				aTemp.length = 0;
			}
			if (aiRunCreateLength)
			{
				aiRunCreateLength = 0;
				aTemp.push.apply(null, aiRunCreate);
				aiRunCreate.length = 0;
				for each (item in aTemp) 
				{
					item.dispose();
				}
				aTemp.length = 0;
			}
			if (aiTargetCreateLength)
			{
				aiTargetCreateLength = 0;
				aTemp.push.apply(null, aiTargetCreate);
				aiTargetCreate.length = 0;
				for each (item in aTemp) 
				{
					item.dispose();
				}
				aTemp.length = 0;
			}
			benchLength = 0;
			benchMethod = null;
			if (playerLength)
			{
				for each (var player:EDCampPlayer in playerList) 
				{
					player.dispose();
					delete playerObj[player];
				}
				playerList.length = 0;
				playerLength = 0;
			}
			if (lengthHero)
			{
				for each (item in listHero) 
				{
					item.dispose();
				}
				lengthHero = 0;
			}
			serverCount = 0;
			if (towerCenter) towerCenter = null;
			if (towerLeft) towerLeft = null;
			if (towerRight) towerRight = null;
		}
		
		/** 移除,清理,并回收 **/
		public function dispose():void
		{
			claer();
			list = null;
			listRole = null;
			aiRunCreate = null;
			aiTargetCreate = null;
			engine = null;
		}
		
		/** 对一个阵营启动AI **/
		public function aiRun():void
		{
			round++;
			overAiRun = false;
			if (length)
			{
				var index:int;
				//在执行 aiRun 的过程中可能Item已经挂了,会造成Bug
				aTemp.push.apply(null, list);
				for each (var item:EDBase in aTemp) 
				{
					if (item.isLive)
					{
						item.aiRun();
					}
					else
					{
						if (item.type == EDType.role && (item as EDRole).info && (item as EDRole).info.hero)
						{
							(item as EDRole).aiRunDieHero();
						}
						else
						{
							index = list.indexOf(item);
							if (index != -1)
							{
								list.splice(index, 1);
								length--;
								if (item.type == EDType.role)
								{
									index = listRole.indexOf(item as EDRole);
									if (index != -1)
									{
										listRole.splice(index, 1);
										lengthRole--;
									}
								}
							}
						}
					}
				}
				aTemp.length = 0;
				overAiRun = true;
				if (aiRunCreateLength)
				{
					aTemp.push.apply(null, aiRunCreate);
					for each (item in aTemp) 
					{
						if (item.isLive)
						{
							item.aiRun();
						}
						else
						{
							if (item.type == EDType.role && (item as EDRole).info.hero)
							{
								(item as EDRole).aiRunDieHero();
							}
							else
							{
								index = aiRunCreate.indexOf(item);
								if (index != -1)
								{
									aiRunCreate.splice(index, 1);
									aiRunCreateLength--;
								}
							}
						}
					}
					aTemp.length = 0;
					//执行添加,可能上面已经被移除,所以不能这样操作
					for each (item in aiRunCreate) 
					{
						list.push(item);
						if (item.type == EDType.role)
						{
							listRole.push(item as EDRole);
							if ((item as EDRole).info.hero)
							{
								listHero.push(item);
								lengthHero++;
							}
						}
					}
					aiRunCreate.length = 0;
					aiRunCreateLength = 0;
				}
			}
		}
		
		/** 对一个阵营启动目标处理 **/
		public function aiTarget():void
		{
			overAiTarget = false;
			if (length && engine.type == StatusEngineType.start)
			{
				//在执行 aiTarget 的过程中可能Item已经挂了,会造成Bug
				aTemp.push.apply(null, list);
				for each (var item:EDBase in aTemp)
				{
					if (engine.type == StatusEngineType.start)
					{
						if (item.isLive)
						{
							item.aiTarget();
						}
					}
					else
					{
						break;
					}
				}
				aTemp.length = 0;
				overAiTarget = true;
				if (aiTargetCreateLength)
				{
					aTemp.push.apply(null, aiTargetCreate);
					for each (item in aTemp)
					{
						if (engine.type == StatusEngineType.start)
						{
							if (item.isLive)
							{
								item.aiTarget();
							}
						}
					}
					aTemp.length = 0;
					if (engine.type == StatusEngineType.start)
					{
						for each (item in aiTargetCreate)
						{
							list.push(item);
							if (item.type == EDType.role)
							{
								listRole.push(item as EDRole);
								if ((item as EDRole).info.hero)
								{
									listHero.push(item);
									lengthHero++;
								}
							}
						}
					}
					aiTargetCreate.length = 0;
					aiTargetCreateLength = 0;
				}
			}
			else
			{
				overAiTarget = true;
			}
		}
	}
}