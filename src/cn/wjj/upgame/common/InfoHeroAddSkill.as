package cn.wjj.upgame.common 
{
	/**
	 * 附加的技能
	 * @author GaGa
	 */
	public class InfoHeroAddSkill 
	{
		/** 通用技能1卡牌ID : 技能1CD降低值 **/
		public var card1:uint = 0;
		/** 通用技能2卡牌ID : 技能2CD降低值 **/
		public var card2:uint = 0;
		/** 通用技能3卡牌ID : 复活时间与回血速度 **/
		public var card3:uint = 0;
		/** 通用技能4卡牌ID : 经验增量,额外增加单位万分之 **/
		public var card4:uint = 0;
		
		/** 英雄所携带的技能卡牌(回城) **/
		public var cardSkill1:uint = 0;
		/** 英雄所携带的技能卡牌(技能2) **/
		public var cardSkill2:uint = 0;
		/** 英雄所携带的技能卡牌(技能3) **/
		public var cardSkill3:uint = 0;
		/** 英雄所携带的技能卡牌(技能4) **/
		public var cardSkill4:uint = 0;
		
		/** 自动回血的速度 百分比/秒 (要传值进来) **/
		public var selfHealing:Number = 0;
		/** 现在的经验值 **/
		public var expVal:uint = 0;
		/** 升级需要的经验值 **/
		public var expNext:uint = 0;
		/** 现在经验的星级 **/
		public var expStar:uint = 0;
		/** 获取经验的额外增加值 **/
		public var expAddUp:Number = 1;
		/** 死亡复活所需要的时间(毫秒) **/
		public var timeRevive:uint = 0;
		
		public function InfoHeroAddSkill() { }
	}
}