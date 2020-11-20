package cn.wjj.upgame.common 
{
	import cn.wjj.upgame.engine.EDBase;
	import cn.wjj.upgame.engine.EDRole;
	import cn.wjj.upgame.engine.EDSkillBuff;
	
	/**
	 * 战报记录接口
	 * 
	 * @author GaGa
	 */
	public interface IUpReport
	{
		/**
		 * 已经命中敌人
		 * @param	reportId		记录的ID排序
		 * @param	attackID		攻击者ID
		 * @param	attackCamp		攻击者阵营
		 * @param	attackIdx		攻击者的序号
		 * @param	attackCall		攻击者是否召唤
		 * @param	reportX			攻击发起者或子弹对象(坐标)
		 * @param	reportY			攻击发起者或子弹对象(坐标)
		 * @param	target			目标
		 * @param	skillId			主动技能ID
		 * @param	actionId		动作技能ID
		 * @param	actionSubId		动作技能子动作ID
		 * @param	effectId		效果表ID
		 * @param	hp				血的变化
		 * @param	crit			爆击
		 * @param	die				是否死亡
		 */
		function hit(reportId:uint, attackID:uint, attackCamp:int, attackIdx:int, attackCall:Boolean, reportX:int, reportY:int, target:EDRole, skillId:uint, actionId:uint, actionSubId:uint, effectId:uint, hp:int, crit:Boolean, die:Boolean = false):void;
		
		/**
		 * 闪避
		 * @param	reportId		记录的ID排序
		 * @param	attackID		攻击者ID
		 * @param	attackCamp		攻击者阵营
		 * @param	attackIdx		攻击者的序号
		 * @param	attackCall		攻击者是否召唤
		 * @param	reportX			攻击发起者或子弹对象(坐标)
		 * @param	reportY			攻击发起者或子弹对象(坐标)
		 * @param	target			目标
		 * @param	skillId			主动技能ID
		 * @param	actionId		动作技能ID
		 * @param	actionSubId		动作技能子动作ID
		 * @param	effectId		效果表ID
		 */
		function miss(reportId:uint, attackID:uint, attackCamp:int, attackIdx:int, attackCall:Boolean, reportX:int, reportY:int, target:EDRole, skillId:uint, actionId:uint, actionSubId:uint, effectId:uint):void;
		
		/**
		 * 添加BUFF
		 * @param	reportId		记录的ID排序
		 * @param	attackID		攻击者ID
		 * @param	attackCamp		攻击者阵营
		 * @param	attackIdx		攻击者的序号
		 * @param	attackCall		攻击者是否召唤
		 * @param	reportX			攻击发起者或子弹对象(坐标)
		 * @param	reportY			攻击发起者或子弹对象(坐标)
		 * @param	target			目标
		 * @param	skillId			主动技能ID
		 * @param	actionId		动作技能ID
		 * @param	actionSubId		动作技能子动作ID
		 * @param	effectId		效果表ID
		 * @param	addbuff			添加buff的ID
		 */
		function addBuff(reportId:uint, attackID:uint, attackCamp:int, attackIdx:int, attackCall:Boolean, reportX:int, reportY:int, target:EDRole, skillId:uint, actionId:uint, actionSubId:uint, effectId:uint, addbuff:uint):void;
		
		/**
		 * 删除BUFF
		 * @param	reportId		记录的ID排序
		 * @param	attackID		攻击者ID
		 * @param	attackCamp		攻击者阵营
		 * @param	attackIdx		攻击者的序号
		 * @param	attackCall		攻击者是否召唤
		 * @param	reportX			攻击发起者或子弹对象(坐标)
		 * @param	reportY			攻击发起者或子弹对象(坐标)
		 * @param	target			目标
		 * @param	skillId			主动技能ID
		 * @param	actionId		动作技能ID
		 * @param	actionSubId		动作技能子动作ID
		 * @param	effectId		效果表ID
		 * @param	removebuff		移除buff的ID
		 */
		function removeBuff(reportId:uint, attackID:uint, attackCamp:int, attackIdx:int, attackCall:Boolean, reportX:int, reportY:int, target:EDRole, skillId:uint, actionId:uint, actionSubId:uint, effectId:uint, removebuff:uint):void;
		
		/**
		 * 召唤ID
		 * @param	reportId		记录的ID排序
		 * @param	attackID		召唤者ID
		 * @param	attackCamp		召唤者阵营
		 * @param	attackIdx		攻击者的序号
		 * @param	attackCall		攻击者是否召唤
		 * @param	reportX			攻击发起者或子弹对象(坐标)
		 * @param	reportY			攻击发起者或子弹对象(坐标)
		 * @param	target			目标
		 * @param	skillId			主动技能ID
		 * @param	actionId		动作技能ID
		 * @param	actionSubId		动作技能子动作ID
		 * @param	effectId		效果表ID
		 * @param	id				召唤怪物ID
		 */
		function callMonster(reportId:uint, attackID:uint, attackCamp:int, attackIdx:int, attackCall:Boolean, reportX:int, reportY:int, target:EDRole, skillId:uint, actionId:uint, actionSubId:uint, effectId:uint, id:uint):void;
		
		/**
		 * 召唤怪物消失,因为时间到时间到了
		 * @param	attackID		替换对象的ID
		 * @param	attackCamp		替换对象的阵营
		 * @param	attackIdx		攻击者的序号
		 * @param	attackCall		攻击者是否召唤
		 * @param	reportX			替补出现位置
		 * @param	reportY			替补出现位置
		 * @param	target			替补
		 * @param	id				ID
		 */
		function removeMonster(attackID:uint, attackCamp:int, attackIdx:int, attackCall:Boolean, reportX:int, reportY:int, target:EDRole, id:uint):void;
		
		/**
		 * 替补出场
		 * @param	attackID		替换对象的ID
		 * @param	attackCamp		替换对象的阵营
		 * @param	attackIdx		攻击者的序号
		 * @param	attackCall		攻击者是否召唤
		 * @param	reportX			替补出现位置
		 * @param	reportY			替补出现位置
		 * @param	target			替补
		 * @param	roleId			
		 */
		function callBench(attackID:uint, attackCamp:int, attackIdx:int, attackCall:Boolean, reportX:int, reportY:int, target:EDRole, roleId:uint):void;
		
		/**
		 * 清理全部的战斗
		 */
		function gameReSet():void;
	}
}