package cn.wjj.upgame.task 
{
	/**
	 * 任务状态
	 * @author GaGa
	 */
	public class TaskItemStatus 
	{
		/** 任务休眠 **/
		public static const sleep:uint = 0;
		/** 任务运行中 **/
		public static const init:uint = 1;
		/** 任务运行中 **/
		public static const running:uint = 2;
		/** 任务已经完成 **/
		public static const complete:uint = 3;
		/** 任务已经清理 **/
		public static const dispose:uint = 4;
		
		public function TaskItemStatus() { }
	}
}