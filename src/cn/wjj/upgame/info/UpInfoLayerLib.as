package cn.wjj.upgame.info
{
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.gagaframe.client.speedfact.SByte;
	import cn.wjj.upgame.common.IUpInfo;
	import cn.wjj.upgame.common.UpInfoType;
	
	/**
	 * 坐标点
	 * @author GaGa
	 */
	public class UpInfoLayerLib extends UpInfoBase 
	{
		/** 现在最大的图层ID **/
		private var _length:int = 0;
		/** 存放名称对应的图层信息 **/
		private var libName:Object = new Object();
		/** [禁止直接操作]将全部的图层都保存起来,index小的在下面 **/
		public var lib:Vector.<UpInfoLayer>;
		
		public function UpInfoLayerLib():void
		{
			this._type = UpInfoType.layerLib;
			lib = new Vector.<UpInfoLayer>();
		}
		
		/**
		 * 获取某一个层级的图层信息
		 * @param	index
		 * @return
		 */
		public function getIdLayer(index:int):UpInfoLayer
		{
			if (lib && lib.length > index && index > -1)
			{
				return lib[index];
			}
			return null;
		}
		
		/**
		 * 获取某一层的ID号, -1就是没有
		 * @param	info
		 * @return
		 */
		public function getLayerId(info:UpInfoLayer):int
		{
			return lib.indexOf(info);
		}
		
		/**
		 * 删除选中的图层
		 * @param	info
		 */
		public function removeLayer(info:UpInfoLayer):Boolean
		{
			var index:int = lib.indexOf(info);
			if (index != -1)
			{
				_length--;
				lib.splice(index, 1);
				libName[info.name] = null;
				delete libName[info.name];
				return true;
			}
			return false;
		}
		
		/**
		 * 获取某一个名称的图层ID
		 * @param	index
		 * @return
		 */
		public function getLayerName(name:String):UpInfoLayer
		{
			return libName[name];
		}
		
		/**
		 * 添加一个图层信息
		 * @param	info
		 */
		public function addLayer(info:UpInfoLayer):Boolean
		{
			if (lib.indexOf(info) != -1)
			{
				g.log.pushLog(this, LogType._ErrorLog, "图层已经存在");
			}
			else if (info.name == "")
			{
				g.log.pushLog(this, LogType._ErrorLog, "图层缺少名称");
			}
			else
			{
				if (libName[info.name] == null)
				{
					libName[info.name] = info;
					lib.push(info);
					_length++;
					return true;
				}
				else
				{
					g.log.pushLog(this, LogType._ErrorLog, "图层重名");
				}
			}
			return false;
		}
		
		/**
		 * 把a和b的位置互换
		 * @param	a
		 * @param	b
		 */
		public function swap(a:UpInfoLayer, b:UpInfoLayer):void
		{
			var aIndex:int = getLayerId(a);
			var bIndex:int = getLayerId(b);
			if (aIndex == -1 )
			{
				g.log.pushLog(this, LogType._ErrorLog, "A没有在列表中");
			}
			else if(bIndex == -1)
			{
				g.log.pushLog(this, LogType._ErrorLog, "B没有在列表中");
			}
			else
			{
				if (aIndex > bIndex)
				{
					var tempIndex:int = aIndex;
					aIndex = bIndex;
					bIndex = tempIndex;
					var tempLayer:UpInfoLayer = a;
					a = b;
					b = tempLayer;
				}
				//把大的删除
				//把小的删除
				lib.splice(bIndex, 1);
				lib.splice(aIndex, 1);
				//把大的放小的位置
				lib.splice(aIndex, 0, b);
				//把小的放大的位置
				lib.splice(bIndex, 0, a);
			}
		}
		
		/**
		 * 把a和b的位置互换
		 * @param	a
		 * @param	b
		 */
		public function swapId(aIndex:int, bIndex:int):void
		{
			var a:UpInfoLayer = getIdLayer(aIndex);
			var b:UpInfoLayer = getIdLayer(bIndex);
			if (a == null )
			{
				g.log.pushLog(this, LogType._ErrorLog, "A没有在列表中");
			}
			else if(b == null)
			{
				g.log.pushLog(this, LogType._ErrorLog, "B没有在列表中");
			}
			else
			{
				if (aIndex > bIndex)
				{
					var tempIndex:int = aIndex;
					aIndex = bIndex;
					bIndex = tempIndex;
					var tempLayer:UpInfoLayer = a;
					a = b;
					b = tempLayer;
				}
				//把大的删除
				//把小的删除
				lib.splice(bIndex, 1);
				lib.splice(aIndex, 1);
				//把大的放小的位置
				lib.splice(aIndex, 0, b);
				//把小的放大的位置
				lib.splice(bIndex, 0, a);
			}
		}
		
		/** 获取这个对象的全部属性信息 **/
		override public function getByte():SByte 
		{
			var b:SByte = SByte.instance();
			b._w_Uint16(_length);
			for each (var item:UpInfoLayer in lib) 
			{
				b._w_CByteArray(item.getByte());
			}
			return b;
		}
		
		/** 读取这个内容 **/
		override public function setByte(b:SByte):void
		{
			lib.length = 0;
			libName = new Object();
			_length = b.readUnsignedShort();
			var i:int = _length;
			var l:UpInfoLayer;
			while (--i > -1) 
			{
				l = new UpInfoLayer();
				b.readUnsignedShort()
				l.setByte(b);
				lib.push(l);
				libName[l.name] = l;
			}
		}
		
		/** 现在最大的图层ID **/
		public function get length():uint { return _length; }
		
		override public function dispose():void 
		{
			super.dispose();
			for each (var item:UpInfoLayer in lib) 
			{
				item.dispose();
			}
			lib.length = 0;
			lib = null;
			libName = null;
		}
		
		/** 克隆一个对象 **/
		override public function clone():IUpInfo 
		{
			var o:UpInfoLayerLib = new UpInfoLayerLib();
			o._length = _length;
			var i:int = _length;
			var copy:UpInfoLayer;
			for each (var item:UpInfoLayer in lib) 
			{
				copy = item.clone() as UpInfoLayer;
				o.lib.push(copy);
				o.libName[copy.name] = copy;
			}
			return o;
		}
	}
}