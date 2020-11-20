package cn.wjj.upgame.tools
{
	import cn.wjj.upgame.UpGame;
	import cn.wjj.upgame.info.UpInfo;
	import cn.wjj.upgame.info.UpInfoDisplay;
	import cn.wjj.upgame.info.UpInfoLayer;
	import cn.wjj.upgame.render.DisplayLayer;
	import cn.wjj.upgame.render.DisplayMap;
	
	/**
	 * 获取画布上的全部数据
	 * @author GaGa
	 */
	public class UpGameV1Status 
	{
		/** 向上游戏框架的主入口 **/
		public static var upGame:UpGame;
		/** 场景中的全部信息 **/
		public static var info:UpInfo;
		/** 获取现在操作的容器 **/
		public static var display:DisplayMap;
		/** 选中的图层所属对象 **/
		private static var _selectDisplay:UpInfoDisplay;
		/** 选中的图层 **/
		private static var _selectLayer:UpInfoLayer;
		/** [默认:1]播放速度 **/
		public static var speed:Number = 1;
		/** [默认:1]画布比例 **/
		public static var stageScale:Number = 1;
		/** [默认:0]X **/
		public static var x:Number = 0;
		/** [默认:0]Y **/
		public static var y:Number = 0;
		/** [默认:0]scaleX **/
		public static var scaleX:Number = 1;
		/** [默认:0]scaleY **/
		public static var scaleY:Number = 1;
		/** [默认:0]scaleX **/
		public static var alpha:Number = 100;
		/** [默认:0]scaleY **/
		public static var rotation:Number = 0;
		/** [绘图使用]绘制工具启动后,是否已经创建的图层 **/
		public static var isCreate:Boolean = false;
		/** [绘图使用]是在工具里展示,还是在实际项目中 **/
		public static var isDrag:Boolean = false;
		/** 编辑图层,还是编辑图层内内容 **/
		public static var editLayer:Boolean = false;
		/** 是否开启自动选择场景内容 **/
		public static var autoSelect:Boolean = true;
		/** 是否可以用快捷键,删除,移动等 **/
		public static var useKeyboard:Boolean = false;
		/** 内容是否处于播放状态 **/
		public static var u2Play:Boolean = true;

		public function UpGameV1Status() { }
		
		/** 选中的图层 **/
		static public function get selectLayer():UpInfoLayer { return _selectLayer; }
		/** 选中的图层 **/
		static public function set selectLayer(value:UpInfoLayer):void 
		{
			if (_selectLayer != value)
			{
				var layer:DisplayLayer;
				_selectLayer = value;
				var e:UpGameToolsEvent = new UpGameToolsEvent(UpGameToolsEvent.SelectLayer);
				UpGameToolsEvent.getInstance.dispatchEvent(e);
				selectDisplay = null;
			}
		}
		/** 选中的图层所属对象 **/
		static public function get selectDisplay():UpInfoDisplay { return _selectDisplay; }
		/** 选中的图层所属对象 **/
		static public function set selectDisplay(value:UpInfoDisplay):void 
		{
			if (_selectDisplay != value)
			{
				_selectDisplay = value;
				var e:UpGameToolsEvent = new UpGameToolsEvent(UpGameToolsEvent.SelectDisplay);
				UpGameToolsEvent.getInstance.dispatchEvent(e);
			}
		}
	}
}