package cn.wjj.upgame.common 
{
	/**
	 * 图层的类型
	 * 
	 * 0-255
	 * 
	 * @author GaGa
	 */
	public class UpInfoLayerType 
	{
		
		/** 无图层类型 **/
		public static const no:uint = 255;
		/** 空中部队伤害数字图层 **/
		public static const flyHarm:uint = 202;
		/** 空中部队头顶特效图层 **/
		public static const flyEffectTop:uint = 201;
		/** 空中部队 **/
		public static const fly:uint = 200;
		/** 空中部队脚下特效图层 **/
		public static const flyEffectEnd:uint = 199;
		/** 地面部队伤害数字图层 **/
		public static const groundHarm:uint = 102;
		/** 地面部队头顶特效图层 **/
		public static const groundEffectTop:uint = 101;
		/** 地面部队 **/
		public static const ground:uint = 100;
		/** 地面部队的有立体感的特效层级 **/
		public static const groundEffect3D:uint = 99;
		/** 地面部队掉落装饰物 **/
		public static const ground3DItem:uint = 98;
		/** 地面部队脚下特效 **/
		public static const groundEffectEnd:uint = 97;
		/** 地板特效图层,地板燃烧 **/
		public static const floorEffect:uint = 50;
		
		public function UpInfoLayerType() { }
	}
}