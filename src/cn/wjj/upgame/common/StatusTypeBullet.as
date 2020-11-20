package cn.wjj.upgame.common 
{
	/**
	 * 子弹状态
	 * 
	 * @author GaGa
	 */
	public class StatusTypeBullet 
	{
		/** 还未初始化 **/
		public static const no:int = 0;
		
		/** 飞行 **/
		public static const fly:int = 1;
		
		/** 超出射程 **/
		public static const outRange:int = 2;
		
		/** 死亡 **/
		public static const die:int = 3;
		
		public function StatusTypeBullet() { }
		
	}

}