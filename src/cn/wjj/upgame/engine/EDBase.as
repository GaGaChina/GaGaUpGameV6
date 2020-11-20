package cn.wjj.upgame.engine 
{
	import cn.wjj.upgame.common.EDType;
	import cn.wjj.upgame.render.RenderInfoBase;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 完全的数据模拟类型基类
	 * 
	 * @author GaGa
	 */
	public class EDBase 
	{
		/** 游戏主框架 **/
		public var u:UpGame;
		/** UI上行为变化 **/
		public var uiList:Vector.<RenderInfoBase>;
		/** UI上的坐标, 透明度, 角度变化 **/
		public var uiBase:Boolean = false;
		/** 是否是活物,摧毁内容不与考虑,UI层发现的时候,要从UI层处理掉 **/
		public var isLive:Boolean = true;
		/** 地图上的位置 **/
		public var x:Number = 0;
		public var y:Number = 0;
		/** 地图中物品的类型 **/
		public var type:int = 0;
		/** 在第几节运转 **/
		public var section:int = 0;
		/** 所属于的阵营的ID, 0是一个乱打的阵营 **/
		public var camp:int = 0;
		/** 所属的玩家ID **/
		public var playerId:int = 0;
		/** 创建时间 **/
		public var creatTime:int = -1;
		
		public function EDBase(u:UpGame)
		{
			this.u = u;
			type = EDType.base;
			creatTime = u.engine.time.timeGame;
		}
		
		/**
		 * 行为思考,就是准备下一步要做什么样的处理
		 * 自己人没有目标,查看视野范围内,有没有目标
		 * 是不是要准备移动,马上会进行移动处理
		 * 如果已经有目标,就不用在执行这个
		 * 本来就不需要目标的那种类型,子弹,就略过
		 * 
		 * 按照计划移动到应该移动的地方
		 * 处于start, live模式的情况下运行
		 */
		public function aiRun():void { }
		/**
		 * 子弹:查看是否已经有碰到人物,或怪物
		 * 人物:是否已经到达射程,进行攻击
		 * 处于start模式的情况下运行
		 */
		public function aiTarget():void { }
		
		/** 移除,清理,并回收 **/
		public function dispose():void
		{
			if (isLive) isLive = false;
			if (u)
			{
				u.engine.removeED(this);
				u = null;
			}
		}
	}
}