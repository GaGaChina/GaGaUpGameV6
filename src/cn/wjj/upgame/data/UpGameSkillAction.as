package cn.wjj.upgame.data
{
	import flash.utils.ByteArray;
	/**
	 * UpGame技能动作数据
	 */
	public class UpGameSkillAction
	{
		/** 索引字段 **/
		internal static var __keyList:Array = ["id"];
		/** [默认:0]技能动作Id : 技能动作的id，这个id在技能表中填写，与相关的技能进行关联表示该技能释放时会使用的动作； **/
		public function get id():uint {
			if (__info.hasOwnProperty("id")) return __info["id"];
			return 0;
		}
		/** [默认:false]是否可以循环 : 这个技能动作是否有循环，是循环的技能动作在攻击时会循环播放一段循环的动画；注：循环的次数需要通过技能数据确定 **/
		public function get circle():Boolean {
			if (__info.hasOwnProperty("circle")) return __info["circle"];
			return false;
		}
		/** [默认:0]循环开始时间点 : 循环动画开始的时间点，这个时间点是一个动作中的一个时间点 **/
		public function get start():uint {
			if (__info.hasOwnProperty("start")) return __info["start"];
			return 0;
		}
		/** [默认:0]循环结束时间点 : 循环动画结束的时间点， **/
		public function get end():uint {
			if (__info.hasOwnProperty("end")) return __info["end"];
			return 0;
		}
		/** [默认:false]是否为组合动作 : 是组合动作的动作，会有多个打击时间和不同的打击点，例如劳拉的双枪攻击就是两个不同的攻击时间点和两个发射点（参照刀塔传奇里面熊猫的大招）；如果为否则只有攻击时间点1会生效 **/
		public function get combo():Boolean {
			if (__info.hasOwnProperty("combo")) return __info["combo"];
			return false;
		}
		/** [默认:0]技能总时间（毫秒） : 角色的普攻技能总时间填写角色卡牌表“攻击间隔”+100，大招总时间看编辑器总时间 **/
		public function get playTime():uint {
			if (__info.hasOwnProperty("playTime")) return __info["playTime"];
			return 0;
		}
		/** [默认:false]是否会强制播完 : 0-否,1-是，填1则该动作一定会按技能总时间播放完毕，期间玩家操作被屏蔽无效。 **/
		public function get lockPlay():Boolean {
			if (__info.hasOwnProperty("lockPlay")) return __info["lockPlay"];
			return false;
		}
		/** [默认:0]攻击时间点1 : 这个动作第一次子弹发出的时间点 **/
		public function get time1():uint {
			if (__info.hasOwnProperty("time1")) return __info["time1"];
			return 0;
		}
		/** [默认:0]时间点1所用发射点 : 这个动作第一发自动发射所使用的子弹发射点（目前最多有两个发射点，劳拉的双枪） **/
		public function get time1point():uint {
			if (__info.hasOwnProperty("time1point")) return __info["time1point"];
			return 0;
		}
		/** [默认:0]时间点1发射的效果链接的id : 本次发射所用子弹的id **/
		public function get time1skill():uint {
			if (__info.hasOwnProperty("time1skill")) return __info["time1skill"];
			return 0;
		}
		/** [默认:0]时间点1目标类型 : 0-当前目标，1-己方血少，2-敌方血少，3-随机位置，4-当前方向，5-自己 **/
		public function get goalType1():uint {
			if (__info.hasOwnProperty("goalType1")) return __info["goalType1"];
			return 0;
		}
		/** [默认:0]攻击时间点2 **/
		public function get time2():uint {
			if (__info.hasOwnProperty("time2")) return __info["time2"];
			return 0;
		}
		/** [默认:0]时间点2所用发射点 **/
		public function get time2point():uint {
			if (__info.hasOwnProperty("time2point")) return __info["time2point"];
			return 0;
		}
		/** [默认:0]时间点2发射的效果链接的id **/
		public function get time2skill():uint {
			if (__info.hasOwnProperty("time2skill")) return __info["time2skill"];
			return 0;
		}
		/** [默认:0]时间点2目标类型 **/
		public function get goalType2():uint {
			if (__info.hasOwnProperty("goalType2")) return __info["goalType2"];
			return 0;
		}
		/** [默认:0]攻击时间点3 **/
		public function get time3():uint {
			if (__info.hasOwnProperty("time3")) return __info["time3"];
			return 0;
		}
		/** [默认:0]时间点3所用发射点 **/
		public function get time3point():uint {
			if (__info.hasOwnProperty("time3point")) return __info["time3point"];
			return 0;
		}
		/** [默认:0]时间点3发射的效果链接的id **/
		public function get time3skill():uint {
			if (__info.hasOwnProperty("time3skill")) return __info["time3skill"];
			return 0;
		}
		/** [默认:0]时间点3目标类型 **/
		public function get goalType3():uint {
			if (__info.hasOwnProperty("goalType3")) return __info["goalType3"];
			return 0;
		}
		/** [默认:0]攻击时间点4 **/
		public function get time4():uint {
			if (__info.hasOwnProperty("time4")) return __info["time4"];
			return 0;
		}
		/** [默认:0]时间点4所用发射点 **/
		public function get time4point():uint {
			if (__info.hasOwnProperty("time4point")) return __info["time4point"];
			return 0;
		}
		/** [默认:0]时间点4发射的效果链接的id **/
		public function get time4skill():uint {
			if (__info.hasOwnProperty("time4skill")) return __info["time4skill"];
			return 0;
		}
		/** [默认:0]时间点4目标类型 **/
		public function get goalType4():uint {
			if (__info.hasOwnProperty("goalType4")) return __info["goalType4"];
			return 0;
		}
		/** [默认:0]攻击时间点5 **/
		public function get time5():uint {
			if (__info.hasOwnProperty("time5")) return __info["time5"];
			return 0;
		}
		/** [默认:0]时间点5所用发射点 **/
		public function get time5point():uint {
			if (__info.hasOwnProperty("time5point")) return __info["time5point"];
			return 0;
		}
		/** [默认:0]时间点5发射的效果链接的id **/
		public function get time5skill():uint {
			if (__info.hasOwnProperty("time5skill")) return __info["time5skill"];
			return 0;
		}
		/** [默认:0]时间点5目标类型 **/
		public function get goalType5():uint {
			if (__info.hasOwnProperty("goalType5")) return __info["goalType5"];
			return 0;
		}
		/** [默认:0]屏幕震动时间点1 **/
		public function get shaketime1():uint {
			if (__info.hasOwnProperty("shaketime1")) return __info["shaketime1"];
			return 0;
		}
		/** [默认:0]时间点1时的震动类型 : 1全地图震动，2地图内的层，3层和地图一起震 **/
		public function get shaketype1():uint {
			if (__info.hasOwnProperty("shaketype1")) return __info["shaketype1"];
			return 0;
		}
		/** [默认:0]时间点1时的震动持续时间（毫秒） **/
		public function get shakeLength1():uint {
			if (__info.hasOwnProperty("shakeLength1")) return __info["shakeLength1"];
			return 0;
		}
		/** [默认:0]时间点1时的震动x轴比例值 **/
		public function get shakeX1():uint {
			if (__info.hasOwnProperty("shakeX1")) return __info["shakeX1"];
			return 0;
		}
		/** [默认:0]时间点1时的震动y轴比例值 **/
		public function get shakeY1():uint {
			if (__info.hasOwnProperty("shakeY1")) return __info["shakeY1"];
			return 0;
		}
		/** [默认:0]屏幕震动时间点2 **/
		public function get shaketime2():uint {
			if (__info.hasOwnProperty("shaketime2")) return __info["shaketime2"];
			return 0;
		}
		/** [默认:0]时间点2时的震动类型 : 1全地图震动，2地图内的层，3层和地图一起震 **/
		public function get shaketype2():uint {
			if (__info.hasOwnProperty("shaketype2")) return __info["shaketype2"];
			return 0;
		}
		/** [默认:0]时间点2时的震动持续时间（毫秒） **/
		public function get shakeLength2():uint {
			if (__info.hasOwnProperty("shakeLength2")) return __info["shakeLength2"];
			return 0;
		}
		/** [默认:0]时间点2时的震动x轴比例值 **/
		public function get shakeX2():uint {
			if (__info.hasOwnProperty("shakeX2")) return __info["shakeX2"];
			return 0;
		}
		/** [默认:0]时间点2时的震动y轴比例值 **/
		public function get shakeY2():uint {
			if (__info.hasOwnProperty("shakeY2")) return __info["shakeY2"];
			return 0;
		}
		/** [默认:0]屏幕震动时间点3 **/
		public function get shaketime3():uint {
			if (__info.hasOwnProperty("shaketime3")) return __info["shaketime3"];
			return 0;
		}
		/** [默认:0]时间点3时的震动类型 : 1全地图震动，2地图内的层，3层和地图一起震 **/
		public function get shaketype3():uint {
			if (__info.hasOwnProperty("shaketype3")) return __info["shaketype3"];
			return 0;
		}
		/** [默认:0]时间点3时的震动持续时间（毫秒） **/
		public function get shakeLength3():uint {
			if (__info.hasOwnProperty("shakeLength3")) return __info["shakeLength3"];
			return 0;
		}
		/** [默认:0]时间点3时的震动x轴比例值 **/
		public function get shakeX3():uint {
			if (__info.hasOwnProperty("shakeX3")) return __info["shakeX3"];
			return 0;
		}
		/** [默认:0]时间点3时的震动y轴比例值 **/
		public function get shakeY3():uint {
			if (__info.hasOwnProperty("shakeY3")) return __info["shakeY3"];
			return 0;
		}
		/** [默认:0]屏幕震动时间点4 **/
		public function get shaketime4():uint {
			if (__info.hasOwnProperty("shaketime4")) return __info["shaketime4"];
			return 0;
		}
		/** [默认:0]时间点4时的震动类型 : 1全地图震动，2地图内的层，3层和地图一起震 **/
		public function get shaketype4():uint {
			if (__info.hasOwnProperty("shaketype4")) return __info["shaketype4"];
			return 0;
		}
		/** [默认:0]时间点4时的震动持续时间（毫秒） **/
		public function get shakeLength4():uint {
			if (__info.hasOwnProperty("shakeLength4")) return __info["shakeLength4"];
			return 0;
		}
		/** [默认:0]时间点4时的震动x轴比例值 **/
		public function get shakeX4():uint {
			if (__info.hasOwnProperty("shakeX4")) return __info["shakeX4"];
			return 0;
		}
		/** [默认:0]时间点4时的震动y轴比例值 **/
		public function get shakeY4():uint {
			if (__info.hasOwnProperty("shakeY4")) return __info["shakeY4"];
			return 0;
		}
		/** [默认:0]屏幕震动时间点5 **/
		public function get shaketime5():uint {
			if (__info.hasOwnProperty("shaketime5")) return __info["shaketime5"];
			return 0;
		}
		/** [默认:0]时间点5时的震动类型 : 1全地图震动，2地图内的层，3层和地图一起震 **/
		public function get shaketype5():uint {
			if (__info.hasOwnProperty("shaketype5")) return __info["shaketype5"];
			return 0;
		}
		/** [默认:0]时间点5时的震动持续时间（毫秒） **/
		public function get shakeLength5():uint {
			if (__info.hasOwnProperty("shakeLength5")) return __info["shakeLength5"];
			return 0;
		}
		/** [默认:0]时间点5时的震动x轴比例值 **/
		public function get shakeX5():uint {
			if (__info.hasOwnProperty("shakeX5")) return __info["shakeX5"];
			return 0;
		}
		/** [默认:0]时间点5时的震动y轴比例值 **/
		public function get shakeY5():uint {
			if (__info.hasOwnProperty("shakeY5")) return __info["shakeY5"];
			return 0;
		}
		//--------------------------------------------------------------------------------------
		/** 对象引用的数据对象 **/
		private var __info:Object;
		
		/**
		 * UpGame技能动作数据
		 * @param	baseInfo			传入null逻辑上会有错误
		 */
		public function UpGameSkillAction(baseInfo:Object):void
		{
			__info = baseInfo;
		}
		/**
		 * UpGame技能动作数据
		 * @param	baseInfo			传入null逻辑上会有错误
		 * @return
		 */
		public static function getThis(baseInfo:Object ):UpGameSkillAction
		{
			return new UpGameSkillAction(baseInfo);
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
