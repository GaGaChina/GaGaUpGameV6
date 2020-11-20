package cn.wjj.upgame.tools 
{
	import cn.wjj.upgame.info.UpInfo;
	import cn.wjj.upgame.info.UpInfoDisplay;
	import cn.wjj.upgame.info.UpInfoLayer;
	
	/**
	 * 获取一个U2InfoBaseInfo里所包含的路径
	 * 
	 * @author GaGa
	 */
	public class GetInfoPath 
	{
		
		public function GetInfoPath() {}
		
		/** 从一个 UpInfo 数据中获取一个路径 **/
		public static function getOnePath(info:UpInfo):String
		{
			var lib:Vector.<UpInfoLayer> = info.map.layer.lib;
			var displayLib:Vector.<UpInfoDisplay>;
			var display:UpInfoDisplay;
			for each (var layer:UpInfoLayer in lib) 
			{
				displayLib = layer.lib;
				for each (display in displayLib) 
				{
					if (display.path)
					{
						return display.path;
					}
				}
			}
			return "";
		}
		
		/** 从一个 UpInfo 数据中获取全部的路径 **/
		public static function getPathList(info:UpInfo):Vector.<String>
		{
			var list:Vector.<String> = new Vector.<String>();
			var lib:Vector.<UpInfoLayer> = info.map.layer.lib;
			var displayLib:Vector.<UpInfoDisplay>;
			var display:UpInfoDisplay;
			for each (var layer:UpInfoLayer in lib) 
			{
				displayLib = layer.lib;
				for each (display in displayLib) 
				{
					if (display.path)
					{
						if (list.indexOf(display.path) == -1)
						{
							list.push(display.path);
						}
					}
				}
			}
			return list;
		}
	}

}