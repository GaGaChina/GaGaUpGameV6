package cn.wjj.upgame.tools 
{
	import cn.wjj.display.MPoint;
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.upgame.data.CardInfoModel;
	import cn.wjj.upgame.data.SkillActiveModel;
	import cn.wjj.upgame.data.UpGameData;
	import cn.wjj.upgame.data.UpGameSkill;
	import cn.wjj.upgame.data.UpGameSkillAction;
	import cn.wjj.upgame.data.UpGameSkillEffect;
	import cn.wjj.upgame.engine.AIRoleSkillRelease;
	import cn.wjj.upgame.engine.CBullet;
	import cn.wjj.upgame.engine.OBullet;
	import cn.wjj.upgame.engine.OSkillEffect;
	import cn.wjj.upgame.UpGame;

	/**
	 * 释放法术
	 * @author GaGa
	 */
	public class ReleaseMagic 
	{
		
		/** 维护列表子弹ID **/
		private static var bulletId:Vector.<uint> = new Vector.<uint>();
		
		public function ReleaseMagic() { }
		
		
		/**
		 * 
		 * @param	u			
		 * @param	skillId		主动技能表ID
		 * @param	camp		阵营
		 * @param	startX		发出点坐标
		 * @param	startY		发出点坐标
		 * @param	x			目标点坐标
		 * @param	y			目标点坐标
		 */
		public static function callSkillXY(u:UpGame, playerId:int, skillId:uint, camp:int, startX:int, startY:int, x:int, y:int):void
		{
			var point:MPoint = MPoint.instance(x, y);
			//通过技能ID来设置
			var skill:SkillActiveModel = UpGameData.skillActive.getItem("id", skillId);
			if (skill)
			{
				var action:UpGameSkillAction = UpGameData.skillAction.getItem("id", skill.actionId);
				if (action)
				{
					/** 马上生效的技能 **/
					var realTimeList:Vector.<OSkillEffect>;
					/** 马上生效的内容的数量 **/
					var realTimeListLength:int = 0;
					/** 技能里包含的全部效果子弹类型 **/
					var bulletList:Vector.<OBullet>;
					/** 子弹效果的数量 **/
					var bulletListLength:int = 0;
					var bulletIndex:int;
					var oBullet:OBullet;
					var oSkill:OSkillEffect;
					/** 临时子弹上挂的技能特效 **/
					var effect:UpGameSkillEffect;
					var skillList:Vector.<UpGameSkill>;
					var link:UpGameSkill;
					var list:Array = g.speedFact.n_array();
					if (action.time1skill) list.push(action.time1skill);
					if (action.time2skill) list.push(action.time2skill);
					if (action.time3skill) list.push(action.time3skill);
					if (action.time4skill) list.push(action.time4skill);
					if (action.time5skill) list.push(action.time5skill);
					if (list.length)
					{
						for each (var skillId:uint in list) 
						{
							skillList = UpGameData.skill.getList("id", skillId);
							if (skillList.length)
							{
								if (realTimeList)
								{
									realTimeList.length = 0;
									realTimeList = null;
								}
								realTimeListLength = 0;
								if (bulletList)
								{
									g.speedFact.d_vector(OBullet, bulletList);
									bulletList = null;
								}
								bulletListLength = 0;
								bulletIndex = 0;
								if (oBullet) oBullet = null;
								if (oSkill) oSkill = null;
								if (effect) effect = null;
								/** 如果有子弹就挂上子弹的信息参数 **/
								ReleaseMagic.bulletId.length = 0;
								for each (link in skillList)
								{
									if (link.bulletId == 0)
									{
										if (link.effectId)
										{
											//马上产生效果
											effect = UpGameData.skillEffect.getItem("id", link.effectId);
											if (effect)
											{
												if (realTimeListLength == 0 && realTimeList == null)
												{
													realTimeList = new Vector.<OSkillEffect>();
												}
												oSkill = new OSkillEffect();
												oSkill.ownerPlayerId = playerId;
												oSkill.actionId = action.id;
												oSkill.actionSkillId = action.time1skill;
												oSkill.hitPointIndex = 0;
												oSkill.ownerId = 0;
												oSkill.ownerCamp = camp;
												oSkill.effect = effect;
												realTimeList.push(oSkill);
												realTimeListLength++;
												HandleSkillEffect.handleReleaseSkill(oSkill);
											}
											else
											{
												g.log.pushLog(ReleaseMagic, LogType._ErrorLog, "[策划]主动技:" + skill.id + " 技能:" + action.time1skill + " 未找到效果ID:" + link.effectId);
											}
										}
									}
									else
									{
										bulletIndex = ReleaseMagic.bulletId.indexOf(link.bulletId);
										if (bulletIndex == -1)
										{
											//新子弹
											oBullet = new OBullet();
											oBullet.range = skill.range;
											oBullet.id = link.bulletId;
											oBullet.info = UpGameData.bulletInfo.getItem("id", link.bulletId);
											if (oBullet.info)
											{
												ReleaseMagic.bulletId.push(link.bulletId);
												if (bulletListLength == 0 && bulletList == null)
												{
													bulletList = g.speedFact.n_vector(OBullet);
													if (bulletList == null)
													{
														bulletList = new Vector.<OBullet>();
													}
												}
												bulletList.push(oBullet);
												bulletListLength++;
											}
											else
											{
												g.log.pushLog(ReleaseMagic, LogType._ErrorLog, "[策划]主动技:" + skill.id + " 技能:" + action.time1skill + " 未找到子弹ID:" + link.bulletId);
											}
										}
										else
										{
											//挂效果子弹
											oBullet = bulletList[bulletIndex];
										}
										if (oBullet.info)
										{
											if (link.effectId)
											{
												effect = UpGameData.skillEffect.getItem("id", link.effectId);
												if (effect)
												{
													oSkill = new OSkillEffect();
													oSkill.ownerPlayerId = playerId;
													oSkill.actionId = action.id;
													oSkill.actionSkillId = action.time1skill;
													oSkill.ownerCamp = camp;
													oSkill.effect = effect;
													oBullet.effectList.push(oSkill);
													HandleSkillEffect.handleReleaseSkill(oSkill);
												}
												else
												{
													g.log.pushLog(ReleaseMagic, LogType._ErrorLog, "[策划]主动技:" + skill.id + " 技能:" + action.time1skill + " 未找到效果ID:" + link.effectId);
												}
											}
											else if (skill.specialType != 0)
											{
												//当效果为空,切技能属于特殊技,就不处理里面参数,因为只会用到
												oSkill = new OSkillEffect();
												oSkill.ownerPlayerId = playerId;
												oSkill.actionId = action.id;
												oSkill.actionSkillId = action.time1skill;
												oSkill.ownerCamp = camp;
												oBullet.effectList.push(oSkill);
											}
										}
									}
								}
								if (realTimeListLength)
								{
									var reportAdd:Boolean = false;
									var reportId:uint = 0;
									for each (oSkill in realTimeList) 
									{
										if (oSkill.effect.effectTarget == 4)
										{
											if (reportAdd == false)
											{
												reportAdd = true;
												if (u.reportStart)
												{
													u.report.index++;
													reportId = u.report.index;
												}
											}
											if (oSkill.effect.hitEffect && oSkill.effect.type == 0)
											{
												if (u.modeTurn)
												{
													u.reader.singleEffect(u.engine.time.timeEngine, "assets/effect/skill/" + oSkill.effect.hitEffect + ".u2", -startX, -startY, true);
												}
												else
												{
													u.reader.singleEffect(u.engine.time.timeEngine, "assets/effect/skill/" + oSkill.effect.hitEffect + ".u2", startX, startY, true);
												}
											}
											AIRoleSkillRelease.releaseSkill(reportId, x, y, u, null, oSkill, null);
										}
									}
								}
								if (bulletListLength)
								{
									for each (oBullet in bulletList)
									{
										CBullet.create(u, null, camp, oBullet, startX, startY, null, point);
									}
								}
							}
							else
							{
								g.log.pushLog(ReleaseMagic, LogType._ErrorLog, "释放技能失败,缺少技能关联");
							}
						}
					}
					if (list)
					{
						g.speedFact.d_array(list);
						list = null;
					}
					if (bulletList)
					{
						g.speedFact.d_vector(OBullet, bulletList);
						bulletList = null;
					}
				}
				else
				{
					g.log.pushLog(ReleaseMagic, LogType._ErrorLog, "释放技能失败,未找到对应动作");
				}
			}
			else
			{
				g.log.pushLog(ReleaseMagic, LogType._ErrorLog, "释放技能失败,主动技能表无ID:" + skillId);
			}
		}
		
		
		/**
		 * 召唤法术技能(使用地图实际坐标)
		 * 
		 * 技能改造,将技能和人物脱离
		 * 有一种拥有者是玩家自身
		 * 
		 * @param	u
		 * @param	cardInfo	卡牌属性
		 * @param	playerId	那个玩家释放的
		 * @param	camp
		 * @param	x			地图真实像素坐标(中心点)
		 * @param	y			地图真实像素坐标(中心点)
		 * @return
		 */
		public static function callCardXY(u:UpGame, cardInfo:CardInfoModel, playerId:int, camp:int, x:int, y:int):void
		{
			//子弹的发出点
			var startX:int = 0;
			var startY:int = 0;
			if (camp == 1)
			{
				startY = u.engine.astar.hotEndY;
			}
			else
			{
				startY = u.engine.astar.hotStartY;
			}
			callSkillXY(u, playerId, cardInfo.SpellSkill, camp, startX, startY, x, y);
		}
	}
}