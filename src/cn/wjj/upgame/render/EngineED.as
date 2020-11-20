package cn.wjj.upgame.render 
{
	import cn.wjj.data.ObjectArraySort;
	import cn.wjj.upgame.common.EDType;
	import cn.wjj.upgame.engine.EDBase;
	import cn.wjj.upgame.engine.EDBullet;
	import cn.wjj.upgame.engine.EDCamp;
	import cn.wjj.upgame.engine.EDDisplay;
	import cn.wjj.upgame.engine.EDRole;
	import cn.wjj.upgame.engine.EDSkillContinue;
	import cn.wjj.upgame.task.TaskItemBase;
	import cn.wjj.upgame.task.TaskItemBreakBossSkill2;
	import cn.wjj.upgame.task.TaskItemMergeKillSmall;
	import cn.wjj.upgame.task.TaskItemMove;
	import cn.wjj.upgame.task.TaskItemSelectEnemy;
	import cn.wjj.upgame.task.TaskItemType;
	import cn.wjj.upgame.UpGame;
	import flash.display.DisplayObject;
	/**
	 * 专门处理ED信息
	 * 
	 * @author GaGa
	 */
	public class EngineED 
	{
		/** 是否已经开启DEBUG **/
		private static var isDebug:Boolean = false;
		
		public function EngineED() { }
		
		/** 把所有的ED信息处理掉,并且清空 **/
		public static function run(u:UpGame):void
		{
			var core:int = u.engine.time.timeEngine;
			//传入时间来控制动画
			var removeLib:Vector.<EDBase> = u.reader.removeLib;
			for each (var ed:EDBase in removeLib) 
			{
				u.reader.removeED(ed);
			}
			removeLib.length = 0;
			//遍历所有的ED对象,把里面对显示列表有影响的内容全处理了
			var campLib:Vector.<EDCamp> = u.engine.campLib;
			for each (var camp:EDCamp in campLib) 
			{
				for each (ed in camp.list)
				{
					if (ed.isLive)
					{
						switch (ed.type) 
						{
							case EDType.bullet:
								EngineEDBullet.run(u, ed as EDBullet, core)
								break;
							case EDType.role:
								EngineEDRole.run(u, ed as EDRole, core)
								break;
							case EDType.skillContinue:
								EngineEDContinue.run(u, ed as EDSkillContinue, core)
								break;
							case EDType.display:
								EngineEDDisplay.run(u, ed as EDDisplay, core);
								break;
						}
					}
					else
					{
						if (ed.type == EDType.role && (ed.x < -1000000 || ed.x > 1000000 || ed.y < -1000000 || ed.y > 1000000))
						{
							
						}
						else
						{
							u.reader.removeED(ed);
						}
					}
				}
			}
			//排序需要排序的层级
			changeIndexLayer(u, core);
			//检测播放一次的特效的情况
			var singleLib:Vector.<DisplayEDSingleEffect> = u.reader.singleLib;
			var length:uint = singleLib.length;
			var single:DisplayEDSingleEffect;
			while (--length > -1)
			{
				single = singleLib[length];
				single.playThis(core);
			}
			//可以进行任务需要的界面处理
			if (u.taskStart && u.task.runLength)
			{
				for each (var task:TaskItemBase in u.task.runList) 
				{
					switch (task.type) 
					{
						case TaskItemType.Move:
							EngineTaskMove.run(u, task as TaskItemMove, core);
							break;
						case TaskItemType.SelectEnemy:
							EngineTaskSelectEnemy.run(u, task as TaskItemSelectEnemy, core);
							break;
						case TaskItemType.MergeKillSmall:
							EngineTaskMergeKillSmall.run(u, task as TaskItemMergeKillSmall, core);
							break;
						case TaskItemType.BreakBossSkill2:
							EngineTaskBreakBossSkill2.run(u, task as TaskItemBreakBossSkill2, core);
							break;
					}
				}
			}
			if (u.isDebug)
			{
				isDebug = true;
				u.reader.map.addDebug();
				for each (camp in campLib) 
				{
					for each (ed in camp.list)
					{
						if (ed.isLive && ed.type == EDType.role)
						{
							EngineEDRole.addDebug(u, ed as EDRole)
						}
					}
				}
			}
			else if(isDebug)
			{
				isDebug = false;
				u.reader.map.removeDebug();
				for each (camp in campLib) 
				{
					for each (ed in camp.list)
					{
						if (ed.isLive && ed.type == EDType.role)
						{
							EngineEDRole.removeDebug(u, ed as EDRole)
						}
					}
				}
			}
		}
		
		private static var indexList:Array = new Array();
		
		/** 排序图层层级 **/
		private static function changeIndexLayer(u:UpGame, core:int):void
		{
			var list:Vector.<DisplayLayer> = u.reader.map.lib;
			var item:DisplayItem;
			for each (var layer:DisplayLayer in list) 
			{
				if (layer.reIndex)
				{
					layer.reIndex = false;
					switch (layer.info.useIndex) 
					{
						case 1://通过X,Y参数来排列图层的先后
							var i:int;
							var length:int = layer.numChildren;
							for (i = 0; i < length; i++) 
							{
								indexList.push(layer.getChildAt(i));
							}
							EngineED.sortList(indexList);
							length = indexList.length - 1;
							if (length > 0)
							{
								var indexA:uint, indexB:uint;
								var a:DisplayObject, b:DisplayObject;
								for (i = 0; i < length; i++) 
								{
									a = indexList[i] as DisplayObject;
									b = indexList[i + 1] as DisplayObject;
									indexA = layer.getChildIndex(a);
									indexB = layer.getChildIndex(b);
									if (indexA > indexB)
									{
										layer.addChildAt(a, indexB);
										layer.addChildAt(b, indexB + 1);
									}
								}
							}
							indexList.length = 0;
							break;
						/*
						case 0:
							break;
						case 2://通过碰撞点坐标排序
							break;
						*/
					}
				}
				//刷新场景上的内容
				if (layer.libLength)
				{
					for each (item in layer.lib) 
					{
						if (item.inLayer && item.sendCore && (item._display as Object).timer)
						{
							(item._display as Object).timer.timeCore(core, -1, false, true);
						}
					}
				}
			}
		}
		
		/** 排序内容 **/
		private static var sortConfig:Array;
		/**
		 * 排序：hatred大到小, index小到大 
		 */
		public static function sortList(arr:*):void
		{
			if (sortConfig == null)
			{
				sortConfig = new Array();
				sortConfig.push(ObjectArraySort.getSortItem_p("y", "0", ObjectArraySort.SORT_NUMBER_SMAILL_BIG, true));
				sortConfig.push(ObjectArraySort.getSortItem_p("x", "0",  ObjectArraySort.SORT_NUMBER_SMAILL_BIG, false));
			}
			ObjectArraySort.sort(arr, sortConfig, null, null, true);
		}
	}
}