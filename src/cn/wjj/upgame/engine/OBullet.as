package cn.wjj.upgame.engine 
{
	import cn.wjj.upgame.data.UpGameBulletInfo;
	
	/**
	 * 子弹的实例化数据数据
	 * 
	 * @author GaGa
	 */
	public class OBullet
	{
		/** 策划文档的ID **/
		public var id:int = 0;
		/** 射程 **/
		public var range:uint = 0;
		/** 策划子弹数据 **/
		public var info:UpGameBulletInfo;
		/** 效果列表 **/
		public var effectList:Vector.<OSkillEffect>;
		/** 所挂的效果个数 **/
		public var length:int = 0;
		
		public function OBullet():void
		{
			effectList = new Vector.<OSkillEffect>();
		}
	}
}