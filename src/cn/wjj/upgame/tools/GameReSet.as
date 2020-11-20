package cn.wjj.upgame.tools 
{
	import cn.wjj.g;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 根据现在的操作记录和时间,将游戏运行到当前时间点上
	 * 
	 * @author GaGa
	 */
	public class GameReSet 
	{
		
		public function GameReSet() { }
		
		/**
		 * 重置游戏
		 * @param	timeGo	充值到什么时间点
		 */
		public static function run(u:UpGame, timeStartBase:int):void
		{
			//不用停,直接干掉里面的东西
			u.engine.clear();
			u.engine.time.gameReSet();
			if (u.readerStart)
			{
				u.reader.map.clearEDDisplay();
				u.reader.map.clearTaskDisplay();
			}
			//将操作日志重新整理整合
			if (u.recordStart)
			{
				//重新初始化游戏
				u.record.init.initAll();
				//将 record.action -> record.live 中
				//遍历全部的对象,看对象们都在干嘛
				var action:Object;
				var live:Object;
				var timeGame:String;
				var camp:Object;
				var list:Array;
				var liveList:Array;
				var id:String;
				if (u.record.actionLength)
				{
					for (timeGame in u.record.action)
					{
						camp = u.record.action[timeGame];
						for (id in camp)
						{
							list = camp[id];
							delete camp[id];
							for each (action in list) 
							{
								if (u.record.live.hasOwnProperty(timeGame) == false)
								{
									live = g.speedFact.n_object();
									u.record.live[timeGame] = live;
								}
								else
								{
									live = u.record.live[timeGame];
								}
								if (live.hasOwnProperty(id) == false)
								{
									liveList = g.speedFact.n_array();
									live[id] = liveList;
								}
								else
								{
									liveList = live[id];
								}
								liveList.push(action);
								u.record.liveLength++;
							}
							g.speedFact.d_array(list);
						}
						g.speedFact.d_object(camp);
					}
					for (timeGame in u.record.action)
					{
						delete u.record.action[timeGame];
					}
					g.speedFact.d_object(u.record.action);
					u.record.action = null;
					u.record.actionLength = 0;
				}
				//翻转到 action 中
				u.record.action = u.record.live;
				u.record.actionLength = u.record.liveLength;
				u.record.live = g.speedFact.n_object();
				u.record.liveLength = 0;
			}
			//重新记录MD5
			if (u.reportStart)
			{
				u.report.gameReSet();
			}
		}
	}
}