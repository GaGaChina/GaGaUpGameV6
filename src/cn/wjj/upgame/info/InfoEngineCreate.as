package cn.wjj.upgame.info 
{
	import cn.wjj.upgame.common.UpInfoLayerType;
	
	/**
	 * ...
	 * @author GaGa
	 */
	public class InfoEngineCreate 
	{
		
		public function InfoEngineCreate() { }
		
		/** 为一个空的游戏对象添加一些空的图层 **/
		public static function addNewLayer(o:UpInfo):void
		{
			var layer:UpInfoLayer = new UpInfoLayer();
			layer.name = "地板下装饰";
			o.map.layer.addLayer(layer);
			
			layer = new UpInfoLayer();
			layer.name = "地板";
			o.map.layer.addLayer(layer);
			
			layer = new UpInfoLayer();
			layer.name = "地板贴地装饰物";
			layer.shockToName = "地板";
			layer.layerType = UpInfoLayerType.floorEffect;
			o.map.layer.addLayer(layer);
			
			layer = new UpInfoLayer();
			layer.name = "地面人物脚底特效";
			layer.shockToName = "地板";
			layer.layerType = UpInfoLayerType.groundEffectEnd;
			o.map.layer.addLayer(layer);
			
			layer = new UpInfoLayer();
			layer.name = "地板立体装饰物";
			layer.shockToName = "地板";
			layer.layerType = UpInfoLayerType.ground3DItem;
			layer.useIndex = 1;
			o.map.layer.addLayer(layer);
			
			layer = new UpInfoLayer();
			layer.name = "地面人物脚底立体特效";
			layer.shockToName = "地板";
			layer.layerType = UpInfoLayerType.groundEffect3D;
			o.map.layer.addLayer(layer);
			
			layer = new UpInfoLayer();
			layer.name = "地面";
			layer.shockToName = "地板";
			layer.layerType = UpInfoLayerType.ground;
			layer.useIndex = 1;
			o.map.layer.addLayer(layer);
			
			layer = new UpInfoLayer();
			layer.name = "地面头顶特效";
			layer.shockToName = "地板";
			layer.layerType = UpInfoLayerType.groundEffectTop;
			o.map.layer.addLayer(layer);
			
			layer = new UpInfoLayer();
			layer.name = "地面伤害展示";
			layer.shockToName = "地板";
			layer.layerType = UpInfoLayerType.groundHarm;
			o.map.layer.addLayer(layer);
			
			layer = new UpInfoLayer();
			layer.name = "天空";
			o.map.layer.addLayer(layer);
			
			layer = new UpInfoLayer();
			layer.name = "空中部队底部特效";
			layer.shockToName = "天空";
			layer.layerType = UpInfoLayerType.flyEffectEnd;
			o.map.layer.addLayer(layer);
			
			layer = new UpInfoLayer();
			layer.name = "空中部队";
			layer.shockToName = "天空";
			layer.layerType = UpInfoLayerType.fly;
			o.map.layer.addLayer(layer);
			
			layer = new UpInfoLayer();
			layer.name = "空中部队上部特效";
			layer.shockToName = "天空";
			layer.layerType = UpInfoLayerType.flyEffectTop;
			o.map.layer.addLayer(layer);
			
			layer = new UpInfoLayer();
			layer.name = "空中部队伤害数字";
			layer.shockToName = "";
			layer.layerType = UpInfoLayerType.flyEffectTop;
			o.map.layer.addLayer(layer);
		}
	}

}