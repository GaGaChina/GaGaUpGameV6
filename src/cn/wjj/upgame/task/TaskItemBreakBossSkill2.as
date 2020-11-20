package cn.wjj.upgame.task 
{
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.upgame.engine.AIRoleSkillAction;
	import cn.wjj.upgame.engine.EDRole;
	
	/**
	 * 打断对手技能,BOSS的第二个技能,我方用冲锋技能
	 * 
	 * 
	 * @author GaGa
	 */
	public class TaskItemBreakBossSkill2 extends TaskItemBase 
	{
		/** 要捕获的服务器ID **/
		public var typeId:uint;
		/** 打断BOSS的技能释放者 **/
		public var role:EDRole;
		/** 技能好的时候的回调函数 Function(task:TaskItemBase) **/
		private var openMethod:Function;
		
		public function TaskItemBreakBossSkill2() 
		{
			type = TaskItemType.BreakBossSkill2;
		}
		
		/**
		 * 设置任务
		 * @param	method	技能好的时候的回调函数 Function(task:TaskItemBase)
		 */
		public function setInfo(method:Function):void
		{
			if (status == TaskItemStatus.sleep)
			{
				status = TaskItemStatus.init;
				this.typeId = typeId;
				this.openMethod = method;
			}
			else
			{
				throw new Error("逻辑顺序错误");
			}
		}
		
		/** 是否完成本项任务 **/
		override public function check():void 
		{
			if (status == TaskItemStatus.running)
			{
				var ed:EDRole;
				var actionRun:AIRoleSkillAction;
				if (role == null && openMethod != null)
				{
					var useTime:uint;
					//查看有没有打断技能,并且是否可以释放,克里斯,第一个技能,modle(1002)
					for each (ed in task.u.engine.camp1.listRole) 
					{
						if (ed.isLive && ed.dieAuto == 0 && ed.model.id == 1002 && ed.ai.aiSkill.length > 0 && ed.ai.aiSkill[1] && ed.ai.aiSkill[1].isReady)
						{
							role = ed;
							for each (ed in task.u.engine.camp2.listRole) 
							{
								if (ed.isLive && ed.info.boss && ed.ai.skillFire && ed.ai.skillFire.index == 2)
								{
									useTime = task.u.engine.time.timeEngine - ed.ai.skillFire.timeFire;
									actionRun = ed.ai.skillFire.actionList[0];
									if ((actionRun.time / 2) < useTime && useTime < (actionRun.time * 0.95))
									{
										if(role.ai.canFireIndex(1, true) == 0)
										{
											if(role.ai.aiSkill[1].target.length)
											{
												if(role.ai.aiSkill[1].target[0] != ed)
												{
													role.ai.changeTarget(ed);
													if(role.ai.canFireIndex(1, true) == 0)
													{
														openMethod(this);
														openMethod = null;
														return;
													}
												}
												else
												{
													openMethod(this);
													openMethod = null;
													return;
												}
											}
										}
									}
								}
							}
							role = null;
							return;
						}
					}
				}
			}
		}
		
		override public function dispose():void 
		{
			super.dispose();
			if (role) role = null;
			if (openMethod != null) openMethod = null;
		}
	}
}