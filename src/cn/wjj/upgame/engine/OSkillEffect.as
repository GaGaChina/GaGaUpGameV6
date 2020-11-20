package cn.wjj.upgame.engine 
{
	import cn.wjj.upgame.data.UpGameSkillEffect;
	
	/**
	 * 技能效果实体数据
	 * 
	 * 这个已经生效的内容,不能进行在次的修改,否则会造成无法回滚到正确的数值上来
	 * 
	 * @author GaGa
	 */
	public class OSkillEffect
	{
		/** [策划]技能效果数据 **/
		public var effect:UpGameSkillEffect;
		
		
		/** 主动技能ID **/
		public var skillIndex:uint = 0;
		/** 动作ID **/
		public var actionId:uint = 0;
		/** 动作表中,本动作下有5个可释放技能,本技能的ID **/
		public var actionSkillId:uint = 0;
		/** 动作所使用的发射点 **/
		public var hitPointIndex:int = 0;
		
		
		/** 技能发起者的引用 **/
		public var owner:EDRole;
		/** 技能拥有者ID,使用服务器ID **/
		public var ownerId:uint = 0;
		/** 技能拥有者ID,使用服务器ID **/
		public var ownerPlayerId:int = 0;
		/** 技能拥有者阵营 **/
		public var ownerCamp:int = 0;
		/** 拥有者的序号 **/
		public var ownerIdx:int = 0;
		/** 拥有者是否是召唤出来的 **/
		public var ownerCall:Boolean = false;
		/** 攻击者的命中总和 **/
		public var ownerHit:int = 0;
		/** 攻击者的爆击 **/
		public var ownerCrit:int = 0;
		/** 攻击者的总致命伤害值 **/
		public var ownerCritValue:int = 0;
		/** 效果的初始值 info.effectUp * owner.info.getSkillLv(skill.id) + info.effect **/
		public var ownerHurtValue:int = 0;
		/** 效果的初始值 info.effectXUp * owner.info.getSkillLv(skill.id) + info.effectX **/
		public var ownerHurtUp:int = 0;
		/** 攻击者的生命值上限 **/
		public var ownerHpMax:int = 0;
		/** 攻击者的攻击力 **/
		public var ownerAtk:int = 0;
		/** 攻击者的攻击力升高偏移,攻击力增强,百分比 **/
		public var ownerAtkUp:int = 0;
		/** 攻击者的暴击伤害值 **/
		public var ownerCritHurt:int = 0;
		/** 攻击者的治疗增强 **/
		public var ownerTreatUp:int = 0;
		
		public function OSkillEffect() { }
	}
}