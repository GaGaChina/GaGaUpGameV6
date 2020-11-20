package cn.wjj.upgame.data
{
	import cn.wjj.g;
	import cn.wjj.data.ObjectAction;
	import flash.utils.ByteArray;
	
	/**
	 * 用户卡牌信息表
	 */
	public class InfoRoleCardModel
	{
		/** 将这些值设置为默认值 **/
		public static function get defaultObject():Object
		{
			if (!__default)
			{
				__default = new Object();
				__default.planId = 0;
				__default.serverId = 0;
				__default.level = 0;
				__default.Pstr = 0;
				__default.Pphy = 0;
				__default.Pagi = 0;
				__default.potential = 0;
				__default.exp = 0;
				__default.protect = false;
				__default.equipIDList = new Array();
				__default.skillIDList = new Array();
				__default.zhenFaSkillsId = 0;
				__default.zhenFaSkillCanStudysId = 0;
				__default.normalSkillLv = 0;
				__default.activeSkillLv = 0;
				__default.activeSkill2Lv = 0;
				__default.activeSkill3Lv = 0;
				__default.activeSkill4Lv = 0;
				__default.attack = 0;
				__default.defence = 0;
				__default.health = 0;
				__default.rate = 0;
				__default.speed = 0;
				__default.hit = 0;
				__default.dodge = 0;
				__default.sealHit = 0;
				__default.sealDodge = 0;
				__default.lethality = 0;
				__default.tenacity = 0;
				__default.finjury = 0;
				__default.finjuryres = 0;
				__default.attX = 0;
				__default.hpX = 0;
				__default.rateX = 0;
				__default.cureX = 0;
				__default.defX = 0;
				__default.betreated = 0;
				__default.reboundrate = 0;
				__default.rebound = 0;
				__default.regenerationrate = 0;
				__default.regenerationValue = 0;
				__default.proportion = 0;
				__default.str = 0;
				__default.magic = 0;
				__default.phy = 0;
				__default.agi = 0;
				__default.equipPIDList = new Array();
				__default.equipPIDLeverList = new Array();
				__default.initialcdreduce1 = 0;
				__default.initialcdreduce2 = 0;
				__default.initialcdreduce3 = 0;
				__default.initialcdreduce4 = 0;
				__default.cdreduce1 = 0;
				__default.cdreduce2 = 0;
				__default.cdreduce3 = 0;
				__default.cdreduce4 = 0;
				__default.chipIDList = new Array();
				__default.chipCount = 0;
				__default.secAttack = 0;
				__default.cardStar = 0;
				__default.activeSkill5Lv = 0;
			}
			__default.equipIDList.length = 0;
			__default.skillIDList.length = 0;
			__default.equipPIDList.length = 0;
			__default.equipPIDLeverList.length = 0;
			__default.chipIDList.length = 0;
			return __default;
		}
		//--------------------------------------------------------------------------------------
		/** 索引字段 **/
		internal static var __keyList:Array = ["planId", "serverId"];
		/** [默认:0]卡在策划文档ID号 **/
		public function get planId():uint {
			return __modelGet("planId");
		}
		/** [默认:0]卡在策划文档ID号 **/
		public function set planId(vars:uint):void {
			__modelSet("planId", vars, false);
		}
		/** [默认:0]卡在服务器的ID号 **/
		public function get serverId():uint {
			return __modelGet("serverId");
		}
		/** [默认:0]卡在服务器的ID号 **/
		public function set serverId(vars:uint):void {
			__modelSet("serverId", vars, false);
		}
		/** [默认:0]卡牌等级 **/
		public function get level():uint {
			return __modelGet("level");
		}
		/** [默认:0]卡牌等级 **/
		public function set level(vars:uint):void {
			__modelSet("level", vars, false);
		}
		/** [默认:0]潜能点力量 **/
		public function get Pstr():int {
			return __modelGet("Pstr");
		}
		/** [默认:0]潜能点力量 **/
		public function set Pstr(vars:int):void {
			__modelSet("Pstr", vars, false);
		}
		/** [默认:0]潜能点体制 **/
		public function get Pphy():int {
			return __modelGet("Pphy");
		}
		/** [默认:0]潜能点体制 **/
		public function set Pphy(vars:int):void {
			__modelSet("Pphy", vars, false);
		}
		/** [默认:0]潜能点敏捷 **/
		public function get Pagi():int {
			return __modelGet("Pagi");
		}
		/** [默认:0]潜能点敏捷 **/
		public function set Pagi(vars:int):void {
			__modelSet("Pagi", vars, false);
		}
		/** [默认:0]潜力点 **/
		public function get potential():uint {
			return __modelGet("potential");
		}
		/** [默认:0]潜力点 **/
		public function set potential(vars:uint):void {
			__modelSet("potential", vars, false);
		}
		/** [默认:0]经验值 **/
		public function get exp():uint {
			return __modelGet("exp");
		}
		/** [默认:0]经验值 **/
		public function set exp(vars:uint):void {
			__modelSet("exp", vars, false);
		}
		/** [默认:false]是否被保护 **/
		public function get protect():Boolean {
			return __modelGet("protect");
		}
		/** [默认:false]是否被保护 **/
		public function set protect(vars:Boolean):void {
			__modelSet("protect", vars, false);
		}
		/** [默认:new Array()]装备的ID列表,0-武器，1-帽子，2-衣服，3-鞋子 **/
		public function get equipIDList():Array {
			return __modelGet("equipIDList");
		}
		/** [默认:new Array()]装备的ID列表,0-武器，1-帽子，2-衣服，3-鞋子 **/
		public function set equipIDList(vars:Array):void {
			__modelSet("equipIDList", vars, false);
		}
		/** [默认:new Array()]被动技能ID列表 **/
		public function get skillIDList():Array {
			return __modelGet("skillIDList");
		}
		/** [默认:new Array()]被动技能ID列表 **/
		public function set skillIDList(vars:Array):void {
			__modelSet("skillIDList", vars, false);
		}
		/** [默认:0]阵法技能id **/
		public function get zhenFaSkillsId():uint {
			return __modelGet("zhenFaSkillsId");
		}
		/** [默认:0]阵法技能id **/
		public function set zhenFaSkillsId(vars:uint):void {
			__modelSet("zhenFaSkillsId", vars, false);
		}
		/** [默认:0]可以学习阵法技能id **/
		public function get zhenFaSkillCanStudysId():uint {
			return __modelGet("zhenFaSkillCanStudysId");
		}
		/** [默认:0]可以学习阵法技能id **/
		public function set zhenFaSkillCanStudysId(vars:uint):void {
			__modelSet("zhenFaSkillCanStudysId", vars, false);
		}
		/** [默认:0]普通主动技能等级 **/
		public function get normalSkillLv():uint {
			return __modelGet("normalSkillLv");
		}
		/** [默认:0]普通主动技能等级 **/
		public function set normalSkillLv(vars:uint):void {
			__modelSet("normalSkillLv", vars, false);
		}
		/** [默认:0]第一个主动技能等级 **/
		public function get activeSkillLv():uint {
			return __modelGet("activeSkillLv");
		}
		/** [默认:0]第一个主动技能等级 **/
		public function set activeSkillLv(vars:uint):void {
			__modelSet("activeSkillLv", vars, false);
		}
		/** [默认:0]第二个主动技能等级 **/
		public function get activeSkill2Lv():uint {
			return __modelGet("activeSkill2Lv");
		}
		/** [默认:0]第二个主动技能等级 **/
		public function set activeSkill2Lv(vars:uint):void {
			__modelSet("activeSkill2Lv", vars, false);
		}
		/** [默认:0]第三个主动技能等级 **/
		public function get activeSkill3Lv():uint {
			return __modelGet("activeSkill3Lv");
		}
		/** [默认:0]第三个主动技能等级 **/
		public function set activeSkill3Lv(vars:uint):void {
			__modelSet("activeSkill3Lv", vars, false);
		}
		/** [默认:0]第四个主动技能等级 **/
		public function get activeSkill4Lv():uint {
			return __modelGet("activeSkill4Lv");
		}
		/** [默认:0]第四个主动技能等级 **/
		public function set activeSkill4Lv(vars:uint):void {
			__modelSet("activeSkill4Lv", vars, false);
		}
		/** [默认:0]攻击 **/
		public function get attack():uint {
			return __modelGet("attack");
		}
		/** [默认:0]攻击 **/
		public function set attack(vars:uint):void {
			__modelSet("attack", vars, false);
		}
		/** [默认:0]防御 **/
		public function get defence():uint {
			return __modelGet("defence");
		}
		/** [默认:0]防御 **/
		public function set defence(vars:uint):void {
			__modelSet("defence", vars, false);
		}
		/** [默认:0]生命 **/
		public function get health():uint {
			return __modelGet("health");
		}
		/** [默认:0]生命 **/
		public function set health(vars:uint):void {
			__modelSet("health", vars, false);
		}
		/** [默认:0]攻击速度 **/
		public function get rate():uint {
			return __modelGet("rate");
		}
		/** [默认:0]攻击速度 **/
		public function set rate(vars:uint):void {
			__modelSet("rate", vars, false);
		}
		/** [默认:0]移动速度 **/
		public function get speed():uint {
			return __modelGet("speed");
		}
		/** [默认:0]移动速度 **/
		public function set speed(vars:uint):void {
			__modelSet("speed", vars, false);
		}
		/** [默认:0]命中 **/
		public function get hit():uint {
			return __modelGet("hit");
		}
		/** [默认:0]命中 **/
		public function set hit(vars:uint):void {
			__modelSet("hit", vars, false);
		}
		/** [默认:0]闪避 **/
		public function get dodge():uint {
			return __modelGet("dodge");
		}
		/** [默认:0]闪避 **/
		public function set dodge(vars:uint):void {
			__modelSet("dodge", vars, false);
		}
		/** [默认:0]封印命中 **/
		public function get sealHit():uint {
			return __modelGet("sealHit");
		}
		/** [默认:0]封印命中 **/
		public function set sealHit(vars:uint):void {
			__modelSet("sealHit", vars, false);
		}
		/** [默认:0]封印闪避 **/
		public function get sealDodge():uint {
			return __modelGet("sealDodge");
		}
		/** [默认:0]封印闪避 **/
		public function set sealDodge(vars:uint):void {
			__modelSet("sealDodge", vars, false);
		}
		/** [默认:0]暴击率 **/
		public function get lethality():uint {
			return __modelGet("lethality");
		}
		/** [默认:0]暴击率 **/
		public function set lethality(vars:uint):void {
			__modelSet("lethality", vars, false);
		}
		/** [默认:0]韧性 **/
		public function get tenacity():uint {
			return __modelGet("tenacity");
		}
		/** [默认:0]韧性 **/
		public function set tenacity(vars:uint):void {
			__modelSet("tenacity", vars, false);
		}
		/** [默认:0]暴击伤害 **/
		public function get finjury():uint {
			return __modelGet("finjury");
		}
		/** [默认:0]暴击伤害 **/
		public function set finjury(vars:uint):void {
			__modelSet("finjury", vars, false);
		}
		/** [默认:0]暴击抵抗 **/
		public function get finjuryres():uint {
			return __modelGet("finjuryres");
		}
		/** [默认:0]暴击抵抗 **/
		public function set finjuryres(vars:uint):void {
			__modelSet("finjuryres", vars, false);
		}
		/** [默认:0]攻击增强 **/
		public function get attX():uint {
			return __modelGet("attX");
		}
		/** [默认:0]攻击增强 **/
		public function set attX(vars:uint):void {
			__modelSet("attX", vars, false);
		}
		/** [默认:0]生命增强 **/
		public function get hpX():uint {
			return __modelGet("hpX");
		}
		/** [默认:0]生命增强 **/
		public function set hpX(vars:uint):void {
			__modelSet("hpX", vars, false);
		}
		/** [默认:0]攻速修正 **/
		public function get rateX():uint {
			return __modelGet("rateX");
		}
		/** [默认:0]攻速修正 **/
		public function set rateX(vars:uint):void {
			__modelSet("rateX", vars, false);
		}
		/** [默认:0]治疗增强 **/
		public function get cureX():uint {
			return __modelGet("cureX");
		}
		/** [默认:0]治疗增强 **/
		public function set cureX(vars:uint):void {
			__modelSet("cureX", vars, false);
		}
		/** [默认:0]防御比例 **/
		public function get defX():uint {
			return __modelGet("defX");
		}
		/** [默认:0]防御比例 **/
		public function set defX(vars:uint):void {
			__modelSet("defX", vars, false);
		}
		/** [默认:0]被治疗比例 **/
		public function get betreated():uint {
			return __modelGet("betreated");
		}
		/** [默认:0]被治疗比例 **/
		public function set betreated(vars:uint):void {
			__modelSet("betreated", vars, false);
		}
		/** [默认:0]反震比例 **/
		public function get reboundrate():uint {
			return __modelGet("reboundrate");
		}
		/** [默认:0]反震比例 **/
		public function set reboundrate(vars:uint):void {
			__modelSet("reboundrate", vars, false);
		}
		/** [默认:0]反震值 **/
		public function get rebound():uint {
			return __modelGet("rebound");
		}
		/** [默认:0]反震值 **/
		public function set rebound(vars:uint):void {
			__modelSet("rebound", vars, false);
		}
		/** [默认:0]再生率 **/
		public function get regenerationrate():uint {
			return __modelGet("regenerationrate");
		}
		/** [默认:0]再生率 **/
		public function set regenerationrate(vars:uint):void {
			__modelSet("regenerationrate", vars, false);
		}
		/** [默认:0]再生值 **/
		public function get regenerationValue():uint {
			return __modelGet("regenerationValue");
		}
		/** [默认:0]再生值 **/
		public function set regenerationValue(vars:uint):void {
			__modelSet("regenerationValue", vars, false);
		}
		/** [默认:0]吸血比例 **/
		public function get proportion():uint {
			return __modelGet("proportion");
		}
		/** [默认:0]吸血比例 **/
		public function set proportion(vars:uint):void {
			__modelSet("proportion", vars, false);
		}
		/** [默认:0]力量 **/
		public function get str():uint {
			return __modelGet("str");
		}
		/** [默认:0]力量 **/
		public function set str(vars:uint):void {
			__modelSet("str", vars, false);
		}
		/** [默认:0]魔力 **/
		public function get magic():uint {
			return __modelGet("magic");
		}
		/** [默认:0]魔力 **/
		public function set magic(vars:uint):void {
			__modelSet("magic", vars, false);
		}
		/** [默认:0]体制 **/
		public function get phy():uint {
			return __modelGet("phy");
		}
		/** [默认:0]体制 **/
		public function set phy(vars:uint):void {
			__modelSet("phy", vars, false);
		}
		/** [默认:0]敏捷 **/
		public function get agi():uint {
			return __modelGet("agi");
		}
		/** [默认:0]敏捷 **/
		public function set agi(vars:uint):void {
			__modelSet("agi", vars, false);
		}
		/** [默认:new Array()]装备的ID列表,0,饰品1,头部,2,腰带,3,武器,4,盔甲,5,鞋子 **/
		public function get equipPIDList():Array {
			return __modelGet("equipPIDList");
		}
		/** [默认:new Array()]装备的ID列表,0,饰品1,头部,2,腰带,3,武器,4,盔甲,5,鞋子 **/
		public function set equipPIDList(vars:Array):void {
			__modelSet("equipPIDList", vars, false);
		}
		/** [默认:new Array()]装备的等级 **/
		public function get equipPIDLeverList():Array {
			return __modelGet("equipPIDLeverList");
		}
		/** [默认:new Array()]装备的等级 **/
		public function set equipPIDLeverList(vars:Array):void {
			__modelSet("equipPIDLeverList", vars, false);
		}
		/** [默认:0]技能1初始cd降低值 **/
		public function get initialcdreduce1():int {
			return __modelGet("initialcdreduce1");
		}
		/** [默认:0]技能1初始cd降低值 **/
		public function set initialcdreduce1(vars:int):void {
			__modelSet("initialcdreduce1", vars, false);
		}
		/** [默认:0]技能2初始cd降低值 **/
		public function get initialcdreduce2():int {
			return __modelGet("initialcdreduce2");
		}
		/** [默认:0]技能2初始cd降低值 **/
		public function set initialcdreduce2(vars:int):void {
			__modelSet("initialcdreduce2", vars, false);
		}
		/** [默认:0]技能3初始cd降低值 **/
		public function get initialcdreduce3():int {
			return __modelGet("initialcdreduce3");
		}
		/** [默认:0]技能3初始cd降低值 **/
		public function set initialcdreduce3(vars:int):void {
			__modelSet("initialcdreduce3", vars, false);
		}
		/** [默认:0]技能4初始cd降低值 **/
		public function get initialcdreduce4():int {
			return __modelGet("initialcdreduce4");
		}
		/** [默认:0]技能4初始cd降低值 **/
		public function set initialcdreduce4(vars:int):void {
			__modelSet("initialcdreduce4", vars, false);
		}
		/** [默认:0]技能1cd降低值 **/
		public function get cdreduce1():int {
			return __modelGet("cdreduce1");
		}
		/** [默认:0]技能1cd降低值 **/
		public function set cdreduce1(vars:int):void {
			__modelSet("cdreduce1", vars, false);
		}
		/** [默认:0]技能2cd降低值 **/
		public function get cdreduce2():int {
			return __modelGet("cdreduce2");
		}
		/** [默认:0]技能2cd降低值 **/
		public function set cdreduce2(vars:int):void {
			__modelSet("cdreduce2", vars, false);
		}
		/** [默认:0]技能3cd降低值 **/
		public function get cdreduce3():int {
			return __modelGet("cdreduce3");
		}
		/** [默认:0]技能3cd降低值 **/
		public function set cdreduce3(vars:int):void {
			__modelSet("cdreduce3", vars, false);
		}
		/** [默认:0]技能4cd降低值 **/
		public function get cdreduce4():int {
			return __modelGet("cdreduce4");
		}
		/** [默认:0]技能4cd降低值 **/
		public function set cdreduce4(vars:int):void {
			__modelSet("cdreduce4", vars, false);
		}
		/** [默认:new Array()]芯片子机的ID列表,0-芯片，1-芯片，2-子机 **/
		public function get chipIDList():Array {
			return __modelGet("chipIDList");
		}
		/** [默认:new Array()]芯片子机的ID列表,0-芯片，1-芯片，2-子机 **/
		public function set chipIDList(vars:Array):void {
			__modelSet("chipIDList", vars, false);
		}
		/** [默认:0]卡牌子机格子数 **/
		public function get chipCount():int {
			return __modelGet("chipCount");
		}
		/** [默认:0]卡牌子机格子数 **/
		public function set chipCount(vars:int):void {
			__modelSet("chipCount", vars, false);
		}
		/** [默认:0]秒伤,角色属性显示时用,避免计算误差显示问题 **/
		public function get secAttack():uint {
			return __modelGet("secAttack");
		}
		/** [默认:0]秒伤,角色属性显示时用,避免计算误差显示问题 **/
		public function set secAttack(vars:uint):void {
			__modelSet("secAttack", vars, false);
		}
		/** [默认:0]卡牌星级 **/
		public function get cardStar():uint {
			return __modelGet("cardStar");
		}
		/** [默认:0]卡牌星级 **/
		public function set cardStar(vars:uint):void {
			__modelSet("cardStar", vars, false);
		}
		/** [默认:0]第五个主动技能等级 **/
		public function get activeSkill5Lv():uint {
			return __modelGet("activeSkill5Lv");
		}
		/** [默认:0]第五个主动技能等级 **/
		public function set activeSkill5Lv(vars:uint):void {
			__modelSet("activeSkill5Lv", vars, false);
		}
		//--------------------------------------------------------------------------------------
		/** 对象引用的数据对象 **/
		private var __info:Object;
		/** 初始默认值的对象 **/
		private static var __default:Object;
		/** AllData的在框架g.bridge.getObjByName引用的名称 **/
		private var __allDataBridgeName:String;
		/** 这个对象在allData上的引用位置 **/
		private var __thisGroupName:String;
		
		/**
		 * 用户卡牌信息表
		 * @param	baseInfo			传入null并且thisGroupName=""的时候,生成一个new Object()
		 * @param	allDataBridgeName	全部数据在框架g.bridge.getObjByName引用的名称,默认allData
		 * @param	thisGroupName		这个数据在全部数据集合上的引用位置(设置后将自动弃用baseInfo,而是从位置里获取内容)
		 * @return
		 */
		public function InfoRoleCardModel(baseInfo:Object = null, allDataBridgeName:String = "UpGame", thisGroupName:String = ""):void
		{
			__allDataBridgeName = allDataBridgeName;
			if (baseInfo && allDataBridgeName && thisGroupName)
			{
				ObjectAction.setGroupVar(g.bridge.getObjByName(allDataBridgeName), thisGroupName, baseInfo);
			}
			if (!baseInfo && !thisGroupName)
			{
				setObject(null);
				return;
			}
			if (allDataBridgeName && thisGroupName)
			{
				setGroupInfo(allDataBridgeName, thisGroupName);
			}
			else
			{
				setObject(baseInfo);
			}
		}
		/**
		 * 用户卡牌信息表
		 * @param	baseInfo			传入null并且thisGroupName=""的时候,生成一个new Object()
		 * @param	allDataBridgeName	全部数据在框架g.bridge.getObjByName引用的名称,默认allData
		 * @param	thisGroupName		这个数据在全部数据集合上的引用位置(设置后将自动弃用baseInfo,而是从位置里获取内容)
		 * @return
		 */
		public static function getThis(baseInfo:Object = null, allDataBridgeName:String = "UpGame", thisGroupName:String = ""):InfoRoleCardModel
		{
			return new InfoRoleCardModel(baseInfo, allDataBridgeName, thisGroupName);
		}
		
		/**
		 * 获取值,当缺少自动赋初始值
		 * @param	n
		 * @return
		 */
		private function __modelGet(n:String):*
		{
			if (__allDataBridgeName && __thisGroupName)
			{
				__info = ObjectAction.getGroupVar(g.bridge.getObjByName(__allDataBridgeName), __thisGroupName);
			}
			if (__info.hasOwnProperty(n))
			{
				return __info[n];
			}
			else
			{
				__info[n] = InfoRoleCardModel.defaultObject[n];
				return __info[n];
			}
		}
		
		/**
		 * 设置一个对象的参数
		 * @param	n				属性名称
		 * @param	vars			值
		 * @param	isRunEvent		是否自动触发事件桥
		 */
		private function __modelSet(n:String, vars:*, isRunEvent:Boolean = false):void
		{
			if (__allDataBridgeName && __thisGroupName)
			{
				__info = ObjectAction.getGroupVar(g.bridge.getObjByName(__allDataBridgeName), __thisGroupName);
			}
			if(__info[n] !== vars){
				__info[n] = vars;
				if (isRunEvent)
				{
					if (__thisGroupName)
					{
						g.event.runEventData(g.bridge.getObjByName(__allDataBridgeName), __thisGroupName + "." + n);
					}
					else
					{
						g.event.runEventData(g.bridge.getObjByName(__allDataBridgeName));
					}
				}
			}
		}
		
		/**
		 * 设置这个对象引用的数据对象
		 * @param	baseInfo	当传入null的时候,自动生成一个new Object()
		 * @return
		 */
		public function setObject(baseInfo:Object = null):InfoRoleCardModel
		{
			if(baseInfo == null){
				baseInfo = new Object();
			}
			__info = baseInfo;
			return this;
		}
		
		/**
		 * 设置对象在一个数据集合中的位置,并且获取这个对象数据,写入这个对象里
		 * @param	allDataBridgeName		全部数据在框架g.bridge.getObjByName引用的名称,默认allData
		 * @param	thisGroupName			这个数据在全部数据集合上的引用位置(设置后自动覆盖这里的数据对象)
		 */
		public function setGroupInfo(allDataBridgeName:String = "UpGame", thisGroupName:String = ""):InfoRoleCardModel
		{
			__allDataBridgeName = allDataBridgeName;
			__thisGroupName = thisGroupName;
			if (allDataBridgeName && thisGroupName)
			{
				var o:Object = g.bridge.getObjByName(allDataBridgeName);
				__info = ObjectAction.getGroupVar(o, thisGroupName);
			}
			return this;
		}
		
		/** 获取数据模型引用的对象 **/
		public function getObject():Object
		{
			return __info;
		}
		
		/** 将初始化数据覆盖进去 **/
		public function setDefault():void
		{
			overlapObject(InfoRoleCardModel.defaultObject);
		}
		
		/**
		 * 设置这个对象的信息,或者覆盖到这个老的数据之上,当从网上传值过来的时候使用
		 * @param	baseInfo
		 * @return
		 */
		public function overlapObject(baseInfo:Object):InfoRoleCardModel
		{
			var o:InfoRoleCardModel = new InfoRoleCardModel(baseInfo, "", "");
			for (var n:String in baseInfo) 
			{
				this[n] = o[n];
			}
			return this;
		}
		
	}
}
