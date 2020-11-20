package cn.wjj.upgame.render 
{
	import cn.wjj.upgame.task.TaskItemMove;
	import cn.wjj.upgame.task.TaskItemStatus;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 处理任务显示对象
	 * 
	 * @author GaGa
	 */
	public class EngineTaskMove 
	{
		
		public function EngineTaskMove() { }
		
		/**
		 * 根据任务来设置场景里的变化
		 * @param	upGame
		 * @param	task
		 */
		public static function run(u:UpGame, task:TaskItemMove, core:int):void
		{
			var display:DisplayEDEffect = u.reader.map.taskToDisplay(task) as DisplayEDEffect;
			if (task.status != TaskItemStatus.complete && u.reader.map.layer_flyEffectTop.canInLayer(task.centerX, task.centerY, 400))
			{
				if (display == null) display = create(u, task);
				display.playThis(core);
			}
			else if (display)
			{
				delete u.reader.map.display_task[task];
				display.dispose();
			}
		}
		
		/** 通过ED数据来获取显示对象 **/
		private static function create(u:UpGame, task:TaskItemMove):DisplayEDEffect
		{
			var display:DisplayEDEffect = DisplayEDEffect.instance();
			if (task.u2Path)
			{
				display.setDisplay(u, 0, task.u2Path, task.centerX, task.centerY, u.reader.map.layer_flyEffectTop);
			}
			else
			{
				display.setDisplay(u, 0, "art/game/st_z_001.u2", task.centerX, task.centerY, u.reader.map.layer_flyEffectTop);
			}
			u.reader.map.display_task[task] = display;
			return display;
		}
		
		/** 可以移除了 **/
		public static function remove(u:UpGame, task:TaskItemMove):void
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