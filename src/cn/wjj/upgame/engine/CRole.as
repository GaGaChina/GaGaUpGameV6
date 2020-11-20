package cn.wjj.upgame.engine 
{
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.upgame.common.InfoHeroAddSkill;
	import cn.wjj.upgame.common.StatusTypeRole;
	import cn.wjj.upgame.data.CardInfoModel;
	import cn.wjj.upgame.data.HeroGeneralSkillModel;
	import cn.wjj.upgame.data.SkillActiveModel;
	import cn.wjj.upgame.data.UpGameData;
	import cn.wjj.upgame.data.UpGameModelInfo;
	import cn.wjj.upgame.UpGame;
	import flash.geom.Rectangle;
	
	/**
	 * 角色生成器
	 * 
	 * @author GaGa
	 */
	public class CRole 
	{
		
		public function CRole() { }
		
		/**
		 * 创建一个角色
		 * 
		 * @param	upGame
		 * @param	info		实例化数据
		 * @param	playerId	玩家ID
		 * @param	camp		阵营, 0, 为无阵营,1, 自己阵营, 2, 敌方阵营
		 * @param	angle		初始角度
		 * @param	x			初始坐标
		 * @param	y			初始坐标
		 * @param	mainTower	是否是主塔
		 * @return
		 */
		public static function create(u:UpGame, info:ORole, playerId:int, camp:int, group:int, angle:int = 0, x:int = 0, y:int = 0, mainTower:Boolean = false):EDRole
		{
			var ed:EDRole;
			if (info == null)
			{
				info = new ORole()
				info.id = 10001;
				info.speed = 100;
				info.isAuto = false;
			}
			info.speedDist = u.engine.time.timeFrame * info.speed / 1000;
			ed = new EDRole(u);
			ed.playerId = playerId;
			if (mainTower)
			{
				ed.sleep = true;
			}
			ed.section = u.engine.section;
			ed.info = info;
			info.rangeGuard2 = info.rangeGuard * info.rangeGuard;
			info.rangeView2 = info.rangeView * info.rangeView;
			ed.hpScale = int(info.hp / info.hpMax * 10000);
			ed.camp = camp;
			ed.group = group;
			ed.angle = angle;
			ed.x = x;
			ed.y = y;
			//如果是建筑要移动位置
			if (ed.info.typeProperty == 3 || ed.info.typeProperty == 4)
			{
				var astar:UpGameAStar = u.engine.astar;
				info.sizeRect = new Rectangle();
				info.sizeRect.x = int(x - (astar.tileWidth * info.size / 2));
				info.sizeRect.y = int(y - (astar.tileHeight * info.size / 2));
				info.sizeRect.width = astar.tileWidth * info.size;
				info.sizeRect.height = astar.tileHeight * info.size;
				//修改AStar
				var mapX:int, mapY:int;
				var startX:int = int((info.sizeRect.x - astar.offsetX) / astar.tileWidth);
				var startY:int = int((info.sizeRect.y - astar.offsetY) / astar.tileHeight);
				var maxX:int = int((info.sizeRect.x + info.sizeRect.width - astar.offsetX) / astar.tileWidth);
				var maxY:int = int((info.sizeRect.y + info.sizeRect.height - astar.offsetY) / astar.tileHeight);
				for (mapX = startX; mapX < maxX; mapX++)
				{
					for (mapY = startY; mapY < maxY; mapY++)
					{
						astar.map[mapX][mapY] = 1;
					}
				}
				astar.moveAll.push(info.sizeRect);
				if (u.isDebug)
				{
					u.reader.map.addDebug();
				}
			}
			//英雄的额外技能
			if (info.hero)
			{
				if (info.heroInfo)
				{
					var general:HeroGeneralSkillModel;
					if (info.heroInfo.card1)
					{
						general = UpGameData.heroGeneralSkill.getItem("card_id", info.heroInfo.card1);
						if (general)
						{
							//回城
							info.skillInfo[1].cd = general.skill1_cd;
						}
						else
						{
							g.log.pushLog(CRole, LogType._ErrorLog, "AllData upgameHeroGeneralSkill 缺ID:" + info.heroInfo.card1 + "通用技能");
						}
					}
					if (info.heroInfo.card2)
					{
						general = UpGameData.heroGeneralSkill.getItem("card_id", info.heroInfo.card2);
						if (general)
						{
							//回血
							info.skillInfo[4].cd = general.skill2_cd;
						}
						else
						{
							g.log.pushLog(CRole, LogType._ErrorLog, "AllData upgameHeroGeneralSkill 缺ID:" + info.heroInfo.card2 + "通用技能");
						}
					}
					if (info.heroInfo.card3)
					{
						general = UpGameData.heroGeneralSkill.getItem("card_id", info.heroInfo.card3);
						if (general)
						{
							//复活时间
							if (general.reborn_time)
							{
								info.heroInfo.timeRevive = general.reborn_time;
							}
							else
							{
								info.heroInfo.timeRevive = 60000;
							}
							if (general.recover_speed)
							{
								info.heroInfo.selfHealing = general.recover_speed / 10000;
							}
							else
							{
								info.heroInfo.selfHealing = 0.05;
							}
						}
						else
						{
							info.heroInfo.timeRevive = 60000;
							info.heroInfo.selfHealing = 0.05;
							g.log.pushLog(CRole, LogType._ErrorLog, "AllData upgameHeroGeneralSkill 缺ID:" + info.heroInfo.card3 + "通用技能");
						}
					}
					if (info.heroInfo.card4)
					{
						general = UpGameData.heroGeneralSkill.getItem("card_id", info.heroInfo.card4);
						if (general)
						{
							if (general.exp_increase)
							{
								info.heroInfo.expAddUp += general.exp_increase / 10000;
							}
						}
						else
						{
							g.log.pushLog(CRole, LogType._ErrorLog, "AllData upgameHeroGeneralSkill 缺ID:" + info.heroInfo.card4 + "通用技能");
						}
					}
					//添加英雄的技能2
					var cardInfo:CardInfoModel = UpGameData.cardInfo.getItem("card_id", info.heroInfo.cardSkill1);
					if (cardInfo)
					{
						info.skillInfo[1].id = cardInfo.SpellSkill;
					}
					if (playerId)
					{
						for each (var edCamp:EDCamp in u.engine.campLib) 
						{
							if (edCamp.playerObj && edCamp.playerObj.hasOwnProperty(playerId))
							{
								(edCamp.playerObj[playerId] as EDCampPlayer).hero = ed;
								break;
							}
						}
					}
				}
				else
				{
					info.heroInfo = new InfoHeroAddSkill();
					info.heroInfo.timeRevive = 60000;
					info.heroInfo.selfHealing = 0.05;
				}
			}
			info.skillInfo[0].cdStart = info.atkTime;
			var model:UpGameModelInfo = UpGameData.modelInfo.getItem("id", info.modelId);
			if (model)
			{
				ed.model = model;
			}
			else
			{
				g.log.pushLog(CRole, LogType._ErrorLog, "AllData UpGameModelInfo 缺少 ID : " + info.modelId + " 的角色模型数据");
				model = new UpGameModelInfo(UpGameData.modelInfo.getArray()[0]);
				ed.model = model;
				info.modelId = model.id;
			}
			info.speedScale = info.speed / model.speed;
			if (info.hpDisplayType == -1)
			{
				info.hpDisplayType = model.hpDisType;
			}
			ed.hit_r_x = model.hit_r_x;
			ed.hit_r_y = model.hit_r_y;
			ed.hit_r = model.hit_r;
			ed.hit_h = model.hit_h;
			//创建主动技能AI对象
			createSkill(ed);
			ed.changeStatus(StatusTypeRole.idle);
			var ai:AIRole = AIRole.instance();
			ai.setThis(ed);
			ed.ai = ai;
			u.engine.addED(ed);
			return ed;
		}
		
		/** 将其他战斗里已经创建的EDRole移植到另一个UpGame中 **/
		public static function addEDRole(u:UpGame, ed:EDRole, camp:int, group:int, angle:int, x:int, y:int):void
		{
			ed.u = u;
			ed.camp = camp;
			ed.group = group;
			ed.angle = angle;
			ed.x = x;
			ed.y = y;
			ed.creatTime = u.engine.time.timeGame;
			u.engine.addED(ed);
		}
		
		/** 把技能都设置上 **/
		internal static function createSkill(ed:EDRole):void
		{
			// 主动技能表的内容
			var skill:SkillActiveModel;
			if (ed.skillList == null) ed.skillList = new Vector.<SkillActiveModel>();
			// 普通技能id, 开枪或动刀
			if (ed.info.skillInfo[0].id)
			{
				skill = UpGameData.skillActive.getItem("id", ed.info.skillInfo[0].id);
				if (skill)
				{
					ed.skillList.push(skill);
				}
				else
				{
					ed.skillList.push(null);
					g.log.pushLog(CRole, LogType._ErrorLog, "AllData SkillActiveModel 缺少 ID : " + ed.info.skillInfo[0].id + " 的主动技能");
				}
			}
			else
			{
				ed.skillList.push(null);
			}
			// 高级技能1id
			if (ed.info.skillInfo[1].id)
			{
				skill = UpGameData.skillActive.getItem("id", ed.info.skillInfo[1].id);
				if (skill)
				{
					ed.skillList.push(skill);
				}
				else
				{
					ed.skillList.push(null);
					g.log.pushLog(CRole, LogType._ErrorLog, "AllData SkillActiveModel 缺少 ID : " + ed.info.skillInfo[1].id + " 主动技");
				}
			}
			else
			{
				ed.skillList.push(null);
			}
			// 高级技能2id
			if (ed.info.skillInfo[2].id)
			{
				skill = UpGameData.skillActive.getItem("id", ed.info.skillInfo[2].id);
				if (skill)
				{
					ed.skillList.push(skill);
				}
				else
				{
					ed.skillList.push(null);
					g.log.pushLog(CRole, LogType._ErrorLog, "AllData SkillActiveModel 缺少 ID : " + ed.info.skillInfo[2].id + " 主动技");
				}
			}
			else
			{
				ed.skillList.push(null);
			}
			// 其他技能,需要加入的
			// 子集技能
			if (ed.info.skillInfo[3].id)
			{
				skill = UpGameData.skillActive.getItem("id", ed.info.skillInfo[3].id);
				if (skill)
				{
					ed.skillList.push(skill);
				}
				else
				{
					ed.skillList.push(null);
					g.log.pushLog(CRole, LogType._ErrorLog, "AllData SkillActiveModel 缺少 ID : " + ed.info.skillInfo[3].id + " 主动技");
				}
			}
			else
			{
				ed.skillList.push(null);
			}
			// 未知技能
			if (ed.info.skillInfo[4].id)
			{
				skill = UpGameData.skillActive.getItem("id", ed.info.skillInfo[4].id);
				if (skill)
				{
					ed.skillList.push(skill);
				}
				else
				{
					ed.skillList.push(null);
					g.log.pushLog(CRole, LogType._ErrorLog, "AllData SkillActiveModel 缺少 ID : " + ed.info.skillInfo[4].id + " 主动技");
				}
			}
			else
			{
				ed.skillList.push(null);
			}
		}
		
		/**
		 * 某一个Role添加一个新的技能,并且初始化里面全部内容
		 * @param	ed			角色
		 * @param	index		序列
		 * @param	skillId		技能ID
		 */
		public static function addSkill(ed:EDRole, index:int, skillId:int):void
		{
			if (skillId)
			{
				ed.info.skillInfo[index].id = skillId;
				var skill:SkillActiveModel = UpGameData.skillActive.getItem("id", skillId);
				if (skill)
				{
					ed.skillList[index] = skill;
					//初始化技能
					if (ed.info.skillInfo && index < ed.info.skillInfo.length && ed.info.skillInfo[index])
					{
						var old:AIRoleSkill = ed.ai.aiSkill[index];
						if (old) old.dispose();
						ed.ai.aiSkill[index] = new AIRoleSkill(ed, ed.ai, skill, index, ed.info.skillInfo[index]);
					}
					else
					{
						ed.ai.aiSkill[index] = null;
						g.log.pushLog(CRole, LogType._ErrorLog, "ED对象:" + ed.info.serverId + " 缺少实体化技能数据 : " + index);
					}
				}
				else
				{
					ed.skillList[index] = null;
					ed.ai.aiSkill[index] = null;
					g.log.pushLog(CRole, LogType._ErrorLog, "AllData SkillActiveModel 缺少 ID : " + skillId + " 主动技");
				}
			}
		}
		
		/** 英雄解锁下一个技能 **/
		public static function heroUnlockNextSkill(ed:EDRole):void
		{
			for each (var item:ORoleSkill in ed.info.skillInfo) 
			{
				if (item.id == 0)
				{
					var cardSkill:uint;
					switch (item.index) 
					{
						case 1:
							cardSkill = ed.info.heroInfo.cardSkill1;
							break;
						case 2:
							cardSkill = ed.info.heroInfo.cardSkill2;
							break;
						case 3:
							cardSkill = ed.info.heroInfo.cardSkill3;
							break;
						case 4:
							cardSkill = ed.info.heroInfo.cardSkill4;
							break;
					}
					if (cardSkill)
					{
						//添加英雄的技能2
						var cardInfo:CardInfoModel = UpGameData.cardInfo.getItem("card_id", cardSkill);
						if (cardInfo)
						{
							addSkill(ed, item.index, cardInfo.SpellSkill);
						}
					}
					break;
				}
			}
			
		}
	}
}