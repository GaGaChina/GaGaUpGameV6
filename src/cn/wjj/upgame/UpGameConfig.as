package cn.wjj.upgame 
{
	import flash.display.BitmapData;
	/**
	 * 战斗的配置
	 * @author GaGa
	 */
	public class UpGameConfig 
	{
		
		/** 游戏中能量的最大数量 **/
		public static var energyMax:Number = 10;
		/** 起始的费数量 **/
		public static var energyStart:int = 5;
		/** 下一张卡可以使用的时间 **/
		public static var cardDownTime:int = 1000;
		
		/** 英雄星级提升特效 **/
		public static var uiStarUp:String = "assets/effect/skill/900122.u2";
		/** 英雄每多一颗星奉献的经验比例 **/
		public static var expStarUp:Number = 0.2;
		/** 最大星级的数量 **/
		public static var expStarMax:int = 5;
		
		/** 对战最长时间长度 **/
		public static var timeAttackNormal:uint = 240000;
		/** 普通模式的计时和真实时间的比例值 **/
		public static var timeEnergyScaleNormal:Number = 2.8;
		/** 过多少时间后开始启用加速时间 **/
		public static var timeAttackSpeedUp:uint = 120000;
		/** 普通模式的计时和真实时间的比例值 **/
		public static var timeEnergyScaleSpeedUp:Number = 1.4;
		/** 对战多久时间开始决斗阶段 **/
		public static var timeAttackDecisive:uint = 180000;
		
		/** 消息延长的时间 **/
		public static var timeInfoSend:uint = 1500;
		/** 消息延长的时间 **/
		public static var timeHeartSend:uint = 1200;
		
		/** 图片资源 : 能量条背景 **/
		public static var imgDataEnergyBg:BitmapData;
		
		/** 多语言字体 : 费的字体 **/
		public static var fontEnergy:String;
		
		public function UpGameConfig() { }
	}
}