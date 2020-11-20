package cn.wjj.upgame.data
{
	
	/**
	 * UpGame的配置文件
	 * 
	 * 每个游戏要有自己的初始化过程
	 */
	public class UpGameData
	{
		/** 数据是否已经初始化 **/
		public static var init:Boolean = false;
		
		/** 角色卡牌配置文件 **/
		public static var cardRole:RoleCardModel_ArrayLib;
		/** 卡牌信息表 **/
		public static var cardInfo:CardInfoModel_ArrayLib;
		/** 装备配置文件 **/
		public static var cardEquip:EquipCardModel_ArrayLib;
		
		/** 关卡地图数据 **/
		public static var warMap:UpGameWarMap_ArrayLib;
		/** 模型数据表 **/
		public static var modelInfo:UpGameModelInfo_ArrayLib;
		/** 子弹数据表 **/
		public static var bulletInfo:UpGameBulletInfo_ArrayLib;
		/** 技能调用表 **/
		public static var skill:UpGameSkill_ArrayLib;
		/** 主动技能配置文件 **/
		public static var skillActive:SkillActiveModel_ArrayLib;
		/** 技能动作数据 **/
		public static var skillAction:UpGameSkillAction_ArrayLib;
		/** 技能效果数据 **/
		public static var skillEffect:UpGameSkillEffect_ArrayLib;
		
		
		/** 怪物属性表 **/
		public static var monsterAttribute:MonsterAttributeModel_ArrayLib;
		
		/** 英雄技能表 **/
		public static var heroSkill:HeroSkillModel_ArrayLib;
		/** 英雄升星表 **/
		public static var heroStarUp:HeroStarUpModel_ArrayLib;
		/** 英雄通用属性表 **/
		public static var heroGeneralSkill:HeroGeneralSkillModel_ArrayLib;
	}
}
