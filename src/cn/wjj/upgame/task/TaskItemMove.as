package cn.wjj.upgame.task 
{
	import cn.wjj.upgame.engine.EDRole;
	/**
	 * 人物移动的时候的控制
	 * 
	 * 可以控制EDRole,进去区域startX, endX ,startY, endY内的时候触发
	 * 
	 * @author GaGa
	 */
	public class TaskItemMove extends TaskItemBase 
	{
		/** 要检测的角色 **/
		private var role:EDRole;
		/** 区域的开始坐标 **/
		private var startX:int;
		/** 区域的开始坐标 **/
		private var startY:int;
		/** 区域的结束坐标 **/
		private var endX:int;
		/** 区域的结束坐标 **/
		private var endY:int;
		
		/** 是否有特殊的U2地址, 默认是art/game/st_z_001.u2 **/
		public var u2Path:String = "";
		/** 区域的结束坐标 **/
		public var centerX:int;
		/** 区域的结束坐标 **/
		public var centerY:int;
		
		public function TaskItemMove() 
		{
			type = TaskItemType.Move;
		}
		
		/**
		 * 设置任务
		 * @param	role
		 * @param	startX
		 * @param	startY
		 * @param	endX
		 * @param	endY
		 * @param	u2Path		默认播放的U2
		 */
		public function setInfo(role:EDRole, startX:int, startY:int, endX:int, endY:int, u2Path:String = ""):void
		{
			if (status == TaskItemStatus.sleep)
			{
				status = TaskItemStatus.init;
				this.role = role;
				this.startX = startX;
				this.startY = startY;
				this.endX = endX;
				this.endY = endY;
				centerX = int((endX - startX) / 2 + startX);
				centerY = int((endY - startY) / 2 + startY);
				this.u2Path = u2Path;
			}
			else
			{
				throw new Error("逻辑顺序错误");
			}
		}
		
		/** 是否完成本项任务 **/
		override public function check():void 
		{
			if (status == TaskItemStatus.running && startX <= role.x && role.x <= endX && startY <= role.y && role.y <= endY)
			{
				finish();
			}
		}
	}
}