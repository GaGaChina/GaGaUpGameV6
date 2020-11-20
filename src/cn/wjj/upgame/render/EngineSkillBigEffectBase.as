package cn.wjj.upgame.render 
{
	import cn.wjj.display.ui2d.IU2Base;
	import cn.wjj.upgame.UpGame;
	import cn.wjj.upgame.data.SkillActiveModel;
	import cn.wjj.upgame.engine.EDRole;

	/**
	 * 控制技能释放的时候大特效的处理
	 * @author GaGa
	 */
	public class EngineSkillBigEffectBase 
	{
		/** 引用 **/
		public var u:UpGame;
		/** 释放者 **/
		public var ed:EDRole;
		/** 技能 **/
		public var skill:SkillActiveModel;
		/** 大特效对象 **/
		public var display:IU2Base;
		/** 开始时间 **/
		public var timeStart:int = 0;
		/** 结束时间 **/
		public var timeEnd:int = 0;
		
		public function EngineSkillBigEffectBase(u:UpGame, ed:EDRole, skill:SkillActiveModel, timeStart:int)
		{
			this.u = u;
			this.ed = ed;
			this.skill = skill;
			this.timeStart = timeStart;
			this.timeEnd = timeStart;
			start();
		}
		
		public function start():void { }
		
		/** 带入时间,返回是否结束 **/
		public function run(time:int):Boolean
		{
			return true;
		}
		
		/** 摧毁 **/
		public function dispose():void
		{
			u = null;
			ed = null;
			skill = null;
			if (display)
			{
				display.dispose();
				display = null;
			}
		}
	}
}