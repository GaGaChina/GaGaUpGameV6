package cn.wjj.upgame.data
{
	import flash.utils.ByteArray;
	/**
	 * UpGame技能效果数据
	 */
	public class UpGameSkillEffect
	{
		/** 索引字段 **/
		internal static var __keyList:Array = ["id"];
		/** [默认:0]技能作用效果id **/
		public function get id():uint {
			if (__info.hasOwnProperty("id")) return __info["id"];
			return 0;
		}
		/** [默认:0]有效目标 : 表示该技能会对什么样的目标产生效果 1-全体，2-友方，3-敌方，4-自己，5-坐标点 **/
		public function get effectTarget():uint {
			if (__info.hasOwnProperty("effectTarget")) return __info["effectTarget"];
			return 0;
		}
		/** [默认:0]作用类型 : 0-普通（作用一次的技能），1-持续产生效果的作用（燃烧弹），2-产生状态的作用， **/
		public function get type():uint {
			if (__info.hasOwnProperty("type")) return __info["type"];
			return 0;
		}
		/** [默认:0]作用次数 : 只有在持续产生效果与状态的作用时该字段才会生效，表示一个持续生效的技能会生效的次数； **/
		public function get count():uint {
			if (__info.hasOwnProperty("count")) return __info["count"];
			return 0;
		}
		/** [默认:0]作用时间 : 只有在持续产生效果与状态的作用时该字段才会生效，表示持续生效的间隔；间隔X次数=持续时间 **/
		public function get perTime():uint {
			if (__info.hasOwnProperty("perTime")) return __info["perTime"];
			return 0;
		}
		/** [默认:0]范围类型 : 0-锁定范围，锁定性的技能，1-范围技能（只有圆形）；注：状态类技能没有范围；对激光无效 **/
		public function get rangeType():uint {
			if (__info.hasOwnProperty("rangeType")) return __info["rangeType"];
			return 0;
		}
		/** [默认:0]范围半径 : 爆炸后该技能的范围半径，对激光无效 **/
		public function get rangeR():uint {
			if (__info.hasOwnProperty("rangeR")) return __info["rangeR"];
			return 0;
		}
		/** [默认:0]击中特效 : 根据作用类型确定特效播放的次数与位置，普通作用时以爆炸点为中心时播放一次；持续范围的作用以爆炸点为中心循环播放的特效；状态作用时以目标中心点为中心持续播放的特效； **/
		public function get hitEffect():uint {
			if (__info.hasOwnProperty("hitEffect")) return __info["hitEffect"];
			return 0;
		}
		/** [默认:0]击飞类型 : 击飞填像素,不击飞填0 **/
		public function get hitType():uint {
			if (__info.hasOwnProperty("hitType")) return __info["hitType"];
			return 0;
		}
		/** [默认:false]是否会被定住（冰冻等） : 0否1是 **/
		public function get isStop():Boolean {
			if (__info.hasOwnProperty("isStop")) return __info["isStop"];
			return false;
		}
		/** [默认:false]是否会被眩晕 : 0否1是 **/
		public function get isStun():Boolean {
			if (__info.hasOwnProperty("isStun")) return __info["isStun"];
			return false;
		}
		/** [默认:0]是否跟随目标移动 : 一般都填1 **/
		public function get effectLinkMove():uint {
			if (__info.hasOwnProperty("effectLinkMove")) return __info["effectLinkMove"];
			return 0;
		}
		/** [默认:0]是否根据目标进行缩放 : 一般都填1 **/
		public function get effectLinkScale():uint {
			if (__info.hasOwnProperty("effectLinkScale")) return __info["effectLinkScale"];
			return 0;
		}
		/** [默认:0]持续产生效果的击中特效 : 只有“作用类型”为1时，该字段有效，0和2无效 **/
		public function get effectListId():uint {
			if (__info.hasOwnProperty("effectListId")) return __info["effectListId"];
			return 0;
		}
		/** [默认:0]持续产生效果的击中特效是否跟随目标移动 : 一般都填1 **/
		public function get effectListLinkMove():uint {
			if (__info.hasOwnProperty("effectListLinkMove")) return __info["effectListLinkMove"];
			return 0;
		}
		/** [默认:0]持续产生效果的击中特效是否根据目标进行缩放 : 一般都填1 **/
		public function get effectListLinkScale():uint {
			if (__info.hasOwnProperty("effectListLinkScale")) return __info["effectListLinkScale"];
			return 0;
		}
		/** [默认:0]命中公式id : 挂接3个命中公式：1-必中，2-普通，3-封印，5-固定几率 **/
		public function get hitId():uint {
			if (__info.hasOwnProperty("hitId")) return __info["hitId"];
			return 0;
		}
		/** [默认:0]命中初始值 **/
		public function get hit():int {
			if (__info.hasOwnProperty("hit")) return __info["hit"];
			return 0;
		}
		/** [默认:0]命中升级增量 **/
		public function get hitUp():uint {
			if (__info.hasOwnProperty("hitUp")) return __info["hitUp"];
			return 0;
		}
		/** [默认:0]暴击公式id : 10-不暴击，11-一般暴击，12-治疗暴击 **/
		public function get critId():uint {
			if (__info.hasOwnProperty("critId")) return __info["critId"];
			return 0;
		}
		/** [默认:0]暴击率初始值 : 百分比10000 **/
		public function get crit():int {
			if (__info.hasOwnProperty("crit")) return __info["crit"];
			return 0;
		}
		/** [默认:0]暴击率升级增量 : 百分比10000 **/
		public function get critUp():uint {
			if (__info.hasOwnProperty("critUp")) return __info["critUp"];
			return 0;
		}
		/** [默认:0]暴击伤害初始值 **/
		public function get critHurt():int {
			if (__info.hasOwnProperty("critHurt")) return __info["critHurt"];
			return 0;
		}
		/** [默认:0]附加暴击伤害增量 **/
		public function get critHurtUp():uint {
			if (__info.hasOwnProperty("critHurtUp")) return __info["critHurtUp"];
			return 0;
		}
		/** [默认:0]效果公式id : 13战斗系统（战斗规则，主动技能释放）—战斗技能说明1 **/
		public function get effectId():uint {
			if (__info.hasOwnProperty("effectId")) return __info["effectId"];
			return 0;
		}
		/** [默认:0]改变属性id : （1-攻击(秒伤)，2-攻击速度，3-移动速度，4-防御，5-攻击增强，6-治疗增强，7-防御比例，8-被治疗增强，9命中，10-回避，11-暴击，12-暴击伤害，13-韧性，14-暴击抵抗，15-封命，16-封抗，22-视野范围） **/
		public function get attributeType():uint {
			if (__info.hasOwnProperty("attributeType")) return __info["attributeType"];
			return 0;
		}
		/** [默认:0]效果倍率初始值 : 这个值是已经乘过10000的 **/
		public function get effectX():int {
			if (__info.hasOwnProperty("effectX")) return __info["effectX"];
			return 0;
		}
		/** [默认:0]效果倍率升级增量 : 召唤物存活时间,单位ms **/
		public function get effectXUp():uint {
			if (__info.hasOwnProperty("effectXUp")) return __info["effectXUp"];
			return 0;
		}
		/** [默认:0]效果偏移初始值 : 移动速度为像素单位 **/
		public function get effect():int {
			if (__info.hasOwnProperty("effect")) return __info["effect"];
			return 0;
		}
		/** [默认:0]效果偏移升级增量 **/
		public function get effectUp():uint {
			if (__info.hasOwnProperty("effectUp")) return __info["effectUp"];
			return 0;
		}
		/** [默认:0]删除目标状态类型1 : 该子弹击中目标后会移除的状态类型（例如可以治疗中毒的技能） **/
		public function get buffDel():uint {
			if (__info.hasOwnProperty("buffDel")) return __info["buffDel"];
			return 0;
		}
		/** [默认:0]删除全部状态 : 填1有效，增益和减益全部删除 **/
		public function get buffClear():uint {
			if (__info.hasOwnProperty("buffClear")) return __info["buffClear"];
			return 0;
		}
		/** [默认:0]状态类型 : 该技能状态类型 **/
		public function get buffType():uint {
			if (__info.hasOwnProperty("buffType")) return __info["buffType"];
			return 0;
		}
		/** [默认:0]仇恨系数 : 近战50000，冲锋50000，其他10000 **/
		public function get hatred():uint {
			if (__info.hasOwnProperty("hatred")) return __info["hatred"];
			return 0;
		}
		/** [默认:false]是否对地 : 效果是否对地面单位起作用 **/
		public function get AttacksGround():Boolean {
			if (__info.hasOwnProperty("AttacksGround")) return __info["AttacksGround"];
			return false;
		}
		/** [默认:false]是否对空 : 效果是否对空中单位起作用 **/
		public function get AttacksAir():Boolean {
			if (__info.hasOwnProperty("AttacksAir")) return __info["AttacksAir"];
			return false;
		}
		/** [默认:false]是否对建筑 : 效果目标是否对建筑起作用 **/
		public function get AttacksBuildings():Boolean {
			if (__info.hasOwnProperty("AttacksBuildings")) return __info["AttacksBuildings"];
			return false;
		}
		/** [默认:false]是否对基地 : 效果目标是否对基地起作用 **/
		public function get AttacksBases():Boolean {
			if (__info.hasOwnProperty("AttacksBases")) return __info["AttacksBases"];
			return false;
		}
		/** [默认:0]召唤物ID : 当卡牌是技能时(即无模型时)，召唤出的怪物id，比如：哥布林桶 **/
		public function get SpawnID():uint {
			if (__info.hasOwnProperty("SpawnID")) return __info["SpawnID"];
			return 0;
		}
		//--------------------------------------------------------------------------------------
		/** 对象引用的数据对象 **/
		private var __info:Object;
		
		/**
		 * UpGame技能效果数据
		 * @param	baseInfo			传入null逻辑上会有错误
		 */
		public function UpGameSkillEffect(baseInfo:Object):void
		{
			__info = baseInfo;
		}
		/**
		 * UpGame技能效果数据
		 * @param	baseInfo			传入null逻辑上会有错误
		 * @return
		 */
		public static function getThis(baseInfo:Object ):UpGameSkillEffect
		{
			return new UpGameSkillEffect(baseInfo);
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
