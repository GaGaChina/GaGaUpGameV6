package cn.wjj.upgame.data
{
	import flash.utils.ByteArray;
	/**
	 * 英雄升星数据表
	 */
	public class HeroStarUpModel
	{
		/** 索引字段 **/
		internal static var __keyList:Array = ["HeroID"];
		/** [默认:0]英雄id **/
		public function get HeroID():uint {
			if (__info.hasOwnProperty("HeroID")) return __info["HeroID"];
			return 0;
		}
		/** [默认:0]星级 **/
		public function get Star():uint {
			if (__info.hasOwnProperty("Star")) return __info["Star"];
			return 0;
		}
		/** [默认:0]星级经验 **/
		public function get StarExp():uint {
			if (__info.hasOwnProperty("StarExp")) return __info["StarExp"];
			return 0;
		}
		/** [默认:0]增加HP **/
		public function get AddHP():uint {
			if (__info.hasOwnProperty("AddHP")) return __info["AddHP"];
			return 0;
		}
		/** [默认:0]增加攻击 **/
		public function get AddAttack():uint {
			if (__info.hasOwnProperty("AddAttack")) return __info["AddAttack"];
			return 0;
		}
		/** [默认:0]解锁技能 **/
		public function get UnlockSkill():uint {
			if (__info.hasOwnProperty("UnlockSkill")) return __info["UnlockSkill"];
			return 0;
		}
		//--------------------------------------------------------------------------------------
		/** 对象引用的数据对象 **/
		private var __info:Object;
		
		/**
		 * 英雄升星数据表
		 * @param	baseInfo			传入null逻辑上会有错误
		 */
		public function HeroStarUpModel(baseInfo:Object):void
		{
			__info = baseInfo;
		}
		/**
		 * 英雄升星数据表
		 * @param	baseInfo			传入null逻辑上会有错误
		 * @return
		 */
		public static function getThis(baseInfo:Object ):HeroStarUpModel
		{
			return new HeroStarUpModel(baseInfo);
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
