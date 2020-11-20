package cn.wjj.upgame.engine 
{
	import cn.wjj.display.MPoint;
	import cn.wjj.upgame.common.EDType;
	import cn.wjj.upgame.common.StatusTypeBullet;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 子弹的虚拟
	 * 
	 * @author GaGa
	 */
	public class EDBullet extends EDBase
	{
		/** 状态 **/
		public var status:int;
		/** 这个对象的AI控制模块 **/
		public var ai:AIBullet;
		/** 子弹的拥有者 **/
		public var owner:EDRole;
		/** [有目标的类型]子弹的目标坐标 **/
		public var point:MPoint;
		/** [按角度的类型]飞行的角度 **/
		public var angle:int = 0;
		/** 子弹透明度 **/
		public var alpha:Number = 0;
		/** 这个子弹的基本属性数据 **/
		public var info:OBullet;
		/** 放缩比率 **/
		public var scaleX:Number = 1;
		/** 放缩比率 **/
		public var scaleY:Number = 1;
		
		/** 运算碰撞使用中间点(先运行这个碰撞点) **/
		//public var hitX:Number = 0;
		//public var hitY:Number = 0;
		/** 碰撞的时候是否是使用的这个碰撞点 **/
		//public var hitRun:Boolean = false;
		
		public function EDBullet(u:UpGame) 
		{
			super(u);
			type = EDType.bullet;
			status = StatusTypeBullet.no;
			//创建显示对象要和一个子弹的属性绑定
		}
		
		/** 执行AI部分 **/
		override public function aiRun():void 
		{
			ai.aiRun();
		}
		
		/** 查看是否有打到人 **/
		override public function aiTarget():void 
		{
			ai.aiTarget();
		}
		
		override public function dispose():void 
		{
			super.dispose();
			if (ai)
			{
				ai.dispose();
				ai = null;
			}
			if (info)
			{
				info = null;
			}
			if (owner) owner = null;
			if (point) point = null;
		}
	}
}