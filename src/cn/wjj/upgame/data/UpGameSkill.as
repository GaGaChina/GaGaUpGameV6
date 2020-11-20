package cn.wjj.upgame.data
{
	import flash.utils.ByteArray;
	/**
	 * UpGame技能调用表
	 */
	public class UpGameSkill
	{
		/** 索引字段 **/
		internal static var __keyList:Array = ["id"];
		/** [默认:0]技能信息链接表id **/
		public function get id():uint {
			if (__info.hasOwnProperty("id")) return __info["id"];
			return 0;
		}
		/** [默认:0]子弹Id : 如果0表示不是子弹，其他标识这个会绑定到的子弹，如果切换目标类型了就不需要子弹(比如攻击敌人同时给自己加buff此时不需要子弹) **/
		public function get bulletId():uint {
			if (__info.hasOwnProperty("bulletId")) return __info["bulletId"];
			return 0;
		}
		/** [默认:0]技能作用效果Id : 技能作用效果的id，这个效果可能是一个伤害效果，也可能会是一个持续范围型伤害，也可能会附加一个状态 **/
		public function get effectId():uint {
			if (__info.hasOwnProperty("effectId")) return __info["effectId"];
			return 0;
		}
		/** [默认:0]特效方向 : 0不使用任何角度,1跟随子弹的角度 **/
		public function get hitEffectDirec():uint {
			if (__info.hasOwnProperty("hitEffectDirec")) return __info["hitEffectDirec"];
			return 0;
		}
		//--------------------------------------------------------------------------------------
		/** 对象引用的数据对象 **/
		private var __info:Object;
		
		/**
		 * UpGame技能调用表
		 * @param	baseInfo			传入null逻辑上会有错误
		 */
		public function UpGameSkill(baseInfo:Object):void
		{
			__info = baseInfo;
		}
		/**
		 * UpGame技能调用表
		 * @param	baseInfo			传入null逻辑上会有错误
		 * @return
		 */
		public static function getThis(baseInfo:Object ):UpGameSkill
		{
			return new UpGameSkill(baseInfo);
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
