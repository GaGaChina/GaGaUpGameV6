package cn.wjj.upgame.engine 
{
	import cn.wjj.data.ObjectArraySort;
	import cn.wjj.display.MPoint;
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.upgame.common.SkillTargetType;
	import cn.wjj.upgame.common.StatusTypeRole;
	import cn.wjj.upgame.common.SystemValue;
	
	/**
	 * 人物搜索攻击目标
	 * 
	 * @author GaGa
	 */
	public class SearchTargetRole 
	{
		
		public function SearchTargetRole() { }
		
		/**
		 * 根据技能类型,来查找目标
		 * 
		 * SkillActiveModel
		 * [非普通技能只关心射程范围内]射程
		 * [普通技能忽视]目标类型(0-当前目标，1-己方血少，2-敌方血少，3-随机位置(屏幕随机点)，4-当前方向，5-自己)
		 * 目标数量
		 * @param	ed
		 * @param	item
		 */
		internal static function searchSkillTarget(ed:EDRole, item:AIRoleSkill):void
		{
			if (item.target) item.target.length = 0;
			if (item.targetPoint) item.targetPoint.length = 0;
			var goalType:uint;
			if (item.skill.goalUseType == 1)
			{
				if (item.actionRun)
				{
					goalType = item.actionRun.goalType;
				}
				else if(item.actionList.length && item.actionList[0])
				{
					goalType = item.actionList[0].goalType;
				}
				else
				{
					g.log.pushLog(SearchTargetRole, LogType._ErrorLog, "动作表无目标类型,技能ID:" + item.skill.id);
					return;
				}
			}
			else
			{
				goalType = item.skill.goalType;
			}
			switch (goalType)
			{
				case 0://当前目标
					item.targetType = SkillTargetType.role;
					skillType1(ed, item);
					break;
				case 1://己方血少(血液的比例, 射程范围内的已方血少)
					item.targetType = SkillTargetType.role;
					skillType2(item, item.target, false);
					break;
				case 120://己方有35%血以下目标,将对射程范围内己方全体治疗(血液的比例, 射程范围内出现血少于35%目标)
					item.targetType = SkillTargetType.role;
					skillType120(item, item.target, false);
					break;
				case 2://敌方血少
					item.targetType = SkillTargetType.role;
					skillType2(item, item.target, true);
					break;
				case 3://随机目标点
					item.targetType = SkillTargetType.point;
					skillType4(ed, item);
					break;
				case 4://当前方向
					item.targetType = SkillTargetType.direction;
					break;
				case 5:
					item.targetType = SkillTargetType.role;
					item.target.push(ed);
					break;
				case 6://射程内随机敌方目标
					item.targetType = SkillTargetType.role;
					skillType6(ed, item, item.skill.count, true);
					break;
				default:
					g.log.pushLog(SearchTargetRole, LogType._ErrorLog, "缺少技能目标类型 : " + goalType);
			}
		}
		
		/**
		 * 普通技能的查找目标方式1 : 当前目标
		 * @param	ed			对象
		 * @param	skill		技能
		 * @param	target		目标列表
		 */
		private static function skillType1(ed:EDRole, skill:AIRoleSkill):void
		{
			if (ed.ai.hatred.length)
			{
				var targetList:int = 0;
				var i:int = 0;
				var role:EDRole;
				while (targetList < skill.skill.count) 
				{
					if (ed.ai.hatred.length > i)
					{
						role = ed.ai.hatred.list[i].ed;
						if ((skill.targetGround && role.info.typeProperty == 1)
						|| (skill.targetSky && role.info.typeProperty == 2)
						|| (skill.targetBuild && role.info.typeProperty == 3)
						|| (skill.targetBases && role.info.typeProperty == 4))
						{
							//判断距离 , BUG 这里 a 可能没东西,死循环
							if (role.isLive && role.canHit && isRangeCount(ed, role, skill.skill.range))
							{
								skill.target.push(role);
								targetList++;
							}
						}
						i++;
						if (i == skill.skill.count)
						{
							break;
						}
					}
					else
					{
						break;
					}
				}
			}
		}
		
		/** 临时的数组变量 **/
		private static var array:Array = new Array();
		/** 临时的数组变量长度 **/
		private static var arrayLength:int = 0;
		
		/**
		 * 普通技能的查找目标方式1 : 己方血少(血液的比例, 射程范围内的已方血少)
		 * @param	skill		
		 * @param	target		
		 * @param	isEnemy		
		 */
		private static function skillType2(skill:AIRoleSkill, target:Vector.<EDRole>, isEnemy:Boolean):void
		{
			//是否被激活(未激活需要找敌对目标进行激活)
			//找的目标所在阵营类型
			var role:EDRole;
			for each (var item:EDCamp in skill.ed.u.engine.campLib) 
			{
				if (item.lengthRole && ((isEnemy && item.camp != skill.ed.camp) || (isEnemy == false && item.camp == skill.ed.camp)))
				{
					for each (role in item.listRole) 
					{
						if ((skill.targetGround && role.info.typeProperty == 1)
						|| (skill.targetSky && role.info.typeProperty == 2)
						|| (skill.targetBuild && role.info.typeProperty == 3)
						|| (skill.targetBases && role.info.typeProperty == 4))
						{
							//召唤怪物都会被排除
							if (role.isLive && role.inHot  && role.canHit && role.dieAuto == 0 && isRangeCount(skill.ed, role, skill.skill.range))
							{
								array.push(role);
								arrayLength++;
							}
						}
					}
				}
			}
			if (arrayLength)
			{
				//排序把血最少的排到前面
				sortHPList(array);
				var targetList:int = 0;
				for each(role in array)
				{
					if (skill.skill.count == 0 || targetList < skill.skill.count)
					{
						targetList++;
						target.push(role);
					}
					else
					{
						break;
					}
				}
				array.length = 0;
				arrayLength = 0;
			}
		}
		
		/**
		 * 普通技能的查找目标方式1 : 己方血少(血液的比例, 射程范围内的已方血少)
		 * @param	skill		
		 * @param	target		
		 * @param	isEnemy		
		 */
		private static function skillType120(skill:AIRoleSkill, target:Vector.<EDRole>, isEnemy:Boolean):void
		{
			//是否被激活(未激活需要找敌对目标进行激活)
			//找的目标所在阵营类型
			var role:EDRole;
			var b:Boolean = false;
			for each (var item:EDCamp in skill.ed.u.engine.campLib) 
			{
				if (item.lengthRole && ((isEnemy && item.camp != skill.ed.camp) || (isEnemy == false && item.camp == skill.ed.camp)))
				{
					for each (role in item.listRole) 
					{
						if ((skill.targetGround && role.info.typeProperty == 1)
						|| (skill.targetSky && role.info.typeProperty == 2)
						|| (skill.targetBuild && role.info.typeProperty == 3)
						|| (skill.targetBases && role.info.typeProperty == 4))
						{
							if (role.isLive && role.inHot && role.dieAuto == 0 && role.canHit && isRangeCount(skill.ed, role, skill.skill.range))
							{
								if (b == false && (role.info.hp / role.info.hpMax) < 0.35)
								{
									b = true;
								}
								array.push(role);
								arrayLength++;
							}
						}
					}
				}
			}
			if (b && arrayLength)
			{
				//排序把血最少的排到前面
				sortHPList(array);
				var targetList:int = 0;
				for each(role in array)
				{
					if (skill.skill.count == 0 || targetList < skill.skill.count)
					{
						targetList++;
						target.push(role);
					}
					else
					{
						break;
					}
				}
				array.length = 0;
				arrayLength = 0;
			}
			else if (arrayLength)
			{
				array.length = 0;
				arrayLength = 0;
			}
		}
		
		/**
		 * 普通技能的查找目标方式3 : 随机目标点
		 * @param	ed
		 * @param	skill			释放的技能
		 */
		private static function skillType4(ed:EDRole, skill:AIRoleSkill):void
		{
			var i:int = 0;
			var p:MPoint;
			var b:Boolean;
			var u:uint = 0;
			while (i++ < skill.skill.count) 
			{
				p = MPoint.instance();
				b = true;
				u = 0;
				while (b && u < 30)
				{
					u++;
					p.x = int(ed.u.random * skill.skill.range + ed.x + ed.hit_r_x - (skill.skill.range / 2));
					p.y = int(ed.u.random * skill.skill.range + ed.y + ed.hit_r_y - (skill.skill.range / 2));
					if (ed.hit_h)
					{
						p.x = ed.hit_r / 2 + p.x;
						p.y = ed.hit_h / 2 + p.y;
					}
					if (ed.u.engine.astar.isPass(p.x, p.y))
					{
						b = false;
					}
				}
				skill.targetPoint.push(p);
			}
		}
		
		/**
		 * 随机目标
		 * @param	ed			技能触发者
		 * @param	skill		释放的技能
		 * @param	count		目标数量
		 * @param	isEnemy		是否为敌方
		 * @return
		 */
		private static function skillType6(ed:EDRole, skill:AIRoleSkill, count:uint, isEnemy:Boolean):void
		{
			var t:EDRole;
			var b:Boolean = false;
			for each (var item:EDCamp in ed.u.engine.campLib) 
			{
				if (item.lengthRole && ((isEnemy && item.camp != ed.camp) || (isEnemy == false && item.camp == ed.camp)))
				{
					for each (t in item.listRole) 
					{
						if ((skill.targetGround && t.info.typeProperty == 1)
						|| (skill.targetSky && t.info.typeProperty == 2)
						|| (skill.targetBuild && t.info.typeProperty == 3)
						|| (skill.targetBases && t.info.typeProperty == 4))
						{
							if (t.isLive && t.inHot && t.canHit && isRangeCount(ed, t, skill.skill.range))
							{
								array.push(t);
								arrayLength++;
							}
						}
					}
				}
			}
			if (arrayLength)
			{
				var random:Number;
				var index:int;
				while (--count > -1)
				{
					random = ed.u.random;
					if (random == 0)
					{
						skill.target.push(array.shift() as EDRole);
					}
					else if (random == 1)
					{
						skill.target.push(array.pop() as EDRole);
					}
					else
					{
						index = int(random * arrayLength);
						skill.target.push(array[index] as EDRole);
						array.splice(index, 1);
					}
					arrayLength--;
				}
				if (arrayLength)
				{
					array.length = 0;
					arrayLength = 0;
				}
			}
		}
		
		/**
		 * 普通技能目标
		 * @param	ed			技能触发者
		 * @param	ai			技能触发对象AI
		 * @param	skill		技能
		 * @param	target		将击中的目标写入这个列表
		 * @return				是否在目标范围内,不在继续使用其他地方来计算目标距离
		 */
		internal static function searchNormalTarget(ed:EDRole, skill:AIRoleSkill):Boolean
		{
			//增加查找对应目标的功能,空地等
			if (ed.lock == true && ed.ai.lockTarget)
			{
				if (ed.ai.lockTarget.isLive)
				{
					if (ed.ai.lockTarget.inHot && ed.ai.lockTarget.canHit)
					{
						if ((skill.targetGround && ed.ai.lockTarget.info.typeProperty == 1)
						|| (skill.targetSky && ed.ai.lockTarget.info.typeProperty == 2)
						|| (skill.targetBuild && ed.ai.lockTarget.info.typeProperty == 3)
						|| (skill.targetBases && ed.ai.lockTarget.info.typeProperty == 4))
						{
							skill.target.length = 0;
							skill.target.push(ed.ai.lockTarget);
							if (isRangeCount(ed, ed.ai.lockTarget, skill.skill.range))
							{
								return true;
							}
						}
					}
					return false;
				}
				else
				{
					ed.ai.lockTarget = null;
					return searchNormalTarget(ed, skill);
				}
			}
			else
			{
				var t:EDRole = ed.ai.hatred.maxED;
				skill.target.length = 0;
				while (t && t.isLive == false)
				{
					ed.ai.hatred.remove(t);
					t = ed.ai.hatred.maxED;
				}
				if (t && t.isLive && ed != t && t.inHot && t.canHit)//普通攻击目标不能为自己
				{
					if ((skill.targetGround && t.info.typeProperty == 1)
					|| (skill.targetSky && t.info.typeProperty == 2)
					|| (skill.targetBuild && t.info.typeProperty == 3)
					|| (skill.targetBases && t.info.typeProperty == 4))
					{
						skill.target.push(t);
						if (isRangeCount(ed, t, skill.skill.range))
						{
							return true;
						}
					}
				}
			}
			return false;
		}
		
		/** 计算距离,二个对象原点,用于计算互助 **/
		public static function searchTargetRangeCount(a:EDRole, b:EDRole):Number
		{
			var x:Number = a.x - b.x;
			var y:Number = a.y - b.y;
			return Math.sqrt(x * x + y * y);
		}
		
		//x,y轴的方位, -1是在外,0在内,1 在另一头外
		private static var rx:int;
		private static var ry:int;
		//临时碰撞点
		private static var hx:Number;
		private static var hy:Number;
		//临时碰撞点2
		private static var hx2:Number;
		private static var hy2:Number;
		
		private static var cn:Number;
		
		/** 计算坐标点和对象碰撞区域之间的最小距离(取出上线,1.5取2,-1.5取-2) **/
		internal static function pointHitRangeCountInt(x:Number, y:Number, role:EDRole):int
		{
			cn = pointHitRangeCount(x, y, role);
			if (cn < 0)
			{
				return Math.floor(cn);
			}
			return Math.ceil(cn);
		}
		
		/** 计算坐标点和对象碰撞区域之间的最小距离, **/
		internal static function pointHitRangeCount(x:Number, y:Number, role:EDRole):Number
		{
			if (role.hit_h)
			{
				/**
				 * 算出 x ,y 和 role中心点的角度
				 * 通过三角函数算出,和 x轴和y轴的交叉点的,xy坐标
				 * 算出这都在交叉点上的距离
				 */
				hx = role.hit_r / 2 + role.x + role.hit_r_x;
				hy = role.hit_h / 2 + role.y + role.hit_r_y;
				if (hx == x)
				{
					if (hy == y)
					{
						return 0;
					}
					else if (hy < y)
					{
						return y - hy;
					}
					return hy - y;
				}
				else if (hy == y)
				{
					if (hx == x)
					{
						return 0;
					}
					else if (hx < x)
					{
						return x - hx;
					}
					return hx - x;
				}
				//y坐标是否在y的范围内
				if (x >= (role.x + role.hit_r_x) && x <= (role.x + role.hit_r_x + role.hit_r))
				{
					//x坐标在x的范围内
					if (y >= (role.y + role.hit_r_y) && y <= (role.y + role.hit_r_y + role.hit_h))
					{
						return 0;
					}
					else
					{
						//只可能和x轴发生交叉,如果y在role.y + role.hit_r_y,就是和左侧碰撞,反之和右侧碰撞
						cn = Math.atan2(y - hy, x - hx);
						if (y < hy)
						{
							//hy2 = role.y + role.hit_r_y - y;
							//hx2 = (hy2 - y) / Math.tan(cn) + x - x;
							hx2 = (role.y + role.hit_r_y - y) / Math.tan(cn);
							hy2 = role.y + role.hit_r_y - y;
						}
						else
						{
							hx2 = (role.y + role.hit_r_y + role.hit_h - y) / Math.tan(cn);
							hy2 = role.y + role.hit_r_y + role.hit_h - y;
						}
						return Math.sqrt(hx2 * hx2 + hy2 * hy2);
					}
				}
				else if (y >= (role.y + role.hit_r_y) && y <= (role.y + role.hit_r_y + role.hit_h))
				{
					//在y的范围内,和y轴发生交叉
					cn = Math.atan2(y - hy, x - hx);
					if (x < hx)
					{
						//和左侧发生交叉
						//hx2 = role.x + role.hit_r_x - x;
						//hy2 = (role.x + role.hit_r_x - x) * Math.tan(cn) + y - y;
						hx2 = role.x + role.hit_r_x - x;
						hy2 = (role.x + role.hit_r_x - x) * Math.tan(cn);
					}
					else
					{
						//和右侧发生交叉
						hx2 = role.x + role.hit_r_x + role.hit_r - x;
						hy2 = (role.x + role.hit_r_x + role.hit_r - x) * Math.tan(cn);
					}
					return Math.sqrt(hx2 * hx2 + hy2 * hy2);
				}
				//如果和X轴交叉了,肯定不能和Y轴在交叉.如果在左侧,按照左边来计算,反之用右侧计算
				cn = Math.atan2(y - hy, x - hx);
				//先算和y轴是否交叉
				if (x < hx)
				{
					//和左侧发生交叉
					//hx2 = role.x + role.hit_r_x - x;
					//hy2 = (role.x + role.hit_r_x - x) * Math.tan(cn) + y - y;
					hy2 = (role.x + role.hit_r_x - x) * Math.tan(cn);
					if ((hy2 + y) >= role.y + role.hit_r_y && (hy2 + y) <= role.y + role.hit_r_y + role.hit_h)
					{
						hx2 = role.x + role.hit_r_x - x;
						return Math.sqrt(hx2 * hx2 + hy2 * hy2);
					}
				}
				else
				{
					//和右侧发生交叉
					hy2 = (role.x + role.hit_r_x + role.hit_r - x) * Math.tan(cn);
					if ((hy2 + y) >= role.y + role.hit_r_y && (hy2 + y) <= role.y + role.hit_r_y + role.hit_h)
					{
						hx2 = role.x + role.hit_r_x + role.hit_r - x;
						return Math.sqrt(hx2 * hx2 + hy2 * hy2);
					}
				}
				if (y < hy)
				{
					hx2 = (role.y + role.hit_r_y - y) / Math.tan(cn);
					hy2 = role.y + role.hit_r_y - y;
				}
				else
				{
					hx2 = (role.y + role.hit_r_y + role.hit_h - y) / Math.tan(cn);
					hy2 = role.y + role.hit_r_y + role.hit_h - y;
				}
				return Math.sqrt(hx2 * hx2 + hy2 * hy2);
				
				/**
				 * 矩形的算法要重新写
				 * 1.解决方案,算出矩形的中心点,和最小半径
				 * 
				
				x = role.hit_r / 2 + role.x + role.hit_r_x - x;
				y = role.hit_h / 2 + role.y + role.hit_r_y - y;
				if (role.hit_r < role.hit_h)
				{
					return Math.sqrt(x * x + y * y) - (role.hit_r / 2);
				}
				return Math.sqrt(x * x + y * y) - (role.hit_h / 2);
				 */
				/*
				rx = 0;
				ry = 0;
				if (x < (role.x + role.hit_r_x))
				{
					rx = -1;
				}
				else if (x > (role.x + role.hit_r_x + role.hit_r))
				{
					rx = 1;
				}
				if (y < (role.y + role.hit_r_y))
				{
					ry = -1;
				}
				else if (y > (role.y + role.hit_r_y + role.hit_h))
				{
					ry = 1;
				}
				//找到方位后,进行判断
				if (rx == 0 && ry == 0)//在其中
				{
					x = role.hit_r / 2 + role.hit_r_x + role.x - x;
					y = role.hit_h / 2 + role.hit_r_y + role.y - y;
					return -Math.sqrt(x * x + y * y);
				}
				else if (rx == 0)//X轴垂直碰撞
				{
					hx = x;
					if (ry == -1)
					{
						hy = role.y + role.hit_r_y;//上角
					}
					else
					{
						hy = role.y + role.hit_r_y + role.hit_h;//下角
					}
				}
				else if (ry == 0)//Y方向水平碰撞
				{
					hy = y;
					if (rx == -1)
					{
						hx = role.x + role.hit_r_x;//左边
					}
					else
					{
						hx = role.x + role.hit_r_x + role.hit_r;//右边
					}
				}
				else if (rx == -1)
				{
					hx = role.x + role.hit_r_x;
					if (ry == -1)
					{
						hy = role.y + role.hit_r_y;//左上角
					}
					else
					{
						hy = role.y + role.hit_r_y + role.hit_h;//左下角
					}
				}
				else if (rx == 1)
				{
					hx = role.x + role.hit_r_x + role.hit_r;
					if (ry == -1)
					{
						hy = role.y + role.hit_r_y;//右上角
					}
					else
					{
						hy = role.y + role.hit_r_y + role.hit_h;//右下角
					}
				}
				x = hx - x;
				y = hy - y;
				return Math.sqrt(x * x + y * y);
				*/
			}
			x = role.x + role.hit_r_x - x;
			y = role.y + role.hit_r_y - y;
			return Math.sqrt(x * x + y * y) - role.hit_r;
		}
		
		/**
		 * 判断是否在射程内
		 * @param	a		技能发出者
		 * @param	b		技能对象
		 * @param	range	技能的射程
		 * @return
		 */
		public static function isRangeCount(a:EDRole, b:EDRole, range:uint):Boolean
		{
			if (int(getDistance(a, b) - range) > 1)
			{
				return false;
			}
			return true;
		}
		
		private static var modeMovePhys:Boolean;
		private static var short:int;
		private static var ax:Number;
		private static var ay:Number;
		
		/** 算出这2个角色之间的距离 **/
		public static function getDistance(a:EDRole, b:EDRole):Number
		{
			//算出攻击者子弹发出点
			/*
			if (modeMovePhys) modeMovePhys = false;
			if (a.isLive)
			{
				if (a.u.modeMovePhys)
				{
					modeMovePhys = true;
				}
			}
			else if (b.isLive)
			{
				if (b.u.modeMovePhys)
				{
					modeMovePhys = true;
				}
			}
			if (short != 0) short = 0;
			ax = a.x + a.hit_r_x;
			ay = a.y + a.hit_r_y;
			if (a.hit_h)
			{
				ax = a.hit_r / 2 + ax;
				ay = a.hit_h / 2 + ay;
				if (modeMovePhys == false)
				{
					short = SystemValue.ShortenRangeRect;
				}
			}
			else
			{
				if (modeMovePhys == false)
				{
					short = SystemValue.ShortenRangeCircle;
				}
			}
			if (modeMovePhys)
			{
				return pointHitRangeCount(ax, ay, b);
			}
			return pointHitRangeCount(ax, ay, b) + short;
			*/
			if (short != 0) short = 0;
			ax = a.x + a.hit_r_x;
			ay = a.y + a.hit_r_y;
			if (a.hit_h)
			{
				ax = a.hit_r / 2 + ax;
				ay = a.hit_h / 2 + ay;
				short = SystemValue.ShortenRangeRect;
			}
			else
			{
				short = SystemValue.ShortenRangeCircle;
			}
			return pointHitRangeCount(ax, ay, b) + short;
		}
		
		/**
		 * 找出 a 对象距离最近的敌人, 并且必须在视野范围内
		 * @param	a
		 * @return
		 */
		public static function getMiniRange(a:EDRole):EDRole
		{
			if (a && a.isLive)
			{
				var rangeView:int = a.info.rangeView;
				var role:EDRole;
				var miniRange:Number = 99999999;
				var miniRole:EDRole;
				var temp:int;
				for each (var item:EDCamp in a.u.engine.campLib) 
				{
					if (item.lengthRole && item.camp != a.camp)
					{
						for each (role in item.listRole) 
						{
							if (role.isLive && role.inHot && role.canHit)
							{
								temp = int(getDistance(a, role));
								if (temp < miniRange && temp <= rangeView)
								{
									miniRange = temp;
									miniRole = role;
								}
							}
						}
					}
				}
			}
			return miniRole;
		}
		
		/** 排序内容 **/
		private static var sortHPConfig:Array;
		/**
		 * 排序
		 */
		private static function sortHPList(arr:*):void
		{
			if (sortHPConfig == null)
			{
				sortHPConfig = new Array();
				sortHPConfig.push(ObjectArraySort.getSortItem_p("hpScale", "0", ObjectArraySort.SORT_NUMBER_SMAILL_BIG, true));
			}
			ObjectArraySort.sort(arr, sortHPConfig, null, null, true);
		}
	}

}