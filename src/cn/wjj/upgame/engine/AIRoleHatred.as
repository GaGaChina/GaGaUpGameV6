package cn.wjj.upgame.engine 
{
	import cn.wjj.data.ObjectArraySort;
	import cn.wjj.upgame.data.SkillActiveModel;
	import flash.utils.Dictionary;
	
	/**
	 * [启用对象池]角色仇恨系统
	 * 
	 * 按照仇恨值大小排序的列表，在没有干预的情况下，ai会自动攻击仇恨列表中最靠前的敌人
	 * 
	 * 列表,然后按照10排序
	 * {对象:ed, hatred :仇恨值:10, index进入这个仇恨值的顺序}
	 * 
	 * 
	 * 
	 * 
	 * 该角色每次攻击时会根据其仇恨列表进行攻击；
	 * 仇恨列表顶端敌人攻击增加的仇恨值=向下取整(1+造成伤害X仇恨系数）X1.08
	 * 仇恨列表普通位置的敌人攻击增加的仇恨值=向下取整(1+造成伤害X仇恨系数），如果攻击者不在该角色的仇恨列表中，则立刻将该角色加入到仇恨列表中
	 * 仇恨值会随时间降低，每秒钟仇恨列表中的所有单位的仇恨降低值=当前仇恨值X12%
	 * 该角色每次选择目标时都会选择其仇恨列表中最顶端的敌方角色；
	 * 仇恨值最低为0
	 * 
	 * @author GaGa
	 */
	public class AIRoleHatred
	{
		
		public function AIRoleHatred() { }
		
		/** 清理 Bitmap 对象, 及里面的全部内容 **/
		public function clear():void
		{
			if (role != null) role = null;
			if (lostTime != 0) lostTime = 0;
			if (lostNextTime != 0) lostNextTime = 0;
			if (maxED != null) maxED = null;
			if (maxTL != 1) maxTL = 1;
			if (length)
			{
				for each (var info:Object in list)
				{
					delete lib[info.ed];
				}
				list.length = 0;
				length = 0;
			}
			if (priorityTarget) priorityTarget = null;
		}
		
		/********************************************实际代码部分********************************************/
		/** 仇恨列表所属角色 **/
		public var role:EDRole;
		/** 仇恨值 : 进入视野，被攻击，会增加仇恨值 **/
		//public var hatred:int = 0;
		/** 上一次执行仇恨值减少的时间 **/
		public var lostTime:Number;
		/** 下一次执行仇恨值减少的时间 **/
		public var lostNextTime:Number;
		/** 现在的最大仇恨对象 **/
		public var maxED:EDRole;
		/** 技能中的最大目标数量 **/
		public var maxTL:int = 1;
		/** 对象的列表 **/
		public var list:Array = new Array();
		/** 对象池数量 **/
		public var length:int = 0;
		/** 对象的数据映射 **/
		public var lib:Dictionary = new Dictionary(true);
		/** 这个对象优先攻击目标,当移除仇恨最高对象后优先查看是否在视野内,如果在就将这个目标排第一 **/
		public var priorityTarget:EDRole;
		/** 是否已经攻击了最大仇恨者,在AI为3的类型中,如果没有可以继续查询周边距离进的对象 **/
		public var hitMax:Boolean = false;
		
		public function setThis(role:EDRole):void
		{
			this.role = role;
			for each (var item:SkillActiveModel in role.skillList) 
			{
				if (item && item.goalType == 0 && item.count > maxTL)
				{
					maxTL = item.count;
				}
			}
		}
		
		/** 对某一个对象增加仇恨值 **/
		public function add(ed:EDRole, value:int):void
		{
			if (value 
			|| (role.ai.targetGround && ed.info.typeProperty == 1)
			|| (role.ai.targetSky && ed.info.typeProperty == 2)
			|| (role.ai.targetBuild && ed.info.typeProperty == 3)
			|| (role.ai.targetBases && ed.info.typeProperty == 4))
			{
				var info:Object;
				switch (role.info.aiType) 
				{
					case 1:
						info = initED(ed);
						info.hatred = info.hatred + value;
						if (info.hatred < 0) info.hatred = 0;
						sort();
						break;
					case 2:
					case 3:
						if (role.info.aiType == 3 && ed.camp == role.camp)
						{
							return;
						}
						if (maxED == null)
						{
							initED2(ed);
							maxED = ed;
							if (hitMax) hitMax = false;
						}
						break;
				}
			}
		}
		
		/** 调整最大的仇恨列表的人 **/
		public function changeTarget(ed:EDRole):void
		{
			var info:Object;
			switch (role.info.aiType)
			{
				case 1:
					if ((role.ai.targetGround && ed.info.typeProperty == 1)
					|| (role.ai.targetSky && ed.info.typeProperty == 2)
					|| (role.ai.targetBuild && ed.info.typeProperty == 3)
					|| (role.ai.targetBases && ed.info.typeProperty == 4))
					{
						initED(ed);
						//找出仇恨最大的人物
						for each (info in list)
						{
							if (info.ed == ed)
							{
								if (info.hatred < 10000000)
								{
									info.hatred = info.hatred + 10000000;
								}
							}
							else if (info.hatred > 10000000)
							{
								info.hatred = info.hatred % 10000000;
								if (info.hatred < 0) info.hatred = 0;
							}
						}
						sort();
					}
					break;
				case 2:
				case 3:
					if (role.info.aiType == 3 && ed.camp == role.camp) { }
					else if (ed && ed.isLive && maxED != ed)
					{
						if ((role.ai.targetGround && ed.info.typeProperty == 1)
						|| (role.ai.targetSky && ed.info.typeProperty == 2)
						|| (role.ai.targetBuild && ed.info.typeProperty == 3)
						|| (role.ai.targetBases && ed.info.typeProperty == 4))
						{
							if (length)
							{
								info = lib[maxED];
								delete lib[maxED];
								lib[ed] = info;
								info.ed = ed;
								list.length = 0;
								list.push(info);
							}
							else
							{
								info = new Object();
								info.ed = ed;
								info.hatred = 0;
								info.index = 0;
								info.dist = 0;
								lib[ed] = info;
								list.push(info);
								length = 1;
							}
							if (hitMax) hitMax = false;
							maxED = ed;
						}
					}
					break;
			}
		}
		
		/** 根据仇恨值是否大于10000000,来判断第一仇恨目标是否处于锁定 **/
		public function get firstIsLock():Boolean
		{
			if (length)
			{
				if (lib[maxED].hatred >= 10000000)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 添加伤害值
		 * @param	ed
		 * @param	value		伤害值(是负数)
		 * @param	scale		仇恨系数
		 */
		public function addHurt(ed:EDRole, value:int, scale:uint = 10000):void
		{
			if ((role.ai.targetGround && ed.info.typeProperty == 1)
			|| (role.ai.targetSky && ed.info.typeProperty == 2)
			|| (role.ai.targetBuild && ed.info.typeProperty == 3)
			|| (role.ai.targetBases && ed.info.typeProperty == 4))
			{
				switch (role.info.aiType)
				{
					case 1:
						var info:Object = initED(ed);
						if (maxED == ed)
						{
							//顶端仇恨值=取整(1+造成伤害X仇恨系数）X1.58
							info.hatred = int((-value * scale / 10000 + 1) * 1.08) + info.hatred;
						}
						else
						{
							//普通仇恨值=向下取整(1+造成伤害X仇恨系数）
							info.hatred = int(-value * scale / 10000 + 1) + info.hatred;
						}
						sort();
						break;
					case 2:
					case 3:
						if (role.info.aiType == 3 && ed.camp == role.camp)
						{
							return;
						}
						if (maxED == null)
						{
							initED2(ed);
							maxED = ed;
							if (hitMax) hitMax = false;
						}
						break;
				}
			}
		}
		
		/** 改变仇恨值 **/
		public function change(ed:EDRole, value:int):void
		{
			if ((role.ai.targetGround && ed.info.typeProperty == 1)
			|| (role.ai.targetSky && ed.info.typeProperty == 2)
			|| (role.ai.targetBuild && ed.info.typeProperty == 3)
			|| (role.ai.targetBases && ed.info.typeProperty == 4))
			{
				switch (role.info.aiType) 
				{
					case 1:
						var info:Object = initED(ed);
						if (value < 0) value = 0;
						info.hatred = value;
						sort();
						break;
					case 2:
					case 3:
						if (role.info.aiType == 3 && ed.camp == role.camp)
						{
							return;
						}
						if (maxED == null)
						{
							initED2(ed);
							maxED = ed;
							if (hitMax) hitMax = false;
						}
						break;
				}
			}
		}
		
		/** 清除特定角色仇恨 **/
		public function remove(ed:EDRole):void
		{
			switch (role.info.aiType) 
			{
				case 1:
					if (lib)
					{
						if (lib[ed])
						{
							var info:Object = lib[ed];
							delete lib[ed];
							var index:int = list.indexOf(info);
							list.splice(index, 1);
							length--;
						}
						if (ed && maxED == ed)
						{
							maxED = null;
							if (length)
							{
								if (maxTL > 2)
								{
									countDistance();
								}
								sort();
							}
							if (priorityTarget)
							{
								if (priorityTarget.isLive && ed.isLive)
								{
									if (SearchTargetRole.searchTargetRangeCount(ed, priorityTarget) <= ed.info.rangeView)
									{
										changeTarget(priorityTarget);
									}
								}
								else
								{
									priorityTarget = null;
								}
							}
						}
						if (length == 0)
						{
							lostTime = 0;
							lostNextTime = 0;
						}
					}
					break;
				case 2:
				case 3:
					if (ed && ed == maxED)
					{
						delete lib[ed];
						list.length = 0;
						length = 0;
						if (priorityTarget)
						{
							if (priorityTarget.isLive && ed.isLive)
							{
								if (SearchTargetRole.searchTargetRangeCount(ed, priorityTarget) <= ed.info.rangeView)
								{
									initED2(priorityTarget);
									maxED = priorityTarget;
								}
								else
								{
									maxED = null;
								}
							}
							else
							{
								priorityTarget = null;
								maxED = null;
							}
						}
						else
						{
							maxED = null;
						}
						if (hitMax) hitMax = false;
					}
					break;
			}
		}
		
		/** 删除全部仇恨列表里的信息 **/
		public function removeAll():void
		{
			if (length)
			{
				for each (var info:Object in list) 
				{
					delete lib[info.ed];
				}
				list.length = 0;
				length = 0;
			}
			if (maxED) maxED = null;
			if (hitMax) hitMax = false;
		}
		
		/** 仇恨值会随时间降低，每秒钟仇恨列表中的所有单位的仇恨降低值=当前仇恨值X12% **/
		public function lostRun():void
		{
			if (length)
			{
				switch (role.info.aiType)
				{
					case 1:
						if (role.u.engine.time.timeGame > lostNextTime)
						{
							lostTime = lostNextTime;
							lostNextTime = lostTime + 1000;
							for each (var info:Object in list) 
							{
								if (info.ed.isLive)
								{
									info.hatred = int(info.hatred * 0.88);
								}
								else
								{
									//多增加一个处理多余对象的方法
									remove(info.ed);
								}
							}
							if (length) sort();
						}
						break;
					case 2:
						if (maxED.isLive == false)
						{
							remove(maxED);
						}
						break;
					case 3:
						if (maxED)
						{
							if (maxED.isLive == false)
							{
								remove(maxED);
							}
							else if (role.info.rangeView < SearchTargetRole.searchTargetRangeCount(role, maxED))
							{
								//如果距离超过了视野,就移除
								remove(maxED);
							}
						}
						break;
				}
			}
		}
		
		/**
		 * 将t的仇恨列表,复制给o仇恨列表
		 * 
		 * @param	t		原始对象
		 * @param	o		目标对象(最后重新排序下)
		 */
		public static function clone(t:AIRoleHatred, o:AIRoleHatred):void
		{
			var x:Number, y:Number;
			var info:Object;
			var infoCopy:Object;
			//o.hatred = t.hatred;
			o.lostTime = t.lostTime;
			o.lostNextTime = t.lostNextTime;
			o.maxED = null;
			if (t.length)
			{
				if (t.role.ai.targetGround == o.role.ai.targetGround && t.role.ai.targetSky == o.role.ai.targetSky && t.role.ai.targetBuild == o.role.ai.targetBuild)
				{
					if ((t.role.info.aiType == 1 && o.role.info.aiType == 1) || (t.role.info.aiType == 2 && o.role.info.aiType == 1))
					{
						for each (info in t.list) 
						{
							infoCopy = new Object();
							infoCopy.ed = info.ed;
							infoCopy.hatred = info.hatred;
							infoCopy.index = info.index;
							x = o.role.x - info.ed.x;
							y = o.role.y - info.ed.y;
							infoCopy.dist = x * x + y * y;//Math.sqrt(x * x + y * y)
							o.list.push(infoCopy);
							o.lib[info.ed] = infoCopy;
						}
						AIRoleHatred.sortList(o.list);
						o.maxED = o.list[0].ed;
						o.length = t.length;
					}
					else if (t.role.info.aiType == 1 && o.role.info.aiType == 2)
					{
						if (t.maxED && t.maxED.isLive)
						{
							info = new Object();
							info.ed = t.maxED;
							info.hatred = 0;
							info.index = 0;
							info.dist = 0;
							o.lib[info.ed] = info;
							o.list.push(info);
							o.length = 1;
							o.maxED = t.maxED;
						}
					}
				}
				else
				{
					if ((t.role.info.aiType == 1 && o.role.info.aiType == 1) || (t.role.info.aiType == 2 && o.role.info.aiType == 1))
					{
						for each (info in t.list) 
						{
							if ((o.role.ai.targetGround && info.ed.info.typeProperty == 1)
							|| (o.role.ai.targetSky && info.ed.info.typeProperty == 2)
							|| (o.role.ai.targetBuild && info.ed.info.typeProperty == 3)
							|| (o.role.ai.targetBases && info.ed.info.typeProperty == 4))
							{
								infoCopy = new Object();
								infoCopy.ed = info.ed;
								infoCopy.hatred = info.hatred;
								infoCopy.index = info.index;
								x = o.role.x - info.ed.x;
								y = o.role.y - info.ed.y;
								infoCopy.dist = x * x + y * y;//Math.sqrt(x * x + y * y)
								o.list.push(infoCopy);
								o.lib[info.ed] = infoCopy;
							}
						}
						if (o.list.length)
						{
							AIRoleHatred.sortList(o.list);
							o.maxED = o.list[0].ed;
							o.length = o.list.length;
						}
						else
						{
							if (o.maxED != null) o.maxED = null;
							if (o.length != 0) o.length = 0;
						}
					}
					else if (t.role.info.aiType == 1 && o.role.info.aiType == 2)
					{
						if ((o.role.ai.targetGround && t.maxED.info.typeProperty == 1)
						|| (o.role.ai.targetSky && t.maxED.info.typeProperty == 2)
						|| (o.role.ai.targetBuild && t.maxED.info.typeProperty == 3)
						|| (o.role.ai.targetBases && info.ed.info.typeProperty == 4))
						{
							if (t.maxED && t.maxED.isLive)
							{
								info = new Object();
								info.ed = t.maxED;
								info.hatred = 0;
								info.index = 0;
								info.dist = 0;
								o.lib[info.ed] = info;
								o.list.push(info);
								o.length = 1;
								o.maxED = t.maxED;
							}
						}
					}
				}
			}
			else if (o.length)
			{
				for each (info in o.list) 
				{
					delete o.lib[info.ed];
				}
				o.list.length = 0;
				o.length = 0;
			}
		}
		
		/** 有新对象加入的时候 **/
		private function initED(ed:EDRole):Object
		{
			if (length == 0)
			{
				lostTime = role.u.engine.time.timeGame;
				lostNextTime = lostTime + 1000;
				maxED = ed;
			}
			var info:Object;
			if (lib[ed] == null)
			{
				info = new Object();
				info.ed = ed;
				info.hatred = 0;
				info.index = 0;
				info.dist = 0;
				lib[ed] = info;
				list.push(info);
				length++;
				//刷新距离
				if (maxTL > 2)
				{
					countDistance();
				}
			}
			else
			{
				info = lib[ed];
			}
			return info;
		}
		
		/** AI2的类型添加对象的方法 **/
		private function initED2(ed:EDRole):void
		{
			var info:Object = new Object();
			info.ed = ed;
			info.hatred = 0;
			info.index = 0;
			info.dist = 0;
			lib[ed] = info;
			list.push(info);
			length = 1;
		}
		
		/** 刷新全部的距离 **/
		private function countDistance():void
		{
			var x:Number, y:Number;
			for each (var info:Object in list) 
			{
				x = role.x - info.ed.x;
				y = role.y - info.ed.y;
				info.dist = x * x + y * y;//Math.sqrt(x * x + y * y)
			}
		}
		
		/** 排序仇恨列表,并且储备一个仇恨最高的对象 **/
		private function sort():void
		{
			if (length == 1)
			{
				maxED = list[0].ed;
			}
			else if (length)
			{
				if (maxTL == 1)
				{
					AIRoleHatred.sortMaxTL1(this);
				}
				else if (maxTL == 2)
				{
					AIRoleHatred.sortMaxTL2(this);
				}
				else
				{
					AIRoleHatred.sortList(list);
					maxED = list[0].ed;
				}
			}
			else
			{
				maxED = null;
			}
		}
		
		/** 排序内容 **/
		private static var sortConfig:Array;
		/**
		 * 排序：hatred大到小, index小到大 
		 */
		public static function sortList(arr:*):void
		{
			if (sortConfig == null)
			{
				sortConfig = new Array();
				//判断仇恨
				sortConfig.push(ObjectArraySort.getSortItem_p("hatred", "0", ObjectArraySort.SORT_NUMBER_SMAILL_BIG, false));
				//判断距离
				sortConfig.push(ObjectArraySort.getSortItem_p("dist", "0",  ObjectArraySort.SORT_NUMBER_SMAILL_BIG, true));
				//不知道要干嘛
				sortConfig.push(ObjectArraySort.getSortItem_p("index", "1",  ObjectArraySort.SORT_NUMBER_SMAILL_BIG, true));
			}
			ObjectArraySort.sort(arr, sortConfig, null, null, true);
		}
		
		private static var b:Boolean = true;
		private static var tempMax:Object = null;
		private static var tempMaxHatred:int = 0;
		/**
		 * 将List里仇恨最大,距离相对较近,加入持续从先到后加入的找出来,单目标排序
		 * @param	list
		 */
		private static function sortMaxTL1(hatred:AIRoleHatred):void
		{
			tempMax = null;
			b = true;
			var x:Number, y:Number;
			for each (var info:Object in hatred.list) 
			{
				if (b)
				{
					b = false;
					tempMax = info;
					tempMaxHatred = info.hatred;
					x = hatred.role.x - info.ed.x;
					y = hatred.role.y - info.ed.y;
					info.dist = x * x + y * y;//Math.sqrt(x * x + y * y)
				}
				else
				{
					if (tempMaxHatred == info.hatred)
					{
						x = hatred.role.x - info.ed.x;
						y = hatred.role.y - info.ed.y;
						info.dist = x * x + y * y;//Math.sqrt(x * x + y * y)
						if (info.dist < tempMax.dist)
						{
							tempMax = info;
						}
						else(info.dist == tempMax.dist)
						{
							if (info.index < tempMax.index)
							{
								tempMax = info;
							}
						}
					}
					else if(tempMaxHatred < info.hatred)
					{
						tempMaxHatred = info.hatred;
						tempMax = info;
						x = hatred.role.x - info.ed.x;
						y = hatred.role.y - info.ed.y;
						info.dist = x * x + y * y;//Math.sqrt(x * x + y * y)
					}
				}
			}
			if (tempMax)
			{
				hatred.maxED = tempMax.ed;
				tempMaxHatred = hatred.list.indexOf(tempMax);
				if (tempMaxHatred != 0)
				{
					hatred.list.splice(tempMaxHatred, 1);
					hatred.list.unshift(tempMax);
				}
				tempMax = null;
			}
		}
		/**
		 * 找出双目标排序结果
		 * @param	hatred
		 */
		private static function sortMaxTL2(hatred:AIRoleHatred):void
		{
			var x:Number, y:Number;
			var a:Object, b:Object;
			if (hatred.list.length == 2)
			{
				a = hatred.list[0];
				b = hatred.list[1];
				if (a.hatred < b.hatred)
				{
					hatred.list[0] = b;
					hatred.list[1] = a;
				}
				else if (a.hatred > b.hatred)
				{
					//不用动
				}
				else
				{
					x = hatred.role.x - a.ed.x;
					y = hatred.role.y - a.ed.y;
					a.dist = x * x + y * y;//Math.sqrt(x * x + y * y)
					x = hatred.role.x - b.ed.x;
					y = hatred.role.y - b.ed.y;
					b.dist = x * x + y * y;//Math.sqrt(x * x + y * y)
					if (a.dist < b.dist)
					{
						//不用修改
					}
					else if (a.dist > b.dist)
					{
						hatred.list[0] = b;
						hatred.list[1] = a;
					}
					else if (a.index > b.index)
					{
						hatred.list[0] = b;
						hatred.list[1] = a;
					}
				}
				hatred.maxED = hatred.list[0].ed;
			}
			else
			{
				//找出第一和第二,然后其他的和这2个比较,每次都比较2个人 a 第一,b第二
				//tempMaxHatred 倒数第二个的仇恨
				var c:Object;
				for each (var info:Object in hatred.list)
				{
					if (a == null)
					{
						a = info;
					}
					else if (b == null)
					{
						b = info;
						if (sortTwoObject(hatred, a, b))
						{
							c = a;
							a = b;
							b = c;
						}
						tempMaxHatred = b.hatred;
					}
					else if (tempMaxHatred < info.hatred)
					{
						if (a.hatred < info.hatred)
						{
							a = info;
							b = a;
							tempMaxHatred = b.hatred;
						}
						else if (a.hatred > info.hatred)
						{
							b = info;
							tempMaxHatred = info.hatred;
						}
						else
						{
							tempMaxHatred = a.hatred;
							if (sortTwoObject(hatred, a, info))
							{
								b = a;
								a = info;
							}
							else
							{
								b = info;
							}
						}
					}
					else if (tempMaxHatred == info.hatred)
					{
						if (sortTwoObject(hatred, b, info))
						{
							b = info;
						}
					}
				}
			}
		}
		
		/**
		 * 比较A,B的数据返回是否需要换位置
		 * @param	a
		 * @param	b
		 * @return
		 */
		private static function sortTwoObject(hatred:AIRoleHatred, a:Object, b:Object):Boolean
		{
			if (a.hatred < b.hatred)
			{
				return true;
			}
			else if (a.hatred > b.hatred)//不用动
			{
				return false;
			}
			else
			{
				var x:Number = hatred.role.x - a.ed.x;
				var y:Number = hatred.role.y - a.ed.y;
				a.dist = x * x + y * y;//Math.sqrt(x * x + y * y)
				x = hatred.role.x - b.ed.x;
				y = hatred.role.y - b.ed.y;
				b.dist = x * x + y * y;//Math.sqrt(x * x + y * y)
				if (a.dist < b.dist)
				{
					//不用修改
					return false;
				}
				else if (a.dist > b.dist)
				{
					return true;
				}
				else
				{
					if (a.index > b.index)
					{
						return true;
					}
				}
			}
			return false;
		}
		
	}
}