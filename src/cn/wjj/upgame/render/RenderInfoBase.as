package cn.wjj.upgame.render 
{
	import cn.wjj.upgame.engine.EDBase;
	/**
	 * 记录影响UI的一些状态
	 * 
	 * @author GaGa
	 */
	public class RenderInfoBase 
	{
		/** 影响界面的类型 **/
		public var type:int = RenderInfoType.create;
		
		public function RenderInfoBase() { }
	}
}