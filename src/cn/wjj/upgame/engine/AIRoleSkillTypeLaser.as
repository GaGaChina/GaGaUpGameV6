package cn.wjj.upgame.engine 
{
	import cn.wjj.g;
	import cn.wjj.upgame.common.IOtherSkillRun;
	
	/**
	 * 激光技能
	 * 
	 * 垂直激光,如果有2个发射点,可以发出2条激光,宽度固定为50
	 * 主动技能表,用技能循环
	 * 默认去动作的第一个,其他的不管
	 * 
	 * skill -> 很多动作,取第一个动作
	 * 动作里有马上生效技能,就取出效果.(取消)
	 * 动作里无马上生效技能,取子弹列表.
	 * 
	 * 如果是子弹,找出第一个子弹挂的第一个效果.为激光效果.其他忽略
	 * 找出第一个子弹的信息,取pathId特效ID,为激光的特效
	 * 
	 * 激光外形取的这个,方向横向,发射点在(0,0),横向为0度(和子弹一样制作,子弹目录,没有屁股,所以需要从0.0点向右延长)
	 * 
	 * 
	 * SkillActiveModel 主动技能
	 * skill.loopTime	: 单次时间
	 * skill.loop		: 次数
	 * 
	 * UpGameBulletInfo 子弹
	 * bulletInfo.radius	: 激光半径
	 * 
	 * @author GaGa
	 */
	public class AIRoleSkillTypeLaser implements IOtherSkillRun 
	{
		
		/** 是否属于激活的 **/
		private var isLive:Boolean = true;
		/** 主动技能引用 **/
		private var skill:AIRoleSkill;
		/** 激光列表 AIRoleSkillTypeLaserItem **/
		private var listLaser:Array;
		private var listLength:int = 0;
		/** 临时处理数据 **/
		private var listLaserCopy:Array;
		/** 是否是垂直激光 **/
		internal var vertical:Boolean = true;
		
		public function AIRoleSkillTypeLaser() { }
		
		/**
		 * 开始释放特殊技能
		 * @param	skill			激光主动技能
		 * @param	useTime			时间
		 * @return
		 */
		public function start(skill:AIRoleSkill, useTime:uint):Boolean
		{
			if (skill.actionList.length && skill.skill.loopTime > 0 && skill.skill.loop > 0)
			{
				this.skill = skill;
				listLaser = g.speedFact.n_array();
				listLaserCopy = g.speedFact.n_array();
				return enterFrame(useTime);
			}
			return true;
		}
		
		/**
		 * 每帧都运行这个特殊技能,返回是否已经结束
		 * 
		 * SkillActiveModel 主动技能
		 * skill.loopTime	: 单次时间
		 * skill.loop		: 次数
		 * 
		 * @param	useTime
		 * @return
		 */
		public function enterFrame(useTime:uint):Boolean
		{
			var isOver:Boolean = false;
			if (isLive && skill.ed.isLive)
			{
				var s:AIRoleSkill = skill;
				var item:AIRoleSkillTypeLaserItem;
				var itemOver:Boolean = false;
				var index:int;
				if (listLength)
				{
					listLaserCopy.push.apply(null, listLaser);
					for each (item in listLaserCopy) 
					{
						itemOver = item.enterFrame(useTime);
						if (isLive && itemOver)
						{
							index = listLaser.indexOf(item);
							listLaser.splice(index, 1);
							listLength--;
						}
					}
					if(isLive)
					{
						listLaserCopy.length = 0;
					}
				}
				if(isLive)
				{
					var canDo:Boolean = true;
					while (canDo)
					{
						if (skill)
						{
							canDo = false;
							if (s.actionLength > s.actionIndex)
							{
								s.actionRun = s.actionList[s.actionIndex];
								if (s.actionRun.time <= useTime)
								{
									canDo = true;
									s.actionIndex++;
									if (isLive)
									{
										if (s.ed.u.readerStart && s.actionRun.shakeLength > 0 && s.actionRun.shakeType != 0 && (s.actionRun.shakeX != 0 || s.actionRun.shakeY != 0))
										{
											s.ed.u.reader.shake.push(s.actionRun.shakeType, s.actionRun.shakeX, s.actionRun.shakeY, s.actionRun.shakeTime, s.actionRun.shakeLength);
										}
										if (s.actionRun.skillId)
										{
											item = new AIRoleSkillTypeLaserItem();
											itemOver = item.start(s.actionRun, useTime, vertical);
											if (isLive && itemOver == false)
											{
												listLength++;
												listLaser.push(item);
											}
											else
											{
												item.dispose();
											}
										}
									}
									//技能释放完毕
									if (s.actionIndex >= s.actionLength)
									{
										if (listLength)
										{
											return false;
										}
										return true;
									}
								}
							}
							else
							{
								if (listLength)
								{
									return false;
								}
								return true;
							}
						}
						else
						{
							isOver = true;
							break;
						}
					}
					return false;
				}
			}
			else
			{
				isOver = true;
			}
			//结束
			if (isOver)
			{
				dispose();
			}
			if(isLive == false)
			{
				return true;
			}
			return isOver;
		}
		
		/** 移除,清理,并回收 **/
		public function dispose():void
		{
			if(isLive)
			{
				isLive = false;
				if (listLength)
				{
					for each (var item:AIRoleSkillTypeLaserItem in listLaser) 
					{
						item.dispose();
					}
					listLength = 0;
				}
				if (listLaser)
				{
					g.speedFact.d_array(listLaser);
					listLaser = null;
				}
				if (listLaserCopy)
				{
					g.speedFact.d_array(listLaserCopy);
					listLaserCopy = null;
				}
				if(skill) skill = null;
			}
		}
	}
}