package cn.wjj.upgame.render 
{
	import cn.wjj.display.ui2d.info.U2InfoBaseFrame;
	import cn.wjj.display.ui2d.info.U2InfoBaseFrameBitmap;
	import cn.wjj.display.ui2d.info.U2InfoBaseFrameDisplay;
	import cn.wjj.display.ui2d.info.U2InfoBaseInfo;
	import cn.wjj.display.ui2d.info.U2InfoBaseLayer;
	import cn.wjj.display.ui2d.info.U2InfoBitmap;
	import cn.wjj.display.ui2d.info.U2InfoDisplay;
	import cn.wjj.display.ui2d.IU2Base;
	import cn.wjj.display.ui2d.U2Bitmap;
	import cn.wjj.gagaframe.client.speedfact.SpeedLib;
	import cn.wjj.upgame.engine.EDBase;
	import cn.wjj.upgame.UpGame;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * 一个绑定着 ED 驱动对象,和一裤衩的显示对象的对象
	 * 
	 * @author GaGa
	 */
	public class DisplayEDU2LinkInfo
	{
		/** 对象池 **/
		private static var __f:SpeedLib = new SpeedLib(150);
		/** 对象池强引用的最大数量 **/
		static public function get __m():uint { return __f.length; }
		/** 对象池强引用的最大数量 **/
		static public function set __m(value:uint):void { __f.length = value; }
		public static function instance():DisplayEDU2LinkInfo
		{
			var o:DisplayEDU2LinkInfo = __f.instance() as DisplayEDU2LinkInfo;
			if (o == null) o = new DisplayEDU2LinkInfo();
			return o;
		}
		
		/** 移除,清理,并回收 **/
		public function dispose():void
		{
			if (this._x != 0) this._x = 0;
			if (this._y != 0) this._y = 0;
			if (this._angle != 0) this._angle = 0;
			if (this._alpha != 1) this._alpha = 1;
			if (this._scaleX != 1) this._scaleX = 1;
			if (this._scaleY != 1) this._scaleY = 1;
			if (this.length != 0)
			{
				if (this.lengthU2 != 0)
				{
					for each (var item:IU2Base in this.list) 
					{
						item.dispose();
					}
					this.list.length = 0;
					this.listInfo.length = 0;
					this.lengthU2 = 0;
				}
				if (this.emb != null)
				{
					this.emb.dispose();
					this.emb = null;
				}
				if (this.embLayerName != "") this.embLayerName = "";
				if (this.embContainer != null) this.embContainer = null;
				this.length = 0;
			}
			if (this.ed != null) this.ed = null;
			if (this.u2  != null) this.u2  = null;
			__f.recover(this);
		}
		
		/**  **/
		public var upGame:UpGame;
		/** 对象的引用 **/
		public var ed:EDBase;
		/** 对象的所在图层,用于将相同图层内容置入对象,如果是这样,将不会改变内容的坐标 **/
		public var edLayer:DisplayLayer;
		/** 如果对象与图层吻合是否将图层植入 **/
		public var edLayerIn:Boolean = true;
		private var _x:int = 0;
		private var _y:int = 0;
		private var _angle:int = 0;
		private var _alpha:Number = 1;
		private var _scaleX:Number = 1;
		private var _scaleY:Number = 1;
		/** 多个对象 **/
		public var list:Vector.<IU2Base> = new Vector.<IU2Base>();
		/** 多个对象的数据引用 **/
		public var listInfo:Vector.<U2InfoBaseLayer> = new Vector.<U2InfoBaseLayer>();
		/** 显示对象的数量 **/
		public var length:uint = 0;
		/** U2显示对象的数量 **/
		public var lengthU2:uint = 0;
		/** 数据的原始引用 **/
		public var u2:U2InfoBaseInfo;
		/** 临时变量 **/
		private var i:int;
		/** 是否有嵌入的显示对象 **/
		public var emb:IU2Base;
		/** 嵌入的图层名称 **/
		public var embLayerName:String = "";
		/** 嵌入的图层的容器 **/
		public var embContainer:DisplayObjectContainer;
		
		public function DisplayEDU2LinkInfo() { }
		
		/**
		 * 设置需要嵌入的内容
		 * @param	layerName	如果图层为这个名字
		 * @param	container	就丢到container图层内
		 */
		public function setEmb(layerName:String, container:DisplayObjectContainer):void
		{
			this.embLayerName = layerName;
			this.embContainer = container;
		}
		
		
		
		/** 设置这个对象的信息 **/
		public function setThis(upGame:UpGame, ed:EDBase, path:String, x:int, y:int, angle:int = 0, alpha:Number = 1, scaleX:Number = 1, scaleY:Number = 1, u2Info:U2InfoBaseInfo = null):void
		{
			this.upGame = upGame;
			if(u2Info)
			{
				u2 = u2Info;
			}
			else
			{
				u2 = upGame.reader.u2Info(path);
			}
			if (u2)
			{
				_x = x;
				_y = y;
				_angle = angle;
				_alpha = alpha;
				_scaleX = scaleX;
				_scaleY = scaleY;
				var lib:Vector.<U2InfoBaseLayer> = u2.layer.lib;
				var displayLayer:DisplayLayer;
				var u2Base:IU2Base;
				for each (var layer:U2InfoBaseLayer in lib)
				{
					if (embLayerName == layer.name)
					{
						u2Base = getU2Display(layer, false, ed.creatTime);
						if (u2Base)
						{
							length++;
							emb = u2Base;
							embContainer.addChild(emb as DisplayObject);
						}
					}
					else
					{
						displayLayer = EngineMap.getNameLayer(upGame.reader.map, layer.name);
						if (displayLayer)
						{
							u2Base = getU2Display(layer, true, ed.creatTime);
							if (u2Base)
							{
								list.push(u2Base);
								listInfo.push(layer);
								length++;
								lengthU2++;
								displayLayer.addChild(u2Base as DisplayObject);
							}
						}
					}
				}
				if (embLayerName != "" && emb == null)
				{
					embLayerName = "";
					embContainer = null;
				}
			}
		}
		
		/** 通过图层信息来获取U2的显示对象 **/
		private function getU2Display(layer:U2InfoBaseLayer, changeSize:Boolean, start:int):IU2Base
		{
			var frame:U2InfoBaseFrame = layer.lib[0];
			var o:IU2Base, d:U2InfoDisplay, b:U2InfoBitmap;
			if (frame is U2InfoBaseFrameDisplay)
			{
				d = (frame as U2InfoBaseFrameDisplay).display;
			}
			if (d)
			{
				if (d.pathType != 0)
				{
					if (d.pathType == 1)
					{
						o = upGame.reader.u2(d.path, false, start) as IU2Base;
						if (o)
						{
							if (changeSize)
							{
								o.setSizeInfo((d.x + _x), (d.y + _y), (d.alpha * _alpha), (d.rotation + _angle), (_scaleX * d.scaleX), (_scaleY * d.scaleY));
							}
							else
							{
								o.setSizeInfo(d.x, d.y, d.alpha, d.rotation, d.scaleX, d.scaleY);
							}
						}
					}
					else
					{
						o = upGame.reader.bitmap(d.path);
						if (o)
						{
							(o as U2Bitmap).setOffsetInfo(d.x, d.y, d.alpha, d.rotation, d.scaleX, d.scaleY);
							if (changeSize) o.setSizeInfo(_x, _y, _alpha, _angle, _scaleX, _scaleY);
						}
					}
				}
			}
			else if (frame is U2InfoBaseFrameBitmap)
			{
				b = (frame as U2InfoBaseFrameBitmap).display;
				if (b.path)
				{
					if (b.path.substr(-3, 3))
					{
						o = upGame.reader.u2(b.path, false, start) as IU2Base;
						if (o)
						{
							(o as U2Bitmap).setOffsetInfo(b.offsetX, b.offsetY, b.offsetAlpha, b.offsetRotation, b.offsetX, b.offsetY);
						}
					}
					else
					{
						o = upGame.reader.bitmap(d.path);
						if (o)
						{
							(o as U2Bitmap).setOffsetInfo(b.offsetX, b.offsetY, b.offsetAlpha, b.offsetRotation, b.offsetX, b.offsetY);
						}
					}
					if (changeSize && o) o.setSizeInfo(_x, _y, _alpha, _angle, _scaleX, _scaleY);
				}
			}
			return o;
		}
		
		private function pushDisplay(o:IU2Base, info:U2InfoBaseLayer):void
		{
			list.push(o);
			listInfo.push(info);
			length++;
			lengthU2++;
		}
		
		/** 为动画传递时间 **/
		public function sendTime(core:int = -1):void
		{
			if (length > 0)
			{
				if (emb && (emb as Object).timer) (emb as Object).timer.timeCore(core, -1, false, true);
				if (lengthU2)
				{
					for each (var o:Object in list) 
					{
						if (o.timer) o.timer.timeCore(core, -1, false, true);
					}
				}
			}
		}
		
		/** 移动这个显示队列 **/
		public function changeInfo(x:int, y:int, angle:int = 0, alpha:Number = 1, scaleX:Number = 1, scaleY:Number = 1, time:int = -1):void
		{
			if (length > 0 && u2 && (_x != x || _y != y || _angle != angle || _alpha != alpha || _scaleX != scaleX || _scaleY != scaleY))
			{
				_x = x;
				_y = y;
				_angle = angle;
				_alpha = alpha;
				_scaleX = scaleX;
				_scaleY = scaleY;
				if (lengthU2)
				{
					var o:Object, layer:U2InfoBaseLayer;
					var frame:U2InfoBaseFrame;
					var d:U2InfoDisplay, b:U2InfoBitmap;
					for (i = 0; i < lengthU2; i++) 
					{
						o = list[i];
						if (o.timer) o.timer.timeCore(time, -1, false, true);
						layer = listInfo[i];
						frame = layer.lib[0];
						if (frame is U2InfoBaseFrameDisplay)
						{
							d = (frame as U2InfoBaseFrameDisplay).display;
						}
						if (d)
						{
							if (d.pathType == 1)
							{
								o.setSizeInfo((d.x + _x), (d.y + _y), (d.alpha * _alpha), (d.rotation + _angle), (_scaleX * d.scaleX), (_scaleY * d.scaleY));
							}
							else
							{
								o.setSizeInfo(_x, _y, _alpha, _angle, _scaleX, _scaleY);
							}
						}
						else if (frame is U2InfoBaseFrameBitmap)
						{
							o.setSizeInfo(_x, _y, _alpha, _angle, _scaleX, _scaleY);
						}
					}
				}
			}
		}
	}
}