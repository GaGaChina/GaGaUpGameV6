package cn.wjj.upgame.render 
{
	import cn.wjj.display.MPoint;
	import cn.wjj.upgame.task.TaskItemBreakBossSkill2;
	import cn.wjj.upgame.task.TaskItemStatus;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 处理任务显示对象
	 * 
	 * @author GaGa
	 */
	public class EngineTaskBreakBossSkill2 
	{
		
		public function EngineTaskBreakBossSkill2() { }
		
		/**
		 * 根据任务来设置场景里的变化
		 * @param	upGame
		 * @param	task
		 */
		public static function run(u:UpGame, task:TaskItemBreakBossSkill2, core:int):void
		{
			if (task.role)
			{
				var display:DisplayEDEffect = u.reader.map.taskToDisplay(task) as DisplayEDEffect;
				//将文字放到屏幕的中间区域
				var centerX:int = 0;
				var centerY:int = int((u.reader.map.layer_flyEffectTop.stageY1 + u.reader.map.layer_flyEffectTop.stageY2) / 2);
				if (task.status != TaskItemStatus.complete && u.reader.map.layer_flyEffectTop.canInLayer(centerX, centerY, 400))
				{
					if (display == null)
					{
						display = create(u, task, centerX, centerY);
					}
					else
					{
						display.changeSizeInfo(centerX, centerY);
					}
					display.playThis(core);
				}
				else if (display)
				{
					delete u.reader.map.display_task[task];
					display.dispose();
				}
			}
		}
		
		
		/** 通过ED数据来获取显示对象 **/
		private static function create(u:UpGame, task:TaskItemBreakBossSkill2, centerX:int, centerY:int):DisplayEDEffect
		{
			var display:DisplayEDEffect = DisplayEDEffect.instance();
			display.setDisplay(u, 0, "art/game/st_z_005.u2", centerX, centerY, u.reader.map.layer_flyEffectTop);
			u.reader.map.display_task[task] = display;
			return display;
		}
		
		/** 可以移除了 **/
		public static function remove(u:UpGame, task:TaskItemBreakBossSkill2):void
		{
			var display:DisplayEDEffect = u.reader.map.taskToDisplay(task) as DisplayEDEffect;
			delete u.reader.map.display_task[task];
			if (display)
			{
				display.dispose();
			}
		}
	}
}