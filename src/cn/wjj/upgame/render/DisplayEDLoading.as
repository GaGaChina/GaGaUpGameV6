package cn.wjj.upgame.render 
{
	import cn.wjj.display.ui2d.IU2Base;
	import cn.wjj.g;
	import cn.wjj.upgame.UpGame;
	import cn.wjj.upgame.UpGameConfig;
	
	/**
	 * 小圈,放兵后的倒计时
	 * 
	 * 当刚放哪里的时候有个网络传递的时间,这个时间用来打开倒计时的圈圈
	 * 如果时间到了没有倒计时成功,就马上返回费,
	 * 
	 * @author GaGa
	 */
	public class DisplayEDLoading extends DisplayEDCardBase
	{
		/** 最后落下的时间,如果失败就要撤回 **/
		private var timeComplete:uint;
		/** 小loader **/
		private var miniLoad:DisplayEDTimeLoad;
		/** 数据已经获取到 **/
		private var infoOk:Boolean = false;
		
		/**
		 * 设置对象的形象
		 * @param	u		
		 * @param	id		
		 * @param	camp	阵营
		 * @param	posX	AStar方格的坐标
		 * @param	posY	AStar方格的坐标
		 */
		public function DisplayEDLoading(u:UpGame, id:int, camp:int, tileX:int, tileY:int)
		{
			super(u, id, camp, tileX, tileY);
			timeComplete = u.engine.time.timeGame + UpGameConfig.timeInfoSend;
			u.net.pushLoading(this);
			u.net.sendReleaseCard(id, 2, timeComplete, tileX, tileY);
			g.event.addEnterFrame(enterFrame, this);
			//要找出卡牌放下去的时间
			if (cardRole && cardRole.DeployTime)
			{
				miniLoad = new DisplayEDTimeLoad(u, camp, u.engine.time.timeGame, timeComplete, timeComplete + cardRole.DeployTime, tileX, tileY);
			}
		}
		
		/** 信息已经获取到了 **/
		public function infoComplete(time:int):void
		{
			infoOk = true;
		}
		
		/** 不停的查看是否过期了,过期了就干掉 **/
		private function enterFrame():void
		{
			if (display && display.length)
			{
				for each (var d:IU2Base in display) 
				{
					if ((d as Object).timer)
					{
						(d as Object).timer.timeCore(u.engine.time.timeEngine, -1, false, false);
					}
				}
			}
			if (u && u.isLive)
			{
				if (timeComplete <= u.engine.time.timeGame)
				{
					if (infoOk == false)
					{
						//提前获取信息
						u.playerED.energyUse -= cardInfo.ManaCost;
						if (u.playerED.energyUse < 0) u.playerED.energyUse = 0;
					}
					dispose();
				}
			}
			else
			{
				dispose();
			}
		}
		
		/** 摧毁对象 **/
		override public function dispose():void 
		{
			if (miniLoad) miniLoad = null;
			g.event.removeEnterFrame(enterFrame, this);
			super.dispose();
			
		}
	}
}