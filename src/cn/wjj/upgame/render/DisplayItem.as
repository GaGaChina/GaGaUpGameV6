package cn.wjj.upgame.render 
{
	import cn.wjj.display.ui2d.info.U2InfoBaseInfo;
	import cn.wjj.display.ui2d.IU2Base;
	import cn.wjj.display.ui2d.U2Bitmap;
	import cn.wjj.gagaframe.client.speedfact.SpeedLib;
	import cn.wjj.upgame.common.IDisplayItem;
	import cn.wjj.upgame.common.UpInfoDisplayType;
	import cn.wjj.upgame.info.UpInfoDisplay;
	import cn.wjj.upgame.UpGame;
	import flash.display.DisplayObject;
	
	/**
	 * 虚拟的显示对象,从里面可以取出来图片
	 * 只作用编辑图层
	 * @author GaGa
	 */
	public class DisplayItem implements IDisplayItem 
	{
		/** 对象池 **/
		private static var __f:SpeedLib = new SpeedLib(70);
		/** 对象池强引用的最大数量 **/
		static public function get __m():uint {return __f.length;}
		/** 对象池强引用的最大数量 **/
		static public function set __m(value:uint):void { __f.length = value; }
		
		public function DisplayItem() { }
		
		public static function instance():DisplayItem
		{
			var o:DisplayItem = __f.instance() as DisplayItem;
			if (o) return o;
			return new DisplayItem();
		}
		
		public function dispose():void
		{
			this.removeDisplay();
			if (this.selfEngine) this.selfEngine  = false;
			if (this.sendCore) this.sendCore = false;
			if (this.layer  != null) this.layer  = null;
			if (this.info  != null) this.info  = null;
			if (this.upGame != null) this.upGame = null;
			__f.recover(this);
		}
		/********************************************实际代码部分********************************************/
		/** 父引用 **/
		public var upGame:UpGame;
		/** 显示对象的信息 **/
		public var info:UpInfoDisplay;
		/** 是否自己驱动 **/
		public var selfEngine:Boolean = false;
		/** 图层 **/
		public var layer:DisplayLayer;
		/** 获取的时候不会创建新的**/
		public var _display:DisplayObject;
		/** 是否需要传递时间进行播放 **/
		public var sendCore:Boolean = false;
		/** 是否已经添加进图层 **/
		public var inLayer:Boolean = false;
		
		public function get display():DisplayObject
		{
			if (_display) return _display;
			if (info && info.path)
			{
				var u2Info:U2InfoBaseInfo;
				switch (info.displayType) 
				{
					case UpInfoDisplayType.u2:
						u2Info = upGame.reader.u2Info(info.path);
						if (u2Info)
						{
							if (info.rotation == 0 && u2Info.contour.startX != u2Info.contour.endX && info.isSetXY == false)
							{
								if (info.scaleX < 0)
								{
									info.sx1 = u2Info.contour.endX * info.scaleX + info.x;
									info.sx2 = u2Info.contour.startX * info.scaleX + info.x;
								}
								else
								{
									info.sx1 = u2Info.contour.startX * info.scaleX + info.x;
									info.sx2 = u2Info.contour.endX * info.scaleX + info.x;
								}
								if (info.scaleY < 0)
								{
									info.sy1 = u2Info.contour.endY * info.scaleY + info.y;
									info.sy2 = u2Info.contour.startY * info.scaleY + info.y;
								}
								else
								{
									info.sy1 = u2Info.contour.startY * info.scaleY + info.y;
									info.sy2 = u2Info.contour.endY * info.scaleY + info.y;
								}
								info.isSetXY = true;
							}
							_display = upGame.reader.u2UseInfo(u2Info, selfEngine);
							if (_display)
							{
								if(u2Info.layer.isPlay && (_display as Object).timer)
								{
									sendCore = true;
								}
								(_display as IU2Base).setSizeInfo(info.x, info.y, info.alpha, info.rotation, info.scaleX, info.scaleY);
								layer.display_info[_display] = this;
							}
						}
						break;
					case UpInfoDisplayType.bitmap:
						_display = upGame.reader.bitmap(info.path);
						if (_display)
						{
							(_display as U2Bitmap).setSizeInfo(info.x, info.y, info.alpha, info.rotation, info.scaleX, info.scaleY);
							layer.display_info[_display] = this;
							if (info.isSetXY == false && info.rotation == 0)
							{
								//将要完全算出坐标内容
								
								if (info.scaleX > 0)
								{
									info.sx1 = (_display as U2Bitmap).superX;
									info.sx2 = info.sx1 + _display.width;
								}
								else
								{
									info.sx2 = (_display as U2Bitmap).superX;
									info.sx1 = info.sx2 - _display.width;
								}
								if (info.scaleY > 0)
								{
									info.sy1 = (_display as U2Bitmap).superY;
									info.sy2 = info.sy1 + _display.height;
								}
								else
								{
									info.sy2 = (_display as U2Bitmap).superY;
									info.sy1 = info.sy2 - _display.height;
								}
								info.isSetXY = true;
							}
						}
						break;
				}
			}
			return _display;
		}
		
		/** 添加到场景上 **/
		public function addInLayer():void
		{
			layer.addChild(display);
		}
		
		/** 从场景上移除 **/
		public function removeDisplay():void
		{
			if (_display)
			{
				delete layer.display_info[_display];
				if (_display.parent)_display.parent.removeChild(_display);
				(_display as Object).dispose();
				_display = null;
				if (sendCore) sendCore = false;
			}
		}
	}

}