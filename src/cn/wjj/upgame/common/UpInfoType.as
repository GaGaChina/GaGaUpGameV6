package cn.wjj.upgame.common
{
	/**
	 * 数据类型的枚举
	 * 
	 * 
	 * @version 1.0.0
	 * @author GaGa <wjjhappy@gmail.com>
	 * @copy 王加静 <www.5ga.cn>
	 */
	public class UpInfoType 
	{
		
		/** 基类类型 **/
		public static const base:uint = 0;
		
		/** 主信息 **/
		public static const info:uint = 1;
		/** 场景属性 **/
		public static const stageInfo:uint = 2;
		/** 图层信息 **/
		public static const layer:uint = 3;
		/** 图层库 **/
		public static const layerLib:uint = 4;
		/** 画出来方格 **/
		public static const grid:uint = 5;
		/** 画出来方格 **/
		public static const astar:uint = 6;
		/** 地图数据 **/
		public static const map:uint = 7;
		/** 图像数据 **/
		public static const display:uint = 8;
		
		/** 碰撞范围信息 **/
		public static const collide:uint = 600;
		/** 碰撞范围 矩形 **/
		public static const collideRect:uint = 601;
		/** 碰撞范围 圆 **/
		public static const collideCircle:uint = 602;
		
		public function UpInfoType() { }
	}
}