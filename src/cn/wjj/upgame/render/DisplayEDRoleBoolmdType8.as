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
	import flash.display.Sprite;
	
	/**
	 * 血条,要在初始化的时候,设置这几个bitmap,否则不会显示血条
	 * 
	 * @author GaGa
	 */
	public class DisplayEDRoleBoolmdType8 extends Sprite implements IDisplayBoolmd 
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
			var o:DisplayEDRoleBoolmdType8 = __f.instance() as DisplayEDRoleBoolmdType8;
			if (o == null) o = new DisplayEDRoleBoolmdType8();
			return o;
		}
		
		/** 移除,清理,并回收 **/
		public function dispose():void
		{
			if (this.parent) this.parent.removeChild(this);
			if (this.role != null) this.role = null;
			if (this.father != null) this.father = null;
			if (this.bg != null)
			{
				this.bg.dispose();
				this.bg = null;
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
			if (this.lv_bg1 != null)
			{
				this.lv_bg1.dispose();
				this.lv_bg1 = null;
			}
			if (this.lv_bg2 != null)
			{
				this.lv_bg2.dispose();
				this.lv_bg2 = null;
			}
			if (this.lv_font != null)
			{
				for each (var item:SBitmap in this.lv_font) 
				{
					item.dispose();
				}
				g.speedFact.d_vector(SBitmap, this.lv_font);
				this.lv_font = null;
			}
			if (this.star != -1) this.star = -1;
			if (this.star1 != null)
			{
				this.star1.dispose();
				this.star1 = null;
			}
			if (this.star2 != null)
			{
				this.star2.dispose();
				this.star2 = null;
			}
			if (this.star3 != null)
			{
				this.star3.dispose();
				this.star3 = null;
			}
			if (this.star4 != null)
			{
				this.star4.dispose();
				this.star4 = null;
			}
			if (this.star5 != null)
			{
				this.star5.dispose();
				this.star5 = null;
			}
			if (starBg)
			{
				starBg.dispose();
				starBg = null;
			}
			if (this.hp != 0) this.hp = 0;
			if (this.hpMax != -1) this.hpMax = -1;
			if (this.hpWhiteIsShow) this.hpWhiteIsShow = false;
			__f.recover(this);
		}
		
		/** 血条所属对象 **/
		public var role:EDRole;
		/** 血条所在父级的显示对象 **/
		public var father:DisplayEDRole;
		/** 血条背景 **/
		private var bg:SBitmap;
		/** 血条 **/
		private var bar:SBitmap;
		/** 白色条 **/
		private var white:SBitmap;
		/** 等级的背景 **/
		private var lv_bg1:SBitmap;
		/** 等级的背景 **/
		private var lv_bg2:SBitmap;
		/** 等级的Bitmap **/
		private var lv_font:Vector.<SBitmap>;
		
		/** 现在展示了多少个星星 **/
		private var star:int = -1;
		/** 第一颗星星 **/
		private var star1:SBitmap;
		private var star2:SBitmap;
		private var star3:SBitmap;
		private var star4:SBitmap;
		private var star5:SBitmap;
		/** 星背景 **/
		private var starBg:SBitmap;
		
		/** 现在的血量 **/
		private var hp:int = 0;
		/** 现在计算的最高血量 **/
		private var hpMax:int = -1;
		/** 属于那种红, 0,无色, 1,1号红,2,2号红 **/
		private var redType:int = 0;
		/** 最多可以红多久 **/
		private var redMax:int = 0;
		/** HP相关条是否已经添加 **/
		private var hpWhiteIsShow:Boolean = false;
		
		public function DisplayEDRoleBoolmdType8() { }
		
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
			setLvFont(true);
			bg = SBitmap.instance();
			bar = SBitmap.instance();
			starBg = SBitmap.instance();
			if (role.u.modeTurn)
			{
				if (role.camp == 1)
				{
					bg.bitmapData = DisplayEDRoleBoolmd.type_4_c2_bg;
					bar.bitmapData = DisplayEDRoleBoolmd.type_4_c2_bar;
					starBg.bitmapData = DisplayEDRoleBoolmd.type_4_c2_bg;
				}
				else
				{
					bg.bitmapData = DisplayEDRoleBoolmd.type_4_c1_bg;
					if (role.playerId == role.u.playerId)
					{
						bar.bitmapData = DisplayEDRoleBoolmd.type_4_c1_bar;
					}
					else
					{
						bar.bitmapData = DisplayEDRoleBoolmd.type_4_c1_2_bar;
					}
					starBg.bitmapData = DisplayEDRoleBoolmd.type_4_c1_bg;
				}
			}
			else
			{
				if (role.camp == 1)
				{
					bg.bitmapData = DisplayEDRoleBoolmd.type_4_c1_bg;
					if (role.playerId == role.u.playerId)
					{
						bar.bitmapData = DisplayEDRoleBoolmd.type_4_c1_bar;
					}
					else
					{
						bar.bitmapData = DisplayEDRoleBoolmd.type_4_c1_2_bar;
					}
					starBg.bitmapData = DisplayEDRoleBoolmd.type_4_c1_bg;
				}
				else
				{
					bg.bitmapData = DisplayEDRoleBoolmd.type_4_c2_bg;
					bar.bitmapData = DisplayEDRoleBoolmd.type_4_c2_bar;
					starBg.bitmapData = DisplayEDRoleBoolmd.type_4_c2_bg;
				}
			}
			bg.width = role.model.bloodWidth + 2;
			bg.height = DisplayEDRoleBoolmd.type_4_heigth;
			bg.y = -4;
			if (lv_bg1)
			{
				bg.x = lv_bg1.x + lv_bg1.width;
			}
			else
			{
				this.x = -int((role.model.bloodWidth + 2) / 2);
			}
			bar.x = bg.x + 1;
			bar.y = bg.y + 1;
			bar.width = getHpWidth();
			bar.height = DisplayEDRoleBoolmd.type_4_heigth - 2;
			this.addChild(bg);
			this.addChild(bar);
			
			starBg.width = bg.width;
			starBg.height = bg.height - 2;
			starBg.x = bg.x;
			starBg.y = bg.y + bg.height;
			this.addChild(starBg);
			
			star1 = SBitmap.instance();
			star1.bitmapData = DisplayEDRoleBoolmd.type_8_star;
			star1.x = bg.x + 2;
			star1.y = 7;
			
			star2 = SBitmap.instance();
			star2.bitmapData = DisplayEDRoleBoolmd.type_8_star;
			star2.x = star1.x + star1.width + 1;
			star2.y = 7;
			
			star3 = SBitmap.instance();
			star3.bitmapData = DisplayEDRoleBoolmd.type_8_star;
			star3.x = star2.x + star2.width + 1;
			star3.y = 7;
			
			star4 = SBitmap.instance();
			star4.bitmapData = DisplayEDRoleBoolmd.type_8_star;
			star4.x = star3.x + star3.width + 1;
			star4.y = 7;
			
			star5 = SBitmap.instance();
			star5.bitmapData = DisplayEDRoleBoolmd.type_8_star;
			star5.x = star4.x + star4.width + 1;
			star5.y = 7;
			
			father.addChild(this);
		}
		
		/**
		 * 添加血条前的等级字符
		 * @param	addHp
		 */
		private function setLvFont(addHp:Boolean):void
		{
			var sb:SBitmap;
			//等级的宽度
			var lw:int = 0;
			//等级字背景的高度
			var lh:int = DisplayEDRoleBoolmd.type_4_heigth + 4;
			if (lv_font == null)
			{
				var level:String = String(role.info.level);
				var lvLength:int = level.length;
				var bi:BitmapDataItem;
				//等级所使用的字体
				var lvFont:String = "";
				if (role.u.modeTurn)
				{
					if (role.camp == 1)
					{
						lvFont = DisplayEDRoleBoolmd.type_4_lv_c2;
					}
					else
					{
						lvFont = DisplayEDRoleBoolmd.type_4_lv_c1;
					}
				}
				else
				{
					if (role.camp == 1)
					{
						lvFont = DisplayEDRoleBoolmd.type_4_lv_c1;
					}
					else
					{
						lvFont = DisplayEDRoleBoolmd.type_4_lv_c2;
					}
				}
				for (var i:int = 0; i < lvLength; i++) 
				{
					bi = g.language.getCacheData(level.substr(i, 1), lvFont, false);
					if (lv_font == null)
					{
						lv_font = g.speedFact.n_vector(SBitmap);
						if (lv_font == null)
						{
							lv_font = new Vector.<SBitmap>();
						}
					}
					lw += bi.bitmapData.width;
					if ((bi.bitmapData.height + 4) > lh)
					{
						lh = bi.bitmapData.height + 4;
					}
					sb = SBitmap.instance();
					sb.bitmapData = bi.bitmapData;
					lv_font.push(sb);
				}
				this.y = role.model.bloodY;
			}
			else
			{
				for each (sb in lv_font) 
				{
					lw += sb.bitmapData.width;
					if ((sb.bitmapData.height + 4) > lh)
					{
						lh = sb.bitmapData.height + 4;
					}
				}
			}
			if (lw)
			{
				lw += 4;
				if (addHp)
				{
					this.x = -int((lw + role.model.bloodWidth + 2) / 2);
				}
				else
				{
					this.x = -int(lw / 2);
				}
				
				if (lv_bg1 == null)
				{
					lv_bg1 = SBitmap.instance();
					lv_bg2 = SBitmap.instance();
					if (role.u.modeTurn)
					{
						if (role.camp == 1)
						{
							lv_bg1.bitmapData = DisplayEDRoleBoolmd.type_4_c2_bg;
							lv_bg2.bitmapData = DisplayEDRoleBoolmd.type_4_c2_bar;
						}
						else
						{
							lv_bg1.bitmapData = DisplayEDRoleBoolmd.type_4_c1_bg;
							if (role.playerId == role.u.playerId)
							{
								lv_bg2.bitmapData = DisplayEDRoleBoolmd.type_4_c1_bar;
							}
							else
							{
								lv_bg2.bitmapData = DisplayEDRoleBoolmd.type_4_c1_2_bar;
							}
						}
					}
					else
					{
						if (role.camp == 1)
						{
							lv_bg1.bitmapData = DisplayEDRoleBoolmd.type_4_c1_bg;
							if (role.playerId == role.u.playerId)
							{
								lv_bg2.bitmapData = DisplayEDRoleBoolmd.type_4_c1_bar;
							}
							else
							{
								lv_bg2.bitmapData = DisplayEDRoleBoolmd.type_4_c1_2_bar;
							}
						}
						else
						{
							lv_bg1.bitmapData = DisplayEDRoleBoolmd.type_4_c2_bg;
							lv_bg2.bitmapData = DisplayEDRoleBoolmd.type_4_c2_bar;
						}
					}
				}
				lv_bg1.width = lw;
				lv_bg1.height = lh;
				lv_bg1.y = -int((lh - DisplayEDRoleBoolmd.type_4_heigth) / 2);
				
				lv_bg2.height = lh - 2;
				lv_bg2.width = lv_bg1.width - 2;
				lv_bg2.x = 1;
				lv_bg2.y = lv_bg1.y + 1;
				
				this.addChild(lv_bg1);
				this.addChild(lv_bg2);
				
				lw = 2;
				for each (sb in lv_font) 
				{
					sb.x = lw;
					sb.y = lv_bg2.y + lv_bg2.height - sb.bitmapData.height - 1;
					lw += sb.bitmapData.width;
					this.addChild(sb);
				}
			}
		}
		
		/** 当最大血亮变化的时候设置 **/
		public function changeMax():void
		{
			if (hpMax != role.info.hpMax)
			{
				hpMax = role.info.hpMax;
				bar.width = getHpWidth();
				changeHP(false);
			}
		}
		
		/** 血条有变化 **/
		public function changeHP(red:Boolean):void
		{
			if (hp != role.info.hp)
			{
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
					white.width = bar.width;
					white.alpha = 1;
				}
				setStar();
			}
		}
		
		private function setStar():void
		{
			if (role.info.hero && role.info.heroInfo.expStar != star)
			{
				if (star > 0)
				{
					this.addChild(star1);
				}
				else if (star1.parent)
				{
					star1.parent.removeChild(star1);
				}
				if (star > 1)
				{
					this.addChild(star2);
				}
				else if (star2.parent)
				{
					star2.parent.removeChild(star2);
				}
				if (star > 2)
				{
					this.addChild(star3);
				}
				else if (star3.parent)
				{
					star3.parent.removeChild(star3);
				}
				if (star > 3)
				{
					this.addChild(star4);
				}
				else if (star4.parent)
				{
					star4.parent.removeChild(star4);
				}
				if (star > 4)
				{
					this.addChild(star5);
				}
				else if (star5.parent)
				{
					star5.parent.removeChild(star5);
				}
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
				else if(redType != -1)
				{
					if (redType != 2)
					{
						ColorTrans.trans(father, ColorTransType.normal);
					}
					redType = -1;
				}
				//把这个对象添加到显示列表中去
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
			else
			{
				dispose();
			}
		}
		
		/** 获取血条的宽度 **/
		private function getHpWidth():int
		{
			var i:int = int(role.model.bloodWidth * hp / hpMax);
			if (i < 0)
			{
				return 0;
			}
			else if (i > role.model.bloodWidth)
			{
				i = role.model.bloodWidth;
			}
			return i;
		}
	}
}