package cn.wjj.upgame.engine 
{
	import cn.wjj.g;
	import cn.wjj.display.MPoint;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.upgame.common.IOtherSkillRun;
	import cn.wjj.upgame.common.SkillTargetType;
	import cn.wjj.upgame.common.StatusTypeRole;
	import cn.wjj.upgame.data.SkillActiveModel;
	import cn.wjj.upgame.data.UpGameData;
	import cn.wjj.upgame.data.UpGameSkillAction;
	
	/**
	 * 每一个主动技能,就配合一个技能AI模块来驱动技能
	 * 
	 * @author GaGa
	 */
	public class AIRoleSkill 
	{
		/** 是否还在存活 **/
		public var isLive:Boolean = true;
		/** 技能的驱动对象 **/
		public var ed:EDRole;
		/** 是否为普通技能, 0 为普通技能 **/
		public var index:int = 0;
		/** 附带技能信息 **/
		public var info:ORoleSkill;
		/**
		 * 主动技能表
		 * 射程,目标类型,阵营作用效果,目标数量,预警提示,CD,CD初始值,狂点技属性,循环技属性
		 */
		public var skill:SkillActiveModel;
		/**
		 * 技能动作表
		 * 释放技能的开始坐标点,震屏,是否和一系列的序列帧动画关联起来
		 */
		public var action:UpGameSkillAction;
		/** 开始做第几个动作 **/
		public var actionIndex:uint = 0;
		/** 正在播放的动作 **/
		public var actionRun:AIRoleSkillAction;
		/** 最大可以播放第几个动作 **/
		public var actionLength:uint;
		/** 技能缓存的处理内容 **/
		public var actionList:Vector.<AIRoleSkillAction>;
		/** 技能是否已经准备好了 **/
		public var isReady:Boolean = false;
		
		/**
		 * 和技能效果和发出有关的内容
		 * 可以找到子弹相关内容
		 * 可以找到效果的相关内容
		 */
		//public var linkList:Vector.<UpGameSkill>;
		/** 技能释放已经用的时间 **/
		public var timeFire:Number = 0;
		/** 用新的时间来统计,现在技能已经使用的长度,当达到新的长度就释放技能 **/
		public var timeLength:int = 0;
		/** 技能目标类型,人物对象,还是坐标对象 **/
		public var targetType:uint = SkillTargetType.role;
		/** 攻击的目标列表 **/
		public var target:Vector.<EDRole>;
		public var targetPoint:Vector.<MPoint>;
		/** 技能CD,普通技能就是直接是攻速 **/
		public var cd:int;
		/** 特殊技能 **/
		public var otherSkill:IOtherSkillRun;
		/** 是否第一次释放,第一次释放,有些CD会变短 **/
		public var isStart:Boolean = true;
		
		/** 效果里包含子弹的效果,召唤的效果数量 **/
		internal var effCallLength:int = 0;
		/** 效果里包含子弹的全部效果 **/
		internal var effLength:int = 0;
		/** 是否只是有召唤的功能 **/
		internal var isOnlyCall:Boolean = false;
		
		/** 本技能是否对空 **/
		public var targetSky:Boolean = false;
		/** 本技能是否对地 **/
		public var targetGround:Boolean = false;
		/** 本技能是否对建筑 **/
		public var targetBuild:Boolean = false;
		/** 本技能是否对基地 **/
		public var targetBases:Boolean = false;
		
		/**
		 * 每一个主动技能,就配合一个技能AI模块来驱动技能
		 * 
		 * @param	ed
		 * @param	skill
		 * @param	index
		 * @param	info		实体化数据
		 */
		public function AIRoleSkill(ed:EDRole, ai:AIRole, skill:SkillActiveModel, index:int, info:ORoleSkill):void
		{
			target = g.speedFact.n_vector(EDRole);
			if (target == null)
			{
				target = new Vector.<EDRole>();
			}
			targetPoint = new Vector.<MPoint>();
			this.ed = ed;
			this.skill = skill;
			this.index = index;
			this.info = info;
			if (skill.AttacksAir)
			{
				targetSky = true;
				if (ai.targetSky == false)
				{
					ai.targetSky = true;
				}
			}
			if (skill.AttacksGround)
			{
				targetGround = true;
				if (ai.targetGround == false)
				{
					ai.targetGround = true;
				}
			}
			if (skill.AttacksBuildings)
			{
				targetBuild = true;
				if (ai.targetBuild == false)
				{
					ai.targetBuild = true;
				}
			}
			if (skill.AttacksBases)
			{
				targetBases = true;
				if (ai.targetBases == false)
				{
					ai.targetBases = true;
				}
			}
			if (index == 0)
			{
				cd = ed.info.atkTime;
				if (cd < 150)
				{
					cd = 150;
					g.log.pushLog(this, LogType._ErrorLog, "[策划]强制修正角色ID:" + ed.info.id + "普通技能ID:" + info.id +"攻速 : 150毫秒");
				}
			}
			else
			{
				cd = skill.cd - info.cd;
				if (cd < 500)
				{
					cd = 500;
					g.log.pushLog(this, LogType._ErrorLog, "[策划]强制修正角色ID:" + ed.info.id + "普通技能ID:" + info.id +"攻速 : 500毫秒");
				}
			}
			if (isStart)
			{
				isStart = false;
				timeLength = info.cdStart + skill.cdStart;
			}
			if (timeLength > cd) timeLength = cd;
			if (timeLength >= cd) isReady = true;
			//找到动作表
			action = UpGameData.skillAction.getItem("id", skill.actionId);
			actionLength = 0;
			if (action)
			{
				if (action.time1skill)
				{
					actionLength = 1;
					if (actionList == null)
					{
						actionList = new Vector.<AIRoleSkillAction>();
					}
					actionList.push(new AIRoleSkillAction(this, 0));
				}
				if (action.time2skill)
				{
					actionLength = 2;
					actionList.push(new AIRoleSkillAction(this, 1));
				}
				if (action.time3skill)
				{
					actionLength = 3;
					actionList.push(new AIRoleSkillAction(this, 2));
				}
				if (action.time4skill)
				{
					actionLength = 4;
					actionList.push(new AIRoleSkillAction(this, 3));
				}
				if (action.time5skill)
				{
					actionLength = 5;
					actionList.push(new AIRoleSkillAction(this, 4));
				}
			}
			if (effCallLength > 0 && effLength == effCallLength)
			{
				isOnlyCall = true;
			}
			if (skill.startUp && skill.specialType == 0)
			{
				//自动释放本技能的效果,并且就一次完成
				for each (actionRun in actionList) 
				{
					//重新处理目标
					if(actionIndex != 0 && skill.goalUseType == 1)
					{
						SearchTargetRole.searchSkillTarget(ed, this);
					}
					actionIndex++;
					if (actionRun.skillId)
					{
						AIRoleSkillRelease.releaseMini(ed.x, ed.y, actionRun);
					}
					//技能释放完毕
					if (actionIndex >= actionLength)
					{
						break;
					}
				}
			}
		}
		
		/** 人物复活技能时间重新初始化 **/
		internal function reStart():void
		{
			if (index == 0)
			{
				cd = ed.info.atkTime;
				if (cd < 150)
				{
					cd = 150;
					g.log.pushLog(this, LogType._ErrorLog, "[策划]强制修正角色ID:" + ed.info.id + "普通技能ID:" + info.id +"攻速 : 150毫秒");
				}
			}
			else
			{
				cd = skill.cd - info.cd;
				if (cd < 500)
				{
					cd = 500;
					g.log.pushLog(this, LogType._ErrorLog, "[策划]强制修正角色ID:" + ed.info.id + "普通技能ID:" + info.id +"攻速 : 500毫秒");
				}
			}
			timeLength = info.cdStart + skill.cdStart;
			if (timeLength > cd) timeLength = cd;
			if (timeLength >= cd)
			{
				isReady = true;
			}
		}
		
		/** 创建属性(基础属性变化的时候也要重新创建这些属性) **/
		internal function createOEffect():void
		{
			if (actionLength)
			{
				for each (var item:AIRoleSkillAction in actionList) 
				{
					item.createOEffect();
				}
			}
		}
		
		/** 游戏每帧运行的时候添加时间 **/
		internal function addTime():void
		{
			if (isReady == false)
			{
				timeLength += ed.u.engine.time.timeFrame * ed.info.skillScale;
				if (timeLength >= cd)
				{
					isReady = true;
				}
			}
		}
		
		/** 调整技能CD,额外累加,正值减少,负值增加 **/
		internal function changeCD(addVer:int):void
		{
			if (isReady == false)
			{
				timeLength += addVer;
				if (timeLength >= cd)
				{
					isReady = true;
				}
			}
		}
		
		/**
		 * 开始释放技能
		 * 由于开火时间可能是走路中途OVER开始的
		 * @param	prevTime	开火的时间
		 */
		internal function fire():void
		{
			if (isReady && isLive)
			{
				if (ed.activate == false)
				{
					ed.activate = true;
				}
				isReady = false;
				timeLength = 0;
				timeFire = -ed.u.engine.time.timeFrame * ed.info.skillScale;
				ed.ai.skillFire = this;
				ed.displayChangeTime = true;
				ed.displayStartTime = ed.u.engine.time.timeGame;
				if (ed.ai.oldSkill) ed.ai.oldSkill = null;
				actionIndex = 0;
				//这里数据结构变了--------------------未完成
				switch (this.index) 
				{
					case 0:
						ed.status = StatusTypeRole.attack;
						break;
					case 1:
						ed.status = StatusTypeRole.skill1;
						break;
					case 2:
						ed.status = StatusTypeRole.skill2;
						break;
					case 3:
						ed.status = StatusTypeRole.skill3;
						break;
					case 4:
						ed.status = StatusTypeRole.skill4;
						break;
					default:
						ed.status = StatusTypeRole.attack;
				}
				//这里数据结构变了--------------------未完成
				changeAngle();
				skillRun();
				if (isLive && ed.camp == 1 && skill.bigEffect != 0 && ed.u.readerStart)
				{
					ed.u.reader.bigEffect.show(ed, skill);
				}
			}
		}
		
		/**
		 * 修改方向依靠人物的转向,出子弹的方向靠后期的计算
		 * @param	timeFire
		 */
		private function changeAngle():void
		{
			if (isLive)
			{
				//设置方向
				var a:Number = ed.angle;
				var px:Number, py:Number;
				switch (targetType) 
				{
					case SkillTargetType.role:
						var t:EDRole = target[0];
						if (t != ed)
						{
							px = ed.x + ed.hit_r_x;
							py = ed.y + ed.hit_r_y;
							if (ed.hit_h)
							{
								px = ed.hit_r / 2 + px;
								py = ed.hit_h / 2 + py;
							}
							px = px - t.x - t.hit_r_x;
							py = py - t.y - t.hit_r_y;
							if (t.hit_h)
							{
								px = -t.hit_r / 2 + px;
								py = -t.hit_h / 2 + py;
							}
							if (px != 0 || py != 0)
							{
								//Math.atan2(py, px) * 180 / Math.PI + 180
								a = (Math.atan2(py, px) + Math.PI) * 180 / Math.PI;
							}
						}
						break;
					case SkillTargetType.point:
						var p:MPoint = targetPoint[0];
						px = ed.x + ed.hit_r_x;
						py = ed.y + ed.hit_r_y;
						if (ed.hit_h)
						{
							px = ed.hit_r / 2 + px;
							py = ed.hit_h / 2 + py;
						}
						px = px - p.x;
						py = py - p.y;
						if (px != 0 || py != 0)
						{
							a = (Math.atan2(py, px) + Math.PI) * 180 / Math.PI;
						}
						break;
					/*
					case SkillTargetType.direction:
						a = ed.angle;
						break;
					*/
				}
				a = a % 360;
				if (a < 0) a += 360;
				if (timeFire < 0 || ed.angle != a)
				{
					ed.angle = a;
					EDRoleToolsSkin.changeSkin(ed, ed.u.modeTurn);
				}
			}
		}
		
		/** 帮助完成释放的动作,技能效果可能产生EDSkill出去 **/
		public function skillRun():void
		{
			if (isLive)
			{
				if (action)
				{
					timeFire += ed.u.engine.time.timeFrame * ed.info.skillScale;
					var isRunOver:Boolean = false;
					switch (skill.specialType) 
					{
						case 0:
							isRunOver = skillRunType0(uint(timeFire));
							break;
						case 1://冲锋
							if (otherSkill == null)
							{
								changeAngle();
								otherSkill = new AIRoleSkillTypeAssault();
								isRunOver = otherSkill.start(this, uint(timeFire));
							}
							else
							{
								isRunOver = otherSkill.enterFrame(uint(timeFire));
							}
							break;
						case 2://垂直激光
							if (otherSkill == null)
							{
								otherSkill = new AIRoleSkillTypeLaser();
								isRunOver = otherSkill.start(this, uint(timeFire));
							}
							else
							{
								isRunOver = otherSkill.enterFrame(uint(timeFire));
							}
							break;
						//case 3://旋风斩
						//	break;
						case 4://横向激光
							if (otherSkill == null)
							{
								otherSkill = new AIRoleSkillTypeLaser();
								(otherSkill as Object).vertical = false;
								isRunOver = otherSkill.start(this, uint(timeFire));
							}
							else
							{
								isRunOver = otherSkill.enterFrame(uint(timeFire));
							}
							break;
						case 5://定点冲锋, 击退
							if (otherSkill == null)
							{
								changeAngle();
								otherSkill = new AIRoleSkillTypeAssaultPoint();
								isRunOver = otherSkill.start(this, uint(timeFire));
							}
							else
							{
								isRunOver = otherSkill.enterFrame(uint(timeFire));
							}
							break;
						default:
							isRunOver = skillRunType0(uint(timeFire));
					}
					if (isRunOver)
					{
						//技能已经释放完毕,CD控制下一次攻击,所以不管CD
						if (otherSkill)
						{
							otherSkill.dispose();
							otherSkill = null;
						}
						actionRun = null;
						actionIndex = 0;
						if (isLive && ed.isLive)
						{
							if (ed.ai.skillFire)
							{
								ed.ai.skillStop();
							}
							if (ed.u.readerStart)
							{
								ed.ai.oldSkill = this;
							}
						}
					}
				}
				else
				{
					if (ed.ai.skillFire)
					{
						ed.ai.skillStop();
					}
					ed.status = StatusTypeRole.idle;
					EDRoleToolsSkin.changeSkin(ed, ed.u.modeTurn);
					g.log.pushLog(this, LogType._ErrorLog, "[策划]主动技能动作表无数据");
				}
			}
		}
		
		/** 普通技能的执行, true:技能播放完成, false:技能未完成 **/
		private function skillRunType0(useTime:uint):Boolean
		{
			var canDo:Boolean = true;
			var dist:Number;
			while (canDo)
			{
				canDo = false;
				if (actionLength > actionIndex)
				{
					actionRun = actionList[actionIndex];
					if (actionRun.time <= useTime)
					{
						//重新处理目标
						if (index == 0)
						{
							//这里直接判断发射点,而不是判断碰撞点,只有当目标发生改变,才需要重新算角度
							if (ed.ai.hatred.maxED && ed.ai.hatred.maxED.isLive)
							{
								if (this.actionRun.point == 1)
								{
									dist = SearchTargetRole.pointHitRangeCount(ed.x + ed.hitX1, ed.y + ed.hitY1, ed.ai.hatred.maxED);
								}
								else
								{
									dist = SearchTargetRole.pointHitRangeCount(ed.x + ed.hitX2, ed.y + ed.hitY2, ed.ai.hatred.maxED);
								}
								if (dist > this.skill.range)
								{
									//重新找目标
									if (SearchTargetRole.searchNormalTarget(ed, this) == false)
									{
										//普通技能无目标就释放完毕
										return true;
									}
									changeAngle();
								}
							}
							else
							{
								if (SearchTargetRole.searchNormalTarget(ed, this) == false)
								{
									//普通技能无目标就释放完毕
									return true;
								}
								//重新瞄准目标
								changeAngle();
							}
						}
						else if(actionIndex != 0 && skill.goalUseType == 1)
						{
							SearchTargetRole.searchSkillTarget(ed, this);
						}
						canDo = true;
						actionIndex++;
						if (ed.u.readerStart && actionRun.shakeLength > 0 && actionRun.shakeType != 0 && (actionRun.shakeX != 0 || actionRun.shakeY != 0))
						{
							ed.u.reader.shake.push(actionRun.shakeType, actionRun.shakeX, actionRun.shakeY, actionRun.shakeTime, actionRun.shakeLength);
						}
						if (actionRun.skillId)
						{
							AIRoleSkillRelease.release(ed.x, ed.y, actionRun);
						}
						//技能释放完毕
						if (actionIndex >= actionLength)
						{
							return true;
						}
					}
				}
				else
				{
					return true;
				}
			}
			return false;
		}
		
		/** 摧毁对象 **/
		public function dispose():void
		{
			if (isLive)
			{
				isLive = false;
				if (target)
				{
					g.speedFact.d_vector(EDRole, target);
					target = null;
				}
				ed = null;
				skill = null;
				action = null;
				info = null;
				/*
				if (targetSky) targetSky = false;
				if (targetGround) targetGround = false;
				if (targetBuild) targetBuild = false;
				*/
				if (actionLength)
				{
					if (actionList)
					{
						for each (actionRun in actionList) 
						{
							actionRun.dispose();
						}
						actionList.length = 0;
						actionList = null;
					}
					actionLength = 0;
				}
				actionRun = null;
				if (otherSkill)
				{
					otherSkill.dispose();
					otherSkill = null;
				}
			}
		}
	}
}