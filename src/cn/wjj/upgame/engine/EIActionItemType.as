package cn.wjj.upgame.engine 
{
	
	/**
	 * 枚举,行为具体行为
	 * 
	 * @author GaGa
	 */
	public class EIActionItemType 
	{
		/** 创建行为 **/
		public static const create:uint = 0;
		/** 销毁行为 **/
		public static const over:int = 1;
		/** 发呆中 **/
		public static const ddd:int = 2;
		/** 移动行为 **/
		public static const move:int = 2;
		/** 选中目标 **/
		public static const selectTarget:int = 3;
		/** 释放技能 **/
		public static const skill:int = 1;
		
		public function EIActionItemType() { }
		
	}

}