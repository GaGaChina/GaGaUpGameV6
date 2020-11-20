package cn.wjj.upgame.engine 
{
	import cn.wjj.g;
	import cn.wjj.upgame.common.StatusTypeRole;
	import cn.wjj.upgame.data.UpGameBulletInfo;
	
	/**
	 * 激光技能动作(无视所有的子弹作用效果效果)
	 * 只有自己,和敌人类型的效果会释放
	 * 对自己的效果(技能触发时候,使用一次)
	 * 对敌人的效果(没个被冲人使用一次)
	 * 
	 * @author GaGa
	 */
	public class AIRoleSkillTypeLaserItem
	{
		
		/** 是否属于激活的 **/
		private var isLive:Boolean = true;
		/** 碰撞范围 **/
		private var x1:int;
		private var x2:int;
		private var y1:int;
		private var y2:int;
		/** 运行了多少次,从0开始 **/
		private var times:uint;
		/** 已经命中的对象列表 **/
		private var hitList:Vector.<EDRole>;
		/** 播放的动作 **/
		private var action:AIRoleSkillAction;
		/** 显示对象 **/
		private var display:EDDisplay;
		/** 开始时间 **/
		private var startTime:uint;
		
		/**
		 * 开始释放特殊技能
		 * @param	ed
		 * @param	skill		技能的原始数据,里面有射程
		 */
		public function AIRoleSkillTypeLaserItem() { }
		
		/**
		 * 开始释放特殊技能
		 * @param	action		
		 * @param	useTime		
		 * @param	vertical	是否垂直
		 * @return
		 */
		public function start(action:AIRoleSkillAction, useTime:uint, vertical:Boolean):Boolean
		{
			if(action.bulletList && action.bulletList.length && action.bulletList[0].effectList && action.bulletList[0].effectList.length)
			{
				startTime = useTime;
				this.action = action;
				var bulletInfo:UpGameBulletInfo = action.bulletList[0].info;
				if (vertical)
				{
					if (action.skill.ed.angle > 0 && action.skill.ed.angle < 180)//向下
					{
						action.skill.ed.angle = 90;
						y1 = 0;
						y2 = action.skill.skill.range;
					}
					else
					{
						action.skill.ed.angle = 270;
						y1 = -action.skill.skill.range;
						y2 = 0;
					}
				}
				else
				{
					if (action.skill.ed.angle > 90 && action.skill.ed.angle < 270)//向左
					{
						action.skill.ed.angle = 180;
						x1 = -action.skill.skill.range;
						x2 = 0;
					}
					else
					{
						action.skill.ed.angle = 0;
						x1 = 0;
						x2 = action.skill.skill.range;
					}
				}
				EDRoleToolsSkin.changeSkin(action.skill.ed, action.skill.ed.u.modeTurn);
				var hitX:int, hitY:int;
				if (action.point == 1)
				{
					hitX = action.skill.ed.x + action.skill.ed.hitX1;
					hitY = action.skill.ed.y + action.skill.ed.hitY1;
				}
				else
				{
					hitX = action.skill.ed.x + action.skill.ed.hitX2;
					hitY = action.skill.ed.y + action.skill.ed.hitY2;
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
				if (vertical)
				{
					x1 = hitX - bulletInfo.radius;
					x2 = x1 + bulletInfo.radius + bulletInfo.radius;
					y1 = y1 + hitY;
					y2 = y2 + hitY;
				}
				else
				{
					y1 = hitY - bulletInfo.radius;
					y2 = y1 + bulletInfo.radius + bulletInfo.radius;
					x1 = x1 + hitX;
					x2 = x2 + hitX;
				}
				if (action.skill.ed.u.readerStart)
				{
					if (display)
					{
						display.dispose();
						display = null;
					}
					display = new EDDisplay(action.skill.ed.u);
					display.x = hitX;
					display.y = hitY;
					display.angle = action.skill.ed.angle;
					display.camp = action.skill.ed.camp;
					display.displayId = bulletInfo.pathId;
					display.pathType = 1;
					action.skill.ed.u.engine.addED(display);
				}
				times = 0;
				//把对自己的效果先释放出来
				var playEffect:Boolean = false;
				if (action.skill.ed.u.readerStart)
				{
					playEffect = true;
					hitX = action.skill.ed.x + action.skill.ed.hit_r_x;
					hitY = action.skill.ed.y + action.skill.ed.hit_r_y;
					if (action.skill.ed.hit_h)//方形
					{
						hitX = action.skill.ed.hit_r / 2 + hitX;
						hitY = action.skill.ed.hit_h / 2 + hitY;
					}
				}
				//马上生效技能,全部生效
				var reportId:uint = 0;
				if (action.skill.ed.u.reportStart)
				{
					action.skill.ed.u.report.index++;
					reportId = action.skill.ed.u.report.index;
				}
				for each (var oSkill:OSkillEffect in action.realTimeList) 
				{
					if (oSkill.effect.effectTarget == 4)
					{
						AIRoleSkillRelease.releaseSkill(reportId, action.skill.ed.x, action.skill.ed.y, action.skill.ed.u, action.skill.ed, oSkill, null);
						if (playEffect && oSkill.effect.hitEffect && oSkill.effect.type == 0)
						{
							if ((action.skill.ed.info.typeProperty == 4 && oSkill.effect.AttacksBases)
							|| (action.skill.ed.info.typeProperty == 1 && oSkill.effect.AttacksGround)
							|| (action.skill.ed.info.typeProperty == 2 && oSkill.effect.AttacksAir)
							|| (action.skill.ed.info.typeProperty == 3 && oSkill.effect.AttacksBuildings))
							{
								if (action.skill.ed.u.modeTurn)
								{
									action.skill.ed.u.reader.singleEffect(action.skill.ed.u.engine.time.timeEngine, "assets/effect/skill/" + oSkill.effect.hitEffect + ".u2", -hitX, -hitY, true);
								}
								else
								{
									action.skill.ed.u.reader.singleEffect(action.skill.ed.u.engine.time.timeEngine, "assets/effect/skill/" + oSkill.effect.hitEffect + ".u2", hitX, hitY, true);
								}
							}
						}
					}
				}
				return enterFrame(useTime);
			}
			return true;
		}
		
		/**
		 * 每帧都运行这个特殊技能,返回是否已经结束
		 * 
		 * SkillActiveModel 主动技能
		 * skill.loopTime	: 单次时间
		 * skill.loop		: 次数
		 * 
		 * @param	useTime
		 * @return
		 */
		public function enterFrame(useTime:uint):Boolean
		{
			var isOver:Boolean = false;
			if (isLive && action.skill.ed.isLive)
			{
				//现在的最大次数
				var allTimes:uint = (useTime - startTime) / action.skill.skill.loopTime;
				while (times < allTimes && times < action.skill.skill.loop)
				{
					times++;
					if (hitList)
					{
						hitList.length = 0;
					}
				}
				runHit();
				if (isLive == false || times >= action.skill.skill.loop)
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
				dispose();
			}
			return isOver;
		}
		
		/** 不停的检测,碰撞的点,只对人操作 **/
		private function runHit():void
		{
			//算碰撞
			var role:EDRole;
			var oSkill:OSkillEffect;
			var px:int;
			var py:int;
			var reportAdd:Boolean = false;
			var reportId:uint = 0;
			var a:AIRoleSkillAction = action;
			var s:AIRoleSkill = a.skill;
			for each (var campItem:EDCamp in s.ed.u.engine.campLib) 
			{
				if (isLive)
				{
					if (campItem.camp != s.ed.camp && campItem.lengthRole)
					{
						for each (role in campItem.listRole) 
						{
							if (isLive)
							{
								if (role.isLive && role.inHot && role.canHit && hitList.indexOf(role) == -1 && isHit(role, x1, x2) && isHitY(role, y1, y2))
								{
									hitList.push(role);
									px = role.x + role.hit_r_x;
									py = role.y + role.hit_r_y;
									if (role.hit_h)
									{
										px = role.hit_r / 2 + px;
										py = role.hit_h / 2 + py;
									}
									//将坐标转换到激光的周边
									if (px < x1)
									{
										px = x1;
									}
									else if (px > x2)
									{
										px = x2;
									}
									if (py < y1)
									{
										py = y1;
									}
									else if (py > y2)
									{
										py = y2;
									}
									//计算伤害等等
									if (reportAdd == false)
									{
										reportAdd = true;
										if (s.ed.u.reportStart)
										{
											s.ed.u.report.index++;
											reportId = s.ed.u.report.index;
										}
									}
									for each (oSkill in a.realTimeList) 
									{
										if (isLive && role.isLive)
										{
											if (oSkill.effect.effectTarget == 3)
											{
												if (role.u.readerStart && oSkill.effect.hitEffect && oSkill.effect.type == 0)
												{
													//找出攻击点,在攻击点燃烧
													if ((role.info.typeProperty == 4 && oSkill.effect.AttacksBases)
													|| (role.info.typeProperty == 1 && oSkill.effect.AttacksGround)
													|| (role.info.typeProperty == 2 && oSkill.effect.AttacksAir)
													|| (role.info.typeProperty == 3 && oSkill.effect.AttacksBuildings))
													{
														if (s.ed.u.modeTurn)
														{
															s.ed.u.reader.singleEffect(role.u.engine.time.timeEngine, "assets/effect/skill/" + oSkill.effect.hitEffect + ".u2", -px, -py, true);
														}
														else
														{
															s.ed.u.reader.singleEffect(role.u.engine.time.timeEngine, "assets/effect/skill/" + oSkill.effect.hitEffect + ".u2", px, py, true);
														}
													}
												}
												AIRoleSkillRelease.releaseSkill(reportId, s.ed.x, s.ed.y, s.ed.u, role, oSkill, null);
											}
										}
										else
										{
											return;
										}
									}
								}
							}
							else
							{
								return;
							}
						}
					}
				}
				else
				{
					return;
				}
			}
		}
		
		/** 计算是否在激光范围内 **/
		private function isHit(b:EDRole, x1:int, x2:int):Boolean
		{
			//左右的碰撞点
			var left:Number, right:Number;
			if (b.hit_h)
			{
				left = b.x + b.hit_r_x;
				right = left + b.hit_r;
			}
			else
			{
				left = b.x + b.hit_r_x - b.hit_r;
				right = b.x + b.hit_r_x + b.hit_r;
			}
			//在中间
			if (left < x1)//在左侧
			{
				if (right >= x1)//已经交际
				{
					return true;
				}
			}
			else if(right > x2)//在右侧
			{
				if (left <= x2)//已经交际
				{
					return true;
				}
			}
			else//在中间
			{
				return true;
			}
			return false;
		}
		
		private function isHitY(b:EDRole, y1:int, y2:int):Boolean
		{
			//上下的碰撞点
			var top:Number, end:Number;
			if (b.hit_h)
			{
				top = b.y + b.hit_r_y;
				end = top + b.hit_h;
			}
			else
			{
				top = b.y + b.hit_r_y - b.hit_r;
				end = b.y + b.hit_r_y + b.hit_r;
			}
			if (top < y1)//在上侧
			{
				if (end >= y1)//已经交际
				{
					return true;
				}
			}
			else if(end > y2)//在下侧
			{
				if (top <= y2)//已经交际
				{
					return true;
				}
			}
			else//在中间
			{
				return true;
			}
			return false;
		}
		
		/** 移除,清理,并回收 **/
		public function dispose():void
		{
			if(isLive)
			{
				isLive = false;
				if (hitList)
				{
					g.speedFact.d_vector(EDRole, hitList);
					hitList = null;
				}
				if(action) action = null;
				if (display)
				{
					display.dispose();
					display = null;
				}
			}
		}
	}
}