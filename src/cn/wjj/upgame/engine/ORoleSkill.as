package cn.wjj.upgame.engine 
{
	/**
	 * 技能的数据
	 * @author GaGa
	 */
	public class ORoleSkill
	{
		/** 在技能表里的位置 **/
		public var index:uint = 0;
		/** 技能ID **/
		public var id:uint = 0;
		/** 技能等级 **/
		public var lv:int = 1;
		/** 技能的CD降低值 **/
		public var cd:int = 0;
		/** 技能的初始CD降低值 **/
		public var cdStart:int = 0;
		
		public function ORoleSkill() { }
	}
}