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
	public class UpInfoStageInfo extends UpInfoBase
	{
		
		/** 开始的坐标 **/
		public var x:int = 0;
		/** 开始的Y坐标 **/
		public var y:int = 0;
		/** 场景的宽度 **/
		public var width:uint = 0;
		/** 场景的宽度 **/
		public var height:uint = 0;
		
		public function UpInfoStageInfo() 
		{
			this._type = UpInfoType.stageInfo;
		}
		
		/** 获取这个对象的全部属性信息 **/
		override public function getByte():SByte 
		{
			var b:SByte = super.getByte();
			b.writeFloat(x);
			b.writeFloat(y);
			b.writeFloat(width);
			b.writeFloat(height);
			return b;
		}
		
		/** 读取这个内容, 返回错误信息, 0为成功 **/
		override public function setByte(b:SByte):void 
		{
			x = b.readFloat();
			y = b.readFloat();
			width = b.readFloat();
			height = b.readFloat();
		}
		
		override public function clone():IUpInfo 
		{
			var o:UpInfoStageInfo = new UpInfoStageInfo();
			o.x = x;
			o.y = y;
			o.width = width;
			o.height = height;
			return o;
		}
	}
}