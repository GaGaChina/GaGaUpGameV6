package cn.wjj.upgame.info 
{
	import cn.wjj.gagaframe.client.speedfact.SByte;
	import cn.wjj.upgame.common.IUpInfo;
	import cn.wjj.upgame.common.UpInfoDisplayType;
	import cn.wjj.upgame.common.UpInfoType;
	
	/**
	 * 地图上所有的显示对象的信息
	 * 
	 * @author GaGa
	 */
	public class UpInfoDisplay extends UpInfoBase
	{
		/** 是否已经设置显示区域 **/
		public var isSetXY:Boolean = false;
		/** 显示区域 **/
		public var sx1:Number = 0;
		public var sx2:Number = 0;
		/** 显示区域 **/
		public var sy1:Number = 0;
		public var sy2:Number = 0;
		
		/** 坐标 **/
		public var x:Number = 0;
		/** 坐标 **/
		public var y:Number = 0;
		/** 图层透明度 **/
		public var alpha:Number = 1;
		/** 图层角度 **/
		public var rotation:Number = 0;
		/** 图层X轴比例 **/
		public var scaleX:Number = 1;
		/** 图层Y轴比例 **/
		public var scaleY:Number = 1;
		/** 显示对象的类型 **/
		public var displayType:uint = UpInfoDisplayType.no;
		/** 显示对象在GFile里的路径 **/
		public var path:String = "";
		
		public function UpInfoDisplay()
		{
			this._type = UpInfoType.display;
		}
		
		/** 获取这个对象的全部属性信息 **/
		override public function getByte():SByte 
		{
			var b:SByte = super.getByte();
			b.writeInt(int(sx1 * 1000));
			b.writeInt(int(sx2 * 1000));
			b.writeInt(int(sy1 * 1000));
			b.writeInt(int(sy2 * 1000));
			b.writeInt(int(x * 1000));
			b.writeInt(int(y * 1000));
			b.writeInt(int(scaleX * 1000));
			b.writeInt(int(scaleY * 1000));
			b.writeByte(uint(alpha * 100));
			b.writeInt(int(rotation * 1000));
			b.writeByte(displayType);
			b._w_String(path);
			return b;
		}
		
		/** 读取这个内容, 返回错误信息, 0为成功 **/
		override public function setByte(b:SByte):void 
		{
			sx1 = b.readInt() / 1000;
			sx2 = b.readInt() / 1000;
			sy1 = b.readInt() / 1000;
			sy2 = b.readInt() / 1000;
			x = b.readInt() / 1000;
			y = b.readInt() / 1000;
			scaleX = b.readInt() / 1000;
			scaleY = b.readInt() / 1000;
			alpha = b.readUnsignedByte() / 100;
			rotation = b.readInt() / 1000;
			displayType = b.readUnsignedByte();
			path = b._r_String();
		}
		
		override public function clone():IUpInfo 
		{
			var o:UpInfoDisplay = new UpInfoDisplay();
			o.isSetXY = isSetXY;
			o.sx1 = sx1;
			o.sx2 = sx2;
			o.sy1 = sy1;
			o.sy2 = sy2;
			o.x = x;
			o.y = y;
			o.scaleX = scaleX;
			o.scaleY = scaleY;
			o.rotation = rotation;
			o.alpha = alpha;
			o.displayType = displayType;
			o.path = path;
			return o;
		}
	}
}