package cn.wjj.upgame.engine 
{
	import cn.wjj.upgame.common.EDType;
	import cn.wjj.upgame.render.DisplayEDRole;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 技能的Buff作用的对象
	 * 直接实例化到人物身上
	 * 
	 * @author GaGa
	 */
	public class EDSkillBuff extends EDBase 
	{
		/** 状态的开始时间 **/
		public var startTime:uint = 0;
		/** 下一次触发的时间 **/
		public var nextHitTime:uint = 0;
		/** Buff谁放的 **/
		public var owner:EDRole;
		/** Buff作用在那个对象上 **/
		public var target:EDRole;
		/** Buff具体效果 **/
		public var effect:OSkillEffect;
		/** 运行了多少次 **/
		public var times:int = 0;
		/** 已经命中率多少次,叠加了多少buff **/
		public var overlay:int = 0;
		/** 是否已经被冻结了 **/
		public var isStop:Boolean = false;
		/** 是否已经被晕了 **/
		public var isStun:Boolean = false;
		
		public function EDSkillBuff(u:UpGame) 
		{
			super(u);
			type = EDType.skillBuff;
		}
		
		/** 不停的运行BUFF的效果 **/
		override public function aiRun():void 
		{
			if (isLive)
			{
				if (effect.effect.type == 3)
				{
					if (startTime == 0)
					{
						times = 0;
						overlay = 0;
						startTime = u.engine.time.timeGame;
						nextHitTime = startTime + effect.effect.perTime;
						useEffect();
					}
					else if(nextHitTime <= u.engine.time.timeGame)
					{
						//释放完毕
						if (target.u.reportStart)
						{
							target.u.report.index++;
							if(owner)
							{
								target.u.report.removeBuff(target.u.report.index, effect.ownerId, effect.ownerCamp, effect.ownerIdx, effect.ownerCall, owner.x, owner.y, owner, effect.skillIndex, effect.actionId, effect.actionSkillId, effect.effect.id, effect.effect.id);
							}
							else
							{
								target.u.report.removeBuff(target.u.report.index, effect.ownerId, effect.ownerCamp, effect.ownerIdx, effect.ownerCall, 0, 0, null, effect.skillIndex, effect.actionId, effect.actionSkillId, effect.effect.id, effect.effect.id);
							}
						}
						target.ai.buff.removeBuff(this);
					}
				}
				else
				{
					if (startTime == 0)
					{
						times = 0;
						overlay = 0;
						startTime = u.engine.time.timeGame;
						nextHitTime = startTime + effect.effect.perTime;
						useEffect();
					}
					else if(nextHitTime <= u.engine.time.timeGame)
					{
						nextHitTime += effect.effect.perTime;
						if (times < effect.effect.count)
						{
							useEffect();
						}
						else
						{
							//释放完毕
							if (target.u.reportStart)
							{
								target.u.report.index++;
								if(owner)
								{
									target.u.report.removeBuff(target.u.report.index, effect.ownerId, effect.ownerCamp, effect.ownerIdx, effect.ownerCall, owner.x, owner.y, owner, effect.skillIndex, effect.actionId, effect.actionSkillId, effect.effect.id, effect.effect.id);
								}
								else
								{
									target.u.report.removeBuff(target.u.report.index, effect.ownerId, effect.ownerCamp, effect.ownerIdx, effect.ownerCall, 0, 0, null, effect.skillIndex, effect.actionId, effect.actionSkillId, effect.effect.id, effect.effect.id);
								}
							}
							target.ai.buff.removeBuff(this);
						}
					}
				}
			}
		}
		
		/** 使Buff产生效果 **/
		private function useEffect():void
		{
			//给 target 上添加效果
			if (target.isLive)
			{
				//增加仇恨
				if (effect.ownerCamp != target.camp && effect.owner && effect.owner.isLive)
				{
					target.ai.hatred.add(effect.owner, 0);
				}
				//查看命中情况
				var reportId:uint = 0;
				if (target.u.reportStart)
				{
					target.u.report.index++;
					reportId = target.u.report.index;
				}
				overlay++;
				if (effect)
				{
					if (effect.effect.isStop && isStop == false)
					{
						isStop = true;
					}
					if (effect.effect.isStun && isStun == false)
					{
						isStun = true;
					}
				}
				times++;
				if(owner)
				{
					AIRoleSkillRelease.releaseEffect(target.u, reportId, true, owner.x, owner.y, target, effect);
				}
				else
				{
					AIRoleSkillRelease.releaseEffect(target.u, reportId, true, 0, 0, target, effect);
				}
			}
			else
			{
				clearEffect();
			}
		}
		
		/** 将Buff的效果去掉 **/
		private function clearEffect():void
		{
			//从 target 上把已经添加的效果都移除
			if (isLive)
			{
				var reportId:uint = 0;
				if (u.reportStart)
				{
					u.report.index++;
					reportId = u.report.index;
				}
				while (overlay > 0)
				{
					overlay--;
					if(owner)
					{
						AIRoleSkillEffect.removeBuff(reportId, owner.x, owner.y, target, effect);
					}
					else
					{
						AIRoleSkillEffect.removeBuff(reportId, 0, 0, target, effect);
					}
				}
				//先处理显示对象里的内容
				if (u.readerStart)
				{
					
					var dr:DisplayEDRole = u.reader.map.edToDisplay(target) as DisplayEDRole;
					if (dr && dr.buff)
					{
						dr.buff.removeBuff(this);
					}
				}
			}
		}
		
		override public function dispose():void 
		{
			clearEffect();
			//主动处理显示对象的BUFF
			super.dispose();
			if (target) target = null;
			if (owner) owner = null;
			if (effect) effect = null;
			if (startTime != 0) startTime = 0;
			if (nextHitTime != 0) nextHitTime = 0;
			if (times != 0) times = 0;
			if (overlay != 0) overlay = 0;
			if (isStop) isStop = false;
			if (isStun) isStun = false;
		}
	}
}