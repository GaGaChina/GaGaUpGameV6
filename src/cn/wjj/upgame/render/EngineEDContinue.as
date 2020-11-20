package cn.wjj.upgame.render 
{
	import cn.wjj.upgame.engine.EDSkillContinue;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 对地面持续特效进行处理,比如燃烧弹
	 * 
	 * @author GaGa
	 */
	public class EngineEDContinue 
	{
		
		public function EngineEDContinue() { }
		
		/**
		 * 根据ED的数据来处理界面上的内容
		 * @param	upGame
		 * @param	ed
		 */
		public static function run(u:UpGame, ed:EDSkillContinue, core:int):void
		{
			var display:DisplayEDU2LinkInfo = u.reader.map.edToDisplay(ed) as DisplayEDU2LinkInfo;
			if (display == null)
			{
				display = create(u, ed);
			}
			else
			{
				display.sendTime(core);
			}
		}
		
		/** 通过ED数据来获取显示对象 **/
		public static function create(u:UpGame, ed:EDSkillContinue):DisplayEDU2LinkInfo
		{
			var u2LinkInfo:DisplayEDU2LinkInfo;
			if (ed.effect.effect.hitEffect)
			{
				u2LinkInfo = DisplayEDU2LinkInfo.instance();
				if (u.modeTurn)
				{
					u2LinkInfo.setThis(u, ed, "assets/effect/skill/" + ed.effect.effect.hitEffect + ".u2", -ed.x, -ed.y);
				}
				else
				{
					u2LinkInfo.setThis(u, ed, "assets/effect/skill/" + ed.effect.effect.hitEffect + ".u2", ed.x, ed.y);
				}
				u.reader.map.display_ed[ed] = u2LinkInfo;
			}
			return u2LinkInfo;
		}
		
		/** 特效已经挂了,可以移除了 **/
		public static function die(u:UpGame, ed:EDSkillContinue):void
		{
			u.reader.removeED(ed);
		}
	}
}