package cn.wjj.upgame.tools 
{
	import cn.wjj.display.MPoint;
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.upgame.engine.EDRole;
	import cn.wjj.upgame.engine.UpGameAStar;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 获取巡逻的路径
	 * @author GaGa
	 */
	public class MovePhysPatrol 
	{
		/** 计算坐标的时候富余出来的弹性坐标 **/
		public static var space:int = 5;
		/** 计算坐标的时候富余出来的弹性坐标 **/
		public static var spaceMin:int = 3;
		/** 临时变量 **/
		private static var u:UpGame;
		private static var astar:UpGameAStar;
		/** 人物对面的塔是否死了 **/
		private static var dieUp:Boolean;
		/** 人物我方的塔是否死了 **/
		private static var dieDown:Boolean;
		//计算使用的坐标,把坐标全换到下面的方位来计算,少写一套上方移动的规则
		private static var x:int, y:int, goX:int, goY:int, temp:int, width:int, height:int;
		
		public function MovePhysPatrol() { }
		
		/**
		 * 巡逻
		 * ed.ai.pathFind
		 * public var pathFind:Vector.<AIRoleMovePoint> = new Vector.<AIRoleMovePoint>();
		 * 
		 * 让路的时候要和本身的高度和宽度产生关系,否则很难绕桩
		 * 
		 * 
		 * @param	ed
		 * @param	point	MPoint,Point如果没有会设置point.x = 9999999
		 * @return
		 */
		public static function getPoint(ed:EDRole, point:Object):void
		{
			if (ed.isLive)
			{
				if (u != ed.u)
				{
					u = ed.u;
					astar = u.engine.astar;
				}
				if (dieUp == false) dieUp = true;
				if (dieDown == false) dieDown = true;
				if (ed.camp == 1)
				{
					x = ed.x;
					y = ed.y;
					//查询对面的副塔是否存在
					if (x < 0)
					{
						if (u.engine.camp1.towerLeft && u.engine.camp1.towerLeft.isLive)
						{
							dieDown = false;
						}
						if (u.engine.camp2.towerRight && u.engine.camp2.towerRight.isLive)
						{
							dieUp = false;
						}
					}
					else
					{
						if (u.engine.camp1.towerRight && u.engine.camp1.towerRight.isLive)
						{
							dieDown = false;
						}
						if (u.engine.camp2.towerLeft && u.engine.camp2.towerLeft.isLive)
						{
							dieUp = false;
						}
					}
				}
				else
				{
					x = -ed.x;
					y = -ed.y;
					//查询对面的副塔是否存在
					if (ed.x < 0)
					{
						if (u.engine.camp1.towerLeft && u.engine.camp1.towerLeft.isLive)
						{
							dieUp = false;
						}
						if (u.engine.camp2.towerRight && u.engine.camp2.towerRight.isLive)
						{
							dieDown = false;
						}
					}
					else
					{
						if (u.engine.camp1.towerRight && u.engine.camp1.towerRight.isLive)
						{
							dieUp = false;
						}
						if (u.engine.camp2.towerLeft && u.engine.camp2.towerLeft.isLive)
						{
							dieDown = false;
						}
					}
				}
				if (ed.hit_h)
				{
					width = Math.ceil(ed.hit_h / 2);
					height = Math.ceil(ed.hit_r / 2);
				}
				else
				{
					width = ed.hit_r;
					height = ed.hit_r;
				}
				if (width < 0)
				{
					width = 0;
					g.log.pushLog(MovePhysPatrol, LogType._ErrorLog, "出现配置错误");
				}
				//开始处理空中单位的寻路目标
				if (ed.info.typeProperty == 2)
				{
					goX = x;
					goY = y;
					//直接去副塔
					if (dieUp)
					{
						//需要包围主塔
						if (y > astar.moveTower6.bottom + height)
						{
							goY = astar.moveTower6.bottom + height;
						}
						else if (y < astar.moveTower6.y - height)
						{
							goY = astar.moveTower6.y - height;
						}
						if (x < 0)
						{
							if (x < astar.moveTower6.x - width)
							{
								goX = astar.moveTower6.x - width;
							}
						}
						else
						{
							if (x > astar.moveTower6.right + width)
							{
								goX = astar.moveTower6.right + width;
							}
						}
					}
					else
					{
						if (y > astar.moveTower5.bottom + height)
						{
							goY = astar.moveTower5.bottom + height;
						}
						else if (y < astar.moveTower5.y - height)
						{
							goY = astar.moveTower5.y - height;
						}
						if (x < 0)
						{
							if (x <= astar.moveTower5.x - width)
							{
								goX = astar.moveTower5.x - width;
							}
							else if (x > astar.moveTower5.right + width)
							{
								goX = astar.moveTower5.right + width;
							}
						}
						else
						{
							if (x <= astar.moveTower4.x - width)
							{
								goX = astar.moveTower4.x - width;
							}
							else if (x > astar.moveTower4.right + width)
							{
								goX = astar.moveTower4.right + width;
							}
						}
					}
				}
				else
				{
					//处理地面单位的寻路
					if (x < 0)
					{
						//左边
						if (y > astar.moveTower1.y - height)
						{
							if (dieDown)
							{
								//中场下面位置
								if (x < astar.moveTower1.x - MovePhysPatrol.space - width)
								{
									//人在左边,走到右边去
									goX = astar.moveTower1.x - MovePhysPatrol.spaceMin - width;
								}
								else if (x > astar.moveTower1.right + MovePhysPatrol.space + width)
								{
									//人在右边,走到左边去
									goX = astar.moveTower1.right + MovePhysPatrol.spaceMin + width;
								}
								else
								{
									//人位于中间位置,向上走就好了,走到rTop的最下面部分
									goX = x;
								}
								goY = astar.moveCenterCenter.bottom + MovePhysPatrol.space + height;
							}
							else
							{
								//副塔以下位置
								temp = astar.moveTower1.width / 2 + astar.moveTower1.x;
								if (x < temp)
								{
									goX = astar.moveTower1.x - MovePhysPatrol.space - width;
								}
								else
								{
									goX = astar.moveTower1.right + MovePhysPatrol.space + width;
								}
								if (y > astar.moveTower3.bottom + MovePhysPatrol.space + height)
								{
									goY = astar.moveTower3.bottom + MovePhysPatrol.spaceMin + height;
								}
								else if (y > astar.moveTower3.y)
								{
									goY = astar.moveTower3.y - MovePhysPatrol.spaceMin;
								}
								else if (y > astar.moveTower1.bottom)
								{
									goY = astar.moveTower1.bottom - MovePhysPatrol.spaceMin;
								}
								else
								{
									goY = astar.moveTower1.y - MovePhysPatrol.space - height;
								}
							}
						}
						else if (y > astar.moveCenterCenter.y - height)
						{
							//中场下面位置
							if (x < astar.moveTower1.x + width)
							{
								//人在左边,走到右边去
								goX = astar.moveTower1.x + MovePhysPatrol.spaceMin + width;
							}
							else if (x > astar.moveTower1.right - width)
							{
								//人在右边,走到左边去
								goX = astar.moveTower1.right - MovePhysPatrol.spaceMin - width;
							}
							else
							{
								//人位于中间位置,向上走就好了,走到rTop的最下面部分
								goX = x;
							}
							if (y > astar.moveCenterCenter.bottom + MovePhysPatrol.space + height)
							{
								goY = astar.moveCenterCenter.bottom + MovePhysPatrol.spaceMin + height;
							}
							else if (y > astar.moveCenterCenter.bottom)
							{
								goY = astar.moveCenterCenter.bottom;
							}
							else
							{
								goY = astar.moveCenterCenter.y - MovePhysPatrol.spaceMin - height;
							}
						}
						else
						{
							if (dieUp)
							{
								//Y离主塔超过三格距离,就会到中间的路上去
								if (x < astar.moveTower5.right + MovePhysPatrol.space)
								{
									//一直走到astar.moveTower5.bottom, 才向右走
									if (x < astar.moveTower5.x)//回中路
									{
										//人在左边,走到右边去
										goX = astar.moveTower5.x + MovePhysPatrol.space;
										if (y > astar.moveTower6.bottom + MovePhysPatrol.space + height)
										{
											goY = astar.moveTower6.bottom + MovePhysPatrol.spaceMin + height;
										}
										else if (y < astar.moveTower6.y - MovePhysPatrol.space - height)
										{
											goY = astar.moveTower6.y - MovePhysPatrol.spaceMin - height;
										}
										else
										{
											goY = y;
										}
									}
									else
									{
										//中路行走逻辑
										if (y > astar.moveTower6.bottom + MovePhysPatrol.space + height)
										{
											goX = x;
											goY = astar.moveTower6.bottom + MovePhysPatrol.spaceMin + height;
											
										}
										else if (y < astar.moveTower6.y - MovePhysPatrol.space - height)
										{
											goX = x;
											goY = astar.moveTower6.y - MovePhysPatrol.spaceMin - height;
										}
										else
										{
											if (x < astar.moveTower6.x - MovePhysPatrol.space - width)
											{
												goX = astar.moveTower6.x - MovePhysPatrol.spaceMin - width;
											}
											goY = y;
										}
									}
								}
								else
								{
									if (y > astar.moveTower5.bottom + MovePhysPatrol.space + height)
									{
										//回中路
										if (x < astar.moveTower5.x)
										{
											//人在左边,走到右边去
											goX = astar.moveTower5.x + MovePhysPatrol.spaceMin;
										}
										else if (x > astar.moveTower5.right)
										{
											//人在右边,走到左边去
											goX = astar.moveTower5.right - MovePhysPatrol.spaceMin;
										}
										else
										{
											//人位于中间位置,向上走就好了,走到rTop的最下面部分
											goX = x;
										}
										goY = astar.moveTower5.bottom + height;
									}
									//Y离主塔3格距离内,靠近主塔的找主塔
									else
									{
										//需要包围主塔
										if (x < astar.moveTower6.x - MovePhysPatrol.space - width)
										{
											goX = astar.moveTower6.x - MovePhysPatrol.spaceMin - width;
										}
										else
										{
											goX = x;
										}
										if (y > astar.moveTower6.bottom + MovePhysPatrol.space + height)
										{
											goY = astar.moveTower6.bottom + MovePhysPatrol.spaceMin + height;
										}
										else if(y < astar.moveTower6.y - MovePhysPatrol.space - height)
										{
											goY = astar.moveTower6.y - MovePhysPatrol.spaceMin - height;
										}
										else
										{
											goY = y;
										}
									}
								}
							}
							//副塔在
							else
							{
								//回中路
								if (x < astar.moveTower5.x - MovePhysPatrol.space - width)
								{
									//人在左边,走到右边去
									goX = astar.moveTower5.x - MovePhysPatrol.spaceMin - width;
								}
								else if (x > astar.moveTower5.right + MovePhysPatrol.space + width)
								{
									//人在右边,走到左边去
									goX = astar.moveTower5.right + MovePhysPatrol.spaceMin + width;
								}
								else
								{
									//人位于中间位置,向上走就好了,走到rTop的最下面部分
									goX = x;
								}
								//Y在副塔下面,去主路,找副塔
								if (y > astar.moveTower5.bottom + MovePhysPatrol.space + height)
								{
									goY = astar.moveTower5.bottom + MovePhysPatrol.spaceMin + height;
								}
								//Y在副塔上面,找主塔
								else if (y < astar.moveTower5.y - MovePhysPatrol.space - height)
								{
									goY = astar.moveTower5.y - MovePhysPatrol.spaceMin - height;
								}
								//向副塔靠拢
								else
								{
									goY = y;
								}
							}
						}
					}
					else
					{
						//右边
						if (y > astar.moveTower2.y - height)
						{
							if (dieDown)
							{
								//中场下面位置
								if (x < astar.moveTower2.x - MovePhysPatrol.space - width)
								{
									//人在左边,走到右边去
									goX = astar.moveTower2.x - MovePhysPatrol.spaceMin - width;
								}
								else if (x > astar.moveTower2.right + MovePhysPatrol.space + width)
								{
									//人在右边,走到左边去
									goX = astar.moveTower2.right + MovePhysPatrol.spaceMin + width;
								}
								else
								{
									//人位于中间位置,向上走就好了,走到rTop的最下面部分
									goX = x;
								}
								goY = astar.moveCenterCenter.bottom + MovePhysPatrol.space + height;
							}
							else
							{
								//副塔以下位置
								temp = astar.moveTower2.width / 2 + astar.moveTower2.x;
								if (x < temp)
								{
									goX = astar.moveTower2.x - MovePhysPatrol.space - width;
								}
								else
								{
									goX = astar.moveTower2.right + MovePhysPatrol.space + width;
								}
								if (y > astar.moveTower3.bottom + MovePhysPatrol.space + height)
								{
									goY = astar.moveTower3.bottom + MovePhysPatrol.spaceMin + height;
								}
								else if (y > astar.moveTower3.y)
								{
									goY = astar.moveTower3.y - MovePhysPatrol.spaceMin;
								}
								else if (y > astar.moveTower2.bottom)
								{
									goY = astar.moveTower2.bottom - MovePhysPatrol.spaceMin;
								}
								else
								{
									goY = astar.moveTower2.y - MovePhysPatrol.space - height;
								}
							}
						}
						else if (y > astar.moveCenterCenter.y - height)
						{
							//中场下面位置
							if (x < astar.moveTower2.x + width)
							{
								//人在左边,走到右边去
								goX = astar.moveTower2.x + MovePhysPatrol.spaceMin + width;
							}
							else if (x > astar.moveTower2.right - width)
							{
								//人在右边,走到左边去
								goX = astar.moveTower2.right - MovePhysPatrol.spaceMin - width;
							}
							else
							{
								//人位于中间位置,向上走就好了,走到rTop的最下面部分
								goX = x;
							}
							if (y > astar.moveCenterCenter.bottom + MovePhysPatrol.space + height)
							{
								goY = astar.moveCenterCenter.bottom + MovePhysPatrol.spaceMin + height;
							}
							else if (y > astar.moveCenterCenter.bottom)
							{
								goY = astar.moveCenterCenter.bottom;
							}
							else
							{
								goY = astar.moveCenterCenter.y - MovePhysPatrol.spaceMin - height;
							}
						}
						else
						{
							if (dieUp)
							{
								//Y离主塔超过三格距离,就会到中间的路上去
								if (x > astar.moveTower4.x - MovePhysPatrol.space)
								{
									//一直走到astar.moveTower5.bottom, 才向右走
									if (x > astar.moveTower4.right)//回中路
									{
										//人在左边,走到右边去
										goX = astar.moveTower4.right - MovePhysPatrol.space;
										if (y > astar.moveTower6.bottom + MovePhysPatrol.space + height)
										{
											goY = astar.moveTower6.bottom + MovePhysPatrol.spaceMin + height;
										}
										else if (y < astar.moveTower6.y - MovePhysPatrol.space - height)
										{
											goY = astar.moveTower6.y - MovePhysPatrol.spaceMin - height;
										}
										else
										{
											goY = y;
										}
									}
									else
									{
										//中路行走逻辑
										if (y > astar.moveTower6.bottom + MovePhysPatrol.space + height)
										{
											goX = x;
											goY = astar.moveTower6.bottom + MovePhysPatrol.spaceMin + height;
											
										}
										else if (y < astar.moveTower6.y - MovePhysPatrol.space - height)
										{
											goX = x;
											goY = astar.moveTower6.y - MovePhysPatrol.spaceMin - height;
										}
										else
										{
											if (x > astar.moveTower6.right + MovePhysPatrol.space + width)
											{
												goX = astar.moveTower6.right + MovePhysPatrol.spaceMin + width;
											}
											goY = y;
										}
									}
								}
								else
								{
									if (y > astar.moveTower4.bottom + MovePhysPatrol.space + height)
									{
										//回中路
										if (x > astar.moveTower4.x)
										{
											//人在左边,走到右边去
											goX = astar.moveTower4.x + MovePhysPatrol.spaceMin;
										}
										else if (x > astar.moveTower4.right)
										{
											//人在右边,走到左边去
											goX = astar.moveTower4.right - MovePhysPatrol.spaceMin;
										}
										else
										{
											//人位于中间位置,向上走就好了,走到rTop的最下面部分
											goX = x;
										}
										goY = astar.moveTower4.bottom + height;
									}
									//Y离主塔3格距离内,靠近主塔的找主塔
									else
									{
										//需要包围主塔
										if (x > astar.moveTower6.right + MovePhysPatrol.space + width)
										{
											goX = astar.moveTower6.right + MovePhysPatrol.spaceMin + width;
										}
										else
										{
											goX = x;
										}
										if (y > astar.moveTower6.bottom + MovePhysPatrol.space + height)
										{
											goY = astar.moveTower6.bottom + MovePhysPatrol.spaceMin + height;
										}
										else if(y < astar.moveTower6.y - MovePhysPatrol.space - height)
										{
											goY = astar.moveTower6.y - MovePhysPatrol.spaceMin - height;
										}
										else
										{
											goY = y;
										}
									}
								}
							}
							//副塔在
							else
							{
								//回中路
								if (x < astar.moveTower4.x - MovePhysPatrol.space - width)
								{
									//人在左边,走到右边去
									goX = astar.moveTower4.x - MovePhysPatrol.spaceMin - width;
								}
								else if (x > astar.moveTower4.right + MovePhysPatrol.space + width)
								{
									//人在右边,走到左边去
									goX = astar.moveTower4.right + MovePhysPatrol.spaceMin + width;
								}
								else
								{
									//人位于中间位置,向上走就好了,走到rTop的最下面部分
									goX = x;
								}
								//Y在副塔下面,去主路,找副塔
								if (y > astar.moveTower4.bottom + MovePhysPatrol.space + height)
								{
									goY = astar.moveTower4.bottom + MovePhysPatrol.spaceMin + height;
								}
								//Y在副塔上面,找主塔
								else if (y < astar.moveTower4.y - MovePhysPatrol.space - height)
								{
									goY = astar.moveTower4.y - MovePhysPatrol.spaceMin - height;
								}
								//向副塔靠拢
								else
								{
									goY = y;
								}
							}
						}
					}
				}
				//翻转上方的坐标
				if (ed.camp == 2)
				{
					goX = -goX;
					goY = -goY;
				}
				if (goX == ed.x && goY == ed.y)
				{
					if (point.x != 9999999) point.x = 9999999;
				}
				else
				{
					if (point.x != goX) point.x = goX;
					if (point.y != goY) point.y = goY;
				}
			}
			else
			{
				if (point.x != 9999999) point.x = 9999999;
			}
		}
		
		/**
		 * 查看是否在桥的2头,并且走不到一块去~~>_<, 射程也打不到桥那头
		 * @param	role		我方
		 * @param	target		对手
		 * @param	range		射程
		 * @param	dist		距离
		 */
		public static function notMoveToTarget(astar:UpGameAStar, role:EDRole, target:EDRole, range:uint, dist:int):Boolean
		{
			if ((role.y < 0 && target.y > 0) || (role.y > 0 && target.y < 0))
			{
				//如果射程过大也不行
				if (range < dist)
				{
					return true;
				}
				//都要在过道中间
				if (role.x < astar.moveCenterLeft.right || role.x > astar.moveCenterRight.x)
				{
					return true;
				}
				else if (role.x > astar.moveCenterCenter.x && role.x < astar.moveCenterCenter.right)
				{
					return true;
				}
				if (target.x < astar.moveCenterLeft.right || target.x > astar.moveCenterRight.x)
				{
					return true;
				}
				else if (target.x > astar.moveCenterCenter.x && target.x < astar.moveCenterCenter.right)
				{
					return true;
				}
			}
			return false;
		}
	}
}