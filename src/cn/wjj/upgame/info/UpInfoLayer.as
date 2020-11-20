package cn.wjj.upgame.info
{
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.gagaframe.client.speedfact.SByte;
	import cn.wjj.upgame.common.IUpInfo;
	import cn.wjj.upgame.common.UpInfoLayerType;
	import cn.wjj.upgame.common.UpInfoType;
	
	/**
	 * 坐标点
	 * @author GaGa
	 */
	public class UpInfoLayer extends UpInfoBase 
	{
		/** 图层名称 **/
		public var name:String = "";
		/** 图层的起始坐标点 **/
		public var x:Number = 0;
		/** 图层的起始坐标点 **/
		public var y:Number = 0;
		/** 图层透明度 **/
		public var alpha:Number = 1;
		/** 图层比例 **/
		public var rotation:Number = 0;
		/** 图层比例 **/
		public var scaleX:Number = 1;
		/** 图层比例 **/
		public var scaleY:Number = 1;
		/** 比主场景移动速度快多少倍 **/
		public var speedX:Number = 0;
		/** 比主场景移动速度快多少倍 **/
		public var speedY:Number = 0;
		/** (0 到 255)是否开启层级控制, 0 不排序,1 按照坐标Y从小向大,X从小向大排序, 2安装碰撞点Y从小向大,X从小向大排序,无碰撞点放最下面  **/
		public var useIndex:uint = 0;
		/** 有人物怪物经过的时候透明度(0-100) **/
		public var autoAlpha:Number = 1;
		/** (0 到 255)发生震动的时候最大震动范围 **/
		public var shockX:uint = 0;
		/** (0 到 255)发生震动的时候最大震动范围 **/
		public var shockY:uint = 0;
		/** 和某一个其他图层一起震动 **/
		public var shockToName:String = "";
		/** 播放的时候嵌入其他图层 **/
		public var implantId:uint = UpInfoLayerType.no;
		/** 没有所属类型 **/
		public var layerType:uint = UpInfoLayerType.no;
		/** 层里的全部显示对象 **/
		public var lib:Vector.<UpInfoDisplay>;
		
		/**
		 * 层类型
		 */
		public function UpInfoLayer():void
		{
			this._type = UpInfoType.layer;
			lib = new Vector.<UpInfoDisplay>();
		}
		
		/** 获取这个对象的全部属性信息 **/
		override public function getByte():SByte 
		{
			var b:SByte = SByte.instance();
			b._w_String(name);
			b.writeInt(int(x * 1000));
			b.writeInt(int(y * 1000));
			b.writeInt(int(scaleX * 1000));
			b.writeInt(int(scaleY * 1000));
			b.writeByte(uint(alpha * 100));
			b.writeInt(int(rotation * 1000));
			b.writeInt(int(speedX * 1000));
			b.writeInt(int(speedY * 1000));
			b.writeByte(useIndex);
			b.writeByte(uint(autoAlpha * 100));
			b.writeByte(shockX);
			b.writeByte(shockY);
			b._w_String(shockToName);
			b.writeShort(lib.length);
			for each (var d:UpInfoDisplay in lib) 
			{
				b._w_CByteArray(d.getByte());
			}
			b.writeByte(layerType);
			b.writeByte(implantId);
			return b;
		}
		
		/** 读取这个内容 **/
		override public function setByte(b:SByte):void
		{
			name = b._r_String();
			x = b.readInt() / 1000;
			y = b.readInt() / 1000;
			scaleX = b.readInt() / 1000;
			scaleY = b.readInt() / 1000;
			alpha = b.readUnsignedByte() / 100;
			rotation = b.readInt() / 1000;
			speedX = b.readInt() / 1000;
			speedY = b.readInt() / 1000;
			useIndex = b.readUnsignedByte();
			autoAlpha = b.readUnsignedByte() / 100;
			shockX = b.readUnsignedByte();
			shockY = b.readUnsignedByte();
			shockToName = b._r_String();
			lib.length = 0;
			var _length:uint = b.readUnsignedShort();
			var d:UpInfoDisplay;
			var i:int = _length;
			while (--i > -1) 
			{
				d = new UpInfoDisplay();
				b.readUnsignedShort();
				d.setByte(b);
				lib.push(d);
			}
			layerType = b.readUnsignedByte();
			if (b.position < b.length)
			{
				implantId = b.readUnsignedByte();
			}
		}
		
		override public function dispose():void 
		{
			super.dispose();
			for each (var item:UpInfoDisplay in lib) 
			{
				item.dispose();
			}
			lib.length = 0;
			lib = null;
		}
		
		/** 添加一帧 **/
		public function pushDisplay(o:UpInfoDisplay):Boolean
		{
			lib.push(o);
			return true;
		}
		
		/** 添加帧到指定位置 **/
		public function pushDisplayIn(o:UpInfoDisplay, id:int):Boolean
		{
			if (id == lib.length)
			{
				lib.push(o);
				return true;
			}
			else if (id > lib.length)
			{
				g.log.pushLog(this, LogType._ErrorLog, "添加的位置超出现在帧数");
			}
			else
			{
				lib.splice(id, 0, o);
				return true;
			}
			return false;
		}
		
		/** 获取里面帧的ID号 **/
		public function getDisplayId(o:UpInfoDisplay):int
		{
			if (lib) return lib.indexOf(o);
			return -1;
		}
		
		/** 获取里面帧的ID号 **/
		public function getIdDisplay(id:int):UpInfoDisplay
		{
			if (lib && lib.length > id) return lib[id];
			return null;
		}
		
		/** 删除一帧 **/
		public function removeDisplayId(id:int):Boolean
		{
			if (lib && lib.length > id)
			{
				lib.splice(id, 1);
				return true;
			}
			return false;
		}
		
		/** 删除图层中的一帧 **/
		public function removeDisplay(o:UpInfoDisplay):Boolean
		{
			if (lib)
			{
				var id:int = lib.indexOf(o);
				if (id != -1)
				{
					return removeDisplayId(id);
				}
			}
			return false;
		}
		
		/** 克隆一个对象 **/
		override public function clone():IUpInfo 
		{
			var o:UpInfoLayer = new UpInfoLayer();
			o.name = name;
			o.x = x;
			o.y = y;
			o.scaleX = scaleX;
			o.scaleY = scaleY;
			o.rotation = rotation;
			o.alpha = alpha;
			o.speedX = speedX;
			o.speedY = speedY;
			o.useIndex = useIndex;
			o.autoAlpha = autoAlpha;
			o.shockX = shockX;
			o.shockY = shockY;
			o.shockToName = shockToName;
			//o.layerType = layerType;
			o.implantId = implantId;
			for each (var d:UpInfoDisplay in lib) 
			{
				o.lib.push(d.clone());
			}
			return o;
		}
	}
}