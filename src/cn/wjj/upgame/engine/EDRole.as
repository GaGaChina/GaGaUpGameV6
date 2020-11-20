package cn.wjj.upgame.engine 
{
	import cn.wjj.upgame.common.EDType;
	import cn.wjj.upgame.common.StatusEngineType;
	import cn.wjj.upgame.common.StatusTypeRole;
	import cn.wjj.upgame.data.HeroStarUpModel;
	import cn.wjj.upgame.data.SkillActiveModel;
	import cn.wjj.upgame.data.UpGameData;
	import cn.wjj.upgame.data.UpGameModelInfo;
	import cn.wjj.upgame.tools.ReleaseMagic;
	import cn.wjj.upgame.UpGame;
	import cn.wjj.upgame.UpGameConfig;
	
	/**
	 * 场景上可以移动的内容
	 * 
	 * @author GaGa
	 */
	public class EDRole extends EDBase 
	{
		/** 状态 **/
		public var status:int;
		/** 角度 **/
		public var angle:int = 0;
		/** 属于第几组刷出来的角色 **/
		public var group:int = -1;
		/** 这个对象的AI控制模块 **/
		public var ai:AIRole;
		/** 角色实体信息 **/
		public var info:ORole;
		/** 模型数据 **/
		public var model:UpGameModelInfo;
		/** RoleCardModel, 所包含的全部技能列表,0为普通技能,为空为没有普通技能 **/
		public var skillList:Vector.<SkillActiveModel>;
		/** 是否已经被激活,激活的角色会有攻击AI,会走技能 **/
		public var activate:Boolean = false;
		/** 是否可以被攻击 **/
		public var canHit:Boolean = false;
		/** 沉睡中 **/
		public var sleep:Boolean = false;
		/** 是否移动到了可移动的区域内, 是否已经进入正常地图范围内,如果不在将无法选中和攻击 **/
		public var inHot:Boolean = false;
		/** 是否被用户锁定指挥 **/
		public var lock:Boolean = false;
		/** 现在的资源ID **/
		public var displayId:uint = 0;
		/** 显示对象的比例 **/
		public var displayScale:Number = 1;
		/** 播放那个时间点, -1是自动播放 **/
		public var displayStartTime:int = -1;
		/** 是否跳转时间点 **/
		public var displayChangeTime:Boolean = false;
		/** 显示对象是否镜像 **/
		public var displayMirror:Boolean = false;
		/** [默认:0]碰撞半径偏移X坐标 **/
		public var hit_r_x:int = 0;
		/** [默认:0]碰撞半径偏移Y坐标 **/
		public var hit_r_y:int = 0;
		/** [默认:0]碰撞半径或矩形的宽度 **/
		public var hit_r:uint = 0;
		/** [默认:0]矩形的高度 : 圆形填0 **/
		public var hit_h:uint = 0;
		/** 人物在计算移动碰撞非移动区或其他角色的时候,使用的比例 **/
		public var hitScale:Number = 1;
		/** 被挤状态恢复时间 **/
		public var hitScaleTime:uint = 0;
		/** 发射点1 **/
		public var hitX1:int = 0;
		/** 发射点1 **/
		public var hitY1:int = 0;
		/** 发射点2 **/
		public var hitX2:int = 0;
		/** 发射点2 **/
		public var hitY2:int = 0;
		/** 生命值的比例*10000后 **/
		public var hpScale:int = 0;
		/** 这个人物的速度变化(被冰冻等等),技能直接被中断 **/
		public var uiStop:Boolean = false;
		/** 是否IA停止运行,中断 **/
		internal var _aiStop:Boolean = false;
		/** 是否处于眩晕 **/
		internal var _aiStun:Boolean = false;
		/** AI停止的时候的时间 **/
		public var aiStopTime:uint = 0;
		/** 是否自动死亡总时长,召唤生物才有这个,如果修改这个,需要去修改removeED函数里的替补上场**/
		public var dieAuto:int = 0;
		/** 本角色已经召唤的怪物的数量 **/
		public var callLength:int = 0;
		/** [毫秒]每次运行减值,减少到小于等于0,就可以执行死亡 **/
		public var timeDie:int = 0;
		/** 复活的时间点 **/
		public var timeRevive:uint = 0;
		/** [毫秒 timeGame]创建时间 **/
		public var timeCreate:uint = 0;
		/** 死亡恢复的角色 **/
		public var dieRecoveryED:EDRole;
		/** 死亡恢复的角色借用的实体信息 **/
		public var dieRecoveryInfo:ORole;
		
		public function EDRole(u:UpGame) 
		{
			super(u);
			timeCreate = u.engine.time.timeGame;
			type = EDType.role;
		}
		
		/** [专门留给显示对象哪里切换状态用]调整人物的状态,并修改形象 **/
		public function changeStatus(status:int):void
		{
			if (this.status != status)
			{
				this.status = status;
				if (displayStartTime != u.engine.time.timeGame) displayStartTime = u.engine.time.timeGame;
				if (displayChangeTime == false) displayChangeTime = true;
				EDRoleToolsSkin.changeSkin(this, u.modeTurn);
			}
		}		
		
		/** 从沉睡中激活 **/
		public function wakeUp():void
		{
			if (sleep)
			{
				sleep = false;
				ai.startAppear();
			}
		}
		
		/** 执行AI部分 **/
		override public function aiRun():void 
		{
			ai.aiRun();
		}
		
		/** 查看是否有打到人 **/
		override public function aiTarget():void 
		{
			ai.aiTarget();
		}
		
		/** 是否IA停止运行,中断 **/
		public function get aiStop():Boolean { return _aiStop; }
		/** 是否IA停止运行,中断 **/
		public function set aiStop(value:Boolean):void 
		{
			if (_aiStop != value)
			{
				_aiStop = value;
				if (ai)
				{
					if (value)
					{
						ai.oldSkill = null;
						if (ai.skillFire)
						{
							ai.skillStop();
						}
						status = StatusTypeRole.idle;
						uiStop = true;
					}
					else
					{
						if (ai.skillFire)
						{
							ai.oldSkill = ai.skillFire;
							ai.skillStop();
						}
						status = StatusTypeRole.idle;
						EDRoleToolsSkin.changeSkin(this, u.modeTurn);
						uiStop = false;
					}
				}
			}
		}
		
		/** 是否眩晕 **/
		public function get aiStun():Boolean { return _aiStun; }
		/** 是否IA停止运行,中断 **/
		public function set aiStun(value:Boolean):void 
		{
			if (_aiStun != value)
			{
				_aiStun = value;
				if (ai)
				{
					if (value)
					{
						ai.oldSkill = null;
						if (ai.skillFire)
						{
							ai.skillStop();
						}
						status = StatusTypeRole.idle;
						EDRoleToolsSkin.changeSkin(this, u.modeTurn);
					}
					else if (ai.skillFire)
					{
						ai.oldSkill = ai.skillFire;
						ai.skillStop();
					}
				}
			}
		}
		
		/** 英雄的回血, 提前检查是否是英雄 **/
		public function aiRunDieHero():void
		{
			//复活英雄
			if (this.timeRevive <= u.engine.time.timeGame)
			{
				status = StatusTypeRole.idle;
				if (camp == 1)
				{
					x = 9999999;
					y = 9999999;
				}
				else
				{
					x = -9999999;
					y = -9999999;
				}
				isLive = true;
				//血恢复
				info.hp = info.hpMax;
				hpScale = 10000;
				//技能初始化
				for each (var skill:AIRoleSkill in ai.aiSkill)
				{
					if(skill)
					{
						skill.reStart();
					}
				}
			}
		}
		
		/** 对英雄添加经验 **/
		public function addExp(val:uint):void
		{
			if (isLive)
			{
				var s:Number = 1;
				if (camp == 1)
				{
					if (x > 1000000 && y > 1000000)
					{
						s = 0.5;
					}
				}
				else if (camp == 2)
				{
					if (x < -1000000 && y < -1000000)
					{
						s = 0.5;
					}
				}
				if (info.heroInfo.expStar < UpGameConfig.expStarMax)
				{
					info.heroInfo.expVal += int(val * s * (UpGameConfig.expStarUp * info.heroInfo.expStar + 1) * info.heroInfo.expAddUp);
					while (info.heroInfo.expVal >= info.heroInfo.expNext)
					{
						//播放升星动画
						if (u.readerStart)
						{
							if (u.modeTurn)
							{
								u.reader.singleEffect(u.engine.time.timeEngine, UpGameConfig.uiStarUp, -x, -y);
							}
							else
							{
								u.reader.singleEffect(u.engine.time.timeEngine, UpGameConfig.uiStarUp, x, y);
							}
						}
						//升星
						info.heroInfo.expStar++;
						var starUpModel:HeroStarUpModel = UpGameData.heroStarUp.getItemArr(["HeroID", "Star"], [info.id, info.heroInfo.expStar], ["==", "=="], [true, true]);
						if (starUpModel)
						{
							info.hpMax += starUpModel.AddHP;
							info.hp += starUpModel.AddHP;
							hpScale = int(info.hp / info.hpMax * 10000);
							info.atk += starUpModel.AddAttack;
							if (starUpModel.UnlockSkill)
							{
								//开始向下解锁技能
								CRole.heroUnlockNextSkill(this);
							}
							ai.createOEffect();
						}
						//经验升满,跳出
						if (info.heroInfo.expStar < UpGameConfig.expStarMax)
						{
							info.heroInfo.expVal -= info.heroInfo.expNext;
							starUpModel = UpGameData.heroStarUp.getItemArr(["HeroID", "Star"], [info.id, (info.heroInfo.expStar + 1)], ["==", "=="], [true, true]);
							if (starUpModel)
							{
								info.heroInfo.expNext = starUpModel.StarExp - info.heroInfo.expNext;
							}
						}
						else
						{
							info.heroInfo.expVal = info.heroInfo.expNext;
							break;
						}
					}
				}
				else
				{
					//星级升满
				}
			}
		}
		
		/** 从战场中先移除走 **/
		internal function removeBattle():void
		{
			if (u)
			{
				//查找周边有没有没有激活的对象,找到阵营内,非我方,非死亡,未激活对象,然后查看是否可以激活
				var role:EDRole;
				var campItem:EDCamp;
				if (info.sizeRect)
				{
					var index:int = u.engine.astar.moveAll.indexOf(info.sizeRect);
					if (index != -1)
					{
						u.engine.astar.moveAll.splice(index, 1);
						//修改AStar
						var astar:UpGameAStar = u.engine.astar;
						var mapX:int, mapY:int;
						var startX:int = int((info.sizeRect.x - astar.offsetX) / astar.tileWidth);
						var startY:int = int((info.sizeRect.y - astar.offsetY) / astar.tileHeight);
						var maxX:int = int((info.sizeRect.x + info.sizeRect.width - astar.offsetX) / astar.tileWidth);
						var maxY:int = int((info.sizeRect.y + info.sizeRect.height - astar.offsetY) / astar.tileHeight);
						for (mapX = startX; mapX < maxX; mapX++)
						{
							for (mapY = startY; mapY < maxY; mapY++)
							{
								astar.map[mapX][mapY] = 0;
							}
						}
					}
					if (u.isDebug)
					{
						u.reader.map.addDebug();
					}
					info.sizeRect = null;
				}
				if (u.engine.type == StatusEngineType.start)
				{
					if (u.engine.campLib.length == 2)
					{
						if (camp == 1)
						{
							if (u.engine.camp1.lengthRole)
							{
								for each (role in u.engine.camp1.listRole) 
								{
									if (role != this && role.isLive && role.activate == false)
									{
										AIRoleActivate.itLook(role);
									}
								}
							}
						}
						else
						{
							if (u.engine.camp2.lengthRole)
							{
								for each (role in u.engine.camp2.listRole) 
								{
									if (role != this && role.isLive && role.activate == false)
									{
										AIRoleActivate.itLook(role);
									}
								}
							}
						}
					}
					else if (u.engine.camp.hasOwnProperty(camp))
					{
						campItem = u.engine.camp[camp];
						if (campItem.lengthRole)
						{
							for each (role in campItem.listRole) 
							{
								if (role != this && role.isLive && role.activate == false)
								{
									AIRoleActivate.itLook(role);
								}
							}
						}
					}
				}
				//从其他的仇恨列表中移除本对象
				if (u.engine.campLib.length == 2)
				{
					if (camp == 2)
					{
						if (u.engine.camp1.lengthRole)
						{
							for each (role in u.engine.camp1.listRole) 
							{
								if (role.isLive) role.ai.hatred.remove(this);
							}
						}
					}
					else
					{
						if (u.engine.camp2.lengthRole)
						{
							for each (role in u.engine.camp2.listRole) 
							{
								if (role.isLive) role.ai.hatred.remove(this);
							}
						}
					}
				}
				else
				{
					for each (campItem in u.engine.campLib) 
					{
						if (campItem.lengthRole && campItem.camp != camp)
						{
							for each (role in campItem.listRole) 
							{
								if (role.isLive) role.ai.hatred.remove(this);
							}
						}
					}
				}
			}
		}
		
		override public function dispose():void 
		{
			removeBattle();
			//清理下BUFF
			if (ai)
			{
				//释放死亡技能
				if (info && info.hero)
				{
					timeRevive = u.engine.time.timeGame + info.heroInfo.timeRevive;
					//ai.buff.clearBuff();
					ai.hatred.removeAll();
					ai.move.stop();
					ai.collision.stop();
					if (ai.targetList.length)
					{
						ai.targetList.length = 0;
					}
					if (ai.lockTarget) ai.lockTarget = null;
					if (ai.skillFire)
					{
						ai.skillStop();
					}
					if (ai.oldSkill) ai.oldSkill = null;
					if (ai.timeChangeHide != -1) ai.timeChangeHide = -1;
					if (ai.timeChangeInit != -1) ai.timeChangeInit = -1;
				}
				else
				{
					ai.dispose();
					ai = null;
				}
				if (info && info.dieSkill)
				{
					//增加死亡复活技能
					if (dieRecoveryED)
					{
						AIRoleSkillEffect.useInfoToEd(dieRecoveryInfo, dieRecoveryED, this);
						dieRecoveryED.x = x;
						dieRecoveryED.y = y;
						dieRecoveryED.isLive = true;
					}
					ReleaseMagic.callSkillXY(u, playerId, info.dieSkill, camp, x, y, x, y);
				}
			}
			this.status = StatusTypeRole.die;
			if (dieAuto)
			{
				dieAuto = 0;
				timeDie = 0;
			}
			if (model && u)
			{
				var deadTime:int = u.engine.time.timeEngine + model.deadTime;
				if (deadTime > u.engine.time.timeFollowUp)
				{
					u.engine.time.timeFollowUp = deadTime;
				}
			}
			//为其他阵营增加经验值
			if (isLive && u && info && info.expDie)
			{
				if (camp == 1)
				{
					u.engine.camp2.addExp(info.expDie);
				}
				else
				{
					u.engine.camp1.addExp(info.expDie);
				}
			}
			if (u && info.hero && u.engine.isGameOver == false)
			{
				if (isLive) isLive = false;
			}
			else
			{
				super.dispose();
				if (model) model = null;
				if (info) info = null;
				if (skillList)
				{
					skillList.length = 0;
					skillList = null;
				}
			}
		}
	}
}