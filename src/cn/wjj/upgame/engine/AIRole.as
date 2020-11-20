package cn.wjj.upgame.engine 
{
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.gagaframe.client.speedfact.SpeedLib;
	import cn.wjj.upgame.common.SkillTargetType;
	import cn.wjj.upgame.common.StatusEngineType;
	import cn.wjj.upgame.common.StatusTypeRole;
	import cn.wjj.upgame.data.SkillActiveModel;
	import cn.wjj.upgame.tools.LineInRect;
	import cn.wjj.upgame.tools.MovePhysPatrol;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 这个是所有的角色最基础的原型
	 * 解决一下问题
	 * 1.怪物什么时候出来,怎么出来
	 * 2.怪物基本的思考方式
	 * 
	 * 
	 * 玩家角色的基础AI
	 * 
	 * 激活
	 * 1、视野：ai角色会锁定视野内的敌对角色，如果没有敌对角色进入视野，则不会做出任何行动；
	 * 2、互助：一个怪物的敏感范围内有友方角色受到攻击时，会立刻激活ai进行目标选择；
	 * 
	 * @author GaGa
	 */
	public class AIRole
	{
		/** 对象池 **/
		private static var __f:SpeedLib = new SpeedLib(200);
		/** 对象池强引用的最大数量 **/
		public static function get __m():uint {return __f.length;}
		/** 对象池强引用的最大数量 **/
		public static function set __m(value:uint):void { __f.length = value; }
		
		/** 初始化 **/
		public static function instance():AIRole
		{
			var o:AIRole = __f.instance() as AIRole;
			if (o)
			{
				return o;
			}
			return new AIRole();
		}
		
		/** 移除,清理,并回收 **/
		public function dispose():void
		{
			if (targetSky) targetSky = false;
			if (targetGround) targetGround = false;
			if (targetBuild) targetBuild = false;
			if (targetBases) targetBases = false;
			if (this.aiSkill.length)
			{
				for each (var skill:AIRoleSkill in this.aiSkill) 
				{
					if (skill)
					{
						skill.dispose();
					}
				}
				this.aiSkill.length = 0;
			}
			this.hatred.clear();
			this.move.clear();
			this.buff.clear();
			this.collision.clear();
			if (this.ed) this.ed = null;
			if (this.targetList.length)
			{
				this.targetList.length = 0;
			}
			if(this.lockTarget) this.lockTarget = null;
			if (this.skillFire)
			{
				this.skillStop();
			}
			if(this.oldSkill) this.oldSkill = null;
			if(this.shortSkill) this.shortSkill = null;
			__f.recover(this);
			if (timeChangeHide != -1) timeChangeHide = -1;
			if (timeChangeInit != -1) timeChangeInit = -1;
			if (timeNextRevive != 0) timeNextRevive = 0;
		}
		
		/** 转换过的AI对象层 **/
		public var ed:EDRole;
		/** 出场的开始时间点 **/
		public var appearStartTime:int;
		/** 普通攻击目标 **/
		public var lockTarget:EDRole;
		/** 技能攻击目标 **/
		public var targetList:Vector.<EDRole> = new Vector.<EDRole>();
		/** 技能的AI部分 **/
		public var aiSkill:Vector.<AIRoleSkill> = new Vector.<AIRoleSkill>();
		/** 仇恨列表 **/
		public var hatred:AIRoleHatred = new AIRoleHatred();
		/** 移动控制对象 **/
		public var move:AIRoleMove = new AIRoleMove();
		/** Buff控制 **/
		public var buff:AIRoleBuff = new AIRoleBuff();
		/** 击退控制器,控制击退过程中的移动 **/
		public var collision:AIRoleCollision = new AIRoleCollision();
		/** 是否有技能正在释放 **/
		public var skillFire:AIRoleSkill;
		/** 是否有技能正在释放 **/
		public var oldSkill:AIRoleSkill;
		/** 最短会播放的技能 **/
		private var shortSkill:AIRoleSkill;
		/** 人物是否对空 **/
		public var targetSky:Boolean = false;
		/** 人物是否对地 **/
		public var targetGround:Boolean = false;
		/** 人物是否对建筑 **/
		public var targetBuild:Boolean = false;
		/** 人物是否对基地 **/
		public var targetBases:Boolean = false;
		
		/** (毫秒)从天而将的时间,上一次改变所在值 **/
		internal var timeChangeHide:int = -1;
		/** (毫秒)启动时间,就是可以攻击别人的时间,上一次改变所在值 **/
		internal var timeChangeInit:int = -1;
		/** (毫秒)下一次增加血的时间 **/
		internal var timeNextRevive:uint = 0;
		
		public function AIRole() { }
		
		public function setThis(ed:EDRole):void
		{
			this.ed = ed;
			hatred.setThis(ed);
			move.setThis(ed);
			collision.ed = ed;
			buff.ed = ed;
			buff.isLive = true;
			//初始化技能
			var index:int = 0;
			for each (var item:SkillActiveModel in ed.skillList) 
			{
				if (item)
				{
					if (ed.info.skillInfo && index < ed.info.skillInfo.length && ed.info.skillInfo[index])
					{
						aiSkill.push(new AIRoleSkill(ed, this, item, index, ed.info.skillInfo[index]));
					}
					else
					{
						aiSkill.push(null);
						g.log.pushLog(this, LogType._ErrorLog, "ED对象:" + ed.info.serverId + " 缺少实体化技能数据 : " + index);
					}
				}
				else
				{
					aiSkill.push(null);
				}
				index++;
			}
			if (ed.activate == false) ed.activate = true;
			if (ed.inHot == false) ed.inHot = true;
			startAppear();
		}
		
		/** 强制启动出场动画 **/
		public function startAppear():void
		{
			if (timeNextRevive) timeNextRevive = 0;
			if (ed.info.hero && ed.info.hp < ed.info.hpMax)
			{
				//自动加血
				if (ed.camp == 1)
				{
					if (ed.x > 1000000 && ed.y > 1000000)
					{
						timeNextRevive = ed.u.engine.time.timeGame + 1000;
					}
				}
				else
				{
					if (ed.x < -1000000 && ed.y < -1000000)
					{
						timeNextRevive = ed.u.engine.time.timeGame + 1000;
					}
				}
			}
			ed.displayStartTime = ed.u.engine.time.timeGame;
			ed.displayChangeTime = true;
			if (ed.sleep == false)
			{
				if (ed.model.typeAppear != 0 && ed.model.appearTime != 0)
				{
					if (ed.camp == 1)
					{
						if (ed.angle != 270) ed.angle = 270;
					}
					else
					{
						if (ed.angle != 90) ed.angle = 90;
					}
					ed.lock = true;
					ed.status = StatusTypeRole.appear;
					if (ed.info.actionStart)
					{
						appearStartTime = -1;
						if (ed.displayScale != 0) ed.displayScale = 0;
					}
					else
					{
						appearStartTime = ed.u.engine.time.timeGame;
						if (ed.displayScale != 1) ed.displayScale = 1;
						if (ed.u.readerStart && ed.model.appearShakeLength > 0 && ed.model.appearShakeType > 0)
						{
							ed.u.reader.shake.pushType(ed.model.appearShakeType, ed.model.appearShakeStart, ed.model.appearShakeLength);
						}
					}
					EDRoleToolsSkin.changeSkin(ed, ed.u.modeTurn);
				}
				else
				{
					if (ed.canHit == false) ed.canHit = true;
					ed.changeStatus(StatusTypeRole.idle);
				}
				if (ed.info.timeInit)
				{
					timeChangeInit = ed.u.engine.time.timeGame + ed.info.timeInit;
				}
				else
				{
					timeChangeInit = 0;
				}
			}
			else if (ed.status != StatusTypeRole.appear)
			{
				if (ed.canHit == false) ed.canHit = true;
				ed.status = StatusTypeRole.appear;
				if (ed.displayScale != 0) ed.displayScale = 0;
				EDRoleToolsSkin.changeSkin(ed, ed.u.modeTurn);
			}
		}
		
		/** 刷新人物的全部属性值 **/
		public function createOEffect():void
		{
			if (aiSkill && aiSkill.length)
			{
				for each (var skill:AIRoleSkill in aiSkill) 
				{
					if (skill)
					{
						skill.createOEffect();
					}
				}
			}
		}
		
		/** 普通技能锁定目标 **/
		public function changeTarget(target:EDRole):void
		{
			if (target && target.isLive)
			{
				//先改方向
				var px:Number = ed.x + ed.hit_r_x;
				var py:Number = ed.y + ed.hit_r_y;
				if (ed.hit_h)
				{
					px = ed.hit_r / 2 + px;
					py = ed.hit_h / 2 + py;
				}
				px = px - target.x - target.hit_r_x;
				py = py - target.y - target.hit_r_y;
				if (target.hit_h)
				{
					px = -target.hit_r / 2 + px;
					py = -target.hit_h / 2 + py;
				}
				if (px != 0 || py != 0)
				{
					ed.angle = (Math.atan2(py, px) + Math.PI) * 180 / Math.PI;
				}
				if(skillFire && skillFire.target.indexOf(target) == -1)
				{
					skillStop();
					oldSkill = null;
					ed.status = StatusTypeRole.idle;
				}
				EDRoleToolsSkin.changeSkin(ed, ed.u.modeTurn);
				hatred.changeTarget(target);
			}
		}
		
		/**
		 * 没有创建,就创建一个先
		 * 如果在发呆
		 * 发呆就看视野范围内有无目标
		 * 没有找到目标就继续发呆
		 * 有目标就看射程
		 * 射程不够就移动过去
		 * 
		 * 移动中的就查看仇恨和看是否需要继续发飙
		 * 
		 * 激活怪物
		 * 看一些技能的CD是否已经OK了
		 * OK了就放掉
		 * 处于start, live模式的情况下运行
		 */
		public function aiRun():void
		{
			if (ed.sleep) return;
			if (ed.info.hp < ed.info.hpMax && timeNextRevive && ed.u.engine.time.timeGame >= timeNextRevive)
			{
				//自动加血
				if (ed.camp == 1)
				{
					if (ed.x > 1000000 && ed.y > 1000000)
					{
						timeNextRevive = ed.u.engine.time.timeGame + 1000;
						ed.info.hp += int(ed.info.hpMax * ed.info.heroInfo.selfHealing);
						if (ed.info.hp > ed.info.hpMax)
						{
							ed.info.hp = ed.info.hpMax;
							ed.hpScale = 10000;
						}
						else
						{
							ed.hpScale = int(ed.info.hp / ed.info.hpMax * 10000);
						}
					}
				}
				else
				{
					if (ed.x < -1000000 && ed.y < -1000000)
					{
						timeNextRevive = ed.u.engine.time.timeGame + 1000;
						ed.info.hp += int(ed.info.hpMax * ed.info.heroInfo.selfHealing);
						if (ed.info.hp > ed.info.hpMax)
						{
							ed.info.hp = ed.info.hpMax;
							ed.hpScale = 10000;
						}
						else
						{
							ed.hpScale = int(ed.info.hp / ed.info.hpMax * 10000);
						}
					}
				}
			}
			if (ed.status == StatusTypeRole.appear && appearStartTime != -1)
			{
				if ((ed.u.engine.time.timeGame - appearStartTime) > ed.model.appearTime)
				{
					if (ed.canHit == false) ed.canHit = true;
					if (ed.lock) ed.lock = false;
					appearStartTime = -1;
					ed.changeStatus(StatusTypeRole.idle);
				}
				else
				{
					return;
				}
			}
			if (timeChangeInit)
			{
				if (timeChangeInit <= ed.u.engine.time.timeGame)
				{
					timeChangeInit = 0;
					ed.changeStatus(StatusTypeRole.idle);
				}
				//单独处理下buff
				buff.runBuff();
				return;
			}
			else if (ed.status == StatusTypeRole.appear)
			{
				return;
			}
			//先处理Buff
			if (ed.dieAuto && ed.u.engine.type == StatusEngineType.start)
			{
				ed.timeDie = ed.timeDie - ed.u.engine.time.timeFrame;
				if (ed.timeDie <= 0)
				{
					ed.u.report.removeMonster(ed.info.serverId, ed.camp, ed.info.idx, ed.info.isCall, ed.x, ed.y, ed, ed.info.serverId);
					ed.dispose();
					return;
				}
			}
			buff.runBuff();
			//研究下是否被BUFF弄死了
			if (ed && ed.isLive)
			{
				var u:UpGame = ed.u;
				//给技能加CD
				if (u.engine.type == StatusEngineType.start)
				{
					for each (var skill:AIRoleSkill in aiSkill) 
					{
						if (skill)
						{
							skill.addTime();
						}
					}
				}
				//被冰冻掉
				if (ed._aiStop)
				{
					if (ed.status == StatusTypeRole.collision)
					{
						collision.runFrame();
					}
					if (ed.aiStopTime == 0) ed.aiStopTime = u.engine.time.timeGame;
				}
				//被晕掉了
				else if (ed._aiStun)
				{
					if (ed.status == StatusTypeRole.collision)
					{
						collision.runFrame();
					}
				}
				else
				{
					//时间最短的技能释放, 如果是-1标识现在还在移动中,不用找最短技能
					switch (ed.status) 
					{
						case StatusTypeRole.move:
							if (move.moveFrame() && ed.lock)
							{
								return;
							}
							break;
						case StatusTypeRole.patrol:
							move.moveFrame();
							break;
						case StatusTypeRole.collision:
							if (collision.runFrame() == false)
							{
								return;
							}
							break;
					}
					if (u.engine.type == StatusEngineType.start)
					{
						if (ed.inHot == false && u.engine.astar.isPass(ed.x, ed.y))
						{
							ed.inHot = true;
						}
						//仇恨值递减
						if (ed.activate) hatred.lostRun();
						//没有被激活,先激活目标,不断查找周边的目标
						AIRoleActivate.itLook(ed);
						//释放的技能
						if (ed.activate)
						{
							//激活播放出场动画的类型,现在执行出场动画的播放
							if(ed.info.actionStart && ed.status == StatusTypeRole.appear && appearStartTime == -1)
							{
								if (ed.model.typeAppear == 0 && ed.model.appearTime == 0)
								{
									ed.lock = false;
									appearStartTime = -1;
									ed.changeStatus(StatusTypeRole.idle);
								}
								else
								{
									appearStartTime = u.engine.time.timeGame;
									ed.displayStartTime = ed.u.engine.time.timeGame;
									ed.displayChangeTime = true;
									if (u.readerStart && ed.model.appearShakeLength > 0 && ed.model.appearShakeType > 0)
									{
										u.reader.shake.pushType(ed.model.appearShakeType, ed.model.appearShakeStart, ed.model.appearShakeLength);
									}
									return;
								}
							}
							//未进入可移动区域的内容
							if (u.modeMovePhys)
							{
								if (ed.inHot == false)
								{
									ed.inHot = true;
								}
							}
							else
							{
								//先移动到可操作区域
								if (ed.inHot == false)
								{
									move.moveBlank();
									if(ed.inHot == false)
									{
										return;
									}
								}
							}
							//继续技能运行
							if (skillFire) skillFire.skillRun();
							if (shortSkill) shortSkill = null;
							if (skillFire == null)
							{
								//查看是否有可以释放的技能
								//先查看CD是否OK
								var index:int = aiSkill.length;
								var item:AIRoleSkill;
								//找到CD最先好的技能,然后走过去
								while (--index > -1)
								{
									item = aiSkill[index];
									if (item)
									{
										if (fireSkill(item))
										{
											return;
										}
										else if (item.index == 0 && ed.status != StatusTypeRole.move && ed.info.speed > 0)
										{
											shortSkill = item;
										}
									}
								}
								//移动到可自动释放的最短技能处
								if (shortSkill && hatred.length)
								{
									var dist:Number = SearchTargetRole.getDistance(ed, hatred.maxED);
									if (int(dist - shortSkill.skill.range) > 1)
									{
										//不能跳跃,并且是地面目标
										if (u.modeMovePhys && ed.info.typeProperty == 1 && ed.info.canJump == false && ed.info.autoPatrol)
										{
											//查看中间是否有障碍物,如果连线有,就不去攻击这个目标
											if (LineInRect.pointLine(u.engine.astar, ed.x, ed.y, hatred.maxED, shortSkill.skill.range))
											{
												hatred.removeAll();
											}
											else
											{
												//二个人要在桥的二头,射程要超过桥那头,攻击者要是陆地角色
												if (MovePhysPatrol.notMoveToTarget(u.engine.astar, ed, hatred.maxED, shortSkill.skill.range, dist))
												{
													hatred.removeAll();
												}
												else
												{
													this.move.moveTarget(hatred.maxED, shortSkill.skill.range, false);
												}
											}
										}
										else
										{
											this.move.moveTarget(hatred.maxED, shortSkill.skill.range, false);
										}
										if(ed.status == StatusTypeRole.move)
										{
											return;
										}
									}
								}
							}
							//将释放动作播放完毕
							if (oldSkill)
							{
								if (oldSkill.action.playTime == 0)
								{
									ed.changeStatus(StatusTypeRole.idle);
									oldSkill = null;
								}
								else
								{
									oldSkill.timeFire += u.engine.time.timeFrame * ed.info.skillScale;
									//这里也要控制停止
									if (oldSkill.timeFire >= oldSkill.action.playTime)
									{
										ed.changeStatus(StatusTypeRole.idle);
										oldSkill = null;
									}
								}
							}
							//没有释放技能,没有目标,就自动巡逻
							if (ed == null) return;
							if (ed.info.autoPatrol && ed.info.speed > 0)
							{
								if (ed.status == StatusTypeRole.idle && hatred.maxED == null)
								{
									move.patrol();
								}
								else
								{
									move.enginePhys.moveNeed(u);
								}
							}
						}
						else if (ed.info.autoPatrol && ed.info.speed > 0)
						{
							if (ed.status == StatusTypeRole.idle && hatred.maxED == null)
							{
								move.patrol();
							}
							else
							{
								move.enginePhys.moveNeed(u);
							}
						}
					}
				}
			}
		}
		
		/** 查看是否有打到人 **/
		public function aiTarget():void { }
		
		/**
		 * 强制播放技能
		 * 0 : 技能释放完毕
		 * 1 : 角色未出场
		 * 2 : 正在播放技能不允许中断
		 * 3 : 游戏状态不允许释放技能
		 * 4 : 人物眩晕或被冰冻
		 * 5 : 未找到技能
		 * 6 : 技能CD中
		 * 7 : 原因不明的释放失败(可能是未找到目标)
		 * 8 : 正在被击退
		 * 9 : 人物眩晕
		 * 10: 召唤名额使用完毕
		 * @param	index
		 * @param	isManual	是否使用了手动释放
		 * @return
		 */
		public function fireIndex(index:int, isManual:Boolean = false):int
		{
			var i:int = canFireIndex(index, isManual);
			if (i == 0)
			{
				var item:AIRoleSkill = aiSkill[index];
				if (item && fireSkill(item, isManual))
				{
					return 0
				}
			}
			return i;
		}
		
		/**
		 * 是否可以释放某一个技能
		 * 0 : 技能释放完毕
		 * 1 : 角色未出场
		 * 2 : 正在播放技能不允许中断
		 * 3 : 游戏状态不允许释放技能
		 * 4 : 人物冰冻
		 * 5 : 未找到技能
		 * 6 : 技能CD中
		 * 7 : 原因不明的释放失败(可能是未找到目标)
		 * 8 : 正在被击退
		 * 9 : 人物眩晕
		 * 10: 召唤名额使用完毕
		 * 11: 同时召唤在场景上的怪物数量限制
		 * 12: 启动技能,在启动的时候已经释放一次,无法在次释放
		 * 13: 站在区域外不能释放
		 * @param	index
		 * @param	isManual	是否使用了手动释放
		 * @return
		 */
		public function canFireIndex(index:int, isManual:Boolean = false):int
		{
			if (ed.status == StatusTypeRole.appear)
			{
				return 1;
			}
			else if (skillFire && skillFire.action && skillFire.action.lockPlay)
			{
				return 2;
			}
			else if (ed.u.engine.type != StatusEngineType.start)
			{
				return 3;
			}
			else if (ed._aiStop)
			{
				return 4;
			}
			else if (ed._aiStun)
			{
				return 9;
			}
			else if (index < 0 || index >= aiSkill.length || aiSkill[index] == null)
			{
				return 5;
			}
			else if (ed.status == StatusTypeRole.collision)
			{
				return 8;
			}
			else if (aiSkill[index].skill.startUp)
			{
				return 12;
			}
			else if (ed.info.maxCall != 0 && aiSkill[index].isOnlyCall && ed.callLength >= ed.info.maxCall)
			{
				return 10;
			}
			else if (ed.camp == 2 && ed.u.engine.camp2.callMax && aiSkill[index].isOnlyCall && ed.u.engine.camp2.callLength >= ed.u.engine.camp2.callMax)
			{
				return 11;
			}
			else if (ed.x > 1000000 || ed.y > 1000000 || ed.x < -1000000 || ed.y < -1000000)
			{
				return 13;
			}
			else
			{
				var item:AIRoleSkill = aiSkill[index];
				if (item.isReady)
				{
					if (item.index == 0)//普通技能
					{
						if (SearchTargetRole.searchNormalTarget(ed, item))
						{
							if (item.targetType == SkillTargetType.point)
							{
								if (item.targetPoint.length)
								{
									//有目标可以释放
									return 0;
								}
							}
							else if (item.target.length)
							{
								//有目标可以释放
								return 0;
							}
						}
					}
					else//其他技能
					{
						var canDo:Boolean = false;
						if (isManual)
						{
							canDo = true;
						}
						else
						{
							if (ed.info.hero)
							{
								if (item.index == 1 || item.index == 4)
								{
									canDo = false;
								}
								else
								{
									canDo = true;
								}
							}
							else if (ed.info.isAuto || (item.index != 1 && item.index != 2))
							{
								canDo = true;
							}
						}
						if (canDo)
						{
							SearchTargetRole.searchSkillTarget(ed, item);
							if (item.targetType == SkillTargetType.direction)
							{
								//有目标可以释放
								return 0;
							}
							else if (item.targetType == SkillTargetType.point)
							{
								if (item.targetPoint.length)
								{
									//有目标可以释放
									return 0;
								}
							}
							else
							{
								if (item.target.length)
								{
									//有目标可以释放
									return 0;
								}
							}
						}
					}
				}
				else
				{
					return 6;
				}
			}
			return 7;
		}
		
		/**
		 * [禁止随便调用]释放某一项技能
		 * @param	item		释放的技能
		 * @param	isManual	是否使用了手动释放
		 * @return
		 */
		public function fireSkill(item:AIRoleSkill, isManual:Boolean = false):Boolean
		{
			if (item.isReady && item.skill.startUp == false
			&& (ed.info.maxCall == 0 || item.isOnlyCall == false || ed.callLength < ed.info.maxCall)
			&& (ed.camp != 2 || item.isOnlyCall == false || ed.u.engine.camp2.callMax == 0 || ed.u.engine.camp2.callLength < ed.u.engine.camp2.callMax)
			&& (ed.x < 1000000 && ed.y < 1000000 && ed.x > -1000000 && ed.y > -1000000))
			{
				if (item.index == 0)//普通技能
				{
					if (SearchTargetRole.searchNormalTarget(ed, item))
					{
						if (item.targetType == SkillTargetType.point)
						{
							if (item.targetPoint.length)
							{
								item.fire();
								return true;
							}
						}
						else if (item.target.length)
						{
							if (item.target.indexOf(hatred.maxED) != -1)
							{
								hatred.hitMax = true;
							}
							item.fire();
							return true;
						}
					}
				}
				else
				{
					var canDo:Boolean = false;
					if (isManual)
					{
						canDo = true;
					}
					else
					{
						if (ed.info.hero)
						{
							if (item.index == 1 || item.index == 4)
							{
								canDo = false;
							}
							else
							{
								canDo = true;
							}
						}
						else if (ed.info.isAuto || (item.index != 1 && item.index != 2))
						{
							canDo = true;
						}
					}
					if (canDo)
					{
						SearchTargetRole.searchSkillTarget(ed, item);
						if (item.targetType == SkillTargetType.direction)
						{
							item.fire();
							return true;
						}
						else if (item.targetType == SkillTargetType.point)
						{
							if (item.targetPoint.length)
							{
								item.fire();
								return true;
							}
						}
						else
						{
							if (item.target.length)
							{
								if (item.target.indexOf(hatred.maxED) != -1)
								{
									hatred.hitMax = true;
								}
								item.fire();
								return true;
							}
						}
					}
				}
			}
			return false;
		}
		
		/** 如果现在有释放的技能,就停止下来 **/
		public function skillStop():void
		{
			if (skillFire)
			{
				if (skillFire.otherSkill)
				{
					skillFire.otherSkill.dispose();
					skillFire.otherSkill = null;
				}
				skillFire = null;
			}
		}
		
		/** 对身边的人物优先攻击对象,target优先攻击目标 **/
		public function findHitRole(target:EDRole):void
		{
			if (ed.isLive && ed.lock == false && hatred.length && hatred.firstIsLock == false && aiSkill.length)
			{
				var skill:AIRoleSkill = aiSkill[0];
				if (skill)
				{
					switch (ed.info.aiType) 
					{
						case 1:
							if (hatred.list.indexOf(target) != -1 && SearchTargetRole.isRangeCount(ed, target, skill.skill.range))
							{
								move.stop();
								changeTarget(target);
								hatred.priorityTarget = target;
							}
							break;
						case 2:
						case 3:
							//判断选中对象有没有在区域内,有就攻击选中对象
							if (SearchTargetRole.isRangeCount(ed, target, skill.skill.range))
							{
								move.stop();
								changeTarget(target);
								hatred.priorityTarget = target;
							}
							break;
					}
				}
			}
		}
	}
}