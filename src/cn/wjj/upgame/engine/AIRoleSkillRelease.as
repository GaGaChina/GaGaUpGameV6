package cn.wjj.upgame.engine 
{
	import cn.wjj.display.MPoint;
	import cn.wjj.upgame.common.SkillTargetType;
	import cn.wjj.upgame.render.EngineEffect;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 技能发射器
	 * 按照技能动作表中的时间节点进行发射
	 * 
	 * @author GaGa
	 */
	public class AIRoleSkillRelease 
	{
		
		public function AIRoleSkillRelease() { }
		
		/**
		 * 当技能被执行的时候处理
		 * 
		 * @param	upGame
		 * @param	ed			攻击者
		 * @param	skill
		 * @param	item
		 */
		public static function release(reportX:int, reportY:int, action:AIRoleSkillAction):void
		{
			//多目标,多技能
			var role:EDRole;
			//马上处理的效果,只有对有效目标的时候,才触发一连串的效果
			var u:UpGame = action.skill.ed.u;
			if (action.realTimeListLength)
			{
				var engineTime:int = u.engine.time.timeEngine;
				var hitEffect:String;
				var hitX:int, hitY:int;
				var playEffect:Boolean;
				//普通技能的执行
				//播放动作,在技能动作里已经做了
				var reportId:uint = 0;
				if (u.reportStart)
				{
					u.report.index++;
					reportId = u.report.index;
				}
				for each (var effect:OSkillEffect in action.realTimeList) 
				{
					if (u.readerStart && effect.effect.hitEffect && (effect.effect.type == 0 || effect.effect.type == 1 || effect.effect.type == 3))
					{
						hitEffect = "assets/effect/skill/" + effect.effect.hitEffect + ".u2";
						playEffect = true;
					}
					else
					{
						playEffect = false;
					}
					if(action.skill.target.length)
					{
						//如果是近战,首先播放攻击者动画
						//查看目标类型,重新找目标,然后攻击,如果是直接生效的内容,就直接
						switch (effect.effect.effectTarget) 
						{
							case 1://1-全体
								for each (role in action.skill.target) 
								{
									if (role.isLive)
									{
										//子弹击中,销毁子弹的特效
										if (playEffect)
										{
											if ((role.info.typeProperty == 1 && effect.effect.AttacksGround)
											|| (role.info.typeProperty == 2 && effect.effect.AttacksAir)
											|| (role.info.typeProperty == 3 && effect.effect.AttacksBuildings)
											|| (role.info.typeProperty == 4 && effect.effect.AttacksBases))
											{
												hitX = role.x + role.hit_r_x;
												hitY = role.y + role.hit_r_y;
												if (role.hit_h)//方形
												{
													hitX = role.hit_r / 2 + hitX;
													hitY = role.hit_h / 2 + hitY;
												}
												if (u.modeTurn)
												{
													u.reader.singleEffect(engineTime, hitEffect, -hitX, -hitY, true);
												}
												else
												{
													u.reader.singleEffect(engineTime, hitEffect, hitX, hitY, true);
												}
												
												
											}
										}
										releaseSkill(reportId, reportX, reportY, u, role, effect, null);
									}
								}
								if (action.skill.ed.isLive)
								{
									//子弹击中,销毁子弹的特效
									if (playEffect)
									{
										if ((action.skill.ed.info.typeProperty == 1 && effect.effect.AttacksGround)
										|| (action.skill.ed.info.typeProperty == 2 && effect.effect.AttacksAir)
										|| (action.skill.ed.info.typeProperty == 3 && effect.effect.AttacksBuildings)
										|| (action.skill.ed.info.typeProperty == 4 && effect.effect.AttacksBases))
										{
											hitX = action.skill.ed.x + action.skill.ed.hit_r_x;
											hitY = action.skill.ed.y + action.skill.ed.hit_r_y;
											if (action.skill.ed.hit_h)//方形
											{
												hitX = action.skill.ed.hit_r / 2 + hitX;
												hitY = action.skill.ed.hit_h / 2 + hitY;
											}
											if (u.modeTurn)
											{
												u.reader.singleEffect(engineTime, hitEffect, -hitX, -hitY, true);
											}
											else
											{
												u.reader.singleEffect(engineTime, hitEffect, hitX, hitY, true);
											}
										}
									}
									releaseSkill(reportId, reportX, reportY, u, action.skill.ed, effect, null);
								}
								break;
							case 2://2-友方
								for each (role in action.skill.target)
								{
									if (role.isLive)
									{
										//子弹击中,销毁子弹的特效
										if (playEffect)
										{
											if ((role.info.typeProperty == 1 && effect.effect.AttacksGround)
											|| (role.info.typeProperty == 2 && effect.effect.AttacksAir)
											|| (role.info.typeProperty == 3 && effect.effect.AttacksBuildings)
											|| (role.info.typeProperty == 4 && effect.effect.AttacksBases))
											{
												hitX = role.x + role.hit_r_x;
												hitY = role.y + role.hit_r_y;
												if (role.hit_h)//方形
												{
													hitX = role.hit_r / 2 + hitX;
													hitY = role.hit_h / 2 + hitY;
												}
												if (u.modeTurn)
												{
													u.reader.singleEffect(engineTime, hitEffect, -hitX, -hitY, true);
												}
												else
												{
													u.reader.singleEffect(engineTime, hitEffect, hitX, hitY, true);
												}
											}
										}
										releaseSkill(reportId, reportX, reportY, u, role, effect, null);
									}
								}
								break;
							case 3://3-敌方
								for each (role in action.skill.target)
								{
									if (role.isLive)
									{
										//子弹击中,销毁子弹的特效
										if (playEffect)
										{
											if ((role.info.typeProperty == 1 && effect.effect.AttacksGround)
											|| (role.info.typeProperty == 2 && effect.effect.AttacksAir)
											|| (role.info.typeProperty == 3 && effect.effect.AttacksBuildings)
											|| (role.info.typeProperty == 4 && effect.effect.AttacksBases))
											{
												hitX = role.x + role.hit_r_x;
												hitY = role.y + role.hit_r_y;
												if (role.hit_h)//方形
												{
													hitX = role.hit_r / 2 + hitX;
													hitY = role.hit_h / 2 + hitY;
												}
												if (u.modeTurn)
												{
													u.reader.singleEffect(engineTime, hitEffect, -hitX, -hitY, true);
												}
												else
												{
													u.reader.singleEffect(engineTime, hitEffect, hitX, hitY, true);
												}
											}
										}
										releaseSkill(reportId, reportX, reportY, u, role, effect, null);
									}
								}
								break;
							case 4://4-自己
								if (action.skill.ed.isLive)
								{
									//子弹击中,销毁子弹的特效
									if (playEffect)
									{
										if ((action.skill.ed.info.typeProperty == 1 && effect.effect.AttacksGround)
										|| (action.skill.ed.info.typeProperty == 2 && effect.effect.AttacksAir)
										|| (action.skill.ed.info.typeProperty == 3 && effect.effect.AttacksBuildings)
										|| (action.skill.ed.info.typeProperty == 4 && effect.effect.AttacksBases))
										{
											hitX = action.skill.ed.x + action.skill.ed.hit_r_x;
											hitY = action.skill.ed.y + action.skill.ed.hit_r_y;
											if (action.skill.ed.hit_h)//方形
											{
												hitX = action.skill.ed.hit_r / 2 + hitX;
												hitY = action.skill.ed.hit_h / 2 + hitY;
											}
											if (u.modeTurn)
											{
												u.reader.singleEffect(engineTime, hitEffect, -hitX, -hitY, true);
											}
											else
											{
												u.reader.singleEffect(engineTime, hitEffect, hitX, hitY, true);
											}
										}
									}
									releaseSkill(reportId, reportX, reportY, u, action.skill.ed, effect, null);
								}
								break;
						}
					}
					else if(effect.effect.effectTarget == 4)
					{
						if (action.skill.ed.isLive)
						{
							if (playEffect)
							{
								if ((action.skill.ed.info.typeProperty == 1 && effect.effect.AttacksGround)
								|| (action.skill.ed.info.typeProperty == 2 && effect.effect.AttacksAir)
								|| (action.skill.ed.info.typeProperty == 3 && effect.effect.AttacksBuildings)
								|| (action.skill.ed.info.typeProperty == 4 && effect.effect.AttacksBases))
								{
									hitX = action.skill.ed.x + action.skill.ed.hit_r_x;
									hitY = action.skill.ed.y + action.skill.ed.hit_r_y;
									if (action.skill.ed.hit_h)//方形
									{
										hitX = action.skill.ed.hit_r / 2 + hitX;
										hitY = action.skill.ed.hit_h / 2 + hitY;
									}
									if (u.modeTurn)
									{
										u.reader.singleEffect(engineTime, hitEffect, -hitX, -hitY, true);
									}
									else
									{
										u.reader.singleEffect(engineTime, hitEffect, hitX, hitY, true);
									}
								}
							}
							releaseSkill(reportId, reportX, reportY, u, action.skill.ed, effect, null);
						}
					}
				}
			}
			//处理子弹
			if (action.bulletListLength)
			{
				var _x:int, _y:int, point:MPoint;
				if (action.point == 1)
				{
					_x = action.skill.ed.x + action.skill.ed.hitX1;
					_y = action.skill.ed.y + action.skill.ed.hitY1;
				}
				else
				{
					_x = action.skill.ed.x + action.skill.ed.hitX2;
					_y = action.skill.ed.y + action.skill.ed.hitY2;
				}
				for each (var bulletInfo:OBullet in action.bulletList) 
				{
					switch (action.skill.targetType) 
					{
						case SkillTargetType.role:
							for each (role in action.skill.target) 
							{
								CBullet.create(u, action.skill.ed, action.skill.ed.camp, bulletInfo, _x, _y, role, null);
							}
							break;
						case SkillTargetType.point:
							for each (point in action.skill.targetPoint) 
							{
								CBullet.create(u, action.skill.ed, action.skill.ed.camp, bulletInfo, _x, _y, null, point);
							}
							break;
						case SkillTargetType.direction:
							CBullet.create(u, action.skill.ed, action.skill.ed.camp, bulletInfo, _x, _y);
							break;
					}
				}
			}
		}
		
		/**
		 * 启动技能的技能释放
		 * 
		 * @param	upGame
		 * @param	ed			攻击者
		 * @param	skill
		 * @param	item
		 */
		public static function releaseMini(reportX:int, reportY:int, action:AIRoleSkillAction):void
		{
			//多目标,多技能
			var role:EDRole;
			//马上处理的效果,只有对有效目标的时候,才触发一连串的效果
			var u:UpGame = action.skill.ed.u;
			if (action.realTimeListLength)
			{
				var hitX:int, hitY:int;
				var playEffect:Boolean;
				//普通技能的执行
				//播放动作,在技能动作里已经做了
				var reportId:uint = 0;
				if (u.reportStart)
				{
					u.report.index++;
					reportId = u.report.index;
				}
				for each (var effect:OSkillEffect in action.realTimeList) 
				{
					if(action.skill.target.length)
					{
						//如果是近战,首先播放攻击者动画
						//查看目标类型,重新找目标,然后攻击,如果是直接生效的内容,就直接
						switch (effect.effect.effectTarget) 
						{
							case 1://1-全体
								for each (role in action.skill.target) 
								{
									if (role.isLive)
									{
										releaseSkill(reportId, reportX, reportY, u, role, effect, null);
									}
								}
								if (action.skill.ed.isLive)
								{
									releaseSkill(reportId, reportX, reportY, u, action.skill.ed, effect, null);
								}
								break;
							case 2://2-友方
								for each (role in action.skill.target)
								{
									if (role.isLive)
									{
										releaseSkill(reportId, reportX, reportY, u, role, effect, null);
									}
								}
								break;
							case 3://3-敌方
								for each (role in action.skill.target)
								{
									if (role.isLive)
									{
										releaseSkill(reportId, reportX, reportY, u, role, effect, null);
									}
								}
								break;
							case 4://4-自己
								if (action.skill.ed.isLive)
								{
									releaseSkill(reportId, reportX, reportY, u, action.skill.ed, effect, null);
								}
								break;
						}
					}
					else if(effect.effect.effectTarget == 4)
					{
						if (action.skill.ed.isLive)
						{
							releaseSkill(reportId, reportX, reportY, u, action.skill.ed, effect, null);
						}
					}
				}
			}
			//处理子弹
			if (action.bulletListLength)
			{
				var _x:int, _y:int, point:MPoint;;
				if (action.point == 1)
				{
					_x = action.skill.ed.x + action.skill.ed.hitX1;
					_y = action.skill.ed.y + action.skill.ed.hitY1;
				}
				else
				{
					_x = action.skill.ed.x + action.skill.ed.hitX2;
					_y = action.skill.ed.y + action.skill.ed.hitY2;
				}
				for each (var bulletInfo:OBullet in action.bulletList) 
				{
					switch (action.skill.targetType) 
					{
						case SkillTargetType.role:
							for each (role in action.skill.target) 
							{
								CBullet.create(u, action.skill.ed, action.skill.ed.camp, bulletInfo, _x, _y, role, null);
							}
							break;
						case SkillTargetType.point:
							for each (point in action.skill.targetPoint) 
							{
								CBullet.create(u, action.skill.ed, action.skill.ed.camp, bulletInfo, _x, _y, null, point);
							}
							break;
						case SkillTargetType.direction:
							CBullet.create(u, action.skill.ed, action.skill.ed.camp, bulletInfo, _x, _y);
							break;
					}
				}
			}
		}
		
		/**
		 * 释放技能特效
		 * @param	reportId	记录的ID排序
		 * @param	reportX
		 * @param	reportY
		 * @param	upGame
		 * @param	owner		技能释放者
		 * @param	target		技能目标
		 * @param	o			释放的技能数据
		 * @param	point
		 * @return				是否命中
		 */
		public static function releaseSkill(reportId:uint, reportX:int, reportY:int, u:UpGame, target:EDRole, o:OSkillEffect, point:MPoint):Boolean
		{
			var hit:Boolean = false;
			switch (o.effect.type) 
			{
				case 0://0-普通（作用一次的技能）
					//增加仇恨
					if (target && target.isLive && o.ownerCamp != target.camp)
					{
						if (o.owner && o.owner.isLive)
						{
							target.ai.hatred.add(o.owner, 0);
						}
						if (target.activate == false) target.activate = true;
						if (target.sleep) target.wakeUp();
					}
					hit = AIRoleSkillEffect.hit(u, o, target);
					//这里的目标都要收到伤害
					if (point)
					{
						releaseEffect(u, reportId, hit, reportX, reportY, target, o, point);
					}
					else
					{
						releaseEffect(u, reportId, hit, reportX, reportY, target, o);
					}
					break;
				case 1://1-持续产生效果的作用（燃烧弹）
				case 3://1-持续产生效果的作用（燃烧弹）,命中后释放Buff
					//增加仇恨
					if (target && target.isLive && o.ownerCamp != target.camp)
					{
						if (o.owner && o.owner.isLive)
						{
							target.ai.hatred.add(o.owner, 0);
						}
						if (target.activate == false) target.activate = true;
						if (target.sleep) target.wakeUp();
					}
					//需要创建地面的特效
					hit = AIRoleSkillEffect.hit(u, o, target);
					if (hit)
					{
						if (point)
						{
							CSkillContinue.create(u, o.owner, o, point.x, point.y);
						}
						else if(target)
						{
							CSkillContinue.create(u, o.owner, o, target.x, target.y);
						}
					}
					else if (u.readerStart && target && target.isLive && o.owner != target
					&& ((target.info.typeProperty == 1 && o.effect.AttacksGround)
					|| (target.info.typeProperty == 2 && o.effect.AttacksAir)
					|| (target.info.typeProperty == 3 && o.effect.AttacksBuildings)
					|| (target.info.typeProperty == 4 && o.effect.AttacksBases)))
					{
						if (point)
						{
							EngineEffect.showMissPoint(u, point.x, point.y);
						}
						else if(target.u.readerStart && o.effect.hitId != 3 && o.owner != target)
						{
							EngineEffect.showMissRole(u, target);
						}
					}
					break;
				case 2://2-产生状态的作用
					//增加仇恨
					if (target && target.isLive && o.ownerCamp != target.camp)
					{
						if (o.owner && o.owner.isLive)
						{
							target.ai.hatred.add(o.owner, 0);
						}
						if (target.activate == false) target.activate = true;
						if (target.sleep) target.wakeUp();
					}
					hit = AIRoleSkillEffect.hit(u, o, target);
					if (hit)
					{
						if (u.reportStart)
						{
							if (o.owner)
							{
								u.report.addBuff(reportId, o.ownerId, o.ownerCamp, o.ownerIdx, o.ownerCall, o.owner.x, o.owner.y, o.owner, o.skillIndex, o.actionId, o.actionSkillId, o.effect.id, o.effect.id);
							}
							else
							{
								u.report.addBuff(reportId, o.ownerId, o.ownerCamp, o.ownerIdx, o.ownerCall, 0, 0, null, o.skillIndex, o.actionId, o.actionSkillId, o.effect.id, o.effect.id);
							}
						}
						CSkillBuff.create(u, o.owner, target, o);
					}
					else if (u.readerStart && o.effect.hitId != 3 && target && target.isLive && o.owner != target
					&& ((target.info.typeProperty == 1 && o.effect.AttacksGround)
					|| (target.info.typeProperty == 2 && o.effect.AttacksAir)
					|| (target.info.typeProperty == 3 && o.effect.AttacksBuildings)
					|| (target.info.typeProperty == 4 && o.effect.AttacksBases)))
					{
						EngineEffect.showMissRole(u, target);
					}
					break;
			}
			return false;
		}
		
		/**
		 * 对伤害进行数值运算
		 * @param	reportId	记录的ID排序
		 * @param	reportX		伤害触发的时候的坐标
		 * @param	reportY		伤害触发的时候的坐标
		 * @param	target		有些内容没有目标,点对象等
		 * @param	effect
		 * @param	point
		 * @return
		 */
		internal static function releaseEffect(u:UpGame, reportId:uint, isHit:Boolean, reportX:int, reportY:int, target:EDRole, effect:OSkillEffect, point:MPoint = null):void
		{
			if (isHit)
			{
				//爆击
				var isCrit:Boolean = false;
				var critValue:int = 10000;
				/** 计算得到暴击值 **/
				var value:int;
				switch (effect.effect.critId) 
				{
					/**
					 * 例如封印类这类不会产生致命的技能的致命计算；
					 * 当遇到致命公式id = 10的时候，直接跳过致命流程；计算为不致命的情况；
					 */
					case 10:
						isCrit = false;
						critValue = 10000;
						break;
					/**
					 * 用于伤害和会产生致命的类技能致命计算；
					 * 【攻击方致命】，（攻击方对应的技能附加总暴击 ）=【技能附加暴击】+【技能附加暴击增量】X（技能等级）
					 * 注：由于防御方的几个属性初始话都需要带上，故不在这里在列举出来，（下同）
					 * （攻击方总致命值） = 【攻击方致命】 +（攻击方对应的技能附加总暴击 ）
					 * （致命率） = （攻击方总致命值）	- 【防御方韧性】
					 */
					case 11:
						if (target && target.isLive)
						{
							value = effect.ownerCrit - target.info.tenacity;
							if (u.random * 10000 > value)
							{
								isCrit = false;
								critValue = 10000;
							}
							else
							{
								isCrit = true;
								critValue = effect.ownerCritValue - target.info.critDef;
								if(critValue < 12000)
								{
									critValue = 12000;
								}
							}
						}
						break;
					/**
					 * 用于治疗和会产生致命的类技能致命计算；
					 * 【攻击方致命】，（攻击方对应的技能附加总暴击 ）=【技能附加暴击】+【技能附加暴击增量】X（技能等级）
					 * （攻击方总致命值） = 【攻击方致命】 +（攻击方对应的技能附加总暴击 ）
					 * （致命率） = （攻击方总致命值）
					 */
					case 12:
						if (u.random * 10000 > effect.ownerCrit)
						{
							isCrit = false;
							critValue = 10000;
						}
						else
						{
							isCrit = true;
							critValue = effect.ownerCritValue;
						}
						break;
				}
				//是否可以击飞
				if (target && target.isLive && effect.effect.hitType && target.model.bhitType && target.info.speed != 0)
				{
					AIRoleSkillToolCollision.Collision(u.engine.astar, null, reportX, reportY, effect.effect.hitType, target);
				}
				AIRoleSkillEffect.hurt(u, reportId, reportX, reportY, effect, critValue, target, point, isCrit);
			}
			else
			{
				if (u.reportStart)
				{
					u.report.miss(reportId, effect.ownerId, effect.ownerCamp, effect.ownerIdx, effect.ownerCall, reportX, reportY, target, effect.skillIndex, effect.actionId, effect.actionSkillId, effect.effect.id);
				}
				if (u.readerStart && target && target.isLive
				&& ((target.info.typeProperty == 1 && effect.effect.AttacksGround)
				|| (target.info.typeProperty == 2 && effect.effect.AttacksAir)
				|| (target.info.typeProperty == 3 && effect.effect.AttacksBuildings)
				|| (target.info.typeProperty == 4 && effect.effect.AttacksBases)))
				{
					if (effect.owner)
					{
						if (target != effect.owner)
						{
							EngineEffect.showMissRole(u, target);
						}
					}
					else
					{
						EngineEffect.showMissRole(u, target);
					}
				}
			}
		}
	}
}