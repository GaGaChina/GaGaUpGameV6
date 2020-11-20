package cn.wjj.upgame.task 
{
	import cn.wjj.upgame.engine.EDCamp;
	import cn.wjj.upgame.engine.EDRole;
	import cn.wjj.upgame.render.DisplayEDEffect;
	
	/**
	 * 检测,选中某个敌人,当敌人,进入场景位置的时候,游戏暂停,被选中的时候,任务结束,恢复游戏
	 * 
	 * @author GaGa
	 */
	public class TaskItemSelectEnemy extends TaskItemBase 
	{
		/** 要捕获的服务器ID **/
		public var typeId:uint;
		/** 要选择的敌人 **/
		public var role:EDRole;
		/** 技能好的时候的回调函数 Function(task:TaskItemBase) **/
		private var openMethod:Function;
		
		public function TaskItemSelectEnemy() 
		{
			type = TaskItemType.SelectEnemy;
		}
		
		/**
		 * 设置任务
		 * @param	target		要选中的敌人
		 */
		public function setInfo(typeId:uint, method:Function):void
		{
			if (status == TaskItemStatus.sleep)
			{
				status = TaskItemStatus.init;
				this.typeId = typeId;
				this.openMethod = method;
			}
			else
			{
				throw new Error("逻辑顺序错误");
			}
		}
		
		/** 是否完成本项任务 **/
		override public function check():void 
		{
			if (status == TaskItemStatus.running)
			{
				if (role == null)
				{
					for each (var camp:EDCamp in task.u.engine.campLib) 
					{
						if (camp.length)
						{
							for each (var ed:EDRole in camp.listRole) 
							{
								if (ed.isLive && ed.info.idType == 2 && ed.info.id == typeId)
								{
									role = ed;
									break;
								}
							}
							if (role)
							{
								break;
							}
						}
					}
				}
				if (role && role.isLive && role.activate && role.inHot)
				{
					var display:DisplayEDEffect = task.u.reader.map.taskToDisplay(this) as DisplayEDEffect;
					if (display)
					{
						if (openMethod != null)
						{
							openMethod(this);
							openMethod = null;
						}
						//需要这里按下的时候完成它
					}
				}
			}
		}
	}
}