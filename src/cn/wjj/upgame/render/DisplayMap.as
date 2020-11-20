package cn.wjj.upgame.render
{
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.factory.FShape;
	import cn.wjj.upgame.common.IDisplayMap;
	import cn.wjj.upgame.engine.EDBase;
	import cn.wjj.upgame.info.UpInfo;
	import cn.wjj.upgame.info.UpInfoLayer;
	import cn.wjj.upgame.task.TaskItemBase;
	import cn.wjj.upgame.UpGame;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * 地图的内容
	 * 
	 * @author GaGa
	 */
	public class DisplayMap extends Sprite implements IDisplayMap 
	{
		/** 父引用 **/
		public var upGame:UpGame;
		/** 所使用的数据 **/
		public var info:UpInfo;
		/** 被设置的坐标 **/
		private var _x:Number = 0;
		/** 被设置的坐标 **/
		private var _y:Number = 0;
		/** 地图现在的坐标 **/
		private var _mapX:Number = 0;
		/** 地图现在的坐标 **/
		private var _mapY:Number = 0;
		/** 上一次处理显示对象的坐标 **/
		internal var _ox:Number = 0;
		/** 上一次处理显示对象的坐标 **/
		internal var _oy:Number = 0;
		/** 地图显示区域宽度 **/
		private var _width:int = 0;
		/** 地图显示区域高度 **/
		private var _height:int = 0;
		/** 震动的偏移坐标 **/
		private var _shockX:Number = 0;
		/** 震动的偏移坐标 **/
		private var _shockY:Number = 0;
		/** X轴震动的最大频率 **/
		public var shockMaxX:uint = 20;
		/** Y轴震动的最大频率 **/
		public var shockMaxY:uint = 20;
		/** 显示区域额外处理像素 **/
		private var displayAdd:int = 30;
		/** Map里的图层显示对象(对象不一定已经加载到场景上) **/
		public var lib:Vector.<DisplayLayer>;
		/** Map上的UpInfoLayer数据所对应的图层显示对象(对象不一定已经加载到场景上) **/
		internal var display_info:Dictionary;
		/** ED元件和显示对象在界面上的互相映射 **/
		internal var display_ed:Dictionary;
		/** 任务显示内容和界面上内容互相映射 **/
		internal var display_task:Dictionary;
		
		/** 空中部队伤害数字图层 **/
		public var layer_flyHarm:DisplayLayer;
		/** 空中部队头顶特效图层 **/
		public var layer_flyEffectTop:DisplayLayer;
		/** 空中部队 **/
		public var layer_fly:DisplayLayer;
		/** 空中部队脚下特效图层 **/
		public var layer_flyEffectEnd:DisplayLayer;
		/** 地面部队伤害数字图层 **/
		public var layer_groundHarm:DisplayLayer;
		/** 地面部队头顶特效,子弹图层 **/
		public var layer_groundEffectTop:DisplayLayer;
		/** 地面部队 **/
		public var layer_ground:DisplayLayer;
		/** 地面部队的有立体感的特效层级 **/
		public var layer_groundEffect3D:DisplayLayer;
		/** 地面部队掉落装饰物 **/
		public var layer_ground3DItem:DisplayLayer;
		/** 地面部队脚下特效 **/
		public var layer_groundEffectEnd:DisplayLayer;
		/** 地板特效图层,地板燃烧 **/
		public var layer_floorEffect:DisplayLayer;
		/** 是否绘制出AStar的区域来 **/
		public var debugAStart:FShape;
		
		/** 创建DisplayMap请使用EngineMap内方法 **/
		public function DisplayMap(upGame:UpGame):void
		{
			this.upGame = upGame;
			lib = new Vector.<DisplayLayer>();
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		override public function get x():Number { return _x; }
		override public function get y():Number { return _y; }
		override public function set y(value:Number):void { if (this._x != value) { this._x = value; pointCount(); }}
		override public function set x(value:Number):void { if (this._y != value) { this._y = value; pointCount(); }}
		override public function get width():Number { return _width; }
		override public function set width(value:Number):void { _width = value; }
		override public function get height():Number { return _height; }
		override public function set height(value:Number):void { _height = value; }
		public function get mapX():Number { return _mapX; }
		public function get mapY():Number { return _mapY; }
		
		/** 地图现在在游戏中的显示位置 **/
		public function moveMap(mapX:Number, mapY:Number):void
		{
			if (this._mapX != mapX || this._mapY != mapY)
			{
				this._mapX = mapX;
				this._mapY = mapY;
				//把内容全都显示出来先
				for each (var item:DisplayLayer in lib) 
				{
					item.moveMap(mapX, mapY);
				}
			}
		}
		
		/** 使用数据找到显示对象 **/
		public function infoToLayerDisplay(info:UpInfoLayer):DisplayLayer
		{
			if (display_info) return display_info[info];
			return null;
		}
		
		/** 通过ED数据来返回显示对象 **/
		public function edToDisplay(ed:EDBase):*
		{
			if (display_ed) return display_ed[ed];
			return null;
		}
		
		/** 通过ED数据来返回显示对象,并销毁掉 **/
		public function edToDispose(ed:EDBase):void
		{
			if (display_ed)
			{
				var d:Object = display_ed[ed];
				if (d)
				{
					d.dispose();
				}
				delete display_ed[ed];
			}
		}
		
		/** 通过ED数据来返回显示对象 **/
		public function taskToDisplay(task:TaskItemBase):*
		{
			if (display_task) return display_task[task];
			return null;
		}
		
		/** 通过ED数据来返回显示对象,并销毁掉 **/
		public function taskToDispose(task:TaskItemBase):void
		{
			if (display_task)
			{
				var d:Object = display_task[task];
				if (d)
				{
					d.dispose();
				}
				delete display_task[task];
			}
		}
		
		/** 计算并设置现在的坐标 **/
		private function pointCount():void
		{
			var x1:int = int(_x + _shockX);
			var y1:int = int(_y + _shockY);
			if (super.x != x1) super.x = x1;
			if (super.y != y1) super.y = y1;
		}
		
		public function get shockX():Number { return _shockX; }
		public function set shockX(value:Number):void 
		{
			if (_shockX != value)
			{
				_shockX = value;
				pointCount();
			}
		}
		public function get shockY():Number { return _shockY; }
		public function set shockY(value:Number):void 
		{
			if (_shockY != value)
			{
				_shockY = value;
				pointCount();
			}
		}
		
		/** 发生偏移坐标,这里主要给震动使用 **/
		public function shock(x:Number = 1, y:Number = 1):void
		{
			if (_shockX != x || _shockY != y)
			{
				_shockX = x;
				_shockY = y;
				pointCount();
			}
		}
		
		 /**
		  * 震动里面的图层
		  * @param	x	是一个比例值
		  * @param	y	是一个比例值
		  */
		public function shockChild(x:Number, y:Number):void
		{
			//把内容全都显示出来先
			for each (var item:DisplayLayer in lib) 
			{
				item.shock(x, y);
			}
		}
		
		public function dispose():void 
		{
			clearEDDisplay();
			if (display_ed)
			{
				display_ed = null;
			}
			clearTaskDisplay();
			if (display_task)
			{
				display_task = null;
			}
			for each (var item:DisplayLayer in lib) 
			{
				item.dispose();
			}
			lib.length = 0;
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
			display_info = null;
			EngineLayer.clearMapLayerLink(this);
			if (debugAStart)
			{
				debugAStart.dispose();
				debugAStart = null;
			}
		}
		
		/** 清理ed_display里的全部显示对象 **/
		public function clearEDDisplay():void
		{
			if (display_ed)
			{
				var d:Object;
				var a:Array = g.speedFact.n_array();
				for (var ed:Object in display_ed) 
				{
					a.push(ed);
				}
				for each (ed in a) 
				{
					d = display_ed[ed];
					d.dispose();
					delete display_ed[ed];
				}
				g.speedFact.d_array(a);
			}
		}
		
		/** 清理ed_display里的全部显示对象 **/
		public function clearTaskDisplay():void
		{
			if (display_task)
			{
				var d:Object;
				var a:Array = g.speedFact.n_array();
				for (var task:Object in display_task) 
				{
					a.push(task);
				}
				for each (task in a) 
				{
					d = display_task[task];
					d.dispose();
					delete display_task[task];
				}
				g.speedFact.d_array(a);
			}
		}
		
		/** 显示出非移动区域 **/
		public function addDebug():void
		{
			if (upGame.isDebug)
			{
				if (debugAStart == null)
				{
					debugAStart = FShape.instance();
					this.addChild(debugAStart);
				}
				debugAStart.graphics.clear();
				debugAStart.graphics.lineStyle(1, 0x000000, 0.8);
				debugAStart.graphics.beginFill(0x000000, 0.3);
				for each (var r:Rectangle in upGame.engine.astar.moveOther) 
				{
					if (upGame.modeTurn)
					{
						debugAStart.graphics.drawRect(-r.x - r.width, -r.y - r.height, r.width, r.height);
					}
					else
					{
						debugAStart.graphics.drawRect(r.x, r.y, r.width, r.height);
					}
				}
				for each (r in upGame.engine.astar.moveAll) 
				{
					if (upGame.modeTurn)
					{
						debugAStart.graphics.drawRect(-r.x - r.width, -r.y - r.height, r.width, r.height);
					}
					else
					{
						debugAStart.graphics.drawRect(r.x, r.y, r.width, r.height);
					}
				}
				debugAStart.graphics.endFill();
			}
			else if (debugAStart)
			{
				debugAStart.dispose();
				debugAStart = null;
			}
		}
		
		public function removeDebug():void
		{
			if (debugAStart)
			{
				debugAStart.dispose();
				debugAStart = null;
			}
		}
	}
}