package cn.wjj.upgame.common 
{
	import cn.wjj.gagaframe.client.speedfact.SByte;
	
	/**
	 * 向上游戏框架里的全部的数据
	 * 
	 * @author GaGa
	 */
	public interface IUpInfo 
	{
		/** 返回数据类型 **/
		function get type():uint;
		/** 获取这个对象的全部属性信息 **/
		function getByte():SByte;
		/** 读取这个内容, 返回错误信息, 0为成功 **/
		function setByte(b:SByte):void;
		/** 克隆对象 **/
		function clone():IUpInfo;
		/** 移除,清理,并回收 **/
		function dispose():void;
	}
}