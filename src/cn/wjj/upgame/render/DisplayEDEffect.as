package cn.wjj.upgame.render 
{
	import cn.wjj.display.ui2d.info.U2InfoBaseFrame;
	import cn.wjj.display.ui2d.info.U2InfoBaseFrameBitmap;
	import cn.wjj.display.ui2d.info.U2InfoBaseFrameDisplay;
	import cn.wjj.display.ui2d.info.U2InfoBaseInfo;
	import cn.wjj.display.ui2d.info.U2InfoBaseLayer;
	import cn.wjj.display.ui2d.info.U2InfoBitmap;
	import cn.wjj.display.ui2d.info.U2InfoDisplay;
	import cn.wjj.display.ui2d.info.U2InfoType;
	import cn.wjj.display.ui2d.IU2Base;
	import cn.wjj.display.ui2d.U2Bitmap;
	import cn.wjj.gagaframe.client.speedfact.SpeedLib;
	import cn.wjj.upgame.UpGame;
	import flash.display.DisplayObject;
	
	/**
	 * 一个一次性的对象
	 * 
	 * @author GaGa
	 */
	public class DisplayEDEffect
	{
		/** 对象池 **/
		private static var __f:SpeedLib = new SpeedLib(150);
		/** 对象池强引用的最大数量 **/
		static public function get __m():uint { return __f.length; }
		/** 对象池强引用的最大数量 **/
		static public function set __m(value:uint):void { __f.length = value; }
		public static function instance():DisplayEDEffect
		{
			var o:DisplayEDEffect = __f.instance() as DisplayEDEffect;
			if (o == null) o = new DisplayEDEffect();
			return o;
		}
		
		/** 移除,清理,并回收 **/
		public function dispose():void
		{
			if (this.startTime != 0) this.startTime = 0;
			if (this.u) this.u = null;
			if (this.length != 0)
			{
				for each (var item:IU2Base in this.list) 
				{
					item.dispose();
				}
				this.list.length = 0;
				this.length = 0;
			}
			__f.recover(this);
		}
		
		private var u:UpGame;
		/** 开始时间 **/
		private var startTime:uint = 0;
		/** 多个对象 **/
		internal var list:Vector.<IU2Base> = new Vector.<IU2Base>();
		/** 显示对象的数量 **/
		private var length:int = 0;
		/** 临时变量 **/
		private var i:int;
		
		public function DisplayEDEffect() { }
		
		/**
		 * 
		 * @param	u
		 * @param	startTime		开始播放的engineTime时间
		 * @param	path			路径
		 * @param	x				在地图上的坐标
		 * @param	y				在地图上的坐标
		 */
		public function setU2Link(u:UpGame, startTime:uint, path:String, x:int, y:int):void
		{
			this.u = u;
			this.startTime = startTime;
			var u2:U2InfoBaseInfo = u.reader.u2Info(path);
			if (u2)
			{
				var lib:Vector.<U2InfoBaseLayer> = u2.layer.lib;
				var displayLayer:DisplayLayer;
				var u2Base:IU2Base;
				for each (var layer:U2InfoBaseLayer in lib) 
				{
					displayLayer = EngineMap.getNameLayer(u.reader.map, layer.name);
					if (displayLayer)
					{
						u2Base = getU2Display(layer, x, y);
						if (u2Base)
						{
							list.push(u2Base);
							length++;
							displayLayer.addChild(u2Base as DisplayObject);
						}
					}
				}
			}
		}
		
		/**
		 * 如果不使用U2Link的方式来设置
		 * @param	upGame
		 * @param	startTime
		 * @param	path
		 * @param	x
		 * @param	y
		 * @param	layer		添加到那一个图层
		 * @param	scaleX		U2的缩放比例
		 * @param	scaleY
		 * @param	playTime	播放多少时间
		 */
		public function setDisplay(u:UpGame, startTime:uint, path:String, x:int, y:int, layer:DisplayLayer, scaleX:Number = 1, scaleY:Number = 1):void
		{
			this.u = u;
			this.startTime = startTime;
			var u2Base:Object = u.reader.u2(path);
			if (u2Base)
			{
				list.push(u2Base);
				length++;
				u2Base.setSizeInfo(x, y, 1, 0, scaleX, scaleY);
				if (u2Base.timer)
				{
					u2Base.timer.timeCore(u.engine.time.timeEngine, startTime, false, true);
				}
				layer.addChild(u2Base as DisplayObject);
			}
		}
		
		/** 通过图层信息来获取U2的显示对象 **/
		private function getU2Display(layer:U2InfoBaseLayer, x:int, y:int):IU2Base
		{
			var u2Base:Object;
			var frame:U2InfoBaseFrame = layer.lib[0];
			var d:U2InfoDisplay;
			if (frame.type == U2InfoType.baseFrameDisplay)
			{
				d = (frame as U2InfoBaseFrameDisplay).display;
				if (d && d.pathType != 0)
				{
					if (d.pathType == 1)
					{
						u2Base = u.reader.u2(d.path);
						if (u2Base)
						{
							u2Base.setSizeInfo((d.x + x), (d.y + y), d.alpha, d.rotation, d.scaleX, d.scaleY);
							if (u2Base.timer)
							{
								u2Base.timer.timeCore(u.engine.time.timeEngine, startTime, false, true);
							}
						}
					}
					else
					{
						u2Base = u.reader.bitmap(d.path)
						u2Base.data = layer.parent;
						if (u2Base)
						{
							(u2Base as U2Bitmap).setOffsetInfo( d.x, d.y, d.alpha, d.rotation, d.scaleX, d.scaleY);
							u2Base.setSizeInfo(x, y);
						}
					}
				}
			}
			else if (frame.type == U2InfoType.baseFrameBitmap)
			{
				var b:U2InfoBitmap = (frame as U2InfoBaseFrameBitmap).display;
				if (b && d.pathType != 0)
				{
					if (d.pathType == 1)
					{
						u2Base = u.reader.u2(b.path);
						if (u2Base)
						{
							(u2Base as U2Bitmap).setOffsetInfo(b.offsetX, b.offsetY, b.offsetAlpha, b.offsetRotation, b.offsetX, b.offsetY);
							u2Base.setSizeInfo(x, y);
							if (u2Base.timer)
							{
								u2Base.timer.timeCore(u.engine.time.timeEngine, startTime, false, true);
							}
						}
					}
					else
					{
						u2Base = u.reader.bitmap(b.path)
						u2Base.data = layer.parent;
						if (u2Base)
						{
							(u2Base as U2Bitmap).setOffsetInfo(b.offsetX, b.offsetY, b.offsetAlpha, b.offsetRotation, b.offsetX, b.offsetY);
							u2Base.setSizeInfo(x, y);
						}
					}
				}
			}
			return u2Base as IU2Base;
		}
		
		/**
		 * 修改位置
		 * @param	x
		 * @param	y
		 * @param	scaleX
		 * @param	scaleY
		 */
		public function changeSizeInfo(x:int, y:int, scaleX:Number = 1, scaleY:Number = 1):void
		{
			if (length)
			{
				for each (var item:IU2Base in list) 
				{
					item.setSizeInfo(x, y, 1, 0, scaleX, scaleY);
					/*
					if (item is U2Sprite)
					{
					}
					else
					{
						item as U2Bitmap
					}
					*/
				}
			}
		}
		
		/** 播放这个内容, 如果某一层播放完毕就删除,如果删除完毕就卸载这个对象 **/
		public function playThis(core:int):void
		{
			if (length != 0)
			{
				i = length;
				var item:Object;
				while (--i > -1)
				{
					item = list[i];
					if (item.timer)
					{
						item.timer.timeCore(core, startTime, false, true);
					}
				}
			}
		}
	}
}