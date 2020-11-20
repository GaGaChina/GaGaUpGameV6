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
	public class DisplayEDSingleEffect
	{
		/** 对象池 **/
		private static var __f:SpeedLib = new SpeedLib(150);
		/** 对象池强引用的最大数量 **/
		static public function get __m():uint { return __f.length; }
		/** 对象池强引用的最大数量 **/
		static public function set __m(value:uint):void { __f.length = value; }
		public static function instance():DisplayEDSingleEffect
		{
			var o:DisplayEDSingleEffect = __f.instance() as DisplayEDSingleEffect;
			if (o == null) o = new DisplayEDSingleEffect();
			return o;
		}
		
		/** 移除,清理,并回收 **/
		public function dispose():void
		{
			if (this.startTime != 0) this.startTime = 0;
			if (this.upGame)
			{
				var i:int = this.upGame.reader.singleLib.indexOf(this);
				if (i != -1)
				{
					this.upGame.reader.singleLib.splice(i, 1);
				}
				this.upGame = null;
			}
			if (this.length != 0)
			{
				for each (var item:IU2Base in this.list) 
				{
					item.dispose();
				}
				this.list.length = 0;
				this.listOver.length = 0;
				this.length = 0;
			}
			__f.recover(this);
		
		}
		
		private var upGame:UpGame;
		/** 开始时间 **/
		private var startTime:uint = 0;
		/** 多个对象 **/
		internal var list:Vector.<IU2Base> = new Vector.<IU2Base>();
		/** 多个对象的删除时间 **/
		private var listOver:Vector.<uint> = new Vector.<uint>();
		/** 显示对象的数量 **/
		private var length:int = 0;
		/** 临时变量 **/
		private var i:int;
		private var t:int;
		
		public function DisplayEDSingleEffect() { }
		
		/**
		 * 
		 * @param	upGame
		 * @param	startTime		开始播放的engineTime时间
		 * @param	path			路径
		 * @param	x				在地图上的坐标
		 * @param	y				在地图上的坐标
		 */
		public function setU2Link(upGame:UpGame, startTime:uint, path:String, x:int, y:int):void
		{
			this.upGame = upGame;
			this.startTime = startTime;
			var u2:U2InfoBaseInfo = upGame.reader.u2Info(path);
			if (u2)
			{
				var lib:Vector.<U2InfoBaseLayer> = u2.layer.lib;
				var displayLayer:DisplayLayer;
				var u2Base:IU2Base;
				for each (var layer:U2InfoBaseLayer in lib) 
				{
					displayLayer = EngineMap.getNameLayer(upGame.reader.map, layer.name);
					if (displayLayer)
					{
						u2Base = getU2Display(layer, x, y);
						if (u2Base)
						{
							pushDisplay(u2Base as IU2Base);
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
		public function setDisplay(upGame:UpGame, startTime:uint, path:String, x:int, y:int, layer:DisplayLayer, scaleX:Number = 1, scaleY:Number = 1, playTime:int = -1):void
		{
			this.upGame = upGame;
			this.startTime = startTime;
			var u2Base:Object = upGame.reader.u2(path);
			if (u2Base)
			{
				if (playTime == -1)
				{
					pushDisplay(u2Base as IU2Base);
				}
				else
				{
					list.push(u2Base as IU2Base);
					listOver.push(playTime);
					length++;
				}
				u2Base.setSizeInfo(x, y, 1, 0, scaleX, scaleY);
				if (u2Base.timer)
				{
					u2Base.timer.timeCore(upGame.engine.time.timeEngine, startTime, false, true);
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
						u2Base = upGame.reader.u2(d.path);
						if (u2Base)
						{
							u2Base.setSizeInfo((d.x + x), (d.y + y), d.alpha, d.rotation, d.scaleX, d.scaleY);
							if (u2Base.timer)
							{
								u2Base.timer.timeCore(upGame.engine.time.timeEngine, startTime, false, true);
							}
						}
					}
					else
					{
						u2Base = upGame.reader.bitmap(d.path)
						u2Base.data = layer.parent;
						if (u2Base)
						{
							u2Base.setOffsetInfo(d.x, d.y, d.alpha, d.rotation, d.scaleX, d.scaleY);
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
						u2Base = upGame.reader.u2(b.path);
						if (u2Base)
						{
							u2Base.setOffsetInfo(b.offsetX, b.offsetY, b.offsetAlpha, b.offsetRotation, b.offsetX, b.offsetY);
							u2Base.setSizeInfo(x, y);
							if (u2Base.timer)
							{
								u2Base.timer.timeCore(upGame.engine.time.timeEngine, startTime, false, true);
							}
						}
					}
					else
					{
						u2Base = upGame.reader.bitmap(b.path)
						u2Base.data = layer.parent;
						if (u2Base)
						{
							u2Base.setOffsetInfo(b.offsetX, b.offsetY, b.offsetAlpha, b.offsetRotation, b.offsetX, b.offsetY);
							u2Base.setSizeInfo(x, y);
						}
					}
				}
			}
			return u2Base as IU2Base;
		}
		
		/** 添加一个显示对象 **/
		private function pushDisplay(o:IU2Base):void
		{
			list.push(o);
			if(o.data && o.data.parent.layer.timeLength)
			{
				listOver.push(o.data.parent.layer.timeLength);
			}
			else
			{
				listOver.push(42);
			}
			length++;
		}
		
		/** 播放这个内容, 如果某一层播放完毕就删除,如果删除完毕就卸载这个对象 **/
		public function playThis(core:int):void
		{
			if (length != 0)
			{
				t = core - startTime;
				i = length;
				var item:Object;
				while (--i > -1)
				{
					item = list[i];
					if (listOver[i] > t)
					{
						if (item.timer)
						{
							item.timer.timeCore(core, startTime, false, true);
						}
					}
					else
					{
						list.splice(i, 1)
						listOver.splice(i, 1);
						length--;
						item.dispose();
						if (length == 0)
						{
							this.dispose();
							return;
						}
					}
				}
			}
			else
			{
				this.dispose();
			}
		}
	}
}