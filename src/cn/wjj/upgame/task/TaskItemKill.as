package cn.wjj.upgame.task 
{
	import cn.wjj.upgame.engine.EDRole;
	/**
	 * 人物移动的时候的控制
	 * 
	 * 可以控制EDRole,进去区域startX, endX ,startY, endY内的时候触发
	 * 
	 * @author GaGa
	 */
	public class TaskItemKill extends TaskItemBase 
	{
		
		/** 要检测的角色 **/
		public var role:EDRole;
		
		public function TaskItemKill() 
		{
			type = TaskItemType.Kill;
		}
		
		/** 监听某一个怪物死亡 **/
		public function listenerEDRole(role:EDRole):void
		{
			if (status == TaskItemStatus.sleep)
			{
				status = TaskItemStatus.init;
				this.role = role;
			}
			else
			{
				throw new Error("逻辑顺序错误");
			}
		}
		
		/** 是否完成本项任务 **/
		override public function check():void 
		{
			if (role.isLive == false || role.info.hp <= 0)
			{
				finish();
			}
		}
	}
}