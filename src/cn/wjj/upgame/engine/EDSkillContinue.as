package cn.wjj.upgame.engine 
{
	import cn.wjj.g;
	import cn.wjj.upgame.common.EDType;
	import cn.wjj.upgame.render.EngineEffect;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 界面上持续的伤害技能,比如燃烧弹
	 * 
	 * @author GaGa
	 */
	public class EDSkillContinue extends EDBase 
	{
		/** 状态的开始时间 **/
		public var startTime:uint = 0;
		/** 下一次触发的时间 **/
		public var nextHitTime:uint = 0;
		/** Buff谁放的 **/
		public var owner:EDRole;
		/** 效果 **/
		public var effect:OSkillEffect;
		/** 运行了多少次 **/
		public var times:uint;
		/** 周期掉血受创的角色记录 **/
		public var list:Vector.<EDRole>;
		
		public function EDSkillContinue(u:UpGame) 
		{
			super(u);
			list = g.speedFact.n_vector(EDRole);
			if (list == null)
			{
				list = new Vector.<EDRole>();
			}
			type = EDType.skillContinue;
		}
		
		/** 查看是否有打到人 **/
		override public function aiTarget():void 
		{
			if (startTime == 0)
			{
				startTime = u.engine.time.timeGame;
				nextHitTime = startTime + effect.effect.perTime;
				times = 1;
				list.length = 0;
			}
			else if(nextHitTime <= u.engine.time.timeGame)
			{
				times++;
				nextHitTime += effect.effect.perTime;
				if (times > effect.effect.count)
				{
					//释放完毕
					dispose();
				}
				else
				{
					list.length = 0;
				}
			}
			if(isLive) hit();
		}
		
		/** 进入范围,并且未在列表的都会受到伤害 **/
		private function hit():void
		{
			//查询范围内的人物或动物啥的
			//effect.effect.rangeR
			//effect.effect.rangeType
			var targetList:Vector.<EDRole>;
			//范围伤害
			switch (effect.effect.effectTarget) 
			{
				case 1://1-全体
					targetList = SearchTargetContinue.range(this, 3);
					break;
				case 2://2-友方
					targetList = SearchTargetContinue.range(this, 2);
					break;
				case 3://3-敌方
					targetList = SearchTargetContinue.range(this, 1);
					break;
				case 4://4-自己
					targetList = new Vector.<EDRole>();
					if(owner)
					{
						targetList.push(owner);
					}
					break;
				default:
					targetList = SearchTargetContinue.range(this, 1);
			}
			//处理击中
			if (targetList && targetList.length)
			{
				var reportId:uint = 0;
				var reportAdd:Boolean = false;
				var path:String = "";
				if (u.readerStart && effect.effect.effectListId)
				{
					path = "assets/effect/skill/" + effect.effect.effectListId + ".u2";
				}
				var effHit:Boolean = false;
				var px:int, py:int;
				for each (var target:EDRole in targetList) 
				{
					if (this.isLive && target.isLive && list.indexOf(target) == -1
					&& ((target.info.typeProperty == 1 && effect.effect.AttacksGround)
					|| (target.info.typeProperty == 2 && effect.effect.AttacksAir)
					|| (target.info.typeProperty == 3 && effect.effect.AttacksBuildings)
					|| (target.info.typeProperty == 4 && effect.effect.AttacksBases)))
					{
						if (effHit) effHit = false;
						if (path)
						{
							//找出攻击点,在攻击点燃烧
							px = target.x + target.hit_r_x;
							py = target.y + target.hit_r_y;
							if (target.hit_h)
							{
								px = target.hit_r / 2 + px;
								py = target.hit_h / 2 + py;
							}
							px = x - px;
							py = y - py;
							if (u.modeTurn)
							{
								u.reader.singleEffect(u.engine.time.timeEngine, path, -px, -py, true);
							}
							else
							{
								u.reader.singleEffect(u.engine.time.timeEngine, path, px, py, true);
							}
						}
						list.push(target);
						//增加仇恨
						if (effect.ownerCamp != target.camp && effect.owner && effect.owner.isLive)
						{
							target.ai.hatred.add(effect.owner, 0);
							if (target.activate == false) target.activate = true;
							if (target.sleep) target.wakeUp();
						}
						if (reportAdd == false)
						{
							reportAdd = true;
							if (u.reportStart)
							{
								u.report.index++;
								reportId = u.report.index;
							}
						}
						effHit = AIRoleSkillEffect.hit(u, effect, target);
						if (effect.effect.type == 3)
						{
							if (effHit)
							{
								if (u.reportStart)
								{
									/*
									if (effect.owner)
									{
										u.report.addBuff(reportId, effect.ownerId, effect.ownerCamp, effect.ownerIdx, effect.ownerCall, effect.owner.x, effect.owner.y, effect.owner, effect.skillIndex, effect.actionId, effect.actionSkillId, effect.effect.id, effect.effect.id);
									}
									else
									{
									*/
										u.report.addBuff(reportId, effect.ownerId, effect.ownerCamp, effect.ownerIdx, effect.ownerCall, target.x, target.y, target, effect.skillIndex, effect.actionId, effect.actionSkillId, effect.effect.id, effect.effect.id);
									/*
									}
									*/
								}
								CSkillBuff.create(u, effect.owner, target, effect);
							}
							else if (u.readerStart && effect.effect.hitId != 3 && target && target.isLive && effect.owner != target
							&& ((target.info.typeProperty == 1 && effect.effect.AttacksGround)
							|| (target.info.typeProperty == 2 && effect.effect.AttacksAir)
							|| (target.info.typeProperty == 3 && effect.effect.AttacksBuildings)
							|| (target.info.typeProperty == 4 && effect.effect.AttacksBases)))
							{
								EngineEffect.showMissRole(u, target);
							}
						}
						else
						{
							AIRoleSkillRelease.releaseEffect(u, reportId, effHit, x, y, target, effect);
						}
					}
				}
			}
		}
		
		override public function dispose():void 
		{
			super.dispose();
			if (owner) owner = null;
			if (effect) effect = null;
			if (list)
			{
				g.speedFact.d_vector(EDRole, list);
				list = null;
			}
		}
	}
}