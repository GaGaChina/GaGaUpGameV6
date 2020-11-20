package cn.wjj.upgame.tools 
{
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.upgame.common.StatusTypeRole;
	import cn.wjj.upgame.engine.EDRole;
	import cn.wjj.upgame.engine.UpGameAStar;
	import cn.wjj.upgame.UpGame;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 物理引擎的前期工作
	 * 
	 * 1.先把建筑阻挡运算在物理引擎内,叠加到所有物体上.
	 * 2.把互相有碰撞的形成一个统一的群体,进行全面的物理推理运算
	 * 3.剩余的部分才可以进行行走的运算
	 * 
	 * @author GaGa
	 */
	public class MovePhysPush
	{
		/** 递归的速度 **/
		private static var recursion:int;
		/** 递归的数量 **/
		private static var recursionLength:int;
		/** 临时记录值 **/
		private static var min:int;
		/** 临时记录值 **/
		private static var type:int;
		/** 遍历的数组长度 **/
		private static var l:int;
		/** 临时记录的区域 **/
		private static var rect:Rectangle;
		
		/** 临时算碰撞的时候所用距离 **/
		private static var ax:Number;
		private static var ay:Number;
		private static var bx:Number;
		private static var by:Number;
		private static var dx:Number;
		private static var dy:Number;
		
		private static var width:Number;
		private static var height:Number;
		
		/** ab之间的碰撞体距离 **/
		private static var ab_hit_dist:uint;
		/** 碰撞的时候ab之间的距离 **/
		private static var ab_dist:Number;
		/** 击飞的弧度 **/
		private static var r:Number;
		
		private static var outMax:uint = 20;
		private static var outRun:Number;
		
		/** 添加多少质量可以推动 **/
		private static var weightAdd:int = 10;
		/** 添加多少质量可以推动 **/
		private static var weightSame:Boolean;
		
		/** 缓存的坐标 **/
		private static var ap:Point = new Point();
		/** 是否缓存了坐标 **/
		private static var apHas:Boolean = false;
		
		public function MovePhysPush() { }
		
		/**
		 * 开始对需要强制碰撞相关的物品进行运算
		 * @param	u
		 */
		public static function start(u:UpGame):void
		{
			recursion = 0;
			recursionLength = u.engine.playerList.length;
			for each (var role:EDRole in u.engine.playerList) 
			{
				if (role.isLive && role.x < 1000000 && role.x > -1000000)
				{
					if (role.hitScale != 1 && role.hitScaleTime < u.engine.time.timeGame)
					{
						role.hitScale = 1;
					}
					//预处理巡逻
					if (role.status == StatusTypeRole.patrol || role.status == StatusTypeRole.move)
					{
						if (role.ai.move.enginePhys.target)
						{
							if (apHas == false) apHas = true;
							if (ap.x != role.ai.move.enginePhys.target.x) ap.x = role.ai.move.enginePhys.target.x;
							if (ap.y != role.ai.move.enginePhys.target.y) ap.y = role.ai.move.enginePhys.target.y;
						}
						else if (role.ai.move.enginePhys.targetX != 9999999 || role.ai.move.enginePhys.targetY != 9999999)
						{
							if (apHas == false) apHas = true;
							if (ap.x != role.ai.move.enginePhys.targetX) ap.x = role.ai.move.enginePhys.targetX;
							if (ap.y != role.ai.move.enginePhys.targetY) ap.y = role.ai.move.enginePhys.targetY;
						}
						else if (role.ai.move.enginePhys.patrolPointTime != role.u.engine.time.timeGame)
						{
							role.ai.move.enginePhys.patrolPointTime = u.engine.time.timeGame;
							MovePhysPatrol.getPoint(role, ap);
							if (role.ai.move.enginePhys.patrolPoint.x != ap.x) role.ai.move.enginePhys.patrolPoint.x = ap.x;
							if (role.ai.move.enginePhys.patrolPoint.y != ap.y) role.ai.move.enginePhys.patrolPoint.y = ap.y;
							if (ap.x == 9999999)
							{
								if (apHas) apHas = false;
							}
							else
							{
								if (apHas == false) apHas = true;
							}
						}
						else
						{
							if (apHas == false) apHas = true;
							if (ap.x != role.ai.move.enginePhys.patrolPoint.x) ap.x = role.ai.move.enginePhys.patrolPoint.x;
							if (ap.y != role.ai.move.enginePhys.patrolPoint.y) ap.y = role.ai.move.enginePhys.patrolPoint.y;
						}
					}
					else if (apHas)
					{
						apHas = false;
					}
					if (role.ai.move.enginePhys.dragPhysX) role.ai.move.enginePhys.dragPhysX = 0;
					if (role.ai.move.enginePhys.dragPhysY) role.ai.move.enginePhys.dragPhysY = 0;
					//先查询地图上不可移动的点
					if (role.info.typeProperty == 1)
					{
						runNeedMove(role, u.engine.astar);
					}
					else if (role.ai.move.enginePhys.inNeed)
					{
						role.ai.move.enginePhys.inNeed = false;
						if (role.ai.move.enginePhys.dragNeedX != 0) role.ai.move.enginePhys.dragNeedX = 0;
						if (role.ai.move.enginePhys.dragNeedY != 0) role.ai.move.enginePhys.dragNeedY = 0;
					}
				}
			}
			for each (role in u.engine.playerList) 
			{
				if (role.isLive && (role.info.typeProperty == 1 || role.info.typeProperty == 2) && role.x < 1000000 && role.x > -1000000)
				{
					runPhys(u, role);
				}
				recursion++;
			}
		}
		
		/**
		 * 地图上现成的不可移动区域,如果撞上,先移动这些区域
		 */
		private static function runNeedMove(role:EDRole, astar:UpGameAStar):void
		{
			var a:Array, i:int;
			if (role.ai.move.enginePhys.inNeed) role.ai.move.enginePhys.inNeed = false;
			ax = role.x + role.hit_r_x;
			ay = role.y + role.hit_r_y;
			if (role.hit_h)
			{
				width = role.hit_r / 2 * role.hitScale;
				height = role.hit_h / 2 * role.hitScale;
				ax = width + ax;
				ay = height + ay;
			}
			else
			{
				width = role.hit_r * role.hitScale;
				height = role.hit_r * role.hitScale;
			}
			//查看是否在屏幕外
			if (ax - width < astar.hotStartX || ax + width > astar.hotEndX || ay - height < astar.hotStartY || ay + height > astar.hotEndY)
			{
				role.ai.move.enginePhys.inNeed = true;
				if (min != 99999999) min = 99999999;
				if (min > astar.hotStartX - ax + width)
				{
					min = int(astar.hotStartX - ax + width);
					if(min == 0)
					{
						role.ai.move.enginePhys.dragNeedX = 100;
					}
					else
					{
						role.ai.move.enginePhys.dragNeedX = astar.hotStartX - ax + width;
					}
					if (role.ai.move.enginePhys.dragNeedY) role.ai.move.enginePhys.dragNeedY = 0;
				}
				if (min > ax + width - astar.hotEndX)
				{
					min = int(ax + width - astar.hotEndX);
					if(min == 0)
					{
						role.ai.move.enginePhys.dragNeedX = -100;
					}
					else
					{
						role.ai.move.enginePhys.dragNeedX = astar.hotEndX - ax - width;
					}
					if (role.ai.move.enginePhys.dragNeedY) role.ai.move.enginePhys.dragNeedY = 0;
				}
				if (min > astar.hotStartY - ay + height)
				{
					min = int(astar.hotStartY - ay + height);
					if(min == 0)
					{
						role.ai.move.enginePhys.dragNeedY = 100;
					}
					else
					{
						role.ai.move.enginePhys.dragNeedY = astar.hotStartY - ay + height;
					}
					if (role.ai.move.enginePhys.dragNeedX) role.ai.move.enginePhys.dragNeedX = 0;
				}
				if (min > ay + height - astar.hotEndY)
				{
					min = int(ay + height - astar.hotEndY);
					if(min == 0)
					{
						role.ai.move.enginePhys.dragNeedY = 100;
					}
					else
					{
						role.ai.move.enginePhys.dragNeedY = astar.hotEndY - ay - height;
					}
					if (role.ai.move.enginePhys.dragNeedX) role.ai.move.enginePhys.dragNeedX = 0;
				}
			}
			else
			{
				/*
				if (l != astar.moveOther.length) l = astar.moveOther.length;
				for (i = 0; i < l; i++)
				{
					rect = astar.moveOther[i];
					a = astar.moveOtherInfo[i];
					//false, true, false, true
					//up:Boolean, down:Boolean, left:Boolean, right:Boolean
					//可以贴边处理
					//矩形,圆形一套算法
					if (ax + width > rect.x && ax - width < rect.right && ay + height > rect.y && ay - height < rect.bottom)
					{
						role.ai.move.enginePhys.inNeed = true;
						if (min != 99999999) min = 99999999;
						if (a[0] && min > ay + height - rect.y)
						{
							min = int(ay + height - rect.y);
							if (apHas)
							{
								if (ap.y < (rect.height / 2 + rect.y))
								{
									if (role.ai.move.enginePhys.dragNeedY != -100) role.ai.move.enginePhys.dragNeedY = -100;
								}
								else if (role.ai.move.enginePhys.dragNeedY != -5)
								{
									role.ai.move.enginePhys.dragNeedY = -5;
								}
							}
							else
							{
								if (role.y < (rect.height / 2 + rect.y))
								{
									if (role.ai.move.enginePhys.dragNeedY != -100) role.ai.move.enginePhys.dragNeedY = -100;
								}
								else if (role.ai.move.enginePhys.dragNeedY != -5)
								{
									role.ai.move.enginePhys.dragNeedY = -5;
								}
							}
							if (a[2] && a[3])//可以左右
							{
								if (apHas)
								{
									if (ap.x < (rect.width / 2 + rect.x))
									{
										if (role.ai.move.enginePhys.dragNeedX != -100) role.ai.move.enginePhys.dragNeedX = -100;
									}
									else if (role.ai.move.enginePhys.dragNeedX != 100)
									{
										role.ai.move.enginePhys.dragNeedX = 100;
									}
								}
								else
								{
									if (role.x < (rect.width / 2 + rect.x))
									{
										if (role.ai.move.enginePhys.dragNeedX != -100) role.ai.move.enginePhys.dragNeedX = -100;
									}
									else if (role.ai.move.enginePhys.dragNeedX != 100)
									{
										role.ai.move.enginePhys.dragNeedX = 100;
									}
								}
							}
							else if (a[2])
							{
								if (role.ai.move.enginePhys.dragNeedX != -100) role.ai.move.enginePhys.dragNeedX = -100;
							}
							else if (a[3])
							{
								if (role.ai.move.enginePhys.dragNeedX != 100) role.ai.move.enginePhys.dragNeedX = 100;
							}
						}
						if (a[1] && min > rect.bottom - ay + height)
						{
							min = int(rect.bottom - ay + height);
							if (apHas)
							{
								if (ap.y > (rect.height / 2 + rect.y))
								{
									role.ai.move.enginePhys.dragNeedY = 100;
								}
								else
								{
									role.ai.move.enginePhys.dragNeedY = 5;
								}
							}
							else
							{
								if (role.y > (rect.height / 2 + rect.y))
								{
									role.ai.move.enginePhys.dragNeedY = 100;
								}
								else
								{
									role.ai.move.enginePhys.dragNeedY = 5;
								}
							}
							if (a[2] && a[3])//可以左右
							{
								if (apHas)
								{
									if (ap.x < (rect.width / 2 + rect.x))
									{
										role.ai.move.enginePhys.dragNeedX = -100;
									}
									else
									{
										role.ai.move.enginePhys.dragNeedX = 100;
									}
								}
								else
								{
									if (role.x < (rect.width / 2 + rect.x))
									{
										role.ai.move.enginePhys.dragNeedX = -100;
									}
									else
									{
										role.ai.move.enginePhys.dragNeedX = 100;
									}
								}
							}
							else if (a[2])
							{
								role.ai.move.enginePhys.dragNeedX = -100;
							}
							else if (a[3])
							{
								role.ai.move.enginePhys.dragNeedX = 100;
							}
						}
						if (a[2] && min > ax + width - rect.x)
						{
							min = int(ax + width - rect.x);
							if (apHas)
							{
								if (ap.x < (rect.width / 2 + rect.x))
								{
									role.ai.move.enginePhys.dragNeedX = -100;
								}
								else
								{
									role.ai.move.enginePhys.dragNeedX = -5;
								}
							}
							else
							{
								if (role.x < (rect.width / 2 + rect.x))
								{
									role.ai.move.enginePhys.dragNeedX = -100;
								}
								else
								{
									role.ai.move.enginePhys.dragNeedX = -5;
								}
							}
							if (a[0] && a[1])//可以上下
							{
								if (apHas)
								{
									if (ap.y < (rect.height / 2 + rect.y))
									{
										role.ai.move.enginePhys.dragNeedY = -100;
									}
									else
									{
										role.ai.move.enginePhys.dragNeedY = 100;
									}
								}
								else
								{
									if (role.y < (rect.height / 2 + rect.y))
									{
										role.ai.move.enginePhys.dragNeedY = -100;
									}
									else
									{
										role.ai.move.enginePhys.dragNeedY = 100;
									}
								}
							}
							else if (a[2])
							{
								role.ai.move.enginePhys.dragNeedY = -100;
							}
							else if (a[3])
							{
								role.ai.move.enginePhys.dragNeedY = 100;
							}
						}
						if (a[3] && min > rect.right - ax + width)
						{
							min = int(rect.right - ax + width);
							if (apHas)
							{
								if (ap.x > (rect.width / 2 + rect.x))
								{
									role.ai.move.enginePhys.dragNeedX = 100;
								}
								else
								{
									role.ai.move.enginePhys.dragNeedX = 5;
								}
							}
							else
							{
								if (role.x > (rect.width / 2 + rect.x))
								{
									role.ai.move.enginePhys.dragNeedX = 100;
								}
								else
								{
									role.ai.move.enginePhys.dragNeedX = 5;
								}
							}
							if (a[0] && a[1])//可以上下
							{
								if (apHas)
								{
									if (ap.y < (rect.height / 2 + rect.y))
									{
										role.ai.move.enginePhys.dragNeedY = -100;
									}
									else
									{
										role.ai.move.enginePhys.dragNeedY = 100;
									}
								}
								else
								{
									if (role.y < (rect.height / 2 + rect.y))
									{
										role.ai.move.enginePhys.dragNeedY = -100;
									}
									else
									{
										role.ai.move.enginePhys.dragNeedY = 100;
									}
								}
							}
							else if (a[2])
							{
								role.ai.move.enginePhys.dragNeedY = -100;
							}
							else if (a[3])
							{
								role.ai.move.enginePhys.dragNeedY = 100;
							}
						}
						break;
					}
				}
				*/
				for each (rect in astar.moveAll)
				{
					if (ax + width > rect.x && ax - width < rect.right && ay + height > rect.y && ay - height < rect.bottom)
					{
						if (role.ai.move.enginePhys.inNeed == false) role.ai.move.enginePhys.inNeed = true;
						min = 99999999;
						if (min > ay + height - rect.y)//在区域上面
						{
							min = int(ay + height - rect.y);
							if (type != 1) type = 1;
						}
						if (min > rect.bottom - ay + height)//在区域下面
						{
							min = int(rect.bottom - ay + height);
							if (type != 2) type = 2;
						}
						if (min > ax + width - rect.x)//在区域左边
						{
							min = int(ax + width - rect.x);
							if (type != 3) type = 3;
						}
						if (min > rect.right - ax + width)
						{
							min = int(rect.right - ax + width);
							if (type != 4) type = 4;
						}
						switch (type)
						{
							case 1://在区域上面
								if (apHas)
								{
									if (ap.y < (rect.height / 2 + rect.y))//目标在区域的上面,人也在上面,向上
									{
										if (role.ai.move.enginePhys.dragNeedY != -100) role.ai.move.enginePhys.dragNeedY = -100;
									}
									else if (role.ai.move.enginePhys.dragNeedY != 10)//否则稍微向下移动一点点
									{
										role.ai.move.enginePhys.dragNeedY = 10;
									}
									if (ap.x < (rect.width / 2 + rect.x))
									{
										if (role.ai.move.enginePhys.dragNeedX != -100) role.ai.move.enginePhys.dragNeedX = -100;
									}
									else if (role.ai.move.enginePhys.dragNeedX != 100)
									{
										role.ai.move.enginePhys.dragNeedX = 100;
									}
								}
								else
								{
									if (role.y < (rect.height / 2 + rect.y))
									{
										if (role.ai.move.enginePhys.dragNeedY != -100) role.ai.move.enginePhys.dragNeedY = -100;
									}
									else if (role.ai.move.enginePhys.dragNeedY != 10)
									{
										role.ai.move.enginePhys.dragNeedY = 10;
									}
									if (role.x < (rect.width / 2 + rect.x))
									{
										if (role.ai.move.enginePhys.dragNeedX != -100) role.ai.move.enginePhys.dragNeedX = -100;
									}
									else if (role.ai.move.enginePhys.dragNeedX != 100)
									{
										role.ai.move.enginePhys.dragNeedX = 100;
									}
								}
								break;
							case 2:
								if (apHas)
								{
									if (ap.y > (rect.height / 2 + rect.y))
									{
										if (role.ai.move.enginePhys.dragNeedY != 100) role.ai.move.enginePhys.dragNeedY = 100;
									}
									else if (role.ai.move.enginePhys.dragNeedY != -10)
									{
										role.ai.move.enginePhys.dragNeedY = -10;
									}
									if (ap.x < (rect.width / 2 + rect.x))
									{
										if (role.ai.move.enginePhys.dragNeedX != -100) role.ai.move.enginePhys.dragNeedX = -100;
									}
									else if (role.ai.move.enginePhys.dragNeedX != 100)
									{
										role.ai.move.enginePhys.dragNeedX = 100;
									}
								}
								else
								{
									if (role.y > (rect.height / 2 + rect.y))
									{
										if (role.ai.move.enginePhys.dragNeedY != 100) role.ai.move.enginePhys.dragNeedY = 100;
									}
									else if (role.ai.move.enginePhys.dragNeedY != -10)
									{
										role.ai.move.enginePhys.dragNeedY = -10;
									}
									if (role.x < (rect.width / 2 + rect.x))
									{
										if (role.ai.move.enginePhys.dragNeedX != -100) role.ai.move.enginePhys.dragNeedX = -100;
									}
									else if (role.ai.move.enginePhys.dragNeedX != 100)
									{
										role.ai.move.enginePhys.dragNeedX = 100;
									}
								}
								break;
							case 3:
								if (apHas)
								{
									if (ap.x < (rect.width / 2 + rect.x))
									{
										if (role.ai.move.enginePhys.dragNeedX != -100) role.ai.move.enginePhys.dragNeedX = -100;
									}
									else if (role.ai.move.enginePhys.dragNeedX != 10)
									{
										role.ai.move.enginePhys.dragNeedX = 10;
									}
									if (ap.y < (rect.height / 2 + rect.y))
									{
										if (role.ai.move.enginePhys.dragNeedY != -100) role.ai.move.enginePhys.dragNeedY = -100;
									}
									else if (role.ai.move.enginePhys.dragNeedY != 100)
									{
										role.ai.move.enginePhys.dragNeedY = 100;
									}
								}
								else
								{
									if (role.x < (rect.width / 2 + rect.x))
									{
										if (role.ai.move.enginePhys.dragNeedX != -100) role.ai.move.enginePhys.dragNeedX = -100;
									}
									else if (role.ai.move.enginePhys.dragNeedX != 10)
									{
										role.ai.move.enginePhys.dragNeedX = 10;
									}
									if (role.y < (rect.height / 2 + rect.y))
									{
										if (role.ai.move.enginePhys.dragNeedY != -100) role.ai.move.enginePhys.dragNeedY = -100;
									}
									else if (role.ai.move.enginePhys.dragNeedY != 100)
									{
										role.ai.move.enginePhys.dragNeedY = 100;
									}
								}
								break;
							case 4:
								if (apHas)
								{
									if (ap.x > (rect.width / 2 + rect.x))
									{
										if (role.ai.move.enginePhys.dragNeedX != 100) role.ai.move.enginePhys.dragNeedX = 100;
									}
									else if (role.ai.move.enginePhys.dragNeedX != -10)
									{
										role.ai.move.enginePhys.dragNeedX = -10;
									}
									if (ap.y < (rect.height / 2 + rect.y))
									{
										if (role.ai.move.enginePhys.dragNeedY != -100) role.ai.move.enginePhys.dragNeedY = -100;
									}
									else if (role.ai.move.enginePhys.dragNeedY != 100)
									{
										role.ai.move.enginePhys.dragNeedY = 100;
									}
								}
								else
								{
									if (role.x > (rect.width / 2 + rect.x))
									{
										if (role.ai.move.enginePhys.dragNeedX != 100) role.ai.move.enginePhys.dragNeedX = 100;
									}
									else if (role.ai.move.enginePhys.dragNeedX != -10)
									{
										role.ai.move.enginePhys.dragNeedX = -10;
									}
									if (role.y < (rect.height / 2 + rect.y))
									{
										if (role.ai.move.enginePhys.dragNeedY != -100) role.ai.move.enginePhys.dragNeedY = -100;
									}
									else if (role.ai.move.enginePhys.dragNeedY != 100)
									{
										role.ai.move.enginePhys.dragNeedY = 100;
									}
								}
								break;
						}
						break;
					}
				}
			}
			if (role.ai.move.enginePhys.inNeed == false)
			{
				if (role.ai.move.enginePhys.dragNeedX != 0) role.ai.move.enginePhys.dragNeedX = 0;
				if (role.ai.move.enginePhys.dragNeedY != 0) role.ai.move.enginePhys.dragNeedY = 0;
			}
		}
		
		/** 找出全部碰撞的物体防到各自数组内,准备计算向量 **/
		private static function runPhys(u:UpGame, a:EDRole):void
		{
			var b:EDRole, c:EDRole;
			for (var i:int = recursion; i < recursionLength; i++) 
			{
				b = u.engine.playerList[i];
				if (b.isLive && a != b && a.info.typeProperty == b.info.typeProperty)
				{
					//检查和role是否有碰撞
					//圆形之间碰撞,圆方之间,方方之间
					if (a.hit_h == 0 && b.hit_h == 0)
					{
						//先改方向
						ax = a.x + a.hit_r_x;
						ay = a.y + a.hit_r_y;
						bx = b.x + b.hit_r_x;
						by = b.y + b.hit_r_y;
						dx = ax - bx;
						dy = ay - by;
						ab_hit_dist = (a.hit_r * a.hitScale) + (b.hit_r * b.hitScale);
						ab_hit_dist = ab_hit_dist * ab_hit_dist;
						ab_dist = ab_hit_dist - (dx * dx + dy * dy);
						if (ab_dist > 4)
						{
							//a -> b 的角度
							r = Math.atan2(dy, dx) + Math.PI;
							if (a.info.weight == b.info.weight)
							{
								if (weightSame == false) weightSame = true;
							}
							else if (a.info.weight < b.info.weight)
							{
								if (a.info.weight < b.info.weight - weightAdd)
								{
									//b 体积大
									if(weightSame) weightSame = false;
									//交换ab,让a的重量大
									//交换a 和 b 进行运算
									c = b;
									b = a;
									a = c;
									c = null;
									r += Math.PI;
								}
								else if (weightSame == false)
								{
									weightSame = true;
								}
							}
							else if (a.info.weight > b.info.weight)
							{
								if (a.info.weight - weightAdd > b.info.weight)
								{
									//a 体积大
									if(weightSame) weightSame = false;
								}
								else if (weightSame == false)
								{
									weightSame = true;
								}
							}
							//根据质量来设置推动的向量
							if (weightSame)
							{
								if (a.info.typeProperty == 2)
								{
									if (a.status == StatusTypeRole.patrol || a.status == StatusTypeRole.move)
									{
										if (b.status == StatusTypeRole.patrol || b.status == StatusTypeRole.move)
										{
											bx = Math.cos(r) * ab_dist / 2;
											by = Math.sin(r) * ab_dist / 2;
											ax = -bx;
											ay = -by;
										}
										else
										{
											bx = Math.cos(r) * ab_dist;
											by = Math.sin(r) * ab_dist;
											ax = 0;
											ay = 0;
										}
									}
									else
									{
										if (b.status == StatusTypeRole.patrol || b.status == StatusTypeRole.move)
										{
											ax = -Math.cos(r) * ab_dist;
											ay = -Math.sin(r) * ab_dist;
											bx = 0;
											by = 0;
										}
										else
										{
											bx = Math.cos(r) * ab_dist / 2;
											by = Math.sin(r) * ab_dist / 2;
											ax = -bx;
											ay = -by;
										}
									}
								}
								else
								{
									bx = Math.cos(r) * ab_dist / 2;
									by = Math.sin(r) * ab_dist / 2;
									runBxBy();
									ax = -bx;
									ay = -by;
								}
							}
							else
							{
								//a 质量大,质量大运动中(质量大推质量小), 质量大其他(质量小让道)
								//质量小的要让道
								bx = Math.cos(r) * ab_dist;
								by = Math.sin(r) * ab_dist;
								runBxBy();
								if (ax != 0) ax = 0;
								if (ay != 0) ay = 0;
							}
							var s:Number = ab_hit_dist / ab_dist;
							if (a.status == StatusTypeRole.patrol || a.status == StatusTypeRole.move)
							{
								if (b.status == StatusTypeRole.patrol || b.status == StatusTypeRole.move)
								{
									if (ax != 0) a.ai.move.enginePhys.dragPhysX += ax * s * 3;
									if (ay != 0) a.ai.move.enginePhys.dragPhysY += ay * s * 3;
									if (bx != 0) b.ai.move.enginePhys.dragPhysX += bx * s * 3;
									if (by != 0) b.ai.move.enginePhys.dragPhysY += by * s * 3;
								}
								else
								{
									if (ax != 0) a.ai.move.enginePhys.dragPhysX += ax * s;
									if (ay != 0) a.ai.move.enginePhys.dragPhysY += ay * s;
									if (bx != 0) b.ai.move.enginePhys.dragPhysX += bx * s * 3;
									if (by != 0) b.ai.move.enginePhys.dragPhysY += by * s * 3;
								}
							}
							else
							{
								if (b.status == StatusTypeRole.patrol || b.status == StatusTypeRole.move)
								{
									if (ax != 0) a.ai.move.enginePhys.dragPhysX += ax * s * 3;
									if (ay != 0) a.ai.move.enginePhys.dragPhysY += ay * s * 3;
									if (bx != 0) b.ai.move.enginePhys.dragPhysX += bx * s;
									if (by != 0) b.ai.move.enginePhys.dragPhysY += by * s;
								}
								else
								{
									if (ax != 0) a.ai.move.enginePhys.dragPhysX += ax * s;
									if (ay != 0) a.ai.move.enginePhys.dragPhysY += ay * s;
									if (bx != 0) b.ai.move.enginePhys.dragPhysX += bx * s;
									if (by != 0) b.ai.move.enginePhys.dragPhysY += by * s;
								}
							}
							if (a.ai.move.enginePhys.dragPhysX || a.ai.move.enginePhys.dragPhysY)
							{
								if (a.ai.move.enginePhys.inPhys == false) a.ai.move.enginePhys.inPhys = true;
							}
							else if (a.ai.move.enginePhys.inPhys)
							{
								a.ai.move.enginePhys.inPhys = false;
							}
							if (b.ai.move.enginePhys.dragPhysX || b.ai.move.enginePhys.dragPhysY)
							{
								if (b.ai.move.enginePhys.inPhys == false) b.ai.move.enginePhys.inPhys = true;
							}
							else if (b.ai.move.enginePhys.inPhys)
							{
								b.ai.move.enginePhys.inPhys = false;
							}
							if (a.ai.move.enginePhys.inNeed)
							{
								if ((a.ai.move.enginePhys.dragNeedX < 0 && a.ai.move.enginePhys.dragPhysX > 0)
								|| (a.ai.move.enginePhys.dragNeedY < 0 && a.ai.move.enginePhys.dragPhysY > 0)
								|| (a.ai.move.enginePhys.dragNeedX > 0 && a.ai.move.enginePhys.dragPhysX < 0)
								|| (a.ai.move.enginePhys.dragNeedY > 0 && a.ai.move.enginePhys.dragPhysY > 0))
								{
									a.hitScaleTime = u.engine.time.timeFrame * 4 + u.engine.time.timeGame;
									a.hitScale = 0.4;
								}
								/**
								 * b 被挤状态
								 * 		b向外挤 a向内挤
								 * 		缩小b的hit范围 , a向外挤
								 * 
								 * 
								 * 
								 */
								//a.hitScaleTime = u.engine.time.timeFrame * 4 + u.engine.time.timeGame;
								//a.hitScale = 0.4;
							}
							if (b.ai.move.enginePhys.inNeed)
							{
								if ((b.ai.move.enginePhys.dragNeedX < 0 && b.ai.move.enginePhys.dragPhysX > 0)
								|| (b.ai.move.enginePhys.dragNeedY < 0 && b.ai.move.enginePhys.dragPhysY > 0)
								|| (b.ai.move.enginePhys.dragNeedX > 0 && b.ai.move.enginePhys.dragPhysX < 0)
								|| (b.ai.move.enginePhys.dragNeedY > 0 && b.ai.move.enginePhys.dragPhysY > 0))
								{
									b.hitScaleTime = u.engine.time.timeFrame * 4 + u.engine.time.timeGame;
									b.hitScale = 0.4;
								}
								/**
								 * b 被挤状态
								 * 		b向外挤 a向内挤
								 * 		缩小b的hit范围 , a向外挤
								 */
								//b.hitScaleTime = u.engine.time.timeFrame * 4 + u.engine.time.timeGame;
								//b.hitScale = 0.4;
							}
						}
					}
					else
					{
						g.log.pushLog(MovePhysPush, LogType._ErrorLog, "未实现本算法");
					}
				}
			}
		}
		
		/** 通过算法对bx和by进行处理 **/
		private static function runBxBy():void
		{
			var s:Number = bx / by;
			if (s < 0) s = -s;
			if (s > 0.5 && s < 1.5)
			{
				//在45度的时候取90度
				//是翻转X轴还是Y轴
			}
			else
			{
				//在90度的时候取45度
				if (bx < 0)
				{
					if (by < 0)
					{
						if (bx < by)
						{
							by = bx;
						}
						else
						{
							bx = by;
						}
					}
					else
					{
						if (-bx > by)
						{
							by = -bx;
						}
						else
						{
							bx = -by;
						}
					}
				}
				else
				{
					if (by > 0)
					{
						if (bx > by)
						{
							by = bx;
						}
						else
						{
							bx = by;
						}
					}
					else
					{
						if (bx > -by)
						{
							by = -bx;
						}
						else
						{
							bx = -by;
						}
					}
				}
			}
		}
	}
}