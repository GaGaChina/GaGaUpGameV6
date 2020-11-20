package cn.wjj.upgame.render 
{
	import cn.wjj.display.MPoint;
	import cn.wjj.display.ui2d.IU2Base;
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.upgame.common.IDisplay;
	import cn.wjj.upgame.data.CardInfoModel;
	import cn.wjj.upgame.data.RoleCardModel;
	import cn.wjj.upgame.data.SkillActiveModel;
	import cn.wjj.upgame.data.UpGameBulletInfo;
	import cn.wjj.upgame.data.UpGameData;
	import cn.wjj.upgame.data.UpGameModelInfo;
	import cn.wjj.upgame.data.UpGameSkill;
	import cn.wjj.upgame.data.UpGameSkillAction;
	import cn.wjj.upgame.data.UpGameSkillEffect;
	import cn.wjj.upgame.engine.EDRoleToolsSkinIdle;
	import cn.wjj.upgame.tools.ReleaseCardMPoint;
	import cn.wjj.upgame.UpGame;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	
	/**
	 * 显示卡牌的时候的工具类
	 * 
	 * DisplayEDLoading 与 DisplayEDCard 公用代码
	 * @author GaGa
	 */
	public class DisplayEDCardBase extends Sprite implements IDisplay
	{
		/** 维护列表子弹ID **/
		private static var bulletId:Vector.<uint> = new Vector.<uint>();
		
		/** 父引用 **/
		public var u:UpGame;
		/** 主内容显示对象 **/
		public var display:Vector.<IU2Base>;
		
		/** 卡牌ID **/
		public var id:int;
		/** 阵营 **/
		public var camp:int;
		/** AStar方格的坐标 **/
		public var tileX:int;
		/** AStar方格的坐标 **/
		public var tileY:int;
		/** 用户拖动所在格子上的像素坐标 **/
		private var _x:int;
		/** 用户拖动所在格子上的像素坐标 **/
		private var _y:int;
		/** 里面的卡片是不是镜像 **/
		public var mirror:Boolean;
		/** 模型ID **/
		public var modelId:uint;
		/** 现在的资源ID **/
		public var displayId:uint = 0;
		
		
		
		/** 模型 **/
		protected var model:UpGameModelInfo;
		/** 卡牌信息 **/
		protected var cardInfo:CardInfoModel;
		/** 角色信息 **/
		protected var cardRole:RoleCardModel;
		/** 技能的范围 **/
		private var magicRange:int = -1;
		
		/**
		 * 基类
		 * 
		 * 容器内的内容只用对应这个中心点就可以,拖放的坐标就本对象坐标
		 * @param	u
		 * @param	id		卡牌ID
		 * @param	camp	阵营
		 * @param	posX	格子坐标
		 * @param	posY	格子坐标
		 */
		public function DisplayEDCardBase(u:UpGame, id:int, camp:int, tileX:int, tileY:int)
		{
			this.u = u;
			this.id = id;
			this.camp = camp;
			cardInfo = UpGameData.cardInfo.getItem("card_id", id);
			if (cardInfo)
			{
				switch (cardInfo.CardType) 
				{
					case 1://部队
					case 3://建筑
					case 4://主塔,副塔
					case 5://英雄
						cardRole = UpGameData.cardRole.getItem("card_id", cardInfo.SummonCharacter);
						if (cardRole)
						{
							//提前获取信息
							if (u.modeTurn)
							{
								if (camp == 1)
								{
									modelId = cardRole.Cmodel2;
								}
								else
								{
									modelId = cardRole.Cmodel;
								}
							}
							else
							{
								if (camp == 1)
								{
									modelId = cardRole.Cmodel;
								}
								else
								{
									modelId = cardRole.Cmodel2;
								}
							}
							model = UpGameData.modelInfo.getItem("id", modelId);
							if (model == null)
							{
								g.log.pushLog(this, LogType._ErrorLog, "AllData UpGameModelInfo 缺少 ID : " + modelId + " 的角色模型数据");
								model = new UpGameModelInfo(UpGameData.modelInfo.getArray()[0]);
								modelId = model.id;
							}
							setXY(tileX, tileY);
						}
						break;
					case 2://法术
						var skill:SkillActiveModel = UpGameData.skillActive.getItem("id", cardInfo.SpellSkill);
						if (skill)
						{
							var action:UpGameSkillAction = UpGameData.skillAction.getItem("id", skill.actionId);
							if (action)
							{
								var skillList:Vector.<UpGameSkill> = UpGameData.skill.getList("id", skill.id);
								if (skillList.length)
								{
									/** 临时子弹上挂的技能特效 **/
									var effect:UpGameSkillEffect;
									/** 如果有子弹就挂上子弹的信息参数 **/
									if (DisplayEDCardBase.bulletId.length) DisplayEDCardBase.bulletId.length = 0;
									for each (var link:UpGameSkill in skillList)
									{
										if (link.bulletId != 0)
										{
											if (DisplayEDCardBase.bulletId.indexOf(link.bulletId) == -1)
											{
												var oBulletInfo:UpGameBulletInfo = UpGameData.bulletInfo.getItem("id", link.bulletId);
												if (oBulletInfo)
												{
													DisplayEDCardBase.bulletId.push(link.bulletId);
													effect = UpGameData.skillEffect.getItem("id", link.effectId);
													if (magicRange < effect.rangeR)
													{
														magicRange = effect.rangeR;
													}
												}
											}
										}
									}
								}
							}
						}
						setXY(tileX, tileY);
						break;
				}
			}
			else
			{
				g.log.pushLog(this, LogType._ErrorLog, "未找到卡牌:" + id);
			}
		}
		
		/**
		 * 重新设置位置
		 * @param	posX
		 * @param	posY
		 */
		public function setXY(tileX:int, tileY:int):void
		{
			if (cardInfo)
			{
				this.tileX = tileX;
				this.tileY = tileY;
				var p:MPoint = u.engine.astar.getMapPoint(tileX, tileY);
				_x = p.x;
				_y = p.y;
				p.dispose();
				if (cardInfo.SummonNumber < 2)
				{
					if (display == null)
					{
						display = g.speedFact.n_vector(IU2Base);
						if (display == null ) display = new Vector.<IU2Base>();
					}
					if (display.length == 0)
					{
						switch (cardInfo.CardType) 
						{
							case 1://部队
							case 3://建筑
							case 4://主塔,副塔
							case 5://英雄
								if (cardRole) callRoleCardXY(0, 0);
								break;
							case 2://法术
								callMagicXY(cardInfo);
								break;
						}
					}
				}
				else
				{
					if (display)
					{
						for each (var u2:IU2Base in display)
						{
							u2.dispose();
						}
						display.length = 0;
					}
					else
					{
						display = g.speedFact.n_vector(IU2Base);
						if (display == null ) display = new Vector.<IU2Base>();
					}
					var mpoint:Vector.<MPoint> = ReleaseCardMPoint.getPoint(u.engine.astar, cardInfo, 1, _x, _y);
					for each (p in mpoint)
					{
						p.x = p.x - _x;
						p.y = p.y - _y;
						switch (cardInfo.CardType) 
						{
							case 1://部队
							case 3://建筑
							case 4://主塔,副塔
							case 5://英雄
								if (cardRole) callRoleCardXY(p.x, p.y);
								break;
							case 2://法术
								callMagicXY(cardInfo);
								break;
						}
					}
				}
			}
		}
		
		/**
		 * (角色卡牌表)通过卡牌信息召唤出卡牌
		 * @param	u
		 * @param	id
		 * @param	camp
		 * @param	x			地图像素坐标
		 * @param	y			地图像素坐标
		 * @return
		 */
		private function callRoleCardXY(x:int, y:int):void
		{
			if (camp == 1)
			{
				EDRoleToolsSkinIdle.changeSkin(u, this, modelId, model.typeIdle, 270);
			}
			else
			{
				EDRoleToolsSkinIdle.changeSkin(u, this, modelId, model.typeIdle, 90);
			}
			var path:String = "assets/model/" + modelId + "/" + displayId + ".u2";
			var u2:DisplayObject = u.reader.u2(path);
			if (u2)
			{
				display.push(u2 as IU2Base);
				u2.scaleX = model.scaleX;
				u2.scaleY = model.scaleY;
				if (mirror)
				{
					if (u2.scaleX > 0)
					{
						u2.scaleX = -u2.scaleX;//要负数
					}
				}
				else if (u2.scaleX < 0)
				{
					u2.scaleX = -u2.scaleX;//要正数
				}
				if ((u2 as Object).timer)
				{
					(u2 as Object).timer.timeCore(u.engine.time.timeEngine, -1, false, false);
				}
				u2.x = x;
				u2.y = y;
				u2.alpha = 0.5;
				this.addChild(u2 as DisplayObject);
			}
		}
		
		/**
		 * 显示出法术的东西
		 * @param	id
		 * @param	x
		 * @param	y
		 */
		private function callMagicXY(info:CardInfoModel):void
		{
			this.graphics.clear();
			if (magicRange > 0)
			{
				this.graphics.lineStyle(5, 0xFFFFFF, 0.5);
				this.graphics.beginFill(0xFFFFFF, 0.4);
				this.graphics.drawCircle(0, 0, magicRange);
				this.graphics.endFill();
			}
		}
		
		/** 摧毁对象 **/
		public function dispose():void
		{
			this.graphics.clear();
			u = null;
			model = null;
			cardInfo = null;
			cardRole = null;
			if (display)
			{
				for each (var item:IU2Base in display) 
				{
					item.dispose();
				}
				g.speedFact.d_vector(IU2Base, display);
				display = null;
			}
			if (this.parent) this.parent.removeChild(this);
		}
	}
}