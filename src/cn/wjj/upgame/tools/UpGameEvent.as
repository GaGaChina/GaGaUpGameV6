package cn.wjj.upgame.tools
{
	import cn.wjj.upgame.info.UpInfoDisplay;
	import cn.wjj.upgame.info.UpInfoLayer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	/**
	 * U2事件分发
	 * @author GaGa
	 */
	public class UpGameEvent extends Event implements IEventDispatcher
	{
		
		private static const instanceUse:String = "upgame_event_instanceUse";
		
		/** 创建图层完成 **/
		public static const CREATE:String = "upgame_event_CREATE";
		/** 场景尺寸比例发生变化 **/
		public static const StageScaleReSize:String = "upgame_event_StageScaleReSize";
		/** 选中了其他图层 **/
		public static const SelectLayer:String = "upgame_event_SelectLayer";
		/** 选中一个特定的显示对象 **/
		public static const SelectDisplay:String = "upgame_event_SelectDisplay";
		/** 修改了选中的图层 **/
		public static const ChangeLayer:String = "upgame_event_ChangeLayer";
		/** 添加或删除图层,导致图层高度发生变化 **/
		public static const ChangeLayerLength:String = "upgame_event_ChangeLayerLength";
		/** 场景绘制完毕 **/
		public static const DragOver:String = "upgame_event_DragOver";
		
		private static var instance:UpGameEvent;
		
		private static var dispatcher:EventDispatcher;
		
		public function UpGameEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
		}
		
		public static function get getInstance():UpGameEvent
		{
			if (instance)
			{
				return instance;
			}
			else
			{
				instance = new UpGameEvent(UpGameEvent.instanceUse);
				dispatcher = new EventDispatcher(instance);
			}
			return instance;
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			dispatcher.addEventListener(type, listener, useCapture, priority);
		}
		
		public function dispatchEvent(evt:Event):Boolean
		{
			return dispatcher.dispatchEvent(evt);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return dispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return dispatcher.willTrigger(type);
		}
		
		override public function clone():Event 
		{
			var e:UpGameEvent = new UpGameEvent(type, bubbles, cancelable);
			return e;
		}
	}
}
class Enforcer{}