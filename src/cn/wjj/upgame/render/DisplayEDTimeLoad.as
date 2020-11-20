package cn.wjj.upgame.render 
{
	import cn.wjj.display.draw.Sector;
	import cn.wjj.display.MPoint;
	import cn.wjj.display.ui2d.U2Bitmap;
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.speedfact.SShape;
	import cn.wjj.upgame.common.IDisplay;
	import cn.wjj.upgame.UpGame;
	import flash.display.Sprite;
	
	/**
	 * 一个时间的倒计时,添加在天空城的上方,最高的位置
	 * @author GaGa
	 */
	public class DisplayEDTimeLoad extends Sprite implements IDisplay
	{
		/** 游戏 **/
		private var u:UpGame;
		/** 阵营 **/
		private var camp:int;
		/** 用户操作的时间 **/
		private var timeStart:uint;
		/** timeGame 中最迟放置的时间 **/
		private var timeNet:uint;
		/** timeGame 人物可以活动的时间点 **/
		private var timeRun:uint;
		/** 背景 **/
		private var bg:U2Bitmap;
		/** 时间的倒计时,宽度15 **/
		private var load:SShape;
		
		/**
		 * 二个时间,自动添加到天空最高的图层
		 * @param	u
		 * @param	camp		阵营
		 * @param	timeStart	动画开始的时间(0将不播放前期的缩放出来的动画)
		 * @param	timeNet		卡牌放置完成的时间点(播放圆盘缩放的动画)
		 * @param	timeRun		卡牌被激活的时间点(播放落地的转圈)
		 */
		public function DisplayEDTimeLoad(u:UpGame, camp:int, timeStart:uint, timeNet:uint, timeRun:uint, tileX:int, tileY:int) 
		{
			this.u = u;
			this.camp = camp;
			this.timeStart = timeStart;
			this.timeNet = timeNet;
			this.timeRun = timeRun;
			bg = u.reader.bitmap("art/c_zd/zd_timebg.png");
			bg.x = -bg.width / 2;
			bg.y = -bg.height / 2;
			load = SShape.instance();
			var p:MPoint = u.engine.astar.getMapPoint(tileX, tileY);
			if (u.modeTurn)
			{
				x = -p.x;
				y = -p.y;
			}
			else
			{
				x = p.x;
				y = p.y;
			}
			p.dispose();
			u.reader.map.layer_flyHarm.addChild(this);
			g.event.addEnterFrame(enterFrame, this);
		}
		
		private function enterFrame():void
		{
			if (u && u.isLive )
			{
				if (timeNet >= u.engine.time.timeGame)
				{
					//还没有到
					if (timeStart)
					{
						this.scaleX = (u.engine.time.timeGame - timeStart) / (timeNet - timeStart);
						this.scaleY = this.scaleX;
						if (this.contains(bg) == false) this.addChild(bg);
					}
				}
				else if(timeRun >= u.engine.time.timeGame)
				{
					if (this.scaleX != 1)
					{
						this.scaleX = 1;
						this.scaleY = 1;
					}
					if (this.contains(bg) == false)
					{
						this.addChild(bg);
						this.addChild(load);
					}
					load.graphics.clear();
					if (u.modeTurn)
					{
						if (camp == 1)
						{
							load.graphics.lineStyle(1, 0xff463d);
							load.graphics.beginFill(0xab1912);
						}
						else
						{
							load.graphics.lineStyle(1, 0x52d8ff);
							load.graphics.beginFill(0x1088e5);
						}
					}
					else
					{
						if (camp == 1)
						{
							load.graphics.lineStyle(1, 0x52d8ff);
							load.graphics.beginFill(0x1088e5);
						}
						else
						{
							load.graphics.lineStyle(1, 0xff463d);
							load.graphics.beginFill(0xab1912);
						}
					}
					var a:int = int( 360 * (u.engine.time.timeGame - timeNet) / (timeRun - timeNet));
					Sector.draw(load.graphics, 0, 0, 15, a);
					if (this.contains(load) == false)
					{
						this.addChild(load);
					}
				}
				else
				{
					var overTime:uint = u.engine.time.timeGame - timeRun;
					if (overTime >= 500)
					{
						dispose();
					}
					else
					{
						this.alpha = (500 - overTime) / 500;
						this.scaleX = this.alpha;
						this.scaleY = this.alpha;
					}
				}
			}
			else
			{
				dispose();
			}
		}
		
		/**
		 * 当网络出现不通畅的时候直接报错
		 */
		public function netErrorClose():void
		{
			dispose();
		}
		
		/** 摧毁对象 **/
		public function dispose():void 
		{
			g.event.removeEnterFrame(enterFrame, this);
			if (this.parent) this.parent.removeChild(this);
			if (bg)
			{
				bg.dispose();
				bg = null;
			}
			if (load)
			{
				load.dispose();
				load = null;
			}
			if (u) u = null;
		}
	}

}