package cn.wjj.upgame.common 
{
	import cn.wjj.upgame.engine.AIRoleSkill;
	import cn.wjj.upgame.engine.EDRole;
	
	/**
	 * 其他特殊技能的驱动类
	 * 
	 * @author GaGa
	 */
	public interface IOtherSkillRun 
	{
		
		/**
		 * 开始释放特殊技能
		 * @param	ed		释放者对象
		 * @param	skill	主动技能引用
		 * @return			是否结束了
		 */
		function start(skill:AIRoleSkill, useTime:uint):Boolean;
		
		/** 每帧都运行这个特殊技能,返回是否已经结束 **/
		function enterFrame(useTime:uint):Boolean;
		
		/** 移除,清理,并回收 **/
		function dispose():void;
	}
	
}