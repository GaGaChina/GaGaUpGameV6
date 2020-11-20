package cn.wjj.upgame.render 
{
	import cn.wjj.display.filter.ColorTrans;
	import cn.wjj.display.filter.ColorTransType;
	import cn.wjj.display.speed.BitmapDataItem;
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.speedfact.SBitmap;
	import cn.wjj.gagaframe.client.speedfact.SpeedLib;
	import cn.wjj.upgame.common.IDisplayBoolmd;
	import cn.wjj.upgame.engine.EDRole;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * 血条,要在初始化的时候,设置这几个bitmap,否则不会显示血条
	 * 
	 * @author GaGa
	 */
	public class DisplayEDRoleBoolmdType7 extends Sprite implements IDisplayBoolmd 
	{
		/** 对象池 **/
		private static var __f:SpeedLib = new SpeedLib(40);
		/** 对象池强引用的最大数量 **/
		static public function get __m():uint { return __f.length; }
		/** 对象池强引用的最大数量 **/
		static public function set __m(value:uint):void { __f.length = value; }
		
		/**
		 * 初始化 Bitmap 对象以引用指定的 BitmapData 对象。
		 * @param	bitmapData		被引用的 BitmapData 对象。
		 * @param	pixelSnapping	Bitmap 对象是否贴紧至最近的像素。
		 * @param	smoothing		在缩放时是否对位图进行平滑处理。例如，下例显示使用系数 3 缩放的同一位图，smoothing 设置为 false（左侧）和 true（右侧）：
		 */
		public static function instance():IDisplayBoolmd
		{
			var o:DisplayEDRoleBoolmdType7 = __f.instance() as DisplayEDRoleBoolmdType7;
			if (o == null) o = new DisplayEDRoleBoolmdType7();
			return o;
		}
		
		/** 移除,清理,并回收 **/
		public function dispose():void
		{
			if (this.parent) this.parent.removeChild(this);
			if (this.role != null) this.role = null;
			if (this.father != null) this.father = null;
			if (this.bg1 != null)
			{
				this.bg1.dispose();
				this.bg1 = null;
			}
			if (this.bg2 != null)
			{
				this.bg2.dispose();
				this.bg2 = null;
			}
			if (this.bar != null)
			{
				this.bar.dispose();
				this.bar = null;
			}
			if (this.white != null)
			{
				this.white.dispose();
				this.white = null;
			}
			if (this.lv_bg != null)
			{
				this.lv_bg.dispose();
				this.lv_bg = null;
			}
			if (this.blood_font != null)
			{
				this.blood_font.dispose();
				this.blood_font = null;
			}
			if (this.hp != 0) this.hp = 0;
			if (this.hpMax != -1) this.hpMax = -1;
			if (this.redType != 0) this.redType = 0;
			if (this.redMax != -1) this.redMax = -1;
			if (this.hpIsShow) this.hpIsShow = false;
			if (this.hpWhiteIsShow) this.hpWhiteIsShow = false;
			__f.recover(this);
		}
		
		/** 血条所属对象 **/
		public var role:EDRole;
		/** 血条所在父级的显示对象 **/
		public var father:DisplayEDRole;
		/** 血条背景 **/
		private var bg1:SBitmap;
		/** 血条背景 **/
		private var bg2:SBitmap;
		/** 血条背景 **/
		private var bg3:SBitmap;
		/** 血条 **/
		private var bar:SBitmap;
		/** 白色条 **/
		private var white:SBitmap;
		/** 等级的背景 **/
		private var lv_bg:SBitmap;
		/** 血量的字体 **/
		private var blood_font:SBitmap;
		/** 血量展示的字体 **/
		private var blood_font_id:String;
		
		/** 现在的血量 **/
		private var hp:int = 0;
		/** 现在计算的最高血量 **/
		private var hpMax:int = -1;
		/** 属于那种红, 0,无色, 1,1号红,2,2号红 **/
		private var redType:int = 0;
		/** 最多可以红多久 **/
		private var redMax:int = -1;
		/** HP相关条是否已经添加 **/
		private var hpIsShow:Boolean = false;
		/** HP相关条是否已经添加 **/
		private var hpWhiteIsShow:Boolean = false;
		
		public function DisplayEDRoleBoolmdType7() { }
		
		/** 是否处于刷新状态 **/
		public function get isRefresh():Boolean { return true; }
		
		/**
		 * 设置血条, 血条的父级的显示容器
		 * @param	role
		 * @param	father
		 */
		public function init(role:EDRole, father:DisplayEDRole):void
		{
			this.role = role;
			this.father = father;
			this.x = -int(role.model.bloodWidth / 2);
			this.y = role.model.bloodY;
			hp = role.info.hp;
			hpMax = role.info.hpMax;
			setLvFont();
			changeHP(false);
			father.addChild(this);
		}
		
		/**
		 * 添加血条前的等级字符
		 */
		private function setLvFont():void
		{
			if (lv_bg == null)
			{
				lv_bg = SBitmap.instance();
				if (role.u.modeTurn)
				{
					if (role.camp == 1)
					{
						lv_bg.bitmapData = DisplayEDRoleBoolmd.type_7_icon_c1;
						blood_font_id = DisplayEDRoleBoolmd.type_7_blood_c1;
					}
					else
					{
						lv_bg.bitmapData = DisplayEDRoleBoolmd.type_7_icon_c2;
						blood_font_id = DisplayEDRoleBoolmd.type_7_blood_c2;
					}
				}
				else
				{
					if (role.camp == 1)
					{
						lv_bg.bitmapData = DisplayEDRoleBoolmd.type_7_icon_c2;
						blood_font_id = DisplayEDRoleBoolmd.type_7_blood_c2;
					}
					else
					{
						lv_bg.bitmapData = DisplayEDRoleBoolmd.type_7_icon_c1;
						blood_font_id = DisplayEDRoleBoolmd.type_7_blood_c1;
					}
				}
				lv_bg.y = int((DisplayEDRoleBoolmd.type_5_bar_c1.height - lv_bg.height) / 2);
				this.addChild(lv_bg);
			}
			this.x = -int((lv_bg.width + role.model.bloodWidth + 2) / 2);
		}
		
		/** 当最大血亮变化的时候设置 **/
		public function changeMax():void
		{
			if (hpMax != role.info.hpMax)
			{
				hpMax = role.info.hpMax;
				if (hpIsShow)
				{
					bar.width = getHpWidth();
					changeHP(false);
				}
			}
		}
		
		/** 血条有变化 **/
		public function changeHP(red:Boolean):void
		{
			if (hpIsShow == false)
			{
				hpIsShow = true;
				bg1 = SBitmap.instance();
				bg2 = SBitmap.instance();
				bg1.bitmapData = DisplayEDRoleBoolmd.type_5_bg1;
				bg2.bitmapData = DisplayEDRoleBoolmd.type_5_bg2;
				bg1.width = role.model.bloodWidth + 1;
				bg2.width = role.model.bloodWidth;
				bg1.height = DisplayEDRoleBoolmd.type_5_bar_c1.height + 2;
				bg2.height = DisplayEDRoleBoolmd.type_5_bar_c1.height;
				bg2.y = 1;
				bg1.x = lv_bg.width;
				bg2.x = lv_bg.width;
				this.addChild(bg1);
				this.addChild(bg2);
				bar = SBitmap.instance();
				if (role.u.modeTurn)
				{
					if (role.camp == 1)
					{
						bar.bitmapData = DisplayEDRoleBoolmd.type_5_bar_c2;
					}
					else
					{
						bar.bitmapData = DisplayEDRoleBoolmd.type_5_bar_c1;
					}
				}
				else
				{
					if (role.camp == 1)
					{
						bar.bitmapData = DisplayEDRoleBoolmd.type_5_bar_c1;
					}
					else
					{
						bar.bitmapData = DisplayEDRoleBoolmd.type_5_bar_c2;
					}
				}
				bar.x = bg2.x;
				bar.y = bg2.y;
				bar.height = bg2.height;
				this.addChild(bar);
			}
			hp = role.info.hp;
			bar.width = getHpWidth();
			if (red)
			{
				redMax = 0;
				if (hpWhiteIsShow == false)
				{
					hpWhiteIsShow = true;
					white = SBitmap.instance();
					white.bitmapData = DisplayEDRoleBoolmd.type_4567_white;
					white.x = bar.x;
					white.y = bar.y;
					white.height = bar.height;
					this.addChild(white);
				}
				if (white.width != bar.width) white.width = bar.width;
				if (white.alpha != 1) white.alpha = 1;
			}
			g.language.setDisplayCacheChar(String(hp), blood_font_id, DisplayEDRoleBoolmd.s, 1, -3, true);
			if (DisplayEDRoleBoolmd.s.numChildren)
			{
				var rect:Rectangle = DisplayEDRoleBoolmd.s.getBounds(DisplayEDRoleBoolmd.s);
				var x:int = Math.round(rect.x);
				var y:int = Math.round(rect.y);
				if (rect.isEmpty())
				{
					rect.width = 1;
					rect.height = 1;
				}
				var b:BitmapData = new BitmapData(Math.ceil(rect.width), Math.ceil(rect.height), true, 0x00000000);
				DisplayEDRoleBoolmd.m.tx = -x;
				DisplayEDRoleBoolmd.m.ty = -y;
				b.drawWithQuality(DisplayEDRoleBoolmd.s, DisplayEDRoleBoolmd.m, null, null, null, true, "best");
				DisplayEDRoleBoolmd.s.removeChildren();
				if (blood_font == null) blood_font = SBitmap.instance();
				blood_font.bitmapData = b;
				blood_font.x = int(x + bg2.x + (role.model.bloodWidth / 3 * 2));
				if (blood_font.x < bg2.x)
				{
					blood_font.x = bg2.x;
				}
				blood_font.y = int(bg2.y + (blood_font.height / 3));
				if (this != blood_font.parent)
				{
					this.addChild(blood_font);
				}
			}
			else if(blood_font)
			{
				blood_font.dispose();
				blood_font = null;
			}
		}
		
		/** 是否需要刷新 **/
		public function refresh():void
		{
			if (role && role.isLive)
			{
				if (hpWhiteIsShow)
				{
					white.alpha -= DisplayEDRoleBoolmd.type_4567_white_sp;
					if (white.alpha <= 0)
					{
						white.dispose();
						white = null;
						hpWhiteIsShow = false;
					}
				}
				if (redMax != -1)
				{
					redMax++;
					if (redMax < 5)
					{
						redType++;
						switch (redType)
						{
							case 0:
								ColorTrans.trans(father, ColorTransType.redLevel8);
								break;
							case 1:
								break;
							case 2:
								ColorTrans.trans(father, ColorTransType.normal);
								break;
							case 3:
								redType = -1;
								break;
						}
					}
					else
					{
						if (redType != 2)
						{
							ColorTrans.trans(father, ColorTransType.normal);
						}
						redType = -1;
						redMax = -1;
					}
				}
				//把这个对象添加到显示列表中去
				if (father)
				{
					if (father != this.parent)
					{
						father.addChild(this);
					}
					else
					{
						var temp:int = father.numChildren - 1;
						if (father.getChildIndex(this) != temp)
						{
							father.setChildIndex(this, temp);
						}
					}
				}
			}
			else
			{
				dispose();
			}
		}
		
		/** 获取血条的宽度 **/
		private function getHpWidth():int
		{
			var temp:int = int(role.model.bloodWidth * hp / hpMax);
			if (temp < 0)
			{
				return 0;
			}
			else if (temp > role.model.bloodWidth)
			{
				temp = role.model.bloodWidth;
			}
			return temp;
		}
	}
}