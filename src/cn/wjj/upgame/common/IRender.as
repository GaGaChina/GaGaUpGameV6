package cn.wjj.upgame.common 
{
	import cn.wjj.gagaframe.client.factory.FSprite;
	
	/**
	 * 显示驱动层的接口
	 * 
	 * @author GaGa
	 */
	public interface IRender 
	{
		/** 移除,清理,并回收 **/
		function dispose():void;
	}
}