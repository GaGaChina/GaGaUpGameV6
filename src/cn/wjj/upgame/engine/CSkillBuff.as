package cn.wjj.upgame.engine 
{
	import cn.wjj.upgame.UpGame;
	
	/**
	 * Buff特效生成器
	 * 
	 * @author GaGa
	 */
	public class CSkillBuff 
	{
		
		public function CSkillBuff() { }
		
		/**
		 * 对对象创建一个Buff
		 * @param	upGame		游戏的场景
		 * @param	role		buff释放者
		 * @param	target		受害者
		 * @param	effect		技能信息
		 */
		public static function create(upGame:UpGame, role:EDRole, target:EDRole, effect:OSkillEffect):void
		{
			var buff:EDSkillBuff = new EDSkillBuff(upGame);
			buff.owner = role;
			buff.target = target;
			buff.effect = effect;
			target.ai.buff.addBuff(buff);
		}
	}
}