package cn.wjj.upgame.render
{
	import cn.wjj.display.speed.BitmapDataItem;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	/**
	 * g.language.clearAllCacheChar();
	 * 
	 * g.language.cacheChar("+-0123456789", "flyNumber1", true);
	 * g.language.cacheChar("+-0123456789", "flyNumber2", true);
	 * g.language.cacheChar("+-0123456789", "flyNumber3", true);
	 */
	public class DisplayNumber extends Bitmap
	{
		/** MISS字体 **/
		public static var miss:BitmapDataItem;
		/** 是否播放动画 **/
		public static var playMovieMiss:Boolean = true;
		/** 是否播放动画 **/
		public static var playMovieNumber:Boolean = true;
		//普通伤害 flyNumber1
		public static var skinAttack:String = "";
		//爆击伤害 flyNumber3
		public static var skinAttackCrit:String = "";
		//治疗加血 flyNumber2
		public static var skinAdd:String = "";
		
		/** 临时容器 **/
		internal static var s:Sprite = new Sprite();
		/** 缩放变量 **/
		internal static var m:Matrix = new Matrix();
		
		public function DisplayNumber():void { }
		
		/**
		 * 会把 BitmapData 方到中间
		 * AllData.getInstance().file_bitmapData("art/miss.png")
		 * @param	bitmapData
		 */
		public static function setMISS(bitmapData:BitmapData):void
		{
			if (bitmapData)
			{
				miss = BitmapDataItem.instance();
				miss.bitmapData = bitmapData;
				miss.x = -int(miss.bitmapData.width / 2);
				miss.y = -int(miss.bitmapData.height / 2);
				//可以对这里微调
				//x = p.x - 10;
			}
			else
			{
				miss.dispose();
				miss = null;
			}
		}
	}
}

