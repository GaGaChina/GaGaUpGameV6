package cn.wjj.upgame.render 
{
	import cn.wjj.display.ui2d.engine.EngineInfo;
	import cn.wjj.display.ui2d.info.U2InfoBaseInfo;
	import cn.wjj.display.ui2d.IU2Base;
	import cn.wjj.display.ui2d.U2Bitmap;
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.upgame.common.EDType;
	import cn.wjj.upgame.common.IRender;
	import cn.wjj.upgame.common.StatusEngineType;
	import cn.wjj.upgame.engine.EDBase;
	import cn.wjj.upgame.engine.EDRole;
	import cn.wjj.upgame.engine.EDRoleToolsSkin;
	import cn.wjj.upgame.UpGame;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	/**
	 * 图像驱动器
	 * 
	 * @author GaGa
	 */
	public class UpReader implements IRender 
	{
		/** 父引用 **/
		public var u:UpGame;
		/** U2里的GFile,可以是Array 数组,里面多个GFile,也可以是单个GFile **/
		public var gfile:*;
		/** 图片是否开启平滑 **/
		public var smoothing:Boolean = false;
		/** 显示对象的速度,一般启动发动机控制,就要和发动机的速度保持一直 **/
		public var speed:Number = 1;
		/** 整个地图的显示对象,创建的时候要自行创建 **/
		public var map:DisplayMap;
		/** 地图震动管理控制层 **/
		public var shake:ManageShock;
		/** 地图上的全部的内容 **/
		public var lib:Vector.<EDBase>;
		/** 播放一次就清理的对象 **/
		public var singleLib:Vector.<DisplayEDSingleEffect>;
		/**  Buff特效,要删除的一些特效 **/
		public var removeLib:Vector.<EDBase>;
		/** 是否开启场景校对 **/
		public var stageStart:Boolean = false;
		/** 场景正对0.0点显示区域,左边的区域延伸叠加值 **/
		public var stageX1:int = 0;
		/** 场景正对0.0点显示区域,右边的区域延伸叠加值 **/
		public var stageX2:int = 0;
		/** 场景正对0.0点显示区域,上边的区域延伸叠加值 **/
		public var stageY1:int = 0;
		/** 场景正对0.0点显示区域,下边的区域延伸叠加值 **/
		public var stageY2:int = 0;
		/** 场景校对区域扩展的距离 **/
		public static var stageAddDist:int = 20;
		/** 是否隐藏特效播放 **/
		public static var hideEffect:Boolean = false;
		/** 图形驱动器中的缓存 **/
		public var cache:Dictionary;
		/** 把多少时间前的卸载掉 **/
		public var cacheDelTime:uint = 4000;
		/** 大特效控制器 **/
		public var bigEffect:EngineSkillBigEffect;
		
		public function UpReader(u:UpGame) 
		{
			this.u = u;
			singleLib = new Vector.<DisplayEDSingleEffect>();
			removeLib = new Vector.<EDBase>();
			shake = new ManageShock(this);
			bigEffect = new EngineSkillBigEffect(u);
			cache = new Dictionary();
		}
		
		/**
		 * 场景正对0.0点显示区域
		 * @param	x1		场景正对0.0点显示区域,左边的区域延伸叠加值
		 * @param	x2		场景正对0.0点显示区域,右边的区域延伸叠加值
		 * @param	y1		场景正对0.0点显示区域,上边的区域延伸叠加值
		 * @param	y2		场景正对0.0点显示区域,下边的区域延伸叠加值
		 */
		public function setStageXY(x1:int, x2:int, y1:int, y2:int):void
		{
			stageStart = true;
			stageX1 = x1 - UpReader.stageAddDist;
			stageX2 = x2 + UpReader.stageAddDist;
			stageY1 = y1 - UpReader.stageAddDist;
			stageY2 = y2 + UpReader.stageAddDist;
			//把内容全都显示出来先
			for each (var item:DisplayLayer in map.lib) 
			{
				item.changeStageXY();
			}
		}
		
		/** 获取一个位图对象 **/
		public function bitmap(path:String, display:U2Bitmap = null):U2Bitmap
		{
			var c:Boolean = false;
			if (display == null)
			{
				c = true;
				display = U2Bitmap.instance();
			}
			if (gfile is Array)
			{
				var o:*;
				var a:Array = gfile as Array;
				for each (var item:* in a) 
				{
					if (g.gfile.getPath(item, path))
					{
						g.gfile.bitmapX(item, path, true, display);
						break;
					}
				}
			}
			else
			{
				g.gfile.bitmapX(gfile, path, true, display);
			}
			if (c && display.bitmapData == null)
			{
				display.dispose();
				display = null;
			}
			return display;
		}
		
		/** 获取一个U2的格式 **/
		public function u2(path:String, selfEngine:Boolean = false, start:int = -1):DisplayObject
		{
			var engine:int;
			if (selfEngine)
			{
				engine = -1;
				start = engine;
			}
			else
			{
				engine = u.engine.time.timeEngine;
				if (start == -1) start = engine;
			}
			var u2:*;
			if (gfile is Array)
			{
				var a:Array = gfile as Array;
				for each (var item:* in a) 
				{
					u2 = g.gfile.u2PathDisplay(item, path, selfEngine, engine, start, true, cache);
					if (u2)
					{
						if (smoothing)
						{
							u2.smoothing = true;
						}
						return u2 as DisplayObject;
					}
				}
			}
			else
			{
				u2 = g.gfile.u2PathDisplay(gfile, path, selfEngine, engine, start, true, cache);
				if (u2)
				{
					if (smoothing)
					{
						u2.smoothing = true;
					}
					return u2 as DisplayObject;
				}
			}
			g.log.pushLog(this, LogType._ErrorLog, "GFile Error : " + path);
			return null;
		}
		
		/** 使用信息创建一个U2对象 **/
		public function u2UseInfo(info:U2InfoBaseInfo, selfEngine:Boolean = false, start:int = -1):DisplayObject
		{
			var engine:int = -1;
			if (selfEngine)
			{
				start = -1;
			}
			else
			{
				engine = u.engine.time.timeEngine;
				if (start == -1)
				{
					start = engine;
				}
			}
			var u2:* = EngineInfo.create(info, selfEngine, engine, start, new Dictionary());
			if (u2)
			{
				if (smoothing)
				{
					u2.smoothing = true;
				}
				return u2 as DisplayObject;
			}
			return null;
		}
		
		/** 获取一个U2的格式 **/
		public function u2Info(path:String):U2InfoBaseInfo
		{
			var u2:*;
			if (gfile is Array)
			{
				var a:Array = gfile as Array;
				for each (var item:* in a) 
				{
					u2 = g.gfile.u2PathInfo(item, path, false);
					if (u2)
					{
						return u2 as U2InfoBaseInfo;
					}
				}
			}
			else
			{
				u2 = g.gfile.u2PathInfo(gfile, path, false);
				if (u2)
				{
					return u2 as U2InfoBaseInfo;
				}
			}
			g.log.pushLog(this, LogType._ErrorLog, "GFile Error : " + path);
			return null;
		}
		
		
		/** 驱动模块已经计算完毕,可以调用展示,展示出来 **/
		public function engineDisplay():void
		{
			EngineED.run(u);
			//遍历图层,将有内容的图层添加进map,没内容的图层移除
			var index:int = 0;
			for each (var item:DisplayLayer in map.lib) 
			{
				if (item.numChildren)
				{
					if (item.inMap == false)
					{
						item.inMap = true;
						map.addChildAt(item, index);
					}
					index++;
				}
				else if(item.inMap)
				{
					item.inMap = false;
					if (item.parent) item.parent.removeChild(item);
				}
			}
			if (cache)
			{
				var t:int = g.time.frameTime.time - cacheDelTime;
				for (var key:* in cache) 
				{
					if (cache[key] < t)
					{
						delete cache[key];
					}
				}
			}
			shake.runShock();
		}
		
		/**
		 * 播放完毕后自动摧毁的特效
		 * @param	startTime		开始时间
		 * @param	path			播放的U2路径
		 * @param	x				特效播放的坐标
		 * @param	y				特效播放的坐标
		 * @param	isU2Link		是否为U2Link对象(抽取层,并根据层名称播放)
		 * @param	layer			如果不为U2Link就使用这个图层来放置
		 * @param	scaleX
		 * @param	scaleY
		 * @param	playTime		播放多少时间,然后才卸载
		 * @return
		 */
		public function singleEffect(startTime:uint, path:String, x:int, y:int, isU2Link:Boolean = true, layer:DisplayLayer = null, scaleX:Number = 1, scaleY:Number = 1, playTime:int = -1):DisplayEDSingleEffect
		{
			if (UpReader.hideEffect) return null;
			var item:DisplayEDSingleEffect = DisplayEDSingleEffect.instance();
			singleLib.push(item);
			if (isU2Link)
			{
				item.setU2Link(u, startTime, path, x, y);
			}
			else
			{
				item.setDisplay(u, startTime, path, x, y, layer, scaleX, scaleY, playTime);
			}
			return item;
		}
		
		/** 清除 **/
		public function clear():void
		{
			if (singleLib)
			{
				if (singleLib.length)
				{
					for each (var item:DisplayEDSingleEffect in singleLib) 
					{
						item.dispose();
					}
					singleLib.length = 0;
				}
			}
		}
		
		/** 从场景上移除一个对象 **/
		public function removeED(ed:EDBase):void
		{
			var display:Object = map.display_ed[ed];
			delete map.display_ed[ed];
			if (display)
			{
				display.dispose();
				display = null;
			}
			if (ed.type == EDType.role && u.engine.type != StatusEngineType.over)
			{
				var role:EDRole = ed as EDRole;
				//播放死亡动画
				EDRoleToolsSkin.changeSkin(role, u.modeTurn);
				var path:String = "assets/model/" + role.model.id + "/" + role.displayId + ".u2";
				var sd:DisplayEDSingleEffect;
				if (u.modeTurn)
				{
					sd = singleEffect(u.engine.time.timeEngine, path, -role.x, -role.y, role.model.deadU2, map.layer_ground);
				}
				else
				{
					sd = singleEffect(u.engine.time.timeEngine, path, role.x, role.y, role.model.deadU2, map.layer_ground);
				}
				if (sd && sd.list)
				{
					for each (var u2:IU2Base in sd.list) 
					{
						u2.scaleX = role.model.scaleX;
						u2.scaleY = role.model.scaleY;
						if (role.displayMirror)
						{
							if (u2.scaleX > 0) u2.scaleX = -u2.scaleX;//要负数
						}
						else
						{
							if (u2.scaleX < 0) u2.scaleX = -u2.scaleX;//要正数
						}
					}
				}
				if (role.info && role.info.hero)
				{
					if (role.camp == 1)
					{
						role.x = 9999999;
						role.y = 9999999;
					}
					else
					{
						role.x = -9999999;
						role.y = -9999999;
					}
				}
			}
		}
		
		/** 摧毁对象 **/
		public function dispose():void 
		{
			if(map)
			{
				map.dispose();
				map = null;
			}
			if (singleLib)
			{
				if (singleLib.length)
				{
					for each (var item:DisplayEDSingleEffect in singleLib) 
					{
						item.dispose();
					}
					singleLib.length = 0;
				}
				singleLib = null;
			}
			if (gfile)
			{
				if (gfile is Array)
				{
					g.speedFact.d_array(gfile as Array);
				}
				gfile = null;
			}
			if (shake)
			{
				shake.dispose();
				shake = null;
			}
			if (bigEffect)
			{
				bigEffect.dispose();
				bigEffect = null;
			}
			if (cache)
			{
				for (var key:* in cache) 
				{
					delete cache[key];
				}
				cache = null;
			}
			u = null;
		}
		
		/**
		 * 添加一个震动的效果
		 * @param	shakeLength		震动时间
		 * @param	shakeType		震动类型, map整张地图震动, child地图内图层分别震动(ShockType)
		 * @param	delay			延迟时间
		 * @param	shakeX			震动的比例
		 * @param	shakeY			震动的比例
		 */
		public function addShake(shakeLength:uint, type:uint, delay:uint, shakeX:Number, shakeY:Number):void
		{
			if (shakeLength > 0 && type != 0 && (shakeX != 0 || shakeY != 0))
			{
				shake.push(type, shakeX, shakeY, delay, shakeLength);
			}
		}
	}
}