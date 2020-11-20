package cn.wjj.upgame.task 
{
	import cn.wjj.upgame.engine.EDRole;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * UpGame战斗中的任务系统,本系统可以提供
	 * 
	 * 根据length的长度来判断是否有任务还未完成
	 * 
	 * 
	 * 
	 * @author GaGa
	 */
	public class UpTask 
	{
		/** 父引用 **/
		public var u:UpGame;
		/** 过关必须完成的列表长度 **/
		public var lengthMust:int = 0;
		/** 任务列表 **/
		public var list:Vector.<TaskItemBase>;
		/** 任务列表数量 **/
		public var listLength:int = 0;
		/** 正在运行的任务列表 **/
		public var runList:Vector.<TaskItemBase>;
		/** 正在运行的列表数量 **/
		public var runLength:int = 0;
		/** 现在监听死亡EDRole数量 **/
		public var listenerEDRoleKill:int = 0;
		
		public function UpTask(u:UpGame) 
		{
			this.u = u;
			list = new Vector.<TaskItemBase>();
			runList = new Vector.<TaskItemBase>();
		}
		
		/**
		 * 添加任务,并运行
		 * @param	item
		 */
		public function push(item:TaskItemBase):void
		{
			item.task = this;
			list.push(item);
			listLength++;
			setMust(item);
			item.start();
		}
		
		/** 设置里面胜利的时候必须完成的任务 **/
		private function setMust(item:TaskItemBase):void
		{
			if (item.isMust)
			{
				lengthMust++;
			}
			if (item.type == TaskItemType.List)
			{
				var list:Vector.<TaskItemBase> = (item as TaskItemList).list;
				for each (item in list) 
				{
					setMust(item);
				}
			}
		}
		
		/** 不停检测任务的运行状态 **/
		public function enterFrame():void
		{
			var i:int = runLength;
			var item:TaskItemBase;
			while (--i > - 1)
			{
				item = runList[i];
				switch (item.type) 
				{
					case TaskItemType.Kill:
						break;
					case TaskItemType.Move:
					case TaskItemType.ReleaseSkill:
					case TaskItemType.SelectEnemy:
					case TaskItemType.MergeKillSmall:
					default:
						item.check();
				}
			}
		}
		
		/**
		 * 杀死某怪物查看是否触发
		 * @param	ed
		 */
		public function killEDRole(ed:EDRole):void
		{
			var i:int = runLength;
			var item:TaskItemBase;
			var kill:TaskItemKill;
			while (--i > - 1)
			{
				item = runList[i];
				if (item.type == TaskItemType.Kill) 
				{
					kill = item as TaskItemKill;
					if (kill.role == ed)
					{
						listenerEDRoleKill--;
						kill.finish();
					}
				}
			}
		}
		
		public function dispose():void
		{
			lengthMust = 0;
			if (runLength)
			{
				runList.length = 0;
				runLength = 0;
			}
			if (listLength)
			{
				var item:TaskItemBase;
				while (--listLength > - 1) 
				{
					item = list[listLength];
					item.dispose();
				}
				listLength = 0;
				list.length = 0;
			}
			if (u)
			{
				u = null;
			}
		}
	}
}