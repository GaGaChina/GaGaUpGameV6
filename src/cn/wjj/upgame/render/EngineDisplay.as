package cn.wjj.upgame.render 
{
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.upgame.info.UpInfo;
	import cn.wjj.upgame.info.UpInfoDisplay;
	import cn.wjj.upgame.UpGame;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * 
	 * @author GaGa
	 */
	public class EngineDisplay 
	{
		
		public function EngineDisplay() { }
		
		/**
		 * 添加图层的显示对象
		 * @param	upGame
		 * @param	layer			要操作的图层内容
		 * @param	selfEngine		元件是否自己驱动自己
		 * @param	removeNull		是否自动删除空的显示对象
		 */
		public static function createDisplay(u:UpGame, layer:DisplayLayer, selfEngine:Boolean = false, removeNull:Boolean = false):void
		{
			var lib:Vector.<UpInfoDisplay> = layer.info.lib;
			var l:int = lib.length;
			if (l)
			{
				var display:DisplayItem;
				var item:UpInfoDisplay;
				if (removeNull)
				{
					var removeList:Vector.<int> = new Vector.<int>();
					for (var i:int = 0; i < l; i++) 
					{
						item = lib[i];
						display = EngineDisplay.pushDisplay(u, layer, item, selfEngine);
						if (display == null)
						{
							removeList.push(i);
						}
					}
					//自动删除不需要的显示对象
					l = removeList.length;
					if (l)
					{
						g.log.pushLog(EngineDisplay, LogType._UserAction, "Map层 " + layer.name + " 删除空元件:" + l);
						while (--l > -1)
						{
							i = removeList[l];
							layer.info.lib.splice(i, 1);
						}
					}
				}
				else
				{
					for each (item in lib) 
					{
						display = EngineDisplay.pushDisplay(u, layer, item, selfEngine);
					}
				}
			}
		}
		
		/** 添加图层的显示对象 **/
		public static function editDisplay(u:UpGame, layer:DisplayLayer, info:UpInfo):void
		{
			var lib:Vector.<UpInfoDisplay> = layer.info.lib;
			var index:int = 0;
			var layerInfoIndex:int = 0;
			var delIndex:int = 0;
			var length:uint = layer.numChildren;
			var displayDelList:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			for (var i:int = 0; i < length; i++) 
			{
				displayDelList.push(layer.getChildAt(i));
			}
			var display:DisplayItem;
			layer.info_display = new Dictionary(true);
			for each (var item:UpInfoDisplay in lib) 
			{
				layerInfoIndex = getInfoIndex(layer.lib, item);
				if (layerInfoIndex == -1)
				{
					display = new DisplayItem();
					display.upGame = u;
					display.info = item;
					display.layer = layer;
					display.display.x = item.x;
					display.display.y = item.y;
					layer.lib.splice(index, 0, display);
					layer.info_display[item] = display;
					delIndex = displayDelList.indexOf(display._display);
					if (delIndex != -1)
					{
						displayDelList.splice(delIndex, 1);
					}
				}
				else if(layerInfoIndex != index)
				{
					display = layer.lib[layerInfoIndex];
					layer.lib.splice(layerInfoIndex, 1);
					layer.lib.splice(index, 0, display);
					layer.info_display[item] = display;
					delIndex = displayDelList.indexOf(display._display);
					if (delIndex != -1)
					{
						displayDelList.splice(delIndex, 1);
					}
				}
				else
				{
					display = layer.lib[index];
					layer.info_display[item] = display;
					delIndex = displayDelList.indexOf(display._display);
					if (delIndex != -1)
					{
						displayDelList.splice(delIndex, 1);
					}
				}
				index++;
			}
			//把剩余的都干掉
			if (layer.lib.length > index)
			{
				display = layer.lib.pop();
				display.dispose();
			}
			//把没有用到的显示对象干掉
			for each (var del:DisplayObject in displayDelList) 
			{
				(item as Object).dispose();
			}
			displayDelList.length = 0;
			//重新按顺序添加
			for each (display in layer.lib) 
			{
				display.addInLayer();
			}
		}
		
		/** 获取这个列表中信息的索引位 **/
		private static function getInfoIndex(lib:Vector.<DisplayItem>, info:UpInfoDisplay):int
		{
			var length:uint = lib.length;
			var item:DisplayItem;
			for (var i:int = 0; i < length; i++) 
			{
				item = lib[i];
				(item.info == info)
				{
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * 根据数据来删除一个显示对象,并在数据中也删除这个信息
		 * @param	upGame
		 * @param	layer
		 * @param	item
		 * @return	是否删除成功
		 */
		public static function removeDisplay(layer:DisplayLayer, item:UpInfoDisplay):Boolean
		{
			var display:DisplayItem = DisplayLayer.infoToItem(layer, item);
			if (display)
			{
				var d:DisplayObject = display._display;
				if (d)
				{
					if (d.parent) d.parent.removeChild(d);
					(d as Object).dispose();
					d = null;
				}
				layer.info_display[item] = null;
				delete layer.info_display[item];
				//还需要层级的索引
				var index:int = layer.lib.indexOf(display);
				if (index != -1)
				{
					layer.lib.splice(index, 1);
				}
				layer.info.removeDisplay(item);
				return true;
			}
			return false;
		}
		
		/**
		 * 将显示对象添加进去
		 * @param	upGame
		 * @param	layer
		 * @param	item
		 * @return
		 */
		public static function pushDisplay(u:UpGame, layer:DisplayLayer, item:UpInfoDisplay, selfEngine:Boolean = false):DisplayItem
		{
			var display:DisplayItem = new DisplayItem();
			display.upGame = u;
			display.info = item;
			display.layer = layer;
			display.selfEngine = selfEngine;
			if(item.path)
			{
				/*
				if (display.display)
				{
					display._display.x = item.x;
					display._display.y = item.y;
					display._display.alpha = item.alpha;
					display._display.rotation = item.rotation;
					display._display.scaleX = item.scaleX;
					display._display.scaleY = item.scaleY;
					display.addInLayer();
				}
				*/
				layer.lib.push(display);
				layer.libLength++;
				layer.info_display[item] = display;
				return display;
			}
			else
			{
				removeDisplay(layer, item);
				g.log.pushLog(EngineDisplay, LogType._ErrorLog, "地图模块缺少资源(直接删除) : " + item.path);
			}
			return null;
		}
	}
}