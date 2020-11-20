package cn.wjj.upgame.render
{
	import cn.wjj.display.tween.LiteManage;
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.speedfact.SpeedLib;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * g.language.clearAllCacheChar();
	 * 
	 * g.language.cacheChar("+-0123456789", "flyNumber1", true);
	 * g.language.cacheChar("+-0123456789", "flyNumber2", true);
	 * g.language.cacheChar("+-0123456789", "flyNumber3", true);
	 * 
	 * 开始坐标偏下
	 * 结束坐标偏上
	 * 
	 */
	public class DisplayAttackNumber extends Bitmap
	{
		/** 对象池 **/
		private static var __f:SpeedLib = new SpeedLib(150);
		/** 对象池强引用的最大数量 **/
		static public function get __m():uint {return __f.length;}
		/** 对象池强引用的最大数量 **/
		static public function set __m(value:uint):void { __f.length = value; }
		
		/**
		 * 
		 * @param	num			影响数字,正数治疗,负数伤害
		 * @param	crit		是否爆击
		 * @param	startX		数字的起始坐标点
		 * @param	startY		数字的起始坐标点
		 */
		public function DisplayAttackNumber(num:int, crit:Boolean, startX:int, startY:int):void
		{
			play(num, crit, startX, startY);
		}
		
		/**
		 * 
		 * @param	num			影响数字,正数治疗,负数伤害
		 * @param	crit		是否爆击
		 * @param	startX		数字的起始坐标点
		 * @param	startY		数字的起始坐标点
		 * @return
		 */
		public static function instance(num:int, crit:Boolean, startX:int, startY:int):DisplayAttackNumber
		{
			var o:DisplayAttackNumber = __f.instance() as DisplayAttackNumber;
			if (o)
			{
				o.play(num, crit, startX, startY);
			}
			else
			{
				o = new DisplayAttackNumber(num, crit, startX, startY);
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
			return super.x - offsetX * scaleX;
		}
		
		override public function set x(value:Number):void 
		{
			value = value + offsetX * scaleX;
			if(super.x != value) super.x = value;
		}
		
		override public function get y():Number 
		{
			return super.y - offsetY * scaleY;
		}
		
		override public function set y(value:Number):void 
		{
			value = value + offsetY * scaleY;
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
		
		/** x轴偏移 **/
		public var offsetX:Number = 0;
		/** y轴偏移 **/
		public var offsetY:Number = 0;
		
		/** 播放设置 **/
		public function play(num:int, crit:Boolean, startX:int, startY:int):void
		{
			if (num < 0)
			{
				if (crit)
				{
					g.language.setDisplayCacheChar("-" + String( -num), DisplayNumber.skinAttackCrit, DisplayNumber.s, 1, 0, true);
					setThis();
					if(DisplayNumber.playMovieNumber)
					{
						x = startX;
						y = startY;
						scaleX = 0.1;
						scaleY = 0.1;
						//添加到场景
						LiteManage.append(this, 0.2, { x:startX, y:(startY - 15), scaleX:1.3, scaleY:1.3  });
						LiteManage.append(this, 0.13, { y:startY, scaleX:0.5, scaleY:0.5 } );
						LiteManage.append(this, 0.042, { scaleX:1, scaleY:1 } );
						//暂停    0.5
						LiteManage.append(this, 0.17, { y:(startY + 20), alpha:0, onComplete:dispose }, 0.3 );
					}
					else
					{
						x = startX;
						y = startY;
						LiteManage.append(this, 0, {onComplete:dispose}, 0.842 );
					}
				}
				else
				{
					g.language.setDisplayCacheChar("-" + String( -num), DisplayNumber.skinAttack, DisplayNumber.s, 1, 0, true);
					setThis();
					if(DisplayNumber.playMovieNumber)
					{
						x = startX;
						y = startY;
						scaleX = 0.1;
						scaleY = 0.1;
						//添加到场景
						LiteManage.append(this, 0.2, { x:startX, y:(startY - 15), scaleX:1.3, scaleY:1.3  });
						LiteManage.append(this, 0.13, { y:startY, scaleX:0.5, scaleY:0.5 } );
						LiteManage.append(this, 0.042, { scaleX:1, scaleY:1 } );
						//暂停    0.5
						LiteManage.append(this, 0.17, { y:(startY + 20), alpha:0, onComplete:dispose }, 0.3 );
					}
					else
					{
						x = startX;
						y = startY;
						LiteManage.append(this, 0, {onComplete:dispose}, 0.842 );
					}
				}
			}
			else
			{
				g.language.setDisplayCacheChar("+" + String(num), DisplayNumber.skinAdd, DisplayNumber.s, 1, 0, true);
				setThis();
				if(DisplayNumber.playMovieNumber)
				{
					x = startX;
					y = startY;
					this.scaleX = 0.1;
					this.scaleY = 0.1;
					//锁中心点
					//end = AttackNumber.cardCenter(affect);
					//end.x = end.x - 10;
					//添加到场景
					LiteManage.append(this, 0.3, { x:startX, y:(startY - 30), scaleX:1.4, scaleY:1.4 });
					LiteManage.append(this, 0.17, { scaleX:0.65, scaleY:0.65 } );
					LiteManage.append(this, 0.09, { scaleX:1, scaleY:1 } );
					//暂停    0.5
					LiteManage.append(this, 0.21, { y:(startY + 20), alpha:0, scaleX:0.85, scaleY:0.85, onComplete:dispose }, 0.3 );
				}
				else
				{
					x = startX;
					y = startY;
					LiteManage.append(this, 0, {onComplete:dispose}, 1.07 );
				}
			}
		}
		
		private function setThis():void
		{
			var b:BitmapData;
			if (DisplayNumber.s.numChildren)
			{
				var rect:Rectangle = DisplayNumber.s.getBounds(DisplayNumber.s);
				var x:int = Math.round(rect.x);
				var y:int = Math.round(rect.y);
				if (rect.isEmpty())
				{
					rect.width = 1;
					rect.height = 1;
				}
				b = new BitmapData(Math.ceil(rect.width), Math.ceil(rect.height), true, 0x00000000);
				DisplayNumber.m.tx = -x;
				DisplayNumber.m.ty = -y;
				b.drawWithQuality(DisplayNumber.s, DisplayNumber.m, null, null, null, true, "best");
				/*
				var realRect:Rectangle = b.getColorBoundsRect(0xFF000000, 0x00000000, false);
				if (!realRect.isEmpty() && (b.width != realRect.width || b.height != realRect.height))
				{
					var realBitData:BitmapData = new BitmapData(realRect.width, realRect.height, true, 0x00000000);
					realBitData.copyPixels(b, realRect, new Point());
					b.dispose();
					b = realBitData;
					x += realRect.x;
					y += realRect.y;
				}
				*/
				DisplayNumber.s.removeChildren();
			}
			else
			{
				b = new BitmapData(1, 1, true, 0x00000000);
			}
			this.bitmapData = b;
			offsetX = x;
			offsetY = y;
		}
	}
}

