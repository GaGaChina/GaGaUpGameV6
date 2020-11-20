package cn.wjj.upgame.common 
{
	/**
	 * 地图上的显示对象的继承接口
	 * 
	 * @author GaGa
	 */
	public interface IDisplay 
	{
		
		function get x():Number;
		function set x(value:Number):void;
		
		function get y():Number;
		function set y(value:Number):void;
		
		/*
		function get scaleX():Number;
		function set scaleX(value:Number);
		
		function get scaleY():Number;
		function set scaleY(value:Number);
		*/
		function get alpha():Number;
		function set alpha(value:Number):void;
		
		
		/** 移除,清理,并回收 **/
		function dispose():void;
	}
}