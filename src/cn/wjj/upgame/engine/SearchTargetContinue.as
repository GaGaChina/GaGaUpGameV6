package cn.wjj.upgame.engine 
{
	import cn.wjj.g;
	
	/**
	 * 区域技能寻找目标
	 * 
	 * @author GaGa
	 */
	public class SearchTargetContinue 
	{
		public function SearchTargetContinue() { }
		
		/**
		 * [多目标]找出对应的目标
		 * @param	ed
		 * @param	type	1:敌人 , 2:友方 , 3 双方
		 * @return
		 */
		public static function range(ed:EDSkillContinue, type:int):Vector.<EDRole>
		{
			var out:Vector.<EDRole>;
			var role:EDRole;
			var edItem:EDBase;
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
								count = SearchTargetRole.pointHitRangeCount(ed.x, ed.y, role) - ed.effect.effect.rangeR;
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
	}
}