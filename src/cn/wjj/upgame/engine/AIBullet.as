package cn.wjj.upgame.engine 
{
	import cn.wjj.g;
	import cn.wjj.display.MPoint;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.gagaframe.client.speedfact.SpeedLib;
	import cn.wjj.upgame.common.OBulletTrack;
	import cn.wjj.upgame.common.StatusTypeBullet;
	import cn.wjj.upgame.data.UpGameSkillEffect;
	
	/**
	 * 子弹的AI
	 * 
	 * 最基础的子弹
	 * 
	 * 分为有目标的内容
	 * 无目标的内容
	 * 飞啊飞
	 * 
	 * @author GaGa
	 */
	public class AIBullet
	{
		
		/** 对象池 **/
		private static var __f:SpeedLib = new SpeedLib(500);
		/** 对象池强引用的最大数量 **/
		public static function get __m():uint {return __f.length;}
		/** 对象池强引用的最大数量 **/
		public static function set __m(value:uint):void { __f.length = value; }
		
		/** 初始化 **/
		public static function instance():AIBullet
		{
			var o:AIBullet = __f.instance() as AIBullet;
			if (o)
			{
				return o;
			}
			return new AIBullet();
		}
		
		/** 移除,清理,并回收 **/
		public function dispose():void
		{
			if (this.ed) this.ed = null;
			if (this.track)
			{
				this.track.dispose();
				this.track = null;
			}
			if (this.penetrateList)
			{
				g.speedFact.d_vector(EDRole, this.penetrateList);
				this.penetrateList = null;
			}
			AIBullet.__f.recover(this);
		}
		
		/** 转换过的AI对象层 **/
		public var ed:EDBullet;
		/** 弹道驱动 **/
		public var track:AIBulletTrack;
		/** 子弹出来的时间 **/
		private var startTime:uint = 0;
		/** 穿透弹道攻击过的人物,下一次攻击不会在攻击这些人物 **/
		private var penetrateList:Vector.<EDRole>;
		/** 已经穿透了多少人 **/
		private var penetrateLength:int;
		/** 播放的特效列表 **/
		public var readerList:Vector.<uint>;
		
		public function AIBullet() { }
		
		/**
		 * 行为思考,就是准备下一步要做什么样的处理
		 * 自己人没有目标,查看视野范围内,有没有目标
		 * 是不是要准备移动,马上会进行移动处理
		 * 如果已经有目标,就不用在执行这个
		 * 本来就不需要目标的那种类型,子弹,就略过
		 * 
		 * 按照计划移动到应该移动的地方
		 */
		internal function aiRun():void
		{
			switch (ed.status) 
			{
				case StatusTypeBullet.no:
					/** 初始透明度 **/
					if (ed.info.info.alphaTime == 0)
					{
						ed.alpha = 0;
					}
					else
					{
						ed.alpha = 1;
					}
					ed.alpha = 0;
					startTime = ed.u.engine.time.timeGame;
					createTrack();
					break;
				case StatusTypeBullet.fly://继续飞
					var useTime:uint = ed.u.engine.time.timeGame - startTime;
					if (useTime > ed.info.info.alphaTime)
					{
						if (ed.alpha != 1) ed.alpha = 1;
					}
					else
					{
						if (ed.alpha != 0) ed.alpha = 0;
					}
					track.move();
					//查看是否在射程内
					break;
				/*
				case StatusTypeBullet.outRange:
				case StatusTypeBullet.die:
					//没你事了
					break;
				*/
			}
		}
		
		/** 超出射程,中途不碰撞弹道就ok,如果带范围伤害就会算击中,炸开 **/
		internal function outRange():void
		{
			var isHit:Boolean = false;
			switch (ed.info.info.track)
			{
				case OBulletTrack.track:
				case OBulletTrack.accelerate:
				case OBulletTrack.parabola:
					isHit = true;
					break;
			}
			var item:OSkillEffect;
			var skillEffect:UpGameSkillEffect;
			if (isHit == false)
			{
				for each (item in ed.info.effectList) 
				{
					skillEffect = item.effect;
					if (skillEffect && skillEffect.rangeType == 1)
					{
						isHit = true;
						break;
					}
				}
			}
			if (isHit)
			{
				var target:EDRole;
				var hitTarget:*;
				var reportId:uint = 0;
				if (ed.u.reportStart)
				{
					ed.u.report.index++;
					reportId = ed.u.report.index;
				}
				for each (item in ed.info.effectList) 
				{
					skillEffect = item.effect;
					if (skillEffect)
					{
						hitTarget = hitList(skillEffect);
						if (hitTarget)
						{
							if (hitTarget is EDRole)
							{
								// hitTarget == EDRole;
								if (hitTarget.isLive && hitTarget.inHot)
								{
									AIRoleSkillRelease.releaseSkill(reportId, ed.x, ed.y, ed.u, hitTarget, item, MPoint.instance(ed.x, ed.y));
								}
							}
							else if (hitTarget is MPoint)
							{
								AIRoleSkillRelease.releaseSkill(reportId, ed.x, ed.y, ed.u, null, item, hitTarget as MPoint);
							}
							else
							{
								// hitTarget == Vector.<EDRole>;
								for each (target in hitTarget) 
								{
									if (target.isLive && ed && ed.isLive)
									{
										AIRoleSkillRelease.releaseSkill(reportId, ed.x, ed.y, ed.u, target, item, MPoint.instance(ed.x, ed.y));
									}
								}
								g.speedFact.d_vector(EDRole, hitTarget);
								hitTarget = null;
							}
						}
					}
				}
			}
			ed.status = StatusTypeBullet.outRange;
			if (ed.u.readerStart && ed.info.info.missileRangeEffect)
			{
				var path:String = "assets/effect/skill/" + ed.info.info.missileRangeEffect + ".u2";
				if (ed.u.modeTurn)
				{
					ed.u.reader.singleEffect(ed.u.engine.time.timeEngine, path, -ed.x, -ed.y, true);
				}
				else
				{
					ed.u.reader.singleEffect(ed.u.engine.time.timeEngine, path, ed.x, ed.y, true);
				}
			}
			ed.dispose();
		}
		
		/** 超出场景多少移除 **/
		private static const outAdd:int = 150;
		
		/** 判断是否移除了场景 **/
		private function outStage():void
		{
			var astar:UpGameAStar = ed.u.engine.astar;
			if (ed.x < (astar.hotStartX - AIBullet.outAdd) || ed.y < (astar.hotStartY - AIBullet.outAdd) || ed.x > (astar.hotEndX + AIBullet.outAdd) || ed.y > (astar.hotEndY + AIBullet.outAdd))
			{
				//销毁
				ed.status = StatusTypeBullet.die;
				ed.dispose();
			}
		}
		
		/** 从没有状态到飞行 **/
		private function createTrack():void
		{
			switch (ed.info.info.track) 
			{
				case OBulletTrack.no://什么也没写,只是个模板
					ed.dispose();
					return;
					break;
				case OBulletTrack.track:// 1 [匀速][不碰]基本弹道  					ok
					if (readerList)
					{
						g.speedFact.d_vector(uint, readerList);
						readerList = null;
					}
					track = AIBulletTrackNo.instance();
					break;
				case OBulletTrack.accelerate://2 [加速][不碰]加速弹道 				ok
					if (readerList)
					{
						g.speedFact.d_vector(uint, readerList);
						readerList = null;
					}
					track = AIBulletTrackAccelerateNo.instance();
					break;
				case OBulletTrack.hit://3 [匀速][碰撞]基本弹道 						ok
					track = AIBulletTrackHit.instance();
					break;
				case OBulletTrack.accelerateHit://4 [加速][碰撞]加速弹道 			ok
					track = AIBulletTrackAccelerateHit.instance();
					break;
				case OBulletTrack.parabola://5 [匀速][不碰]抛物线弹道  				ok
					//track = AIBulletTrackNo.instance();
					if (readerList)
					{
						g.speedFact.d_vector(uint, readerList);
						readerList = null;
					}
					track = AIBulletTrackParabolaNo.instance();
					//添加预警
					if (ed.u.readerStart)
					{
						var _x:Number = ed.x - ed.point.x;
						var _y:Number = ed.y - ed.point.y;
						var _l:Number = Math.sqrt(_x * _x + _y * _y);
						if (_l != 0)
						{
							//飞行总时间
							var overTime:int = _l / ed.info.info.speed * 1000;
							if (overTime)
							{
								var range:uint = 0;
								for each (var item:OSkillEffect in ed.info.effectList) 
								{
									if (item.effect && item.effect.rangeType == 1 && range < item.effect.rangeR)
									{
										range = item.effect.rangeR;
									}
								}
								if (range)
								{
									var scale:Number = range / 75;
									if (ed.u.modeAttack)
									{
										if (ed.u.modeTurn)
										{
											ed.u.reader.singleEffect(ed.u.engine.time.timeEngine, "art/game/baozhatishia.u2", -ed.point.x, -ed.point.y, false, ed.u.reader.map.layer_floorEffect, scale, scale, overTime);
										}
										else
										{
											ed.u.reader.singleEffect(ed.u.engine.time.timeEngine, "art/game/baozhatishia.u2", ed.point.x, ed.point.y, false, ed.u.reader.map.layer_floorEffect, scale, scale, overTime);
										}
									}
									else
									{
										if (ed.u.modeTurn)
										{
											ed.u.reader.singleEffect(ed.u.engine.time.timeEngine, "art/game/baozhatishia.u2", -ed.point.x, -ed.point.y + 60, false, ed.u.reader.map.layer_floorEffect, scale, scale, overTime);
										}
										else
										{
											ed.u.reader.singleEffect(ed.u.engine.time.timeEngine, "art/game/baozhatishia.u2", ed.point.x, ed.point.y + 60, false, ed.u.reader.map.layer_floorEffect, scale, scale, overTime);
										}
									}
								}
							}
						}
					}
					break;
				case OBulletTrack.penetrateHit://6 [匀速][碰撞]穿透弹道				ok
					track = AIBulletTrackPenetrateHit.instance();
					penetrateList = g.speedFact.n_vector(EDRole);
					if (penetrateList == null)
					{
						penetrateList = new Vector.<EDRole>();
					}
					penetrateLength = 0;
					break;
				case OBulletTrack.acceleratePenetrateHit://7 [加速][碰撞]穿透弹道	ok
					track = AIBulletTrackAcceleratePtHit.instance();
					penetrateList = g.speedFact.n_vector(EDRole);
					if (penetrateList == null)
					{
						penetrateList = new Vector.<EDRole>();
					}
					penetrateLength = 0;
					break;
				case OBulletTrack.line://8 [匀速][碰撞]光线弹道
					track = AIBulletTrackLine.instance();
					penetrateList = g.speedFact.n_vector(EDRole);
					if (penetrateList == null)
					{
						penetrateList = new Vector.<EDRole>();
					}
					penetrateLength = 0;
					break;
				default:
					g.log.pushLog(this, LogType._UserAction, "缺少弹道类型 : " + ed.info.info.track);
					ed.dispose();
					return;
			}
			track.start(ed);
		}
		
		/**
		 * 子弹:查看是否已经有碰到人物,或怪物
		 * 人物:是否已经到达射程,进行攻击
		 * 击中后怎么办
		 */
		public function aiTarget():void
		{
			if (ed.status == StatusTypeBullet.fly)
			{
				var item:OSkillEffect;
				//击中的目标
				var target:EDRole;
				var hitTarget:*;
				//是否击中
				var isHit:Boolean = false;
				//是否需要销毁
				var isDispose:Boolean = false;
				var reportId:uint = 0;
				switch (ed.info.info.track) 
				{
					case OBulletTrack.no://什么也没写,只是个模板
						isDispose = true;
						break;
					case OBulletTrack.track:
					case OBulletTrack.accelerate:
					case OBulletTrack.parabola:
						if (track.isHit)
						{
							isHit = true;
							isDispose = true;
							if (ed.u.reportStart)
							{
								ed.u.report.index++;
								reportId = ed.u.report.index;
							}
							for each (item in ed.info.effectList) 
							{
								if (item.effect && ed && ed.isLive)
								{
									hitTarget = hitList(item.effect, false);
									if (hitTarget)
									{
										if (hitTarget is EDRole)
										{
											// hitTarget == EDRole;
											if (hitTarget.isLive)
											{
												AIRoleSkillRelease.releaseSkill(reportId, ed.x, ed.y, ed.u, hitTarget, item, MPoint.instance(ed.x, ed.y));
											}
										}
										else if (hitTarget is MPoint)
										{
											AIRoleSkillRelease.releaseSkill(reportId, ed.x, ed.y, ed.u, null, item, hitTarget as MPoint);
										}
										else
										{
											// hitTarget == Vector.<EDRole>;
											for each (target in hitTarget) 
											{
												if (target.isLive && ed && ed.isLive)
												{
													AIRoleSkillRelease.releaseSkill(reportId, ed.x, ed.y, ed.u, target, item, MPoint.instance(ed.x, ed.y));
												}
											}
											g.speedFact.d_vector(EDRole, hitTarget);
											hitTarget = null;
										}
									}
								}
							}
						}
						break;
					case OBulletTrack.hit:
					case OBulletTrack.accelerateHit:
						if (ed.u.reportStart)
						{
							ed.u.report.index++;
							reportId = ed.u.report.index;
						}
						for each (item in ed.info.effectList) 
						{
							if (item.effect && ed && ed.isLive)
							{
								hitTarget = hitList(item.effect);
								if (hitTarget)
								{
									if (hitTarget is EDRole)
									{
										if (isHit == false) isHit = true;
										if (isDispose == false) isDispose = true;
										target = hitTarget;
										if (target.isLive)
										{
											if (readerList && item.effect.hitEffect && readerList.indexOf(item.effect.hitEffect) == -1)
											{
												if (item.effect.type == 0)
												{
													if((target.info.typeProperty == 1 && item.effect.AttacksGround)
													|| (target.info.typeProperty == 2 && item.effect.AttacksAir)
													|| (target.info.typeProperty == 3 && item.effect.AttacksBuildings)
													|| (target.info.typeProperty == 4 && item.effect.AttacksBases))
													{
														readerList.push(item.effect.hitEffect);
													}
												}
												else if (item.effect.type == 1 || item.effect.type == 3)
												{
													readerList.push(item.effect.hitEffect);
												}
											}
											AIRoleSkillRelease.releaseSkill(reportId, ed.x, ed.y, ed.u, target, item, null);
										}
									}
									else if (hitTarget is MPoint)
									{
										AIRoleSkillRelease.releaseSkill(reportId, ed.x, ed.y, ed.u, null, item, hitTarget as MPoint);
									}
									else
									{
										if (isHit == false) isHit = true;
										if (isDispose == false) isDispose = true;
										for each (target in hitTarget)// hitTarget == Vector.<EDRole>;
										{
											if (ed && ed.isLive)
											{
												if (target.isLive)
												{
													if (readerList && item.effect.hitEffect && readerList.indexOf(item.effect.hitEffect) == -1)
													{
														if (item.effect.type == 0)
														{
															if((target.info.typeProperty == 1 && item.effect.AttacksGround)
															|| (target.info.typeProperty == 2 && item.effect.AttacksAir)
															|| (target.info.typeProperty == 3 && item.effect.AttacksBuildings)
															|| (target.info.typeProperty == 4 && item.effect.AttacksBases))
															{
																readerList.push(item.effect.hitEffect);
															}
														}
														else if (item.effect.type == 1 || item.effect.type == 3)
														{
															readerList.push(item.effect.hitEffect);
														}
													}
													AIRoleSkillRelease.releaseSkill(reportId, ed.x, ed.y, ed.u, target, item, null);
												}
											}
											else
											{
												break;
											}
										}
										g.speedFact.d_vector(EDRole, hitTarget);
										hitTarget = null;
									}
								}
							}
						}
						break;
					case OBulletTrack.line:
					case OBulletTrack.penetrateHit:
					case OBulletTrack.acceleratePenetrateHit://7 [加速][碰撞]穿透弹道
						//penetrateList 已经命中记录在这里面
						if (ed.u.reportStart)
						{
							ed.u.report.index++;
							reportId = ed.u.report.index;
						}
						var hitTimes:uint = ed.info.info.hitTimes;
						if (hitTimes == 0 || hitTimes > penetrateLength)
						{
							//在这里先将命中的目标都罗列出来
							if (ed.info.effectList.length == 1)
							{
								//一个效果的情况
								item = ed.info.effectList[0];
								if (item.effect && ed && ed.isLive)
								{
									hitTarget = hitList(item.effect);
									if (hitTarget)
									{
										if (hitTarget as EDRole)
										{
											if (hitTarget.isLive && penetrateList.indexOf(hitTarget) == -1)
											{
												if (isHit == false) isHit = true;
												penetrateList.push(hitTarget);
												penetrateLength++;
												if (readerList && item.effect.hitEffect && readerList.indexOf(item.effect.hitEffect) == -1)
												{
													if (item.effect.type == 0)
													{
														if((hitTarget.info.typeProperty == 1 && item.effect.AttacksGround)
														|| (hitTarget.info.typeProperty == 2 && item.effect.AttacksAir)
														|| (hitTarget.info.typeProperty == 3 && item.effect.AttacksBuildings)
														|| (hitTarget.info.typeProperty == 4 && item.effect.AttacksBases))
														{
															readerList.push(item.effect.hitEffect);
														}
													}
													else if (item.effect.type == 1 || item.effect.type == 3)
													{
														readerList.push(item.effect.hitEffect);
													}
												}
												AIRoleSkillRelease.releaseSkill(reportId, ed.x, ed.y, ed.u, hitTarget, item, null);
											}
										}
										else if (hitTarget is MPoint)
										{
											AIRoleSkillRelease.releaseSkill(reportId, ed.x, ed.y, ed.u, null, item, hitTarget as MPoint);
										}
										else
										{
											// hitTarget == Vector.<EDRole>;
											for each (target in hitTarget) 
											{
												if (ed && ed.isLive && isDispose == false)
												{
													if (target.isLive && penetrateList.indexOf(target) == -1)
													{
														if (isHit == false) isHit = true;
														penetrateList.push(target);
														penetrateLength++;
														if (readerList && item.effect.hitEffect && readerList.indexOf(item.effect.hitEffect) == -1)
														{
															if (item.effect.type == 0)
															{
																if((target.info.typeProperty == 1 && item.effect.AttacksGround)
																|| (target.info.typeProperty == 2 && item.effect.AttacksAir)
																|| (target.info.typeProperty == 3 && item.effect.AttacksBuildings)
																|| (target.info.typeProperty == 4 && item.effect.AttacksBases))
																{
																	readerList.push(item.effect.hitEffect);
																}
															}
															else if (item.effect.type == 1 || item.effect.type == 3)
															{
																readerList.push(item.effect.hitEffect);
															}
														}
														AIRoleSkillRelease.releaseSkill(reportId, ed.x, ed.y, ed.u, target, item, null);
														if (hitTimes != 0 && hitTimes == penetrateLength)
														{
															isDispose = true;
															break;
														}
													}
												}
												else
												{
													break;
												}
											}
											g.speedFact.d_vector(EDRole, hitTarget);
											hitTarget = null;
										}
										if (hitTimes != 0 && hitTimes == penetrateLength)
										{
											isDispose = true;
										}
									}
								}
							}
							else if (ed.info.effectList.length)
							{
								//有多个效果
								//本轮目标数量
								var thisRound:Vector.<EDRole> = g.speedFact.n_vector(EDRole);
								if (thisRound == null) thisRound = new Vector.<EDRole>();
								var thisRoundLength:int = 0;
								for each (item in ed.info.effectList)
								{
									if (isDispose == false && item.effect && ed && ed.isLive)
									{
										hitTarget = hitList(item.effect);
										if (hitTarget)
										{
											if (hitTarget as EDRole)
											{
												if (isDispose == false && hitTarget.isLive && penetrateList.indexOf(hitTarget) == -1)
												{
													if (thisRound.indexOf(hitTarget) == -1)
													{
														if (hitTimes == 0 || hitTimes > (penetrateLength + thisRoundLength))
														{
															if (isHit == false) isHit = true;
															thisRound.push(hitTarget);
															thisRoundLength++;
															if (readerList && item.effect.hitEffect && readerList.indexOf(item.effect.hitEffect) == -1)
															{
																if (item.effect.type == 0)
																{
																	if((hitTarget.info.typeProperty == 1 && item.effect.AttacksGround)
																	|| (hitTarget.info.typeProperty == 2 && item.effect.AttacksAir)
																	|| (hitTarget.info.typeProperty == 3 && item.effect.AttacksBuildings)
																	|| (hitTarget.info.typeProperty == 4 && item.effect.AttacksBases))
																	{
																		readerList.push(item.effect.hitEffect);
																	}
																}
																else if (item.effect.type == 1 || item.effect.type == 3)
																{
																	readerList.push(item.effect.hitEffect);
																}
															}
															AIRoleSkillRelease.releaseSkill(reportId, ed.x, ed.y, ed.u, hitTarget, item, null);
														}
													}
													else
													{
														if (isHit == false) isHit = true;
														AIRoleSkillRelease.releaseSkill(reportId, ed.x, ed.y, ed.u, hitTarget, item, null);
													}
												}
											}
											else if (hitTarget is MPoint)
											{
												AIRoleSkillRelease.releaseSkill(reportId, ed.x, ed.y, ed.u, null, item, hitTarget as MPoint);
											}
											else
											{
												for each (target in hitTarget)// hitTarget == Vector.<EDRole>;
												{
													if (ed && ed.isLive && isDispose == false)
													{
														if (target.isLive && penetrateList.indexOf(target) == -1)
														{
															if (thisRound.indexOf(target) == -1)
															{
																if (hitTimes == 0 || hitTimes > (penetrateLength + thisRoundLength))
																{
																	if (isHit == false) isHit = true;
																	thisRound.push(target);
																	thisRoundLength++;
																	if (readerList && item.effect.hitEffect && readerList.indexOf(item.effect.hitEffect) == -1)
																	{
																		if (item.effect.type == 0)
																		{
																			if((target.info.typeProperty == 1 && item.effect.AttacksGround)
																			|| (target.info.typeProperty == 2 && item.effect.AttacksAir)
																			|| (target.info.typeProperty == 3 && item.effect.AttacksBuildings)
																			|| (target.info.typeProperty == 4 && item.effect.AttacksBases))
																			{
																				readerList.push(item.effect.hitEffect);
																			}
																		}
																		else if (item.effect.type == 1 || item.effect.type == 3)
																		{
																			readerList.push(item.effect.hitEffect);
																		}
																	}
																	AIRoleSkillRelease.releaseSkill(reportId, ed.x, ed.y, ed.u, target, item, null);
																}
															}
															else
															{
																if (isHit == false) isHit = true;
																if (readerList && item.effect.hitEffect && readerList.indexOf(item.effect.hitEffect) == -1)
																{
																	if (item.effect.type == 0)
																	{
																		if((target.info.typeProperty == 1 && item.effect.AttacksGround)
																		|| (target.info.typeProperty == 2 && item.effect.AttacksAir)
																		|| (target.info.typeProperty == 3 && item.effect.AttacksBuildings)
																		|| (target.info.typeProperty == 4 && item.effect.AttacksBases))
																		{
																			readerList.push(item.effect.hitEffect);
																		}
																	}
																	else if (item.effect.type == 1 || item.effect.type == 3)
																	{
																		readerList.push(item.effect.hitEffect);
																	}
																}
																AIRoleSkillRelease.releaseSkill(reportId, ed.x, ed.y, ed.u, target, item, null);
															}
														}
													}
													else
													{
														break;
													}
												}
												g.speedFact.d_vector(EDRole, hitTarget);
												hitTarget = null;
											}
										}
									}
								}
								//将本轮的命中目标在推到轮循环中
								if (thisRoundLength && penetrateList)
								{
									for each (target in thisRound) 
									{
										penetrateList.push(target);
										penetrateLength++;
									}
								}
								if (thisRound)
								{
									g.speedFact.d_vector(EDRole, thisRound);
									thisRound = null;
								}
								if (hitTimes != 0 && hitTimes == penetrateLength)
								{
									isDispose = true;
								}
							}
						}
						else
						{
							isDispose = true;
						}
						break;
					default:
						g.log.pushLog(this, LogType._ErrorLog, "缺少弹道类型 : " + ed.info.info.track);
				}
				if (isHit)
				{
					//子弹击中,销毁子弹的特效
					if(ed)
					{
						if (readerList)
						{
							if (readerList.length)
							{
								for each (reportId in readerList) 
								{
									if (ed.u.modeTurn)
									{
										ed.u.reader.singleEffect(ed.u.engine.time.timeEngine, "assets/effect/skill/" + reportId + ".u2", -ed.x, -ed.y, true);
									}
									else
									{
										ed.u.reader.singleEffect(ed.u.engine.time.timeEngine, "assets/effect/skill/" + reportId + ".u2", ed.x, ed.y, true);
									}
								}
								readerList.length = 0;
							}
						}
						else if (ed.u.readerStart)
						{
							for each (item in ed.info.effectList)
							{
								if (item.effect.hitEffect && (item.effect.type == 0 || item.effect.type == 1 || item.effect.type == 3))
								{
									if (ed.u.modeTurn)
									{
										ed.u.reader.singleEffect(ed.u.engine.time.timeEngine, "assets/effect/skill/" + item.effect.hitEffect + ".u2", -ed.x, -ed.y, true);
									}
									else
									{
										ed.u.reader.singleEffect(ed.u.engine.time.timeEngine, "assets/effect/skill/" + item.effect.hitEffect + ".u2", ed.x, ed.y, true);
									}
								}
							}
						}
						if (isDispose) ed.dispose();
					}
				}
				else if (track.outRange)
				{
					outRange();
				}
				else
				{
					outStage();
				}
			}
		}
		
		/**
		 * 获取技能的命中列表
		 * @param	skillEffect
		 * @param	hitRange		是否需要击中才会爆开
		 * @return
		 */
		private function hitList(skillEffect:UpGameSkillEffect, hitRange:Boolean = true):Object
		{
			if (skillEffect.effectTarget == 4)
			{
				//对自己的效果, 在子弹发出前已经释放掉了,但是自己释放的不会走子弹,所以还是要产生效果
				return ed.owner;
			}
			else if(skillEffect.type == 3)
			{
				//如果在固定地方放持续特效,并且以BUFF的形态出现,就强制用固定点
				if (ed.point)
				{
					return ed.point;
				}
				else
				{
					return MPoint.instance(ed.x, ed.y);
				}
			}
			else if (skillEffect.effectTarget == 5)
			{
				//5-坐标点(弹道:子弹坐标点,非弹道:技能发射点)
				if (ed.point)
				{
					return ed.point;
				}
				else
				{
					return MPoint.instance(ed.x, ed.y);
				}
			}
			else
			{
				var skillList:Vector.<EDRole>;
				if (skillEffect.rangeType == 1)
				{
					//范围伤害
					switch (skillEffect.effectTarget) 
					{
						case 1://1-全体
							skillList = SearchTargetBullet.searchRoleCampRange(ed, 3, skillEffect, hitRange);
							break;
						case 2://2-友方
							skillList = SearchTargetBullet.searchRoleCampRange(ed, 2, skillEffect, hitRange);
							break;
						case 3://3-敌方
							skillList = SearchTargetBullet.searchRoleCampRange(ed, 1, skillEffect, hitRange);
							break;
						case 6://3-敌方 , 血量排序
							skillList = SearchTargetBullet.searchRoleCampRange(ed, 1, skillEffect, hitRange);
							if(skillList && skillList.length > 2)
							{
								SearchTargetBullet.sortHPList(skillList);
								if (skillList.length > 2)
								{
									skillList.splice(2, skillList.length - 2);
								}
							}
							break;
						default:
							skillList = SearchTargetBullet.searchRoleCampRange(ed, 1, skillEffect, hitRange);
					}
					return skillList;
				}
				else
				{
					var target:EDRole;
					//用作在单体内容
					switch (skillEffect.effectTarget) 
					{
						case 1://1-全体
							target = SearchTargetBullet.searchRoleCampOne(ed, 3);
							break;
						case 2://2-友方
							target = SearchTargetBullet.searchRoleCampOne(ed, 2);
							break;
						case 3://3-敌方
							target = SearchTargetBullet.searchRoleCampOne(ed, 1);
							break;
						case 6://3-敌方
							target = SearchTargetBullet.searchRoleCampOneMax(ed, 1);
							break;
						default:
							target = SearchTargetBullet.searchRoleCampOne(ed, 1);
					}
					return target;
				}
			}
			return null;
		}
	}
}