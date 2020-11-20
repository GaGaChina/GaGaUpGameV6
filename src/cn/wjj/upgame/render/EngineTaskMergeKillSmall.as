package cn.wjj.upgame.render 
{
	import cn.wjj.upgame.task.TaskItemMergeKillSmall;
	import cn.wjj.upgame.task.TaskItemStatus;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 处理任务显示对象
	 * 
	 * @author GaGa
	 */
	public class EngineTaskMergeKillSmall 
	{
		
		public function EngineTaskMergeKillSmall() { }
		
		/**
		 * 根据任务来设置场景里的变化
		 * @param	upGame
		 * @param	task
		 */
		public static function run(u:UpGame, task:TaskItemMergeKillSmall, core:int):void
		{
			if (task.role)
			{
				var display:DisplayEDEffect = u.reader.map.taskToDisplay(task) as DisplayEDEffect;
				var centerX:int = task.role.x + task.role.model.dragX;
				var centerY:int = task.role.y + task.role.model.dragY;
				if (task.role.model.dragType == 1)
				{
					centerX += int(task.role.model.dragWidth / 2);
					centerY += int(task.role.model.dragHeight / 2);
				}
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
		private static function create(u:UpGame, task:TaskItemMergeKillSmall, centerX:int, centerY:int):DisplayEDEffect
		{
			var display:DisplayEDEffect = DisplayEDEffect.instance();
			display.setDisplay(u, 0, "art/game/st_z_006.u2", centerX, centerY, u.reader.map.layer_flyEffectTop);
			u.reader.map.display_task[task] = display;
			return display;
		}
		
		/** 可以移除了 **/
		public static function remove(u:UpGame, task:TaskItemMergeKillSmall):void
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