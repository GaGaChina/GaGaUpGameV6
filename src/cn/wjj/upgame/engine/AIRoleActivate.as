package cn.wjj.upgame.engine 
{
	import cn.wjj.upgame.common.StatusTypeRole;
	
	/**
	 * 角色激活算法
	 * 
	 * @author GaGa
	 */
	public class AIRoleActivate 
	{
		
		private static var x:Number;
		private static var y:Number;
		private static var count:Number;
		
		public function AIRoleActivate() { }
		
		/**
		 * 查看视野范围内有没有敌人,有敌人就激活
		 * 
		 * 自己的警戒范围来看是否被动激活
		 */
		internal static function itLook(ed:EDRole):void
		{
			if (ed.isLive)
			{
				//如果ai类型是2,并且已经有目标就直接跳过
				var lib:Vector.<EDCamp> = ed.u.engine.campLib;
				var helpCount:Number = 8888888888;
				//距离最近的互助对象
				var help:EDRole;
				var role:EDRole;
				var campItem:EDCamp;
				var target:EDRole;
				var targetCount:Number = 8888888888;
				if (ed.info.aiType == 2 || ed.info.aiType == 3)
				{
					if (ed.ai.hatred.maxED)
					{
						//类型3,在没有完全攻击目标前,不修改新目标
						if (ed.info.aiType == 3 && ed.ai.hatred.hitMax == false)
						{
							//如果还没有杀到要去的目标,中途出现新目标,就扭头
							//找视野内最近的
							for each (campItem in lib) 
							{
								if (campItem.lengthRole && campItem.camp != ed.camp)
								{
									//敌人, 看视野
									for each (role in campItem.listRole) 
									{
										if (role.isLive && role.inHot && role.canHit)
										{
											if ((ed.ai.targetGround && role.info.typeProperty == 1)
											|| (ed.ai.targetSky && role.info.typeProperty == 2)
											|| (ed.ai.targetBuild && role.info.typeProperty == 3)
											|| (ed.ai.targetBases && role.info.typeProperty == 4))
											{
												x = ed.x - role.x;
												y = ed.y - role.y;
												count = x * x + y * y;
												if (ed.info.rangeView2 >= count && targetCount > count)
												{
													targetCount = count;
													target = role;
												}
											}
										}
									}
								}
							}
							if (target && target != ed.ai.hatred.maxED)
							{
								ed.ai.hatred.changeTarget(target);
							}
						}
					}
					else
					{
						//找到最近的,没有在看互帮助对象
						if (ed.ai.hatred.priorityTarget)
						{
							if (ed.ai.hatred.priorityTarget.isLive)
							{
								x = ed.x - ed.ai.hatred.priorityTarget.x;
								y = ed.y - ed.ai.hatred.priorityTarget.y;
								count = x * x + y * y;
								if (count <= ed.info.rangeView2)
								{
									ed.ai.hatred.changeTarget(ed.ai.hatred.priorityTarget);
									return;
								}
							}
							else
							{
								ed.ai.hatred.priorityTarget = null;
							}
						}
						if (ed.ai.hatred.maxED == null)
						{
							//找视野内最近的
							for each (campItem in lib) 
							{
								if (campItem.lengthRole)
								{
									if (campItem.camp == ed.camp)
									{
										if (ed.info.aiType == 2 && ed.activate == false)
										{
											//看互助, 自己人
											for each (role in campItem.listRole) 
											{
												if (role.isLive && role.activate && ed != role && role.canHit)
												{
													x = ed.x - role.x;
													y = ed.y - role.y;
													count = x * x + y * y;
													if (ed.info.rangeGuard2 >= count && helpCount > count)
													{
														helpCount = count;
														help = role;
													}
												}
											}
										}
									}
									else
									{
										//敌人, 看视野
										for each (role in campItem.listRole) 
										{
											if (role.isLive && role.inHot && role.canHit)
											{
												if ((ed.ai.targetGround && role.info.typeProperty == 1)
												|| (ed.ai.targetSky && role.info.typeProperty == 2)
												|| (ed.ai.targetBuild && role.info.typeProperty == 3)
												|| (ed.ai.targetBases && role.info.typeProperty == 4))
												{
													x = ed.x - role.x;
													y = ed.y - role.y;
													count = x * x + y * y;
													if (ed.info.rangeView2 >= count && targetCount > count)
													{
														targetCount = count;
														target = role;
													}
												}
											}
										}
									}
								}
							}
							if (target)
							{
								if (ed.activate == false)
								{
									ed.activate = true;
								}
								ed.ai.hatred.changeTarget(target);
							}
							else if(ed.activate == false && help)
							{
								AIRoleHatred.clone(help.ai.hatred as AIRoleHatred, ed.ai.hatred as AIRoleHatred);
								ed.activate = true;
							}
						}
					}
				}
				else
				{
					//是否被激活(未激活需要找敌对目标进行激活)
					//找的目标所在阵营类型
					for each (campItem in lib) 
					{
						if (campItem.lengthRole)
						{
							if (campItem.camp == ed.camp)
							{
								if (ed.activate == false)
								{
									//看互助, 自己人
									for each (role in campItem.listRole) 
									{
										if (role.isLive && role.activate && ed != role && role.canHit)
										{
											x = ed.x - role.x;
											y = ed.y - role.y;
											count = x * x + y * y;
											if (ed.info.rangeGuard2 >= count && helpCount > count)
											{
												helpCount = count;
												help = role;
											}
										}
									}
								}
							}
							else
							{
								//敌人, 看视野
								for each (role in campItem.listRole) 
								{
									if (role.isLive && role.inHot && role.canHit)
									{
										x = ed.x - role.x;
										y = ed.y - role.y;
										count = x * x + y * y;
										if (ed.info.rangeView2 >= count)
										{
											ed.ai.hatred.add(role, 0);
											if (ed.activate == false)
											{
												ed.activate = true;
											}
										}
									}
								}
							}
						}
					}
					//未激活怪物,当检测到有助战好友的时候,复制仇恨列表
					if (ed.activate == false && help)
					{
						AIRoleHatred.clone(help.ai.hatred as AIRoleHatred, ed.ai.hatred as AIRoleHatred);
						ed.activate = true;
					}
					//检测优先攻击目标是否进入视野,进入就切换攻击优先攻击目标
					if (ed.ai.hatred.priorityTarget)
					{
						if (ed.ai.hatred.priorityTarget.isLive)
						{
							x = ed.x - ed.ai.hatred.priorityTarget.x;
							y = ed.y - ed.ai.hatred.priorityTarget.y;
							count = x * x + y * y;
							if (count <= ed.info.rangeView2)
							{
								ed.ai.hatred.changeTarget(ed.ai.hatred.priorityTarget);
							}
						}
						else
						{
							ed.ai.hatred.priorityTarget = null;
						}
					}
				}
			}
		}
	}
}