package cn.wjj.upgame.common
{
	/**
	 * 地图上的类型的基类
	 * 
	 * 
	 * @author GaGa
	 */
	public class EDType 
	{
		/** 场景对象的基本类型 **/
		public static const base:int = 0;
		/** 场景对象的球类物品 **/
		public static const bullet:int = 1;
		/** 角色的类型,这种类型有自己的方向,方向有方向的类型,这里不做处理 **/
		public static const role:int = 3;
		/** 技能类型,丢出去的技能 **/
		public static const skill:int = 4;
		/** Buff技能击中后在人物身上的效果 **/
		public static const skillBuff:int = 5;
		/** 在地上燃烧的对象 **/
		public static const skillContinue:int = 6;
		/** 只是显示对象的对象 **/
		public static const display:int = 7;
		
		public function EDType() { }
	}

}