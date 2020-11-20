package cn.wjj.upgame.engine 
{
	import cn.wjj.display.MPoint;
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.upgame.common.InfoHeroAddSkill;
	import cn.wjj.upgame.common.StatusTypeRole;
	import cn.wjj.upgame.data.SkillActiveModel;
	import cn.wjj.upgame.data.UpGameSkillEffect;
	import cn.wjj.upgame.render.DisplayEnergy;
	import cn.wjj.upgame.render.EngineEDRole;
	import cn.wjj.upgame.tools.ReleaseCard;
	import cn.wjj.upgame.tools.ReleaseMagic;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * [对象池]技能里带的效果对象
	 * 
	 * 
	 * @author GaGa
	 */
	public class AIRoleSkillEffect 
	{
		/** 是否需要展示出特效 **/
		public var displayUI:Boolean = true;
		
		public function AIRoleSkillEffect() { }
		
		/** 获取是否命中, true:命中, false:未命中 **/
		public static function hit(u:UpGame, oEffect:OSkillEffect, target:EDRole):Boolean
		{
			/** 计算得到命中值 **/
			var value:int;
			switch (oEffect.effect.hitId)
			{
				/**
				 * 用于回复加血增加正面状态的辅助技能，这类技能一般是必然命中
				 * 当遇到命中公式id = 0的时候，直接跳过命中流程；计算为必中的情况
				 */
				case 1:
					return true;
					break;
				/**
				 * 用于普通的攻击，技能攻击
				 * 初始话需要提供的值 ：
				 * 【攻击方命中】，（攻击方对应的技能附加总命中）=【技能附加命中】+【技能附加命中增量】X（技能等级）
				 * (攻击方总命中值）= 【攻击方命中】+（攻击方技能附加总命中）
				 * (命中值) = （攻击方总命中值） - 【防守方回避】
				 * 注：技能附加命中可能为负值
				 */
				case 2:
					if (target && target.isLive
					&& ((target.info.typeProperty == 1 && oEffect.effect.AttacksGround)
					|| (target.info.typeProperty == 2 && oEffect.effect.AttacksAir)
					|| (target.info.typeProperty == 3 && oEffect.effect.AttacksBuildings)
					|| (target.info.typeProperty == 4 && oEffect.effect.AttacksBases)))
					{
						value = oEffect.ownerHit - target.info.dodge;
						if (u.random * 10000 <= value)
						{
							return true;
						}
					}
					break;
				/**
				 * 用于封印系技能和负面状态类技能
				 * 初始话需要提供的值：【攻击方封印命中】，（攻击方对应的技能附加总命中）=【技能附加命中】+【技能附加命中增量】X（技能等级）
				 * （攻击方总封印命中值）= 【攻击方封印命中】+（攻击方对应的技能附加总命中）
				 * (封印命中值) = （攻击方总封印命中值） - 【防守方封抗性】
				 * if（(封印命中值)<0）(封印命中值) = 0;
				 * 加的3000取消掉了
				 */
				case 3:
					if (target && target.isLive
					&& ((target.info.typeProperty == 1 && oEffect.effect.AttacksGround)
					|| (target.info.typeProperty == 2 && oEffect.effect.AttacksAir)
					|| (target.info.typeProperty == 3 && oEffect.effect.AttacksBuildings)
					|| (target.info.typeProperty == 4 && oEffect.effect.AttacksBases)))
					{
						value = oEffect.ownerHit - target.info.sealDodge;
						if (value < 0)
						{
							value = 0;
						}
						if (u.random * 10000 <= value)
						{
							return true;
						}
					}
					break;
				/**
				 * 用于固定几率命中的技能/状态， 这个命中公式下，命中值与防御方的属性无关
				 * （攻击方对应的技能附加总命中）=【技能附加命中】+【技能附加命中增量】X（技能等级）
				 * (技能/状态命中值) = （攻击方对应的技能附加总命中）
				 */
				case 5:
					if (u.random * 10000 <= oEffect.ownerHit)
					{
						return true;
					}
					break;
				/**
				 * 命中公式增加6,攻击目标一致情况下必中~~比如效果对空,打空中目标必中,如果使用1必中,将不区分攻击类型
				 */
				case 6:
					if (target && target.isLive
					&& ((target.info.typeProperty == 1 && oEffect.effect.AttacksGround)
					|| (target.info.typeProperty == 2 && oEffect.effect.AttacksAir)
					|| (target.info.typeProperty == 3 && oEffect.effect.AttacksBuildings)
					|| (target.info.typeProperty == 4 && oEffect.effect.AttacksBases)))
					{
						return true;
					}
					break;
			}
			return false;
		}
		
		/**
		 * 伤害效果计算
		 * @param	u
		 * @param	reportId
		 * @param	reportX
		 * @param	reportY
		 * @param	o
		 * @param	critValue
		 * @param	target
		 * @param	point
		 * @param	isCrit
		 */
		internal static function hurt(u:UpGame, reportId:uint, reportX:int, reportY:int, o:OSkillEffect, critValue:int, target:EDRole, point:MPoint, isCrit:Boolean):void
		{
			var info:UpGameSkillEffect = o.effect;
			/** 计算得到 **/
			var value:int;
			/** 攻击方 **/
			var ownerValue:int;
			/** 倍率 **/
			var valueUp:int;
			/** 统计伤害使用 **/
			var count:int;
			switch (info.effectId) 
			{
				
				/**
				 * 一般伤害效果计算
				 * 【攻击方攻击】，（攻击方对应的技能附加总攻击 ）=【伤害修正偏移（主动技能表数据）】 + 【伤害修正偏移增量】 X 【技能等级（角色技能等级数据）】
				 * 【攻击方攻击增强倍率】，（攻击方对应的技能总附加增强倍率）=【修正倍率（主动技能表数据）】 + 【修正倍率增量】 X 【技能等级（角色技能等级数据）】
				 * （伤害） = 	（【攻击方攻击】 + （攻击方对应的技能附加总攻击）-【防守方防御力】））
				 * 			X（1 + （【攻击方攻击增强倍率】+（攻击方对应的技能总附加增强倍率）-【防方物理抗性】） /10000）
				 * 			X（致命伤害）/10000
				 * 
				 * (新修改)
				 * （【攻击方攻击】 + （攻击方对应的技能附加总修正偏移）-【防守方防御力】）> 0
				 * （伤害） = （【攻击方攻击】+（攻击方对应的技能附加总修正偏移）-【防守方防御力】）X（1 + （攻击方对应的技能附加总修正倍率）/10000）
				 * X（1 + （【攻击方攻击增强倍率】-【防方物理抗性】） /10000）
				 * X（致命伤害）/10000
				 */
				case 101:
					/** 【防方物理抗性】） **/
					if (target && target.isLive)
					{
						value = o.ownerAtk + o.ownerHurtValue - target.info.def;
						if(value < 0)
						{
							value = -1;
						}
						else
						{
							value = value * (o.ownerHurtUp / 10000 + 1) * ((o.ownerAtkUp - target.info.defUp) / 10000 + 1);
							if(value < 0)
							{
								value = -1;
							}
							else
							{
								value = -value * critValue / 10000;
								if (value > -1)
								{
									value = -1;
								}
							}
						}
						count = target.info.hp;
						target.info.hp += value;
						target.hpScale = int(target.info.hp / target.info.hpMax * 10000);
						if (o.ownerCamp != target.camp)
						{
							if (o.owner && o.owner.isLive)
							{
								target.ai.hatred.addHurt(o.owner, value, o.effect.hatred);
							}
							if (u.readerStart) EngineEDRole.damage(u, target, value, isCrit);
						}
						else if (u.readerStart)
						{
							EngineEDRole.boolmdChangeHP(u, target);
						}
						if (target.info.hp < 1)
						{
							u.engine.camp[o.ownerCamp].count_damage -= count;
							if (target.info.boss)
							{
								u.engine.camp[o.ownerCamp].count_damage_boss -= count;
							}
							if (u.reportStart)
							{
								u.report.hit(reportId, o.ownerId, o.ownerCamp, o.ownerIdx, o.ownerCall, reportX, reportY, target, o.skillIndex, o.actionId, o.actionSkillId, o.effect.id, value, isCrit, true);
							}
							target.dispose();
						}
						else
						{
							u.engine.camp[o.ownerCamp].count_damage += value;
							if (target.info.boss)
							{
								u.engine.camp[o.ownerCamp].count_damage_boss += value;
							}
							if (target.info.hp > target.info.hpMax)
							{
								target.info.hp = target.info.hpMax;
								target.hpScale = 10000;
							}
							if (u.reportStart)
							{
								u.report.hit(reportId, o.ownerId, o.ownerCamp, o.ownerIdx, o.ownerCall, reportX, reportY, target, o.skillIndex, o.actionId, o.actionSkillId, o.effect.id, value, isCrit, false);
							}
						}
					}
					break;
				/**
				 * 忽视防御方防御的伤害效果
				 * 【攻击方攻击】，（攻击方对应的技能附加总攻击 ）=【伤害修正偏移（主动技能表数据）】 + 【伤害修正偏移增量】 X 【技能等级（角色技能等级数据）】
				 * 【攻击方攻击增强倍率】，（攻击方对应的技能总附加增强倍率）=【修正倍率（主动技能表数据）】 + 【修正倍率增量】 X 【技能等级（角色技能等级数据）】
				 * （伤害） = 	（【攻击方攻击】 + （攻击方对应的技能附加总攻击））
				 * 			X（1 + （【攻击方攻击增强倍率】+（攻击方对应的技能总附加增强倍率）-【防方物理抗性】） /10000）
				 * 			X（致命伤害）/10000
				 * 
				 * 石磊改
				 * （【攻击方攻击】 + （攻击方对应的技能附加总修正偏移））X（1 + （攻击方对应的技能附加总修正倍率）/10000）
				 * X（1 + （【攻击方攻击增强倍率】-【防方物理抗性】） /10000）
				 * X（致命伤害）/10000
				 */
				case 102:
					if (target && target.isLive)
					{
						value = -(o.ownerAtk + o.ownerHurtValue) * (o.ownerHurtUp / 10000 + 1) * ((o.ownerAtkUp - target.info.defUp) / 10000 + 1) * critValue / 10000;
						if (value > -1) value = -1;
						count = target.info.hp;
						target.info.hp += value;
						target.hpScale = int(target.info.hp / target.info.hpMax * 10000);
						if (o.ownerCamp != target.camp)
						{
							if (o.owner && o.owner.isLive)
							{
								target.ai.hatred.addHurt(o.owner, value, o.effect.hatred);
							}
							if (u.readerStart) EngineEDRole.damage(u, target, value, isCrit);
						}
						else if (u.readerStart)
						{
							EngineEDRole.boolmdChangeHP(u, target);
						}
						if (target.info.hp < 1)
						{
							u.engine.camp[o.ownerCamp].count_damage -= count;
							if (target.info.boss)
							{
								u.engine.camp[o.ownerCamp].count_damage_boss -= count;
							}
							if (u.reportStart)
							{
								u.report.hit(reportId, o.ownerId, o.ownerCamp, o.ownerIdx, o.ownerCall, reportX, reportY, target, o.skillIndex, o.actionId, o.actionSkillId, o.effect.id, value, isCrit, true);
							}
							target.dispose();
						}
						else
						{
							u.engine.camp[o.ownerCamp].count_damage += value;
							if (target.info.boss)
							{
								u.engine.camp[o.ownerCamp].count_damage_boss += value;
							}
							if (target.info.hp > target.info.hpMax)
							{
								target.info.hp = target.info.hpMax;
								target.hpScale = 10000;
							}
							if (u.reportStart)
							{
								u.report.hit(reportId, o.ownerId, o.ownerCamp, o.ownerIdx, o.ownerCall, reportX, reportY, target, o.skillIndex, o.actionId, o.actionSkillId, o.effect.id, value, isCrit, false);
							}
						}
					}
					break;
				/**
				 * 增加或者降低防守方技能cd的技能效果(正值减少)
				 * 造成伤害的同时增加对方两个技能的cd
				 * 初始话需要提供的值：
				 * （减少第一个技能的cd时间）=【修正倍率（主动技能表数据）】 + 【修正倍率增量】 X 【技能等级（角色技能等级数据）】
				 * （减少第二个技能的cd时间）=【伤害修正偏移（主动技能表数据）】 + 【伤害修正偏移增量】 X 【技能等级（角色技能等级数据）】
				 * 降低的时间单位：毫秒
				 */
				case 103:
					if (target && target.isLive)
					{
						if (target.ai.aiSkill.length > 1 && target.ai.aiSkill[1])
						{
							target.ai.aiSkill[1].changeCD(o.ownerHurtValue);
						}
						if (target.ai.aiSkill.length > 2 && target.ai.aiSkill[2])
						{
							target.ai.aiSkill[2].changeCD(o.ownerHurtUp);
						}
					}
					break;
				/**
				 * 按照防守方最大hp造成伤害的技能
				 * 伤害效果与攻击什么的无关的技能，世界boss秒杀会用一用；
				 * （攻击方对应的附加总修正倍率）=【修正倍率（主动技能表数据）】 + 【修正倍率增量】 X 【技能等级（角色技能等级数据）】
				 * （攻击方对应的附加总修正偏移）=【伤害修正偏移（主动技能表数据）】 + 【伤害修正偏移增量】 X 【技能等级（角色技能等级数据）】
				 * （伤害效果） = 防守方最大hp  X 【修正倍率】/ 10000  + 【修正偏移】
				 */
				case 104:
					if (target && target.isLive)
					{
						value = -(target.info.hpMax * o.ownerHurtUp / 10000 + o.ownerHurtValue);
						if (value > -1) value = -1;
						count = target.info.hp;
						target.info.hp += value;
						target.hpScale = int(target.info.hp / target.info.hpMax * 10000);
						if (o.ownerCamp != target.camp)
						{
							if (o.owner && o.owner.isLive)
							{
								target.ai.hatred.addHurt(o.owner, value, o.effect.hatred);
							}
							if (u.readerStart) EngineEDRole.damage(u, target, value, isCrit);
						}
						else if (u.readerStart)
						{
							EngineEDRole.boolmdChangeHP(u, target);
						}
						if (target.info.hp < 1)
						{
							u.engine.camp[o.ownerCamp].count_damage -= count;
							if (target.info.boss)
							{
								u.engine.camp[o.ownerCamp].count_damage_boss -= count;
							}
							if (u.reportStart)
							{
								u.report.hit(reportId, o.ownerId, o.ownerCamp, o.ownerIdx, o.ownerCall, reportX, reportY, target, o.skillIndex, o.actionId, o.actionSkillId, o.effect.id, value, isCrit, true);
							}
							target.dispose();
						}
						else
						{
							u.engine.camp[o.ownerCamp].count_damage += value;
							if (target.info.boss)
							{
								u.engine.camp[o.ownerCamp].count_damage_boss += value;
							}
							if (target.info.hp > target.info.hpMax)
							{
								target.info.hp = target.info.hpMax;
								target.hpScale = 10000;
							}
							if (u.reportStart)
							{
								u.report.hit(reportId, o.ownerId, o.ownerCamp, o.ownerIdx, o.ownerCall, reportX, reportY, target, o.skillIndex, o.actionId, o.actionSkillId, o.effect.id, value, isCrit, false);
							}
						}
					}
					break;
				/**
				 * 治疗技能计算
				 * （攻击方对应的附加总修正倍率）=【修正倍率（主动技能表数据）】 + 【修正倍率增量】 X 【技能等级（角色技能等级数据）】
				 * （攻击方对应的附加总修正偏移）=【伤害修正偏移（主动技能表数据）】 + 【伤害修正偏移增量】 X 【技能等级（角色技能等级数据）】
				 * （治疗效果） = （【攻击方攻击】 + （攻击方对应的附加总修正偏移））X
				 * 					（1 + （【攻方治疗增强】+（攻击方对应的附加总修正倍率））/10000）X
				 * 					（1 + 【防方被治疗增强】/10000）X（致命伤害）/10000
				 * 
				 * 石磊改
				 * （攻击方对应的技能附加总修正偏移）=【效果偏移初始值（j技能作用效果表）】+【效果偏移升级增量】X【技能等级（角色技能等级数据）】
				 * （攻击方对应的技能附加总修正倍率）=【效果倍率初始值（j技能作用效果表）】+【效果倍率升级增量】X【技能等级（角色技能等级数据）】
				 * （治疗效果）=（【攻击方攻击】+（攻击方对应的技能附加总修正偏移））X（1 + （攻击方对应的技能附加总修正倍率）/10000）X
				 * （1 + 【攻方治疗增强】/10000）X
				 * （1 + 【防方被治疗增强】/10000）X
				 * （致命伤害）/10000
				 */
				case 120:
					if (target && target.isLive)
					{
						value = (o.ownerAtk + o.ownerHurtValue) * (o.ownerHurtUp / 10000 + 1)  * (o.ownerTreatUp / 10000 + 1) * (target.info.treatEffect / 10000 + 1) * critValue / 10000;
						if (value == 0) value = 1;
						count = target.info.hp;
						target.info.hp += value;
						target.hpScale = int(target.info.hp / target.info.hpMax * 10000);
						if (o.ownerCamp != target.camp)
						{
							if (o.owner && o.owner.isLive)
							{
								target.ai.hatred.addHurt(o.owner, value, o.effect.hatred);
							}
							if (u.readerStart) EngineEDRole.damage(u, target, value, isCrit);
						}
						else if (u.readerStart)
						{
							EngineEDRole.boolmdChangeHP(u, target);
						}
						if (target.info.hp < 1)
						{
							u.engine.camp[o.ownerCamp].count_damage -= count;
							if (target.info.boss)
							{
								u.engine.camp[o.ownerCamp].count_damage_boss -= count;
							}
							if (u.reportStart)
							{
								u.report.hit(reportId, o.ownerId, o.ownerCamp, o.ownerIdx, o.ownerCall, reportX, reportY, target, o.skillIndex, o.actionId, o.actionSkillId, o.effect.id, value, isCrit, true);
							}
							target.dispose();
						}
						else
						{
							u.engine.camp[o.ownerCamp].count_damage += value;
							if (target.info.boss)
							{
								u.engine.camp[o.ownerCamp].count_damage_boss += value;
							}
							if (target.info.hp > target.info.hpMax)
							{
								target.info.hp = target.info.hpMax;
								target.hpScale = 10000;
							}
							if (u.reportStart)
							{
								u.report.hit(reportId, o.ownerId, o.ownerCamp, o.ownerIdx, o.ownerCall, reportX, reportY, target, o.skillIndex, o.actionId, o.actionSkillId, o.effect.id, value, isCrit, false);
							}
						}
					}
					break;
				/**
				 * 比例治疗效果计算
				 * （攻击方对应的附加总修正倍率）=【修正倍率（主动技能表数据）】 + 【修正倍率增量】 X 【技能等级（角色技能等级数据）】
				 * （攻击方对应的附加总修正偏移）=【伤害修正偏移（主动技能表数据）】 + 【伤害修正偏移增量】 X 【技能等级（角色技能等级数据）】
				 * （治疗效果）= （【防守方最大hp】 X （攻击方对应的附加总修正倍率）/10000） +（攻击方对应的附加总修正偏移）
				 */
				case 121:
					if (target && target.isLive)
					{
						value = (target.info.hp * o.ownerHurtUp / 10000) + o.ownerHurtValue;
						if (value == 0) value = 1;
						count = target.info.hp;
						target.info.hp += value;
						target.hpScale = int(target.info.hp / target.info.hpMax * 10000);
						if (o.ownerCamp != target.camp)
						{
							if (o.owner && o.owner.isLive)
							{
								target.ai.hatred.addHurt(o.owner, value, o.effect.hatred);
							}
							if (u.readerStart) EngineEDRole.damage(u, target, value, isCrit);
						}
						else if (u.readerStart)
						{
							EngineEDRole.boolmdChangeHP(u, target);
						}
						if (target.info.hp < 1)
						{
							u.engine.camp[o.ownerCamp].count_damage -= count;
							if (target.info.boss)
							{
								u.engine.camp[o.ownerCamp].count_damage_boss -= count;
							}
							if (u.reportStart)
							{
								u.report.hit(reportId, o.ownerId, o.ownerCamp, o.ownerIdx, o.ownerCall, reportX, reportY, target, o.skillIndex, o.actionId, o.actionSkillId, o.effect.id, value, isCrit, true);
							}
							target.dispose();
						}
						else
						{
							u.engine.camp[o.ownerCamp].count_damage += value;
							if (target.info.boss)
							{
								u.engine.camp[o.ownerCamp].count_damage_boss += value;
							}
							if (target.info.hp > target.info.hpMax)
							{
								target.info.hp = target.info.hpMax;
								target.hpScale = 10000;
							}
							if (u.reportStart)
							{
								u.report.hit(reportId, o.ownerId, o.ownerCamp, o.ownerIdx, o.ownerCall, reportX, reportY, target, o.skillIndex, o.actionId, o.actionSkillId, o.effect.id, value, isCrit, false);
							}
						}
					}
					break;
				/**
				 * 召唤技能(过关的时候干掉)
				 * o.ownerHurtValue 召唤怪物的ID
				 */
				case 141:
				case 142:
				case 143:
				case 144:
				case 145://实例化召唤
				case 146://变身
					//检测技能发射者是否还存活,如果挂了,就直接break掉
					if ((info.effectId == 145 || info.effectId == 146) && (o.owner == null || o.owner.isLive == false || o.owner.info == null))
					{
						break;
					}
					if (o.ownerHurtValue)
					{
						var callRole:EDRole;
						if (u.modeAttack)
						{
							if (point)
							{
								callRole = ReleaseCard.callRoleCardXY(u, o.ownerHurtValue, 0, o.ownerPlayerId, o.ownerCamp, point.x, point.y) as EDRole;
							}
							else
							{
								if (o.owner && o.owner.isLive)
								{
									if (o.hitPointIndex == 1)
									{
										callRole = ReleaseCard.callRoleCardXY(u, o.ownerHurtValue, 0, o.ownerPlayerId, o.ownerCamp, o.owner.x + o.owner.hitX1, o.owner.y + o.owner.hitY1) as EDRole;
									}
									else
									{
										callRole = ReleaseCard.callRoleCardXY(u, o.ownerHurtValue, 0, o.ownerPlayerId, o.ownerCamp, o.owner.x + o.owner.hitX2, o.owner.y + o.owner.hitY2) as EDRole;
									}
								}
								else
								{
									callRole = ReleaseCard.callRoleCardXY(u, o.ownerHurtValue, 0, o.ownerPlayerId, o.ownerCamp, 0, 0) as EDRole;
								}
							}
						}
						else
						{
							if (o.owner && o.owner.isLive && (o.owner.info.maxCall == 0 || o.owner.callLength < o.owner.info.maxCall))
							{
								if (u.engine.callMonster != null)
								{
									if (point)
									{
										callRole = u.engine.callMonster(o.owner, o.ownerHurtValue, point.x, point.y);
									}
									else
									{
										if (o.hitPointIndex == 1)
										{
											callRole = u.engine.callMonster(o.owner, o.ownerHurtValue, o.owner.x + o.owner.hitX1, o.owner.y + o.owner.hitY1);
										}
										else
										{
											callRole = u.engine.callMonster(o.owner, o.ownerHurtValue, o.owner.x + o.owner.hitX2, o.owner.y + o.owner.hitY2);
										}
									}
								}
							}
						}
						if (callRole && callRole.isLive)
						{
							if (o.effect.effectXUp != 0)
							{
								callRole.dieAuto = o.effect.effectXUp;
								callRole.timeDie = o.effect.effectXUp;
							}
							u.report.callMonster(reportId, o.ownerId, o.ownerCamp, o.ownerIdx, o.ownerCall, reportX, reportY, callRole, o.skillIndex, o.actionId, o.actionSkillId, o.effect.id, callRole.info.serverId);
							if (o.owner && o.owner.isLive)
							{
								o.owner.callLength++;
							}
							if (info.effectId == 145 || info.effectId == 146)
							{
								var buff:EDSkillBuff;
								var overlay:int;
								var buffValue:int;
								//先把owner的 buff 去掉,并且存起来
								if (o.owner.ai.buff.length)
								{
									for each (buff in o.owner.ai.buff.buffList)
									{
										if (buff.overlay && buff.effect.effect.effectId == 182)
										{
											overlay = buff.overlay;
											while (overlay > 0)
											{
												overlay--;
												buffValue = getAttributeValue(o.owner, buff.effect.effect.attributeType) - buff.effect.ownerHurtValue;
												setAttributeValue(o.owner, buff.effect.effect.attributeType, buffValue);
											}
										}
									}
								}
								//处理
								if (info.effectId == 146)
								{
									callRole.dieRecoveryInfo = callRole.info.clone();
								}
								useOwnerToEd(o.owner, callRole);
								//把owner的 buff 加回去
								if (o.owner.ai.buff.length)
								{
									for each (buff in o.owner.ai.buff.buffList)
									{
										if (buff.overlay && buff.effect.effect.effectId == 182)
										{
											overlay = buff.overlay;
											while (overlay > 0)
											{
												overlay--;
												buffValue = getAttributeValue(o.owner, buff.effect.effect.attributeType) + buff.effect.ownerHurtValue;
												setAttributeValue(o.owner, buff.effect.effect.attributeType, buffValue);
											}
										}
									}
								}
								if (info.effectId == 145)
								{
									//技能
								}
								else if (info.effectId == 146)
								{
									//将Buff覆盖过去
									if (o.owner.ai.buff.length)
									{
										var newBuff:EDSkillBuff;
										for each (buff in o.owner.ai.buff.buffList)
										{
											newBuff = new EDSkillBuff(u);
											newBuff.startTime = buff.startTime;
											newBuff.nextHitTime = buff.nextHitTime;
											newBuff.owner = buff.owner;
											newBuff.target = callRole;
											newBuff.effect = buff.effect;
											newBuff.times = buff.times;
											newBuff.overlay = buff.overlay;
											newBuff.isStop = buff.isStop;
											newBuff.isStun = buff.isStun;
										}
										//把前面的buff累加进去
										if (newBuff.overlay && newBuff.effect.effect.effectId == 182)
										{
											overlay = newBuff.overlay;
											while (overlay > 0)
											{
												overlay--;
												buffValue = getAttributeValue(callRole, newBuff.effect.effect.attributeType) + newBuff.effect.ownerHurtValue;
												setAttributeValue(callRole, newBuff.effect.effect.attributeType, buffValue);
											}
										}
									}
									//把自己移除走
									o.owner.removeBattle();
									o.owner.ai.buff.clearBuff();
									o.owner.ai.hatred.removeAll();
									o.owner.ai.move.stop();
									o.owner.ai.collision.stop();
									if (o.owner.ai.targetList.length)
									{
										o.owner.ai.targetList.length = 0;
									}
									if (o.owner.ai.lockTarget) o.owner.ai.lockTarget = null;
									if (o.owner.ai.skillFire)
									{
										o.owner.ai.skillStop();
									}
									if (o.owner.ai.oldSkill) o.owner.ai.oldSkill = null;
									//if (o.owner.ai.timeChangeHide != -1) o.owner.ai.timeChangeHide = -1;
									//if (o.owner.ai.timeChangeInit != -1) o.owner.ai.timeChangeInit = -1;
									o.owner.isLive = false;
									if (o.owner.camp == 1)
									{
										o.owner.x = 9999999;
										o.owner.y = 9999999;
									}
									else
									{
										o.owner.x = -9999999;
										o.owner.y = -9999999;
									}
									callRole.dieRecoveryED = o.owner;
									if (u.readerStart)
									{
										u.reader.removeED(o.owner);
									}
									
									
									
								}
							}
						}
					}
					break;
				/**
				 * 睡眠效果
				 * （效果） = 使目标对象睡眠
				 * 如果在持续时间内被攻击则该状态消失
				 */
				case 160://{         废弃,使用isStop属性        }
					//target.uiStop = true;
					//target.aiStop = true;
					break;
				/**
				 * 眩晕效果
				 * （效果） = 使目标对象眩晕；
				 */
				case 161://{         废弃,使用isStop属性        }
					//target.uiStop = true;
					//target.aiStop = true;
					break;
				/**
				 * 嘲讽
				 */
				case 162:
					if (target && target.isLive && o.owner && o.owner.isLive)
					{
						target.ai.hatred.changeTarget(o.owner);
					}
					break;
				/**
				 * 状态类效果 属性值变化，只与被施法对象有关
				 * 改变角色基本属性的buff类技能；
				 * （攻击方对应的附加总修正倍率）=【修正倍率（主动技能表数据）】 + 【修正倍率增量】 X 【技能等级（角色技能等级数据）】
				 * （攻击方对应的附加总修正偏移）=【伤害修正偏移（主动技能表数据）】 + 【伤害修正偏移增量】 X 【技能等级（角色技能等级数据）】
				 * （被改变的效果id）= （状态修改的属性类型id）
				 * （效果） =（攻击方对应的附加总修正倍率）/10000 X 【防御方的对应属性】 +（攻击方对应的附加总修正偏移）；
				 * 注：可以被改变的属性包括，属性的id需要与程序约定
				 * （1-攻击，2-攻击速度，3-移动速度，4-防御，5-攻击增强，6-治疗增强，7-防御比例，8-被治疗增强，9命中，10-回避，11-暴击，12-暴击伤害，13-韧性，14-暴击抵抗，15-封命，16-封抗，22-视野范围）
				 */
				case 182:
					if (target && target.isLive)
					{
						value = getAttributeValue(target, o.effect.attributeType) + o.ownerHurtValue;
						setAttributeValue(target, o.effect.attributeType, value);
					}
					break;
				/**
				 * 状态类效果 与施法对象攻击有关
				 * （攻击方对应的附加总修正倍率）=【修正倍率（主动技能表数据）】 + 【修正倍率增量】 X 【技能等级（角色技能等级数据）】
				 * （攻击方对应的附加总修正偏移）=【伤害修正偏移（主动技能表数据）】 + 【伤害修正偏移增量】 X 【技能等级（角色技能等级数据）】
				 */
				case 183:
					if (o.owner && o.owner.isLive)
					{
						value = getAttributeValue(o.owner, o.effect.attributeType) + o.ownerHurtValue;
						setAttributeValue(o.owner, o.effect.attributeType, value);
					}
					break;
				/**
				 * 状态类效果，持续伤害
				 * （攻击方对应的附加总修正倍率）=【修正倍率（主动技能表数据）】 + 【修正倍率增量】 X 【技能等级（角色技能等级数据）】
				 * （攻击方对应的附加总修正偏移）=【伤害修正偏移（主动技能表数据）】 + 【伤害修正偏移增量】 X 【技能等级（角色技能等级数据）】
				 * （伤害效果）= （攻击方对应的技能附加总修正倍率）/10000 X （ 【攻击方攻击】 + （攻击方对应的技能附加总修正偏移） ）X（1 + （【攻击方攻击增强倍率】-【防方防御比例】） /10000）
				 */
				case 184:
					if (target && target.isLive)
					{
						value = -(o.ownerHurtUp / 10000 * (o.ownerAtk + o.ownerHurtValue) * ((o.ownerAtkUp - target.info.defUp) / 10000 + 1));
						if (value > -1) value = -1;
						count = target.info.hp;
						target.info.hp += value;
						target.hpScale = int(target.info.hp / target.info.hpMax * 10000);
						if (o.ownerCamp != target.camp)
						{
							if (o.owner && o.owner.isLive)
							{
								target.ai.hatred.addHurt(o.owner, value, o.effect.hatred);
							}
							if (u.readerStart) EngineEDRole.damage(u, target, value, isCrit);
						}
						else if (u.readerStart)
						{
							EngineEDRole.boolmdChangeHP(u, target);
						}
						if (target.info.hp < 1)
						{
							u.engine.camp[o.ownerCamp].count_damage -= count;
							if (target.info.boss)
							{
								u.engine.camp[o.ownerCamp].count_damage_boss -= count;
							}
							if (u.reportStart)
							{
								u.report.hit(reportId, o.ownerId, o.ownerCamp, o.ownerIdx, o.ownerCall, reportX, reportY, target, o.skillIndex, o.actionId, o.actionSkillId, o.effect.id, value, isCrit, true);
							}
							target.dispose();
						}
						else
						{
							u.engine.camp[o.ownerCamp].count_damage += value;
							if (target.info.boss)
							{
								u.engine.camp[o.ownerCamp].count_damage_boss += value;
							}
							if (target.info.hp > target.info.hpMax)
							{
								target.info.hp = target.info.hpMax;
								target.hpScale = 10000;
							}
							if (u.reportStart)
							{
								u.report.hit(reportId, o.ownerId, o.ownerCamp, o.ownerIdx, o.ownerCall, reportX, reportY, target, o.skillIndex, o.actionId, o.actionSkillId, o.effect.id, value, isCrit, false);
							}
						}
					}
					break;
				/**
				 * 状态类效果，持续回复
				 * （攻击方对应的附加总修正倍率）=【修正倍率（主动技能表数据）】 + 【修正倍率增量】 X 【技能等级（角色技能等级数据）】
				 * （攻击方对应的附加总修正偏移）=【伤害修正偏移（主动技能表数据）】 + 【伤害修正偏移增量】 X 【技能等级（角色技能等级数据）】
				 * （回复效果）= （攻击方对应的技能附加总修正倍率）/10000 X （ 【攻击方攻击】 + （攻击方对应的技能附加总修正偏移） ）X（1 + （【攻方治疗增强】）/10000）X（1 + 【防方被治疗增强】/10000）
				 */
				case 185:
					if (target && target.isLive)
					{
						value = o.ownerHurtUp / 10000 * (o.ownerAtk + o.ownerHurtValue) * (o.ownerTreatUp / 10000 + 1) * (target.info.treatEffect / 10000 + 1);
						if (value == 0) value = 1;
						count = target.info.hp;
						target.info.hp += value;
						target.hpScale = int(target.info.hp / target.info.hpMax * 10000);
						if (o.ownerCamp != target.camp)
						{
							if (o.owner && o.owner.isLive)
							{
								target.ai.hatred.addHurt(o.owner, value, o.effect.hatred);
							}
							if (u.readerStart) EngineEDRole.damage(u, target, value, isCrit);
						}
						else if (u.readerStart)
						{
							EngineEDRole.boolmdChangeHP(u, target);
						}
						if (target.info.hp < 1)
						{
							u.engine.camp[o.ownerCamp].count_damage -= count;
							if (target.info.boss)
							{
								u.engine.camp[o.ownerCamp].count_damage_boss -= count;
							}
							if (u.reportStart)
							{
								u.report.hit(reportId, o.ownerId, o.ownerCamp, o.ownerIdx, o.ownerCall, reportX, reportY, target, o.skillIndex, o.actionId, o.actionSkillId, o.effect.id, value, isCrit, true);
							}
							target.dispose();
						}
						else
						{
							u.engine.camp[o.ownerCamp].count_damage += value;
							if (target.info.boss)
							{
								u.engine.camp[o.ownerCamp].count_damage_boss += value;
							}
							if (target.info.hp > target.info.hpMax)
							{
								target.info.hp = target.info.hpMax;
								target.hpScale = 10000;
							}
							if (u.reportStart)
							{
								u.report.hit(reportId, o.ownerId, o.ownerCamp, o.ownerIdx, o.ownerCall, reportX, reportY, target, o.skillIndex, o.actionId, o.actionSkillId, o.effect.id, value, isCrit, false);
							}
						}
					}
					break;
				/**
				 * 状态类效果，按生命持续回复
				 * 持续回复的技能
				 * 初始化需要提供的值：
				 * 
				 * （攻击方对应的技能附加总修正偏移）=【效果偏移初始值（j技能作用效果表）】+【效果偏移升级增量】X【技能等级（角色技能等级数据）】
				 * （攻击方对应的技能附加总修正倍率）=【效果倍率初始值（j技能作用效果表）】+【效果倍率升级增量】X【技能等级（角色技能等级数据）】
				 * （回复效果）= （攻击方对应的技能附加总修正倍率）/10000 X 【受法方生命上限】+攻击方对应的技能附加总修正偏移
				 */
				case 186:
					if (target && target.isLive)
					{
						value = o.ownerHurtUp / 10000 * (o.ownerHpMax + o.ownerHurtValue);
						if (value == 0) value = 1;
						count = target.info.hp;
						target.info.hp += value;
						target.hpScale = int(target.info.hp / target.info.hpMax * 10000);
						if (o.ownerCamp != target.camp)
						{
							if (o.owner && o.owner.isLive)
							{
								target.ai.hatred.addHurt(o.owner, value, o.effect.hatred);
							}
							if (u.readerStart) EngineEDRole.damage(u, target, value, isCrit);
						}
						else if (u.readerStart)
						{
							EngineEDRole.boolmdChangeHP(u, target);
						}
						if (target.info.hp < 1)
						{
							u.engine.camp[o.ownerCamp].count_damage -= count;
							if (target.info.boss)
							{
								u.engine.camp[o.ownerCamp].count_damage_boss -= count;
							}
							if (u.reportStart)
							{
								u.report.hit(reportId, o.ownerId, o.ownerCamp, o.ownerIdx, o.ownerCall, reportX, reportY, target, o.skillIndex, o.actionId, o.actionSkillId, o.effect.id, value, isCrit, true);
							}
							target.dispose();
						}
						else
						{
							u.engine.camp[o.ownerCamp].count_damage += value;
							if (target.info.boss)
							{
								u.engine.camp[o.ownerCamp].count_damage_boss += value;
							}
							if (target.info.hp > target.info.hpMax)
							{
								target.info.hp = target.info.hpMax;
								target.hpScale = 10000;
							}
							if (u.reportStart)
							{
								u.report.hit(reportId, o.ownerId, o.ownerCamp, o.ownerIdx, o.ownerCall, reportX, reportY, target, o.skillIndex, o.actionId, o.actionSkillId, o.effect.id, value, isCrit, false);
							}
						}
					}
					break;
				/**
				 * 回城技能,对自己进行回城
				 * 
				 * 回城在无限远的地方
				 */
				case 187:
					if (target && target.isLive)
					{
						target.status = StatusTypeRole.idle;
						target.ai.skillFire = null;
						target.ai.hatred.removeAll();
						if (target.camp == 1)
						{
							target.x = 9999999;
							target.y = 9999999;
						}
						else
						{
							target.x = -9999999;
							target.y = -9999999;
						}
						if (target.info.hero && target.info.hp < target.info.hpMax)
						{
							target.ai.timeNextRevive = u.engine.time.timeGame + 1000;
						}
					}
					break;
				/**
				 * 清理目标的仇恨,将仇恨全滞空
				 */
				case 188:
					if (target && target.isLive)
					{
						target.ai.hatred.removeAll();
					}
					break;
				/**
				 * 重置目标全部技能CD
				 */
				case 189:
					if (target && target.isLive)
					{
						target.ai.oldSkill = null;
						target.ai.skillFire = null;
						for each (var skill:AIRoleSkill in target.ai.aiSkill) 
						{
							if (skill) skill.timeLength = 0;
						}
					}
					break;
				/**
				 * 增加能量值的效果
				 */
				case 190:
					if (target && target.isLive)
					{
						if (u.modeAttack)
						{
							if (target.camp == 1)
							{
								if (u.engine.camp1.addEnergy(1, o.ownerPlayerId))
								{
									if (u.playerId && o.ownerPlayerId == u.playerId)
									{
										u.net.sendEnergy(o.ownerId, o.ownerCamp, u.engine.time.timeGame, 1);
									}
									if (u.readerStart)
									{
										if (u.modeTurn)
										{
											DisplayEnergy.instance().init(u, 1, -reportX, -reportY);
										}
										else
										{
											DisplayEnergy.instance().init(u, 1, reportX, reportY);
										}
									}
								}
							}
							else
							{
								if (u.engine.camp2.addEnergy(1, o.ownerPlayerId))
								{
									if (u.playerId && o.ownerPlayerId == u.playerId)
									{
										u.net.sendEnergy(o.ownerId, o.ownerCamp, u.engine.time.timeGame, 1);
									}
									if (u.readerStart)
									{
										if (u.modeTurn)
										{
											DisplayEnergy.instance().init(u, 1, -reportX, -reportY);
										}
										else
										{
											DisplayEnergy.instance().init(u, 1, reportX, reportY);
										}
									}
								}
							}
						}
						else
						{
							//未实现
							throw new Error();
						}
					}
					break;
				/**
				 * 增加能量值的效果(本方全体)
				 */
				case 191:
					throw new Error();
					if (target && target.isLive)
					{
						if (u.modeAttack)
						{
							if (target.camp == 1)
							{
								if (u.engine.camp1.addEnergy(1))
								{
									u.net.sendEnergy(o.ownerId, o.ownerCamp, u.engine.time.timeGame, 1);
									if (u.readerStart)
									{
										if (u.modeTurn)
										{
											DisplayEnergy.instance().init(u, 1, -reportX, -reportY);
										}
										else
										{
											DisplayEnergy.instance().init(u, 1, reportX, reportY);
										}
									}
								}
							}
							else
							{
								if (u.engine.camp2.addEnergy(1))
								{
									u.net.sendEnergy(o.ownerId, o.ownerCamp, u.engine.time.timeGame, 1);
									if (u.readerStart)
									{
										if (u.modeTurn)
										{
											DisplayEnergy.instance().init(u, 1, -reportX, -reportY);
										}
										else
										{
											DisplayEnergy.instance().init(u, 1, reportX, reportY);
										}
									}
								}
							}
						}
						else
						{
							//未实现
							throw new Error();
						}
					}
					break;
				/**
				 * 对命中对象释放技能
				 */
				case 200:
					if (target && target.isLive)
					{
						ReleaseMagic.callSkillXY(u, o.ownerPlayerId, o.ownerHurtValue, o.ownerCamp, target.x, target.y, target.x, target.y);
					}
					break;
			}
		}
		
		/**
		 * 将owner的属性,使用在ed身上
		 * @param	owner
		 * @param	ed
		 */
		private static function useOwnerToEd(owner:EDRole, ed:EDRole):void
		{
			/** 前摇时间,如果发生移动就充值 **/
			//public var attackPrepose:int = 500;
			//召唤的角色是按照老角色的比例的
			if (ed.info.aiType == 0)
			{
				ed.info.aiType = owner.info.aiType;
			}
			else
			{
				ed.info.aiType = ed.info.aiType / 10000 * owner.info.aiType + owner.info.aiType;
			}
			//视野范围,像素, 激活后,会先处理仇恨列表
			if (ed.info.rangeView == 0)
			{
				ed.info.rangeView = owner.info.rangeView;
			}
			else
			{
				ed.info.rangeView = ed.info.rangeView / 10000 * owner.info.rangeView + owner.info.rangeView;
			}
			ed.info.rangeView2 = ed.info.rangeView * ed.info.rangeView;
			//警戒范围,像素, 互助的范围
			if (ed.info.rangeGuard == 0)
			{
				ed.info.rangeGuard = owner.info.rangeGuard;
			}
			else
			{
				ed.info.rangeGuard = ed.info.rangeGuard / 10000 * owner.info.rangeGuard + owner.info.rangeGuard;
			}
			ed.info.rangeGuard2 = ed.info.rangeGuard * ed.info.rangeGuard;
			//攻击频率(暂时没用)
			if (ed.info.atkRate == 0)
			{
				ed.info.atkRate = owner.info.atkRate;
			}
			else
			{
				ed.info.atkRate = ed.info.atkRate / 10000 * owner.info.atkRate + owner.info.atkRate;
			}
			//攻击力增强,百分比
			if (ed.info.atkUp == 0)
			{
				ed.info.atkUp = owner.info.atkUp;
			}
			else
			{
				ed.info.atkUp = ed.info.atkUp / 10000 * owner.info.atkUp + owner.info.atkUp;
			}
			//防御力
			if (ed.info.def == 0)
			{
				ed.info.def = owner.info.def;
			}
			else
			{
				ed.info.def = ed.info.def / 10000 * owner.info.def + owner.info.def;
			}
			//防御力增强,百分比
			if (ed.info.defUp == 0)
			{
				ed.info.defUp = owner.info.defUp;
			}
			else
			{
				ed.info.defUp = ed.info.defUp / 10000 * owner.info.defUp + owner.info.defUp;
			}
			//最大生命值
			if (ed.info.hpMax == 0)
			{
				ed.info.hpMax = owner.info.hpMax;
			}
			else
			{
				ed.info.hpMax = ed.info.hpMax / 10000 * owner.info.hpMax + owner.info.hpMax;
			}
			//生命值增强,百分比
			if (ed.info.hpUp == 0)
			{
				ed.info.hpUp = owner.info.hpUp;
			}
			else
			{
				ed.info.hpUp = ed.info.hpUp / 10000 * owner.info.hpMax + owner.info.hpMax;
			}
			//攻击间隔,普通攻击,攻击间隔,攻速,毫秒
			if (ed.info.atkTime == 0)
			{
				ed.info.atkTime = owner.info.atkTime;
			}
			else
			{
				ed.info.atkTime = ed.info.atkTime / 10000 * owner.info.atkTime + owner.info.atkTime;
			}
			//攻击间隔修正
			if (ed.info.atkTimeUp == 0)
			{
				ed.info.atkTimeUp = owner.info.atkTimeUp;
			}
			else
			{
				ed.info.atkTimeUp = ed.info.atkTimeUp / 10000 * owner.info.atkTimeUp + owner.info.atkTimeUp;
			}
			//移动速度
			if (ed.info.speed == 0)
			{
				ed.info.speed = owner.info.speed;
			}
			else
			{
				ed.info.speed = ed.info.speed / 10000 * owner.info.speed + owner.info.speed;
			}
			ed.info.speedScale = ed.info.speed / ed.model.speed;
			ed.info.speedDist = ed.u.engine.time.timeFrame * ed.info.speed / 1000;
			//减速的最低速度
			if (ed.info.speedMin == 0)
			{
				ed.info.speedMin = owner.info.speedMin;
			}
			else
			{
				ed.info.speedMin = ed.info.speedMin / 10000 * owner.info.speedMin + owner.info.speedMin;
			}
			//基础的数据,操作的时候用
			if (ed.info.speedBase == 0)
			{
				ed.info.speedBase = owner.info.speedBase;
			}
			else
			{
				ed.info.speedBase = ed.info.speedBase / 10000 * owner.info.speedBase + owner.info.speedBase;
			}
			//命中值
			if (ed.info.hit == 0)
			{
				ed.info.hit = owner.info.hit;
			}
			else
			{
				ed.info.hit = ed.info.hit / 10000 * owner.info.hit + owner.info.hit;
			}
			//回避值
			if (ed.info.dodge == 0)
			{
				ed.info.dodge = owner.info.dodge;
			}
			else
			{
				ed.info.dodge = ed.info.dodge / 10000 * owner.info.dodge + owner.info.dodge;
			}
			//封命值
			if (ed.info.sealHit == 0)
			{
				ed.info.sealHit = owner.info.sealHit;
			}
			else
			{
				ed.info.sealHit = ed.info.sealHit / 10000 * owner.info.sealHit + owner.info.sealHit;
			}
			//封抗值
			if (ed.info.sealDodge == 0)
			{
				ed.info.sealDodge = owner.info.sealDodge;
			}
			else
			{
				ed.info.sealDodge = ed.info.sealDodge / 10000 * owner.info.sealDodge + owner.info.sealDodge;
			}
			//暴击率
			if (ed.info.crit == 0)
			{
				ed.info.crit = owner.info.crit;
			}
			else
			{
				ed.info.crit = ed.info.crit / 10000 * owner.info.crit + owner.info.crit;
			}
			//暴击伤害值
			if (ed.info.critHurt == 0)
			{
				ed.info.critHurt = owner.info.critHurt;
			}
			else
			{
				ed.info.critHurt = ed.info.critHurt / 10000 * owner.info.critHurt + owner.info.critHurt;
			}
			//暴击抵抗
			if (ed.info.critDef == 0)
			{
				ed.info.critDef = owner.info.critDef;
			}
			else
			{
				ed.info.critDef = ed.info.critDef / 10000 * owner.info.critDef + owner.info.critDef;
			}
			//韧性
			if (ed.info.tenacity == 0)
			{
				ed.info.tenacity = owner.info.tenacity;
			}
			else
			{
				ed.info.tenacity = ed.info.tenacity / 10000 * owner.info.tenacity + owner.info.tenacity;
			}
			//[直接用攻击力]治疗
			if (ed.info.treat == 0)
			{
				ed.info.treat = owner.info.treat;
			}
			else
			{
				ed.info.treat = ed.info.treat / 10000 * owner.info.treat + owner.info.treat;
			}
			//治疗增强,是百分比
			if (ed.info.treatUp == 0)
			{
				ed.info.treatUp = owner.info.treatUp;
			}
			else
			{
				ed.info.treatUp = ed.info.treatUp / 10000 * owner.info.treatUp + owner.info.treatUp;
			}
			//被治疗效果,是百分比
			if (ed.info.treatEffect == 0)
			{
				ed.info.treatEffect = owner.info.treatEffect;
			}
			else
			{
				ed.info.treatEffect = ed.info.treatEffect / 10000 * owner.info.treatEffect + owner.info.treatEffect;
			}
			//再生值
			if (ed.info.regeneration == 0)
			{
				ed.info.regeneration = owner.info.regeneration;
			}
			else
			{
				ed.info.regeneration = ed.info.regeneration / 10000 * owner.info.regeneration + owner.info.regeneration;
			}
			//141技能的召唤参数
			if (ed.info.callMonster1 == 0)
			{
				ed.info.callMonster1 = owner.info.callMonster1;
			}
			else
			{
				ed.info.callMonster1 = ed.info.callMonster1 / 10000 * owner.info.callMonster1 + owner.info.callMonster1;
			}
			//142怪物的召唤ID2
			if (ed.info.callMonster2 == 0)
			{
				ed.info.callMonster2 = owner.info.callMonster2;
			}
			else
			{
				ed.info.callMonster2 = ed.info.callMonster2 / 10000 * owner.info.callMonster2 + owner.info.callMonster2;
			}
			//143怪物的召唤ID3
			if (ed.info.callMonster3 == 0)
			{
				ed.info.callMonster3 = owner.info.callMonster3;
			}
			else
			{
				ed.info.callMonster3 = ed.info.callMonster3 / 10000 * owner.info.callMonster3 + owner.info.callMonster3;
			}
			//怪物出来的初始角度,-1是通过程序设置
			if (ed.info.startAngle == 0)
			{
				ed.info.startAngle = owner.info.startAngle;
			}
			else
			{
				ed.info.startAngle = ed.info.startAngle / 10000 * owner.info.startAngle + owner.info.startAngle;
			}
			//最大的召唤怪物数量
			if (ed.info.maxCall == 0)
			{
				ed.info.maxCall = owner.info.maxCall;
			}
			else
			{
				ed.info.maxCall = ed.info.maxCall / 10000 * owner.info.maxCall + owner.info.maxCall;
			}
			//死亡的时候释放的技能
			if (ed.info.dieSkill == 0)
			{
				ed.info.dieSkill = owner.info.dieSkill;
			}
			else
			{
				ed.info.dieSkill = ed.info.dieSkill / 10000 * owner.info.dieSkill + owner.info.dieSkill;
			}
			//(毫秒)启动时间,就是可以攻击别人的时间
			if (ed.info.timeInit == 0)
			{
				ed.info.timeInit = owner.info.timeInit;
			}
			else
			{
				ed.info.timeInit = ed.info.timeInit / 10000 * owner.info.timeInit + owner.info.timeInit;
			}
			//死亡产生的经验值
			if (ed.info.expDie == 0)
			{
				ed.info.expDie = owner.info.expDie;
			}
			else
			{
				ed.info.expDie = ed.info.expDie / 10000 * owner.info.expDie + owner.info.expDie;
			}
			//技能的基础速度
			if (ed.info.skillSpeed == 0)
			{
				ed.info.skillSpeed = owner.info.skillSpeed;
			}
			else
			{
				ed.info.skillSpeed = ed.info.skillSpeed / 10000 * owner.info.skillSpeed + owner.info.skillSpeed;
			}
			//技能CD的增长速度
			if (ed.info.skillScale == 0)
			{
				ed.info.skillScale = owner.info.skillScale;
			}
			else
			{
				ed.info.skillScale = ed.info.skillScale / 10000 * owner.info.skillScale + owner.info.skillScale;
			}
			//技能里CD有关的各项值
			for (var index:int = 0; index < 5; index++)
			{
				if (ed.info.skillInfo[index].id == 0)
				{
					ed.info.skillInfo[index].id = owner.info.skillInfo[index].id;
					ed.info.skillInfo[index].lv = owner.info.skillInfo[index].lv;
					ed.info.skillInfo[index].cd = owner.info.skillInfo[index].cd;
					ed.info.skillInfo[index].cdStart = owner.info.skillInfo[index].cdStart;
				}
				else
				{
					ed.info.skillInfo[index].lv = owner.info.skillInfo[index].lv;
				}
			}
			//是否开启自动巡逻
			ed.info.autoPatrol = owner.info.autoPatrol;
			//是否可以跳跃
			ed.info.canJump = owner.info.canJump;
			//英雄的数据
			if (ed.info.heroInfo && owner.info.heroInfo)
			{
				ed.info.heroInfo.card1 = owner.info.heroInfo.card1;
				ed.info.heroInfo.card2 = owner.info.heroInfo.card2;
				ed.info.heroInfo.card3 = owner.info.heroInfo.card3;
				ed.info.heroInfo.card4 = owner.info.heroInfo.card4;
				ed.info.heroInfo.cardSkill1 = owner.info.heroInfo.cardSkill1;
				ed.info.heroInfo.cardSkill2 = owner.info.heroInfo.cardSkill2;
				ed.info.heroInfo.cardSkill3 = owner.info.heroInfo.cardSkill3;
				ed.info.heroInfo.cardSkill4 = owner.info.heroInfo.cardSkill4;
				ed.info.heroInfo.selfHealing = owner.info.heroInfo.selfHealing;
				ed.info.heroInfo.expVal = owner.info.heroInfo.expVal;
				ed.info.heroInfo.expNext = owner.info.heroInfo.expNext;
				ed.info.heroInfo.expStar = owner.info.heroInfo.expStar;
				ed.info.heroInfo.expAddUp = owner.info.heroInfo.expAddUp;
				ed.info.heroInfo.timeRevive = owner.info.heroInfo.timeRevive;
			}
			if (ed.skillList && ed.skillList.length)
			{
				ed.skillList.length = 0;
			}
			CRole.createSkill(ed);
			ed.ai.aiSkill.length = 0;
			index = 0;
			for each (var item:SkillActiveModel in ed.skillList)
			{
				if (item)
				{
					if (ed.info.skillInfo && index < ed.info.skillInfo.length && ed.info.skillInfo[index])
					{
						ed.ai.aiSkill.push(new AIRoleSkill(ed, ed.ai, item, index, ed.info.skillInfo[index]));
					}
					else
					{
						ed.ai.aiSkill.push(null);
						g.log.pushLog(AIRoleSkillEffect, LogType._ErrorLog, "ED对象:" + ed.info.serverId + " 缺少实体化技能数据 : " + index);
					}
				}
				else
				{
					ed.ai.aiSkill.push(null);
				}
				index++;
			}
			ed.ai.createOEffect();
			//映射CD的时间
			for (index = 0; index < 5; index++)
			{
				if (owner.ai.aiSkill[index] && ed.ai.aiSkill[index])
				{
					ed.ai.aiSkill[index].timeLength = owner.ai.aiSkill[index].timeLength;
				}
			}
		}
		
		/**
		 * 将ORole的属性,使用在ED身上
		 * 
		 * @param	info		备份的原始数据
		 * @param	owner		操作的本体 (要替换回去的人物)
		 * @param	ed			操作的替身 (已经被改变的人物)
		 */
		internal static function useInfoToEd(info:ORole, owner:EDRole, ed:EDRole):void
		{
			/** 前摇时间,如果发生移动就充值 **/
			//public var attackPrepose:int = 500;
			//视野范围,像素, 激活后,会先处理仇恨列表
			if (info.rangeView != 0)
			{
				owner.info.rangeView = -info.rangeView / 10000 * owner.info.rangeView + ed.info.rangeView;
			}
			owner.info.rangeView2 = owner.info.rangeView * owner.info.rangeView;
			//警戒范围,像素, 互助的范围
			if (info.rangeGuard != 0)
			{
				owner.info.rangeGuard = -info.rangeGuard / 10000 * owner.info.rangeGuard + ed.info.rangeGuard;
			}
			owner.info.rangeGuard2 = owner.info.rangeGuard * owner.info.rangeGuard;
			//攻击频率(暂时没用)
			if (info.atkRate != 0)
			{
				owner.info.atkRate = -info.atkRate / 10000 * owner.info.atkRate + ed.info.atkRate;
			}
			//攻击力增强,百分比
			if (info.atkUp != 0)
			{
				owner.info.atkUp = -info.atkUp / 10000 * owner.info.atkUp + ed.info.atkUp;
			}
			//防御力
			if (info.def != 0)
			{
				owner.info.def = -info.def / 10000 * owner.info.def + ed.info.def;
			}
			//防御力增强,百分比
			if (info.defUp != 0)
			{
				owner.info.defUp = -info.defUp / 10000 * owner.info.defUp + ed.info.defUp;
			}
			//最大生命值
			if (info.hpMax != 0)
			{
				owner.info.hpMax = -info.hpMax / 10000 * owner.info.hpMax + ed.info.hpMax;
			}
			//生命值增强,百分比
			if (info.hpUp != 0)
			{
				owner.info.hpUp = -info.hpUp / 10000 * owner.info.hpUp + ed.info.hpUp;
			}
			//攻击间隔,普通攻击,攻击间隔,攻速,毫秒
			if (info.atkTime != 0)
			{
				owner.info.atkTime = -info.atkTime / 10000 * owner.info.atkTime + ed.info.atkTime;
			}
			//攻击间隔修正
			if (info.atkTimeUp != 0)
			{
				owner.info.atkTimeUp = -info.atkTimeUp / 10000 * owner.info.atkTimeUp + ed.info.atkTimeUp;
			}
			//移动速度
			if (info.speed != 0)
			{
				owner.info.speed = -info.speed / 10000 * owner.info.speed + ed.info.speed;
			}
			owner.info.speedScale = owner.info.speed / owner.model.speed;
			owner.info.speedDist = owner.u.engine.time.timeFrame * owner.info.speed / 1000;
			//减速的最低速度
			if (info.speedMin != 0)
			{
				owner.info.speedMin = -info.speedMin / 10000 * owner.info.speedMin + ed.info.speedMin;
			}
			//基础的数据,操作的时候用
			if (info.speedBase != 0)
			{
				owner.info.speedBase = -info.speedBase / 10000 * owner.info.speedBase + ed.info.speedBase;
			}
			//命中值
			if (info.hit != 0)
			{
				owner.info.hit = -info.hit / 10000 * owner.info.hit + ed.info.hit;
			}
			//回避值
			if (info.dodge != 0)
			{
				owner.info.dodge = -info.dodge / 10000 * owner.info.dodge + ed.info.dodge;
			}
			//封命值
			if (info.sealHit != 0)
			{
				owner.info.sealHit = -info.sealHit / 10000 * owner.info.sealHit + ed.info.sealHit;
			}
			//封抗值
			if (info.sealDodge != 0)
			{
				owner.info.sealDodge = -info.sealDodge / 10000 * owner.info.sealDodge + ed.info.sealDodge;
			}
			//暴击率
			if (info.crit != 0)
			{
				owner.info.crit = -info.crit / 10000 * owner.info.crit + ed.info.crit;
			}
			//暴击伤害值
			if (info.critHurt != 0)
			{
				owner.info.critHurt = -info.critHurt / 10000 * owner.info.critHurt + ed.info.critHurt;
			}
			//暴击抵抗
			if (info.critDef != 0)
			{
				owner.info.critDef = -info.critDef / 10000 * owner.info.critDef + ed.info.critDef;
			}
			//韧性
			if (info.tenacity != 0)
			{
				owner.info.tenacity = -info.tenacity / 10000 * owner.info.tenacity + ed.info.tenacity;
			}
			//[直接用攻击力]治疗
			if (info.treat != 0)
			{
				owner.info.treat = -info.treat / 10000 * owner.info.treat + ed.info.treat;
			}
			//治疗增强,是百分比
			if (info.treatUp != 0)
			{
				owner.info.treatUp = -info.treatUp / 10000 * owner.info.treatUp + ed.info.treatUp;
			}
			//被治疗效果,是百分比
			if (info.treatEffect != 0)
			{
				owner.info.treatEffect = -info.treatEffect / 10000 * owner.info.treatEffect + ed.info.treatEffect;
			}
			//再生值
			if (info.regeneration != 0)
			{
				owner.info.regeneration = -info.regeneration / 10000 * owner.info.regeneration + ed.info.regeneration;
			}
			//141技能的召唤参数
			if (info.callMonster1 != 0)
			{
				owner.info.callMonster1 = -info.callMonster1 / 10000 * owner.info.callMonster1 + ed.info.callMonster1;
			}
			//142怪物的召唤ID2
			if (info.callMonster2 != 0)
			{
				owner.info.callMonster2 = -info.callMonster2 / 10000 * owner.info.callMonster2 + ed.info.callMonster2;
			}
			//143怪物的召唤ID3
			if (info.callMonster3 != 0)
			{
				owner.info.callMonster3 = -info.callMonster3 / 10000 * owner.info.callMonster3 + ed.info.callMonster3;
			}
			//怪物出来的初始角度,-1是通过程序设置
			if (info.startAngle != 0)
			{
				owner.info.startAngle = -info.startAngle / 10000 * owner.info.startAngle + ed.info.startAngle;
			}
			//最大的召唤怪物数量
			if (info.maxCall != 0)
			{
				owner.info.maxCall = -info.maxCall / 10000 * owner.info.maxCall + ed.info.maxCall;
			}
			//死亡的时候释放的技能
			if (info.dieSkill != 0)
			{
				owner.info.dieSkill = -info.dieSkill / 10000 * owner.info.dieSkill + ed.info.dieSkill;
			}
			//(毫秒)启动时间,就是可以攻击别人的时间
			if (info.timeInit != 0)
			{
				owner.info.timeInit = -info.timeInit / 10000 * owner.info.timeInit + ed.info.timeInit;
			}
			//死亡产生的经验值
			if (info.expDie != 0)
			{
				owner.info.expDie = -info.expDie / 10000 * owner.info.expDie + ed.info.expDie;
			}
			//技能的基础速度
			if (info.skillSpeed != 0)
			{
				owner.info.skillSpeed = -info.skillSpeed / 10000 * owner.info.skillSpeed + ed.info.skillSpeed;
			}
			//技能CD的增长速度
			if (info.skillScale != 0)
			{
				owner.info.skillScale = -info.skillScale / 10000 * owner.info.skillScale + ed.info.skillScale;
			}
			//重新刷新技能值
			ed.ai.createOEffect();
			//映射CD的时间
			for (var index:int = 0; index < 5; index++)
			{
				if (owner.ai.aiSkill[index] && ed.ai.aiSkill[index])
				{
					owner.ai.aiSkill[index].timeLength = ed.ai.aiSkill[index].timeLength;
				}
			}
		}
		
		/** 移除特效影响的buff值 **/
		public static function removeBuff(reportId:uint, reportX:int, reportY:int, target:EDRole, o:OSkillEffect):void
		{
			if (target && target.isLive)
			{
				switch (o.effect.effectId) 
				{
					case 182:
						if (target.u.reportStart)
						{
							target.u.report.removeBuff(reportId, o.ownerId, o.ownerCamp, o.ownerIdx, o.ownerCall, reportX, reportY, target, o.skillIndex, o.actionId, o.actionSkillId, o.effect.id, o.effect.id);
						}
						var value:int = getAttributeValue(target, o.effect.attributeType) - o.ownerHurtValue;
						setAttributeValue(target, o.effect.attributeType, value);
						break;
				}
			}
		}
		
		/**
		 * 获取角色某项属性值
		 * @param	target	对象
		 * @param	type	类型
		 * @return
		 */
		private static function getAttributeValue(target:EDRole, type:int):int
		{
			var value:int = 0;
			switch(type)
			{
				case 1:
					value = target.info.atk;
					break;
				case 2:
					value = target.info.atkTime;
					break;
				case 3:
					//value = target.info.speed;
					value = target.info.speedBase;
					break;
				case 4:
					value = target.info.def;
					break;
				case 5:
					value = target.info.atkUp;
					break;
				case 6:
					value = target.info.treatUp;
					break;
				case 7:
					value = target.info.defUp;
					break;
				case 8:
					value = target.info.treatEffect;
					break;
				case 9:
					value = target.info.hit;
					break;
				case 10:
					value = target.info.dodge;
					break;
				case 11:
					value = target.info.crit;
					break;
				case 12:
					value = target.info.critHurt;
					break;
				case 13:
					value = target.info.tenacity;
					break;
				case 14:
					value = target.info.critDef;
					break;
				case 15:
					value = target.info.sealHit;
					break;
				case 16:
					value = target.info.sealDodge;
					break;
				case 22:
					value = target.info.rangeView;
					break;
				case 23:
					value = target.info.skillSpeed;
					break;
			}
			return value;
		}
		
		/**
		 * 设置角色某项属性值
		 * @param	target	设置对象
		 * @param	type	设置类型
		 * @param	value	设置数值
		 */
		private static function setAttributeValue(target:EDRole, type:int, value:int):void
		{
			switch(type)
			{
				case 1:
					if (target.info.atk != value)
					{
						target.info.atk = value;
						//刷新目标技能附带数据
						target.ai.createOEffect();
					}
					break;
				case 2:
					target.info.atkTime = value;
					break;
				case 3:
					if (target.info.typeProperty != 3 && target.info.speed != 0 && value != 0)
					{
						target.info.speedBase = value;
						if (target.info.speedMin < value)
						{
							target.info.speed = value;
						}
						else
						{
							target.info.speed = target.info.speedMin;
						}
						target.info.speedScale = target.info.speed / target.model.speed;
						target.info.speedDist = target.u.engine.time.timeFrame * target.info.speed / 1000;
					}
					break;
				case 4:
					target.info.def = value;
					break;
				case 5:
					if (target.info.atkUp != value)
					{
						target.info.atkUp = value;
						//刷新目标技能附带数据
						target.ai.createOEffect();
					}
					break;
				case 6:
					if (target.info.treatUp != value)
					{
						target.info.treatUp = value;
						//刷新目标技能附带数据
						target.ai.createOEffect();
					}
					break;
				case 7:
					target.info.defUp = value;
					break;
				case 8:
					target.info.treatEffect = value;
					break;
				case 9:
					target.info.hit = value;
					break;
				case 10:
					target.info.dodge = value;
					break;
				case 11:
					target.info.crit = value;
					break;
				case 12:
					if (target.info.critHurt != value)
					{
						target.info.critHurt = value;
						//刷新目标技能附带数据
						target.ai.createOEffect();
					}
					break;
				case 13:
					target.info.tenacity = value;
					break;
				case 14:
					target.info.critDef = value;
					break;
				case 15:
					target.info.sealHit = value;
					break;
				case 16:
					target.info.sealDodge = value;
					break;
				case 22:
					target.info.rangeView = value;
					break;
				case 23:
					target.info.skillSpeed = value;
					target.info.skillScale = target.info.skillSpeed / 10000;
					break;
			}
		}
	}
}