package cn.wjj.upgame.data
{
	import flash.utils.ByteArray;
	/**
	 * 主动技能
	 */
	public class SkillActiveModel
	{
		/** 索引字段 **/
		internal static var __keyList:Array = [];
		/** [默认:0]技能id **/
		public function get id():uint {
			if (__info.hasOwnProperty("id")) return __info["id"];
			return 0;
		}
		/** [默认:0]技能名称id : 技能的名称id，用于显示 **/
		public function get Name():uint {
			if (__info.hasOwnProperty("Name")) return __info["Name"];
			return 0;
		}
		/** [默认:0]技能描述id : 技能的描述id，用于显示 **/
		public function get describe():uint {
			if (__info.hasOwnProperty("describe")) return __info["describe"];
			return 0;
		}
		/** [默认:0]技能成长描述1id **/
		public function get describe1():uint {
			if (__info.hasOwnProperty("describe1")) return __info["describe1"];
			return 0;
		}
		/** [默认:0]初始效果值1 : 显示效果，表示该技能0级的数值 **/
		public function get effect1():uint {
			if (__info.hasOwnProperty("effect1")) return __info["effect1"];
			return 0;
		}
		/** [默认:0]升级效果值1 : 显示效果，表示该技能每升一级所增加的数值 **/
		public function get effectup1():uint {
			if (__info.hasOwnProperty("effectup1")) return __info["effectup1"];
			return 0;
		}
		/** [默认:0]效果值格式1 : 1-正常数值，2-百分比（计算出的数字/100） **/
		public function get geshi1():uint {
			if (__info.hasOwnProperty("geshi1")) return __info["geshi1"];
			return 0;
		}
		/** [默认:0]技能成长描述2id : 一个技能有2个成长效果时才用到描述2 **/
		public function get describe2():uint {
			if (__info.hasOwnProperty("describe2")) return __info["describe2"];
			return 0;
		}
		/** [默认:0]初始效果值2 : 显示效果，表示该技能0级的数值 **/
		public function get effect2():uint {
			if (__info.hasOwnProperty("effect2")) return __info["effect2"];
			return 0;
		}
		/** [默认:0]升级效果值2 : 显示效果，表示该技能每升一级所增加的数值 **/
		public function get effectup2():uint {
			if (__info.hasOwnProperty("effectup2")) return __info["effectup2"];
			return 0;
		}
		/** [默认:0]效果值格式2 : 1-正常数值，2-百分比（计算出的数字/100） **/
		public function get geshi2():uint {
			if (__info.hasOwnProperty("geshi2")) return __info["geshi2"];
			return 0;
		}
		/** [默认:0]升级类型 : 技能升级所使用的花费曲线类型，该表中会填写相关的消费； **/
		public function get lvUpType():uint {
			if (__info.hasOwnProperty("lvUpType")) return __info["lvUpType"];
			return 0;
		}
		/** [默认:0]技能图标 **/
		public function get image():uint {
			if (__info.hasOwnProperty("image")) return __info["image"];
			return 0;
		}
		/** [默认:0]技能类型 : 是普通攻击或者是普通技能，1-普攻，2-普技 **/
		public function get type():uint {
			if (__info.hasOwnProperty("type")) return __info["type"];
			return 0;
		}
		/** [默认:0]技能动作id **/
		public function get actionId():uint {
			if (__info.hasOwnProperty("actionId")) return __info["actionId"];
			return 0;
		}
		/** [默认:0]射程 : 单位像素，人的技能射程填1手动能放出来，怪的技能填1自动则放不出来 **/
		public function get range():uint {
			if (__info.hasOwnProperty("range")) return __info["range"];
			return 0;
		}
		/** [默认:0]最小射程 : 技能的最小射程，即射击盲区 **/
		public function get MinimumRange():uint {
			if (__info.hasOwnProperty("MinimumRange")) return __info["MinimumRange"];
			return 0;
		}
		/** [默认:0]目标类型 : 0-当前目标，1-己方血少，2-敌方血少，3-随机位置，4-当前方向，5-自己，6-随机目标，120-己方血在20%以下,将对射程范围内己方全体治疗(血液的比例, 射程范围内出现血少于20%目标) **/
		public function get goalType():uint {
			if (__info.hasOwnProperty("goalType")) return __info["goalType"];
			return 0;
		}
		/** [默认:0]目标数量 : 目标类型为4、5时，该字段无效 **/
		public function get count():uint {
			if (__info.hasOwnProperty("count")) return __info["count"];
			return 0;
		}
		/** [默认:0]有预警范围提示 : 当前没启用 **/
		public function get alarm():uint {
			if (__info.hasOwnProperty("alarm")) return __info["alarm"];
			return 0;
		}
		/** [默认:0]技能cd : 技能的冷却时间，技能释放一次后再次释放的时间（普通攻击的技能这个cd是没有用的） **/
		public function get cd():uint {
			if (__info.hasOwnProperty("cd")) return __info["cd"];
			return 0;
		}
		/** [默认:0]技能初始cd : 战斗开始后第一次使用该技能的时间 **/
		public function get cdStart():uint {
			if (__info.hasOwnProperty("cdStart")) return __info["cdStart"];
			return 0;
		}
		/** [默认:0]允许点击施放次数 : 点多少次以后该技能进入CD **/
		public function get hitCount():uint {
			if (__info.hasOwnProperty("hitCount")) return __info["hitCount"];
			return 0;
		}
		/** [默认:0]允许点击的时间区间 : 类似PA的B技能，持续3秒或4次攻击(毫秒) **/
		public function get hitTime():uint {
			if (__info.hasOwnProperty("hitTime")) return __info["hitTime"];
			return 0;
		}
		/** [默认:0]每次点击的间隔CD : 此字段已废(毫秒) **/
		public function get hitCd():uint {
			if (__info.hasOwnProperty("hitCd")) return __info["hitCd"];
			return 0;
		}
		/** [默认:0]技能循环持续次数 : 是否为循环施法技能，如果是则该技能释放时会重复动作中的循环序列,-1-不循环,0-无限循环,其他数字标识循环次数 **/
		public function get loop():int {
			if (__info.hasOwnProperty("loop")) return __info["loop"];
			return 0;
		}
		/** [默认:0]循环执行的单次时间 : 美术提供(毫秒) **/
		public function get loopTime():uint {
			if (__info.hasOwnProperty("loopTime")) return __info["loopTime"];
			return 0;
		}
		/** [默认:0]技能特殊效果类型 : 0普通，1冲锋，2竖向激光，3旋风斩，4横向激光，5定点冲锋 **/
		public function get specialType():uint {
			if (__info.hasOwnProperty("specialType")) return __info["specialType"];
			return 0;
		}
		/** [默认:false]死亡时触发 : 0否1是 **/
		public function get death():Boolean {
			if (__info.hasOwnProperty("death")) return __info["death"];
			return false;
		}
		/** [默认:0]技能释放定格动画类型 : 后4个为新加字段，照填就行 **/
		public function get freezeType():uint {
			if (__info.hasOwnProperty("freezeType")) return __info["freezeType"];
			return 0;
		}
		/** [默认:0]技能释放定格动震动延后时间(毫秒) **/
		public function get freezeShockStart():uint {
			if (__info.hasOwnProperty("freezeShockStart")) return __info["freezeShockStart"];
			return 0;
		}
		/** [默认:0]技能释放定格动震动时长(毫秒) **/
		public function get freezeShockLength():uint {
			if (__info.hasOwnProperty("freezeShockLength")) return __info["freezeShockLength"];
			return 0;
		}
		/** [默认:0]技能释放定格动震动类型 : 1小震动，2中震动，3大震动 **/
		public function get freezeShockType():uint {
			if (__info.hasOwnProperty("freezeShockType")) return __info["freezeShockType"];
			return 0;
		}
		/** [默认:0]是否使用动作表的目标类型 : 0否1是，填1则使用技能动作表中的目标类型 **/
		public function get goalUseType():uint {
			if (__info.hasOwnProperty("goalUseType")) return __info["goalUseType"];
			return 0;
		}
		/** [默认:0]技能定格特效 : 0,没有,-1超大定格动画(不受位置控制),大于0,特定的U2 **/
		public function get bigEffect():int {
			if (__info.hasOwnProperty("bigEffect")) return __info["bigEffect"];
			return 0;
		}
		/** [默认:0]定格特效位置 : 0,不跟踪,1,锁定释放者位置,2,锁定目标位置释放 **/
		public function get bigEffectPos():uint {
			if (__info.hasOwnProperty("bigEffectPos")) return __info["bigEffectPos"];
			return 0;
		}
		/** [默认:false]是否对地 : 攻击是否对地面单位有效 **/
		public function get AttacksGround():Boolean {
			if (__info.hasOwnProperty("AttacksGround")) return __info["AttacksGround"];
			return false;
		}
		/** [默认:false]是否对空 : 攻击是否对空中单位有效 **/
		public function get AttacksAir():Boolean {
			if (__info.hasOwnProperty("AttacksAir")) return __info["AttacksAir"];
			return false;
		}
		/** [默认:false]是否对建筑 : 攻击目标是否对建筑 **/
		public function get AttacksBuildings():Boolean {
			if (__info.hasOwnProperty("AttacksBuildings")) return __info["AttacksBuildings"];
			return false;
		}
		/** [默认:false]是否对基地 : 攻击目标是否对基地 **/
		public function get AttacksBases():Boolean {
			if (__info.hasOwnProperty("AttacksBases")) return __info["AttacksBases"];
			return false;
		}
		/** [默认:false]启动技能 : 英雄初始化的时候自动释放的技能 **/
		public function get startUp():Boolean {
			if (__info.hasOwnProperty("startUp")) return __info["startUp"];
			return false;
		}
		//--------------------------------------------------------------------------------------
		/** 对象引用的数据对象 **/
		private var __info:Object;
		
		/**
		 * 主动技能
		 * @param	baseInfo			传入null逻辑上会有错误
		 */
		public function SkillActiveModel(baseInfo:Object):void
		{
			__info = baseInfo;
		}
		/**
		 * 主动技能
		 * @param	baseInfo			传入null逻辑上会有错误
		 * @return
		 */
		public static function getThis(baseInfo:Object ):SkillActiveModel
		{
			return new SkillActiveModel(baseInfo);
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
