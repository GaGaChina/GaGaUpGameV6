package cn.wjj.upgame.info 
{
	/**
	 * ...
	 * @author GaGa
	 */
	public class InfoEngineMap 
	{
		public function InfoEngineMap() {}
		
		/** 计算最大的震动程度 **/
		public static function countMaxShock(info:UpInfo):void
		{
			var sx:uint = 0;
			var sy:uint = 0;
			var lib:Vector.<UpInfoLayer> = info.map.layer.lib;
			for each (var layer:UpInfoLayer in lib) 
			{
				if (sx < layer.shockX) sx = layer.shockX;
				if (sy < layer.shockY) sy = layer.shockY;
			}
			info.map.shockMaxX = info.map.shockX + sx;
			info.map.shockMaxY = info.map.shockX + sx;
		}
	}
}