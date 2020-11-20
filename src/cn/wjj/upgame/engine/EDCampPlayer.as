package cn.wjj.upgame.engine 
{
	import cn.wjj.upgame.UpGameConfig;
	
	/**
	 * 用户玩家的数据
	 * @author GaGa
	 */
	public class EDCampPlayer 
	{
		/** 玩家阵营 **/
		public var camp:EDCamp;
		/** 是否启用玩家数据 **/
		public var using:Boolean = false;
		/** 列表中第几个 **/
		public var index:int = 0;
		/** 玩家用户ID **/
		public var playerId:int = 0;
		
		/** 现在可用的能量大小 **/
		public var energyValue:int = UpGameConfig.energyStart;
		/** 现在能量大小带小数点 **/
		public var energyTemp:Number = UpGameConfig.energyStart;
		/** 现在放出去的卡牌但是没有落地的,提前扣费先 **/
		public var energyUse:int = 0;
		
		/** 卡牌的ID **/
		public var card1:int = 0;
		/** 卡牌已经使用, 在接下来本时间之前都不能被使用 **/
		public var card1TimeUse:int = 0;
		/** 卡牌的准备好的时间, 新卡下来有CD **/
		public var card1Time:int = 0;
		/** 卡牌的ID **/
		public var card2:int = 0;
		/** 卡牌已经使用并有使用时间 **/
		public var card2TimeUse:int = 0;
		/** 卡牌的准备好的时间 **/
		public var card2Time:int = 0;
		/** 卡牌的ID **/
		public var card3:int = 0;
		/** 卡牌已经使用并有使用时间 **/
		public var card3TimeUse:int = 0;
		/** 卡牌的准备好的时间 **/
		public var card3Time:int = 0;
		/** 卡牌的ID **/
		public var card4:int = 0;
		/** 卡牌已经使用并有使用时间 **/
		public var card4TimeUse:int = 0;
		/** 卡牌的准备好的时间 **/
		public var card4Time:int = 0;
		/** 卡牌下一张ID **/
		public var cardNext:int = 0;
		/** 本玩家的英雄 **/
		public var hero:EDRole;
		
		public function EDCampPlayer(camp:EDCamp) 
		{
			this.camp = camp;
		}
		
		/** 清理,不回收 **/
		public function claer():void
		{
			energyUse = 0;
			energyValue = UpGameConfig.energyStart;
			energyTemp = UpGameConfig.energyStart;
		}
		
		/** 移除,清理,并回收 **/
		public function dispose():void
		{
			claer();
			camp = null;
			hero = null;
		}
	}

}