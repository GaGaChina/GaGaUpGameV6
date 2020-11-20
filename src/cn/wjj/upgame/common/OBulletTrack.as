package cn.wjj.upgame.common 
{
	/**
	 * 子弹的弹道类型
	 * 轨迹类型 : 0-无弹道，1-基本弹道（匀速），2-基本弹道（加速）；3-碰撞弹道（匀速）；4-碰撞弹道（加速）；5-抛物线弹道，6-穿透弹道（匀速），7-穿透弹道（加速），8-光线弹道（激光） 
	 * @author GaGa
	 */
	public class OBulletTrack 
	{
		
		/** 0 无弹道 **/
		public static const no:uint = 0;
		
		/** 1 [匀速][不碰]基本弹道 **/
		public static const track:uint = 1;
		
		/** 2 [加速][不碰]加速弹道 **/
		public static const accelerate:uint = 2;
		
		/** 3 [匀速][碰撞]基本弹道 **/
		public static const hit:uint = 3;
		
		/** 4 [加速][碰撞]加速弹道 **/
		public static const accelerateHit:uint = 4;
		
		/** 5 [匀速][不碰]抛物线弹道 **/
		public static const parabola:uint = 5;
		
		/** 6 [匀速][碰撞]穿透弹道 **/
		public static const penetrateHit:uint = 6;
		
		/** 7 [加速][碰撞]穿透弹道 **/
		public static const acceleratePenetrateHit:uint = 7;
		
		/** 8 [匀速][碰撞]光线弹道 **/
		public static const line:uint = 8;
		
		public function OBulletTrack() { }
		
	}
}