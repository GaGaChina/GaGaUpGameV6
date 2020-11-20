package cn.wjj.upgame.tools 
{
	import cn.wjj.upgame.engine.EDRole;
	import cn.wjj.upgame.engine.ORoleSkill;
	import cn.wjj.upgame.engine.OSkillEffect;
	/**
	 * 处理 OSkillEffect 的类容
	 * @author GaGa
	 */
	public class HandleSkillEffect 
	{
		
		public function HandleSkillEffect() { }
		
		/**
		 * 预处理技能方面的内容
		 * @param	e
		 * @param	owner		发出者,技能发出的时候可以为空
		 * @param	skillLv
		 */
		public static function handleSkill(e:OSkillEffect, owner:EDRole, skillLv:int):void
		{
			//设置命中
			switch (e.effect.hitId) 
			{
				case 1:
					//e.ownerHit = 0;
					break;
				case 2:
					e.ownerHit = e.effect.hitUp * skillLv + e.effect.hit + owner.info.hit;
					break;
				case 3:
					e.ownerHit = e.effect.hitUp * skillLv + e.effect.hit + owner.info.sealHit;
					break;
				case 5:
					e.ownerHit = e.effect.hitUp * skillLv + e.effect.hit;
					break;
			}
			//计算爆击
			switch (e.effect.critId) 
			{
				case 10:
					e.ownerCrit = 0;
					break;
				case 11:
				case 12:
					e.ownerCrit = e.effect.critUp * skillLv + e.effect.critUp + owner.info.crit;
					e.ownerCritValue = e.effect.critHurtUp * skillLv + e.effect.critHurt + owner.info.critHurt;
					break;
			}
			//提前计算伤害
			switch (e.effect.effectId)
			{
				case 101:
				case 102:
				case 103:
				case 104:
				case 110:
				case 111:
				case 120:
				case 121:
				case 170:
				case 171:
				case 180:
				case 181:
				case 182:
				case 183:
				case 184:
				case 185:
				case 186:
				case 200:
					e.ownerHurtValue = e.effect.effectUp * skillLv + e.effect.effect;
					e.ownerHurtUp = e.effect.effectXUp * skillLv + e.effect.effectX;
					break;
				case 160:
				case 161:
				case 162:
					e.ownerHurtValue = 0;
					e.ownerHurtUp = 0;
					break;
				/**
				 * 角色召唤指定id的怪物
				 * （召唤的怪物的怪物id）=【召唤技能怪物id参数（角色卡牌表数据）】+【召唤技能的技能等级（角色技能等级数据）】 - 1
				 */
				case 141:
				case 145:
				case 146:
					e.ownerHurtValue = owner.info.callMonster1 + skillLv - 1;
					break;
				/**
				 * 怪物使用召唤技能召唤指定id1的怪物
				 * （召唤的怪物的怪物id）=【召唤怪物id1（怪物属性表数据）】
				 */
				case 142:
					e.ownerHurtValue = owner.info.callMonster2;
					break;
				/**
				 * 怪物使用召唤技能召唤指定id2的怪物
				 * （召唤的怪物的怪物id）=【召唤怪物id2（怪物属性表数据）】
				 */
				case 143:
					e.ownerHurtValue = owner.info.callMonster3;
					break;
				case 144:
					e.ownerHurtValue = e.effect.SpawnID;
					break;
			}
			e.ownerHpMax = owner.info.hpMax;
			e.ownerAtk = owner.info.atk;
			e.ownerAtkUp = owner.info.atkUp;
			e.ownerCritHurt = owner.info.critHurt;
			e.ownerTreatUp = owner.info.treatUp;
		}
		
		/**
		 * 预处理手动释放的技能
		 * @param	e
		 */
		public static function handleReleaseSkill(e:OSkillEffect):void
		{
			//设置命中
			switch (e.effect.hitId) 
			{
				case 1:
					//e.ownerHit = 0;
					break;
				case 2:
					e.ownerHit = e.effect.hitUp + e.effect.hit;
					break;
				case 3:
					e.ownerHit = e.effect.hitUp + e.effect.hit;
					break;
				case 5:
					e.ownerHit = e.effect.hitUp + e.effect.hit;
					break;
			}
			//计算爆击
			switch (e.effect.critId) 
			{
				case 10:
					e.ownerCrit = 0;
					break;
				case 11:
				case 12:
					e.ownerCrit = e.effect.critUp + e.effect.critUp;
					e.ownerCritValue = e.effect.critHurtUp + e.effect.critHurt;
					break;
			}
			//提前计算伤害
			switch (e.effect.effectId)
			{
				case 101:
				case 102:
				case 103:
				case 104:
				case 110:
				case 111:
				case 120:
				case 121:
				case 170:
				case 171:
				case 180:
				case 181:
				case 182:
				case 183:
				case 184:
				case 185:
				case 186:
					e.ownerHurtValue = e.effect.effectUp + e.effect.effect;
					e.ownerHurtUp = e.effect.effectXUp + e.effect.effectX;
					break;
				case 160:
				case 161:
				case 162:
					e.ownerHurtValue = 0;
					e.ownerHurtUp = 0;
					break;
				/**
				 * 角色召唤指定id的怪物
				 */
				case 141:
				case 142:
				case 143:
				case 144:
					e.ownerHurtValue = e.effect.SpawnID;
					break;
			}
		}
	}
}