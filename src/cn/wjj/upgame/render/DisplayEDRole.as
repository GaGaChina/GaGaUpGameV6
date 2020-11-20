package cn.wjj.upgame.render 
{
	import cn.wjj.display.filter.ColorTrans;
	import cn.wjj.display.ui2d.U2Bitmap;
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.factory.FTextField;
	import cn.wjj.gagaframe.client.speedfact.SShape;
	import cn.wjj.upgame.common.IDisplay;
	import cn.wjj.upgame.common.IDisplayBoolmd;
	import cn.wjj.upgame.common.StatusTypeRole;
	import cn.wjj.upgame.engine.AIRoleMovePoint;
	import cn.wjj.upgame.engine.AIRoleSkill;
	import cn.wjj.upgame.engine.EDRole;
	import cn.wjj.upgame.UpGame;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	/**
	 * 所有角色原始类型
	 * 
	 * @author GaGa
	 */
	public class DisplayEDRole extends Sprite implements IDisplay 
	{
		/** 父引用 **/
		public var u:UpGame;
		/** 在驱动里的 **/
		public var ed:EDRole;
		/** 血条 **/
		public var boolmd:IDisplayBoolmd;
		/** 主内容显示对象 **/
		public var display:Object;
		/** 现在的资源ID **/
		public var displayId:uint = 0;
		/** 角色影子 **/
		public var shadow:U2Bitmap;
		/** Buff的控制对象 **/
		public var buff:DisplayEDRoleBuff;
		/** 是否已经被攻击了 **/
		public var damage:Boolean = false;
		
		/** 模拟模型下绘制一些区域 **/
		public var debugSprite:SShape;
		/** 写出现在的坐标点 **/
		public var debugText:FTextField;
		/** DEBUG的文本 **/
		private static var textFormat:TextFormat = new TextFormat(null, 12, 0xFFFFFF, true, null, null, null, null, null, 2, 2, null, null);
		
		/** 设置对象的形象 **/
		public function DisplayEDRole(u:UpGame, ed:EDRole) 
		{
			this.u = u;
			this.ed = ed;
			switch (ed.info.hpDisplayType) 
			{
				case 0://OK 0-不显示
					break;
				case 1://OK 1-被攻击时显示
					boolmd = DisplayEDRoleBoolmdType1.instance();
					boolmd.init(ed, this);
					break;
				case 2://OK 2-总是显示
					boolmd = DisplayEDRoleBoolmdType2.instance();
					boolmd.init(ed, this);
					break;
				case 3://OK 3-固定显示在屏幕最顶端
					if (u.engine.methodTopBoolmd != null)
					{
						u.engine.methodTopBoolmd(ed);
					}
					else
					{
						boolmd = DisplayEDRoleBoolmdType2.instance();
						boolmd.init(ed, this);
					}
					break;
				case 4://Ok (始终显示等级)受伤后永久显示血条, 一般角色
					boolmd = DisplayEDRoleBoolmdType4.instance();
					boolmd.init(ed, this);
					break;
				case 5://OK (显示等级)激活后永久显示血条,总部老家,显示血量
					boolmd = DisplayEDRoleBoolmdType5.instance();
					boolmd.init(ed, this);
					break;
				case 6://OK (显示等级)总是显示血条,其他建筑
					boolmd = DisplayEDRoleBoolmdType6.instance();
					boolmd.init(ed, this);
					break;
				case 7://OK (不显示等级,但显示图标)总是显示,并显示血量,箭塔
					boolmd = DisplayEDRoleBoolmdType7.instance();
					boolmd.init(ed, this);
					break;
				case 8://OK (显示等级)总是显示血条,下面还有星星
					boolmd = DisplayEDRoleBoolmdType8.instance();
					boolmd.init(ed, this);
					break;
			}
		}
		
		/**
		 * 测试模式的情况下
		 * 1.绘制视野
		 * 2.绘制敏感区域
		 * 3.击中的区域
		 * 4.绘制路径
		 */
		public function showDebug():void
		{
			if (ed && ed.isLive)
			{
				if (debugSprite == null) debugSprite = SShape.instance();
				debugSprite.graphics.clear();
				debugSprite.graphics.endFill();
				//绘制视野
				debugSprite.graphics.lineStyle(1, 0x0033FF, 0.5);
				debugSprite.graphics.drawCircle(0, 0, ed.info.rangeView);
				//绘制敏感区域
				debugSprite.graphics.lineStyle(1, 0xFF6600, 0.5);
				debugSprite.graphics.drawCircle(0, 0, ed.info.rangeGuard);
				debugSprite.graphics.endFill();
				//鼠标区域
				debugSprite.graphics.lineStyle(1, 0x00FFFF, 0.5);
				debugSprite.graphics.beginFill(0x00FFFF, 0.2);
				if (ed.model.dragType == 1)
				{
					debugSprite.graphics.drawRect(ed.model.dragX, ed.model.dragY, ed.model.dragWidth, ed.model.dragHeight);
				}
				else
				{
					debugSprite.graphics.drawCircle(ed.model.dragX, ed.model.dragY, 1);
					debugSprite.graphics.drawCircle(ed.model.dragX, ed.model.dragY, ed.model.dragWidth);
				}
				//击中区域
				debugSprite.graphics.lineStyle(1, 0xFF0000, 0.5);
				debugSprite.graphics.beginFill(0xFF0000, 0.2);
				if (ed.hit_h)
				{
					debugSprite.graphics.drawRect(ed.hit_r_x, ed.hit_r_y, ed.hit_r, ed.hit_h);
				}
				else
				{
					debugSprite.graphics.drawCircle(ed.hit_r_x, ed.hit_r_y, ed.hit_r);
				}
				//脚下,0,0点
				debugSprite.graphics.lineStyle(1, 0xFF00FF, 1);
				debugSprite.graphics.beginFill(0xFF00FF, 0.8);
				debugSprite.graphics.drawCircle(0, 0, 3);
				//攻击点
				debugSprite.graphics.endFill();
				debugSprite.graphics.lineStyle(0, 0, 0);
				if (ed.hitX1 != 0 && ed.hitY1 != 0)
				{
					debugSprite.graphics.beginFill(0xFF0000, 1);
					debugSprite.graphics.drawCircle(ed.hitX1, ed.hitY1, 3);
				}
				if (ed.hitX2 != 0 && ed.hitY2 != 0)
				{
					debugSprite.graphics.beginFill(0x660099, 1);
					debugSprite.graphics.drawCircle(ed.hitX2, ed.hitY2, 3);
				}
				//路径
				if (ed.ai.move.enginePhys)
				{
					if (ed.info.typeProperty != 3)
					{
						if (ed.ai.move.enginePhys.inNeed)
						{
							debugSprite.graphics.endFill();
							debugSprite.graphics.lineStyle(2, 0xFF3300, 0.5);
							debugSprite.graphics.moveTo(0, 0);
							debugSprite.graphics.lineTo(ed.ai.move.enginePhys.dragNeedX, ed.ai.move.enginePhys.dragNeedY);
						}
						if (ed.ai.move.enginePhys.dragPhysX || ed.ai.move.enginePhys.dragPhysY)
						{
							debugSprite.graphics.endFill();
							debugSprite.graphics.lineStyle(2, 0x0000FF, 0.5);
							debugSprite.graphics.moveTo(0, 0);
							debugSprite.graphics.lineTo(ed.ai.move.enginePhys.dragPhysX, ed.ai.move.enginePhys.dragPhysY);
						}
						if (ed.ai.move.enginePhys.dragGoX || ed.ai.move.enginePhys.dragGoY)
						{
							debugSprite.graphics.endFill();
							debugSprite.graphics.lineStyle(2, 0xFF00FF, 0.5);
							debugSprite.graphics.moveTo(0, 0);
							debugSprite.graphics.lineTo(ed.ai.move.enginePhys.dragGoX - ed.x, ed.ai.move.enginePhys.dragGoY - ed.y);
						}
					}
				}
				var path:Vector.<AIRoleMovePoint>;
				var point:AIRoleMovePoint;
				if (ed.ai.move.engineAStar)
				{
					path = ed.ai.move.engineAStar.path;
					point = ed.ai.move.engineAStar.point;
				}
				else if (ed.ai.move.enginePhys)
				{
					//path = ed.ai.move.enginePhys.path;
					//point = ed.ai.move.enginePhys.point;
				}
				if ((path && path.length) || point)
				{
					debugSprite.graphics.endFill();
					if (ed.camp == 1)
					{
						debugSprite.graphics.lineStyle(2, 0x0000FF, 0.5);
					}
					else
					{
						debugSprite.graphics.lineStyle(2, 0xFF3300, 0.5);
					}
					debugSprite.graphics.moveTo(0, 0);
					if (point)
					{
						debugSprite.graphics.lineTo(int(point.x - ed.x), int(point.y - ed.y));
						debugSprite.graphics.drawCircle(int(point.x - ed.x), int(point.y - ed.y), 3);
						debugSprite.graphics.moveTo(int(point.x - ed.x), int(point.y - ed.y));
					}
					var pl:int = path.length;
					var pathItem:AIRoleMovePoint;
					while (--pl > -1)
					{
						pathItem = path[pl];
						debugSprite.graphics.lineTo(int(pathItem.x - ed.x), int(pathItem.y - ed.y));
						debugSprite.graphics.drawCircle(int(pathItem.x - ed.x), int(pathItem.y - ed.y), 3);
						debugSprite.graphics.moveTo(int(pathItem.x - ed.x), int(pathItem.y - ed.y));
					}
					debugSprite.graphics.endFill();
				}
				this.addChild(debugSprite);
				var x:int = int((ed.x - ed.u.engine.astar.info.offsetX) / ed.u.engine.astar.info.tileWidth);
				var y:int = int((ed.y - ed.u.engine.astar.info.offsetY) / ed.u.engine.astar.info.tileHeight);
				if (debugText == null) debugText = FTextField.instance();
				debugText.setTextFormat(DisplayEDRole.textFormat);
				g.language.setFieldFont(debugText, "MSYH_Bold");
				debugText.defaultTextFormat = DisplayEDRole.textFormat;
				
				var textStr:String = "ID:<font color='#00FF00'>";
				if (ed && ed.info)
				{
					if (ed.info.serverId)
					{
						textStr += ed.info.serverId;
					}
					else
					{
						textStr += ed.info.id;
					}
				}
				textStr += "</font> " + x + " : " + y + " - " + int(ed.x * 1000) / 1000 + ":" + int(ed.y * 1000) / 1000;
				
				if (ed.hitX1 != 0 && ed.hitY1 != 0)
				{
					textStr += " T1:" + ed.hitX1 + ":" + ed.hitY1;
				}
				if (ed.hitX2 != 0 && ed.hitY2 != 0)
				{
					textStr += " T2:" + ed.hitX2 + ":" + ed.hitY2;
				}
				//把技能的情况输出
				textStr += "<br />技:";
				for (var s:int = 0; s < ed.ai.aiSkill.length; s++) 
				{
					var skill:AIRoleSkill = ed.ai.aiSkill[s];
					//正在播放技能 FF0000 技能好 00FF00 技能CD 999999
					if (skill)
					{
						if (ed.ai.skillFire == skill)
						{
							textStr += "<font color='#FF0000'>释放</font> ";
						}
						else if(skill.timeLength >= skill.cd)
						{
							textStr += "<font color='#00FF00'>就绪</font> ";
						}
						else
						{
							textStr += "<font color='#999999'>" + int((skill.cd - skill.timeLength) / 1000) + "</font> ";
						}
					}
					else
					{
						textStr += "<font color='#999999'>无</font> ";
					}
				}
				//仇恨列表
				if (ed.isLive && ed.activate)
				{
					var i:int = 0;
					for each (var info:Object in ed.ai.hatred.list) 
					{
						i++;
						if (i < 10)
						{
							textStr += "<br />0" + i + ":";
						}
						else
						{
							textStr += "<br />" + i + ":";
						}
						textStr += "ID:<font color='#00FF00'>";
						if (info.ed && info.ed.info)
						{
							if (info.ed.info.serverId)
							{
								textStr += info.ed.info.serverId;
							}
							else
							{
								textStr += info.ed.info.id;
							}
						}
						textStr += "</font> <font color='#FF0000'>" + info.hatred + "</font>";
					}
				}
				debugText.multiline = true;
				debugText.htmlText = textStr;
				debugText.type = TextFieldType.DYNAMIC;
				debugText.mouseEnabled = false;
				debugText.width = debugText.textWidth + 8;
				debugText.height = debugText.textHeight + 8;
				debugText.x = -int(debugText.width / 2);
				debugText.y = 6;
				debugText.cacheAsBitmap = true;
				this.addChild(debugText);
			}
			else
			{
				hideDebug();
			}
		}
		
		/** 摧毁移除Debug模式 **/
		public function hideDebug():void
		{
			if (debugSprite)
			{
				debugSprite.dispose();
				debugSprite = null;
			}
			if (debugText)
			{
				debugText.dispose();
				debugText = null;
			}
		}
		
		/** 根据参数来设置这个对象 **/
		public function setSkin():void
		{
			if (ed.model.shadowType && ed.status != StatusTypeRole.appear)
			{
				if (shadow == null)
				{
					shadow = U2Bitmap.instance();
					u.reader.bitmap("assets/model/img/shadow/" + ed.model.shadowType + ".png", shadow);
					if (shadow.bitmapData == null) u.reader.bitmap("assets/model/img/shadow/1.png", shadow);
					shadow.setOffsetInfo( -int(shadow.width / 2), -int(shadow.height / 2), 1, 0, ed.model.shadowScaleX, ed.model.shadowScaleY);
					shadow.setSizeInfo(x, y);
					u.reader.map.layer_floorEffect.addChild(shadow);
				}
			}
			else if(shadow)
			{
				shadow.dispose();
				shadow = null;
			}
			if (ed.displayId != displayId)
			{
				displayId = ed.displayId;
				var path:String = "assets/model/" + ed.model.id + "/" + displayId + ".u2";
				var pathDisplay:DisplayObject = u.reader.u2(path);
				if (pathDisplay)
				{
					if (display)
					{
						display.dispose();
						display = null;
					}
					display = pathDisplay;
					display.scaleX = ed.model.scaleX;
					display.scaleY = ed.model.scaleY;
				}
				if (display && display.timer)
				{
					if (ed.displayStartTime == -1)
					{
						if (ed.displayChangeTime)
						{
							ed.displayChangeTime = false;
							display.timer.timeCore(u.engine.time.timeGame, u.engine.time.timeGame, true, false, true);
						}
						else
						{
							display.timer.timeCore(u.engine.time.timeGame, u.engine.time.timeGame, true, false);
						}
					}
					else
					{
						if (ed.displayChangeTime)
						{
							ed.displayChangeTime = false;
							display.timer.timeCore(u.engine.time.timeGame, ed.displayStartTime, true, false, true);
						}
						else
						{
							display.timer.timeCore(u.engine.time.timeGame, ed.displayStartTime, true, false);
						}
					}
				}
			}
			else if (display && ed.displayChangeTime)
			{
				ed.displayChangeTime = false;
				if ((display as Object).timer)
				{
					if (ed.displayStartTime == -1)
					{
						display.timer.timeCore(u.engine.time.timeGame, u.engine.time.timeGame, true, false, true);
					}
					else
					{
						display.timer.timeCore(u.engine.time.timeGame, ed.displayStartTime, true, false, true);
					}
				}
			}
			if (display)
			{
				if (ed.displayMirror)
				{
					if (display.scaleX > 0) display.scaleX = -display.scaleX;//要负数
				}
				else if (display.scaleX < 0)
				{
					display.scaleX = -display.scaleX;//要正数
				}
				if (display.timer)
				{
					switch (ed.status) 
					{
						case StatusTypeRole.move:
						case StatusTypeRole.patrol:
							if (display.timer._speed != ed.info.speedScale)
							{
								display.timer.speed = ed.info.speedScale;
							}
							display.timer.timeCore(u.engine.time.timeGame, -1, false, true);
							break;
						case StatusTypeRole.attack:
						case StatusTypeRole.skill1:
						case StatusTypeRole.skill2:
						case StatusTypeRole.skill3:
						case StatusTypeRole.skill4:
							if (display.timer._speed != ed.info.skillScale)
							{
								display.timer.speed = ed.info.skillScale;
							}
							display.timer.timeCore(u.engine.time.timeGame, -1, false, true);
							break;
						case StatusTypeRole.appear:
							if (ed.displayScale)
							{
								display.timer.timeCore(u.engine.time.timeGame, -1, false, true);
							}
							break;
						default:
							display.timer.timeCore(u.engine.time.timeGame, -1, false, false);
					}
				}
				if (display.parent != this) addChild(display as DisplayObject);
			}
			setXY();
		}
		
		public function setXY():void
		{
			if (u.modeTurn)
			{
				if (x != int(-ed.x) || y != int(-ed.y))
				{
					x = int(-ed.x);
					if (damage)
					{
						damage = false;
						y = int(-ed.y - 3);
					}
					else
					{
						y = int(-ed.y);
					}
					if (shadow)
					{
						shadow.setSizeInfo(x, y);
					}
				}
			}
			else if (x != int(ed.x) || y != int(ed.y))
			{
				x = int(ed.x);
				if (damage)
				{
					damage = false;
					y = int(ed.y - 3);
				}
				else
				{
					y = int(ed.y);
				}
				if (shadow)
				{
					shadow.setSizeInfo(x, y);
				}
			}
		}
		
		/** 摧毁对象 **/
		public function dispose():void
		{
			ColorTrans.holdRemove(this, false);
			u = null;
			if (damage) damage = false;
			if (display)
			{
				display.dispose();
				display = null;
			}
			if (shadow)
			{
				shadow.dispose();
				shadow = null;
			}
			if (boolmd)
			{
				boolmd.dispose();
				boolmd = null;
			}
			if (buff)
			{
				buff.dispose();
				buff = null;
			}
			ed = null;
			hideDebug();
			if (this.parent) this.parent.removeChild(this);
		}
	}
}