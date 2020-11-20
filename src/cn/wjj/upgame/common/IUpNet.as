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
	public interface IUpNet
	{
		/**
		 * 释放卡牌
		 * @param	id
		 * @param	type	2释放卡牌,1释放英雄卡牌
		 * @param	time	预计放下的时间
		 * @param	posX
		 * @param	posY
		 */
		function sendReleaseCard(id:int, type:int, time:int, posX:int, posY:int):void;
		
		/**
		 * 增加费,能量值
		 * @param	id			释放者的ID
		 * @param	camp		阵营
		 * @param	time		增加的时间点
		 * @param	energy		增加的数量
		 */
		function sendEnergy(id:int, camp:int, time:uint, energy:int):void;
		
		/**
		 * 战斗结束
		 */
		function gameOver():void;
	}
}