package cn.wjj.upgame.task 
{
	import cn.wjj.upgame.engine.AIRoleSkill;
	import cn.wjj.upgame.engine.EDRole;
	
	/**
	 * 检测,释放技能,当技能可以释放强制引导玩家释放本技能,游戏暂停,并且任务结束
	 * 
	 * @author GaGa
	 */
	public class TaskItemReleaseSkill extends TaskItemBase 
	{
		
		/** 要检测的角色 **/
		private var role:EDRole;
		/** 要监听第几个技能 **/
		private var index:int;
		/** 技能好的时候的回调函数 Function(task:TaskItemBase) **/
		private var openMethod:Function;
		
		
		public function TaskItemReleaseSkill() 
		{
			type = TaskItemType.ReleaseSkill;
		}
		
		/**
		 * 设置任务
		 * @param	role	监听的角色
		 * @param	skill	监听第几个技能
		 * @param	method	回调函数
		 */
		public function setInfo(role:EDRole, index:int, method:Function):void
		{
			if (status == TaskItemStatus.sleep)
			{
				status = TaskItemStatus.init;
				this.role = role;
				this.index = index;
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
				if (role && role.isLive && role.ai.canFireIndex(index))
				{
					if (openMethod != null)
					{
						openMethod(this);
						openMethod = null;
					}
					finish();
				}
			}
		}
	}
}