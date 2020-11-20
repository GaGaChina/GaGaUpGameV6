package cn.wjj.upgame.common 
{
	import flash.events.Event;
	/**
	 * 事件
	 * 
	 * @author GaGa
	 */
	public class UpGameEvent extends Event
	{
		/** 游戏开始 **/
		public static const start:String = "UpGame.GameStart";
		/** 游戏结束 **/
		public static const over:String = "UpGame.GameOver";
		/** 游戏暂停 **/
		public static const pause:String = "UpGame.GamePause";
		/** 选择卡牌, info.id = 卡牌ID, info.camp = 所属阵营 **/
		public static const selectCard:String = "UpGame.SelectCard";
		/** 游戏日志部分校验出错 **/
		public static const reportError:String = "UpGame.ReportError";
		/** 游戏重新运行完成 **/
		public static const gameReGo:String = "UpGame.ReGo";
		
		
		/** 传递的消息 **/
		public var info:Object;
		
		public function UpGameEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
		}
	}
}