package cn.wjj.upgame.render 
{
	import cn.wjj.gagaframe.client.speedfact.SSprite;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	/**
	 * 血条,要在初始化的时候,设置这几个bitmap,否则不会显示血条
	 * 
	 * 按照血量增加分割线；
	 * 每5000血为一格；血量越多格子越多；
	 * 每个血条最多可能的格子数量 = 血条长度/5
	 * 即：每个格子的宽度最少4个像素（不含分割线，分割线为1个像素）
	 * 当血量超过最多格子时，按照最大格子数拆分血格；
	 * 
	 * 1像素 + 血条长度 + 1像素
	 * 格子最大数量 = 血条长度/5 取上限
	 * 
	 * @author GaGa
	 */
	public class DisplayEDRoleBoolmd
	{
		/** 是否把全部的BitmapData初始化成功 **/
		public static var isInit:Boolean = false;
		
		/** 缓存血量的Sprite **/
		internal static var s:SSprite = SSprite.instance();
		/** 缩放变量 **/
		internal static var m:Matrix = new Matrix();
		
		/** 大黑背景 **/
		public static var bd_bg:BitmapData;
		/** 黑背景上的条条 **/
		public static var bg_bar:BitmapData;
		/** 类型1的条背景 **/
		public static var bg_type_1:BitmapData;
		/** 类型2的条背景 **/
		public static var bg_type_2:BitmapData;
		/** 类型BOSS的条背景 **/
		public static var bg_type_boss:BitmapData;
		/** [小条]减少的白条的背景 **/
		public static var bg_small_del:BitmapData;
		/** [大条]减少的白条的背景 **/
		public static var bg_big_del:BitmapData;
		/** 自动死亡的条,召唤 **/
		public static var bg_die_bar:BitmapData;
		/** 条的宽度,粗细 **/
		public static var bar_height:uint = 2;
		/** 死亡条的宽度,粗细 **/
		public static var die_bar_height:uint = 1;
		/** 是否展示血条的小条条 **/
		public static var show_bar:Boolean = true;
		
		/** 类型4567,4个血条被攻击的时候,闪光的白色条 **/
		public static var type_4567_white:BitmapData;
		/** 类型4567,4个血条被攻击的时候,闪光的白色条每次减少的alpha的量 **/
		public static var type_4567_white_sp:Number = 0.3;
		
		/** 类型4的camp阵容1的血条(一般角色, 蓝色) **/
		public static var type_4_c1_bar:BitmapData;
		/** 类型4的camp阵容1的血条(一般角色, 绿色(队友)) **/
		public static var type_4_c1_2_bar:BitmapData;
		/** 类型4的camp阵容1的背景(一般角色, 蓝色) **/
		public static var type_4_c1_bg:BitmapData;
		
		/** 类型4的camp阵容1的血条(一般角色, 红色) **/
		public static var type_4_c2_bar:BitmapData;
		/** 类型4的camp阵容1的背景(一般角色, 红色) **/
		public static var type_4_c2_bg:BitmapData;
		/** 类型4的camp阵容1的背景的高度,bar要上下都减少1,就是-2 **/
		public static var type_4_heigth:uint = 10;
		/** 类型4的等级的多语言,使用 getCacheData 可以获取到文本的BitmapData **/
		public static var type_4_lv_c1:String = "";
		/** 类型4的等级的多语言,使用 getCacheData 可以获取到文本的BitmapData **/
		public static var type_4_lv_c2:String = "";
		
		/** 类型5最下面的背景(黑色) **/
		public static var type_5_bg1:BitmapData;
		/** 类型5最下面的背景(黄色) **/
		public static var type_5_bg2:BitmapData;
		/** 类型5最下面的背景(内测背景蓝色) **/
		public static var type_5_bg3:BitmapData;
		/** 我方阵营的等级背景 **/
		public static var type_5_icon_c1:BitmapData;
		/** 敌方阵营的等级背景 **/
		public static var type_5_icon_c2:BitmapData;
		/** 我方阵营的Bar的背景 **/
		public static var type_5_bar_c1:BitmapData;
		/** 敌方阵营的Bar的背景 **/
		public static var type_5_bar_c2:BitmapData;
		/** 等级的多语言 **/
		public static var type_5_lv_c1:String = "";
		/** 等级的多语言 **/
		public static var type_5_lv_c2:String = "";
		/** 血量的多语言 **/
		public static var type_5_blood_c1:String = "";
		/** 血量的多语言 **/
		public static var type_5_blood_c2:String = "";
		/** 类型5中血条展开的速度 **/
		public static var type_5_open_sp:Number = 5;
		
		/** 我方阵营的等级背景 **/
		public static var type_7_icon_c1:BitmapData;
		/** 敌方阵营的等级背景 **/
		public static var type_7_icon_c2:BitmapData;
		/** 血量的多语言 **/
		public static var type_7_blood_c1:String = "";
		/** 血量的多语言 **/
		public static var type_7_blood_c2:String = "";
		
		/** 小星星 **/
		public static var type_8_star:BitmapData;
		
		public function DisplayEDRoleBoolmd() { }
	}
}