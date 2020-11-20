package cn.wjj.upgame.engine 
{
	
	/**
	 * 人物或者怪物的移动
	 * 
	 * 有2种类型,一种是目标类型
	 * target : 移动到这个目标,达到射程就停掉
	 * point : 移动到这个坐标,到了也就停止了
	 * 
	 * @author GaGa
	 */
	public class AIRoleMove
	{
		
		/** 引用 **/
		public var ed:EDRole;
		/** 使用物理引擎驱动的移动 **/
		public var enginePhys:AIRoleMovePhys;
		/** 使用物理引擎驱动的移动 **/
		public var engineAStar:AIRoleMoveAStar;
		
		public function AIRoleMove() { }
		
		public function setThis(ed:EDRole):void
		{
			this.ed = ed;
			if (ed.u.modeMovePhys)
			{
				if (engineAStar)
				{
					engineAStar.clear();
					engineAStar = null;
				}
				if (enginePhys == null) enginePhys = new AIRoleMovePhys();
				enginePhys.setThis(ed);
			}
			else
			{
				if (enginePhys)
				{
					enginePhys.clear();
					enginePhys = null;
				}
				if (engineAStar == null) engineAStar = new AIRoleMoveAStar();
				engineAStar.setThis(ed);
			}
		}
		
		/** 清理对象, 及里面的全部内容 **/
		public function clear():void
		{
			if (enginePhys)
			{
				enginePhys.clear();
			}
			else if (engineAStar)
			{
				engineAStar.clear();
			}
		}
		
		/** 停止移动 **/
		public function stop():void
		{
			if (enginePhys)
			{
				enginePhys.stop();
			}
			else if (engineAStar)
			{
				engineAStar.stop();
			}
		}
		
		/**
		 * 根据位置进行巡逻
		 * 专门为对打制作的寻路
		 */
		public function patrol():void
		{
			if (enginePhys) enginePhys.patrol(ed.u);
		}
		
		/** 提前走入场景里 **/
		public function moveBlank():void
		{
			if (engineAStar) engineAStar.moveBlank();
		}
		
		/**
		 * 使用自动控制来移动到特定坐标位置
		 * 
		 * 中途变化的时候,如果点从格子变化另外的格子,连线会发生变化
		 * @param	x
		 * @param	y
		 * @param	lock
		 * @return	是否成功运行,还是本命令无效
		 */
		public function movePoint(x:int, y:int, lock:Boolean = false):Boolean
		{
			if (enginePhys)
			{
				return enginePhys.movePoint(x, y);
			}
			else if (engineAStar)
			{
				return engineAStar.movePoint(x, y, lock);
			}
			return false;
		}
		
		/**
		 * 跟踪敌人移动到攻击范围,中途不停的校验是否已经到达目标,不停的改变方向等
		 * 通过运行的时间,来算出距离,用距离和角度,算出每次叠加的x,y轴的距离,每次运行都加值
		 * @param	target
		 * @param	range
		 * @param	lock
		 */
		public function moveTarget(target:EDRole, range:uint, lock:Boolean = false):void
		{
			if (enginePhys)
			{
				enginePhys.moveTarget(target, range, lock);
			}
			else if (engineAStar)
			{
				engineAStar.moveTarget(target, range, lock);
			}
		}
		
		/**
		 * 不停的移动
		 * @param	doTarget	是否要处理攻击对象
		 * @return	移动完毕后的一个时间,如果是true,没有移动完毕
		 */
		public function moveFrame(doTarget:Boolean = true):Boolean 
		{
			if (enginePhys)
			{
				return enginePhys.moveFrame(ed.u, doTarget);
			}
			else if (engineAStar)
			{
				return engineAStar.moveFrame(ed.u, doTarget);
			}
			return false;
		}
	}
}