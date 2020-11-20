package cn.wjj.upgame.engine 
{
	import cn.wjj.g;
	import cn.wjj.data.ObjectArraySort;
	import cn.wjj.upgame.data.UpGameSkillEffect;
	
	/**
	 * 子弹寻找目标
	 * 
	 * @author GaGa
	 */
	public class SearchTargetBullet 
	{
		
		public function SearchTargetBullet() { }
		
		/**
		 * [多目标]找出对应的目标
		 * @param	ed
		 * @param	type	1:敌人 , 2:友方 , 3 双方
		 * @return
		 */
		internal static function searchRoleCamp(ed:EDBullet, type:int):Vector.<EDRole>
		{
			var out:Vector.<EDRole>;
			var role:EDRole;
			var count:Number;
			for each (var camp:EDCamp in ed.u.engine.campLib) 
			{
				if (camp.lengthRole)
				{
					if (type == 3 || (type == 2 && camp.camp == ed.camp) || (type == 1 && camp.camp != ed.camp))
					{
						for each (role in camp.listRole) 
						{
							if (role.isLive && role.inHot && role.canHit)
							{
								count = SearchTargetRole.pointHitRangeCount(ed.x, ed.y, role) - ed.info.info.radius;
								if (count <= 0)
								{
									if (out == null)
									{
										out = g.speedFact.n_vector(EDRole);
										if (out == null)
										{
											out = new Vector.<EDRole>();
										}
									}
									out.push(role);
								}
							}
						}
					}
				}
			}
			return out;
		}
		
		/**
		 * [多目标]首先打上,然后在砸开,按照效果目标的范围来查找多个对象
		 * @param	ed
		 * @param	type			1:敌人 , 2:友方 , 3 双方
		 * @param	skillEffect
		 * @param	hitRange		是否需要先打上,如果不是就不用先检查一个
		 * @return
		 */
		internal static function searchRoleCampRange(ed:EDBullet, type:int, skillEffect:UpGameSkillEffect, hitRange:Boolean = true):Vector.<EDRole>
		{
			var out:Vector.<EDRole>;
			var target:EDRole;
			if (hitRange)
			{
				target = searchRoleCampOne(ed, type);
			}
			if (hitRange == false || target)
			{
				//检查炸开了
				var count:Number;
				var role:EDRole;
				for each (var camp:EDCamp in ed.u.engine.campLib) 
				{
					if (camp.lengthRole)
					{
						if (type == 3 || (type == 2 && camp.camp == ed.camp) || (type == 1 && camp.camp != ed.camp))
						{
							for each (role in camp.listRole) 
							{
								if (role.isLive && role.inHot && role.canHit)
								{
									if((role.info.typeProperty == 1 && skillEffect.AttacksGround)
									|| (role.info.typeProperty == 2 && skillEffect.AttacksAir)
									|| (role.info.typeProperty == 3 && skillEffect.AttacksBuildings)
									|| (role.info.typeProperty == 4 && skillEffect.AttacksBases))
									{
										count = SearchTargetRole.pointHitRangeCount(ed.x, ed.y, role) - skillEffect.rangeR;
										if (count <= 0)
										{
											if (out == null)
											{
												out = g.speedFact.n_vector(EDRole);
												if (out == null)
												{
													out = new Vector.<EDRole>();
												}
											}
											out.push(role);
										}
									}
								}
							}
						}
					}
				}
			}
			return out;
		}
		
		/**
		 * [单目标]找出对应的目标
		 * @param	ed
		 * @param	type	1:敌人 , 2:友方 , 3 双方
		 * @return
		 */
		internal static function searchRoleCampOne(ed:EDBullet, type:int):EDRole
		{
			var role:EDRole;
			var count:Number;
			for each (var camp:EDCamp in ed.u.engine.campLib) 
			{
				if (camp.lengthRole)
				{
					if (type == 3 || (type == 2 && camp.camp == ed.camp) || (type == 1 && camp.camp != ed.camp))
					{
						for each (role in camp.listRole) 
						{
							if (role.isLive && role.inHot && role.canHit)
							{
								count = SearchTargetRole.pointHitRangeCount(ed.x, ed.y, role) - ed.info.info.radius;
								if (count <= 0)
								{
									return role;
								}
							}
						}
					}
				}
			}
			return null;
		}
		
		/**
		 * [单目标]找出对应的目标(血量对大的对象)
		 * @param	ed
		 * @param	type	1:敌人 , 2:友方 , 3 双方
		 * @return
		 */
		internal static function searchRoleCampOneMax(ed:EDBullet, type:int):EDRole
		{
			var role:EDRole;
			var count:Number;
			var hpMax:int = 0;
			var roleMax:EDRole;
			for each (var camp:EDCamp in ed.u.engine.campLib) 
			{
				if (camp.lengthRole)
				{
					if (type == 3 || (type == 2 && camp.camp == ed.camp) || (type == 1 && camp.camp != ed.camp))
					{
						for each (role in camp.listRole) 
						{
							if (role.isLive && role.inHot && role.canHit && role.info.hp > hpMax)
							{
								count = SearchTargetRole.pointHitRangeCount(ed.x, ed.y, role) - ed.info.info.radius;
								if (count <= 0)
								{
									roleMax = role;
								}
							}
						}
					}
				}
			}
			return roleMax;
		}
		
		/** 排序内容 **/
		private static var sortHPConfig:Array;
		/**
		 * 排序, 
		 */
		internal static function sortHPList(arr:*):void
		{
			if (sortHPConfig == null)
			{
				sortHPConfig = new Array();
				sortHPConfig.push(ObjectArraySort.getSortItem_p("info.hp", "0", ObjectArraySort.SORT_NUMBER_SMAILL_BIG, false));
			}
			ObjectArraySort.sort(arr, sortHPConfig, null, null, true);
		}
	}
}