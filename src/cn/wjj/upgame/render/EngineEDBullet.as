package cn.wjj.upgame.render 
{
	import cn.wjj.upgame.common.UpInfoDisplayType;
	import cn.wjj.upgame.engine.EDBullet;
	import cn.wjj.upgame.UpGame;
	import flash.display.DisplayObject;
	
	/**
	 * 对子弹的处理
	 * 
	 * @author GaGa
	 */
	public class EngineEDBullet 
	{
		/** 是否隐藏子弹 **/
		public static var hide:Boolean = false;
		
		public function EngineEDBullet() { }
		
		/**
		 * 根据ED的数据来处理界面上的内容
		 * @param	upGame
		 * @param	ed
		 */
		public static function run(u:UpGame, ed:EDBullet, core:int):void
		{
			if (EngineEDBullet.hide) return;
			var display:Object = u.reader.map.edToDisplay(ed);
			if (display == null) display = create(u, ed);
			if (display && ed.uiBase)
			{
				if (display is DisplayObject)
				{
					if (u.modeTurn)
					{
						display.x = -ed.x;
						display.y = -ed.y;
						if (ed.angle < 180)
						{
							display.rotation = ed.angle + 180;
						}
						else
						{
							display.rotation = ed.angle - 180;
						}
					}
					else
					{
						display.x = ed.x;
						display.y = ed.y;
						display.rotation = ed.angle;
					}
					display.alpha = ed.alpha;
					display.scaleX = ed.scaleX;
					display.scaleY = ed.scaleY;
				}
				else if (display is DisplayEDU2LinkInfo)
				{
					(display as DisplayEDU2LinkInfo).sendTime(core);
					if (u.modeTurn)
					{
						if (ed.angle < 180)
						{
							(display as DisplayEDU2LinkInfo).changeInfo(-ed.x, -ed.y, ed.angle + 180, ed.alpha, ed.scaleX, ed.scaleY);
						}
						else
						{
							(display as DisplayEDU2LinkInfo).changeInfo(-ed.x, -ed.y, ed.angle - 180, ed.alpha, ed.scaleX, ed.scaleY);
						}
					}
					else
					{
						(display as DisplayEDU2LinkInfo).changeInfo(ed.x, ed.y, ed.angle, ed.alpha, ed.scaleX, ed.scaleY);
					}
				}
			}
		}
		
		/** 通过ED数据来获取显示对象 **/
		private static function create(u:UpGame, ed:EDBullet):*
		{
			var display:DisplayObject;
			var u2LinkInfo:DisplayEDU2LinkInfo;
			if (ed.info.info.pathId && ed.info.info.pathType != UpInfoDisplayType.no)
			{
				switch (ed.info.info.pathType) 
				{
					case UpInfoDisplayType.u2:
						u2LinkInfo = DisplayEDU2LinkInfo.instance();
						if (u.modeTurn)
						{
							if (ed.angle < 180)
							{
								u2LinkInfo.setThis(u, ed, "assets/effect/bullet/" + ed.info.info.pathId + ".u2", -ed.x, -ed.y, ed.angle + 180, ed.alpha);
							}
							else
							{
								u2LinkInfo.setThis(u, ed, "assets/effect/bullet/" + ed.info.info.pathId + ".u2", -ed.x, -ed.y, ed.angle - 180, ed.alpha);
							}
						}
						else
						{
							u2LinkInfo.setThis(u, ed, "assets/effect/bullet/" + ed.info.info.pathId + ".u2", ed.x, ed.y, ed.angle, ed.alpha);
						}
						break;
					case UpInfoDisplayType.png:
						display = u.reader.bitmap("assets/effect/bullet/" + ed.info.info.pathId + ".png");
						break;
					case UpInfoDisplayType.jpg:
						display = u.reader.bitmap("assets/effect/bullet/" + ed.info.info.pathId + ".jpg");
						break;
					case UpInfoDisplayType.bitmap:
						display = u.reader.bitmap("assets/effect/bullet/" + ed.info.info.pathId + ".png");
						break;
				}
			}
			if(display)
			{
				u.reader.map.display_ed[ed] = display;
				u.reader.map.layer_groundEffectTop.addChild(display);
				return display;
			}
			if (u2LinkInfo)
			{
				u.reader.map.display_ed[ed] = u2LinkInfo;
				return u2LinkInfo;
			}
			return null;
		}
		
		/** 特效已经挂了,可以移除了 **/
		public static function die(u:UpGame, ed:EDBullet):void
		{
			u.reader.removeED(ed);
		}
	}
}