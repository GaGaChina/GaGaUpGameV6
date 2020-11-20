package cn.wjj.upgame.engine 
{
	import cn.wjj.upgame.UpGame;
	
	/**
	 * Buff特效生成器
	 * 
	 * @author GaGa
	 */
	public class CSkillContinue 
	{
		
		public function CSkillContinue() { }
		
		/**
		 * 对对象创建一个持续效果特效
		 * @param	upGame		游戏的场景
		 * @param	role		buff释放者
		 * @param	skill		技能的引用
		 * @param	buffInfo	Buff的信息
		 */
		public static function create(upGame:UpGame, owner:EDRole, effect:OSkillEffect, x:int, y:int):void
		{
			var c:EDSkillContinue = new EDSkillContinue(upGame);
			c.camp = effect.ownerCamp;
			c.owner = owner;
			c.effect = effect;
			c.x = x;
			c.y = y;
			upGame.engine.addED(c);
		}
	}
}