package cn.wjj.upgame.render 
{
	import cn.wjj.display.speed.BitmapText;
	import cn.wjj.display.tween.LiteManage;
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.speedfact.SBitmap;
	import cn.wjj.gagaframe.client.speedfact.SpeedLib;
	import cn.wjj.upgame.UpGame;
	import cn.wjj.upgame.UpGameConfig;
	import flash.display.Sprite;
	
	/**
	 * 费在中间
	 * 
	 * @author GaGa
	 */
	public class DisplayEnergy extends Sprite
	{
		/** 对象池 **/
		private static var __f:SpeedLib = new SpeedLib(10);
		/** 对象池强引用的最大数量 **/
		static public function get __m():uint { return __f.length; }
		/** 对象池强引用的最大数量 **/
		static public function set __m(value:uint):void { __f.length = value; }
		
		/**
		 * 初始化 Bitmap 对象以引用指定的 BitmapData 对象。
		 * @param	bitmapData		被引用的 BitmapData 对象。
		 * @param	pixelSnapping	Bitmap 对象是否贴紧至最近的像素。
		 * @param	smoothing		在缩放时是否对位图进行平滑处理。例如，下例显示使用系数 3 缩放的同一位图，smoothing 设置为 false（左侧）和 true（右侧）：
		 */
		public static function instance():DisplayEnergy
		{
			var o:DisplayEnergy = __f.instance() as DisplayEnergy;
			if (o == null) o = new DisplayEnergy();
			return o;
		}
		
		/** 移除,清理,并回收 **/
		public function dispose():void
		{
			LiteManage.killTweensOf(this);
			if (this.parent) this.parent.removeChild(this);
			if (this.bg != null)
			{
				this.bg.dispose();
				this.bg = null;
			}
			if (this.font != null)
			{
				this.font.dispose();
				this.font = null;
			}
			__f.recover(this);
		}
		
		/** 能量背景 **/
		private var bg:SBitmap;
		/** 现在的血量 **/
		private var hp:int = 0;
		/** 费的文字 **/
		private var font:BitmapText;
		
		public function DisplayEnergy() { }
		
		/**
		 * 初始化
		 * @param	u
		 * @param	change	显示出来的数量
		 * @param	x		坐标
		 * @param	y		坐标
		 */
		public function init(u:UpGame, change:int, x:int, y:int):void
		{
			this.x = x;
			this.y = y;
			if (bg == null) bg = SBitmap.instance();
			bg.bitmapData = UpGameConfig.imgDataEnergyBg;
			bg.scaleX = 0.8;
			bg.scaleY = 0.8;
			bg.x = -int(bg.width / 2);
			bg.y = -int(bg.height / 2);
			bg.smoothing = true;
			this.addChild(bg);
			if (font) font.dispose();
			font = g.language.getBitmapField(UpGameConfig.fontEnergy, change);
			font.scaleX = 0.75;
			font.scaleY = 0.75;
			font.x = -int(font.width / 2);
			font.y = -int(font.height / 2);
			this.addChild(font);
			//添加动画
			this.alpha = 0;
			u.reader.map.layer_flyHarm.addChild(this);
			//添加到场景
			LiteManage.append(this, 0.2, { y:y - 30, alpha:0.8 });
			LiteManage.append(this, 0.4, { y:y - 80 } );
			LiteManage.append(this, 0.15, { y:y + 100, alpha:0, onComplete:dispose }, 0.2 );
		}
	}
}