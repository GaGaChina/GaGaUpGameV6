package cn.wjj.upgame.data
{
	import flash.utils.ByteArray;
	/**
	 * 英雄技能表
	 */
	public class HeroSkillModel
	{
		/** 索引字段 **/
		internal static var __keyList:Array = ["HeroID"];
		/** [默认:0]英雄关系标识ID **/
		public function get HeroID():uint {
			if (__info.hasOwnProperty("HeroID")) return __info["HeroID"];
			return 0;
		}
		/** [默认:0]技能1-关系标识 **/
		public function get Skill1():uint {
			if (__info.hasOwnProperty("Skill1")) return __info["Skill1"];
			return 0;
		}
		/** [默认:0]技能2-关系标识 **/
		public function get Skill2():uint {
			if (__info.hasOwnProperty("Skill2")) return __info["Skill2"];
			return 0;
		}
		/** [默认:0]技能3-关系标识 **/
		public function get Skill3():uint {
			if (__info.hasOwnProperty("Skill3")) return __info["Skill3"];
			return 0;
		}
		/** [默认:0]技能4-关系标识 **/
		public function get Skill4():uint {
			if (__info.hasOwnProperty("Skill4")) return __info["Skill4"];
			return 0;
		}
		//--------------------------------------------------------------------------------------
		/** 对象引用的数据对象 **/
		private var __info:Object;
		
		/**
		 * 英雄技能表
		 * @param	baseInfo			传入null逻辑上会有错误
		 */
		public function HeroSkillModel(baseInfo:Object):void
		{
			__info = baseInfo;
		}
		/**
		 * 英雄技能表
		 * @param	baseInfo			传入null逻辑上会有错误
		 * @return
		 */
		public static function getThis(baseInfo:Object ):HeroSkillModel
		{
			return new HeroSkillModel(baseInfo);
		}
		
		/**
		 * 获取值,当缺少自动赋初始值
		 * @param	n
		 * @return
		 */
		private function __modelGet(n:String):*
		{
			if (__info.hasOwnProperty(n))
			{
				return __info[n];
			}
			return null;
		}
	}
}
