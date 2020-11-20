package cn.wjj.upgame.data
{
	import flash.utils.ByteArray;
	/**
	 * UpGame关卡地图表
	 */
	public class UpGameWarMap
	{
		/** 索引字段 **/
		internal static var __keyList:Array = ["id"];
		/** [默认:0]战场ID **/
		public function get id():uint {
			if (__info.hasOwnProperty("id")) return __info["id"];
			return 0;
		}
		/** [默认:0]地图ID **/
		public function get mapId():uint {
			if (__info.hasOwnProperty("mapId")) return __info["mapId"];
			return 0;
		}
		/** [默认:0]音乐 **/
		public function get music():uint {
			if (__info.hasOwnProperty("music")) return __info["music"];
			return 0;
		}
		/** [默认:0]剧情y坐标1 **/
		public function get y1():int {
			if (__info.hasOwnProperty("y1")) return __info["y1"];
			return 0;
		}
		/** [默认:0]剧情y坐标2 **/
		public function get y2():int {
			if (__info.hasOwnProperty("y2")) return __info["y2"];
			return 0;
		}
		/** [默认:0]剧情出现点1 : 初始点 **/
		public function get player1():int {
			if (__info.hasOwnProperty("player1")) return __info["player1"];
			return 0;
		}
		/** [默认:0]剧情出现点2 **/
		public function get player2():int {
			if (__info.hasOwnProperty("player2")) return __info["player2"];
			return 0;
		}
		/** [默认:0]剧情出现点3 **/
		public function get player3():int {
			if (__info.hasOwnProperty("player3")) return __info["player3"];
			return 0;
		}
		/** [默认:0]剧情出现点4 : 初始点好友位置 **/
		public function get player4():int {
			if (__info.hasOwnProperty("player4")) return __info["player4"];
			return 0;
		}
		/** [默认:0]战前剧情ID : 如果有,要走到后面起始点 **/
		public function get storyBegin():uint {
			if (__info.hasOwnProperty("storyBegin")) return __info["storyBegin"];
			return 0;
		}
		/** [默认:false]黑屏 **/
		public function get blackscreen():Boolean {
			if (__info.hasOwnProperty("blackscreen")) return __info["blackscreen"];
			return false;
		}
		/** [默认:0]战斗y坐标1 **/
		public function get battleY1():int {
			if (__info.hasOwnProperty("battleY1")) return __info["battleY1"];
			return 0;
		}
		/** [默认:0]战斗y坐标2 **/
		public function get battleY2():int {
			if (__info.hasOwnProperty("battleY2")) return __info["battleY2"];
			return 0;
		}
		/** [默认:0]战斗上面y轴可视范围 **/
		public function get viewTopY():int {
			if (__info.hasOwnProperty("viewTopY")) return __info["viewTopY"];
			return 0;
		}
		/** [默认:0]战斗下面y轴可视范围 **/
		public function get viewBottomY():int {
			if (__info.hasOwnProperty("viewBottomY")) return __info["viewBottomY"];
			return 0;
		}
		/** [默认:0]战斗出现点1 : 战斗点 **/
		public function get battlePlayer1():int {
			if (__info.hasOwnProperty("battlePlayer1")) return __info["battlePlayer1"];
			return 0;
		}
		/** [默认:0]战斗出现点2 **/
		public function get battlePlayer2():int {
			if (__info.hasOwnProperty("battlePlayer2")) return __info["battlePlayer2"];
			return 0;
		}
		/** [默认:0]战斗出现点3 **/
		public function get battlePlayer3():int {
			if (__info.hasOwnProperty("battlePlayer3")) return __info["battlePlayer3"];
			return 0;
		}
		/** [默认:0]战斗出现点4 **/
		public function get battlePlayer4():int {
			if (__info.hasOwnProperty("battlePlayer4")) return __info["battlePlayer4"];
			return 0;
		}
		/** [默认:0]战后剧情ID **/
		public function get storyFinish():uint {
			if (__info.hasOwnProperty("storyFinish")) return __info["storyFinish"];
			return 0;
		}
		/** [默认:0]失败剧情 **/
		public function get storyFail():uint {
			if (__info.hasOwnProperty("storyFail")) return __info["storyFail"];
			return 0;
		}
		/** [默认:0]阵容2方召唤同场景的最大数量 **/
		public function get numMax():uint {
			if (__info.hasOwnProperty("numMax")) return __info["numMax"];
			return 0;
		}
		//--------------------------------------------------------------------------------------
		/** 对象引用的数据对象 **/
		private var __info:Object;
		
		/**
		 * UpGame关卡地图表
		 * @param	baseInfo			传入null逻辑上会有错误
		 */
		public function UpGameWarMap(baseInfo:Object):void
		{
			__info = baseInfo;
		}
		/**
		 * UpGame关卡地图表
		 * @param	baseInfo			传入null逻辑上会有错误
		 * @return
		 */
		public static function getThis(baseInfo:Object ):UpGameWarMap
		{
			return new UpGameWarMap(baseInfo);
		}
		
		/**
		 * 获取值,当缺少自动赋初始值
		 * @param	n
		 * @return
		 */
		private function __modelGet(n:String):*
		{
			if (__info.hasOwnProperty(n))
			{
				return __info[n];
			}
			return null;
		}
	}
}
