package cn.wjj.upgame.engine 
{
	import cn.wjj.gagaframe.client.speedfact.SpeedLib;
	/**
	 * A星移动专属的数据结构
	 * 
	 * 可以表达出到某个点,这个人物的形象,还有方向
	 * 
	 * @author GaGa
	 */
	public class AIRoleMovePoint
	{
		
		/** 对象池 **/
		private static var __f:SpeedLib = new SpeedLib(500);
		/** 对象池强引用的最大数量 **/
		static public function get __m():uint {return __f.length;}
		/** 对象池强引用的最大数量 **/
		static public function set __m(value:uint):void { __f.length = value; }
		/** X的坐标 **/
		public var x:int = 0;
		/** Y的坐标 **/
		public var y:int = 0;
		/** 路径的角度 **/
		public var angle:Number = 0;
		/** 路径的弧度 **/
		public var radian:Number = 0;
		
		public function AIRoleMovePoint(x:int, y:int, angle:uint = 0, radian:uint = 0)
		{
			this.x = x;
			this.y = y;
			this.angle = angle;
			this.radian = radian;
		}
		
		/** 初始化 AIRoleMovePoint **/
		public static function instance(x:int, y:int, angle:uint = 0, radian:uint = 0):AIRoleMovePoint
		{
			var o:AIRoleMovePoint = __f.instance() as AIRoleMovePoint;
			if (o)
			{
				if (o.x != x ) o.x = x;
				if (o.y != y ) o.y = y;
				if (o.angle != angle ) o.angle = angle;
				if (o.radian != radian ) o.radian = radian;
				return o;
			}
			return new AIRoleMovePoint(x, y, angle, radian);
		}
		
		/** 移除,清理,并回收 **/
		public function dispose():void
		{
			if (this.x != 0) this.x = 0;
			if (this.y != 0) this.y = 0;
			if (this.angle != 0) this.angle = 0;
			if (this.radian != 0) this.radian = 0;
			__f.recover(this);
		}
	}
}