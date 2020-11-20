package cn.wjj.upgame.tools 
{
	import cn.wjj.display.MPoint;
	import cn.wjj.upgame.data.CardInfoModel;
	import cn.wjj.upgame.data.RoleCardModel;
	import cn.wjj.upgame.data.UpGameData;
	import cn.wjj.upgame.engine.AIRoleMovePoint;
	import cn.wjj.upgame.engine.AIRoleMoveTool;
	import cn.wjj.upgame.engine.EDCamp;
	import cn.wjj.upgame.engine.UpGameAStar;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 给出地图里的一个像素坐标,然后类会根据要召唤的卡牌类型,返回一个
	 * 合理的格子坐标来作为移动的最终目标
	 * 
	 * 返回坐标,可能是修正后的坐标,或者是真实坐标
	 * 返回空,标识不能放置卡牌
	 * @author GaGa
	 */
	public class ReleaseCardRevisePoint 
	{
		/** 不可放置区域 **/
		public static var rectLeft1:MPoint = MPoint.instance(0, 21);
		public static var rectLeft2:MPoint = MPoint.instance(18, 33);
		public static var rectRight1:MPoint = MPoint.instance(19, 21);
		public static var rectRight2:MPoint = MPoint.instance(35, 33);
		
		private static var liveLeft:Boolean = true;
		private static var liveRight:Boolean = true;
		
		public function ReleaseCardRevisePoint() { }
		
		/**
		 * 当是翻转模式的时候,还是以翻转模式来运行
		 * @param	u
		 * @param	x		像素坐标(不用在中心点,会修正到中心点)
		 * @param	y		像素坐标(不用在中心点,会修正到中心点)
		 * @param	id		卡牌ID
		 * @return
		 */
		public static function revise(u:UpGame, x:int, y:int, id:int):MPoint
		{
			var cardInfo:CardInfoModel = UpGameData.cardInfo.getItem("card_id", id);
			if (cardInfo)
			{
				if (cardInfo.CardType != 2)
				{
					var card:RoleCardModel = UpGameData.cardRole.getItem("card_id", cardInfo.SummonCharacter);
				}
				if (cardInfo.CardType == 2 || card)
				{
					var astar:UpGameAStar = u.engine.astar;
					if (x < astar.hotStartX)
					{
						x = astar.hotStartX;
					}
					else if (x > astar.hotEndX)
					{
						x = astar.hotEndX - 1;
					}
					if (y < astar.hotStartY)
					{
						y = astar.hotStartY;
					}
					else if (y > astar.hotEndY)
					{
						y = astar.hotEndY - 1;
					}
					var tileX:int = int((x - astar.offsetX) / astar.tileWidth);
					var tileY:int = int((y - astar.offsetY) / astar.tileHeight);
					if (cardInfo.CardType != 2)
					{
						if (card.CardType == 1 || card.CardType == 3 || card.CardType == 5 || card.CardType == 6)
						{
							//先判断是否在我放区域内,如果是就ok
							if (tileY <= rectLeft2.y)
							{
								//修正到可放区域
								var camp:EDCamp;
								if (liveLeft == false) liveLeft = true;
								if (liveRight == false) liveRight = true;
								if (u.modeTurn)
								{
									camp = u.engine.camp1;
								}
								else
								{
									camp = u.engine.camp2;
								}
								if (camp.towerLeft == null || camp.towerLeft.isLive == false)
								{
									liveRight = false;
								}
								if (camp.towerRight == null || camp.towerRight.isLive == false)
								{
									liveLeft = false;
								}
								if (liveLeft && liveRight)
								{
									if (tileY <= rectRight2.y)
									{
										tileY = rectRight2.y + 1;
									}
								}
								else if (liveLeft == false && liveRight == false)
								{
									if (tileY < rectRight1.y)
									{
										tileY = rectRight1.y;
									}
								}
								else if (liveLeft == false)
								{
									//右边的区域
									if (tileX < (rectRight1.x + int((rectRight2.x - rectRight1.x) / 4)))
									{
										if (tileX >= rectRight1.x)
										{
											tileX = rectRight1.x - 1;
										}
										if (tileY <= rectRight1.y)
										{
											tileY = rectRight1.y + 1;
										}
									}
									else
									{
										if (tileY < rectRight2.y)
										{
											tileY = rectRight2.y;
										}
									}
								}
								else
								{
									//左边的区域
									if (tileX < (rectLeft1.x + int((rectLeft2.x - rectLeft1.x) * 3 / 4)))
									{
										//在中间区域的左侧的只用动Y坐标
										if (tileY <= rectLeft2.y)
										{
											tileY = rectLeft2.y + 1;
										}
									}
									else
									{
										if (tileX <= rectLeft2.x)
										{
											tileX = rectLeft2.x + 1;
										}
										if (tileY < rectRight1.y)
										{
											tileY = rectRight1.y;
										}
									}
								}
							}
						}
					}
					//外加一层保护
					if (tileX < 0)
					{
						tileX = 0;
					}
					else if (tileX >= astar.width)
					{
						tileX = astar.width - 1;
					}
					if (tileY < 0)
					{
						tileY = 0;
					}
					else if (tileY >= astar.height)
					{
						tileY = astar.height - 1;
					}
					//添加值比较
					var add:int = 1;
					if (cardInfo.CardType == 2)
					{
						return MPoint.instance(tileX, tileY);
					}
					else
					{
						switch (card.CardType) 
						{
							case 1://部队
							case 5://英雄
								if (card.FlyingHeight == 0)
								{
									//陆地,非移动区域不可放,选出一个位置来
									var aiPoint:AIRoleMovePoint;
									if (u.modeTurn)
									{
										tileX = astar.width - tileX - 1;
										tileY = astar.height - tileY - 1;
									}
									if (astar.map[tileX][tileY] == 1)
									{
										aiPoint = AIRoleMoveTool.gotoBlankGrid(u.engine.astar, tileX, tileY, 1);
										if (aiPoint)
										{
											if (u.modeTurn)
											{
												return MPoint.instance(astar.width - aiPoint.x - 1, astar.height - aiPoint.y - 1);
											}
											return MPoint.instance(aiPoint.x, aiPoint.y);
										}
									}
									else
									{
										if (u.modeTurn)
										{
											return MPoint.instance(astar.width - tileX - 1, astar.height - tileY - 1);
										}
										return MPoint.instance(tileX, tileY);
									}
								}
								else
								{
									//空中,我放区域都可以放
									return MPoint.instance(tileX, tileY);
								}
								break;
							case 3://建筑
								//圆圈的找,找100个格子外
								if (u.modeTurn)
								{
									tileX = astar.width - tileX - 1;
									tileY = astar.height - tileY - 1;
								}
								if (putBuilder(astar, tileX, tileY, card.Mass, u.modeTurn))
								{
									if (u.modeTurn)
									{
										return MPoint.instance(astar.width - tileX - 1, astar.height - tileY - 1);
									}
									return MPoint.instance(tileX, tileY);
								}
								else
								{
									//向外找圈圈内合适的点
									var list:Array, length:int, i:int;
									for (var range:int = 1; range < 30; range++)
									{
										list = AIRoleMoveTool.getAroundList(astar, tileX, tileY, 1, range, true);
										if (list)
										{
											//可以将list里靠近目标点的先运算
											
											sortList(list, tileX, tileY);
											i = 0;
											length = list.length;
											while (i < length)
											{
												if (putBuilder(astar, list[i], list[i + 1], card.Mass, u.modeTurn))
												{
													if (u.modeTurn)
													{
														return MPoint.instance(astar.width - list[i] - 1, astar.height - list[i + 1] - 1);
													}
													return MPoint.instance(list[i], list[i + 1]);
												}
												i = i + 2;
											}
										}
									}
								}
								return null;
								break;
							//case 2://法术
							//case 4://主塔,副塔
							//	break;
						}
					}
				}
			}
			return null;
		}
		
		/**
		 * 算出距离tileX 和 tileY 距离的排序
		 * @param	list
		 * @param	tileX
		 * @param	tileY
		 * @return
		 */
		private static function sortList(list:Array, tileX:int, tileY:int):Array
		{
			var dist:Number, x:int, y:int, i:int, j:int, c:int, cx:int, cy:int;
			var distArray:Array = new Array();
			var length:int = list.length;
			if (length > 2)
			{
				i = 0;
				while (i < length)
				{
					x = tileX - list[i];
					y = tileY - list[i + 1];
					dist = x * x + y * y;
					distArray.push(dist);
					i = i + 2;
				}
				//排序distArray
				i = 0;
				length = distArray.length;
				for (i = 1; i < length; i++)
				{
					c = i -1;
					if (distArray[c] > distArray[i])
					{
						//向前一直找,找到一个合适的位置,交换位置
						j = c - 1;
						while (j >= 0)
						{
							if (distArray[j] > distArray[i])
							{
								c = j;
								j--;
							}
							else
							{
								break;
							}
						}
						//堆栈操作,而非交换操作
						//先抽出下面的内容
						
						cx = distArray[i];
						distArray.splice(i, 1);
						distArray.splice(c, 0, cx);
						cx = list[i * 2];
						cy = list[i * 2 + 1];
						list.splice(i * 2, 2);
						list.splice(c * 2, 0, cx, cy);
						//j 和 i 进行交换位置
						/*
						cx = distArray[i];
						distArray[i] = distArray[c];
						distArray[c] = cx;
						cx = list[i * 2];
						cy = list[i * 2 + 1];
						list[i * 2] = list[c * 2];
						list[i * 2 + 1] = list[c * 2 + 1];
						list[c * 2] = cx;
						list[c * 2 + 1] = cy;
						*/
					}
				}
			}
			return list;
		}
		
		/**
		 * 放的格子重点
		 * @param	tileX
		 * @param	tileY
		 * @param	size
		 * @return	返回是否可以放置
		 */
		private static function putBuilder(astar:UpGameAStar, tileX:int, tileY:int, size:int, modeTurn:Boolean):Boolean
		{
			if (astar.map[tileX][tileY] == 1 || canInTile(astar, tileX, tileY, modeTurn) == false)
			{
				return false;
			}
			var x:int, y:int;
			/*
			if (modeTurn)
			{
				x = int(tileX * astar.tileWidth - (astar.tileWidth / 2) + astar.offsetX);
				y = int(tileY * astar.tileHeight - (astar.tileHeight / 2) + astar.offsetY);
			}
			else
			{
			*/
				x = int(tileX * astar.tileWidth + (astar.tileWidth / 2) + astar.offsetX);
				y = int(tileY * astar.tileHeight + (astar.tileHeight / 2) + astar.offsetY);
			/*
			}
			*/
			x = int(x - (astar.tileWidth * size / 2));
			y = int(y - (astar.tileHeight * size / 2));
			var width:int = astar.tileWidth * size;
			var height:int = astar.tileHeight * size;
			//修改AStar
			var mapX:int, mapY:int;
			var startX:int = int((x - astar.offsetX) / astar.tileWidth) - 1;
			var startY:int = int((y - astar.offsetY) / astar.tileHeight) - 1;
			var maxX:int = int((x + width - astar.offsetX) / astar.tileWidth) + 2;
			var maxY:int = int((y + height - astar.offsetY) / astar.tileHeight) + 2;
			if (startX < 0 || startY < 0 || maxX > astar.width || maxY > astar.height)
			{
				return false;
			}
			for (mapX = startX; mapX < maxX; mapX++)
			{
				for (mapY = startY; mapY < maxY; mapY++)
				{
					if (astar.map[mapX][mapY] == 1 || canInTile(astar, mapX, mapY, modeTurn) == false)
					{
						return false;
					}
				}
			}
			return true;
		}
		
		/**
		 * 查看位置是否是可以放置建筑物的位置
		 * @param	tileX
		 * @param	tileY
		 * @return	true		不可以放下
		 */
		private static function canInTile(astar:UpGameAStar, tileX:int, tileY:int, modeTurn:Boolean):Boolean
		{
			if (modeTurn)
			{
				tileX = astar.width - tileX - 1;
				tileY = astar.height - tileY - 1;
			}
			if (tileY <= rectLeft2.y)
			{
				//修正到可放区域
				if (liveLeft && liveRight)
				{
					if (tileY <= rectRight2.y)
					{
						return false;
					}
				}
				else if (liveLeft == false && liveRight == false)
				{
					if (tileY < rectRight1.y)
					{
						return false;
					}
				}
				else if (liveLeft == false)
				{
					//右边的区域
					if (tileX > (rectRight1.x + int((rectRight2.x - rectRight1.x) * 3 / 4)))
					{
						if (tileY <= rectRight2.y)
						{
							return false;
						}
					}
					else
					{
						if (tileX >= rectRight1.x)
						{
							return false;
						}
						if (tileY < rectLeft1.y)
						{
							return false;
						}
					}
				}
				else
				{
					//左边的区域
					if (tileX < (rectLeft1.x + int((rectLeft2.x - rectLeft1.x) * 3 / 4)))
					{
						//在中间区域的左侧的只用动Y坐标
						if (tileY <= rectLeft2.y)
						{
							return false;
						}
					}
					else
					{
						if (tileX <= rectLeft2.x)
						{
							return false;
						}
						if (tileY < rectRight1.y)
						{
							return false;
						}
					}
				}
			}
			return true;
		}
	}
}