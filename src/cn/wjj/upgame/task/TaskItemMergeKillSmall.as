package cn.wjj.upgame.task 
{
	import cn.wjj.upgame.common.StatusTypeRole;
	import cn.wjj.upgame.engine.EDRole;
	
	/**
	 * 合计杀死小怪,有BOSS,有小怪,我方队员有目标为BOSS(不检测召唤和NPC),引导先杀小怪
	 * 并且小怪要有仇恨列表,小怪也需要停下来
	 * 
	 * @author GaGa
	 */
	public class TaskItemMergeKillSmall extends TaskItemBase 
	{
		/** 要捕获的服务器ID **/
		public var typeId:uint;
		/** 要选择的敌人 **/
		public var role:EDRole;
		/** 技能好的时候的回调函数 Function(task:TaskItemBase) **/
		private var openMethod:Function;
		
		public function TaskItemMergeKillSmall() 
		{
			type = TaskItemType.MergeKillSmall;
		}
		
		/**
		 * 设置任务
		 * @param	method	技能好的时候的回调函数 Function(task:TaskItemBase)
		 */
		public function setInfo(method:Function):void
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
			if (status == TaskItemStatus.running && role == null)
			{
				var hasBoss:Boolean = false;
				var hasSmall:Boolean = false;
				for each (var ed:EDRole in task.u.engine.camp2.listRole) 
				{
					if (ed.isLive)
					{
						if (ed.info.boss)
						{
							hasBoss = true;
						}
						else if (ed.activate && ed.inHot && ed.ai.hatred.maxED && ed.status != StatusTypeRole.move)
						{
							role = ed;
							hasSmall = true;
						}
					}
				}
				if (hasBoss && hasSmall)
				{
					//查看是否有人目标是打BOSS的
					var isLookBoss:Boolean = false;
					//查看子对象的目标,看看有没有是BOSS的,有就要瞄准那个role
					for each (ed in task.u.engine.camp1.listRole) 
					{
						if (ed.isLive && ed.dieAuto == 0)
						{
							if (ed.ai.skillFire && ed.ai.skillFire.target && ed.ai.skillFire.target.length)
							{
								if (ed.ai.skillFire.target[0].isLive && ed.ai.skillFire.target[0].info.boss)
								{
									isLookBoss = true;
									break;
								}
							}
							else if (ed.ai.hatred.maxED && ed.ai.hatred.maxED.info.boss)
							{
								isLookBoss = true;
								break;
							}
						}
					}
					if (isLookBoss && openMethod != null)
					{
						//如果复合条件,就执行里面的函数,Display是干什么的~?
						//var display:DisplayEDEffect = task.u.reader.map.taskToDisplay(this) as DisplayEDEffect;
						//if (display)
						//{
							openMethod(this);
							openMethod = null;
						//}
					}
					else if (role)
					{
						role = null;
					}
				}
				else if(role)
				{
					role = null;
				}
			}
		}
	}
}