package cn.wjj.upgame.render 
{
	import cn.wjj.gagaframe.client.factory.FShape;
	import cn.wjj.upgame.common.UpInfoLayerType;
	import cn.wjj.upgame.engine.UpGameAStar;
	import cn.wjj.upgame.info.UpInfoLayer;
	import flash.display.Graphics;
	
	import cn.wjj.upgame.UpGame;
	import cn.wjj.upgame.info.UpInfo;
	
	/**
	 * 生成地图
	 * 
	 * @author GaGa
	 */
	public class EngineMap 
	{
		
		public function EngineMap() { }
		
		/**
		 * 将upGame数据带入一个新的Map数据中,创建地图
		 * @param	upGame
		 * @param	selfEngine		元件是否自己驱动自己
		 * @param	removeNull		是否自动删除空的显示对象
		 * @return
		 */
		public static function create(u:UpGame, selfEngine:Boolean = false, removeNull:Boolean = false):DisplayMap
		{
			if (u.reader.map == null) u.reader.map = new DisplayMap(u);
			u.reader.map.info = u.info;
			backGround(u);
			EngineLayer.createLayer(u, selfEngine, removeNull);
			return u.reader.map;
		}
		
		/** 找到map对象中对应类型的图层 **/
		public static function getTypeLayer(map:DisplayMap, type:uint):DisplayLayer
		{
			switch (type) 
			{
				case UpInfoLayerType.flyHarm:
					return map.layer_flyHarm;
				case UpInfoLayerType.flyEffectTop:
					return map.layer_flyEffectTop;
				case UpInfoLayerType.fly:
					return map.layer_fly;
				case UpInfoLayerType.flyEffectEnd:
					return map.layer_flyEffectEnd;
				case UpInfoLayerType.groundHarm:
					return map.layer_groundHarm;
				case UpInfoLayerType.groundEffectTop:
					return map.layer_groundEffectTop;
				case UpInfoLayerType.ground:
					return map.layer_ground;
				case UpInfoLayerType.groundEffect3D:
					return map.layer_groundEffect3D;
				case UpInfoLayerType.ground3DItem:
					return map.layer_ground3DItem;
				case UpInfoLayerType.groundEffectEnd:
					return map.layer_groundEffectEnd;
				case UpInfoLayerType.floorEffect:
					return map.layer_floorEffect;
			}
			return null;
		}
		
		/** 找到map对象中对应类型的图层 **/
		public static function getNameLayer(map:DisplayMap, name:String):DisplayLayer
		{
			switch (name) 
			{
				case "flyHarm":
					return map.layer_flyHarm;
				case "flyEffectTop":
					return map.layer_flyEffectTop;
				case "fly":
					return map.layer_fly;
				case "flyEffectEnd":
					return map.layer_flyEffectEnd;
				case "groundHarm":
					return map.layer_groundHarm;
				case "groundEffectTop":
					return map.layer_groundEffectTop;
				case "ground":
					return map.layer_ground;
				case "groundEffect3D":
					return map.layer_groundEffect3D;
				case "ground3DItem":
					return map.layer_ground3DItem;
				case "groundEffectEnd":
					return map.layer_groundEffectEnd;
				case "floorEffect":
					return map.layer_floorEffect;
			}
			return null;
		}
		
		/** 从一个Map地图中,获取信息为upInfoLayer对应的图层显示对象 **/
		public static function upInfoLayerToDisplayLayer(map:DisplayMap, info:UpInfoLayer):DisplayLayer
		{
			if (map.display_info) return map.display_info[info];
			return null;
		}
		
		/**
		 * 绘制背景
		 * @param	upGame		如果是编辑模式不会绘制背景
		 * @param	info
		 * @param	map
		 */
		private static function backGround(upGame:UpGame):void
		{
			var info:UpInfo = upGame.info;
			var map:DisplayMap = upGame.reader.map;
			var graphics:Graphics = map.graphics;
			graphics.clear();
			if (info.stageInfo.width < 0)
			{
				map.width = -info.stageInfo.width;
			}
			else
			{
				map.width = info.stageInfo.width;
			}
			if (info.stageInfo.height < 0)
			{
				map.height = -info.stageInfo.height;
			}
			else
			{
				map.height = info.stageInfo.height;
			}
			if (upGame.isEdit)
			{
				graphics.lineStyle(0, 0, 0);
				graphics.beginFill(0x99CC00);
				graphics.drawRect(info.stageInfo.x, info.stageInfo.y, map.width, map.height);
				
				/** 画网格 **/
				var w:Number, h:Number, x:int, y:int;
				var gridWidth:uint = 100;
				var gridHeight:uint = 100;
				graphics.lineStyle(1, 0x000000, 0.15);
				graphics.beginFill(0, 0);
				//画竖线
				w = info.stageInfo.x + map.width;
				x = info.stageInfo.x - (info.stageInfo.x % gridWidth);
				while (x <= w) 
				{
					graphics.moveTo(x, info.stageInfo.y);
					graphics.lineTo(x, info.stageInfo.y + map.height);
					x += gridWidth;
				}
				//画横线
				y = info.stageInfo.y - (info.stageInfo.y % gridHeight);
				h = info.stageInfo.y + map.height;
				while (y <= h)
				{
					graphics.moveTo(info.stageInfo.x, y);
					graphics.lineTo(info.stageInfo.x + map.width, y);
					y += gridHeight;
				}
				
				/**
				 * 添加标尺
				 * 画个白圈圈里面一个灰圈,2条线, 加2条线
				 * 在辅助线上画100像素每个的节点 , 5像素高
				 */
				gridWidth = 100;
				x = info.stageInfo.x - (info.stageInfo.x % gridWidth);
				if (info.stageInfo.x < x) x -= gridWidth;
				w = info.stageInfo.x + map.width + (info.stageInfo.x - x);
				if (w % gridWidth != 0) w = w - (w % gridWidth) + gridWidth;
				
				//画白色背景线
				graphics.lineStyle(3, 0xFFFFFF, 0.3);
				graphics.moveTo(x, 0);
				graphics.lineTo(w, 0);
				//画黑色辅助线
				graphics.lineStyle(1, 0x000000, 0.5);
				graphics.moveTo(x, 0);
				graphics.lineTo(w, 0);
				while (x <= w) 
				{
					//画竖线
					graphics.lineStyle(3, 0xFFFFFF, 0.3);
					graphics.moveTo(x, -5);
					graphics.lineTo(x, 5);
					graphics.lineStyle(1, 0x000000, 0.7);
					graphics.moveTo(x, -5);
					graphics.lineTo(x, 5);
					x += gridWidth;
				}
				gridHeight = 100;
				y = info.stageInfo.y - (info.stageInfo.y % gridHeight);
				if (info.stageInfo.y < y) y -= gridHeight;
				h = info.stageInfo.y + map.height + (info.stageInfo.y - y);
				if (h % gridHeight != 0) h = h - (h % gridHeight) + gridHeight;
				//画白色背景线
				graphics.lineStyle(3, 0xFFFFFF, 0.3);
				graphics.moveTo(0, y);
				graphics.lineTo(0, h);
				//画黑色辅助线
				graphics.lineStyle(1, 0x000000, 0.5);
				graphics.moveTo(0, y);
				graphics.lineTo(0, h);
				while (y <= h)
				{
					graphics.lineStyle(3, 0xFFFFFF, 0.3);
					graphics.moveTo(-5, y);
					graphics.lineTo(5, y);
					graphics.lineStyle(1, 0x000000, 0.7);
					graphics.moveTo(-5, y);
					graphics.lineTo(5, y);
					y += gridHeight;
				}
				
				//画个白圆
				graphics.lineStyle(0, 0, 0);
				graphics.beginFill(0xFFFFFF, 1);
				graphics.drawCircle(0, 0, 4);
				graphics.beginFill(0x999999, 1);
				graphics.drawCircle(0, 0, 2);
				
				graphics.endFill();
			}
		}
		
		/**
		 * 绘制背景
		 * @param	u		如果是编辑模式不会绘制背景
		 */
		public static function drawAStarBg(u:UpGame):void
		{
			var astar:UpGameAStar = u.engine.astar;
			var map:DisplayMap = u.reader.map;
			if (map.debugAStart == null) map.debugAStart = FShape.instance();
			var graphics:Graphics = map.debugAStart.graphics;
			graphics.clear();
			graphics.beginFill(0xFF0000, 0.2);
			var x:int;
			var sx:int;
			var ex:int;
			var draw:Boolean = false;
			var dx:int, dy:int, dw:int, dh:int;
			for (var y:int = 0; y < astar.height; y++) 
			{
				sx = -1;
				ex = -1;
				draw = false;
				for (x = 0; x < astar.width; x++) 
				{
					if (astar.map[x][y] == 1)
					{
						if (sx == -1)
						{
							sx = x;
						}
						else
						{
							ex = x;
						}
					}
					else if (sx != -1)
					{
						ex = x - 1;
						draw = true;
					}
					if (sx != -1 && x == (astar.width - 1))
					{
						ex = x - 1;
						draw = true;
					}
					if (sx != -1 && ex != -1 && draw)
					{
						dx = sx * astar.tileWidth + astar.offsetX;
						dw = (ex + 1) * astar.tileWidth + astar.offsetX - dx;
						dy = y * astar.tileHeight + astar.offsetY;
						dh = astar.tileHeight;
						graphics.drawRect(dx, dy, dw, dh);
						sx = -1;
						ex = -1;
					}
				}
			}
			graphics.endFill();
			map.addChild(map.debugAStart);
		}
	}
}