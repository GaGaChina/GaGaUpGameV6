package cn.wjj.upgame.data
{
	import flash.utils.ByteArray;
	/**
	 * 卡牌信息表
	 */
	public class CardInfoModel
	{
		/** 索引字段 **/
		internal static var __keyList:Array = ["card_id"];
		/** [默认:0]卡牌id **/
		public function get card_id():uint {
			if (__info.hasOwnProperty("card_id")) return __info["card_id"];
			return 0;
		}
		/** [默认:0]卡牌名称id **/
		public function get Cname():uint {
			if (__info.hasOwnProperty("Cname")) return __info["Cname"];
			return 0;
		}
		/** [默认:0]卡牌描述id **/
		public function get Cdescribe():uint {
			if (__info.hasOwnProperty("Cdescribe")) return __info["Cdescribe"];
			return 0;
		}
		/** [默认:0]图片资源id **/
		public function get CImage():uint {
			if (__info.hasOwnProperty("CImage")) return __info["CImage"];
			return 0;
		}
		/** [默认:0]卡牌类型:1.部队 2.法术 3.建筑 **/
		public function get CardType():uint {
			if (__info.hasOwnProperty("CardType")) return __info["CardType"];
			return 0;
		}
		/** [默认:0]卡牌的等级 **/
		public function get CardLevel():uint {
			if (__info.hasOwnProperty("CardLevel")) return __info["CardLevel"];
			return 0;
		}
		/** [默认:0]召唤角色id **/
		public function get SummonCharacter():uint {
			if (__info.hasOwnProperty("SummonCharacter")) return __info["SummonCharacter"];
			return 0;
		}
		/** [默认:0]召唤数量 **/
		public function get SummonNumber():uint {
			if (__info.hasOwnProperty("SummonNumber")) return __info["SummonNumber"];
			return 0;
		}
		/** [默认:0]召唤技能ID **/
		public function get SpellSkill():uint {
			if (__info.hasOwnProperty("SpellSkill")) return __info["SpellSkill"];
			return 0;
		}
		/** [默认:0]解锁战场 **/
		public function get UnlockArena():uint {
			if (__info.hasOwnProperty("UnlockArena")) return __info["UnlockArena"];
			return 0;
		}
		/** [默认:0]品质 **/
		public function get Cquality():uint {
			if (__info.hasOwnProperty("Cquality")) return __info["Cquality"];
			return 0;
		}
		/** [默认:0]卡牌的使用费用 **/
		public function get ManaCost():uint {
			if (__info.hasOwnProperty("ManaCost")) return __info["ManaCost"];
			return 0;
		}
		/** [默认:0]经验类别 **/
		public function get Cexpclass():uint {
			if (__info.hasOwnProperty("Cexpclass")) return __info["Cexpclass"];
			return 0;
		}
		/** [默认:0]卡牌是否可升级 **/
		public function get LevelUp():uint {
			if (__info.hasOwnProperty("LevelUp")) return __info["LevelUp"];
			return 0;
		}
		/** [默认:0]关系类型标识,卡牌是否是同一张卡 **/
		public function get Crelationship():uint {
			if (__info.hasOwnProperty("Crelationship")) return __info["Crelationship"];
			return 0;
		}
		/** [默认:0]解锁前的图标类型，1为正常，2为问号 **/
		public function get LockedImage():uint {
			if (__info.hasOwnProperty("LockedImage")) return __info["LockedImage"];
			return 0;
		}
		//--------------------------------------------------------------------------------------
		/** 对象引用的数据对象 **/
		private var __info:Object;
		
		/**
		 * 卡牌信息表
		 * @param	baseInfo			传入null逻辑上会有错误
		 */
		public function CardInfoModel(baseInfo:Object):void
		{
			__info = baseInfo;
		}
		/**
		 * 卡牌信息表
		 * @param	baseInfo			传入null逻辑上会有错误
		 * @return
		 */
		public static function getThis(baseInfo:Object ):CardInfoModel
		{
			return new CardInfoModel(baseInfo);
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
