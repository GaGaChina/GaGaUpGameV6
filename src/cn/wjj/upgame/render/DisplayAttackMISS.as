package cn.wjj.upgame.render
{
	import cn.wjj.display.tween.LiteManage;
	import cn.wjj.gagaframe.client.speedfact.SpeedLib;
	import flash.display.Bitmap;
	
	/**
	 * 战斗中的Miss内容,要提前设置Miss的BitmapData
	 * 调用 setMISS 方法
	 */
	public class DisplayAttackMISS extends Bitmap
	{
		/** 对象池 **/
		private static var __f:SpeedLib = new SpeedLib(40);
		/** 对象池强引用的最大数量 **/
		static public function get __m():uint {return __f.length;}
		/** 对象池强引用的最大数量 **/
		static public function set __m(value:uint):void { __f.length = value; }
		
		/**
		 * 继承于Bitmap的对象
		 * @param info
		 */
		public function DisplayAttackMISS(startX:int, startY:int):void
		{
			this.bitmapData = DisplayNumber.miss.bitmapData;
			super.x = DisplayNumber.miss.x;
			super.y = DisplayNumber.miss.y;
			play(startX, startY);
		}
		
		/**
		 * 继承于Bitmap的对象
		 * @param info
		 */
		public static function instance(startX:int, startY:int):DisplayAttackMISS
		{
			var o:DisplayAttackMISS = __f.instance() as DisplayAttackMISS;
			if (o)
			{
				o.bitmapData = DisplayNumber.miss.bitmapData;
				o.x = 0;
				o.y = 0;
				o.play(startX, startY);
			}
			else
			{
				o = new DisplayAttackMISS(startX, startY);
			}
			return o;
		}
		
		/** 移除,清理,并回收 **/
		public function dispose():void
		{
			LiteManage.killTweensOf(this);
			if (this.parent) this.parent.removeChild(this);
			if (this.bitmapData != null) this.bitmapData = null;
			if (this.scaleX != 1) this.scaleX = 1;
			if (this.scaleY != 1) this.scaleY = 1;
			if (this.visible != true) this.visible = true;
			if (this.alpha != 1) this.alpha = 1;
			__f.recover(this);
		}
		
		//----------------------------------------------------覆盖的方法-----------------------------------------------------
		
		override public function get x():Number 
		{
			return super.x - DisplayNumber.miss.x * scaleX;
		}
		
		override public function set x(value:Number):void 
		{
			value = value + DisplayNumber.miss.x * scaleX;
			if(super.x != value) super.x = value;
		}
		
		override public function get y():Number 
		{
			return super.y - DisplayNumber.miss.y * scaleY;
		}
		
		override public function set y(value:Number):void 
		{
			value = value + DisplayNumber.miss.y * scaleY;
			if(super.y != value) super.y = value;
		}
		
		override public function set scaleX(value:Number):void 
		{
			var temp:Number = x;
			super.scaleX = value;
			x = temp;
		}
		
		override public function set scaleY(value:Number):void 
		{
			var temp:Number = y;
			super.scaleY = value;
			y = temp;
		}
		
		/**
		 * 设置并播放动画
		 * @param	startX
		 * @param	startY
		 */
		private function play(startX:int, startY:int):void
		{
			this.x = startX;
			this.y = startY;
			if(DisplayNumber.playMovieMiss)
			{
				scaleX = 0.1;
				scaleY = 0.1;
				LiteManage.append(this, 0.3, { x:startX, y:(startY - 30), scaleX:1.4, scaleY:1.4  } );
				LiteManage.append(this, 0.17, { scaleX:0.65, scaleY:0.65 } );
				LiteManage.append(this, 0.09, { scaleX:1, scaleY:1 } );
				//暂停    0.5
				LiteManage.append(this, 0.21, { y:(startY+ 20), alpha:0, scaleX:0.85, scaleY:0.85, onComplete:dispose }, 0.3 );
			}
			else
			{
				LiteManage.append(this, 0, { onComplete:dispose }, 1.07 );
			}
		}
	}
}
