package cn.wjj.upgame.task 
{
	import cn.wjj.upgame.render.EngineTaskBreakBossSkill2;
	import cn.wjj.upgame.render.EngineTaskMergeKillSmall;
	import cn.wjj.upgame.render.EngineTaskMove;
	import cn.wjj.upgame.render.EngineTaskSelectEnemy;
	/**
	 * 没条的任务处理内容
	 * 
	 * @author GaGa
	 */
	public class TaskItemBase 
	{
		/** 控制层 **/
		internal var task:UpTask;
		/** 备用,用于外其他任务回调的ID **/
		public var id:uint = 0;
		/** 状态 **/
		public var status:int = 0;
		/** 任务类型 **/
		public var type:int = 0;
		/** 是否必须要完成的任务 **/
		public var isMust:Boolean = false;
		/** 完成的时候的回调函数,会将TaskItemBase回传回去 Function(item:TaskItemBase):void **/
		public var complete:Function;
		/** 是否包含任务父级 **/
		internal var parent:TaskItemList;
		
		public function TaskItemBase() { }
		
		/** 开启任务执行检测 **/
		public function start():void
		{
			if (status == TaskItemStatus.init)
			{
				status = TaskItemStatus.running;
				if (type == TaskItemType.List)
				{
					throw new Error("在List里执行");
				}
				else
				{
					task.runLength++;
					task.runList.push(this);
					if (type == TaskItemType.Kill) 
					{
						task.listenerEDRoleKill++;
					}
				}
			}
			else
			{
				throw new Error("未初始化");
			}
		}
		
		/** 任务完成 **/
		public function finish():void
		{
			if (status == TaskItemStatus.running)
			{
				status = TaskItemStatus.complete;
				if (complete != null)
				{
					complete(this);
					complete = null;
				}
				if(isMust)
				{
					task.lengthMust--;
				}
				var index:int;
				//包括父级:是否包含任务父级
				if (parent)
				{
					parent.finishItem(this);
				}
				else if(task.listLength)
				{
					//清理掉最外面的任务
					index = task.list.indexOf(this);
					if (index != -1)
					{
						task.list.splice(index, 1);
						task.listLength--;
					}
				}
				if (task.runLength)
				{
					index = task.runList.indexOf(this);
					if (index != -1)
					{
						task.runList.splice(index, 1);
						task.runLength--;
					}
				}
				//查看显示对象的移除
				if (task.u.readerStart)
				{
					switch (type) 
					{
						case TaskItemType.Move:
							EngineTaskMove.remove(task.u, this as TaskItemMove);
							break;
						case TaskItemType.SelectEnemy:
							EngineTaskSelectEnemy.remove(task.u, this as TaskItemSelectEnemy);
							break;
						case TaskItemType.MergeKillSmall:
							EngineTaskMergeKillSmall.remove(task.u, this as TaskItemMergeKillSmall);
							break;
						case TaskItemType.BreakBossSkill2:
							EngineTaskBreakBossSkill2.remove(task.u, this as TaskItemBreakBossSkill2);
							break;
					}
				}
			}
		}
		
		/** 检测是否通过 **/
		public function check():void { }
		
		/** 摧毁 **/
		public function dispose():void
		{
			if (status != TaskItemStatus.dispose)
			{
				status = TaskItemStatus.dispose;
				if (complete != null)
				{
					complete = null;
				}
				if (parent)
				{
					parent = null;
				}
			}
		}
	}
}