package cn.wjj.upgame.info 
{
	import cn.wjj.gagaframe.client.speedfact.SByte;
	import cn.wjj.upgame.common.IUpInfo;
	import cn.wjj.upgame.common.UpInfoType;
	
	/**
	 * 全部的数据部分
	 * 
	 * @author GaGa
	 */
	public class UpInfoBase implements IUpInfo
	{
		/** 文件的类型 **/
		internal var _type:uint;
		
		public function UpInfoBase() { _type = UpInfoType.base; }
		/** 返回数据类型 **/
		public function get type():uint { return _type; }
		/** 获取这个对象的全部属性信息 **/
		public function getByte():SByte { return SByte.instance(); }
		/** 读取这个内容, 返回错误信息, 0为成功 **/
		public function setByte(b:SByte):void { }
		/** 移除,清理,并回收 **/
		public function dispose():void { }
		/** 克隆一个对象 **/
		public function clone():IUpInfo { return new UpInfoBase(); }
	}
}