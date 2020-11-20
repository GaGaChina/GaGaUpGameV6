package cn.wjj.upgame.render 
{
	import cn.wjj.g;
	import cn.wjj.upgame.UpGame;
	import cn.wjj.upgame.data.SkillActiveModel;
	import cn.wjj.upgame.engine.EDRole;

	/**
	 * 控制技能释放的时候大特效的处理
	 * @author GaGa
	 */
	public class EngineSkillBigEffect 
	{
		/** 引用 **/
		public var u:UpGame;
		/** 正在播放的特效 **/
		private var run:EngineSkillBigEffectBase;
		/** 播放的特效的时间 **/
		private var runTime:Number;
		/** 是否已经启动 **/
		private var startFrame:Boolean = false;
		
		public function EngineSkillBigEffect(u:UpGame)
		{
			this.u = u;
		}
		
		/** 把所有的ED信息处理掉,并且清空 **/
		public function show(ed:EDRole, skill:SkillActiveModel):void
		{
			clear();
			runTime = u.engine.time.timeEngine;
			switch (skill.bigEffect) 
			{
				case -1:
					run = new EngineSkillBigEffectNegative1(u, ed, skill, runTime);
					break;
			}
			if (run && run.display)
			{
				if (startFrame == false)
				{
					startFrame = true;
					u.engine.changePlayPause++;
					g.event.addEnterFrame(enterFrame, this);
				}
			}
			else
			{
				clear();
			}
		}
		
		private function enterFrame():void
		{
			if (u && u.isLive)
			{
				runTime += u.engine.time.displayFrame * u.engine.time.displaySpeed;
				if (run.run(runTime))
				{
					clear();
				}
			}
			else
			{
				clear();
			}
		}
		
		/** 清理老的技能定格 **/
		public function clear():void
		{
			if (startFrame)
			{
				startFrame = false;
				u.engine.changePlayPause--;
				if (u.engine.changePlayPause == 0)
				{
					u.engine.checkState();
				}
			}
			g.event.removeEnterFrame(enterFrame, this);
			if (run)
			{
				run.dispose();
				run = null;
			}
		}
		
		/** 摧毁对象 **/
		public function dispose():void 
		{
			clear();
			u = null;
		}
	}
}