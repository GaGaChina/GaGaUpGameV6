package cn.wjj.upgame.engine 
{
	import cn.wjj.upgame.common.EDType;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 只是一个显示对象,用于控制显示的
	 * 
	 * @author GaGa
	 */
	public class EDDisplay extends EDBase
	{
		/** 角度 **/
		public var angle:int = 0;
		/** 播放了多少时间了,-1就是循环播放 **/
		public var playTime:int = 0;
		/** 现在的资源ID **/
		public var displayId:uint = 0;
		/** 显示对象的类型,0 : DisplayEDU2LinkInfo **/
		public var displayType:uint = 0;
		/** 显示对象文件所在目录,0从技能里取,1从子弹里取 **/
		public var pathType:uint = 0;
		
		public function EDDisplay(u:UpGame) 
		{
			super(u);
			type = EDType.display;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
		}
	}
}