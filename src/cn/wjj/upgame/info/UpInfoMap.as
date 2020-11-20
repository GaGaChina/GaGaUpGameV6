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
	public class UpInfoMap extends UpInfoBase
	{
		/** 信息的版本号 **/
		public var ver:uint;
		
		/** (0 到 255)主容器的震动 **/
		public var shockX:uint = 0;
		/** (0 到 255)主容器的震动 **/
		public var shockY:uint = 0;
		
		/** (0 到 255)整个显示对象的震动范围 **/
		public var shockMaxX:uint = 0;
		/** (0 到 255)整个显示对象的震动范围 **/
		public var shockMaxY:uint = 0;
		
		/** 图层数据 **/
		public var layer:UpInfoLayerLib;
		
		public function UpInfoMap()
		{
			this._type = UpInfoType.map;
			layer = new UpInfoLayerLib();
		}
		
		/** 获取这个对象的全部属性信息 **/
		override public function getByte():SByte 
		{
			var b:SByte = super.getByte();
			b.writeByte(shockX);
			b.writeByte(shockY);
			b.writeByte(shockMaxX);
			b.writeByte(shockMaxY);
			b._w_CByteArray(layer.getByte(), 32);
			return b;
		}
		
		/** 读取这个内容, 返回错误信息, 0为成功 **/
		override public function setByte(b:SByte):void 
		{
			shockX = b.readUnsignedByte();
			shockY = b.readUnsignedByte();
			shockMaxX = b.readUnsignedByte();
			shockMaxY = b.readUnsignedByte();
			if (ver > 2)
			{
				b.readUnsignedInt();
				layer.setByte(b);
			}
			else
			{
				b.readUnsignedShort();
				layer.setByte(b);
			}
		}
		
		/** 克隆一个对象 **/
		override public function clone():IUpInfo 
		{
			var o:UpInfoMap = new UpInfoMap();
			o.shockX = shockX;
			o.shockY = shockY;
			o.layer = layer.clone() as UpInfoLayerLib;
			return o;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			layer.dispose();
		}
	}
}