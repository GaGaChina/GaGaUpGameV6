package cn.wjj.upgame.task 
{
	
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	
	/**
	 * 任务列表
	 * @author GaGa
	 */
	public class TaskItemList extends TaskItemBase 
	{
		/** 任务列表 **/
		public var list:Vector.<TaskItemBase>;
		/** 现在正在执行的任务 **/
		public var runItem:TaskItemBase;
		/** 是否是俺循序执行的任务 **/
		public var lineRun:Boolean = true;
		
		/** 任务列表已经完成的数量 **/
		public var completeLength:int = 0;
		
		public function TaskItemList() 
		{
			type = TaskItemType.List;
		}
		
		override public function start():void 
		{
			if (status == TaskItemStatus.sleep)
			{
				status = TaskItemStatus.running;
				if (list.length)
				{
					if (lineRun)
					{
						if (runItem == null)
						{
							runItem = list[0];
							runItem.start();
						}
					}
					else
					{
						for each (var item:TaskItemBase in list) 
						{
							item.start();
						}
					}
				}
				else
				{
					finish();
				}
			}
		}
		
		/**
		 * 完成了一个任务
		 * @param	item
		 */
		public function finishItem(item:TaskItemBase):void
		{
			if (lineRun)
			{
				if (runItem == item)
				{
					completeLength++;
					check()
				}
				else
				{
					g.log.pushLog(this, LogType._ErrorLog, "任务已经错乱");
					throw new Error("任务出现问题");
				}
			}
			else
			{
				completeLength++;
				check()
			}
		}
		
		/** 是否完成本项任务 **/
		override public function check():void 
		{
			if (list.length == completeLength)
			{
				finish();
			}
		}
		
		override public function dispose():void 
		{
			if (status != TaskItemStatus.dispose)
			{
				super.dispose();
				if (list)
				{
					if (list.length)
					{
						for each (var item:TaskItemBase in list) 
						{
							item.dispose();
						}
						list.length = 0;
					}
					list = null;
				}
				if (runItem)
				{
					runItem = null;
				}
				if(completeLength != 0) completeLength = 0;
			}
		}
	}
}