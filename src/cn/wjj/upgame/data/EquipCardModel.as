package cn.wjj.upgame.data
{
	import flash.utils.ByteArray;
	/**
	 * 装备数据表
	 */
	public class EquipCardModel
	{
		/** 索引字段 **/
		internal static var __keyList:Array = ["Id", "tujianno", "job", "cardlv"];
		/** [默认:0]装备id **/
		public function get Id():uint {
			if (__info.hasOwnProperty("Id")) return __info["Id"];
			return 0;
		}
		/** [默认:0]装备名称语言包ID **/
		public function get Name():uint {
			if (__info.hasOwnProperty("Name")) return __info["Name"];
			return 0;
		}
		/** [默认:0]装备描述语言包ID **/
		public function get describe():uint {
			if (__info.hasOwnProperty("describe")) return __info["describe"];
			return 0;
		}
		/** [默认:""]图片资源地址 **/
		public function get Image():String {
			if (__info.hasOwnProperty("Image")) return __info["Image"];
			return "";
		}
		/** [默认:0]装备的突破等级 **/
		public function get tupoLV():uint {
			if (__info.hasOwnProperty("tupoLV")) return __info["tupoLV"];
			return 0;
		}
		/** [默认:0]星级 **/
		public function get quality():uint {
			if (__info.hasOwnProperty("quality")) return __info["quality"];
			return 0;
		}
		/** [默认:0]类别 **/
		public function get Type():uint {
			if (__info.hasOwnProperty("Type")) return __info["Type"];
			return 0;
		}
		/** [默认:0]装备类型描述 **/
		public function get typedec():uint {
			if (__info.hasOwnProperty("typedec")) return __info["typedec"];
			return 0;
		}
		/** [默认:0]等级上限 **/
		public function get Lvcap():uint {
			if (__info.hasOwnProperty("Lvcap")) return __info["Lvcap"];
			return 0;
		}
		/** [默认:0]该卡牌升级时所使用的花费类别 **/
		public function get stype():uint {
			if (__info.hasOwnProperty("stype")) return __info["stype"];
			return 0;
		}
		/** [默认:0]该装备出售时所使用的价格类型，价格类型读取表“卡牌升级经验表” **/
		public function get selltype():uint {
			if (__info.hasOwnProperty("selltype")) return __info["selltype"];
			return 0;
		}
		/** [默认:0]攻击 **/
		public function get Att():uint {
			if (__info.hasOwnProperty("Att")) return __info["Att"];
			return 0;
		}
		/** [默认:0]攻击频率 **/
		public function get rate():uint {
			if (__info.hasOwnProperty("rate")) return __info["rate"];
			return 0;
		}
		/** [默认:0]装备的初始防御 **/
		public function get def():uint {
			if (__info.hasOwnProperty("def")) return __info["def"];
			return 0;
		}
		/** [默认:0]生命 **/
		public function get Hp():uint {
			if (__info.hasOwnProperty("Hp")) return __info["Hp"];
			return 0;
		}
		/** [默认:0]装备的初始攻击速度 **/
		public function get attsp():uint {
			if (__info.hasOwnProperty("attsp")) return __info["attsp"];
			return 0;
		}
		/** [默认:0]速度 **/
		public function get Sp():uint {
			if (__info.hasOwnProperty("Sp")) return __info["Sp"];
			return 0;
		}
		/** [默认:0]命中 **/
		public function get Hit():uint {
			if (__info.hasOwnProperty("Hit")) return __info["Hit"];
			return 0;
		}
		/** [默认:0]回避 **/
		public function get dod():uint {
			if (__info.hasOwnProperty("dod")) return __info["dod"];
			return 0;
		}
		/** [默认:0]封命 **/
		public function get seal():uint {
			if (__info.hasOwnProperty("seal")) return __info["seal"];
			return 0;
		}
		/** [默认:0]封抗 **/
		public function get sealres():uint {
			if (__info.hasOwnProperty("sealres")) return __info["sealres"];
			return 0;
		}
		/** [默认:0]致命率 **/
		public function get lethality():uint {
			if (__info.hasOwnProperty("lethality")) return __info["lethality"];
			return 0;
		}
		/** [默认:0]韧性 **/
		public function get tenacity():uint {
			if (__info.hasOwnProperty("tenacity")) return __info["tenacity"];
			return 0;
		}
		/** [默认:0]致命伤害值 **/
		public function get Finjury():uint {
			if (__info.hasOwnProperty("Finjury")) return __info["Finjury"];
			return 0;
		}
		/** [默认:0]装备的初始致命伤害减免值 **/
		public function get finjuryres():uint {
			if (__info.hasOwnProperty("finjuryres")) return __info["finjuryres"];
			return 0;
		}
		/** [默认:0]物攻增强 **/
		public function get attX():uint {
			if (__info.hasOwnProperty("attX")) return __info["attX"];
			return 0;
		}
		/** [默认:0]生命增强 **/
		public function get HpX():uint {
			if (__info.hasOwnProperty("HpX")) return __info["HpX"];
			return 0;
		}
		/** [默认:0]攻速修正 **/
		public function get attspX():uint {
			if (__info.hasOwnProperty("attspX")) return __info["attspX"];
			return 0;
		}
		/** [默认:0]治疗增强 **/
		public function get cureX():uint {
			if (__info.hasOwnProperty("cureX")) return __info["cureX"];
			return 0;
		}
		/** [默认:0]装备的初始防御比例 **/
		public function get defx():uint {
			if (__info.hasOwnProperty("defx")) return __info["defx"];
			return 0;
		}
		/** [默认:0]被治疗增强 **/
		public function get betreated():uint {
			if (__info.hasOwnProperty("betreated")) return __info["betreated"];
			return 0;
		}
		/** [默认:0]装备的初始反震比例 **/
		public function get reboundrate():uint {
			if (__info.hasOwnProperty("reboundrate")) return __info["reboundrate"];
			return 0;
		}
		/** [默认:0]反震效果 **/
		public function get rebound():uint {
			if (__info.hasOwnProperty("rebound")) return __info["rebound"];
			return 0;
		}
		/** [默认:0]再生率 **/
		public function get regenerationrate():uint {
			if (__info.hasOwnProperty("regenerationrate")) return __info["regenerationrate"];
			return 0;
		}
		/** [默认:0]再生值 **/
		public function get regenerationvalue():uint {
			if (__info.hasOwnProperty("regenerationvalue")) return __info["regenerationvalue"];
			return 0;
		}
		/** [默认:0]吸血比例 **/
		public function get proportion():uint {
			if (__info.hasOwnProperty("proportion")) return __info["proportion"];
			return 0;
		}
		/** [默认:0]技能1初始cd降低值 **/
		public function get initialcdreduce1():uint {
			if (__info.hasOwnProperty("initialcdreduce1")) return __info["initialcdreduce1"];
			return 0;
		}
		/** [默认:0]技能2初始cd降低值 **/
		public function get initialcdreduce2():uint {
			if (__info.hasOwnProperty("initialcdreduce2")) return __info["initialcdreduce2"];
			return 0;
		}
		/** [默认:0]技能3初始cd降低值 **/
		public function get initialcdreduce3():uint {
			if (__info.hasOwnProperty("initialcdreduce3")) return __info["initialcdreduce3"];
			return 0;
		}
		/** [默认:0]技能4初始cd降低值 **/
		public function get initialcdreduce4():uint {
			if (__info.hasOwnProperty("initialcdreduce4")) return __info["initialcdreduce4"];
			return 0;
		}
		/** [默认:0]技能1cd降低值 **/
		public function get cdreduce1():uint {
			if (__info.hasOwnProperty("cdreduce1")) return __info["cdreduce1"];
			return 0;
		}
		/** [默认:0]技能2cd降低值 **/
		public function get cdreduce2():uint {
			if (__info.hasOwnProperty("cdreduce2")) return __info["cdreduce2"];
			return 0;
		}
		/** [默认:0]技能3cd降低值 **/
		public function get cdreduce3():uint {
			if (__info.hasOwnProperty("cdreduce3")) return __info["cdreduce3"];
			return 0;
		}
		/** [默认:0]技能4cd降低值 **/
		public function get cdreduce4():uint {
			if (__info.hasOwnProperty("cdreduce4")) return __info["cdreduce4"];
			return 0;
		}
		/** [默认:0]攻击增量 **/
		public function get attXnum():uint {
			if (__info.hasOwnProperty("attXnum")) return __info["attXnum"];
			return 0;
		}
		/** [默认:0]防御 **/
		public function get defnum():uint {
			if (__info.hasOwnProperty("defnum")) return __info["defnum"];
			return 0;
		}
		/** [默认:0]生命增量 **/
		public function get hpXnum():uint {
			if (__info.hasOwnProperty("hpXnum")) return __info["hpXnum"];
			return 0;
		}
		/** [默认:0]攻击速度增量 **/
		public function get attspnum():uint {
			if (__info.hasOwnProperty("attspnum")) return __info["attspnum"];
			return 0;
		}
		/** [默认:0]速度增量 **/
		public function get Spxnum():uint {
			if (__info.hasOwnProperty("Spxnum")) return __info["Spxnum"];
			return 0;
		}
		/** [默认:0]命中增量 **/
		public function get Hitxnum():uint {
			if (__info.hasOwnProperty("Hitxnum")) return __info["Hitxnum"];
			return 0;
		}
		/** [默认:0]回避增量 **/
		public function get Dodxnum():uint {
			if (__info.hasOwnProperty("Dodxnum")) return __info["Dodxnum"];
			return 0;
		}
		/** [默认:0]封命增量 **/
		public function get Sealxnum():uint {
			if (__info.hasOwnProperty("Sealxnum")) return __info["Sealxnum"];
			return 0;
		}
		/** [默认:0]封抗增量 **/
		public function get Sealresxnum():uint {
			if (__info.hasOwnProperty("Sealresxnum")) return __info["Sealresxnum"];
			return 0;
		}
		/** [默认:0]致命率增量 **/
		public function get Lethalityxnum():uint {
			if (__info.hasOwnProperty("Lethalityxnum")) return __info["Lethalityxnum"];
			return 0;
		}
		/** [默认:0]韧性增量 **/
		public function get Tenacityxnum():uint {
			if (__info.hasOwnProperty("Tenacityxnum")) return __info["Tenacityxnum"];
			return 0;
		}
		/** [默认:0]致命值增量 **/
		public function get Finjuryxnum():uint {
			if (__info.hasOwnProperty("Finjuryxnum")) return __info["Finjuryxnum"];
			return 0;
		}
		/** [默认:0]暴击抵抗增量 **/
		public function get finjuryresnum():uint {
			if (__info.hasOwnProperty("finjuryresnum")) return __info["finjuryresnum"];
			return 0;
		}
		/** [默认:0]物攻增强增量 **/
		public function get attXxnum():uint {
			if (__info.hasOwnProperty("attXxnum")) return __info["attXxnum"];
			return 0;
		}
		/** [默认:0]生命增强增量 **/
		public function get HpXxnum():uint {
			if (__info.hasOwnProperty("HpXxnum")) return __info["HpXxnum"];
			return 0;
		}
		/** [默认:0]攻速修正增量 **/
		public function get attspXnum():uint {
			if (__info.hasOwnProperty("attspXnum")) return __info["attspXnum"];
			return 0;
		}
		/** [默认:0]治疗增强增量 **/
		public function get cureXxnum():uint {
			if (__info.hasOwnProperty("cureXxnum")) return __info["cureXxnum"];
			return 0;
		}
		/** [默认:0]防御比例增量 **/
		public function get defxnum():uint {
			if (__info.hasOwnProperty("defxnum")) return __info["defxnum"];
			return 0;
		}
		/** [默认:0]被治疗增强增量 **/
		public function get betreatedxnum():uint {
			if (__info.hasOwnProperty("betreatedxnum")) return __info["betreatedxnum"];
			return 0;
		}
		/** [默认:0]反震比例增量 **/
		public function get reboundratenum():uint {
			if (__info.hasOwnProperty("reboundratenum")) return __info["reboundratenum"];
			return 0;
		}
		/** [默认:0]反震效果增量 **/
		public function get reboundxnum():uint {
			if (__info.hasOwnProperty("reboundxnum")) return __info["reboundxnum"];
			return 0;
		}
		/** [默认:0]再生率增量 **/
		public function get Regenerationratexnum():uint {
			if (__info.hasOwnProperty("Regenerationratexnum")) return __info["Regenerationratexnum"];
			return 0;
		}
		/** [默认:0]再生值增量 **/
		public function get Regenerationvaluexnum():uint {
			if (__info.hasOwnProperty("Regenerationvaluexnum")) return __info["Regenerationvaluexnum"];
			return 0;
		}
		/** [默认:0]吸血比例增量 **/
		public function get Proportionxnum():uint {
			if (__info.hasOwnProperty("Proportionxnum")) return __info["Proportionxnum"];
			return 0;
		}
		/** [默认:0]技能1初始cd降低值增量 **/
		public function get initialcdreduce1num():uint {
			if (__info.hasOwnProperty("initialcdreduce1num")) return __info["initialcdreduce1num"];
			return 0;
		}
		/** [默认:0]技能2初始cd降低值增量 **/
		public function get initialcdreduce2num():uint {
			if (__info.hasOwnProperty("initialcdreduce2num")) return __info["initialcdreduce2num"];
			return 0;
		}
		/** [默认:0]技能3初始cd降低值增量 **/
		public function get initialcdreduce3num():uint {
			if (__info.hasOwnProperty("initialcdreduce3num")) return __info["initialcdreduce3num"];
			return 0;
		}
		/** [默认:0]技能4初始cd降低值增量 **/
		public function get initialcdreduce4num():uint {
			if (__info.hasOwnProperty("initialcdreduce4num")) return __info["initialcdreduce4num"];
			return 0;
		}
		/** [默认:0]技能1cd降低值增量 **/
		public function get cdreduce1num():uint {
			if (__info.hasOwnProperty("cdreduce1num")) return __info["cdreduce1num"];
			return 0;
		}
		/** [默认:0]技能2cd降低值增量 **/
		public function get cdreduce2num():uint {
			if (__info.hasOwnProperty("cdreduce2num")) return __info["cdreduce2num"];
			return 0;
		}
		/** [默认:0]技能3cd降低值增量 **/
		public function get cdreduce3num():uint {
			if (__info.hasOwnProperty("cdreduce3num")) return __info["cdreduce3num"];
			return 0;
		}
		/** [默认:0]技能4cd降低值增量 **/
		public function get cdreduce4num():uint {
			if (__info.hasOwnProperty("cdreduce4num")) return __info["cdreduce4num"];
			return 0;
		}
		/** [默认:0]关系类型标识 **/
		public function get relationship2():uint {
			if (__info.hasOwnProperty("relationship2")) return __info["relationship2"];
			return 0;
		}
		/** [默认:0]是否可进阶 **/
		public function get jinhua():uint {
			if (__info.hasOwnProperty("jinhua")) return __info["jinhua"];
			return 0;
		}
		/** [默认:0]图鉴与查看装备显示用 **/
		public function get tujianno():uint {
			if (__info.hasOwnProperty("tujianno")) return __info["tujianno"];
			return 0;
		}
		/** [默认:0]职业限制 **/
		public function get job():uint {
			if (__info.hasOwnProperty("job")) return __info["job"];
			return 0;
		}
		/** [默认:0]卡牌等级限制 **/
		public function get cardlv():uint {
			if (__info.hasOwnProperty("cardlv")) return __info["cardlv"];
			return 0;
		}
		/** [默认:0]机甲的模型id **/
		public function get model():uint {
			if (__info.hasOwnProperty("model")) return __info["model"];
			return 0;
		}
		/** [默认:0]提供的经验值 **/
		public function get exp():uint {
			if (__info.hasOwnProperty("exp")) return __info["exp"];
			return 0;
		}
		/** [默认:0]主动技能1id **/
		public function get zskill1():uint {
			if (__info.hasOwnProperty("zskill1")) return __info["zskill1"];
			return 0;
		}
		/** [默认:0]主动技能2id **/
		public function get zskill2():uint {
			if (__info.hasOwnProperty("zskill2")) return __info["zskill2"];
			return 0;
		}
		/** [默认:0]机甲判断是否是同一的标准，重复获得同一机甲系统自动分解 **/
		public function get unique():uint {
			if (__info.hasOwnProperty("unique")) return __info["unique"];
			return 0;
		}
		/** [默认:0]机甲碎片的产出描述 **/
		public function get describe1():uint {
			if (__info.hasOwnProperty("describe1")) return __info["describe1"];
			return 0;
		}
		/** [默认:0]芯片判断是否是同一属性芯片的标准，同一属性芯片一个角色只能同时装备一个，同一属性的芯片填写相同的数字 **/
		public function get same():uint {
			if (__info.hasOwnProperty("same")) return __info["same"];
			return 0;
		}
		/** [默认:0]机甲的攻击类型描述 **/
		public function get describe2():uint {
			if (__info.hasOwnProperty("describe2")) return __info["describe2"];
			return 0;
		}
		/** [默认:""]机甲大图 **/
		public function get Image1():String {
			if (__info.hasOwnProperty("Image1")) return __info["Image1"];
			return "";
		}
		/** [默认:0]产出关卡类型1 : 角色碎片关联的关卡类型，用作跳转碎片掉落的关卡用 **/
		public function get Cloot11():uint {
			if (__info.hasOwnProperty("Cloot11")) return __info["Cloot11"];
			return 0;
		}
		/** [默认:0]产出大关id1 : 关联的大关id **/
		public function get Cloot12():uint {
			if (__info.hasOwnProperty("Cloot12")) return __info["Cloot12"];
			return 0;
		}
		/** [默认:0]产出小关id1 : 关联的小关id **/
		public function get Cloot13():uint {
			if (__info.hasOwnProperty("Cloot13")) return __info["Cloot13"];
			return 0;
		}
		/** [默认:0]产出关卡类型2 **/
		public function get Cloot21():uint {
			if (__info.hasOwnProperty("Cloot21")) return __info["Cloot21"];
			return 0;
		}
		/** [默认:0]产出大关id2 **/
		public function get Cloot22():uint {
			if (__info.hasOwnProperty("Cloot22")) return __info["Cloot22"];
			return 0;
		}
		/** [默认:0]产出小关id2 **/
		public function get Cloot23():uint {
			if (__info.hasOwnProperty("Cloot23")) return __info["Cloot23"];
			return 0;
		}
		/** [默认:0]产出关卡类型3 **/
		public function get Cloot31():uint {
			if (__info.hasOwnProperty("Cloot31")) return __info["Cloot31"];
			return 0;
		}
		/** [默认:0]产出大关id3 **/
		public function get Cloot32():uint {
			if (__info.hasOwnProperty("Cloot32")) return __info["Cloot32"];
			return 0;
		}
		/** [默认:0]产出小关id3 **/
		public function get Cloot33():uint {
			if (__info.hasOwnProperty("Cloot33")) return __info["Cloot33"];
			return 0;
		}
		/** [默认:0]产出关卡类型4 **/
		public function get Cloot41():uint {
			if (__info.hasOwnProperty("Cloot41")) return __info["Cloot41"];
			return 0;
		}
		/** [默认:0]产出大关id4 **/
		public function get Cloot42():uint {
			if (__info.hasOwnProperty("Cloot42")) return __info["Cloot42"];
			return 0;
		}
		/** [默认:0]产出小关id4 **/
		public function get Cloot43():uint {
			if (__info.hasOwnProperty("Cloot43")) return __info["Cloot43"];
			return 0;
		}
		/** [默认:0]子机技能显示等级 **/
		public function get displaylv():uint {
			if (__info.hasOwnProperty("displaylv")) return __info["displaylv"];
			return 0;
		}
		//--------------------------------------------------------------------------------------
		/** 对象引用的数据对象 **/
		private var __info:Object;
		
		/**
		 * 装备数据表
		 * @param	baseInfo			传入null逻辑上会有错误
		 */
		public function EquipCardModel(baseInfo:Object):void
		{
			__info = baseInfo;
		}
		/**
		 * 装备数据表
		 * @param	baseInfo			传入null逻辑上会有错误
		 * @return
		 */
		public static function getThis(baseInfo:Object ):EquipCardModel
		{
			return new EquipCardModel(baseInfo);
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
