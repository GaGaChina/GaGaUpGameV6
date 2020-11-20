package cn.wjj.upgame.render 
{
	import cn.wjj.upgame.common.ShockEffectType;
	import cn.wjj.upgame.common.ShockType;
	import cn.wjj.upgame.engine.UpEngineTime;
	
	/**
	 * 地图震动控制器
	 * @author GaGa
	 */
	public class ManageShock 
	{
		/** 显示层引用 **/
		public var reader:UpReader;
		
		public var time:UpEngineTime;
		
		/** 震动的数据 **/
		private var list:Array;
		private var length:int = 0;
		
		/** 是否有地图震动 **/
		private var mapShock:Boolean = false;
		private var mapX:Number = 0;
		private var mapY:Number = 0;
		/** 是否有地图图层震动 **/
		private var layerShock:Boolean = false;
		private var layerX:Number = 0;
		private var layerY:Number = 0;
		
		public function ManageShock(reader:UpReader) 
		{
			this.reader = reader;
			this.time = reader.u.engine.time;
			list = new Array();
		}
		
		/**
		 * 添加特定震动类型
		 * @param	type		类型形震动
		 * @param	delay		延迟时间
		 * @param	timeLength	震动时间
		 */
		public function pushType(type:int = 1, delay:uint = 0, timeLength:uint = 41):void
		{
			switch (type) 
			{
				case ShockEffectType.small:
					push(ShockType.mapAddChild, 0.5, 0.5, delay, timeLength);
					break;
				case ShockEffectType.medium:
					push(ShockType.mapAddChild, 0.8, 0.8, delay, timeLength);
					break;
				case ShockEffectType.big:
					push(ShockType.mapAddChild, 1, 1, delay, timeLength);
					break;
				default:
					push(ShockType.mapAddChild, 1, 1, delay, timeLength);
			}
		}
		
		/**
		 * 添加一个震动的效果
		 * @param	type		震动类型, map整张地图震动, child地图内图层分别震动(ShockType)
		 * @param	x			震动的比例
		 * @param	y			震动的比例
		 * @param	delay		延迟时间
		 * @param	timeLength	震动时间
		 */
		public function push(type:uint = 1, x:Number = 1, y:Number = 1, delay:uint = 0, timeLength:uint = 41):void
		{
			list.push(type);
			if(x > 1) x = 1;
			if(y > 1) y = 1;
			list.push(x);
			list.push(y);
			list.push(time.timeEngine + delay);
			list.push(time.timeEngine + delay + timeLength);
			length += 5;
		}
		
		/** 开始震动 **/
		internal function runShock():void
		{
			if (length)
			{
				mapShock = false;
				layerShock = false;
				mapX = 0;
				mapY = 0;
				layerX = 0;
				layerY = 0;
				var i:int = length - 5;
				var engineTime:uint = time.timeEngine;
				while (i > -1)
				{
					if (list[i + 4] < engineTime)
					{
						//删除
						list.splice(i, 5);
						length -= 5;
					}
					else if (list[i + 3] < engineTime)
					{
						//播放
						switch (list[i]) 
						{
							case ShockType.map:
								setShockMap(i);
								break;
							case ShockType.child:
								setShockChild(i);
								break;
							case ShockType.mapAddChild:
								setShockMap(i);
								setShockChild(i);
								break;
						}
					}
					i -= 5;
				}
				doShock();
			}
		}
		
		/** 清空全部的震动 **/
		public function clear():void
		{
			list.length = 0;
			length = 0;
			if (mapShock)
			{
				mapShock = false;
				if (mapX != 0) mapX = 0;
				if (mapY != 0) mapY = 0;
			}
			if (layerShock)
			{
				layerShock = false;
				if (layerX != 0) layerX = 0;
				if (layerY != 0) layerY = 0;
			}
			runShock();
		}
		
		/** 设置地图数据 **/
		private function setShockMap(i:int):void
		{
			var x:Number = list[i + 1];
			var y:Number = list[i + 2];
			if (x > 0 && y > 0)
			{
				mapShock = true;
				if (mapX < x) mapX = x;
				if (mapY < y) mapY = y;
			}
		}
		
		/** 设置地图数据 **/
		private function setShockChild(i:int):void
		{
			var x:Number = list[i + 1];
			var y:Number = list[i + 2];
			if (x > 0 && y > 0)
			{
				layerShock = true;
				if (layerX < x) layerX = x;
				if (layerY < y) layerY = y;
			}
		}
		
		private function doShock():void
		{
			if (reader.map)
			{
				var x:int;
				var y:int;
				var sx:Number;
				var sy:Number;
				if (mapShock)
				{
					x = int(reader.map.shockMaxX * (0.5 - Math.random()) * mapX);
					y = int(reader.map.shockMaxY * (0.5 - Math.random()) * mapY);
					reader.map.shock(x, y);
					mapShock = false;
					mapX = 0;
					mapY = 0;
				}
				else
				{
					reader.map.shock(0, 0);
				}
				if (layerShock)
				{
					sx = (0.5 - Math.random()) * layerX;
					sy = (0.5 - Math.random()) * layerY;
					reader.map.shockChild(sx, sy);
					layerShock = false;
					layerX = 0;
					layerY = 0;
				}
				else
				{
					reader.map.shockChild(0, 0);
				}
			}
		}
		
		/** 摧毁对象 **/
		public function dispose():void 
		{
			reader = null;
			time = null;
			if (list)
			{
				list.length = 0;
				list = null;
			}
		}
	}
}