package cn.wjj.upgame.tools 
{
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.upgame.data.InfoRoleCardModel;
	import cn.wjj.upgame.data.MonsterAttributeModel;
	import cn.wjj.upgame.data.RoleCardModel;
	import cn.wjj.upgame.data.UpGameData;
	import cn.wjj.upgame.engine.CRole;
	import cn.wjj.upgame.engine.EDRole;
	import cn.wjj.upgame.engine.ORole;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 使用服务器的数据
	 * 
	 * 关卡ID
	 * 
	 * 
	 * 
	 * @author GaGa
	 */
	public class NetStartBattle 
	{
		
		public function NetStartBattle() { }
		
		/**
		 * 初始化信息,获取有多少波,多少组
		 * @param	u
		 * @param	data
		 */
		//public static function initGroupRound(u:UpGame, data:Stru_INST_DATA):void
		public static function initGroupRound(u:UpGame, data:*):void
		{
			if (u.isLive && data.miMonsterTypeCount)
			{
				//找到最大
				var o:Object = new Object();
				var i:int;
				var group:int;
				var round:int;
				var maxRound:int = 0;
				//var item:Stru_MONSTER_INST_DATA;
				var item:*;
				for each (item in data.moFriendNpc)
				{
					if (maxRound < item.miIdx)
					{
						maxRound = item.miIdx;
					}
					if (o.hasOwnProperty(item.miIdx))
					{
						o[item.miIdx]++;
					}
					else
					{
						o[item.miIdx] = 1;
					}
				}
				for each (item in data.moMonstList)
				{
					if (maxRound < (item.miIdx + 1))
					{
						maxRound = item.miIdx + 1;
					}
					if (o.hasOwnProperty(item.miIdx))
					{
						o[item.miIdx]++;
					}
					else
					{
						o[item.miIdx] = 1;
					}
				}
				//设置数组
				group = int(maxRound / 50) + 1;
				u.engine.roundGroupLength = group;
				for (i = 0; i < group; i++)
				{
					u.engine.roundGroupTimeNext.push(0);
					u.engine.roundGroupRoleLength.push(0);
					u.engine.roundGroupItemlength.push(0);
					u.engine.roundGroupItemComplete.push(0);
				}
				//校验添加波次
				for (i = 0; i < maxRound; i++)
				{
					if (o.hasOwnProperty(i))
					{
						group = int(i / 50);
						round = - group * 50 + i;
						if (u.engine.roundGroupItemlength[group] == round)
						{
							u.engine.roundGroupItemlength[group]++;
						}
						else
						{
							g.log.pushLog(NetStartBattle, LogType._ErrorLog, "刷波次出现非连续错误,组" + group + " 现在长度 " + u.engine.roundGroupItemlength[group] + " 中断执行ID : " + i);
						}
					}
				}
			}
		}
		
		/**
		 * 设置下一个的ID
		 * 添加助战NPC
		 * 添加怪物
		 * 
		 * @param	upGame		
		 * @param	roleCard
		 * @param	o
		 * @param	group		属于第几组
		 * @param	groupRound		添加第几波
		 */
		//public static function setRoundId(u:UpGame, data:Stru_INST_DATA, group:int, groupRound:int):void
		public static function setRoundId(u:UpGame, data:*, group:int, groupRound:int):void
		{
			if (u.isLive && u.engine.roundGroupLength > group)
			{
				var round:int = group * 50 + groupRound;
				//var item:Stru_MONSTER_INST_DATA;
				var item:*;
				if (data.miMonsterTypeCount)
				{
					if(data.miFriendNpcCount)
					{
						for each (item in data.moFriendNpc) 
						{
							if (item.miIdx == round)
							{
								pushMonst(u, vectorToObject(data.miMonsterTypeList), item, 1, group, true);
							}
						}
					}
					if(data.miMonsterCount)
					{
						for each (item in data.moMonstList) 
						{
							if (item.miIdx == round)
							{
								pushMonst(u, vectorToObject(data.miMonsterTypeList), item, 2, group);
							}
						}
					}
				}
				u.engine.roundGroupTimeNext[group] = 0;
				if(data.miGroupCount)
				{
					//for each (var groupInfo:Stru_BATTLE_GROUP_INFO in data.moGroupList) 
					for each (var groupInfo:* in data.moGroupList) 
					{
						if (groupInfo.miGroupIdx == round)
						{
							if (groupInfo.miGroupTime > 0)
							{
								u.engine.roundGroupTimeNext[group] = groupInfo.miGroupTime * 1000 + u.engine.time.timeEngine;
							}
							else
							{
								u.engine.roundGroupTimeNext[group] = 0;
							}
							break;
						}
					}
				}
			}
		}
		
		/** 将Vector转换为Object的列表 **/
		private static function vectorToObject(vector:*):Vector.<Object>
		{
			var o:Vector.<Object> = new Vector.<Object>();
			for each (var item:* in vector) 
			{
				o.push(item);
			}
			return o;
		}
		
		/**
		 * 添加一个角色,如果成功返回这个角色
		 * @param	u
		 * @param	role		角色数据
		 * @param	pos			在地图上的初始位置
		 * @param	camp
		 * @param	isFriend
		 * @return
		 */
		public static function pushTeamRole(u:UpGame, role:InfoRoleCardModel, pos:int, camp:int, group:int, isFriend:Boolean = false, isPVP:Boolean = false):EDRole
		{
			if (u.isLive)
			{
				var ed:EDRole = createRole(u, role, pos, camp, group, isFriend, isPVP);
				if (ed)
				{
					if (camp == 1)
					{
						if (isFriend)
						{
							u.engine.playerFriendList.push(ed);
							u.engine.playerFriendLength++;
						}
						else
						{
							u.engine.playerList.push(ed);
							u.engine.playerLength++;
						}
					}
					return ed;
				}
			}
			return null;
		}
		
		/**
		 * 添加一个角色,如果成功返回这个角色
		 * @param	u
		 * @param	role		角色数据
		 * @param	pos			在地图上的初始位置
		 * @param	camp
		 * @param	isFriend
		 * @return
		 */
		public static function pushTeamRoleXY(u:UpGame, role:InfoRoleCardModel, x:int, y:int, camp:int, group:int, isFriend:Boolean = false, isPVP:Boolean = false):EDRole
		{
			if (u.isLive)
			{
				var ed:EDRole = createRoleXY(u, role, x, y, camp, group, isFriend, isPVP);
				if (ed)
				{
					if (camp == 1)
					{
						if (isFriend)
						{
							u.engine.playerFriendList.push(ed);
							u.engine.playerFriendLength++;
						}
						else
						{
							u.engine.playerList.push(ed);
							u.engine.playerLength++;
						}
					}
					return ed;
				}
			}
			return null;
		}
		
		/**
		 * 添加怪物
		 * 
		 * @param	upGame	upGame对象
		 * @param	o
		 * @param	item	怪物数据
		 * @param	camp	阵营
		 * @param	isNPC	友方NPC
		 * @return
		 */
		//private static function pushMonst(u:UpGame, miMonsterTypeList:Vector.<Stru_MONSTER_DATA>, item:Stru_MONSTER_INST_DATA, camp:int, group:int, isNPC:Boolean = false):EDRole
		private static function pushMonst(u:UpGame, miMonsterTypeList:Vector.<Object>, item:*, camp:int, group:int, isNPC:Boolean = false):EDRole
		{
			if (u.isLive)
			{
				var info:ORole = new ORole();
				//var typeInfo:Stru_MONSTER_DATA = getMonsterType(miMonsterTypeList, item.miMonsterTypeID);
				var typeInfo:* = getMonsterType(miMonsterTypeList, item.miMonsterTypeID);
				if (typeInfo)
				{
					var px:int = u.engine.astar.hotCenterX;
					var py:int = u.engine.astar.hotCenterY;
					if (u.info.aStar.monster.hasOwnProperty(item.miPos))
					{
						var a:Array = u.info.aStar.monster[item.miPos];
						if (a.length)
						{
							var s:int = 0;
							if(a.length > 2)
							{
								s = int((a.length / 2) * u.random) * 2;
								if (s == a.length) s = a.length - 2;
							}
							px = a[s];
							py = a[s + 1];
						}
						else
						{
							g.log.pushLog(NetStartBattle, LogType._ErrorLog, "地图怪物点无数据 : " + item.miPos);
						}
					}
					else
					{
						g.log.pushLog(NetStartBattle, LogType._ErrorLog, "地图无怪物点 : " + item.miPos);
					}
					getMonsterInfo(info, typeInfo.moCombatProperty);
					info.id = item.miMonsterTypeID;
					info.idType = 2;
					info.serverId = item.miMonsterID;
					info.hp = item.miCurHP;
					var angle:int = info.startAngle;
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
					var ed:EDRole = CRole.create(u, info, 0, camp, group, angle, px, py);
					if (camp == 1 && isNPC)
					{
						u.engine.playerNPCList.push(ed);
						u.engine.playerNPCLength++;
					}
					return ed;
				}
				else
				{
					g.log.pushLog(NetStartBattle, LogType._ErrorLog, "没有获取到怪物类型对应数据 : " + item.miMonsterTypeID);
				}
			}
			return null;
		}
		
		/**
		 * 添加召唤怪物
		 * @param	u					upGame对象
		 * @param	o
		 * @param	monsterTypeID		怪物类型
		 * @param	posX				出现点
		 * @param	posY				出现点
		 * @param	camp				阵营
		 * @return
		 */
		//public static function pushCallMonst(u:UpGame, miMonsterTypeList:Vector.<Stru_MONSTER_DATA>, monsterTypeID:int, posX:int, posY:int, camp:int, group:int):EDRole
		public static function pushCallMonst(u:UpGame, miMonsterTypeList:Vector.<Object>, monsterTypeID:int, posX:int, posY:int, camp:int, group:int):EDRole
		{
			if (u.isLive)
			{
				var info:ORole = new ORole();
				//var typeInfo:Stru_MONSTER_DATA = getMonsterType(miMonsterTypeList, monsterTypeID);
				var typeInfo:* = getMonsterType(miMonsterTypeList, monsterTypeID);
				if (typeInfo)
				{
					getMonsterInfo(info, typeInfo.moCombatProperty);
					var callId:int = 0;
					if (u.engine.callId.hasOwnProperty(monsterTypeID))
					{
						callId = u.engine.callId[monsterTypeID];
					}
					callId++;
					u.engine.callId[monsterTypeID] = callId;
					info.serverId = monsterTypeID * 10000 + callId;
					info.id = monsterTypeID;
					info.idType = 2;
					info.hp = info.hpMax;
					info.isCall = true;
					var angle:int = info.startAngle;
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
					var ed:EDRole = CRole.create(u, info, 0, camp, group, angle, posX, posY);
					if (camp == 1)
					{
						u.engine.playerCallList.push(ed);
						u.engine.playerCallLength++;
					}
					return ed;
				}
				else
				{
					g.log.pushLog(NetStartBattle, LogType._ErrorLog, "召唤没有获取到怪物类型数据 : " + monsterTypeID);
				}
			}
			return null;
		}
		
		/**
		 * 通过怪物表创建一个怪物
		 * @param	u
		 * @param	m
		 * @param	pos
		 * @param	camp
		 * @return
		 */
		public static function createUseMonster(u:UpGame, m:MonsterAttributeModel, pos:int, camp:int, group:int):EDRole
		{
			if (u.isLive)
			{
				var info:ORole = new ORole();
				info.id = m.Id;
				info.atk 					= m.Att;				// 攻击
				info.atkRate				= 0;					// 攻击频率
				info.def 					= m.def;				// 防御
				info.hpMax 					= m.Hp;					// 生命
				info.hp						= m.Hp;
				info.atkTime 				= m.attsp;				// 攻击间隔
				info.speed 					= m.Sp;					// 移动速度
				info.hit 					= m.Hit;				// 命中
				info.dodge 					= m.Dod;				// 闪避
				info.sealHit 				= m.seal;				// 封印命中 -- 封命
				info.sealDodge 				= m.sealres;			// 封印闪避 -- 封抗
				info.crit 					= m.lethality;			// 致命率
				info.tenacity 				= m.tenacity;			// 韧性
				info.critHurt 				= m.Finjury;			// 致命伤害
				info.critDef 				= m.finjuryres;			// 致命伤害抵抗 - 暴击抵抗
				info.atkUp 					= m.attX;				// 攻击增强
				info.hpUp 					= m.hpX;				// 生命增强
				info.atkTimeUp	 			= m.attspX;				// 攻速修正
				info.treatUp 				= m.cureX;				// 治疗增强
				info.defUp					= m.defx;				// 防御比例
				info.treatEffect 			= m.betreated;			// 被治疗比例
				info.regeneration 			= m.Regenerationvalue;	// 再生值
				info.skillInfo[1].cdStart	= m.initialcdreduce1;	// 技能1初始cd降低值
				info.skillInfo[2].cdStart	= m.initialcdreduce2;	// 技能2初始cd降低值
				info.skillInfo[3].cdStart	= m.initialcdreduce3;	// 技能3初始cd降低值
				info.skillInfo[4].cdStart	= m.initialcdreduce4;	// 技能4初始cd降低值
				info.skillInfo[1].cd		= m.cdreduce1;			// 技能1cd降低值
				info.skillInfo[2].cd		= m.cdreduce2;			// 技能2cd降低值
				info.skillInfo[3].cd		= m.cdreduce3;			// 技能3cd降低值
				info.skillInfo[4].cd		= m.cdreduce4;			// 技能4cd降低值
				info.modelId				= m.Card;				// 形象
				if (m.Boss)											// BOSS
				{
					info.boss				= true;
				}
				else
				{
					info.boss				= false;
				}
				info.rangeView				= m.look;				// 视野范围
				info.rangeGuard				= m.sensitive;			// 敏感范围
				info.skillInfo[0].id		= m.Pskillid;			// 普通技能
				info.skillInfo[1].id		= m.Gskillid;			// 技能1
				info.skillInfo[2].id		= m.Gskillid2;			// 技能2
				info.skillInfo[3].id		= m.Gskillid3;			// 技能3
				info.skillInfo[4].id		= m.Gskillid4;			// 技能4
				info.hpDisplayType			= m.hpdisplaytype;		// 血条显示类型
				info.hpDisplayNum			= m.hpdisplaynum;		// 血条显示层数
				info.callMonster2			= m.monsterid1;			// 召唤技能召唤的角色1,ID
				info.callMonster3			= m.monsterid2;			// 召唤技能召唤的角色2,ID
				if (m.actionStart == 1)								// 0怪刷出后直接走入场景，1怪被激活后再走入场景
				{
					info.actionStart = true;
				}
				else
				{
					info.actionStart = false;
				}
				info.aiType					= m.ai;					// AI类型
				info.startAngle				= m.first;				// 怪物出来的初始角度
				info.maxCall				= m.callTotal;			// 召唤怪物的上限
				//找到数据里的策划的位置. 通过index
				var px:int = u.engine.astar.hotCenterX;
				var py:int = u.engine.astar.hotCenterY;
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
						px = a[s];
						py = a[s + 1];
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
				var angle:int = info.startAngle;
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
				return CRole.create(u, info, 0, camp, group, angle, px, py);
			}
			return null;
		}
		
		/**
		 * 
		 * @param	upGame
		 * @param	role		本地的数据
		 * @param	pos			地图位置
		 * @param	camp		阵营, 0, 为无阵营,1, 自己阵营, 2, 敌方阵营
		 * @param	isFriend
		 * @return
		 */
		private static function createRole(u:UpGame, role:InfoRoleCardModel, pos:int, camp:int, group:int, isFriend:Boolean = false, isPVP:Boolean = false):EDRole
		{
			if (u.isLive)
			{
				var info:ORole = createRoleInfo(u, role, camp, isFriend, isPVP);
				if (info)
				{
					//找到数据里的策划的位置. 通过index
					var px:int = u.engine.astar.hotCenterX;
					var py:int = u.engine.astar.hotCenterY;
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
							px = a[s];
							py = a[s + 1];
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
					var angle:int = info.startAngle;
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
					return CRole.create(u, info, 0, camp, group, angle, px, py);
				}
				else
				{
					g.log.pushLog(NetStartBattle, LogType._ErrorLog, "没有在卡牌数据中找到卡牌 : " + role.planId);
				}
			}
			return null;
		}
		
		/**
		 * 
		 * @param	upGame
		 * @param	role		本地的数据
		 * @param	camp		阵营, 0, 为无阵营,1, 自己阵营, 2, 敌方阵营
		 */
		private static function createRoleXY(u:UpGame, role:InfoRoleCardModel, x:int, y:int, camp:int, group:int, isFriend:Boolean, isPVP:Boolean):EDRole
		{
			if (u.isLive)
			{
				var info:ORole = createRoleInfo(u, role, camp, isFriend, isPVP);
				if (info)
				{
					var angle:int = info.startAngle;
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
					return CRole.create(u, info, 0, camp, group, angle, x, y);
				}
				else
				{
					g.log.pushLog(NetStartBattle, LogType._ErrorLog, "没有在卡牌数据中找到卡牌 : " + role.planId);
				}
			}
			return null;
		}
		
		/**
		 * 将一个EDRole添加到upGame中
		 * @param	upGame
		 * @param	role
		 * @param	pos
		 * @param	camp
		 * @param	isFriend
		 */
		public static function addEDRole(u:UpGame, role:EDRole, pos:int, camp:int, group:int, isFriend:Boolean = false):void
		{
			if (u.isLive)
			{
				var px:int = u.engine.astar.hotCenterX;
				var py:int = u.engine.astar.hotCenterY;
				if (u.info.aStar.monster.hasOwnProperty(pos))
				{
					var a:Array = u.info.aStar.monster[pos];
					if (a.length)
					{
						var s:int = 0;
						if(a.length > 2)
						{
							s = int((a.length / 2) * u.random) * 2;
							if (s == a.length) s = a.length - 2;
						}
						px = a[s];
						py = a[s + 1];
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
				var angle:int = 0;
				if (camp == 1)
				{
					angle = 270;
				}
				else
				{
					angle = 90;
				}
				CRole.addEDRole(u, role, camp, group, angle, px, py);
			}
		}
		
		/**
		 * 创建Role的数据
		 * @param	role
		 * @return
		 */
		public static function createRoleInfo(u:UpGame, role:InfoRoleCardModel, camp:int, isFriend:Boolean, isPVP:Boolean):ORole
		{
			if (u.isLive)
			{
				var card:RoleCardModel = UpGameData.cardRole.getItem("card_id", role.planId);
				if (card)
				{
					var info:ORole = new ORole();
					//写入策划数据
					//info.card = card;
					info.skillInfo[0].id = card.Cnskill;
					info.skillInfo[1].id = card.CHskill;
					info.skillInfo[2].id = card.CHskill2;
					info.skillInfo[3].id = card.CHskill3;
					if (camp == 1)
					{
						info.modelId = card.Cmodel;
					}
					else
					{
						info.modelId = card.Cmodel2;
					}
					info.aiType = card.Cai;
					if (isPVP)
					{
						info.rangeGuard = card.Csensitive * 100;
						info.rangeView = card.Clook * 100;
					}
					else
					{
						info.rangeGuard = card.Csensitive;
						info.rangeView = card.Clook;
					}
					info.callMonster1 = card.Cmonsterid;// 召唤技能配置参数
					//测试使用 * 10
					info.hp = role.health;
					//写入本地数据
					info.id = role.planId;
					info.serverId = role.serverId;
					info.idType = 1;
					info.isFriend = isFriend;
					info.atk = role.attack;				// 攻击
					info.def = role.defence;			// 防御
					info.hpMax = role.health;			// 生命
					info.atkTime = role.rate;			// 攻速
					info.atkTimeUp = role.rateX;		// 攻速修正
					info.speed = role.speed;			// 移动速度
					info.hit = role.hit;				// 命中
					info.dodge = role.dodge;			// 闪避
					info.sealHit = role.sealHit;		// 封印命中 -- 封命
					info.sealDodge = role.sealDodge;	// 封印闪避 -- 封抗
					info.crit = role.lethality;			// 致命率
					info.tenacity = role.tenacity;		// 韧性
					info.critHurt = role.finjury;		// 致命伤害
					info.critDef = role.finjuryres;		// 致命伤害抵抗 - 暴击抵抗
					info.atkUp = role.attX;				// 攻击增强
					info.hpUp = role.hpX;				// 生命增强
					info.treatUp = role.cureX;			// 治疗增强
					info.defUp = role.defX;				// 防御比例
					info.treatEffect = role.betreated;	// 被治疗比例
					info.skillInfo[0].lv = role.normalSkillLv;
					info.skillInfo[1].lv = role.activeSkillLv;			// 技能1等级
					info.skillInfo[1].cd = role.cdreduce1;				// 技能1cd降低值
					info.skillInfo[1].cdStart = role.initialcdreduce1;	// 技能1初始cd降低值
					info.skillInfo[2].lv = role.activeSkill2Lv;			// 技能2等级
					info.skillInfo[2].cd = role.cdreduce2;				// 技能2cd降低值
					info.skillInfo[2].cdStart = role.initialcdreduce2;	// 技能2初始cd降低值
					info.skillInfo[3].lv = role.activeSkill3Lv;			// 技能3等级
					info.skillInfo[3].cd = role.cdreduce3;				// 技能3cd降低值
					info.skillInfo[3].cdStart = role.initialcdreduce3;	// 技能3初始cd降低值
					info.skillInfo[4].lv = role.activeSkill4Lv;			// 技能4等级
					info.skillInfo[4].cd = role.cdreduce4;				// 技能4cd降低值
					info.skillInfo[4].cdStart = role.initialcdreduce4;	// 技能4初始cd降低值
					
					
					//-----------------------------------------------------------------
					//新的字段
					
					info.typeProperty = 1;
					
					
					
					//-----------------------------------------------------------------
					return info;
				}
			}
			return null;
		}
		
		/**
		 * 获取怪物类型对应的数据
		 * 
		 * @param	o
		 * @param	monsterType
		 */
		//private static function getMonsterType(miMonsterTypeList:Vector.<Stru_MONSTER_DATA>, monsterType:int):Stru_MONSTER_DATA
		private static function getMonsterType(miMonsterTypeList:Vector.<Object>, monsterType:int):*
		{
			if (miMonsterTypeList)
			{
				//for each (var item:Stru_MONSTER_DATA in miMonsterTypeList) 
				for each (var item:* in miMonsterTypeList)
				{
					if (item.miPropsTypeID == monsterType)
					{
						return item;
					}
				}
			}
			g.log.pushLog(NetStartBattle, LogType._ErrorLog, "没有找到怪物数据 : " + monsterType);
			return null;
		}
		
		/**
		 * 将数据里的
		 * @param	info
		 * @param	list
		 */
		private static function getMonsterInfo(info:ORole, list:Vector.<int>):void
		{
			info.atk 					= list[0];		// 攻击
			info.atkRate				= list[1];		// 攻击频率
			info.def 					= list[2];		// 防御
			info.hpMax 					= list[3];		// 生命
			info.atkTime 				= list[4];		// 攻击间隔
			info.speed 					= list[5];		// 移动速度
			info.hit 					= list[6];		// 命中
			info.dodge 					= list[7];		// 闪避
			info.sealHit 				= list[8];		// 封印命中 -- 封命
			info.sealDodge 				= list[9];		// 封印闪避 -- 封抗
			info.crit 					= list[10];		// 致命率
			info.tenacity 				= list[11];		// 韧性
			info.critHurt 				= list[12];		// 致命伤害
			info.critDef 				= list[13];		// 致命伤害抵抗 - 暴击抵抗
			info.atkUp 					= list[14];		// 攻击增强
			info.hpUp 					= list[15];		// 生命增强
			info.atkTimeUp	 			= list[16];		// 攻速修正
			info.treatUp 				= list[17];		// 治疗增强
			info.defUp					= list[18];		// 防御比例
			info.treatEffect 			= list[19];		// 被治疗比例
			info.regeneration 			= list[20];		// 再生值
			info.skillInfo[1].cdStart	= list[21];		// 技能1初始cd降低值
			info.skillInfo[2].cdStart	= list[22];		// 技能2初始cd降低值
			info.skillInfo[3].cdStart	= list[23];		// 技能3初始cd降低值
			info.skillInfo[4].cdStart	= list[24];		// 技能4初始cd降低值
			info.skillInfo[1].cd		= list[25];		// 技能1cd降低值
			info.skillInfo[2].cd		= list[26];		// 技能2cd降低值
			info.skillInfo[3].cd		= list[27];		// 技能3cd降低值
			info.skillInfo[4].cd		= list[28];		// 技能4cd降低值
			info.modelId				= list[29];		// 形象
			info.boss					= list[30];		// BOSS
			info.rangeView				= list[31];		// 视野范围
			info.rangeGuard				= list[32];		// 敏感范围
			info.skillInfo[0].id		= list[33];		// 普通技能
			info.skillInfo[1].id		= list[34];		// 技能1
			info.skillInfo[2].id		= list[35];		// 技能2
			info.skillInfo[3].id		= list[36];		// 技能3
			info.skillInfo[4].id		= list[37];		// 技能4
			info.hpDisplayType			= list[38];		// 血条显示类型
			info.hpDisplayNum			= list[39];		// 血条显示层数
			info.callMonster2			= list[40];		// 召唤技能召唤的角色1,ID
			info.callMonster3			= list[41];		// 召唤技能召唤的角色2,ID
			if (list[42] == 1)							// 0怪刷出后直接走入场景，1怪被激活后再走入场景
			{
				info.actionStart = true;
			}
			else
			{
				info.actionStart = false;
			}
			info.aiType					= list[43];		// AI类型
			info.startAngle				= list[44];		// 怪物出来的初始角度
			info.maxCall				= list[45];		// 召唤怪物最大数量
			
			//-----------------------------------------------------------------
			//新的字段
			
			info.typeProperty = 1;
			
			
			
			//-----------------------------------------------------------------
		}
		
		/**
		 * 添加PVP对手的对象
		 * @param	u				游戏引用
		 * @param	o
		 * @param	serverId		服务器ID
		 * @param	pos				位置数据
		 * @param	camp			阵营
		 * @return
		 */
		//public static function pushPvpRolePos(u:UpGame, o:Stru_PLAYER_DETAIL_ARMY, serverId:uint, pos:int, camp:int, group:int):EDRole
		public static function pushPvpRolePos(u:UpGame, o:*, serverId:uint, pos:int, camp:int, group:int):EDRole
		{
			if (u.isLive && o.miCardCount)
			{
				//for each (var cardInfo:Stru_CARD_DETAIL_INFO in o.moCards) 
				for each (var cardInfo:* in o.moCards) 
				{
					if (cardInfo.moCardDisplayInfo.miCardID == serverId)
					{
						var info:ORole = getPvpORole(u, o, cardInfo);
						if (info)
						{
							var px:int = u.engine.astar.hotCenterX;
							var py:int = u.engine.astar.hotCenterY;
							if (u.info.aStar.monster.hasOwnProperty(pos))
							{
								var a:Array = u.info.aStar.monster[pos];
								if (a.length)
								{
									var s:int = 0;
									if(a.length > 2)
									{
										s = int((a.length / 2) * u.random) * 2;
										if (s == a.length) s = a.length - 2;
									}
									px = a[s];
									py = a[s + 1];
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
							var angle:int = info.startAngle;
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
							return CRole.create(u, info, 0, camp, group, angle, px, py);
						}
					}
				}
			}
			return null;
		}
		
		/**
		 * 
		 * @param	u
		 * @param	o
		 * @param	serverId
		 * @return
		 */
		//public static function getPVPRoleInfo(u:UpGame, o:Stru_PLAYER_DETAIL_ARMY, serverId:uint):ORole
		public static function getPVPRoleInfo(u:UpGame, o:*, serverId:uint):ORole
		{
			if (u.isLive && o.miCardCount)
			{
				//for each (var cardInfo:Stru_CARD_DETAIL_INFO in o.moCards) 
				for each (var cardInfo:* in o.moCards) 
				{
					if (cardInfo.moCardDisplayInfo.miCardID == serverId)
					{
						var info:ORole = getPvpORole(u, o, cardInfo);
						if (info)
						{
							return info;
						}
					}
				}
			}
			return null;
		}
		
		/**
		 * 添加PVP对手的对象
		 * @param	upGame			游戏引用
		 * @param	o
		 * @param	serverId		服务器ID
		 * @param	pos				位置数据
		 * @param	camp			阵营
		 * @return
		 */
		//public static function pushPvpRoleXY(upGame:UpGame, o:Stru_PLAYER_DETAIL_ARMY, serverId:uint, x:int, y:int, camp:int, group:int):EDRole
		public static function pushPvpRoleXY(upGame:UpGame, o:*, serverId:uint, x:int, y:int, camp:int, group:int):EDRole
		{
			if (upGame.isLive && o.miCardCount)
			{
				//for each (var cardInfo:Stru_CARD_DETAIL_INFO in o.moCards) 
				for each (var cardInfo:* in o.moCards) 
				{
					if (cardInfo.moCardDisplayInfo.miCardID == serverId)
					{
						var info:ORole = getPvpORole(upGame, o, cardInfo);
						if (info)
						{
							var angle:int = info.startAngle;
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
							return CRole.create(upGame, info, 0, camp, group, angle, x, y);
						}
					}
				}
			}
			return null;
		}
		
		
		/**
		 * 从PVP的信息里获取到 ORole 信息
		 * @param	o
		 * @param	cardIndex
		 * @return
		 */
		//private static function getPvpORole(upGame:UpGame, o:Stru_PLAYER_DETAIL_ARMY, cardInfo:Stru_CARD_DETAIL_INFO):ORole
		private static function getPvpORole(upGame:UpGame, o:*, cardInfo:*):ORole
		{
			if (upGame.isLive)
			{
				var card:RoleCardModel = UpGameData.cardRole.getItem("card_id", cardInfo.moCardDisplayInfo.miCardTypeID);
				if (card)
				{
					var info:ORole = new ORole();
					var i:int = 0;
					var u:uint;
					//开始找参数
					info.skillInfo[0].id = card.Cnskill;
					info.skillInfo[1].id = card.CHskill;
					info.skillInfo[2].id = card.CHskill2;
					info.skillInfo[3].id = card.CHskill3;
					info.modelId = card.Cmodel;
					info.aiType = card.Cai;
					info.rangeGuard = card.Csensitive * 100;
					info.rangeView = card.Clook * 100;
					info.callMonster1 = card.Cmonsterid;// 召唤技能配置参数
					//写入本地数据
					info.id = card.card_id;
					//info.id = cardInfo.moCardDisplayInfo.miCardID;
					info.serverId = cardInfo.moCardDisplayInfo.miCardID;
					info.idType = 1;
					info.isFriend = false;
					info.isAuto = true;
					//
					info.atk = cardInfo.moCombatInfo[0];			// 每秒伤害
					info.atkRate = cardInfo.moCombatInfo[1];		// 攻击频率 - 改为标准攻击间隔(?)
					info.def = cardInfo.moCombatInfo[2];			// 防御
					info.hp = cardInfo.moCombatInfo[3];				// 生命
					info.hpMax = info.hp;
					info.atkTime = cardInfo.moCombatInfo[4];		// 攻击间隔
					info.speed = cardInfo.moCombatInfo[5];			// 移动速度
					info.hit = cardInfo.moCombatInfo[6];			// 命中
					info.dodge = cardInfo.moCombatInfo[7];			// 闪避
					info.sealHit = cardInfo.moCombatInfo[8];		// 封印命中 -- 封命
					info.sealDodge = cardInfo.moCombatInfo[9];		// 封印闪避 -- 封抗
					info.crit = cardInfo.moCombatInfo[10];			// 致命率
					info.tenacity = cardInfo.moCombatInfo[11];		// 韧性
					info.critHurt = cardInfo.moCombatInfo[12];		// 致命伤害
					info.critDef = cardInfo.moCombatInfo[13];		// 致命伤害抵抗 - 暴击抵抗
					info.atkUp = cardInfo.moCombatInfo[14];			// 攻击增强
					info.hpUp = cardInfo.moCombatInfo[15];			// 生命增强
					info.atkTimeUp = cardInfo.moCombatInfo[16];		// 攻速修正
					info.treatUp = cardInfo.moCombatInfo[17];		// 治疗增强
					info.defUp = cardInfo.moCombatInfo[18];			// 防御比例
					info.treatEffect = cardInfo.moCombatInfo[19];	// 被治疗比例
					//cardInfo.moCombatInfo[20];	// 再生值(?)
					info.skillInfo[1].cdStart = cardInfo.moCombatInfo[21];	// 技能1初始cd降低值
					info.skillInfo[2].cdStart = cardInfo.moCombatInfo[22];	// 技能2初始cd降低值
					info.skillInfo[3].cdStart = cardInfo.moCombatInfo[23];	// 技能3初始cd降低值
					info.skillInfo[4].cdStart = cardInfo.moCombatInfo[24];	// 技能4初始cd降低值
					
					info.skillInfo[1].cd = cardInfo.moCombatInfo[25];	// 技能1cd降低值
					info.skillInfo[2].cd = cardInfo.moCombatInfo[26];	// 技能2cd降低值
					info.skillInfo[3].cd = cardInfo.moCombatInfo[27];	// 技能3cd降低值
					info.skillInfo[4].cd = cardInfo.moCombatInfo[28];	// 技能4cd降低值
					//设置技能等级
					i = 0;
					if (cardInfo.moCardDisplayInfo.miSkillLvCount)
					{
						for each (u in cardInfo.moCardDisplayInfo.miSkillLvList) 
						{
							if(info.skillInfo.length > i)
							{
								info.skillInfo[i].lv = u;
							}
							else
							{
								g.log.pushLog(NetStartBattle, LogType._ErrorLog, "主动技能推送过多");
							}
							i++;
						}
					}
					return info;
				}
			}
			return null;
		}
		
		/**
		 * 通过PVP列表获取 装备的信息
		 * @param	o
		 * @param	equipid
		 * @return
		 */
		//private static function getPvpEquip(o:Stru_CARD_DETAIL_INFO, equipid:uint):Stru_PROPS_INST_INFO
		private static function getPvpEquip(o:*, equipid:uint):*
		{
			if (o.moEquips.length)
			{
				//for each (var equip:Stru_PROPS_INST_INFO in o.moEquips) 
				for each (var equip:* in o.moEquips) 
				{
					if (equip.miPropsID == equipid)
					{
						return equip;
					}
				}
			}
			return null;
		}
	}
}