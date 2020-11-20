package cn.wjj.upgame.render 
{
	import cn.wjj.gagaframe.client.speedfact.SpeedLib;
	
	/**
	 * 可以直接修改显示对象的参数或者是调用显示对象的方法
	 * 
	 * @author GaGa
	 */
	public class RenderInfoProperty
	{
		/** 对象池 **/
		private static var __f:SpeedLib = new SpeedLib(100);
		/** 对象池强引用的最大数量 **/
		static public function get __m():uint {return __f.length;}
		/** 对象池强引用的最大数量 **/
		static public function set __m(value:uint):void {__f.length = value;}
		
		public function RenderInfoProperty() { }
		
		/** 初始化 Shape **/
		public static function instance():RenderInfoProperty
		{
			var o:RenderInfoProperty = __f.instance() as RenderInfoProperty;
			if (o) return o;
			return new RenderInfoProperty();
		}
		
		/** 摧毁这个属性值列表 **/
		public function dispose():void
		{
			for (var name:String in this.property) 
			{
				delete this.property[name];
			}
			this.length = 0;
			__f.recover(this);
		}
		
		/** 数据变化的部分 **/
		public var property:Object = new Object();
		/** 属性的变化量 **/
		public var length:int = 0;
		
		/**
		 * 对显示对象修正某一项属性值,或执行某一个函数
		 * DisplayObject : x, y, rotation, alpha
		 * 
		 * @param	name
		 * @param	indexEnd	是否把设置内容放最后
		 * @param	...args		支持多个参数,属性只能用一个参数
		 */
		public function setProperty(name:String, value:*):void
		{
			if (!property.hasOwnProperty(name)) length++;
			property[name] = value;
		}
		
		/** 对一个对象应用属性值,并摧毁 **/
		public static function useThis(object:Object, property:RenderInfoProperty):void
		{
			if (property.length)
			{
				for (var name:String in property.property) 
				{
					object[name] = property.property[name];
					/*
					if (object[name] is Function)
					{
						object[name].apply(null, property.property[name]);
					}
					else
					{
						object[name] = property.property[name][0];
					}
					*/
				}
			}
		}
	}
}