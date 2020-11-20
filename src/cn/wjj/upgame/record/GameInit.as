package cn.wjj.upgame.record 
{
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.upgame.common.InfoHeroAddSkill;
	import cn.wjj.upgame.common.RecordType;
	import cn.wjj.upgame.engine.EDCamp;
	import cn.wjj.upgame.engine.EDCampPlayer;
	import cn.wjj.upgame.engine.EDRole;
	import cn.wjj.upgame.tools.ReleaseCard;
	import cn.wjj.upgame.UpGame;
	import cn.wjj.upgame.UpGameConfig;
	
	/**
	 * 游戏初始化的时候的设置
	 * 战斗前的一些准备
	 * 
	 * @author GaGa
	 */
	public class GameInit 
	{
		/** 父引用 **/
		public var u:UpGame;
		
		/** 初始化信息 **/
		public var info:Array;
		/** 初始化信息的长度 **/
		public var length:int = 0;
		
		public function GameInit(u:UpGame) 
		{
			this.u = u;
			info = g.speedFact.n_array();
		}
		
		/**
		 * 设置数据到记录中
		 * @param	o
		 * @param	setRandom	是否重置随机参数
		 */
		public function random(group:int, site:int):void
		{
			var o:Object = g.speedFact.n_object();
			o.type = RecordType.InitRandom;
			o.group = group;
			o.site = site;
			length++;
			info.push(o);
		}
		
		/**
		 * 设置游戏类型
		 * @param	attack	是否开启对攻模式(上下对打的模式)
		 * @param	turn	是否开启翻转模式(镜像播放模式),进攻方在下面
		 * @param	phys	人物互相推让的功能,固定位置的推体重大的,体重大的优先推让体重小的
		 */
		public function mode(attack:Boolean, turn:Boolean, phys:Boolean):void
		{
			var o:Object = g.speedFact.n_object();
			o.type = RecordType.InitMode;
			o.attack = attack;
			o.turn = turn;
			o.phys = phys;
			length++;
			info.push(o);
		}
		
		/**
		 * 设置能量增长速度
		 * @param	scale
		 */
		public function energy(scale:Number):void
		{
			var o:Object = g.speedFact.n_object();
			o.type = RecordType.InitEnergy;
			o.scale = scale;
			length++;
			info.push(o);
		}
		
		/**
		 * 设置能量增长速度
		 * @param	playerId	如果是0就全部都初始化	
		 * @param	scale	
		 */
		public function changeEnergy(playerId:int, value:Number):void
		{
			var o:Object = g.speedFact.n_object();
			o.type = RecordType.InitChangeEnergy;
			o.playerId = playerId;
			o.value = value;
			length++;
			info.push(o);
		}
		
		/**
		 * 初始化在场景上的卡牌
		 * @param	id			释放某一个ID的卡牌
		 * @param	serverId	服务器给的ID
		 * @param	camp		阵营ID
		 * @param	pos			位置
		 * @param	boss		是否为BOSS
		 * @param	activate	是否已经被激活,激活的角色会有攻击AI,会走技能
		 * @param	inHot		是否移动到了可移动的区域内, 是否已经进入正常地图范围内,如果不在将无法选中和攻击
		 */
		public function releaseCardPos(id:int, serverId:int, playerId:int, camp:int, pos:int, boss:Boolean, activate:Boolean, inHot:Boolean):void
		{
			var o:Object = g.speedFact.n_object();
			o.type = RecordType.InitRoleCardPos;
			o.id = id;
			o.serverId = serverId;
			o.playerId = playerId;
			o.camp = camp;
			o.pos = pos;
			o.boss = boss;
			o.activate = activate;
			o.inHot = inHot;
			length++;
			info.push(o);
		}
		
		/**
		 * 初始化在场景上的卡牌
		 * @param	playerId	玩家ID
		 * @param	card1		卡牌ID
		 * @param	card2
		 * @param	card3
		 * @param	card4
		 * @param	card5
		 */
		public function cardList(playerId:int, card1:int, card2:int, card3:int, card4:int, card5:int):void
		{
			var o:Object = g.speedFact.n_object();
			o.type = RecordType.InitCardList;
			o.playerId = playerId;
			o.card1 = card1;
			o.card2 = card2;
			o.card3 = card3;
			o.card4 = card4;
			o.card5 = card5;
			length++;
			info.push(o);
		}
		
		/**
		 * 设置Camp对象,如果有这个玩家就修改玩家,如果没有就添加
		 * @param	campId
		 * @param	playerId
		 * @param	using		是否启用
		 */
		public function setCampPlayer(campId:int, playerId:int, using:Boolean):void
		{
			var o:Object = g.speedFact.n_object();
			o.type = RecordType.InitSetCampPlayer;
			o.campId = campId;
			o.playerId = playerId;
			o.using = using;
			length++;
			info.push(o);
		}
		
		/**
		 * 设置现在默认玩家playerId
		 * @param	playerId
		 */
		public function setPlayer(playerId:int):void
		{
			var o:Object = g.speedFact.n_object();
			o.type = RecordType.InitPlayer;
			o.playerId = playerId;
			length++;
			info.push(o);
		}
		
		/**
		 * 初始化在场景上的卡牌
		 * @param	id			释放某一个ID的卡牌
		 * @param	serverId	服务器给的ID
		 * @param	camp		阵营ID
		 * @param	x			位置
		 * @param	y			位置
		 * @param	boss		是否为BOSS
		 * @param	activate	是否已经被激活,激活的角色会有攻击AI,会走技能
		 * @param	inHot		是否移动到了可移动的区域内, 是否已经进入正常地图范围内,如果不在将无法选中和攻击
		 * @param	towerType	塔类型
		 */
		public function releaseCardXY(id:int, serverId:int, playerId:int, camp:int, x:int, y:int, boss:Boolean, activate:Boolean, inHot:Boolean, towerType:int, heroSkill:InfoHeroAddSkill = null):void
		{
			var o:Object = g.speedFact.n_object();
			o.type = RecordType.InitRoleCardXY;
			o.id = id;
			o.serverId = serverId;
			o.playerId = playerId;
			o.camp = camp;
			o.x = x;
			o.y = y;
			o.boss = boss;
			o.activate = activate;
			o.inHot = inHot;
			o.towerType = towerType;
			if (heroSkill)
			{
				o.c1 = heroSkill.card1;
				o.c2 = heroSkill.card2;
				o.c3 = heroSkill.card3;
				o.c4 = heroSkill.card4;
				o.s1 = heroSkill.cardSkill1;
				o.s2 = heroSkill.cardSkill2;
				o.s3 = heroSkill.cardSkill3;
				o.s4 = heroSkill.cardSkill4;
			}
			else
			{
				o.c1 = 0;
				o.c2 = 0;
				o.c3 = 0;
				o.c4 = 0;
				o.s1 = 0;
				o.s2 = 0;
				o.s3 = 0;
				o.s4 = 0;
			}
			length++;
			info.push(o);
		}
		
		/** 将全部的Info设置起来 **/
		public function initAll():void
		{
			if (length)
			{
				var ed:EDRole;
				var camp:EDCamp;
				var player:EDCampPlayer;
				for each (var o:Object in info) 
				{
					switch (o.type) 
					{
						case RecordType.InitRandom:
							u.randomGroup = o.group;
							u.randomSite = o.site;
							u.randomSet(o.group, o.site);
							break;
						case RecordType.InitMode:
							u.modeAttack = o.attack;
							u.modeTurn = o.turn;
							u.modeMovePhys = o.phys;
							break;
						case RecordType.InitEnergy:
							u.engine.time.timeEnergyScale = o.scale;
							break;
						case RecordType.InitChangeEnergy:
							for each (camp in u.engine.campLib) 
							{
								if (o.playerId == 0)
								{
									setCampEnergy(camp, o.value);
								}
								else
								{
									if (camp.playerObj && camp.playerObj.hasOwnProperty(o.playerId))
									{
										player = camp.playerObj[o.playerId];
										player.energyTemp = o.value;
										if (player.energyTemp > UpGameConfig.energyMax)
										{
											player.energyTemp = UpGameConfig.energyMax;
										}
										player.energyValue = int(player.energyTemp);
										
									}
								}
							}
							break;
						case RecordType.InitRoleCardPos:
							ed = ReleaseCard.callRoleCardPos(u, o.id, o.serverId, o.playerId, o.camp, o.pos, o.towerType) as EDRole;
							if (ed)
							{
								ed.info.boss = o.boss;
								ed.activate = o.activate;
								ed.inHot = o.inHot;
							}
							else
							{
								g.log.pushLog(this, LogType._ErrorLog, "初始化失败:释放卡牌错误ID:" + o.id + " 位置:" + o.pos);
							}
							break;
						case RecordType.InitRoleCardXY:
							var heroSkill:InfoHeroAddSkill = new InfoHeroAddSkill();
							heroSkill.card1 = o.c1;
							heroSkill.card2 = o.c2;
							heroSkill.card3 = o.c3;
							heroSkill.card4 = o.c4;
							heroSkill.cardSkill1 = o.s1;
							heroSkill.cardSkill2 = o.s2;
							heroSkill.cardSkill3 = o.s3;
							heroSkill.cardSkill4 = o.s4;
							ed = ReleaseCard.callRoleCardXY(u, o.id, o.serverId, o.playerId, o.camp, o.x, o.y, o.towerType, heroSkill) as EDRole;
							if (ed)
							{
								ed.info.boss = o.boss;
								ed.activate = o.activate;
								ed.inHot = o.inHot;
							}
							else
							{
								g.log.pushLog(this, LogType._ErrorLog, "初始化失败:释放卡牌错误ID:" + o.id);
							}
							break;
						case RecordType.InitCardList:
							for each (camp in u.engine.campLib) 
							{
								if (camp.playerObj && camp.playerObj.hasOwnProperty(o.playerId))
								{
									player = camp.playerObj[o.playerId];
									player.card1 = o.card1;
									player.card1Time = 0;
									player.card1TimeUse = 0;
									player.card2 = o.card2;
									player.card2Time = 0;
									player.card2TimeUse = 0;
									player.card3 = o.card3;
									player.card3Time = 0;
									player.card3TimeUse = 0;
									player.card4 = o.card4;
									player.card4Time = 0;
									player.card4TimeUse = 0;
									player.cardNext = o.card5;
									break;
								}
							}
							break;
						case RecordType.InitSetCampPlayer:
							camp = null;
							if (o.campId == 1)
							{
								camp = u.engine.camp1;
							}
							else if (o.campId == 2)
							{
								camp = u.engine.camp2;
							}
							if (camp)
							{
								if (camp.playerObj.hasOwnProperty(o.playerId))
								{
									player = camp.playerObj[o.playerId];
									player.using = o.using;
								}
								else
								{
									player = new EDCampPlayer(camp);
									player.playerId = o.playerId;
									player.using = o.using;
									camp.playerList.push(player);
									camp.playerLength++;
									camp.playerObj[player.playerId] = player;
								}
							}
							break;
						case RecordType.InitPlayer:
							for each (camp in u.engine.campLib) 
							{
								if (camp.playerObj && camp.playerObj.hasOwnProperty(o.playerId))
								{
									player = camp.playerObj[o.playerId];
									if (u.playerED != player) u.playerED = player;
									if (u.playerId != player.playerId) u.playerId = player.playerId;
									break;
								}
							}
							break;
					}
				}
			}
		}
		
		/** 设置阵营里的能量值 **/
		private function setCampEnergy(camp:EDCamp, value:Number):void
		{
			for each (var player:EDCampPlayer in camp.playerList) 
			{
				player.energyTemp = value;
				if (player.energyTemp > UpGameConfig.energyMax)
				{
					player.energyTemp = UpGameConfig.energyMax;
				}
				player.energyValue = int(player.energyTemp);
			}
		}
		
		/** 摧毁对象 **/
		public function dispose():void
		{
			if (u) u = null;
			if (info)
			{
				g.speedFact.d_array(info);
				info = null;
				length = 0;
			}
		}
	}
}