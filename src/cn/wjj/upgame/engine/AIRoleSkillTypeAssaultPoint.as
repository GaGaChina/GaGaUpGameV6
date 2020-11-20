package cn.wjj.upgame.engine 
{
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.upgame.common.IOtherSkillRun;
	import cn.wjj.upgame.common.SkillTargetType;
	import cn.wjj.upgame.common.StatusTypeRole;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 定点冲锋
	 * 冲到的人会被弹开
	 * 最后目标不会被弹开
	 * 
	 * 技能作用效果表里的击飞类型字段的意义更新为：击退距离，0为不击退
	 * 其他数字为击退距离，单位为像素
	 * 
	 * 
	 * 只有自己,和敌人类型的效果会释放
	 * 对自己的效果(技能触发时候,使用一次)
	 * 对敌人的效果(没个被冲人使用一次)
	 * 对敌人的碰撞效果,每次移动都会执行一次
	 * 
	 * 
	 * 冲刺类技能, 需要增加子弹的数据
	 * 子弹的半径, 代表冲刺者的冲刺时的碰撞半径
	 * 子弹的速度，加速度，最高速度 代表冲刺时行动的速度
	 * 
	 * 冲刺技能中射程的数据代表冲刺技能可以冲刺到的最大距离
	 * 
	 * @author GaGa
	 */
	public class AIRoleSkillTypeAssaultPoint implements IOtherSkillRun 
	{
		/** 是否属于激活的 **/
		private var isLive:Boolean = true;
		/** 目标位置 **/
		private var _x:int;
		/** 目标位置 **/
		private var _y:int;
		/** 上一次冲刺的结束点 **/
		private var edX:Number;
		private var edY:Number;
		/** 上次计算位移的时间 **/
		private var _t:uint = 0;
		private var _a:Number;
		private var _r:int;
		
		/** 已经命中的对象列表 **/
		private var hitList:Vector.<EDRole>;
		/** 主动技能引用 **/
		private var skill:AIRoleSkill;
		
		/** 冲刺碰撞距离 **/
		internal var dist:int = 10;
		/** 冲锋的碰撞范围, 用的身上的碰撞点 **/
		private var range:int = 50;
		/** 冲锋移动的速度, 像素 **/
		private var speed:uint = 750;
		/** 是否可以多次撞开 **/
		private var hitTimes:Boolean = false;
		/** 落地特效,作用于冲锋完毕 **/
		private var overEffect:uint = 0;
		/** 是否反弹回去了 **/
		private var isRebound:Boolean = false;
		/** 反弹到那个坐标 **/
		private var reboundX:int;
		/** 反弹到那个坐标 **/
		private var reboundY:int;
		/** 反弹回去的速度 **/
		private var reboundS:int;
		/** 反弹回去的距离 **/
		private var reboundC:int;
		/** 临时变量,角度 **/
		private var reboundA:Number;
		/** 临时变量,角度(弧度) **/
		private var reboundR:int;
		/** 撞上去需要停止的人物 **/
		private var overTarget:EDRole;
		
		/**
		 * 开始释放特殊技能
		 * @param	ed
		 * @param	skill		技能的原始数据,里面有射程
		 */
		public function AIRoleSkillTypeAssaultPoint() { }
		
		/**
		 * 开始释放特殊技能
		 * @param	skill	主动技能引用
		 * @return
		 */
		public function start(skill:AIRoleSkill, useTime:uint):Boolean
		{
			var ed:EDRole = skill.ed;
			edX = ed.x;
			edY = ed.y;
			if (skill.actionList.length)
			{
				if (skill.targetType == SkillTargetType.role)
				{
					if (skill.target.length)
					{
						overTarget = skill.target[0];
						_x = overTarget.x;
						_y = overTarget.y;
					}
					else
					{
						return true;
					}
				}
				else if(skill.targetType == SkillTargetType.point)
				{
					if (skill.targetPoint.length)
					{
						_x = skill.targetPoint[0].x;
						_y = skill.targetPoint[0].y;
					}
					else
					{
						return true;
					}
				}
				else
				{
					g.log.pushLog(this, LogType._ErrorLog, "定点冲锋缺少目标");
					return true;
				}
				if (hitList)
				{
					hitList.length = 0;
				}
				else
				{
					hitList = g.speedFact.n_vector(EDRole);
					if (hitList == null)
					{
						hitList = new Vector.<EDRole>();
					}
				}
				_r = ed.angle % 360;
				if (_r < 0) _r += 360;
				_a = _r / 180 * Math.PI;
				this.skill = skill;
				var action:AIRoleSkillAction = skill.actionList[0];
				//startSpeed	弹回去的速度
				//angle			弹回去的距离
				if (action.bulletListLength)
				{
					var oBullet:OBullet = action.bulletList[0];
					range = oBullet.info.radius;
					speed = oBullet.info.speed;
					dist = oBullet.info.acceleration;
					overEffect = oBullet.info.missileRangeEffect;
					reboundS = oBullet.info.startSpeed;
					reboundC = oBullet.info.angle;
				}
				else
				{
					range = 50;
					speed = 750;
					dist = 20;
					overEffect = 0;
					reboundS = 0;
					reboundC = 0;
				}
				var playEffect:Boolean = false;
				var hitX:int, hitY:int;
				if (ed.u.readerStart)
				{
					playEffect = true;
					hitX = edX + ed.hit_r_x;
					hitY = edY + ed.hit_r_y;
					if (ed.hit_h)//方形
					{
						hitX = ed.hit_r / 2 + hitX;
						hitY = ed.hit_h / 2 + hitY;
					}
				}
				var oSkill:OSkillEffect;
				var reportId:uint = 0;
				var reportAdd:Boolean = false;
				for each (action in skill.actionList) 
				{
					if (ed.isLive)
					{
						reportAdd = false;
						//马上生效技能,全部生效
						if (action.realTimeListLength)
						{
							for each (oSkill in action.realTimeList) 
							{
								if (ed.isLive)
								{
									if (oSkill.effect.effectTarget == 4)
									{
										if (reportAdd == false)
										{
											reportAdd = true;
											if (ed.u.reportStart)
											{
												ed.u.report.index++;
												reportId = ed.u.report.index;
											}
										}
										if (playEffect && oSkill.effect.hitEffect && oSkill.effect.type == 0)
										{
											if ((ed.info.typeProperty == 4 && oSkill.effect.AttacksBases)
											|| (ed.info.typeProperty == 1 && oSkill.effect.AttacksGround)
											|| (ed.info.typeProperty == 2 && oSkill.effect.AttacksAir)
											|| (ed.info.typeProperty == 3 && oSkill.effect.AttacksBuildings))
											{
												if (ed.u.modeTurn)
												{
													ed.u.reader.singleEffect(ed.u.engine.time.timeEngine, "assets/effect/skill/" + oSkill.effect.hitEffect + ".u2", -hitX, -hitY, true);
												}
												else
												{
													ed.u.reader.singleEffect(ed.u.engine.time.timeEngine, "assets/effect/skill/" + oSkill.effect.hitEffect + ".u2", hitX, hitY, true);
												}
											}
										}
										AIRoleSkillRelease.releaseSkill(reportId, int(edX), int(edY), ed.u, ed, oSkill, null);
									}
								}
								else
								{
									break;
								}
							}
						}
					}
					else
					{
						break;
					}
				}
				var hitOver:Boolean = runHit();
				if (hitOver == false)
				{
					return enterFrame(useTime);
				}
			}
			return true;
		}
		
		/** 不停的检测,碰撞的点 **/
		private function runHit():Boolean
		{
			//算碰撞
			var role:EDRole;
			var rangeCount:Number;
			var action:AIRoleSkillAction;
			var oSkill:OSkillEffect;
			var px:int;
			var py:int;
			var s:AIRoleSkill = skill;
			var ed:EDRole = s.ed;
			var x:Number = ed.x + ed.hit_r_x;
			var y:Number = ed.y + ed.hit_r_y;
			if (ed.hit_h)
			{
				x = ed.hit_r / 2 + x;
				y = ed.hit_h / 2 + y;
			}
			var hit:Boolean = false;
			var canHit:Boolean = false;
			var hitOver:Boolean = false;
			var reportId:uint = 0;
			var reportAdd:Boolean = false;
			for each (var campItem:EDCamp in ed.u.engine.campLib) 
			{
				if (isLive && ed.isLive)
				{
					if (campItem.lengthRole && campItem.camp != ed.camp)
					{
						for each (role in campItem.listRole) 
						{
							if (isLive && ed.isLive)
							{
								if (role.isLive && role.inHot && role.canHit)
								{
									rangeCount = SearchTargetRole.pointHitRangeCount(x, y, role);
									if (range >= rangeCount)
									{
										//计算伤害等等
										if (s.actionLength)
										{
											hit = false;
											if(role.model.bhitType && role.info.speed != 0)
											{
												canHit = true;
											}
											else
											{
												canHit = false;
											}
											if (hitList.indexOf(role) == -1)
											{
												if (isLive && ed.isLive)
												{
													hitList.push(role);
													px = role.x + role.hit_r_x;
													py = role.y + role.hit_r_y;
													if (role.hit_h)
													{
														px = role.hit_r / 2 + px;
														py = role.hit_h / 2 + py;
													}
													for each (action in s.actionList)
													{
														//马上生效技能,全部生效
														if (isLive && ed.isLive)
														{
															reportAdd = false;
															for each (oSkill in action.realTimeList)
															{
																if (isLive && ed.isLive)
																{
																	if (oSkill.effect.effectTarget == 3)
																	{
																		if (reportAdd == false)
																		{
																			reportAdd = true;
																			if (ed.u.reportStart)
																			{
																				ed.u.report.index++;
																				reportId = ed.u.report.index;
																			}
																		}
																		if (ed.u.readerStart && oSkill.effect.hitEffect && oSkill.effect.type == 0)
																		{
																			if ((role.info.typeProperty == 4 && oSkill.effect.AttacksBases)
																			|| (role.info.typeProperty == 1 && oSkill.effect.AttacksGround)
																			|| (role.info.typeProperty == 2 && oSkill.effect.AttacksAir)
																			|| (role.info.typeProperty == 3 && oSkill.effect.AttacksBuildings))
																			{
																				if (role.u.modeTurn)
																				{
																					ed.u.reader.singleEffect(ed.u.engine.time.timeEngine, "assets/effect/skill/" + oSkill.effect.hitEffect + ".u2", -px, -py, true);
																				}
																				else
																				{
																					ed.u.reader.singleEffect(ed.u.engine.time.timeEngine, "assets/effect/skill/" + oSkill.effect.hitEffect + ".u2", px, py, true);
																				}
																			}
																		}
																		if (AIRoleSkillRelease.releaseSkill(reportId, ed.x, ed.y, ed.u, role, oSkill, null))
																		{
																			if (hitOver == false && overTarget == role)
																			{
																				hitOver = true;
																			}
																			if(canHit && hit == false)
																			{
																				hit = true;
																			}
																		}
																	}
																}
																else
																{
																	break;
																}
															}
														}
														else
														{
															break;
														}
													}
												}
												else
												{
													break;
												}
											}
											else if (hitTimes)
											{
												for each (action in s.actionList)
												{
													if (isLive && ed.isLive)
													{
														//马上生效技能,全部生效
														for each (oSkill in action.realTimeList)
														{
															if (isLive && ed.isLive)
															{
																if (oSkill.effect.effectTarget == 3)
																{
																	if (AIRoleSkillEffect.hit(skill.ed.u, oSkill, role))
																	{
																		if(canHit && hit == false)
																		{
																			hit = true;
																		}
																	}
																	/*
																	if (skill.ed.u.readerStart && oSkill.effect.hitEffect)
																	{
																		//不知道放什么特效
																	}
																	*/
																}
															}
															else
															{
																break;
															}
														}
													}
													else
													{
														break;
													}
												}
											}
											//被撞开
											if (hit)
											{
												if (AIRoleSkillToolCollision.Collision(campItem.engine.astar, ed, x, y, dist, role))
												{
													hitOver = true;
												}
											}
										}
									}
								}
							}
							else
							{
								break;
							}
						}
					}
				}
				else
				{
					break;
				}
			}
			return hitOver;
		}
		
		/** 每帧都运行这个特殊技能,返回是否已经结束 **/
		public function enterFrame(useTime:uint):Boolean
		{
			if (isLive)
			{
				var u:UpGame, x:Number, y:Number;
				if (skill.ed && skill.ed.isLive)
				{
					u = skill.ed.u;
				}
				if (u && skill.skill)
				{
					var s:AIRoleSkill = skill;
					var h:Number, l:Number, isOver:Boolean, isStop:Boolean;
					if (isRebound)
					{
						//反弹的
						//计算现在要移动的距离
						h = reboundS * (useTime - _t) / 1000;
						_t = useTime;
						//计算距离目标点的距离
						x = reboundX - edX;
						y = reboundY - edY;
						l = Math.sqrt(x * x + y * y);
						isOver = false;
						if (h < l)
						{
							//移动还未到位
							x = edX;
							y = edY;
							switch (reboundR) 
							{
								case 0:
									x = edX + h;
									break;
								case 90:
									y = edY + h;
									break;
								case 180:
									x = edX - h;
									break;
								case 270:
									y = edY - h;
									break;
								default:
									x = Math.cos(reboundA) * h + edX;
									y = Math.sin(reboundA) * h + edY;
							}
							if (u.engine.astar.isPass(int(x), s.ed.y) && u.engine.astar.isPass(s.ed.x, int(y)))
							{
								edX = x;
								s.ed.x = int(x);
								edY = y;
								s.ed.y = int(y);
								if (s.ed.uiBase == false) s.ed.uiBase = true;
							}
							else
							{
								isOver = true;
							}
							isStop = false;
							if (u.engine.astar.isPass(int(x), s.ed.y))
							{
								edX = x;
								s.ed.x = int(x);
								if (s.ed.uiBase == false) s.ed.uiBase = true;
							}
							else
							{
								isStop = true;
							}
							if (u.engine.astar.isPass(s.ed.x, int(y)))
							{
								edY = y;
								s.ed.y = int(y);
								if (s.ed.uiBase == false) s.ed.uiBase = true;
							}
							else
							{
								isStop = true;
							}
							if (isStop && isOver == false)
							{
								isOver = true;
							}
							x = s.ed.x;
							y = s.ed.y;
						}
						else
						{
							//移动已经到位了
							h = l;
							//直接到终点
							if (u.engine.astar.isPass(reboundX, s.ed.y) && u.engine.astar.isPass(s.ed.x, reboundY))
							{
								s.ed.x = reboundX;
								s.ed.y = reboundY;
								if (s.ed.uiBase == false) s.ed.uiBase = true;
							}
							x = s.ed.x;
							y = s.ed.y;
							isOver = true;
						}
					}
					else
					{
						//计算现在要移动的距离
						h = speed * (useTime - _t) / 1000;
						_t = useTime;
						//计算距离目标点的距离
						x = _x - edX;
						y = _y - edY;
						l = Math.sqrt(x * x + y * y);
						isOver = false;
						if (h < l)
						{
							//移动还未到位
							x = edX;
							y = edY;
							switch (_r) 
							{
								case 0:
									x = edX + h;
									break;
								case 90:
									y = edY + h;
									break;
								case 180:
									x = edX - h;
									break;
								case 270:
									y = edY - h;
									break;
								default:
									x = Math.cos(_a) * h + edX;
									y = Math.sin(_a) * h + edY;
							}
							if (u.engine.astar.isPass(int(x), s.ed.y) && u.engine.astar.isPass(s.ed.x, int(y)))
							{
								edX = x;
								s.ed.x = int(x);
								edY = y;
								s.ed.y = int(y);
								if (runHit())
								{
									isOver = true;
								}
								if (s.ed.uiBase == false) s.ed.uiBase = true;
							}
							else
							{
								isOver = true;
							}
							isStop = false;
							if (u.engine.astar.isPass(int(x), s.ed.y))
							{
								edX = x;
								s.ed.x = int(x);
								if (s.ed.uiBase == false) s.ed.uiBase = true;
							}
							else
							{
								isStop = true;
							}
							if (u.engine.astar.isPass(s.ed.x, int(y)))
							{
								edY = y;
								s.ed.y = int(y);
								if (s.ed.uiBase == false) s.ed.uiBase = true;
							}
							else
							{
								isStop = true;
							}
							if (isStop && isOver == false)
							{
								isOver = true;
							}
							x = s.ed.x;
							y = s.ed.y;
						}
						else
						{
							//移动已经到位了
							h = l;
							//直接到终点
							if (u.engine.astar.isPass(_x, s.ed.y) && u.engine.astar.isPass(s.ed.x, _y))
							{
								s.ed.x = _x;
								s.ed.y = _y;
								edX = x;
								edY = y;
								if (runHit())
								{
									isOver = true;
								}
								if (s.ed.uiBase == false) s.ed.uiBase = true;
							}
							x = s.ed.x;
							y = s.ed.y;
							isOver = true;
						}
						if (isOver && reboundC)
						{
							edX = x;
							edY = y;
							isRebound = true;
							isOver = false;
							//计算出要反弹回去的距离 (反弹回去的速度和距离)
							//找到距离,然后按照角度,找出结尾的坐标,然后标出来
							reboundR = _r - 180;
							if (reboundR < 0) reboundR += 360;
							reboundA = reboundR / 180 * Math.PI;
							reboundX = Math.cos(reboundA) * reboundC + x;
							reboundY = Math.sin(reboundA) * reboundC + y;
							//切换到待机模式
							s.ed.status = StatusTypeRole.idle;
							EDRoleToolsSkin.changeSkin(s.ed, u.modeTurn);
						}
					}
				}
				else
				{
					isOver = true;
				}
				//结束
				if (isOver)
				{
					if (u && u.readerStart && overEffect)
					{
						if (u.modeTurn)
						{
							u.engine.u.reader.singleEffect(u.engine.time.timeEngine, "assets/effect/skill/" + overEffect + ".u2", -x, -y, true);
						}
						else
						{
							u.engine.u.reader.singleEffect(u.engine.time.timeEngine, "assets/effect/skill/" + overEffect + ".u2", x, y, true);
						}
					}
					dispose();
				}
			}
			else
			{
				return true;
			}
			return isOver;
		}
		
		/** 移除,清理,并回收 **/
		public function dispose():void
		{
			if (isLive)
			{
				isLive = false;
				if (hitList)
				{
					g.speedFact.d_vector(EDRole, hitList);
					hitList = null;
				}
				skill = null;
			}
		}
	}

}