package cn.wjj.upgame.tools 
{
	import cn.wjj.display.MPoint;
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.upgame.common.InfoHeroAddSkill;
	import cn.wjj.upgame.data.CardInfoModel;
	import cn.wjj.upgame.data.HeroStarUpModel;
	import cn.wjj.upgame.data.RoleCardModel;
	import cn.wjj.upgame.data.UpGameData;
	import cn.wjj.upgame.engine.CRole;
	import cn.wjj.upgame.engine.EDBase;
	import cn.wjj.upgame.engine.EDCamp;
	import cn.wjj.upgame.engine.EDRole;
	import cn.wjj.upgame.engine.ORole;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 释放卡牌
	 * @author GaGa
	 */
	public class ReleaseCard
	{
		
		/** 名字的多语言 **/
		public static var lang_name:String = "";
		/** 多语言技能等级 **/
		public static var lang_lv:String = "";
		
		public function ReleaseCard() { }
		
		/**
		 * 添加召唤卡牌(使用位置)
		 * @param	u
		 * @param	id
		 * @param	serverId	服务器ID
		 * @param	playerId	玩家的ID
		 * @param	camp
		 * @param	pos
		 */
		public static function callCardPos(u:UpGame, id:int, serverId:int, playerId:int, camp:int, pos:int, towerType:int = 0, heroSkill:InfoHeroAddSkill = null):Object
		{
			var p:MPoint = getPosMPoint(u, pos);
			return callCardXY(u, id, serverId, playerId, camp, p.x, p.y, towerType, heroSkill);
		}
		
		/**
		 * 添加召唤卡牌(使用地图标记坐标)
		 * @param	u
		 * @param	id
		 * @param	serverId	服务器ID
		 * @param	playerId	玩家的ID
		 * @param	camp
		 * @param	tileX		地图标记的坐标
		 * @param	tileY
		 * @param	towerType	0,普通,1主塔,2副塔左,3副塔右
		 * @return
		 */
		public static function callCardPosXY(u:UpGame, id:int, serverId:int, playerId:int, camp:int, tileX:int, tileY:int, towerType:int = 0, heroSkill:InfoHeroAddSkill = null):Object
		{
			var p:MPoint = u.engine.astar.getMapPoint(tileX, tileY);
			return callCardXY(u, id, serverId, playerId, camp, p.x, p.y, towerType, heroSkill);
		}
		
		/**
		 * 添加召唤卡牌(使用地图实际坐标)
		 * @param	u
		 * @param	id
		 * @param	serverId	服务器ID
		 * @param	camp
		 * @param	x			地图实际像素坐标(格子中心点)
		 * @param	y			地图实际像素坐标(格子中心点)
		 * @param	towerType	0,普通,1主塔,2副塔左,3副塔右
		 * @return
		 */
		public static function callCardXY(u:UpGame, id:int, serverId:int, playerId:int, camp:int, x:int, y:int, towerType:int = 0, heroSkill:InfoHeroAddSkill = null):Object
		{
			var cardInfo:CardInfoModel = UpGameData.cardInfo.getItem("card_id", id);
			if (cardInfo)
			{
				if (cardInfo.SummonNumber == 1 || cardInfo.SummonNumber == 0)
				{
					switch (cardInfo.CardType) 
					{
						case 1://部队
						case 5://英雄
						case 6://非命中
							return callRoleCardXY(u, cardInfo.SummonCharacter, serverId, playerId, camp, x, y, towerType, heroSkill);
							break;
						case 2://法术
							ReleaseMagic.callCardXY(u, cardInfo, playerId, camp, x, y);
							break;
						case 3://建筑
							return callRoleCardXY(u, cardInfo.SummonCharacter, serverId, playerId, camp, x, y, towerType, heroSkill);
							break;
						case 4://主塔,副塔
							return callRoleCardXY(u, cardInfo.SummonCharacter, serverId, playerId, camp, x, y, towerType, heroSkill);
							break;
					}
				}
				else
				{
					var mpoint:Vector.<MPoint> = ReleaseCardMPoint.getPoint(u.engine.astar, cardInfo, camp, x, y);
					var edList:Array = g.speedFact.n_array();
					for each (var p:MPoint in mpoint)
					{
						switch (cardInfo.CardType) 
						{
							case 1://部队
							case 5://英雄
							case 6://非命中
								edList.push(callRoleCardXY(u, cardInfo.SummonCharacter, serverId, playerId, camp, p.x, p.y, towerType, heroSkill));
								break;
							case 2://法术
								ReleaseMagic.callCardXY(u, cardInfo, playerId, camp, p.x, p.y);
								break;
							case 3://建筑
								edList.push(callRoleCardXY(u, cardInfo.SummonCharacter, serverId, playerId, camp, p.x, p.y, towerType, heroSkill));
								break;
							case 4://主塔,副塔
								edList.push(callRoleCardXY(u, cardInfo.SummonCharacter, serverId, playerId, camp, p.x, p.y, towerType, heroSkill));
								break;
						}
					}
					return edList;
				}
			}
			return null;
		}
		
		/**
		 * (角色卡牌表)通过卡牌信息召唤出卡牌
		 * @param	u
		 * @param	id
		 * @param	serverId	服务器ID
		 * @param	camp
		 * @param	x			地图像素坐标
		 * @param	y			地图像素坐标
		 * @return
		 */
		public static function callRoleCardPos(u:UpGame, id:int, serverId:int, playerId:int, camp:int, pos:int, towerType:int = 0, heroSkill:InfoHeroAddSkill = null):EDBase
		{
			var p:MPoint = getPosMPoint(u, pos);
			return callRoleCardXY(u, id, serverId, playerId, camp, p.x, p.y, towerType, heroSkill);
		}
		
		/**
		 * (角色卡牌表)添加召唤卡牌(使用地图标记坐标)
		 * @param	u
		 * @param	id
		 * @param	serverId	服务器ID
		 * @param	camp
		 * @param	posX		地图标记的坐标
		 * @param	posY
		 * @param	towerType	0,普通,1主塔,2副塔左,3副塔右
		 * @return
		 */
		public static function callRoleCardPosXY(u:UpGame, id:int, serverId:int, playerId:int, camp:int, tileX:int, tileY:int, towerType:int = 0, heroSkill:InfoHeroAddSkill = null):Object
		{
			var p:MPoint = u.engine.astar.getMapPoint(tileX, tileY);
			return callRoleCardXY(u, id, serverId, playerId, camp, p.x, p.y, towerType, heroSkill);
		}
		
		/**
		 * (角色卡牌表)通过卡牌信息召唤出卡牌
		 * @param	u
		 * @param	id
		 * @param	serverId	服务器ID
		 * @param	camp
		 * @param	x			地图像素坐标(格子中心点)
		 * @param	y			地图像素坐标(格子中心点)
		 * @param	towerType	0,普通,1主塔,2副塔左,3副塔右
		 * @return
		 */
		public static function callRoleCardXY(u:UpGame, id:int, serverId:int, playerId:int, camp:int, x:int, y:int, towerType:int = 0, heroSkill:InfoHeroAddSkill = null):EDBase
		{
			var cardRole:RoleCardModel = UpGameData.cardRole.getItem("card_id", id);
			if (cardRole)
			{
				var edCamp:EDCamp;
				if (camp == 1)
				{
					edCamp = u.engine.camp1;
				}
				else
				{
					edCamp = u.engine.camp2;
				}
				var roleInfo:ORole = new ORole();
				roleInfo.id = id;
				if (serverId == 0)
				{
					edCamp.serverCount++;
					if (camp == 1)
					{
						roleInfo.serverId = 10000 + edCamp.serverCount;
					}
					else
					{
						roleInfo.serverId = 20000 + edCamp.serverCount;
					}
				}
				else
				{
					roleInfo.serverId = serverId;
				}
				roleInfo.autoPatrol = true;
				roleInfo.timeInit = cardRole.DeployTime;
				roleInfo.idType = 1;
				roleInfo.weight = cardRole.Mass;
				roleInfo.expDie = cardRole.Exp;
				roleInfo.dieSkill = cardRole.DeathSkill;			//死亡的动作
				roleInfo.skillInfo[0].id = cardRole.Cnskill;
				roleInfo.skillInfo[1].id = cardRole.CHskill;
				roleInfo.skillInfo[2].id = cardRole.CHskill2;
				roleInfo.skillInfo[3].id = cardRole.CHskill3;
				if (u.modeTurn)
				{
					if (camp == 1)
					{
						roleInfo.modelId = cardRole.Cmodel2;
					}
					else
					{
						roleInfo.modelId = cardRole.Cmodel;
					}
				}
				else
				{
					if (camp == 1)
					{
						roleInfo.modelId = cardRole.Cmodel;
					}
					else
					{
						roleInfo.modelId = cardRole.Cmodel2;
					}
				}
				roleInfo.aiType = cardRole.Cai;
				roleInfo.rangeGuard = cardRole.Csensitive;
				roleInfo.rangeView = cardRole.Clook;
				roleInfo.callMonster1 = cardRole.Cmonsterid;// 召唤技能配置参数
				//------------------------------------------获取信息
				roleInfo.level = cardRole.CardLevel;		// 卡牌等级
				switch (cardRole.CardType) 
				{
					case 1://部队
						if (cardRole.FlyingHeight == 0)
						{
							roleInfo.typeProperty = 1;		// 卡牌类型
						}
						else
						{
							roleInfo.typeProperty = 2;		// 卡牌类型
						}
						break;
					case 2://法术
						g.log.pushLog(ReleaseCard, LogType._ErrorLog, "角色卡牌中不可能出现法术卡牌");
						break;
					case 3://建筑
						roleInfo.typeProperty = 3;			// 卡牌类型
						roleInfo.size = cardRole.Mass;
						roleInfo.weight = ORole.weightBuilding;
						break;
					case 4://基地
						roleInfo.typeProperty = 4;			// 卡牌类型
						roleInfo.size = cardRole.Mass;
						roleInfo.weight = ORole.weightBuilding;
						break;
					case 5://英雄
						roleInfo.hero = true;
						if (heroSkill)
						{
							roleInfo.heroInfo = heroSkill;
						}
						else
						{
							roleInfo.heroInfo = new InfoHeroAddSkill();
						}
						if (cardRole.FlyingHeight == 0)
						{
							roleInfo.typeProperty = 1;		// 卡牌类型
						}
						else
						{
							roleInfo.typeProperty = 2;		// 卡牌类型
						}
						var starUpModel:HeroStarUpModel = UpGameData.heroStarUp.getItemArr(["HeroID", "Star"], [id, 1], ["==", "=="], [true, true]);
						if (starUpModel)
						{
							roleInfo.heroInfo.expNext = starUpModel.StarExp;
						}
						break;
					case 6://不能被攻击
						roleInfo.typeProperty = 5;
						break;
				}
				roleInfo.hp = cardRole.Chp;					// 生命
				roleInfo.atk = cardRole.Catt;				// 攻击
				roleInfo.def = cardRole.Cdef;				// 防御
				roleInfo.hpMax = cardRole.Chp;				// 生命
				roleInfo.atkTime = cardRole.Crate;			// 攻速
				roleInfo.atkTimeUp = cardRole.CattspX;		// 攻速修正
				roleInfo.speed = cardRole.Csp;				// 移动速度
				roleInfo.speedBase = cardRole.Csp;			// 调整用的速度
				roleInfo.speedMin = cardRole.Clsp;			// 最低速度
				roleInfo.hit = cardRole.Chit;				// 命中
				roleInfo.dodge = cardRole.Cdod;				// 闪避
				roleInfo.sealHit = cardRole.Cseal;			// 封印命中 -- 封命
				roleInfo.sealDodge = cardRole.Csealres;		// 封印闪避 -- 封抗
				roleInfo.crit = cardRole.Clethality;		// 致命率
				roleInfo.tenacity = cardRole.Ctenacity;		// 韧性
				roleInfo.critHurt = cardRole.CFinjury;		// 致命伤害
				roleInfo.critDef = cardRole.Cfinjuryres;	// 致命伤害抵抗 - 暴击抵抗
				roleInfo.atkUp = cardRole.CattX;			// 攻击增强
				roleInfo.hpUp = cardRole.ChpX;				// 生命增强
				roleInfo.treatUp = cardRole.CcureX;			// 治疗增强
				roleInfo.defUp = cardRole.Cdefx;			// 防御比例
				roleInfo.treatEffect = cardRole.Cbetreated;	// 被治疗比例
				roleInfo.skillInfo[0].lv = 1;
				roleInfo.skillInfo[1].lv = 1;								// 技能1等级
				roleInfo.skillInfo[1].cd = cardRole.Ccdreduce1;				// 技能1cd降低值
				roleInfo.skillInfo[1].cdStart = cardRole.Cinitialcdreduce1;	// 技能1初始cd降低值
				roleInfo.skillInfo[2].lv = 1;								// 技能2等级
				roleInfo.skillInfo[2].cd = cardRole.Ccdreduce2;				// 技能2cd降低值
				roleInfo.skillInfo[2].cdStart = cardRole.Cinitialcdreduce2;	// 技能2初始cd降低值
				roleInfo.skillInfo[3].lv = 1;								// 技能3等级
				roleInfo.skillInfo[3].cd = cardRole.Ccdreduce3;				// 技能3cd降低值
				roleInfo.skillInfo[3].cdStart = cardRole.Cinitialcdreduce3;	// 技能3初始cd降低值
				roleInfo.skillInfo[4].lv = 1				;				// 技能4等级
				roleInfo.skillInfo[4].cd = cardRole.Ccdreduce4;				// 技能4cd降低值
				roleInfo.skillInfo[4].cdStart = cardRole.Cinitialcdreduce4;	// 技能4初始cd降低值
				//-------------------------------------------
				var angle:int = -1;//roleInfo.startAngle 初始角度值没了
				if (angle == -1)
				{
					if (camp == 1)
					{
						angle = 270;
					}
					else
					{
						angle = 90;
					}
				}
				var ed:EDRole;
				if (towerType == 1)
				{
					ed = CRole.create(u, roleInfo, playerId, camp, 0, angle, x, y, true);
				}
				else
				{
					ed = CRole.create(u, roleInfo, playerId, camp, 0, angle, x, y);
				}
				if (ed)
				{
					if (towerType != 0)
					{
						switch (towerType) 
						{
							case 1:
								edCamp.towerCenter = ed;
								break;
							case 2:
								edCamp.towerLeft = ed;
								break;
							case 3:
								edCamp.towerRight = ed;
								break;
						}
					}
					u.engine.playerList.push(ed);
					u.engine.playerLength++;
					return ed;
				}
			}
			return null;
		}
		
		/**
		 * 获取位置的坐标(已经是中心点)
		 * @param	u
		 * @param	pos
		 * @return
		 */
		public static function getPosMPoint(u:UpGame, pos:int):MPoint
		{
			//找到数据里的策划的位置. 通过index
			var p:MPoint = MPoint.instance(u.engine.astar.hotCenterX, u.engine.astar.hotCenterY);
			if (u.info.aStar.monster.hasOwnProperty(pos))
			{
				var a:Array = u.info.aStar.monster[pos];
				if (a.length > 0)
				{
					var s:int = 0;
					if(a.length > 2)
					{
						s = int((a.length / 2) * u.random) * 2;
						if (s == a.length) s = a.length - 2;
					}
					p.x = a[s];
					p.y = a[s + 1];
				}
				else
				{
					g.log.pushLog(NetStartBattle, LogType._ErrorLog, "地图怪物点无数据 : " + pos);
				}
			}
			else
			{
				g.log.pushLog(NetStartBattle, LogType._ErrorLog, "地图无怪物点 : " + pos);
			}
			return p;
		}
	}
}