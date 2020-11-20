package cn.wjj.upgame.task 
{
	/**
	 * ...
	 * @author GaGa
	 */
	public class TaskItemType 
	{
		/** 任务列表,可以完成多个任务按顺序完成或者同时进行,全部完成 **/
		public static const List:uint = 1;
		/** 移动任务,可以设置让某任务移动到某区域完成 **/
		public static const Move:uint = 2;
		/** 杀死任务,可以设置杀死某怪物,杀死多少怪物,杀死某类型怪物,杀死某模型怪物 **/
		public static const Kill:uint = 3;
		/** 选中敌人任务,(当有敌人可以选中的时候,游戏暂停下)选中某个敌人,或选中敌人完成 **/
		public static const SelectEnemy:uint = 4;
		/** 释放技能,(当技能有目标,且可以释放技能的时候)可以设置当释放某技能完成 **/
		public static const ReleaseSkill:uint = 5;
		/** 伤害值统计,可以统计阵营的伤害量达到一定值的时候完成任务 **/
		public static const Damage:uint = 6;
		/** 治疗值统计,可以统计阵营的治疗量达到一定值的时候完成任务 **/
		public static const Treat:uint = 7;
		/** 坚持未死亡 **/
		public static const KeepNotDie:uint = 8;
		/** 合计杀死小怪,有BOSS,有小怪,我方主3个队员有目标为BOSS,引导先杀小怪 **/
		public static const MergeKillSmall:uint = 9;
		/** 打断对手技能,BOSS的第二个技能,我方用冲锋技能 **/
		public static const BreakBossSkill2:uint = 10;
		
		
		public function TaskItemType() { }
		
		
	}
}