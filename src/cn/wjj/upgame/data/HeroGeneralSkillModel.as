package cn.wjj.upgame.data
{
	import flash.utils.ByteArray;
	/**
	 * 英雄通用技能表
	 */
	public class HeroGeneralSkillModel
	{
		/** 索引字段 **/
		internal static var __keyList:Array = ["card_id"];
		/** [默认:0]卡牌ID **/
		public function get card_id():uint {
			if (__info.hasOwnProperty("card_id")) return __info["card_id"];
			return 0;
		}
		/** [默认:0]技能1CD降低值 **/
		public function get skill1_cd():uint {
			if (__info.hasOwnProperty("skill1_cd")) return __info["skill1_cd"];
			return 0;
		}
		/** [默认:0]技能2CD降低值 **/
		public function get skill2_cd():uint {
			if (__info.hasOwnProperty("skill2_cd")) return __info["skill2_cd"];
			return 0;
		}
		/** [默认:0]复活时间 **/
		public function get reborn_time():uint {
			if (__info.hasOwnProperty("reborn_time")) return __info["reborn_time"];
			return 0;
		}
		/** [默认:0]回血速度 **/
		public function get recover_speed():uint {
			if (__info.hasOwnProperty("recover_speed")) return __info["recover_speed"];
			return 0;
		}
		/** [默认:0]经验增量 **/
		public function get exp_increase():uint {
			if (__info.hasOwnProperty("exp_increase")) return __info["exp_increase"];
			return 0;
		}
		//--------------------------------------------------------------------------------------
		/** 对象引用的数据对象 **/
		private var __info:Object;
		
		/**
		 * 英雄通用技能表
		 * @param	baseInfo			传入null逻辑上会有错误
		 */
		public function HeroGeneralSkillModel(baseInfo:Object):void
		{
			__info = baseInfo;
		}
		/**
		 * 英雄通用技能表
		 * @param	baseInfo			传入null逻辑上会有错误
		 * @return
		 */
		public static function getThis(baseInfo:Object ):HeroGeneralSkillModel
		{
			return new HeroGeneralSkillModel(baseInfo);
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
