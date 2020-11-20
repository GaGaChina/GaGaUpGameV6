package cn.wjj.upgame.common
{
	/**
	 * 录像用的
	 * 
	 * 
	 * id:serverId
	 * x:int 坐标
	 * y:int 坐标
	 * lock:Boolean 是否锁定
	 * 
	 * target:serverId(uint) 目标
	 * index:int 
	 * 
	 * @author GaGa
	 */
	public class RecordType
	{

		/** 释放卡牌 {} **/
		public static const ReleaseCard:int = 1;
		/** 选中卡牌 {} **/
		public static const SelectCard:int = 2;
		/** 修改卡牌 {} **/
		public static const ChangeCard:int = 3;
		/** 修改卡牌 {} **/
		public static const ChangeEnergyScale:int = 4;
		
		
		
		
		/** 移动 {id:xxxx, x:1111, y:1111, lock:false} **/
		public static const MovePoint:int = 11;
		/** 移动 {id:xxxx} **/
		public static const MoveStop:int = 12;
		/** 选择目标 {id:xxxx, target:xxxx} **/
		public static const SelectTarget:int = 13;
		/** 重新选择离身边最近目标 {id:xxxx, target:xxxx} **/
		public static const FindHitRole:int = 14;
		/** 释放技能 {id:xxxx, index:1} **/
		public static const ReleaseSkill:int = 15;
		/** 清除仇恨值 {id:xxxx} **/
		public static const ClearHatred:int = 16;
		/** 直接移动到位置 {id:xxxx, x:1111, y:1111} **/
		public static const ChangePoint:int = 17;

		
		
		
		/** 设置随机数 **/
		public static const InitRandom:int = 101;
		/** 设置随机数 **/
		public static const InitMode:int = 102;
		/** 设置随机数 **/
		public static const InitEnergy:int = 103;
		/** 设置开始就在场景上的人物 **/
		public static const InitRoleCardPos:int = 104;
		/** 设置开始就在场景上的人物 **/
		public static const InitRoleCardXY:int = 105;
		/** 设置开始初始化的卡牌 **/
		public static const InitCardList:int = 106;
		/** 设置开始初始化的Camp **/
		public static const InitSetCampPlayer:int = 107;
		/** 设置开始初始化默认玩家 **/
		public static const InitPlayer:int = 108;
		/** 修改一个阵营的能量值 **/
		public static const InitChangeEnergy:int = 109;
		
		public function RecordType() { }
	}

}