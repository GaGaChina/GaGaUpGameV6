package cn.wjj.upgame.render 
{
	import cn.wjj.upgame.common.UpInfoLayerType;
	import cn.wjj.upgame.info.UpInfoLayer;
	import cn.wjj.upgame.info.UpInfoMap;
	import cn.wjj.upgame.UpGame;
	import flash.utils.Dictionary;
	
	/**
	 * 绘制背景
	 * @author GaGa
	 */
	public class EngineLayer 
	{
		public function EngineLayer() { }
		
		/** 添加图层的显示对象 **/
		public static function createLayer(u:UpGame, selfEngine:Boolean = false, removeNull:Boolean = false):void
		{
			clearAllLayer(u.reader.map);
			var lib:Vector.<UpInfoLayer> = u.info.map.layer.lib;
			var layer:DisplayLayer;
			for each (var item:UpInfoLayer in lib) 
			{
				layer = pushLayer(u, item);
				switch (item.layerType) 
				{
					case UpInfoLayerType.flyHarm:
						u.reader.map.layer_flyHarm = layer;
						break;
					case UpInfoLayerType.flyEffectTop:
						u.reader.map.layer_flyEffectTop = layer;
						break;
					case UpInfoLayerType.fly:
						u.reader.map.layer_fly = layer;
						break;
					case UpInfoLayerType.flyEffectEnd:
						u.reader.map.layer_flyEffectEnd = layer;
						break;
					case UpInfoLayerType.groundHarm:
						u.reader.map.layer_groundHarm = layer;
						break;
					case UpInfoLayerType.groundEffectTop:
						u.reader.map.layer_groundEffectTop = layer;
						break;
					case UpInfoLayerType.ground:
						u.reader.map.layer_ground = layer;
						break;
					case UpInfoLayerType.groundEffect3D:
						u.reader.map.layer_groundEffect3D = layer;
						break;
					case UpInfoLayerType.ground3DItem:
						u.reader.map.layer_ground3DItem = layer;
						break;
					case UpInfoLayerType.groundEffectEnd:
						u.reader.map.layer_groundEffectEnd = layer;
						break;
					case UpInfoLayerType.floorEffect:
						u.reader.map.layer_floorEffect = layer;
						break;
				}
				EngineDisplay.createDisplay(u, layer, selfEngine, removeNull);
			}
		}
		
		/** 清理图层全部内容 **/
		public static function clearAllLayer(map:DisplayMap):void
		{
			clearMapLayerLink(map);
			for each (var item:DisplayLayer in map.lib) 
			{
				item.dispose();
			}
			map.lib.length = 0;
			var i:int = map.numChildren;
			var d:*;
			while (--i > -1)
			{
				d = map.removeChildAt(i);
			}
			map.display_info = new Dictionary(true);
			map.display_ed = new Dictionary(true);
			map.display_task = new Dictionary(true);
		}
		
		/** 查看是否已经包含了这个图层 **/
		public static function getTypeInfoLayer(map:UpInfoMap, type:uint):Vector.<UpInfoLayer>
		{
			var out:Vector.<UpInfoLayer> = new Vector.<UpInfoLayer>();
			var lib:Vector.<UpInfoLayer> = map.layer.lib;
			for each (var item:UpInfoLayer in lib) 
			{
				if (item.layerType == type)
				{
					out.push(item);
				}
			}
			return out;
		}
		
		/** 把各个图层的引用全干掉 **/
		public static function clearMapLayerLink(map:DisplayMap):void
		{
			map.layer_flyHarm = null;
			map.layer_flyEffectTop = null;
			map.layer_fly = null;
			map.layer_flyEffectEnd = null;
			map.layer_groundHarm = null;
			map.layer_groundEffectTop = null;
			map.layer_ground = null;
			map.layer_groundEffect3D = null;
			map.layer_ground3DItem = null;
			map.layer_groundEffectEnd = null;
			map.layer_floorEffect = null;
		}
		
		/** 添加一个图层信息 **/
		public static function pushLayer(u:UpGame, item:UpInfoLayer):DisplayLayer
		{
			var layer:DisplayLayer = new DisplayLayer(u);
			layer.info = item;
			layer.info_display = new Dictionary(true);
			layer.display_info = new Dictionary(true);
			layer.inMap = true;
			u.reader.map.addChild(layer);
			u.reader.map.lib.push(layer);
			u.reader.map.display_info[item] = layer;
			return layer;
		}
	}
}