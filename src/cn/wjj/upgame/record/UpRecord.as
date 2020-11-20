package cn.wjj.upgame.record 
{
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.upgame.common.RecordType;
	import cn.wjj.upgame.engine.EDRole;
	import cn.wjj.upgame.UpGame;
	import cn.wjj.upgame.UpGameConfig;
	
	/**
	 * 记录器
	 * 
	 * 行为动作记录器(用户操作的记录)
	 * 战斗数据记录器(战斗中的各种记录)
	 * 
	 * action.init = new Object();
	 * 
	 * action[timeGame] = new Object();
	 * action[timeGame][阵营] = new Array();
	 * action[timeGame][阵营][1] = {"type":1, "info":{参数}}
	 * 
	 * 
	 * "行走", ID, X , Y
	 * 
	 * @author GaGa
	 */
	public class UpRecord 
	{
		/** 父引用 **/
		public var u:UpGame;
		/** 行为动作记录 **/
		public var action:Object;
		/** 行为动作记录的长度 **/
		public var actionLength:int = 0;
		/** 实况记录 **/
		public var live:Object;
		/** 实况记录的长度 **/
		public var liveLength:int = 0;
		/** 游戏初始化信息 **/
		public var init:GameInit;
		
		public function UpRecord(u:UpGame)
		{
			this.u = u;
			action = g.speedFact.n_object();
			live = g.speedFact.n_object();
			init = new GameInit(u);
		}
		
		/** 获取记录的日志部分 **/
		public function getLive():Object
		{
			var o:Object = g.speedFact.n_object();
			o.live = live;
			o.liveLength = liveLength;
			o.engineFrame = u.engine.time.timeFrame;
			o.randomGroup = u.randomGroup;
			o.randomSite = u.randomSite;
			return o;
		}
		
		/**
		 * 释放某种卡牌
		 * @param	id			释放某一个ID的卡牌
		 * @param	playerId	释放卡牌的玩家ID
		 * @param	camp		阵营ID
		 * @param	xyType		X,Y所属类型, 1 格子 ,2 实际坐标
		 * @param	x			格子ID
		 * @param	y			格子ID
		 * @param	addTime		累加的时间,如果没有,就累加displayFrame
		 * @param	delEnergy	是否进行扣费处理
		 * @param	useAddTime	强制使用时间
		 */
		public function releaseCard(id:int, playerId:int, camp:int, xyType:int, x:int, y:int, addTime:int = 0, delEnergy:Boolean = false, useAddTime:Boolean = false):void
		{
			var o:Object = g.speedFact.n_object();
			o.type = RecordType.ReleaseCard;
			o.id = id;
			o.playerId = playerId;
			o.camp = camp;
			o.xyType = xyType;
			o.x = x;
			o.y = y;
			o.del = delEnergy;
			if (addTime > 0 || (addTime == 0 && u.engine.time.roundOver == false))
			{
				var a:Array = getSaveArray(camp, addTime, useAddTime);
				a.push(o);
			}
			else
			{
				if (camp == 1)
				{
					u.engine.time.runActionItem(u.engine.camp1, o, (addTime + u.engine.time.timeGame));
				}
				else if(camp == 2)
				{
					u.engine.time.runActionItem(u.engine.camp2, o, (addTime + u.engine.time.timeGame));
				}
			}
			
		}
		
		/**
		 * 收到修改卡牌
		 * @param	id			释放的卡牌ID
		 * @param	playerId	玩家ID
		 * @param	addTime		释放出来的时间点,减去卡牌释放时间,就是要释放出来的时间
		 * @param	next		下一个卡牌ID
		 * @param	useAddTime	是否强制使用addTime
		 */
		public function changeCard(id:int, playerId:int, camp:int, addTime:int, next:uint, useAddTime:Boolean):void
		{
			var o:Object = g.speedFact.n_object();
			o.type = RecordType.ChangeCard;
			o.id = id;
			o.playerId = playerId;
			o.camp = camp;
			o.next = next;//下次出场卡牌ID
			o.dtime = addTime + u.engine.time.timeGame + UpGameConfig.timeInfoSend + UpGameConfig.cardDownTime;
			if (addTime > 0 || (addTime == 0 && u.engine.time.roundOver == false))
			{
				var a:Array = getSaveArray(camp, addTime, useAddTime);
				a.push(o);
			}
			else
			{
				if (camp == 1)
				{
					u.engine.time.runActionItem(u.engine.camp1, o, (addTime + u.engine.time.timeGame));
				}
				else if(camp == 2)
				{
					u.engine.time.runActionItem(u.engine.camp2, o, (addTime + u.engine.time.timeGame));
				}
			}
		}
		
		/**
		 * 修改能量增加速度
		 * @param	addTime				累加的时间,如果没有,就累加displayFrame
		 * @param	energyScaleSpeed	修正的能量增长速度
		 */
		public function changeEnergyScale(addTime:int, energyScaleSpeed:Number, useAddTime:Boolean = false):void
		{
			var a:Array = getSaveArray(1, addTime, useAddTime);
			var o:Object = g.speedFact.n_object();
			o.type = RecordType.ChangeEnergyScale;
			o.energyScaleSpeed = energyScaleSpeed;
			a.push(o);
		}
		
		/**
		 * 选中某中卡牌
		 * @param	playerId
		 * @param	index
		 * @param	camp
		 * @param	addTime
		 */
		public function selectCard(playerId:int, index:int, camp:int, addTime:int = 0, useAddTime:Boolean = false):void
		{
			var a:Array = getSaveArray(camp, addTime, useAddTime);
			var o:Object = g.speedFact.n_object();
			o.type = RecordType.SelectCard;
			o.playerId = playerId;
			o.camp = camp;
			o.index = index;
			a.push(o);
		}
		
		/**
		 * 直接移动对象到某一个坐标点
		 * @param	role	对象
		 * @param	x		像素坐标
		 * @param	y		像素坐标
		 */
		public function changePoint(role:EDRole, x:int, y:int, addTime:int = 0, useAddTime:Boolean = false):void
		{
			var o:Object = g.speedFact.n_object();
			o.type = RecordType.ChangePoint;
			o.id = role.info.serverId;
			o.x = x;
			o.y = y;
			if (addTime > 0 || (addTime == 0 && u.engine.time.roundOver == false))
			{
				if (role.isLive && role.info)
				{
					if (role.info.serverId)
					{
						var a:Array = getSaveArray(role.camp, addTime, useAddTime);
						a.push(o);
					}
					else
					{
						g.log.pushLog(this, LogType._ErrorLog, "添加移动事件对象无ServerId");
					}
				}
			}
			else
			{
				if (role.camp == 1)
				{
					u.engine.time.runActionItem(u.engine.camp1, o, (addTime + u.engine.time.timeGame));
				}
				else if(role.camp == 2)
				{
					u.engine.time.runActionItem(u.engine.camp2, o, (addTime + u.engine.time.timeGame));
				}
			}
		}
		
		
		/**
		 * 添加移动行走事件
		 * @param	role
		 * @param	x
		 * @param	y
		 * @param	lock
		 */
		public function movePoint(role:EDRole, x:int, y:int, lock:Boolean, addTime:int = 0, useAddTime:Boolean = false):void
		{
			if (role && role.isLive && role.info)
			{
				if (role.info.serverId)
				{
					var a:Array = getSaveArray(role.camp, addTime, useAddTime);
					var o:Object = g.speedFact.n_object();
					o.type = RecordType.MovePoint;
					o.id = role.info.serverId;
					o.x = x;
					o.y = y;
					o.lock = lock;
					a.push(o);
				}
				else
				{
					g.log.pushLog(this, LogType._ErrorLog, "添加移动事件对象无ServerId");
				}
			}
		}
		
		/**
		 * 停止移动
		 * @param	role
		 */
		public function moveStop(role:EDRole, addTime:int = 0, useAddTime:Boolean = false):void
		{
			if (role && role.isLive && role.info)
			{
				if (role.info.serverId)
				{
					var a:Array = getSaveArray(role.camp, addTime, useAddTime);
					var o:Object = g.speedFact.n_object();
					o.type = RecordType.MoveStop;
					o.id = role.info.serverId;
					a.push(o);
				}
				else
				{
					g.log.pushLog(this, LogType._ErrorLog, "添加停止移动无ServerId");
				}
			}
		}
		
		/**
		 * 选中角色
		 * @param	role
		 */
		public function selectTarget(role:EDRole, target:EDRole, addTime:uint = 0, useAddTime:Boolean = false):void
		{
			if (role && role.isLive && role.info && target && target.isLive && target.info)
			{
				if (role.info.serverId && target.info.serverId)
				{
					var a:Array = getSaveArray(role.camp, addTime, useAddTime);
					var o:Object = g.speedFact.n_object();
					o.type = RecordType.SelectTarget;
					o.id = role.info.serverId;
					o.target = target.info.serverId;
					a.push(o);
				}
				else
				{
					g.log.pushLog(this, LogType._ErrorLog, "选中角色无ServerId");
				}
			}
		}
		
		/**
		 * 释放技能
		 * @param	role
		 * @param	index
		 */
		public function releaseSkill(role:EDRole, index:int, addTime:uint = 0, useAddTime:Boolean = false):void
		{
			if (role && role.isLive && role.info)
			{
				if (role.info.serverId)
				{
					var a:Array = getSaveArray(role.camp, addTime, useAddTime);
					var o:Object = g.speedFact.n_object();
					o.type = RecordType.ReleaseSkill;
					o.id = role.info.serverId;
					o.index = index;
					a.push(o);
				}
				else
				{
					g.log.pushLog(this, LogType._ErrorLog, "选中角色无ServerId");
				}
			}
		}
		
		/**
		 * 选择最近目标攻击,如果有target在视野里就选择攻击这个对象
		 * @param	role
		 * @param	target
		 */
		public function findHitRole(role:EDRole, target:EDRole = null, addTime:uint = 0, useAddTime:Boolean = false):void
		{
			if (role && role.isLive && role.info)
			{
				if (role.info.serverId)
				{
					var a:Array = getSaveArray(role.camp, addTime, useAddTime);
					var o:Object = g.speedFact.n_object();
					o.type = RecordType.FindHitRole;
					o.id = role.info.serverId;
					if (target)
					{
						if (target.isLive && target.info && target.info.serverId)
						{
							o.target = target.info.serverId;
							g.log.pushLog(this, LogType._ErrorLog, "target无ServerId");
							return;
						}
					}
					else
					{
						o.target = 0;
					}
					a.push(o);
				}
				else
				{
					g.log.pushLog(this, LogType._ErrorLog, "选中角色无ServerId");
				}
			}
		}
		
		/**
		 * 清除仇恨值
		 * @param	role
		 */
		public function clearHatred(role:EDRole, addTime:uint = 0, useAddTime:Boolean = false):void
		{
			if (role && role.isLive && role.info)
			{
				if (role.info.serverId)
				{
					var a:Array = getSaveArray(role.camp, addTime, useAddTime);
					var o:Object = g.speedFact.n_object();
					o.type = RecordType.ClearHatred;
					o.id = role.info.serverId;
					a.push(o);
				}
				else
				{
					g.log.pushLog(this, LogType._ErrorLog, "添加清理仇恨无ServerId");
				}
			}
		}
		
		/**
		 * 获取操作事件要保存在那个数组里
		 * @param	camp
		 * @param	addTime		累加的时间,如果没有,就累加displayFrame
		 * @param	useAddTime	是否强制使用addTime
		 * @return
		 */
		private function getSaveArray(camp:int, addTime:int = 0, useAddTime:Boolean = false):Array
		{
			var o:Object;
			var runTime:uint = u.engine.time.timeGame;
			if (addTime || useAddTime)
			{
				runTime += addTime;
			}
			else
			{
				runTime += u.engine.time.timeFrame;
			}
			if (action.hasOwnProperty(runTime))
			{
				o = action[runTime];
			}
			else
			{
				o = g.speedFact.n_object();
				action[runTime] = o;
			}
			var a:Array;
			if (o.hasOwnProperty(camp))
			{
				a = o[camp];
			}
			else
			{
				a = g.speedFact.n_array();
				o[camp] = a;
			}
			actionLength++;
			return a;
		}
		
		/** 摧毁对象 **/
		public function dispose():void
		{
			u = null;
			var key:String;
			var timeGame:String;
			var camp:Object;
			var list:Array;
			var id:String;
			if (action)
			{
				if (actionLength)
				{
					for(timeGame in action)
					{
						camp = action[timeGame];
						for(id in camp)
						{
							list = camp[id];
							delete camp[id];
							g.speedFact.d_array(list);
						}
						delete action[timeGame];
						g.speedFact.d_object(camp);
					}
					actionLength = 0;
				}
				g.speedFact.d_object(action);
				action = null;
			}
			if (init)
			{
				init.dispose();
				init = null;
			}
		}
	}
}