package cn.wjj.upgame.render 
{
	import cn.wjj.display.MPoint;
	import cn.wjj.upgame.common.IDisplay;
	import cn.wjj.upgame.info.UpInfoDisplay;
	import cn.wjj.upgame.info.UpInfoLayer;
	import cn.wjj.upgame.UpGame;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	/**
	 * 每一个图层
	 * 
	 * @author GaGa
	 */
	public class DisplayLayer extends Sprite implements IDisplay 
	{
		/** 父引用 **/
		private var u:UpGame;
		/** 所使用的信息 **/
		private var _info:UpInfoLayer;
		/** 被设置的坐标 **/
		private var _x:Number = 0;
		/** 被设置的坐标 **/
		private var _y:Number = 0;
		/** 设置的比例 **/
		private var _scaleX:Number;
		/** 设置的比例 **/
		private var _scaleY:Number;
		/** 地图现在的坐标 **/
		private var _mapX:Number = 0;
		/** 地图现在的坐标 **/
		private var _mapY:Number = 0;
		/** 显示区域现在综合的坐标点 **/
		private var _changeX:int = 999999;
		/** 显示区域现在综合的坐标点 **/
		private var _changeY:int = 999999;
		/** 震动的偏移比例坐标 **/
		private var _shockSX:Number = 0;
		/** 震动的偏移比例坐标 **/
		private var _shockSY:Number = 0;
		/** 震动的偏移坐标 **/
		private var _shockX:Number = 0;
		/** 震动的偏移坐标 **/
		private var _shockY:Number = 0;
		/** [禁止直接操作]图层里的全部的显示对象(全是编辑数据) **/
		public var lib:Vector.<DisplayItem>;
		/** 图层的内容长度 **/
		public var libLength:int = 0;
		/** 是否有改变坐标或内容的地方 **/
		public var reIndex:Boolean = false;
		/** 数据对应显示对象 UpInfoDisplay = DisplayItem **/
		internal var info_display:Dictionary;
		/** 显示对象对应数据 **/
		internal var display_info:Dictionary;
		/** 内容层级控制层 **/
		//private var indexManage:LayerIndexManage;
		/** 是否已经添加进图层 **/
		public var inMap:Boolean = false;
		
		/** 场景正对0.0点显示区域,左边的区域延伸叠加值 **/
		public var stageX1:int = 0;
		/** 场景正对0.0点显示区域,右边的区域延伸叠加值 **/
		public var stageX2:int = 0;
		/** 场景正对0.0点显示区域,上边的区域延伸叠加值 **/
		public var stageY1:int = 0;
		/** 场景正对0.0点显示区域,下边的区域延伸叠加值 **/
		public var stageY2:int = 0;
		
		public function DisplayLayer(u:UpGame) 
		{
			this.u = u;
			lib = new Vector.<DisplayItem>();
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		override public function get x():Number { return _x; }
		override public function get y():Number { return _y; }
		override public function get scaleX():Number { return _scaleX; }
		override public function get scaleY():Number { return _scaleY; }
		override public function set x(value:Number):void { }
		override public function set y(value:Number):void { }
		override public function set scaleX(value:Number):void { }
		override public function set scaleY(value:Number):void { }
		
		/** 通过数据返回显示对象的数据 **/
		public static function infoToItem(layer:DisplayLayer, info:UpInfoDisplay):DisplayItem
		{
			if (layer && layer.info_display)
			{
				return layer.info_display[info];
			}
			return null;
		}
		
		/** 通过显示对象来这个图层中查找出数据对象 **/
		public static function displayToInfo(layer:DisplayLayer, display:DisplayObject):DisplayItem
		{
			if (layer && layer.display_info)
			{
				return layer.display_info[display];
			}
			return null;
		}
		
		/** 移动图层 **/
		internal function moveMap(mapX:Number, mapY:Number):void
		{
			if (this._mapX != mapX || this._mapY != mapY)
			{
				this._mapX = mapX;
				this._mapY = mapY;
				pointCount();
				changeStageXY();
			}
		}
		
		/**
		 * 将地图里的坐标转换为本图层的坐标
		 * @param	mapX	全局地图坐标
		 * @param	mapY	全局地图坐标
		 * @return
		 */
		public function mapPointToLocal(mapX:Number, mapY:Number):MPoint
		{
			var p:MPoint = MPoint.instance();
			p.x = int(mapX - (mapX * _info.speedX));
			p.y = int(mapY - (mapY * _info.speedY));
			return p;
		}
		
		/** 找出现在显示区域的范围 **/
		internal function changeStageXY():void
		{
			var x1:Number = _x + _mapX - (_mapX * _info.speedX);
			var y1:Number = _y + _mapY - (_mapY * _info.speedY);
			var item:DisplayItem;
			var index:int = -1;
			if (u.reader.stageStart)
			{
				stageX1 = int((u.reader.stageX1 + x1 - _info.shockX) * _info.scaleX);
				stageX2 = int((u.reader.stageX2 + x1 + _info.shockX) * _info.scaleX);
				stageY1 = int((u.reader.stageY1 + y1 - _info.shockY) * _info.scaleY);
				stageY2 = int((u.reader.stageY2 + y1 + _info.shockY) * _info.scaleY);
				if (libLength)
				{
					x1 = x1 * _info.scaleX;
					y1 = y1 * _info.scaleX;
					x1 = int(x1 / UpReader.stageAddDist);
					y1 = int(y1 / UpReader.stageAddDist);
					if (x1 != _changeX || y1 != _changeY)
					{
						_changeX = x1;
						_changeY = y1;
						//遍历子元件看是否需要添加
						var add:Boolean;
						for each (item in lib)
						{
							if (item.info.isSetXY)
							{
								if (item.info.sx1 < stageX2 && item.info.sx2 > stageX1 && item.info.sy1 < stageY2 && item.info.sy2 >stageY1)
								{
									add = true;
								}
								else
								{
									add = false;
								}
							}
							else
							{
								var sx:Number = item.info.scaleX;
								var sy:Number = item.info.scaleY;
								if (sx < 0) sx = -sx;
								if (sy < 0) sy = -sy;
								if ((-600 * sx + item.info.x) < stageX2 && (600 * sx + item.info.x) > stageX1 && (-600 * sy + item.info.y) < stageY2 && (600 * sy + item.info.y) >stageY1)
								{
									add = true;
								}
								else
								{
									add = false;
								}
								//add = true;
							}
							if (add)
							{
								if (item.inLayer)
								{
									index++;
								}
								else if (item.display)
								{
									index++;
									item.inLayer = true;
									this.addChildAt(item._display, index);
								}
							}
							else if(item.inLayer)
							{
								item.inLayer = false;
								if (item._display)
								{
									item.removeDisplay();
								}
							}
						}
					}
				}
			}
			else if (libLength)
			{
				for each (item in lib) 
				{
					if (item.inLayer)
					{
						index++;
					}
					else if (item.display)
					{
						index++;
						item.inLayer = true;
						this.addChildAt(item._display, index);
					}
				}
			}
		}
		
		/** 输出本这样的XY,在本图层,在range的上下左右扩展范围内,是否可以显示在场景中 **/
		public function canInLayer(x:int, y:int, range:int):Boolean
		{
			if ((x - range) < stageX2 && (x + range) > stageX1 && (y - range) < stageY2 && (y + range) >stageY1)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * 震动图层
		 * @param	x	震动的比例
		 * @param	y	震动的比例
		 */
		internal function shock(x:Number, y:Number):void
		{
			if (_shockSX != x || _shockSY != y)
			{
				_shockSX = x;
				_shockSY = y;
				if (_info.shockX != 0 || _info.shockY != 0)
				{
					_shockX = x * _info.shockX;
					_shockY = y * _info.shockY;
					pointCount();
				}
			}
		}
		
		/** 计算并设置现在的坐标 **/
		private function pointCount():void
		{
			var x1:int = int(_x + _shockX + (_mapX * _info.speedX));
			var y1:int = int(_y + _shockY + (_mapY * _info.speedY));
			if (super.x != x1) super.x = x1;
			if (super.y != y1) super.y = y1;
			if (super.scaleX != _info.scaleX) super.scaleX = _info.scaleX;
			if (super.scaleY != _info.scaleY) super.scaleY = _info.scaleY;
		}
		
		public function get shockX():Number { return _shockX; }
		public function set shockX(value:Number):void { if (_shockX != value) { _shockX = value; pointCount(); }}
		public function get shockY():Number { return _shockY; }
		public function set shockY(value:Number):void { if (_shockY != value) { _shockY = value; pointCount(); }}
		
		public function get info():UpInfoLayer { return _info; }
		public function set info(value:UpInfoLayer):void 
		{
			if (value == null)
			{
				_info = value;
			}
			else
			{
				_info = value;
				infoCount();
			}
		}
		
		/** 重新规整Info的参数 **/
		public function infoCount():void
		{
			var change:Boolean = false;
			this.name = _info.name;
			this.rotation = _info.rotation;
			if (this._x != _info.x)
			{
				this._x = _info.x;
				change = true;
			}
			if (this._y != _info.y)
			{
				this._y = _info.y;
				change = true;
			}
			if (this._scaleX != _info.scaleX)
			{
				this._scaleX = _info.scaleX;
				change = true;
			}
			if (this._scaleY != _info.scaleY)
			{
				this._scaleY = _info.scaleY;
				change = true;
			}
			if (change) pointCount();
		}
				
		public function dispose():void 
		{
			if (libLength)
			{
				for each (var item:DisplayItem in lib) 
				{
					if (item._display)
					{
						delete display_info[item._display];
						(item._display as Object).dispose();
						if (item.sendCore) item.sendCore = false;
						item._display = null;
					}
					item.dispose();
				}
				lib.length = 0;
				libLength = 0;
			}
			/*
			var i:int = numChildren;
			if (i)
			{
				var d:Object;
				while (--i > -1)
				{
					d = removeChildAt(i);
					if ("dispose" in d)
					{
						d.dispose();
					}
				}
				removeChildren();
			}
			*/
			removeChildren();
			info_display = null;
			display_info = null;
		}
	}
}