package cn.wjj.upgame.net 
{
	import cn.wjj.upgame.common.IUpNet;
	import cn.wjj.upgame.render.DisplayEDLoading;
	import cn.wjj.upgame.UpGame;
	import cn.wjj.upgame.UpGameConfig;
	
	/**
	 * 联网后的数据传输
	 * 联网后部分数据从这里发送出去
	 * 
	 * @author GaGa
	 */
	public class UpNet
	{
		
		/** 父引用 **/
		public var u:UpGame;
		/** 日志记录器 **/
		public var net:IUpNet;
		/** 是否开记录 **/
		private var start:Boolean = false;
		
		/** 监听的卡牌显示对象 **/
		private var listLoading:Vector.<DisplayEDLoading> = new Vector.<DisplayEDLoading>();
		
		public function UpNet(u:UpGame)
		{
			this.u = u;
		}
		
		/**
		 * 设置网络接口层
		 * @param	net
		 */
		public function setIUpNet(net:IUpNet):void
		{
			if (net)
			{
				start = true;
			}
			else
			{
				start = false;
			}
			this.net = net;
		}
		
		/**
		 * 释放卡牌
		 * @param	id
		 * @param	type	2释放卡牌,1释放英雄卡牌
		 * @param	time	预计放下的时间
		 * @param	tileX
		 * @param	tileY
		 */
		public function sendReleaseCard(id:int, type:int, time:int, tileX:int, tileY:int):void
		{
			if (start)
			{
				net.sendReleaseCard(id, type, time, tileX, tileY);
			}
		}
		
		/**
		 * 增加费,能量值
		 * @param	id			释放者的ID
		 * @param	camp		阵营
		 * @param	time		增加的时间点
		 * @param	energy		增加的数量
		 */
		public function sendEnergy(id:int, camp:int, time:uint, energy:int):void
		{
			if (start)
			{
				net.sendEnergy(id, camp, time, energy);
			}
		}
		
		/**
		 * 服务器获取卡牌ID
		 * @param	cardId		释放的卡牌ID
		 * @param	playerId
		 * @param	time		多少时间后释放时间
		 * @param	timeGame
		 * @param	next		下一张卡ID(替补卡牌ID)
		 * @param	tileX
		 * @param	tileY
		 * @param	delEnergy
		 */
		public function getReleaseCard(cardId:uint, playerId:int, time:uint, timeGame:int, next:uint, tileX:int, tileY:int, delEnergy:Boolean):void
		{
			for each (var item:DisplayEDLoading in listLoading) 
			{
				if (item.id == cardId)
				{
					item.infoComplete(time);
					break;
				}
			}
			//u.engine.time.timeGame + time - UpGameConfig.timeInfoSend - u.engine.time.timeGame;
			//(           卡牌放下的时间   ) - 放置卡牌的时间  
			var changeTime:int = time - UpGameConfig.timeInfoSend;
			u.record.changeCard(cardId, playerId, item.camp, (time - UpGameConfig.timeInfoSend), next, true);
			u.record.releaseCard(cardId, playerId, item.camp, 1, tileX, tileY, time, delEnergy);
		}
		
		/**
		 * 战斗结束
		 */
		public function gameOver():void
		{
			if (start)
			{
				net.gameOver();
			}
		}
		
		public function pushLoading(loading:DisplayEDLoading):void
		{
			if (start)
			{
				listLoading.push(loading);
			}
		}
		
		/**
		 * 清理全部的战斗
		 */
		public function gameReSet():void
		{
			if (start)
			{
				
			}
		}
		
		/** 摧毁对象 **/
		public function dispose():void 
		{
			u = null;
			net = null;
			start = false;
			listLoading.length = 0;
		}
	}
}