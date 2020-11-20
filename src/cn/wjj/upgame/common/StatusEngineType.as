package cn.wjj.upgame.common 
{
	/**
	 * 游戏状态
	 * 
	 * @author GaGa
	 */
	public class StatusEngineType 
	{
		/** 游戏还没运行过 **/
		public static const no:int = 0;
		/** 游戏已经开始中 **/
		public static const start:int = 1;
		/** 游戏已经暂停 **/
		public static const pause:int = 2;
		/** 游戏已经结束 **/
		public static const over:int = 3;
		/** 游戏时间结束 **/
		public static const timeover:int = 4;
		/** 游戏处于活动模式 **/
		public static const live:int = 5;
		
		public function StatusEngineType() { }
	}
}