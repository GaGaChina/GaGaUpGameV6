package cn.wjj.upgame.engine 
{
	import cn.wjj.upgame.common.StatusTypeBullet;
	/**
	 * 弹道的基类
	 * 
	 * @author GaGa
	 */
	public class AIBulletTrack 
	{
		public var ed:EDBullet;
		/** 目标形的弹道是否已经到达目标 **/
		public var isHit:Boolean = false;
		/** 是否已经达到了射程,如果达到,而且没有碰到人物,就要让子弹落地 **/
		public var outRange:Boolean = false;
		
		public function AIBulletTrack() { }
		
		/** 基本弹道的运行 **/
		public function start(ed:EDBullet):void
		{
			ed.uiBase = true;
			this.ed = ed;
			isHit = false;
		}
		
		public function move():void
		{
			ed.uiBase = true;
		}
		
		/** 摧毁对象 **/
		public function dispose():void
		{
			ed = null;
			isHit = false;
			outRange = false;
		}
	}
}