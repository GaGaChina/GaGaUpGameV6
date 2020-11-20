package cn.wjj.upgame.render 
{
	import cn.wjj.upgame.engine.EDDisplay;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 处理其他的显示对象
	 * 
	 * @author GaGa
	 */
	public class EngineEDDisplay 
	{
		
		public function EngineEDDisplay() { }
		
		/**
		 * 根据ED的数据来处理界面上的内容
		 * @param	u
		 * @param	camp
		 * @param	ed
		 */
		public static function run(u:UpGame, ed:EDDisplay, core:int):void
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
		public static function create(u:UpGame, ed:EDDisplay):DisplayEDU2LinkInfo
		{
			var u2LinkInfo:DisplayEDU2LinkInfo;
			if (ed.displayId)
			{
				u2LinkInfo = DisplayEDU2LinkInfo.instance();
				var path:String;
				if(ed.pathType == 0)
				{
					path = "assets/effect/skill/" + ed.displayId + ".u2";
				}
				else
				{
					path = "assets/effect/bullet/" + ed.displayId + ".u2";
				}
				if (u.modeTurn)
				{
					if (ed.angle < 180)
					{
						u2LinkInfo.setThis(u, ed, path, -ed.x, -ed.y, ed.angle + 180);
					}
					else
					{
						u2LinkInfo.setThis(u, ed, path, -ed.x, -ed.y, ed.angle - 180);
					}
					
				}
				else
				{
					u2LinkInfo.setThis(u, ed, path, ed.x, ed.y, ed.angle);
				}
				u.reader.map.display_ed[ed] = u2LinkInfo;
			}
			return u2LinkInfo;
		}
		
		/** 特效已经挂了,可以移除了 **/
		public static function die(u:UpGame, ed:EDDisplay):void
		{
			u.reader.removeED(ed);
		}
	}
}