package cn.wjj.upgame.info 
{
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.gagaframe.client.speedfact.SByte;
	import cn.wjj.upgame.common.UpInfoType;
	
	/**
	 * 全部的数据部分
	 * 如果使用数据会导致2次翻转
	 * 
	 * 从地图上的开始点 - 开始计算
	 * 并且可以把老的数据迁移过来
	 * 如果有偏移是自己地图的偏移问题,框架不管理?
	 * 对地图的格子数据变化后,将不能实现
	 * 
	 * 
	 * @author GaGa
	 */
	public class UpInfoAStar extends UpInfoBase
	{
		
		/** (像素)偏移起始点 **/
		public var offsetX:int = 0;
		/** (像素)偏移起始点 **/
		public var offsetY:int = 0;
		/** (像素)宽度 **/
		public var width:int = 0;
		/** (像素)高度 **/
		public var height:int = 0;
		/** (像素)格子宽度 **/
		public var tileWidth:uint = 0;
		/** (像素)格子高度 **/
		public var tileHeight:uint = 0;
		/** 空白区域,4个int组成一个队列,如果在这个队列内,就将不使用A星算法,这里也使用A星的位置 **/
		/** 新的数据(横向X轴拥有的格子数量) **/
		public var xLength:uint = 0;
		/** 新的数据(纵向Y轴拥有的格子数量) **/
		public var yLength:uint = 0;
		/**  **/
		/**
		 * 二维数组记录地图数据
		 * A星类型
		 * 0 陆地天空可以通过  1, 任何情况不能通过
		 * 2 只有陆地可以通过, 3, 只有天空可以通过, 4, 只可以跳过
		 */
		public var map:Array = new Array();
		/** 怪物数据[key]Array[x,y,x1,y1,x2,y2......] {1:Array||Object} **/
		public var monster:Object;
		
		public function UpInfoAStar()
		{
			this._type = UpInfoType.astar;
			monster = new Object();
		}
		
		/** 获取这个对象的全部属性信息 **/
		override public function getByte():SByte 
		{
			var x:int, y:int;
			var b:SByte = super.getByte();
			b._w_Int16(offsetX);
			b._w_Int16(offsetY);
			b._w_Uint16(width);
			b._w_Uint16(height);
			b._w_Uint16(tileWidth);
			b._w_Uint16(tileHeight);
			//写入新的数据
			b._w_Uint16(xLength);
			b._w_Uint16(yLength);
			for (x = 0; x < xLength; x++)
			{
				for (y = 0; y < yLength; y++)
				{
					b.writeByte(map[x][y]);
				}
			}
			b.writeObject(monster);
			return b;
		}
		
		/** 读取这个内容, 返回错误信息, 0为成功 **/
		override public function setByte(b:SByte):void 
		{
			var x:int, y:int;
			var p:uint = b.position;
			try
			{
				//新的读数据方法
				offsetX = b.readShort();
				offsetY = b.readShort();
				width = b.readUnsignedShort();
				height = b.readUnsignedShort();
				tileWidth = b.readUnsignedShort();
				tileHeight = b.readUnsignedShort();
				xLength = b.readUnsignedShort();
				yLength = b.readUnsignedShort();
				map.length = 0;
				for (x = 0; x < xLength; x++) 
				{
					map[x] = g.speedFact.n_array();
					for (y = 0; y < yLength; y++) 
					{
						map[x][y] = b.readUnsignedByte();
					}
				}
				monster = b.readObject();
			}
			catch(e:Error)
			{
				g.log.pushLog(this, LogType._UserAction, "长度出现错误,可能是版本兼容问题");
				b.position = p;
				offsetX = b.readShort();
				offsetY = b.readShort();
				width = b.readUnsignedShort();
				height = b.readUnsignedShort();
				tileWidth = b.readUnsignedShort();
				tileHeight = b.readUnsignedShort();
				b.readUnsignedShort();//var tileLineNum:uint = 
				//把数据转换掉
				xLength = Math.ceil(width / tileWidth);
				yLength = Math.ceil(height / tileHeight);
				var blankRect:Vector.<int> = new Vector.<int>();
				blankRect.length = 0;
				var _length:uint = Math.ceil(width / tileWidth) * Math.ceil(height / tileHeight);
				var d:int;
				var i:int = _length;
				while (--i > -1) 
				{
					d = b.readUnsignedByte();
					blankRect.push(d);
				}
				
				//把数据转换掉
				for (x = 0; x < xLength; x++) 
				{
					map[x] = g.speedFact.n_array();
					for (y = 0; y < yLength; y++) 
					{
						map[x][y] = blankRect[y * xLength + x];
					}
				}
				monster = b.readObject();
				g.log.pushLog(this, LogType._UserAction, "数据转换成功");
			}
		}
		
		override public function dispose():void 
		{
			super.dispose();
		}
	}
}