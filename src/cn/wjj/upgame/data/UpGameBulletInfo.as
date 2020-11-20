package cn.wjj.upgame.data
{
	import flash.utils.ByteArray;
	/**
	 * 子弹数据模型
	 */
	public class UpGameBulletInfo
	{
		/** 索引字段 **/
		internal static var __keyList:Array = ["id"];
		/** [默认:0]子弹Id **/
		public function get id():uint {
			if (__info.hasOwnProperty("id")) return __info["id"];
			return 0;
		}
		/** [默认:0]透明时间 : 子弹发射出时的透明时间；单位：毫秒 **/
		public function get alphaTime():uint {
			if (__info.hasOwnProperty("alphaTime")) return __info["alphaTime"];
			return 0;
		}
		/** [默认:0]子弹类型 : 1-普通，2-扇形散弹 **/
		public function get type():uint {
			if (__info.hasOwnProperty("type")) return __info["type"];
			return 0;
		}
		/** [默认:0]散弹发射角度 : 多颗子弹发射时之间的夹角（中心子弹的位置与目标中心点有关） **/
		public function get angle():uint {
			if (__info.hasOwnProperty("angle")) return __info["angle"];
			return 0;
		}
		/** [默认:0]发射弹数 : 一次发射出散弹数，角度x弹数若=360，则弹数可为偶数，否则为奇数 **/
		public function get count():uint {
			if (__info.hasOwnProperty("count")) return __info["count"];
			return 0;
		}
		/** [默认:0]特效Id **/
		public function get pathId():uint {
			if (__info.hasOwnProperty("pathId")) return __info["pathId"];
			return 0;
		}
		/** [默认:0]特效类型 : 0-无图,1-U2,2-PNG,3-JPG **/
		public function get pathType():uint {
			if (__info.hasOwnProperty("pathType")) return __info["pathType"];
			return 0;
		}
		/** [默认:false]特效是否需要旋转 : 特效是否需要根据方向旋转,0不需要,1需要 **/
		public function get isRotate():Boolean {
			if (__info.hasOwnProperty("isRotate")) return __info["isRotate"];
			return false;
		}
		/** [默认:0]子弹最大速度 : 单位像素/秒 **/
		public function get speed():uint {
			if (__info.hasOwnProperty("speed")) return __info["speed"];
			return 0;
		}
		/** [默认:0]子弹启动速度 : 单位像素/秒 **/
		public function get startSpeed():uint {
			if (__info.hasOwnProperty("startSpeed")) return __info["startSpeed"];
			return 0;
		}
		/** [默认:0]子弹加速度 : 单位像素/秒平方 **/
		public function get acceleration():uint {
			if (__info.hasOwnProperty("acceleration")) return __info["acceleration"];
			return 0;
		}
		/** [默认:0]轨迹类型 : 0-无弹道，1-基本弹道（匀速），2-基本弹道（加速）；3-碰撞弹道（匀速）；4-碰撞弹道（加速）；5-抛物线弹道，6-穿透弹道（匀速），7-穿透弹道（加速），8-光线弹道（激光） **/
		public function get track():uint {
			if (__info.hasOwnProperty("track")) return __info["track"];
			return 0;
		}
		/** [默认:0]落地特效ID **/
		public function get missileRangeEffect():uint {
			if (__info.hasOwnProperty("missileRangeEffect")) return __info["missileRangeEffect"];
			return 0;
		}
		/** [默认:0]子弹半径 : 该字段数值由美术提供 **/
		public function get radius():uint {
			if (__info.hasOwnProperty("radius")) return __info["radius"];
			return 0;
		}
		/** [默认:0]子弹穿透目标数量上限 : 只有轨迹类型为6、7的时候穿透数量才有效 **/
		public function get hitTimes():uint {
			if (__info.hasOwnProperty("hitTimes")) return __info["hitTimes"];
			return 0;
		}
		/** [默认:0]散弹偏移角度 **/
		public function get angle1():uint {
			if (__info.hasOwnProperty("angle1")) return __info["angle1"];
			return 0;
		}
		//--------------------------------------------------------------------------------------
		/** 对象引用的数据对象 **/
		private var __info:Object;
		
		/**
		 * 子弹数据模型
		 * @param	baseInfo			传入null逻辑上会有错误
		 */
		public function UpGameBulletInfo(baseInfo:Object):void
		{
			__info = baseInfo;
		}
		/**
		 * 子弹数据模型
		 * @param	baseInfo			传入null逻辑上会有错误
		 * @return
		 */
		public static function getThis(baseInfo:Object ):UpGameBulletInfo
		{
			return new UpGameBulletInfo(baseInfo);
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
