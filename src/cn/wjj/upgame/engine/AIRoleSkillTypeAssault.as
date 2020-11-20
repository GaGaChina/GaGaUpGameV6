package cn.wjj.upgame.engine 
{
	import cn.wjj.g;
	import cn.wjj.upgame.common.IOtherSkillRun;
	import cn.wjj.upgame.common.StatusTypeRole;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 冲锋技能(无视所有的子弹作用效果效果)
	 * 只有自己,和敌人类型的效果会释放
	 * 对自己的效果(技能触发时候,使用一次)
	 * 对敌人的效果(没个被冲人使用一次)
	 * 
	 * 冲刺类技能 需要增加子弹的数据
	 * 子弹的半径 代表冲刺者的冲刺时的碰撞半径
	 * 子弹的速度，加速度，最高速度 代表冲刺时行动的速度
	 * 
	 * 冲刺技能中射程的数据代表冲刺技能可以冲刺到的最大距离
	 * 
	 * @author GaGa
	 */
	public class AIRoleSkillTypeAssault implements IOtherSkillRun 
	{
		/** 是否属于激活的 **/
		private var isLive:Boolean = true;
		/** 起始位置 **/
		private var _x:int;
		private var _y:int;
		private var _a:Number;
		private var _r:int;
		/** 移动的时候中途停顿的时间 **/
		private var moveStartKill:int = 0;
		/** 移动的时候已经使用的距离 **/
		private var moveUserRange:Number = 0;
		
		/** 已经命中的对象列表 **/
		private var hitList:Vector.<EDRole>;
		/** 主动技能引用 **/
		private var skill:AIRoleSkill;
		
		/** 冲锋的碰撞范围, 用的身上的碰撞点 **/
		private var range:int = 50;
		/** 冲锋移动的速度, 像素 **/
		private var speed:uint = 750;
		/** 落地特效,作用于冲锋完毕 **/
		private var overEffect:uint = 0;
		/** 冲锋要多少时间内会重置hitList的数量 **/
		private var reCleanHit:int = 0;
		/** 下一次刷新hitList内容的时间 **/
		private var reCleanTime:int = 0;
		
		/**
		 * 开始释放特殊技能
		 * @param	ed
		 * @param	skill		技能的原始数据,里面有射程
		 */
		public function AIRoleSkillTypeAssault() { }
		
		/**
		 * 开始释放特殊技能
		 * @param	skill	主动技能引用
		 * @return
		 */
		public function start(skill:AIRoleSkill, useTime:uint):Boolean
		{
			if (skill.actionList.length)
			{
				var ed:EDRole = skill.ed;
				_x = ed.x;
				_y = ed.y;
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
				if (action.bulletListLength)
				{
					var oBullet:OBullet = action.bulletList[0];
					range = oBullet.info.radius;
					speed = oBullet.info.speed;
					overEffect = oBullet.info.missileRangeEffect;
					reCleanHit = oBullet.info.startSpeed;
					if (reCleanHit)
					{
						reCleanTime = ed.u.engine.time.timeGame + reCleanHit;
					}
				}
				else
				{
					range = 50;
					speed = 750;
					overEffect = 0;
					reCleanHit = 0;
				}
				var playEffect:Boolean = false;
				var hitX:int, hitY:int;
				if (ed.u.readerStart)
				{
					playEffect = true;
					hitX = ed.x + ed.hit_r_x;
					hitY = ed.y + ed.hit_r_y;
					if (ed.hit_h)//方形
					{
						hitX = ed.hit_r / 2 + hitX;
						hitY = ed.hit_h / 2 + hitY;
					}
				}
				var reportId:uint = 0;
				var reportAdd:Boolean = false;
				var oSkill:OSkillEffect;
				for each (action in skill.actionList) 
				{
					//马上生效技能,全部生效
					if (ed.isLive)
					{
						reportAdd = false;
						if (action.realTimeListLength)
						{
							for each (oSkill in action.realTimeList) 
							{
								if (ed.isLive)
								{
									if (oSkill.effect.effectTarget == 4)
									{
										if (ed.u.reportStart)
										{
											ed.u.report.index++;
											reportId = ed.u.report.index;
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
										AIRoleSkillRelease.releaseSkill(reportId, ed.x, ed.y, ed.u, ed, oSkill, null);
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
				runHit();
				return enterFrame(useTime);
			}
			return true;
		}
		
		/** 不停的检测,碰撞的点 **/
		private function runHit():void
		{
			//算碰撞
			var role:EDRole;
			var ed:EDRole = skill.ed;
			var rangeCount:Number;
			var action:AIRoleSkillAction;
			var oSkill:OSkillEffect;
			var px:int;
			var py:int;
			var s:AIRoleSkill = skill;
			var x:Number = ed.x + ed.hit_r_x;
			var y:Number = ed.y + ed.hit_r_y;
			if (ed.hit_h)
			{
				x = ed.hit_r / 2 + x;
				y = ed.hit_h / 2 + y;
			}
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
								if (role.isLive && role.inHot && hitList.indexOf(role) == -1)
								{
									rangeCount = SearchTargetRole.pointHitRangeCount(x, y, role);
									if (range >= rangeCount)
									{
										hitList.push(role);
										//计算伤害等等
										px = role.x + role.hit_r_x;
										py = role.y + role.hit_r_y;
										if (role.hit_h)
										{
											px = role.hit_r / 2 + px;
											py = role.hit_h / 2 + py;
										}
										//计算伤害等等
										if (s.actionLength)
										{
											for each (action in s.actionList) 
											{
												if (isLive && ed.isLive)
												{
													reportAdd = false;
													//马上生效技能,全部生效
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
																		if (ed.u.modeTurn)
																		{
																			ed.u.reader.singleEffect(ed.u.engine.time.timeEngine, "assets/effect/skill/" + oSkill.effect.hitEffect + ".u2", -px, -py, true);
																		}
																		else
																		{
																			ed.u.reader.singleEffect(ed.u.engine.time.timeEngine, "assets/effect/skill/" + oSkill.effect.hitEffect + ".u2", px, py, true);
																		}
																	}
																}
																AIRoleSkillRelease.releaseSkill(reportId, ed.x, ed.y, ed.u, role, oSkill, null);
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
		}
		
		/** 每帧都运行这个特殊技能,返回是否已经结束 **/
		public function enterFrame(useTime:uint):Boolean
		{
			var h:Number = speed * (useTime - moveStartKill) / 1000;
			var isOver:Boolean = false;
			var u:UpGame;
			var x:int, y:int;
			if (isLive && skill.ed && skill.ed.isLive)
			{
				u = skill.ed.u;
				if (reCleanHit && u.engine.time.timeGame >= reCleanTime)
				{
					reCleanTime = u.engine.time.timeGame + reCleanHit;
					hitList.length = 0;
				}
				if (u && skill.skill)
				{
					if (skill.skill.range < (h + moveUserRange))
					{
						isOver = true;
						h = skill.skill.range - moveUserRange;
					}
					x = skill.ed.x;
					y = skill.ed.y;
					switch (_r) 
					{
						case 0:
							x = int(_x + h);
							break;
						case 90:
							y = int(_y + h);
							break;
						case 180:
							x = int(_x - h);
							break;
						case 270:
							y = int(_y - h);
							break;
						default:
							x = int(Math.cos(_a) * h + _x);
							y = int(Math.sin(_a) * h + _y);
					}
					var isStop:Boolean = false;
					if (u.engine.astar.isPass(x, skill.ed.y))
					{
						skill.ed.x = x;
						if (skill.ed.uiBase == false) skill.ed.uiBase = true;
					}
					else
					{
						isStop = true;
					}
					if (u.engine.astar.isPass(skill.ed.x, y))
					{
						skill.ed.y = y;
						if (skill.ed.uiBase == false) skill.ed.uiBase = true;
					}
					else
					{
						isStop = true;
					}
					if (isStop)
					{
						_x = skill.ed.x;
						_y = skill.ed.y;
						moveStartKill = useTime;
						moveUserRange += h;
					}
					x = skill.ed.x;
					y = skill.ed.y;
					runHit();
				}
				else
				{
					isOver = true;
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
			if (isLive == false)
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