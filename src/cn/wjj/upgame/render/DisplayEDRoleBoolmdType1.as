package cn.wjj.upgame.render 
{
	import cn.wjj.display.filter.ColorTrans;
	import cn.wjj.display.filter.ColorTransType;
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
	public class DisplayEDRoleBoolmdType1 extends Sprite implements IDisplayBoolmd 
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
			var o:DisplayEDRoleBoolmdType1 = __f.instance() as DisplayEDRoleBoolmdType1;
			if (o == null) o = new DisplayEDRoleBoolmdType1();
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
			if (this.barFrame != null)
			{
				this.barFrame.dispose();
				this.barFrame = null;
			}
			if (this.barBg != null)
			{
				this.barBg.dispose();
				this.barBg = null;
			}
			if (this.barDel != null)
			{
				this.barDel.dispose();
				this.barDel = null;
			}
			if (this.dieFrame != null)
			{
				this.dieFrame.dispose();
				this.dieFrame = null;
			}
			if (this.dieBar != null)
			{
				this.dieBar.dispose();
				this.dieBar = null;
			}
			if (this.dieBg != null)
			{
				this.dieBg.dispose();
				this.dieBg = null;
			}
			if (this.barCenter != null)
			{
				for each (var item:SBitmap in this.barCenter) 
				{
					item.dispose();
				}
				item = null;
				this.barCenter.length = 0;
				this.barCenter = null;
			}
			if (this.type != 0) this.type = 0;
			if (this.hp != 0) this.hp = 0;
			if (this.hpMax != -1) this.hpMax = -1;
			if (this.part != 0) this.part = 0;
			if (this.partUseHp) this.partUseHp = false;
			if (this.barHeight != 0) this.barHeight = 0;
			if (this.delStartX != 0) this.delStartX = 0;
			if (this.delEndX != 0) this.delEndX = 0;
			if (this.delSpeed != 0) this.delSpeed = 0;
			if (this.delShowTime != 0) this.delShowTime = 0;
			if (this._isRefresh) this._isRefresh = false;
			if (this.hpShow) this.hpShow = false;
			if (this.hpIsShow) this.hpIsShow = false;
			if (this.hpDelShow) this.hpDelShow = false;
			if (this.hpDelIsShow) this.hpDelIsShow = false;
			__f.recover(this);
		}
		
		/** 血条所属对象 **/
		public var role:EDRole;
		/** 血条所在父级的显示对象 **/
		public var father:DisplayEDRole;
		/** (必须实底)血条背景 **/
		private var bg:SBitmap;
		/** (必须实底)血条的边框上面 **/
		private var barFrame:SBitmap;
		/** 有颜色的背景 **/
		private var barBg:SBitmap;
		/** 掉血的时候的条 **/
		private var barDel:SBitmap;
		/** 中间的条 **/
		private var barCenter:Vector.<SBitmap>;
		/** 血条类型, 1绿色(我方), 2 红色(敌方),3, 红色BOSS **/
		private var type:uint = 0;
		/** 现在的血量 **/
		private var hp:int = 0;
		/** 现在计算的最高血量 **/
		private var hpMax:int = -1;
		/** 现在有几节 **/
		private var part:uint = 0;
		/** 每一节用的是HP还是用的5像素的长度 **/
		private var partUseHp:Boolean = false;
		/** 条的高度 **/
		private var barHeight:uint = 0;
		/** HP相关的显示内容是否显示在上面 **/
		private var hpShow:Boolean = false;
		/** HP相关条是否已经添加 **/
		private var hpIsShow:Boolean = false;
		/** HP上的删除是否显示 **/
		private var hpDelShow:Boolean = false;
		/** HP相关条是否已经添加 **/
		private var hpDelIsShow:Boolean = false;
		
		/** 删除坐标的X坐标的起始点 **/
		private var delStartX:int = 0;
		private var delEndX:int = 0;
		/** 删除的速度 **/
		private var delSpeed:int = 0;
		private var delShowTime:int = 0;
		/** 是否处于刷新状态 **/
		private var _isRefresh:Boolean = false;
		/** 属于那种红, 0,无色, 1,1号红,2,2号红 **/
		private var redType:int = 0;
		/** 最多可以红多久 **/
		private var redMax:int = 0;
		
		/** 召唤生物死亡条的边框 **/
		private var dieFrame:SBitmap;
		/** 召唤生物死亡条的条 **/
		private var dieBar:SBitmap;
		/** 召唤生物死亡条的背景 **/
		private var dieBg:SBitmap;
		
		public function DisplayEDRoleBoolmdType1() { }
		
		/** 是否处于刷新状态 **/
		public function get isRefresh():Boolean 
		{
			return _isRefresh;
		}
		
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
			var temp:uint = 0;
			if (role.info.boss)
			{
				temp = 3;
			}
			else if (role.camp == 1)
			{
				temp = 1;
			}
			else
			{
				temp = 2;
			}
			if (type != temp)
			{
				type = temp;
				if (barFrame == null)
				{
					barFrame = SBitmap.instance();
					barFrame.bitmapData = DisplayEDRoleBoolmd.bg_bar;
				}
				if (bg == null)
				{
					bg = SBitmap.instance();
					bg.bitmapData = DisplayEDRoleBoolmd.bd_bg;
				}
				var item:SBitmap;
				if (DisplayEDRoleBoolmd.show_bar)
				{
					if (barCenter == null)
					{
						barCenter = new Vector.<SBitmap>();
					}
					else
					{
						for each (item in barCenter) 
						{
							item.dispose();
						}
						item = null;
						barCenter.length = 0;
					}
				}
				else if(barCenter)
				{
					for each (item in barCenter) 
					{
						item.dispose();
					}
					item = null;
					barCenter.length = 0;
					barCenter = null;
				}
				if (barBg == null) barBg = SBitmap.instance();
				if (barDel == null) barDel = SBitmap.instance();
				switch (type) 
				{
					case 1:
						barBg.bitmapData = DisplayEDRoleBoolmd.bg_type_1;
						barDel.bitmapData = DisplayEDRoleBoolmd.bg_small_del;
						break;
					case 2:
						barBg.bitmapData = DisplayEDRoleBoolmd.bg_type_2;
						barDel.bitmapData = DisplayEDRoleBoolmd.bg_small_del;
						break;
					case 3:
						barBg.bitmapData = DisplayEDRoleBoolmd.bg_type_boss;
						barDel.bitmapData = DisplayEDRoleBoolmd.bg_big_del;
						break;
				}
				barHeight = barBg.height;
				barFrame.x = -DisplayEDRoleBoolmd.bar_height;
				barFrame.y = -DisplayEDRoleBoolmd.bar_height;
				barFrame.height = DisplayEDRoleBoolmd.bar_height + DisplayEDRoleBoolmd.bar_height + barHeight;
				barFrame.width = DisplayEDRoleBoolmd.bar_height + DisplayEDRoleBoolmd.bar_height + role.model.bloodWidth;
				bg.height = barHeight;
				bg.width = role.model.bloodWidth;
			}
			hp = role.info.hp;
			setHpMax();
			setDieBar();
			if (role.dieAuto)
			{
				_isRefresh = true;
			}
		}
		
		private function setHpMax():void
		{
			var temp:int;
			var tempBitmap:SBitmap;
			if (hpMax != role.info.hpMax)
			{
				hpMax = role.info.hpMax;
				if (DisplayEDRoleBoolmd.show_bar)
				{
					//血条根据血量算出的最大节数
					var hpPart:int = Math.ceil(hpMax / 5000);
					//通过宽度算出的最大节数
					var widthPart:int = Math.ceil(role.model.bloodWidth / 9);
					for each (var item:SBitmap in barCenter) 
					{
						item.dispose();
					}
					item = null;
					barCenter.length = 0;
					var partI:int = 0;
					if (hpPart > widthPart)
					{
						part = widthPart;
						partUseHp = false;
						partI = partI + 9;
						while (partI < role.model.bloodWidth)
						{
							tempBitmap = SBitmap.instance();
							tempBitmap.bitmapData = DisplayEDRoleBoolmd.bg_bar;
							tempBitmap.x = int(partI + (DisplayEDRoleBoolmd.bar_height / 2));
							tempBitmap.width = DisplayEDRoleBoolmd.bar_height;
							tempBitmap.height = barHeight;
							barCenter.push(tempBitmap);
							partI = partI + 9;
						}
					}
					else
					{
						part = hpPart;
						partUseHp = true;
						while (++partI <= part)
						{
							temp = int(role.model.bloodWidth * 5000 * partI / hpMax + (DisplayEDRoleBoolmd.bar_height / 2));
							if (temp < role.model.bloodWidth)
							{
								tempBitmap = SBitmap.instance();
								tempBitmap.bitmapData = DisplayEDRoleBoolmd.bg_bar;
								tempBitmap.x = temp;
								tempBitmap.width = DisplayEDRoleBoolmd.bar_height;
								tempBitmap.height = barHeight;
								barCenter.push(tempBitmap);
							}
						}
					}
				}
				temp = getHpWidth();
				barBg.width = temp;
			}
		}
		
		/** 创建死亡倒计时条 **/
		private function setDieBar(isShow:Boolean = false):void
		{
			if (isShow || (role.dieAuto && role.timeDie <= 10000))
			{
				if (dieFrame == null)
				{
					dieFrame = SBitmap.instance();
					dieFrame.bitmapData = DisplayEDRoleBoolmd.bg_bar;
					this.addChild(dieFrame);
				}
				if (dieBg == null)
				{
					dieBg = SBitmap.instance();
					dieBg.bitmapData = DisplayEDRoleBoolmd.bg_die_bar;
					this.addChild(dieBg);
				}
				if (dieBar == null)
				{
					dieBar = SBitmap.instance();
					dieBar.bitmapData = DisplayEDRoleBoolmd.bd_bg;
					this.addChild(dieBar);
				}
				dieFrame.x = -DisplayEDRoleBoolmd.die_bar_height;
				dieFrame.y = -DisplayEDRoleBoolmd.die_bar_height + barHeight + DisplayEDRoleBoolmd.bar_height + 3;
				dieFrame.height = DisplayEDRoleBoolmd.die_bar_height + DisplayEDRoleBoolmd.die_bar_height + DisplayEDRoleBoolmd.bg_die_bar.height;
				dieFrame.width = DisplayEDRoleBoolmd.die_bar_height + DisplayEDRoleBoolmd.die_bar_height + role.model.bloodWidth;
				dieBg.height = DisplayEDRoleBoolmd.bg_die_bar.height;
				dieBg.y = barHeight + DisplayEDRoleBoolmd.bar_height + 3;
			}
			else
			{
				if (dieFrame)
				{
					dieFrame.dispose();
					dieFrame = null;
				}
				if (dieBar)
				{
					dieBar.dispose();
					dieBar = null;
				}
				if (dieBg)
				{
					dieBg.dispose();
					dieBg = null;
				}
			}
		}
		
		/** 当最大血亮变化的时候设置 **/
		public function changeMax():void
		{
			delShowTime = role.u.engine.time.timeEngine + 2000;
			_isRefresh = true;
			setHpMax();
		}
		
		/** 血条有变化 **/
		public function changeHP(red:Boolean):void
		{
			if (red) redMax = 0;
			//记录del的开始点和结束点
			delShowTime = role.u.engine.time.timeEngine + 2000;
			_isRefresh = true;
			if (this.parent == null) father.addChild(this);
			var temp:int = barBg.width;
			if (temp > delEndX)
			{
				delEndX = temp;
			}
			hp = role.info.hp;
			delStartX = getHpWidth();
			barBg.width = delStartX;
			if (delEndX != delStartX)
			{
				delSpeed = int((delEndX - delStartX) / 10);
				if (delSpeed < 2) delSpeed = 2;
				barDel.x = delStartX;
				barDel.width = delEndX - delStartX;
				hpDelShow = true;
			}
			else if (barDel.parent)
			{
				delEndX = 0;
				delStartX = 0;
				hpDelShow = false;
			}
		}
		
		/** 是否需要刷新 **/
		public function refresh():void
		{
			if (role && role.isLive)
			{
				if (delEndX != delStartX)
				{
					delEndX = delEndX - delSpeed;
					if (delEndX > delStartX)
					{
						barDel.x = delStartX;
						barDel.width = delEndX - delStartX;
					}
					else if (hpDelShow)
					{
						delEndX = 0;
						delStartX = 0;
						hpDelShow = false;
					}
				}
				if (role.isLive == false || delShowTime < role.u.engine.time.timeEngine)
				{
					//移除这个血条
					delEndX = 0;
					delStartX = 0;
					if (role.dieAuto)
					{
						_isRefresh = true;
					}
					hpShow = false;
				}
				else
				{
					_isRefresh = true;
					hpShow = true;
				}
				if (father)
				{
					var item:SBitmap;
					if (hpShow || (role.dieAuto && role.timeDie <= 10000))
					{
						if (hpShow)
						{
							if (hpIsShow == false)
							{
								this.addChild(barFrame);
								this.addChild(bg);
								this.addChild(barBg);
							}
							if (hpDelShow)
							{
								if (hpDelIsShow == false)
								{
									this.addChildAt(barDel, 2);
									hpDelIsShow = true;
								}
							}
							else if (hpDelIsShow)
							{
								barDel.parent.removeChild(barDel);
								hpDelIsShow = false;
							}
							if (hpIsShow == false && barCenter)
							{
								for each (item in barCenter) 
								{
									this.addChild(item);
								}
							}
							hpIsShow = true;
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
						}
						else if (hpIsShow)
						{
							barFrame.parent.removeChild(barFrame);
							bg.parent.removeChild(bg);
							barBg.parent.removeChild(barBg);
							if (hpDelIsShow)
							{
								barDel.parent.removeChild(barDel);
								hpDelIsShow = false;
							}
							if (barCenter)
							{
								for each (item in barCenter)
								{
									item.parent.removeChild(item);
								}
							}
							hpIsShow = false;
							ColorTrans.trans(father, ColorTransType.normal);
							redType = -1;
						}
						//制作死亡条倒计时,是不是要检查条是否加进去
						if (role.dieAuto)
						{
							setDieBar(true);
							dieBg.width = getDieWidth();
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
					else if (this.parent)
					{
						this.parent.removeChild(this);
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
		
		/** 获取死亡条的宽度 **/
		private function getDieWidth():int
		{
			var temp:int = int(role.model.bloodWidth * role.timeDie / role.dieAuto);
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