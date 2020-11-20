package cn.wjj.upgame.common 
{
	import cn.wjj.upgame.engine.EDRole;
	import cn.wjj.upgame.render.DisplayEDRole;
	
	/**
	 * 角色血条的接口
	 * 
	 * @author GaGa
	 */
	public interface IDisplayBoolmd
	{
		/**
		 * 设置血条, 血条的父级的显示容器
		 * @param	role
		 * @param	father
		 */
		function init(role:EDRole, father:DisplayEDRole):void;
		
		/** 是否处于刷新状态 **/
		function get isRefresh():Boolean;
		
		/** 当最大血亮变化的时候设置 **/
		function changeMax():void;
		
		/** 血条有变化 **/
		function changeHP(red:Boolean):void;
		
		/** 是否需要刷新 **/
		function refresh():void;
		
		/** 移除,清理,并回收 **/
		function dispose():void;
		
	}
}