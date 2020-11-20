package cn.wjj.upgame.data
{
	import flash.utils.ByteArray;
	/**
	 * 怪物属性表
	 */
	public class MonsterAttributeModel
	{
		/** 索引字段 **/
		internal static var __keyList:Array = ["Id"];
		/** [默认:0]怪物id **/
		public function get Id():int {
			if (__info.hasOwnProperty("Id")) return __info["Id"];
			return 0;
		}
		/** [默认:0]类型 **/
		public function get Type():int {
			if (__info.hasOwnProperty("Type")) return __info["Type"];
			return 0;
		}
		/** [默认:0]怪物形象 : 模型ID，取自模型数据表 **/
		public function get Card():int {
			if (__info.hasOwnProperty("Card")) return __info["Card"];
			return 0;
		}
		/** [默认:0]是否为boss : 是否为boss、用于显示，boss类的卡牌在战斗中会以大卡牌的样式 **/
		public function get Boss():int {
			if (__info.hasOwnProperty("Boss")) return __info["Boss"];
			return 0;
		}
		/** [默认:0]攻击 **/
		public function get Att():int {
			if (__info.hasOwnProperty("Att")) return __info["Att"];
			return 0;
		}
		/** [默认:0]标准攻击间隔 **/
		public function get rate():int {
			if (__info.hasOwnProperty("rate")) return __info["rate"];
			return 0;
		}
		/** [默认:0]防御 **/
		public function get def():int {
			if (__info.hasOwnProperty("def")) return __info["def"];
			return 0;
		}
		/** [默认:0]生命 **/
		public function get Hp():int {
			if (__info.hasOwnProperty("Hp")) return __info["Hp"];
			return 0;
		}
		/** [默认:0]攻击间隔 **/
		public function get attsp():int {
			if (__info.hasOwnProperty("attsp")) return __info["attsp"];
			return 0;
		}
		/** [默认:0]移动速度 **/
		public function get Sp():int {
			if (__info.hasOwnProperty("Sp")) return __info["Sp"];
			return 0;
		}
		/** [默认:0]命中 **/
		public function get Hit():int {
			if (__info.hasOwnProperty("Hit")) return __info["Hit"];
			return 0;
		}
		/** [默认:0]回避 **/
		public function get Dod():int {
			if (__info.hasOwnProperty("Dod")) return __info["Dod"];
			return 0;
		}
		/** [默认:0]封命 **/
		public function get seal():int {
			if (__info.hasOwnProperty("seal")) return __info["seal"];
			return 0;
		}
		/** [默认:0]封抗 **/
		public function get sealres():int {
			if (__info.hasOwnProperty("sealres")) return __info["sealres"];
			return 0;
		}
		/** [默认:0]暴击率 **/
		public function get lethality():int {
			if (__info.hasOwnProperty("lethality")) return __info["lethality"];
			return 0;
		}
		/** [默认:0]韧性 **/
		public function get tenacity():int {
			if (__info.hasOwnProperty("tenacity")) return __info["tenacity"];
			return 0;
		}
		/** [默认:0]暴击伤害值 **/
		public function get Finjury():int {
			if (__info.hasOwnProperty("Finjury")) return __info["Finjury"];
			return 0;
		}
		/** [默认:0]暴击抵抗 **/
		public function get finjuryres():int {
			if (__info.hasOwnProperty("finjuryres")) return __info["finjuryres"];
			return 0;
		}
		/** [默认:0]攻击增强 **/
		public function get attX():int {
			if (__info.hasOwnProperty("attX")) return __info["attX"];
			return 0;
		}
		/** [默认:0]生命增强 **/
		public function get hpX():int {
			if (__info.hasOwnProperty("hpX")) return __info["hpX"];
			return 0;
		}
		/** [默认:0]攻速修正 **/
		public function get attspX():int {
			if (__info.hasOwnProperty("attspX")) return __info["attspX"];
			return 0;
		}
		/** [默认:0]治疗增强 **/
		public function get cureX():int {
			if (__info.hasOwnProperty("cureX")) return __info["cureX"];
			return 0;
		}
		/** [默认:0]防御比例 **/
		public function get defx():int {
			if (__info.hasOwnProperty("defx")) return __info["defx"];
			return 0;
		}
		/** [默认:0]被治疗比例 **/
		public function get betreated():int {
			if (__info.hasOwnProperty("betreated")) return __info["betreated"];
			return 0;
		}
		/** [默认:0]再生值 **/
		public function get Regenerationvalue():int {
			if (__info.hasOwnProperty("Regenerationvalue")) return __info["Regenerationvalue"];
			return 0;
		}
		/** [默认:0]技能1初始cd降低值 **/
		public function get initialcdreduce1():int {
			if (__info.hasOwnProperty("initialcdreduce1")) return __info["initialcdreduce1"];
			return 0;
		}
		/** [默认:0]技能2初始cd降低值 **/
		public function get initialcdreduce2():int {
			if (__info.hasOwnProperty("initialcdreduce2")) return __info["initialcdreduce2"];
			return 0;
		}
		/** [默认:0]技能3初始cd降低值 **/
		public function get initialcdreduce3():int {
			if (__info.hasOwnProperty("initialcdreduce3")) return __info["initialcdreduce3"];
			return 0;
		}
		/** [默认:0]技能4初始cd降低值 **/
		public function get initialcdreduce4():int {
			if (__info.hasOwnProperty("initialcdreduce4")) return __info["initialcdreduce4"];
			return 0;
		}
		/** [默认:0]技能1cd降低值 **/
		public function get cdreduce1():int {
			if (__info.hasOwnProperty("cdreduce1")) return __info["cdreduce1"];
			return 0;
		}
		/** [默认:0]技能2cd降低值 **/
		public function get cdreduce2():int {
			if (__info.hasOwnProperty("cdreduce2")) return __info["cdreduce2"];
			return 0;
		}
		/** [默认:0]技能3cd降低值 **/
		public function get cdreduce3():int {
			if (__info.hasOwnProperty("cdreduce3")) return __info["cdreduce3"];
			return 0;
		}
		/** [默认:0]技能4cd降低值 **/
		public function get cdreduce4():int {
			if (__info.hasOwnProperty("cdreduce4")) return __info["cdreduce4"];
			return 0;
		}
		/** [默认:0]AI类型 **/
		public function get ai():int {
			if (__info.hasOwnProperty("ai")) return __info["ai"];
			return 0;
		}
		/** [默认:0]视野范围 **/
		public function get look():int {
			if (__info.hasOwnProperty("look")) return __info["look"];
			return 0;
		}
		/** [默认:0]敏感范围 **/
		public function get sensitive():int {
			if (__info.hasOwnProperty("sensitive")) return __info["sensitive"];
			return 0;
		}
		/** [默认:0]普通技能id **/
		public function get Pskillid():int {
			if (__info.hasOwnProperty("Pskillid")) return __info["Pskillid"];
			return 0;
		}
		/** [默认:0]高级技能1id **/
		public function get Gskillid():int {
			if (__info.hasOwnProperty("Gskillid")) return __info["Gskillid"];
			return 0;
		}
		/** [默认:0]高级技能2id **/
		public function get Gskillid2():int {
			if (__info.hasOwnProperty("Gskillid2")) return __info["Gskillid2"];
			return 0;
		}
		/** [默认:0]高级技能3id **/
		public function get Gskillid3():int {
			if (__info.hasOwnProperty("Gskillid3")) return __info["Gskillid3"];
			return 0;
		}
		/** [默认:0]高级技能4id **/
		public function get Gskillid4():int {
			if (__info.hasOwnProperty("Gskillid4")) return __info["Gskillid4"];
			return 0;
		}
		/** [默认:0]血条显示类型 : 未使用，0-不显示，1-被攻击时显示，2-总是显示，3-固定显示在屏幕最顶端 **/
		public function get hpdisplaytype():int {
			if (__info.hasOwnProperty("hpdisplaytype")) return __info["hpdisplaytype"];
			return 0;
		}
		/** [默认:0]血条显示层数 : 主要用于显示boss的血量，表示血量最多会显示为几层 **/
		public function get hpdisplaynum():int {
			if (__info.hasOwnProperty("hpdisplaynum")) return __info["hpdisplaynum"];
			return 0;
		}
		/** [默认:0]召唤怪物id1 : 该怪物召唤出的怪物1的id **/
		public function get monsterid1():int {
			if (__info.hasOwnProperty("monsterid1")) return __info["monsterid1"];
			return 0;
		}
		/** [默认:0]召唤怪物id2 : 该怪物召唤出的怪物2的id **/
		public function get monsterid2():int {
			if (__info.hasOwnProperty("monsterid2")) return __info["monsterid2"];
			return 0;
		}
		/** [默认:0]是否直接走入场景 : 0怪刷出后直接走入场景，1怪被激活后再走入场景 **/
		public function get actionStart():int {
			if (__info.hasOwnProperty("actionStart")) return __info["actionStart"];
			return 0;
		}
		/** [默认:0]初始角度 : 默认-1（程序自动设为90度），生效填0-360的角度 **/
		public function get first():int {
			if (__info.hasOwnProperty("first")) return __info["first"];
			return 0;
		}
		/** [默认:0]召唤怪物数量上限 **/
		public function get callTotal():int {
			if (__info.hasOwnProperty("callTotal")) return __info["callTotal"];
			return 0;
		}
		//--------------------------------------------------------------------------------------
		/** 对象引用的数据对象 **/
		private var __info:Object;
		
		/**
		 * 怪物属性表
		 * @param	baseInfo			传入null逻辑上会有错误
		 */
		public function MonsterAttributeModel(baseInfo:Object):void
		{
			__info = baseInfo;
		}
		/**
		 * 怪物属性表
		 * @param	baseInfo			传入null逻辑上会有错误
		 * @return
		 */
		public static function getThis(baseInfo:Object ):MonsterAttributeModel
		{
			return new MonsterAttributeModel(baseInfo);
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
