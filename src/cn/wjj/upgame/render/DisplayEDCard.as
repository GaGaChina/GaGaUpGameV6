package cn.wjj.upgame.render 
{
	import cn.wjj.display.speed.BitmapText;
	import cn.wjj.g;
	import cn.wjj.upgame.tools.ReleaseCard;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 显示出卡牌放置前的形象,本框架并不直接使用
	 * 
	 * @author GaGa
	 */
	public class DisplayEDCard extends DisplayEDCardBase
	{
		/** 卡牌名字 **/
		private var txName:BitmapText;
		/** 卡牌等级 **/
		private var txLevel:BitmapText;
		
		/**
		 * 设置对象的形象
		 * @param	u		
		 * @param	id		
		 * @param	camp	阵营
		 * @param	tileX	AStar方格的坐标
		 * @param	tileY	AStar方格的坐标
		 */
		public function DisplayEDCard(u:UpGame, id:int, camp:int, tileX:int, tileY:int)
		{
			super(u, id, camp, tileX, tileY);
			if (cardInfo)
			{
				if (txName) txName.dispose();
				if (txLevel) txLevel.dispose();
				txName = g.language.getBitmapField(ReleaseCard.lang_name, g.language.getString(String(cardInfo.Cname)));
				txName.x = int( -txName.width / 2);
				txName.y = -120;
				txLevel = g.language.getBitmapField(ReleaseCard.lang_lv, cardInfo.CardLevel);
				txLevel.x = int( -txLevel.width / 2);
				txLevel.y = -90;
				this.addChild(txName);
				this.addChild(txLevel);
				switch (cardInfo.CardType)
				{
					case 1://部队
					case 4://主塔,副塔
					case 5://英雄
						this.graphics.lineStyle(5, 0xFFFFFF, 1);
						this.graphics.beginFill(0xFFFFFF, 0.8);
						this.graphics.drawRoundRect(int( -u.engine.astar.tileWidth / 2), int( -u.engine.astar.tileHeight / 2), u.engine.astar.tileWidth, u.engine.astar.tileHeight, 5, 5);
						this.graphics.endFill();
						break;
					case 3://建筑
						var bx:int = int( -cardRole.Mass / 2 * u.engine.astar.tileWidth - int(u.engine.astar.tileWidth / 2));
						var by:int = int( -cardRole.Mass / 2 * u.engine.astar.tileHeight - int(u.engine.astar.tileHeight / 2));
						this.graphics.lineStyle(5, 0xFFFFFF, 1);
						this.graphics.beginFill(0xFFFFFF, 0.8);
						this.graphics.drawRoundRect(bx, by, cardRole.Mass * u.engine.astar.tileWidth + u.engine.astar.tileWidth, cardRole.Mass * u.engine.astar.tileHeight + u.engine.astar.tileHeight, 5, 5);
						this.graphics.endFill();
						break;
				}
			}
		}
		
		/** 摧毁对象 **/
		override public function dispose():void 
		{
			super.dispose();
			if (txName) txName.dispose();
			if (txLevel) txLevel.dispose();
		}
	}
}