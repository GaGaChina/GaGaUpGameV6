package cn.wjj.upgame.report 
{
	import cn.wjj.crypto.CRC32;
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.upgame.common.EDType;
	import cn.wjj.upgame.common.IUpReport;
	import cn.wjj.upgame.common.StatusTypeRole;
	import cn.wjj.upgame.common.UpGameEvent;
	import cn.wjj.upgame.engine.AIRoleSkill;
	import cn.wjj.upgame.engine.EDBase;
	import cn.wjj.upgame.engine.EDBullet;
	import cn.wjj.upgame.engine.EDRole;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 游戏战报
	 * @author GaGa
	 */
	public class UpReport
	{
		
		/**
		 * 攻击者ID
		 * 攻击者阵营
		 * 攻击者位置
		 * 攻击者施法时间
		 * 攻击者技能ID
		 * 
		 *     击中目标
		 *         目标1 : 1111
		 *                  目标坐标
		 *                  属性变化
		 *                  击中时间
		 *                  
		 *         目标2 : 2222
		 */
		
		/** 是否启动CRC校验功能 **/
		public static var startCheck:Boolean = false;
		/** 是否启用CRC累计叠加 **/
		public static var startConnect:Boolean = true;
		/** 是否开启每一帧的校验 **/
		public static var startFrameCheck:Boolean = false;
		
		/** 父引用 **/
		public var u:UpGame;
		/** 日志记录器 **/
		public var report:IUpReport;
		/** 是否开记录 **/
		private var start:Boolean = false;
		/** 记录的动作或效果的序号 **/
		public var index:uint = 0;
		
		/** 字符串处理 **/
		private var crcStr:String;
		/** CRC32内容 **/
		public var crc:uint = 0;
		/** CRC32的对比 **/
		public var info:Array = new Array();
		/** CRC32的备份 **/
		public var infoBack:Array = new Array();
		
		/** CRC32每一帧的对比 **/
		public var frameInfo:Array = new Array();
		/** CRC32每一帧的备份 **/
		public var frameInfoBack:Array = new Array();
		
		/** 是否报出错误 **/
		public var showError:Boolean = true;
		/** 是否报出错误 **/
		public var showErrorFrame:Boolean = true;
		
		public function UpReport(upGame:UpGame) 
		{
			this.u = upGame;
		}
		
		/**
		 * 设置记录数据接口
		 * @param	report
		 */
		public function setIUpReport(report:IUpReport):void
		{
			if (report)
			{
				start = true;
			}
			else
			{
				start = false;
			}
			this.report = report;
		}
		
		/** 日志中的一部分 **/
		private function get logHead():String
		{
			return "[" + u.random_g + "][" + u.random_s + "][" + u.engine.time.timeGame + "]";
		}
		
		/**
		 * 获取到人物的一些信息
		 * @param	attackID
		 * @param	target
		 * @return
		 */
		private function edLog(attackID:int, target:EDRole):String
		{
			var s:String = "";
			var attack:EDRole;
			if (attackID && u.engine.playerLength)
			{
				for each (var ed:EDRole in u.engine.playerList) 
				{
					if (ed.info && ed.info.serverId == attackID)
					{
						attack = ed;
						break;
					}
				}
			}
			if (attack)
			{
				s += "[" + attack.camp + "-" + attackID + ":" + ed.x + "," + ed.y + "," + ed.angle + "]";
			}
			else
			{
				s += "[无]";
			}
			if (target)
			{
				s += "[" + target.camp + "-" + target.info.serverId + ":" +target.x + "," + target.y + "," + target.angle + "]";
			}
			else
			{
				s += "[无]";
			}
			return s;
		}
		
		/**
		 * 已经命中敌人
		 * @param	reportId		记录的ID排序
		 * @param	attackID		攻击者ID
		 * @param	attackCamp		攻击者阵营
		 * @param	attackIdx		攻击者的序号
		 * @param	attackCall		攻击者是否召唤
		 * @param	reportX			攻击发起者或子弹对象(坐标)
		 * @param	reportY			攻击发起者或子弹对象(坐标)
		 * @param	target			目标
		 * @param	skillId			主动技能ID
		 * @param	actionId		动作技能ID
		 * @param	actionSubId		动作技能子动作ID
		 * @param	effectId		效果表ID
		 * @param	hp				血的变化
		 * @param	crit			爆击
		 * @param	die				是否死亡
		 */
		public function hit(reportId:uint, attackID:uint, attackCamp:int, attackIdx:int, attackCall:Boolean, reportX:int, reportY:int, target:EDRole, skillId:uint, actionId:uint, actionSubId:uint, effectId:uint, hp:int, crit:Boolean, die:Boolean = false):void
		{
			if (start && target && target.isLive)
			{
				report.hit(reportId, attackID, attackCamp, attackIdx, attackCall, reportX, reportY, target, skillId, actionId, actionSubId, effectId, hp, crit, die);
				if (startCheck)
				{
					crcStr = u.engine.time.timeGame + reportId + attackID + attackCamp + attackIdx + attackCall + reportX + reportY + target.info.serverId + skillId + actionId + actionSubId + effectId + hp + crit + die;
					if (startConnect) crcStr = String(crc) + crcStr;
					crc = CRC32.getStr(crcStr);
					info.push(crc + " " + logHead + "[" + reportId + "][" + attackIdx + "][" + attackCall + "][" + reportX + "][" + reportY + "][" + skillId + "][" + actionId + "][" + actionSubId + "][" + effectId + "][" + hp + "][" + crit + "][" + die + "]" + edLog(attackID, target));
					checkError();
				}
			}
		}
		
		/**
		 * 闪避
		 * @param	reportId		记录的ID排序
		 * @param	attackID		攻击者ID
		 * @param	attackCamp		攻击者阵营
		 * @param	attackIdx		攻击者的序号
		 * @param	attackCall		攻击者是否召唤
		 * @param	reportX			攻击发起者或子弹对象(坐标)
		 * @param	reportY			攻击发起者或子弹对象(坐标)
		 * @param	target			目标
		 * @param	skillId			主动技能ID
		 * @param	actionId		动作技能ID
		 * @param	actionSubId		动作技能子动作ID
		 * @param	effectId		效果表ID
		 */
		public function miss(reportId:uint, attackID:uint, attackCamp:int, attackIdx:int, attackCall:Boolean, reportX:int, reportY:int, target:EDRole, skillId:uint, actionId:uint, actionSubId:uint, effectId:uint):void
		{
			if (start && target && target.isLive)
			{
				report.miss(reportId, attackID, attackCamp, attackIdx, attackCall, reportX, reportY, target, skillId, actionId, actionSubId, effectId);
				if (startCheck)
				{
					crcStr = u.engine.time.timeGame + reportId + attackID + attackCamp + attackIdx + attackCall + reportX + reportY + target.info.serverId + skillId + actionId + actionSubId + effectId;
					if (startConnect) crcStr = String(crc) + crcStr;
					crc = CRC32.getStr(crcStr);
					info.push(crc + " " + logHead + "[" + reportId + "][" + attackIdx + "][" + attackCall + "][" + reportX + "][" + reportY + "][" + skillId + "][" + actionId + "][" + actionSubId + "][" + effectId + "]" + edLog(attackID, target));
					checkError();
				}
			}
		}
		
		/**
		 * 添加BUFF
		 * @param	reportId		记录的ID排序
		 * @param	attackID		攻击者ID
		 * @param	attackCamp		攻击者阵营
		 * @param	attackIdx		攻击者的序号
		 * @param	attackCall		攻击者是否召唤
		 * @param	reportX			攻击发起者或子弹对象(坐标)
		 * @param	reportY			攻击发起者或子弹对象(坐标)
		 * @param	target			目标
		 * @param	skillId			主动技能ID
		 * @param	actionId		动作技能ID
		 * @param	actionSubId		动作技能子动作ID
		 * @param	effectId		效果表ID
		 * @param	addbuff			添加buff的ID
		 */
		public function addBuff(reportId:uint, attackID:uint, attackCamp:int, attackIdx:int, attackCall:Boolean, reportX:int, reportY:int, target:EDRole, skillId:uint, actionId:uint, actionSubId:uint, effectId:uint, addbuff:uint):void
		{
			if (start && target && target.isLive)
			{
				report.addBuff(reportId, attackID, attackCamp, attackIdx, attackCall, reportX, reportY, target, skillId, actionId, actionSubId, effectId, addbuff);
				if (startCheck)
				{
					crcStr = u.engine.time.timeGame + reportId + attackID + attackCamp + attackIdx + attackCall + reportX + reportY + target.info.serverId + skillId + actionId + actionSubId + effectId + addbuff;
					if (startConnect) crcStr = String(crc) + crcStr;
					crc = CRC32.getStr(crcStr);
					info.push(crc + " " + logHead + "[" + reportId + "][" + attackIdx + "][" + attackCall + "][" + reportX + "][" + reportY + "][" + skillId + "][" + actionId + "][" + actionSubId + "][" + effectId + "][" + addbuff + "]" + edLog(attackID, target));
					checkError();
				}
			}
		}
		
		/**
		 * 删除BUFF
		 * @param	reportId		记录的ID排序
		 * @param	attackID		攻击者ID
		 * @param	attackCamp		攻击者阵营
		 * @param	attackIdx		攻击者的序号
		 * @param	attackCall		攻击者是否召唤
		 * @param	reportX			攻击发起者或子弹对象(坐标)
		 * @param	reportY			攻击发起者或子弹对象(坐标)
		 * @param	target			目标
		 * @param	skillId			主动技能ID
		 * @param	actionId		动作技能ID
		 * @param	actionSubId		动作技能子动作ID
		 * @param	effectId		效果表ID
		 * @param	removebuff		移除buff的ID
		 */
		public function removeBuff(reportId:uint, attackID:uint, attackCamp:int, attackIdx:int, attackCall:Boolean, reportX:int, reportY:int, target:EDRole, skillId:uint, actionId:uint, actionSubId:uint, effectId:uint, removebuff:uint):void
		{
			if (start && target && target.isLive)
			{
				report.addBuff(reportId, attackID, attackCamp, attackIdx, attackCall, reportX, reportY, target, skillId, actionId, actionSubId, effectId, removebuff);
				if (startCheck)
				{
					crcStr = u.engine.time.timeGame + reportId + attackID + attackCamp + attackIdx + attackCall + reportX + reportY + target.info.serverId + skillId + actionId + actionSubId + effectId + removebuff;
					if (startConnect) crcStr = String(crc) + crcStr;
					crc = CRC32.getStr(crcStr);
					info.push(crc + " " + logHead + "[" + reportId + "][" + attackIdx + "][" + attackCall + "][" + reportX + "][" + reportY + "][" + skillId + "][" + actionId + "][" + actionSubId + "][" + effectId + "][" + removebuff + "]" + edLog(attackID, target));
					checkError();
				}
			}
		}
		
		/**
		 * 召唤ID
		 * @param	reportId		记录的ID排序
		 * @param	attackID		召唤者ID
		 * @param	attackCamp		召唤者阵营
		 * @param	attackIdx		攻击者的序号
		 * @param	attackCall		攻击者是否召唤
		 * @param	reportX			攻击发起者或子弹对象(坐标)
		 * @param	reportY			攻击发起者或子弹对象(坐标)
		 * @param	target			目标
		 * @param	skillId			主动技能ID
		 * @param	actionId		动作技能ID
		 * @param	actionSubId		动作技能子动作ID
		 * @param	effectId		效果表ID
		 * @param	id				召唤怪物ID
		 */
		public function callMonster(reportId:uint, attackID:uint, attackCamp:int, attackIdx:int, attackCall:Boolean, reportX:int, reportY:int, target:EDRole, skillId:uint, actionId:uint, actionSubId:uint, effectId:uint, id:uint):void
		{
			if (start && target && target.isLive)
			{
				report.callMonster(reportId, attackID, attackCamp, attackIdx, attackCall, reportX, reportY, target, skillId, actionId, actionSubId, effectId, id);
				if (startCheck)
				{
					crcStr = u.engine.time.timeGame + reportId + attackID + attackCamp + attackIdx + attackCall + reportX + reportY + target.info.serverId + skillId + actionId + actionSubId + effectId + id;
					if (startConnect) crcStr = String(crc) + crcStr;
					crc = CRC32.getStr(crcStr);
					info.push(crc + " " + logHead + "[" + reportId + "][" + attackIdx + "][" + attackCall + "][" + reportX + "][" + reportY + "][" + skillId + "][" + actionId + "][" + actionSubId + "][" + effectId + "][" + id + "]" + edLog(attackID, target));
					checkError();
				}
			}
		}
		
		/**
		 * 替补出场
		 * @param	attackID		替换对象的ID
		 * @param	attackCamp		替换对象的阵营
		 * @param	attackIdx		攻击者的序号
		 * @param	attackCall		攻击者是否召唤
		 * @param	reportX			替补出现位置
		 * @param	reportY			替补出现位置
		 * @param	target			替补
		 * @param	roleId			
		 */
		public function callBench(attackID:uint, attackCamp:int, attackIdx:int, attackCall:Boolean, reportX:int, reportY:int, target:EDRole, roleId:uint):void
		{
			if (start && target && target.isLive)
			{
				report.callBench(attackID, attackCamp, attackIdx, attackCall, reportX, reportY, target, roleId);
				if (startCheck)
				{
					crcStr = u.engine.time.timeGame + attackID + attackCamp + attackIdx + attackCall + reportX + reportY + target.info.serverId + roleId;
					if (startConnect) crcStr = String(crc) + crcStr;
					crc = CRC32.getStr(crcStr);
					info.push(crc + " " + logHead + "[" + attackIdx + "][" + attackCall + "][" + reportX + "][" + reportY + "][" + roleId + "]" + edLog(attackID, target));
					checkError();
				}
			}
		}
		
		/**
		 * 召唤怪物消失,因为时间到时间到了
		 * @param	attackID		替换对象的ID
		 * @param	attackCamp		替换对象的阵营
		 * @param	attackIdx		攻击者的序号
		 * @param	attackCall		攻击者是否召唤
		 * @param	reportX			替补出现位置
		 * @param	reportY			替补出现位置
		 * @param	target			替补
		 * @param	id				ID
		 */
		public function removeMonster(attackID:uint, attackCamp:int, attackIdx:int, attackCall:Boolean, reportX:int, reportY:int, target:EDRole, id:uint):void
		{
			if (start && target && target.isLive)
			{
				report.removeMonster(attackID, attackCamp, attackIdx, attackCall, reportX, reportY, target, id);
				if (startCheck)
				{
					crcStr = u.engine.time.timeGame + attackID + attackCamp + attackIdx + attackCall + reportX + reportY + target.info.serverId + id;
					if (startConnect) crcStr = String(crc) + crcStr;
					crc = CRC32.getStr(crcStr);
					info.push(crc + " " + logHead + "[" + attackIdx + "][" + attackCall + "][" + reportX + "][" + reportY + "][" + id + "]" + edLog(attackID, target));
					checkError();
				}
			}
		}
		
		/** 校验错误 **/
		private function checkError():void
		{
			if (showError && infoBack && info.length <= infoBack.length && infoBack[info.length - 1] != info[info.length - 1])
			{
				showError = false;
				g.log.pushLog(this, LogType._ErrorLog, "游戏校验失败,时间" + u.engine.time.timeGame);
				g.log.pushLog(this, LogType._ErrorLog, infoBack[info.length - 1]);
				g.log.pushLog(this, LogType._ErrorLog, info[info.length - 1]);
				u.dispatchEvent(new UpGameEvent(UpGameEvent.reportError));
			}
		}
		
		/** 开启每帧校验 **/
		public function enterFrame():void
		{
			var o:Object = new Object();
			o.enginePlayList = new Array();
			for each (var role:EDRole in u.engine.playerList) 
			{
				if (role.isLive)
				{
					o.enginePlayList.push(getRoleLog(role));
				}
			}
			
			o.engineCallList = new Array();
			for each (role in u.engine.playerCallList) 
			{
				if (role.isLive)
				{
					o.engineCallList.push(getRoleLog(role));
				}
			}
			
			o.camp1RoleList = new Array();
			for each (role in u.engine.camp1.listRole) 
			{
				if (role.isLive)
				{
					o.camp1RoleList.push(getRoleLog(role));
				}
			}
			
			o.camp2RoleList = new Array();
			for each (role in u.engine.camp2.listRole) 
			{
				if (role.isLive)
				{
					o.camp2RoleList.push(getRoleLog(role));
				}
			}
			
			
			o.camp1List = new Array();
			var edBullet:EDBullet;
			for each (var ed:EDBase in u.engine.camp1.list) 
			{
				if (ed.isLive)
				{
					switch (ed.type) 
					{
						case EDType.bullet:
							edBullet = ed as EDBullet;
							o.camp1List.push(edBullet.x + ":" + edBullet.y + " Time:" + edBullet.creatTime);
							break;
					}
				}
			}
			
			o.camp2List = new Array();
			for each (ed in u.engine.camp2.list) 
			{
				if (ed.isLive)
				{
					switch (ed.type) 
					{
						case EDType.bullet:
							edBullet = ed as EDBullet;
							o.camp2List.push(edBullet.x + ":" + edBullet.y + " Time:" + edBullet.creatTime);
							break;
					}
				}
			}
			
			frameInfo.push(g.jsonGetStr(o));
			
			if (showErrorFrame && frameInfoBack && frameInfo.length <= frameInfoBack.length && frameInfoBack[frameInfo.length - 1] != frameInfo[frameInfo.length - 1])
			{
				u.engine.changePlayLive++;
				showErrorFrame = false;
				if ((frameInfo.length - 2) > -1)
				{
					g.log.pushLog(this, LogType._ErrorLog, "旧数据 时间:" + (u.engine.time.timeGame - u.engine.time.timeFrame));
					g.log.pushLog(this, LogType._ErrorLog, "旧数据 备份:" + frameInfoBack[frameInfo.length - 2]);
					g.log.pushLog(this, LogType._ErrorLog, "旧数据 运行:" + frameInfo[frameInfo.length - 2]);
				}
				g.log.pushLog(this, LogType._ErrorLog, "新数据 时间:" + u.engine.time.timeGame);
				var c1:String = frameInfoBack[frameInfo.length - 1];
				var c2:String = frameInfo[frameInfo.length - 1];
				g.log.pushLog(this, LogType._ErrorLog, "新数据 备份:" + c1);
				g.log.pushLog(this, LogType._ErrorLog, "新数据 运行:" + c2);
				
				var o1:Object = g.jsonGetObj(c1);
				var o2:Object = g.jsonGetObj(c2);
				
				// o.enginePlayList 全部的列表
				var length:int = o1.enginePlayList.length;
				if (length < o2.enginePlayList.length)
				{
					length = o2.enginePlayList.length;
				}
				for (var i:int = 0; i < length; i++) 
				{
					if (i < o1.enginePlayList.length && i < o2.enginePlayList.length)
					{
						if (o1.enginePlayList[i] != o2.enginePlayList[i])
						{
							g.log.pushLog(this, LogType._ErrorLog, "enginePlayList 位置:" + i);
							getRoleInfo(int(Number((o2.enginePlayList[i]).split(" ")[0])));
						}
					}
					else
					{
						g.log.pushLog(this, LogType._ErrorLog, "enginePlayList 位置:" + i);
					}
				}
				// o.camp1RoleList 角色1
				length = o1.camp1RoleList.length;
				if (length < o2.camp1RoleList.length)
				{
					length = o2.camp1RoleList.length;
				}
				for (i = 0; i < length; i++) 
				{
					if (i < o1.camp1RoleList.length && i < o2.camp1RoleList.length)
					{
						if (o1.camp1RoleList[i] != o2.camp1RoleList[i])
						{
							g.log.pushLog(this, LogType._ErrorLog, "camp1RoleList 位置:" + i);
							getRoleInfo(int(Number((o2.camp1RoleList[i]).split(" ")[0])));
						}
					}
					else
					{
						g.log.pushLog(this, LogType._ErrorLog, "camp1RoleList 位置:" + i);
					}
				}
				// o.camp2RoleList 角色2
				length = o1.camp2RoleList.length;
				if (length < o2.camp2RoleList.length)
				{
					length = o2.camp2RoleList.length;
				}
				for (i = 0; i < length; i++) 
				{
					if (i < o1.camp2RoleList.length && i < o2.camp2RoleList.length)
					{
						if (o1.camp2RoleList[i] != o2.camp2RoleList[i])
						{
							g.log.pushLog(this, LogType._ErrorLog, "camp2RoleList 位置:" + i);
							getRoleInfo(int(Number((o2.camp2RoleList[i]).split(" ")[0])));
						}
					}
					else
					{
						g.log.pushLog(this, LogType._ErrorLog, "camp2RoleList 位置:" + i);
					}
				}
				// o.camp1List 子弹1
				length = o1.camp1List.length;
				if (length < o2.camp1List.length)
				{
					length = o2.camp1List.length;
				}
				for (i = 0; i < length; i++) 
				{
					if (i < o1.camp1List.length && i < o2.camp1List.length)
					{
						if (o1.camp1List[i] != o2.camp1List[i])
						{
							g.log.pushLog(this, LogType._ErrorLog, "camp1List 位置:" + i);
						}
					}
					else
					{
						g.log.pushLog(this, LogType._ErrorLog, "camp1List 位置:" + i);
					}
				}
				// o.camp2List 子弹2
				length = o1.camp2List.length;
				if (length < o2.camp2List.length)
				{
					length = o2.camp2List.length;
				}
				for (i = 0; i < length; i++) 
				{
					if (i < o1.camp2List.length && i < o2.camp2List.length)
					{
						if (o1.camp2List[i] != o2.camp2List[i])
						{
							g.log.pushLog(this, LogType._ErrorLog, "camp2List 位置:" + i);
						}
					}
					else
					{
						g.log.pushLog(this, LogType._ErrorLog, "camp2List 位置:" + i);
					}
				}
			}
		}
		
		private function getRoleLog(role:EDRole):String
		{
			var s:String = role.info.serverId + " " + role.timeCreate;
			s += " " + role.x + ":" + role.y + ":" + role.angle;
			s += " H1:" + role.hitX1 + ":" + role.hitY1 + " H2:" + role.hitX2 + ":" + role.hitY2;
			s += " R:" + role.hit_r_x + " " + role.hit_r_y + " " + role.hit_r + " " + role.hit_h;
			s += " S:" + StatusTypeRole.getName(role.status);
			s += " M:need:" + role.ai.move.enginePhys.inNeed + " phys:" + role.ai.move.enginePhys.inPhys;
			s += " oX:" + role.ai.move.enginePhys.dragOldNeedX + " oY:" + role.ai.move.enginePhys.dragOldNeedY;
			s += " nX:" + role.ai.move.enginePhys.dragNeedX + " nY:" + role.ai.move.enginePhys.dragNeedY;
			s += " pX:" + role.ai.move.enginePhys.dragPhysX + " pY:" + role.ai.move.enginePhys.dragPhysY;
			s += " gX:" + role.ai.move.enginePhys.dragGoX + " gY:" + role.ai.move.enginePhys.dragGoY;
			s += " dA:" + role.ai.move.enginePhys.dragAngle + " dD:" + role.ai.move.enginePhys.dragOutDist;
			if (role.ai.skillFire)
			{
				s += " fire:" + role.ai.skillFire.index;
			}
			else
			{
				s += " fire:no";
			}
			var skillLength:int = role.ai.aiSkill.length;
			var skill:AIRoleSkill;
			for (var i:int = 0; i < skillLength; i++) 
			{
				skill = role.ai.aiSkill[i];
				if (skill)
				{
					if (skill.timeLength >= skill.cd)
					{
						s += " s" + i + ":isReady";
					}
					else
					{
						s += " s" + i + ":" + skill.timeLength;
					}
				}
				else
				{
					s += " s" + i + ":no";
				}
			}
			if (role.ai.hatred.maxED && role.ai.hatred.maxED.isLive)
			{
				s += " hetred:" + role.ai.hatred.maxED.info.serverId;
			}
			else
			{
				s += " hetred:0";
			}
			return s;
		}
		
		/**
		 * 获取服务器信息
		 * @param	serverId
		 */
		private function getRoleInfo(serverId:int):void
		{
			for each (var role:EDRole in u.engine.playerList) 
			{
				if (role.isLive && role.info.serverId == serverId)
				{
					
				}
			}
		}
		
		
		/**
		 * 清理全部的战斗
		 */
		public function gameReSet():void
		{
			if (start)
			{
				report.gameReSet();
				if (startCheck)
				{
					index = 0;
					crc = 0;
					info.length = 0;
					infoBack.length = 0;
					frameInfo.length = 0;
					frameInfoBack.length = 0;
				}
			}
		}
		
		/** 摧毁对象 **/
		public function dispose():void 
		{
			u = null;
		}
	}
}