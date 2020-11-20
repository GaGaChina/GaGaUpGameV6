package cn.wjj.upgame.common 
{
	/**
	 * 震动对象的类型
	 * 
	 * @author GaGa
	 */
	public class ShockType 
	{
		/** 全地图震动 **/
		public static const no:uint = 0;
		/** 全地图震动 **/
		public static const map:uint = 1;
		/** 地图内的层 **/
		public static const child:uint = 2;
		/** 层和地图一起震 **/
		public static const mapAddChild:uint = 3;
		
		public function ShockType() 
		{
			
		}
		
	}

}