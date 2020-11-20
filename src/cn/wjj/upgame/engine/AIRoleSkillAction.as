package cn.wjj.upgame.engine 
{
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.upgame.data.UpGameData;
	import cn.wjj.upgame.data.UpGameSkill;
	import cn.wjj.upgame.data.UpGameSkillEffect;
	import cn.wjj.upgame.tools.HandleSkillEffect;
	
	/**
	 * 没个主动技能里还有分动作的情况
	 * 
	 * @author GaGa
	 */
	public class AIRoleSkillAction
	{
		/** 维护列表子弹ID **/
		private static var bulletId:Vector.<uint> = new Vector.<uint>();
		/** 每个技能的信息 **/
		public var skill:AIRoleSkill;
		/** 开始做第几个动作 **/
		public var actionIndex:uint = 0;
		/** 攻击时间点 **/
		public var time:uint = 0;
		/** 所用发射点 **/
		public var point:uint = 0;
		/** 动作表中所填写子动作技能ID **/
		public var skillId:uint = 0;
		/** 目标类型 : 0-当前目标，1-己方血少，2-敌方血少，3-随机位置，4-当前方向，5-自己； **/
		public var goalType:uint = 0;
		/** 屏幕震动延后时间点 **/
		public var shakeTime:uint = 0;
		/** 屏幕震动时间长度 **/
		public var shakeLength:uint = 0;
		/** 屏幕震动类型,1,地图内,2,图层,3,整个地图 **/
		public var shakeType:uint = 0;
		/** 屏幕震动X轴比例 **/
		public var shakeX:Number = 0;
		/** 屏幕震动X轴比例 **/
		public var shakeY:Number = 0;
		/** 技能调度表 **/
		public var skillList:Vector.<UpGameSkill>;
		/** 技能调度表数量 **/
		public var skillListLength:int = 0;
		/** 马上生效的技能 **/
		public var realTimeList:Vector.<OSkillEffect>;
		/** 马上生效的内容的数量 **/
		public var realTimeListLength:int = 0;
		/** 技能里包含的全部效果子弹类型 **/
		public var bulletList:Vector.<OBullet>;
		/** 子弹效果的数量 **/
		public var bulletListLength:int = 0;
		
		/**
		 * 每个人物都会配备这样的信息,这个信息会被子弹引用出去,发生变化,人物会在次创建这个信息
		 * 
		 * @param	skill
		 * @param	index
		 * @param	info		实体化数据
		 */
		public function AIRoleSkillAction(skill:AIRoleSkill, actionIndex:int):void
		{
			this.skill = skill;
			this.actionIndex = actionIndex;
			switch (actionIndex)
			{
				case 0:
					time = skill.action.time1;
					point = skill.action.time1point;
					skillId = skill.action.time1skill;
					goalType = skill.action.goalType1;
					shakeTime = skill.action.shaketime1;
					shakeLength = skill.action.shakeLength1;
					shakeType = skill.action.shaketype1;
					shakeX = skill.action.shakeX1 / 10000;
					shakeY = skill.action.shakeY1 / 10000;
					break;
				case 1:
					time = skill.action.time2;
					point = skill.action.time2point;
					skillId = skill.action.time2skill;
					goalType = skill.action.goalType2;
					shakeTime = skill.action.shaketime2;
					shakeLength = skill.action.shakeLength2;
					shakeType = skill.action.shaketype2;
					shakeX = skill.action.shakeX2 / 10000;
					shakeY = skill.action.shakeY2 / 10000;
					break;
				case 2:
					time = skill.action.time3;
					point = skill.action.time3point;
					skillId = skill.action.time3skill;
					goalType = skill.action.goalType3;
					shakeTime = skill.action.shaketime3;
					shakeLength = skill.action.shakeLength3;
					shakeType = skill.action.shaketype3;
					shakeX = skill.action.shakeX3 / 10000;
					shakeY = skill.action.shakeY3 / 10000;
					break;
				case 3:
					time = skill.action.time4;
					point = skill.action.time4point;
					skillId = skill.action.time4skill;
					goalType = skill.action.goalType4;
					shakeTime = skill.action.shaketime4;
					shakeLength = skill.action.shakeLength4;
					shakeType = skill.action.shaketype4;
					shakeX = skill.action.shakeX4 / 10000;
					shakeY = skill.action.shakeY4 / 10000;
					break;
				case 4:
					time = skill.action.time5;
					point = skill.action.time5point;
					skillId = skill.action.time5skill;
					goalType = skill.action.goalType5;
					shakeTime = skill.action.shaketime5;
					shakeLength = skill.action.shakeLength5;
					shakeType = skill.action.shaketype5;
					shakeX = skill.action.shakeX5 / 10000;
					shakeY = skill.action.shakeY5 / 10000;
					break;
			}
			//释放这个技能
			//shaketime
			//shaketype
			if (skillId)
			{
				skillList = UpGameData.skill.getList("id", skillId);
				skillListLength = skillList.length;
				createOEffect(true);
			}
		}
		
		/** 创建技能的数据对象 **/
		internal function createOEffect(countEff:Boolean = false):void
		{
			if (skillListLength)
			{
				var oSkillEffect:OSkillEffect;
				if (realTimeListLength)
				{
					realTimeList.length = 0;
					realTimeListLength = 0;
				}
				var oBullet:OBullet;
				if (bulletListLength)
				{
					bulletList.length = 0;
					bulletListLength = 0;
				}
				/** 临时子弹上挂的技能特效 **/
				var effect:UpGameSkillEffect;
				var bulletIndex:int;
				/** 如果有子弹就挂上子弹的信息参数 **/
				bulletId.length = 0;
				for each (var link:UpGameSkill in skillList)
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
								oSkillEffect = new OSkillEffect();
								oSkillEffect.owner = skill.ed;
								oSkillEffect.ownerPlayerId = skill.ed.playerId;
								oSkillEffect.skillIndex = skill.index;
								oSkillEffect.actionId = skill.skill.actionId;
								oSkillEffect.actionSkillId = skillId;
								oSkillEffect.hitPointIndex = point;
								oSkillEffect.ownerId = skill.ed.info.serverId;
								oSkillEffect.ownerCall = skill.ed.info.isCall;
								if (skill.ed.info.idx) oSkillEffect.ownerIdx = skill.ed.info.idx;
								oSkillEffect.ownerCamp = skill.ed.camp;
								oSkillEffect.effect = effect;
								realTimeList.push(oSkillEffect);
								realTimeListLength++;
								HandleSkillEffect.handleSkill(oSkillEffect, skill.ed, skill.info.lv);
								if (countEff)
								{
									skill.effLength++;
									switch (oSkillEffect.effect.effectId) 
									{
										case 141:
										case 145:
										case 146:
											if (skill.ed.info.callMonster1)
											{
												skill.effCallLength++;
											}
											break;
										case 142:
											if (skill.ed.info.callMonster2)
											{
												skill.effCallLength++;
											}
											break;
										case 143:
											if (skill.ed.info.callMonster3)
											{
												skill.effCallLength++;
											}
											break;
										case 144:
											if (oSkillEffect.effect.SpawnID)
											{
												skill.effCallLength++;
											}
											break;
									}
								}
							}
							else
							{
								g.log.pushLog(this, LogType._ErrorLog, "[策划]主动技:" + skill.skill.id + " 第" + actionIndex + "个动作:" + skillId + " 未找到效果ID:" + link.effectId);
							}
						}
					}
					else
					{
						bulletIndex = bulletId.indexOf(link.bulletId);
						if (bulletIndex == -1)
						{
							//新子弹
							oBullet = new OBullet();
							oBullet.range = skill.skill.range;
							oBullet.id = link.bulletId;
							oBullet.info = UpGameData.bulletInfo.getItem("id", link.bulletId);
							if (oBullet.info)
							{
								bulletId.push(link.bulletId);
								if (bulletListLength == 0 && bulletList == null)
								{
									bulletList = new Vector.<OBullet>();
								}
								bulletList.push(oBullet);
								bulletListLength++;
							}
							else
							{
								g.log.pushLog(this, LogType._ErrorLog, "[策划]主动技:" + skill.skill.id + " 第" + actionIndex + "个动作:" + skillId + " 未找到子弹ID:" + link.bulletId);
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
									oSkillEffect = new OSkillEffect();
									oSkillEffect.owner = skill.ed;
									oSkillEffect.ownerPlayerId = skill.ed.playerId;
									oSkillEffect.skillIndex = skill.index;
									oSkillEffect.actionId = skill.skill.actionId;
									oSkillEffect.actionSkillId = skillId;
									oSkillEffect.hitPointIndex = point;
									oSkillEffect.ownerId = skill.ed.info.serverId;
									oSkillEffect.ownerCall = skill.ed.info.isCall;
									if (skill.ed.info.idx) oSkillEffect.ownerIdx = skill.ed.info.idx;
									oSkillEffect.ownerCamp = skill.ed.camp;
									oSkillEffect.effect = effect;
									oBullet.effectList.push(oSkillEffect);
									HandleSkillEffect.handleSkill(oSkillEffect, skill.ed, skill.info.lv);
									if (countEff)
									{
										skill.effLength++;
										switch (oSkillEffect.effect.effectId) 
										{
											case 141:
											case 145:
											case 146:
												if (skill.ed.info.callMonster1)
												{
													skill.effCallLength++;
												}
												break;
											case 142:
												if (skill.ed.info.callMonster2)
												{
													skill.effCallLength++;
												}
												break;
											case 143:
												if (skill.ed.info.callMonster3)
												{
													skill.effCallLength++;
												}
												break;
											case 144:
												if (oSkillEffect.effect.SpawnID)
												{
													skill.effCallLength++;
												}
												break;
										}
									}
								}
								else
								{
									g.log.pushLog(this, LogType._ErrorLog, "[策划]主动技:" + skill.skill.id + " 第" + actionIndex + "个动作:" + skillId + " 未找到效果ID:" + link.effectId);
								}
							}
							else if (skill.skill.specialType != 0)
							{
								//当效果为空,切技能属于特殊技,就不处理里面参数,因为只会用到
								oSkillEffect = new OSkillEffect();
								oSkillEffect.owner = skill.ed;
								oSkillEffect.ownerPlayerId = skill.ed.playerId;
								oSkillEffect.skillIndex = skill.index;
								oSkillEffect.actionId = skill.skill.actionId;
								oSkillEffect.actionSkillId = skillId;
								oSkillEffect.hitPointIndex = point;
								oSkillEffect.ownerId = skill.ed.info.serverId;
								oSkillEffect.ownerCall = skill.ed.info.isCall;
								if (skill.ed.info.idx) oSkillEffect.ownerIdx = skill.ed.info.idx;
								oSkillEffect.ownerCamp = skill.ed.camp;
								oBullet.effectList.push(oSkillEffect);
							}
						}
					}
				}
			}
		}
		
		/** 摧毁对象 **/
		public function dispose():void
		{
			skill = null;
			if (realTimeList)
			{
				if (realTimeListLength)
				{
					realTimeList.length = 0;
					realTimeListLength = 0;
				}
				realTimeList = null;
			}
			if (bulletList)
			{
				if (bulletListLength)
				{
					bulletList.length = 0;
					bulletListLength = 0;
				}
				bulletList = null;
			}
		}
	}
}