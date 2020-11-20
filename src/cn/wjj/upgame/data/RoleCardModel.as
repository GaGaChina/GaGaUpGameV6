package cn.wjj.upgame.data
{
	import flash.utils.ByteArray;
	/**
	 * 角色卡牌表Item
	 */
	public class RoleCardModel
	{
		/** 索引字段 **/
		internal static var __keyList:Array = ["card_id"];
		/** [默认:0]卡牌id : 卡牌的id **/
		public function get card_id():uint {
			if (__info.hasOwnProperty("card_id")) return __info["card_id"];
			return 0;
		}
		/** [默认:0]卡牌名称id : 卡牌名称id **/
		public function get Cname():uint {
			if (__info.hasOwnProperty("Cname")) return __info["Cname"];
			return 0;
		}
		/** [默认:0]卡牌描述id : 卡牌背景描述，该字段将用于显示在卡牌描述的位置； **/
		public function get Cdescribe():uint {
			if (__info.hasOwnProperty("Cdescribe")) return __info["Cdescribe"];
			return 0;
		}
		/** [默认:0]卡牌描述id : 卡牌背景描述，该字段将用于显示在卡牌描述的位置；签到 **/
		public function get Cdescribe2():uint {
			if (__info.hasOwnProperty("Cdescribe2")) return __info["Cdescribe2"];
			return 0;
		}
		/** [默认:0]卡牌类型 : 1.部队 2.法术 3.建筑 4.基地 **/
		public function get CardType():uint {
			if (__info.hasOwnProperty("CardType")) return __info["CardType"];
			return 0;
		}
		/** [默认:0]卡牌等级 : 卡牌等级 卡牌的等级 **/
		public function get CardLevel():uint {
			if (__info.hasOwnProperty("CardLevel")) return __info["CardLevel"];
			return 0;
		}
		/** [默认:0]图片资源id : 该卡牌所使用的图片资源，取自图片资源表 **/
		public function get CImage():uint {
			if (__info.hasOwnProperty("CImage")) return __info["CImage"];
			return 0;
		}
		/** [默认:0]背景id : 该卡牌所使用的背景图片资源 **/
		public function get CImage1():uint {
			if (__info.hasOwnProperty("CImage1")) return __info["CImage1"];
			return 0;
		}
		/** [默认:0]模型id : 该卡牌所使用的模型资源，取自模型资源表 **/
		public function get Cmodel():uint {
			if (__info.hasOwnProperty("Cmodel")) return __info["Cmodel"];
			return 0;
		}
		/** [默认:0]模型id2(蓝) : 该卡牌所使用的模型资源2，取自模型资源表 **/
		public function get Cmodel2():uint {
			if (__info.hasOwnProperty("Cmodel2")) return __info["Cmodel2"];
			return 0;
		}
		/** [默认:0]卡牌突破等级 : 卡牌突破的等级，该字段会决定卡牌下侧的加成值显示； **/
		public function get CtupoLV():uint {
			if (__info.hasOwnProperty("CtupoLV")) return __info["CtupoLV"];
			return 0;
		}
		/** [默认:0]星级 : 该卡牌的星级，该字段会决定卡牌边框和底图的显示；1、2-白，3-绿，4-蓝，5-紫，6-橙； **/
		public function get Cquality():uint {
			if (__info.hasOwnProperty("Cquality")) return __info["Cquality"];
			return 0;
		}
		/** [默认:0]唯一上阵 : 只能上阵唯一的系列卡牌填写同一个正整数，例如所有填1的卡牌只能同时上阵1张 **/
		public function get Cunique():uint {
			if (__info.hasOwnProperty("Cunique")) return __info["Cunique"];
			return 0;
		}
		/** [默认:0]职业id : 该卡牌的职业，图标显示和进阶判定用 **/
		public function get Cmenpai():uint {
			if (__info.hasOwnProperty("Cmenpai")) return __info["Cmenpai"];
			return 0;
		}
		/** [默认:0]经验类别 : 该卡牌升级时所使用的经验类型，经验类型读取表“卡牌升级经验表” **/
		public function get Cexpclass():uint {
			if (__info.hasOwnProperty("Cexpclass")) return __info["Cexpclass"];
			return 0;
		}
		/** [默认:0]合成经验基数 : 该卡牌作为材料被吃掉时可以提供的经验值；注：具体合成经验 =固定值（配置）+基数 X 卡牌当前等级 **/
		public function get CofferExp():uint {
			if (__info.hasOwnProperty("CofferExp")) return __info["CofferExp"];
			return 0;
		}
		/** [默认:0]出售价格基数 : 该卡牌出售时的价格基数，具体出售价格 = 基数 X（10 + 卡牌当前等级） **/
		public function get Csell():uint {
			if (__info.hasOwnProperty("Csell")) return __info["Csell"];
			return 0;
		}
		/** [默认:0]被动技能格数 : 该卡牌可能拥有的被动技能最大数量（最多4个） **/
		public function get CSskill():uint {
			if (__info.hasOwnProperty("CSskill")) return __info["CSskill"];
			return 0;
		}
		/** [默认:0]力量增量 : 卡牌每次升级默认增加的力量值；卡牌最终力量 = 初始力量 + 力量增量X当前等级/10；力量增量这里需要填写一个X10的值； **/
		public function get CstrAdd():uint {
			if (__info.hasOwnProperty("CstrAdd")) return __info["CstrAdd"];
			return 0;
		}
		/** [默认:0]体质增量 : 卡牌每次升级默认增加的体质值，卡牌最终体质算法同卡牌最终力量 **/
		public function get CphyAdd():uint {
			if (__info.hasOwnProperty("CphyAdd")) return __info["CphyAdd"];
			return 0;
		}
		/** [默认:0]敏捷增量 : 卡牌每次升级默认增加的敏捷值，卡牌最终敏捷算法同卡牌最终力量 **/
		public function get CagiAdd():uint {
			if (__info.hasOwnProperty("CagiAdd")) return __info["CagiAdd"];
			return 0;
		}
		/** [默认:0]潜力增量 : 卡牌每次升级所提供的潜力值（潜力值可以通过培养增加到三项基本属性上） **/
		public function get CproficiencyAdd():uint {
			if (__info.hasOwnProperty("CproficiencyAdd")) return __info["CproficiencyAdd"];
			return 0;
		}
		/** [默认:0]攻击资质 : 卡牌的攻击资质，用于运算卡牌的攻击值； **/
		public function get CAttflair():uint {
			if (__info.hasOwnProperty("CAttflair")) return __info["CAttflair"];
			return 0;
		}
		/** [默认:0]防御资质 : 卡牌的防御资质，用于运算卡牌的防御值； **/
		public function get Cdefflair():uint {
			if (__info.hasOwnProperty("Cdefflair")) return __info["Cdefflair"];
			return 0;
		}
		/** [默认:0]生命资质 : 卡牌的生命资质，用于运算卡牌的生命值； **/
		public function get CHpflair():uint {
			if (__info.hasOwnProperty("CHpflair")) return __info["CHpflair"];
			return 0;
		}
		/** [默认:0]攻击速度资质 : 卡牌的攻击速度资质，用于运算卡牌的攻击速度值； **/
		public function get Cattspflair():uint {
			if (__info.hasOwnProperty("Cattspflair")) return __info["Cattspflair"];
			return 0;
		}
		/** [默认:0]移动速度资质 : 卡牌的移动速度资质，用于运算卡牌的移动速度值； **/
		public function get CSpflair():uint {
			if (__info.hasOwnProperty("CSpflair")) return __info["CSpflair"];
			return 0;
		}
		/** [默认:0]力量 : 卡牌初始的力量值 **/
		public function get Cstr():uint {
			if (__info.hasOwnProperty("Cstr")) return __info["Cstr"];
			return 0;
		}
		/** [默认:0]体质 : 卡牌初始的体质值 **/
		public function get Cphy():uint {
			if (__info.hasOwnProperty("Cphy")) return __info["Cphy"];
			return 0;
		}
		/** [默认:0]敏捷 : 卡牌初始的敏捷值 **/
		public function get Cagi():uint {
			if (__info.hasOwnProperty("Cagi")) return __info["Cagi"];
			return 0;
		}
		/** [默认:0]潜能 : 卡牌初始的潜能点 **/
		public function get proficiency():uint {
			if (__info.hasOwnProperty("proficiency")) return __info["proficiency"];
			return 0;
		}
		/** [默认:0]攻击 : 卡牌的初始攻击 **/
		public function get Catt():uint {
			if (__info.hasOwnProperty("Catt")) return __info["Catt"];
			return 0;
		}
		/** [默认:0]攻击频率 **/
		public function get Crate():uint {
			if (__info.hasOwnProperty("Crate")) return __info["Crate"];
			return 0;
		}
		/** [默认:0]防御 : 卡牌的初始防御 **/
		public function get Cdef():uint {
			if (__info.hasOwnProperty("Cdef")) return __info["Cdef"];
			return 0;
		}
		/** [默认:0]生命 : 卡牌的初始生命 **/
		public function get Chp():uint {
			if (__info.hasOwnProperty("Chp")) return __info["Chp"];
			return 0;
		}
		/** [默认:0]攻击间隔 : 卡牌的初始攻击速度 **/
		public function get Cattsp():uint {
			if (__info.hasOwnProperty("Cattsp")) return __info["Cattsp"];
			return 0;
		}
		/** [默认:0]移动速度 : 卡牌的初始移动速度 **/
		public function get Csp():uint {
			if (__info.hasOwnProperty("Csp")) return __info["Csp"];
			return 0;
		}
		/** [默认:0]命中 : 卡牌的初始命中 **/
		public function get Chit():uint {
			if (__info.hasOwnProperty("Chit")) return __info["Chit"];
			return 0;
		}
		/** [默认:0]回避 : 卡牌的初始回避 **/
		public function get Cdod():uint {
			if (__info.hasOwnProperty("Cdod")) return __info["Cdod"];
			return 0;
		}
		/** [默认:0]封命 : 卡牌的初始封命 **/
		public function get Cseal():uint {
			if (__info.hasOwnProperty("Cseal")) return __info["Cseal"];
			return 0;
		}
		/** [默认:0]封抗 : 卡牌的初始封抗，注：计算时如果某个卡牌的封抗为负表示该角色免疫封印 **/
		public function get Csealres():uint {
			if (__info.hasOwnProperty("Csealres")) return __info["Csealres"];
			return 0;
		}
		/** [默认:0]暴击率 : 卡牌的初始致命率 **/
		public function get Clethality():uint {
			if (__info.hasOwnProperty("Clethality")) return __info["Clethality"];
			return 0;
		}
		/** [默认:0]韧性 : 卡牌的初始韧性 **/
		public function get Ctenacity():uint {
			if (__info.hasOwnProperty("Ctenacity")) return __info["Ctenacity"];
			return 0;
		}
		/** [默认:0]暴击伤害值 : 卡牌的初始致命伤害值 **/
		public function get CFinjury():uint {
			if (__info.hasOwnProperty("CFinjury")) return __info["CFinjury"];
			return 0;
		}
		/** [默认:0]暴击抵抗 : 卡牌的初始致命伤害减免值 **/
		public function get Cfinjuryres():uint {
			if (__info.hasOwnProperty("Cfinjuryres")) return __info["Cfinjuryres"];
			return 0;
		}
		/** [默认:0]攻击增强 : 卡牌的初始攻击增强 **/
		public function get CattX():uint {
			if (__info.hasOwnProperty("CattX")) return __info["CattX"];
			return 0;
		}
		/** [默认:0]生命增强 : 卡牌的初始生命增强 **/
		public function get ChpX():uint {
			if (__info.hasOwnProperty("ChpX")) return __info["ChpX"];
			return 0;
		}
		/** [默认:0]攻速修正 **/
		public function get CattspX():uint {
			if (__info.hasOwnProperty("CattspX")) return __info["CattspX"];
			return 0;
		}
		/** [默认:0]治疗增强 : 卡牌的初始治疗增强 **/
		public function get CcureX():uint {
			if (__info.hasOwnProperty("CcureX")) return __info["CcureX"];
			return 0;
		}
		/** [默认:0]防御比例 : 卡牌的初始防御比例 **/
		public function get Cdefx():uint {
			if (__info.hasOwnProperty("Cdefx")) return __info["Cdefx"];
			return 0;
		}
		/** [默认:0]被治疗比例 : 卡牌的初始被治疗比例 **/
		public function get Cbetreated():uint {
			if (__info.hasOwnProperty("Cbetreated")) return __info["Cbetreated"];
			return 0;
		}
		/** [默认:0]反震比例 : 卡牌的初始反震比例 **/
		public function get Creboundrate():uint {
			if (__info.hasOwnProperty("Creboundrate")) return __info["Creboundrate"];
			return 0;
		}
		/** [默认:0]反震值 : 卡牌的初始反震值 **/
		public function get Crebound():uint {
			if (__info.hasOwnProperty("Crebound")) return __info["Crebound"];
			return 0;
		}
		/** [默认:0]再生率 : 卡牌的初始再生率 **/
		public function get Cregenerationrate():uint {
			if (__info.hasOwnProperty("Cregenerationrate")) return __info["Cregenerationrate"];
			return 0;
		}
		/** [默认:0]再生值 : 卡牌的初始再生值 **/
		public function get CRegenerationValue():uint {
			if (__info.hasOwnProperty("CRegenerationValue")) return __info["CRegenerationValue"];
			return 0;
		}
		/** [默认:0]吸血比例 : 卡牌的初始吸血比例 **/
		public function get Cproportion():uint {
			if (__info.hasOwnProperty("Cproportion")) return __info["Cproportion"];
			return 0;
		}
		/** [默认:0]技能1初始cd降低值 **/
		public function get Cinitialcdreduce1():uint {
			if (__info.hasOwnProperty("Cinitialcdreduce1")) return __info["Cinitialcdreduce1"];
			return 0;
		}
		/** [默认:0]技能2初始cd降低值 **/
		public function get Cinitialcdreduce2():uint {
			if (__info.hasOwnProperty("Cinitialcdreduce2")) return __info["Cinitialcdreduce2"];
			return 0;
		}
		/** [默认:0]技能3初始cd降低值 **/
		public function get Cinitialcdreduce3():uint {
			if (__info.hasOwnProperty("Cinitialcdreduce3")) return __info["Cinitialcdreduce3"];
			return 0;
		}
		/** [默认:0]技能4初始cd降低值 **/
		public function get Cinitialcdreduce4():uint {
			if (__info.hasOwnProperty("Cinitialcdreduce4")) return __info["Cinitialcdreduce4"];
			return 0;
		}
		/** [默认:0]技能1cd降低值 **/
		public function get Ccdreduce1():uint {
			if (__info.hasOwnProperty("Ccdreduce1")) return __info["Ccdreduce1"];
			return 0;
		}
		/** [默认:0]技能2cd降低值 **/
		public function get Ccdreduce2():uint {
			if (__info.hasOwnProperty("Ccdreduce2")) return __info["Ccdreduce2"];
			return 0;
		}
		/** [默认:0]技能3cd降低值 **/
		public function get Ccdreduce3():uint {
			if (__info.hasOwnProperty("Ccdreduce3")) return __info["Ccdreduce3"];
			return 0;
		}
		/** [默认:0]技能4cd降低值 **/
		public function get Ccdreduce4():uint {
			if (__info.hasOwnProperty("Ccdreduce4")) return __info["Ccdreduce4"];
			return 0;
		}
		/** [默认:0]AI类型 : 1仇恨型，2顽固型,3新项目用 **/
		public function get Cai():uint {
			if (__info.hasOwnProperty("Cai")) return __info["Cai"];
			return 0;
		}
		/** [默认:0]视野范围 **/
		public function get Clook():uint {
			if (__info.hasOwnProperty("Clook")) return __info["Clook"];
			return 0;
		}
		/** [默认:0]敏感范围 **/
		public function get Csensitive():uint {
			if (__info.hasOwnProperty("Csensitive")) return __info["Csensitive"];
			return 0;
		}
		/** [默认:0]普通技能id : 该卡牌所使用的普通攻击的技能id，读取表“主动技能表” **/
		public function get Cnskill():uint {
			if (__info.hasOwnProperty("Cnskill")) return __info["Cnskill"];
			return 0;
		}
		/** [默认:0]高级技能1id : 该卡牌所使用的第1个高级技能的技能id，读取表“主动技能表” **/
		public function get CHskill():uint {
			if (__info.hasOwnProperty("CHskill")) return __info["CHskill"];
			return 0;
		}
		/** [默认:0]高级技能2id : 该卡牌所使用的第2个高级技能的技能id，读取表“主动技能表” **/
		public function get CHskill2():uint {
			if (__info.hasOwnProperty("CHskill2")) return __info["CHskill2"];
			return 0;
		}
		/** [默认:0]高级技能3id : 该卡牌所使用的第3个高级技能的技能id，读取表“主动技能表” **/
		public function get CHskill3():uint {
			if (__info.hasOwnProperty("CHskill3")) return __info["CHskill3"];
			return 0;
		}
		/** [默认:0]召唤技能怪物id参数 : 召唤出的怪物id=该参数+召唤技能的实例化等级-1 **/
		public function get Cmonsterid():uint {
			if (__info.hasOwnProperty("Cmonsterid")) return __info["Cmonsterid"];
			return 0;
		}
		/** [默认:0]召唤技能第几个 : 决定该角色的第几个主动技能是召唤技能 **/
		public function get Czhaoskill():uint {
			if (__info.hasOwnProperty("Czhaoskill")) return __info["Czhaoskill"];
			return 0;
		}
		/** [默认:0]天生被动技能1id : 卡牌天生携带的被动技能1的id **/
		public function get Cbskillid():uint {
			if (__info.hasOwnProperty("Cbskillid")) return __info["Cbskillid"];
			return 0;
		}
		/** [默认:0]天生被动技能1id : 卡牌天生携带的被动技能2的id **/
		public function get Cbskillid2():uint {
			if (__info.hasOwnProperty("Cbskillid2")) return __info["Cbskillid2"];
			return 0;
		}
		/** [默认:0]天生阵法技能id : 卡牌天生携带的阵法技能的被动技能id **/
		public function get Czskillid():uint {
			if (__info.hasOwnProperty("Czskillid")) return __info["Czskillid"];
			return 0;
		}
		/** [默认:0]死亡触发技能id : 角色死亡时触发的技能 **/
		public function get DeathSkill():uint {
			if (__info.hasOwnProperty("DeathSkill")) return __info["DeathSkill"];
			return 0;
		}
		/** [默认:0]是否可进阶 : 0否1是用于显示该卡牌是否可继续进阶 **/
		public function get Cjinhua():uint {
			if (__info.hasOwnProperty("Cjinhua")) return __info["Cjinhua"];
			return 0;
		}
		/** [默认:0]图鉴编号 : 显示在查看角色界面和图鉴列表中 **/
		public function get Ctujianno():uint {
			if (__info.hasOwnProperty("Ctujianno")) return __info["Ctujianno"];
			return 0;
		}
		/** [默认:0]卡牌档次 : 标识卡牌是几阶卡 **/
		public function get Cjie1234():uint {
			if (__info.hasOwnProperty("Cjie1234")) return __info["Cjie1234"];
			return 0;
		}
		/** [默认:0]卡牌用途 : 客户端用，0-普通卡，1-经验卡，2-金币卡 **/
		public function get Cuseway():uint {
			if (__info.hasOwnProperty("Cuseway")) return __info["Cuseway"];
			return 0;
		}
		/** [默认:0]是否可分解 : 0不可分解，1可分解 **/
		public function get Cfenjie():uint {
			if (__info.hasOwnProperty("Cfenjie")) return __info["Cfenjie"];
			return 0;
		}
		/** [默认:0]分解内容描述 : 字符串id **/
		public function get Cfenjiewu():uint {
			if (__info.hasOwnProperty("Cfenjiewu")) return __info["Cfenjiewu"];
			return 0;
		}
		/** [默认:0]评论标识 : 用于角色评论，评论标识一样的卡牌在角色评论中视为同一张卡牌 **/
		public function get Ctalkid():uint {
			if (__info.hasOwnProperty("Ctalkid")) return __info["Ctalkid"];
			return 0;
		}
		/** [默认:0]进阶新主动技能 : 进阶界面显示用 **/
		public function get Ctupozskill():uint {
			if (__info.hasOwnProperty("Ctupozskill")) return __info["Ctupozskill"];
			return 0;
		}
		/** [默认:0]进阶新被动技能1 **/
		public function get Ctupobskill1():uint {
			if (__info.hasOwnProperty("Ctupobskill1")) return __info["Ctupobskill1"];
			return 0;
		}
		/** [默认:0]进阶新被动技能2 **/
		public function get Ctupobskill2():uint {
			if (__info.hasOwnProperty("Ctupobskill2")) return __info["Ctupobskill2"];
			return 0;
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
		/** [默认:0]随机语音1 **/
		public function get Crandomsound1():uint {
			if (__info.hasOwnProperty("Crandomsound1")) return __info["Crandomsound1"];
			return 0;
		}
		/** [默认:0]随机语音2 **/
		public function get Crandomsound2():uint {
			if (__info.hasOwnProperty("Crandomsound2")) return __info["Crandomsound2"];
			return 0;
		}
		/** [默认:0]随机语音3 **/
		public function get Crandomsound3():uint {
			if (__info.hasOwnProperty("Crandomsound3")) return __info["Crandomsound3"];
			return 0;
		}
		/** [默认:0]新技能卡牌星级 **/
		public function get Cnewtimes():uint {
			if (__info.hasOwnProperty("Cnewtimes")) return __info["Cnewtimes"];
			return 0;
		}
		/** [默认:0]产出描述1id,角色碎片的产出描述 **/
		public function get Cdescribe1():uint {
			if (__info.hasOwnProperty("Cdescribe1")) return __info["Cdescribe1"];
			return 0;
		}
		/** [默认:0]产出描述1跳转,1-vip特权，2-传记章节，3-商城卡包，4-竞技商店，5-神秘商店，6-活动副本 **/
		public function get Clink1():uint {
			if (__info.hasOwnProperty("Clink1")) return __info["Clink1"];
			return 0;
		}
		/** [默认:0]产出描述2id,角色碎片的产出描述 **/
		public function get Cdescribe12():uint {
			if (__info.hasOwnProperty("Cdescribe12")) return __info["Cdescribe12"];
			return 0;
		}
		/** [默认:0]产出描述2跳转,1-vip特权，2-传记章节，3-商城卡包，4-竞技商店，5-神秘商店，6-活动副本 **/
		public function get Clink2():uint {
			if (__info.hasOwnProperty("Clink2")) return __info["Clink2"];
			return 0;
		}
		/** [默认:0]关系类型标识 **/
		public function get Crelationship():uint {
			if (__info.hasOwnProperty("Crelationship")) return __info["Crelationship"];
			return 0;
		}
		/** [默认:0]星级上限 **/
		public function get Cstarmax():uint {
			if (__info.hasOwnProperty("Cstarmax")) return __info["Cstarmax"];
			return 0;
		}
		/** [默认:0]每个星级资质倍率 **/
		public function get CstarX():uint {
			if (__info.hasOwnProperty("CstarX")) return __info["CstarX"];
			return 0;
		}
		/** [默认:0]突破等级上限 **/
		public function get CtupoLVmax():uint {
			if (__info.hasOwnProperty("CtupoLVmax")) return __info["CtupoLVmax"];
			return 0;
		}
		/** [默认:0]放置延时:角色放置到战场后，到开始激活起作用前的冷却时间 **/
		public function get DeployTime():uint {
			if (__info.hasOwnProperty("DeployTime")) return __info["DeployTime"];
			return 0;
		}
		/** [默认:0]落地时间:角色从放置到落地的时间 **/
		public function get DownTime():uint {
			if (__info.hasOwnProperty("DownTime")) return __info["DownTime"];
			return 0;
		}
		/** [默认:0]角色是否免疫被击退 **/
		public function get IgnorePushback():uint {
			if (__info.hasOwnProperty("IgnorePushback")) return __info["IgnorePushback"];
			return 0;
		}
		/** [默认:0]角色的飞行高度，填0为地面单位 **/
		public function get FlyingHeight():uint {
			if (__info.hasOwnProperty("FlyingHeight")) return __info["FlyingHeight"];
			return 0;
		}
		/** [默认:0]角色的跳跃高度 **/
		public function get JumpHeight():uint {
			if (__info.hasOwnProperty("JumpHeight")) return __info["JumpHeight"];
			return 0;
		}
		/** [默认:0]角色的跳跃速度 **/
		public function get JumpSpeed():uint {
			if (__info.hasOwnProperty("JumpSpeed")) return __info["JumpSpeed"];
			return 0;
		}
		/** [默认:0]质量 : 该角色的重量 **/
		public function get Mass():uint {
			if (__info.hasOwnProperty("Mass")) return __info["Mass"];
			return 0;
		}
		/** [默认:0]提供经验 : 该角色提供的经验 **/
		public function get Exp():uint {
			if (__info.hasOwnProperty("Exp")) return __info["Exp"];
			return 0;
		}
		/** [默认:0]最低移动速度 : 最低移动速度 **/
		public function get Clsp():uint {
			if (__info.hasOwnProperty("Clsp")) return __info["Clsp"];
			return 0;
		}
		//--------------------------------------------------------------------------------------
		/** 对象引用的数据对象 **/
		private var __info:Object;
		
		/**
		 * 角色卡牌表Item
		 * @param	baseInfo			传入null逻辑上会有错误
		 */
		public function RoleCardModel(baseInfo:Object):void
		{
			__info = baseInfo;
		}
		/**
		 * 角色卡牌表Item
		 * @param	baseInfo			传入null逻辑上会有错误
		 * @return
		 */
		public static function getThis(baseInfo:Object ):RoleCardModel
		{
			return new RoleCardModel(baseInfo);
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
