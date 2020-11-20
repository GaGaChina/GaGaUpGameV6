package cn.wjj.upgame.tools 
{
	/**
	 * 角度转弧度
	 * @author GaGa
	 */
	public class MathAngle 
	{
		public function MathAngle() { }
		
		/**
		 * 角度弧度转换
		 * @param	deg
		 * @return
		 */
		public static function deg2rad(deg:Number):Number
		{
			return deg / 180 * Math.PI;
		}
	}
}