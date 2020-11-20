package cn.wjj.upgame 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import cn.wjj.upgame.data.CardInfoModel_ArrayLib;
	import cn.wjj.upgame.data.HeroGeneralSkillModel_ArrayLib;
	import cn.wjj.upgame.data.HeroStarUpModel_ArrayLib;
	import cn.wjj.upgame.data.MonsterAttributeModel_ArrayLib;
	import cn.wjj.upgame.data.RoleCardModel_ArrayLib;
	import cn.wjj.upgame.data.SkillActiveModel_ArrayLib;
	import cn.wjj.upgame.data.UpGameBulletInfo_ArrayLib;
	import cn.wjj.upgame.data.UpGameData;
	import cn.wjj.upgame.data.UpGameModelInfo_ArrayLib;
	import cn.wjj.upgame.data.UpGameSkillAction_ArrayLib;
	import cn.wjj.upgame.data.UpGameSkillEffect_ArrayLib;
	import cn.wjj.upgame.data.UpGameSkill_ArrayLib;
	import cn.wjj.upgame.data.UpGameWarMap_ArrayLib;
	import cn.wjj.upgame.engine.EDCampPlayer;
	import cn.wjj.upgame.engine.UpEngine;
	import cn.wjj.upgame.info.UpInfo;
	import cn.wjj.upgame.net.UpNet;
	import cn.wjj.upgame.record.UpRecord;
	import cn.wjj.upgame.render.UpReader;
	import cn.wjj.upgame.report.UpReport;
	import cn.wjj.upgame.task.UpTask;
	import cn.wjj.upgame.tools.MathRandom;
	
	/**
	 * 向上游戏框架的主入口
	 * 
	 * 分成逻辑层和显示层
	 * 逻辑层发生重要情况会告诉显示层
	 * 显示层来控制那些显示上的和逻辑层无关的内容
	 * 
	 * 游戏的二种驱动类型
	 * 
	 * 驱动发动机,然后驱动显示层
	 * 驱动显示层,发动机搁置
	 * 
	 * 先不使用接口,使用单独内容直接干掉
	 * 
	 * @author GaGa
	 */
	public class UpGame implements IEventDispatcher
	{
		/** 版本号 **/
		public static const VER:uint = 6;
		
		/** 是否属于活动模式 **/
		public var isLive:Boolean = true;
		/** 是否处于编辑模式 **/
		public var isEdit:Boolean = false;
		/** 游戏的信息 **/
		public var info:UpInfo;
		/** 驱动模块 **/
		public var engine:UpEngine;
		/** 显示驱动 **/
		public var reader:UpReader;
		/** 是否启动UI控制,不启动UI,整体不会播放 **/
		public var readerStart:Boolean = true;
		/** 操作记录对象 **/
		public var record:UpRecord;
		/** 操作记录对象是否开启 **/
		public var recordStart:Boolean = true;
		/** 是否开启战报 **/
		public var report:UpReport;
		/** 是否开启战报 **/
		public var reportStart:Boolean = true;
		/** 任务控制系统 **/
		public var task:UpTask;
		/** 是否开启任务控制系统 **/
		public var taskStart:Boolean = false;
		/** 网络传输层 **/
		public var net:UpNet;
		
		/** 是否是调试模式,这个模式就显示出人物视野等信息 **/
		public var isDebug:Boolean = false;
		/** 本控制玩家的ID **/
		public var playerId:int = 0;
		/** 本控制玩家的对象 **/
		public var playerED:EDCampPlayer;
		
		/** 战斗开始的随机数的组 **/
		public var randomGroup:int = 0;
		/** 战斗开始的随机数的开始位置 **/
		public var randomSite:int = 0;
		/** 是否是录像模式 **/
		public var modeRecord:Boolean = false;
		/** 游戏需要重头运行到 timeEngineTo = int((new Date().time - timeStartBase) / timeFrame) * timeFrame; **/
		public var modeReDo:Boolean = false;
		/** 是否正在重头运行 **/
		public var modeReIn:Boolean = false;
		/** 是否开启翻转模式(镜像播放模式) **/
		public var modeTurn:Boolean = false;
		/** 是否开启对攻模式(上下对打的模式) **/
		public var modeAttack:Boolean = false;
		/** 人物互相推让的功能,固定位置的推体重大的,体重大的优先推让体重小的 **/
		public var modeMovePhys:Boolean = false;
		
		private var dispatcher:EventDispatcher;
		
		/**
		 * 初始化UpGame
		 * @param	readerStart		是否开启显示对象
		 * @param	recordStart		是否开启操作录像
		 * @param	reportStart		是否开启战报记录
		 * @param	taskStart		是否开启任务控制系统
		 * @param	modeAttack		是否开启对攻模式
		 */
		public function UpGame(info:UpInfo, readerStart:Boolean = true, recordStart:Boolean = true, reportStart:Boolean = true, taskStart:Boolean = false, modeAttack:Boolean = false) 
		{
			if (UpGameData.init == false)
			{
				throw new Error("数据未初始化,无法初始化UpGame");
			}
			randomGroup = int(Math.random() * 20);
			randomSite = int(Math.random() * 100);
			randomSet(randomGroup, randomSite);
			dispatcher = new EventDispatcher();
			if(info)
			{
				this.info = info;
			}
			else
			{
				this.info = new UpInfo(VER);
			}
			this.modeAttack = modeAttack;
			engine = new UpEngine(this);
			this.readerStart = readerStart;
			if (readerStart)
			{
				reader = new UpReader(this);
			}
			this.recordStart = recordStart;
			if (recordStart)
			{
				record = new UpRecord(this);
			}
			this.reportStart = reportStart;
			if (reportStart)
			{
				report = new UpReport(this);
			}
			this.taskStart = taskStart;
			if (taskStart)
			{
				task = new UpTask(this);
			}
			net = new UpNet(this);
		}
		
		/** 使用的随机因子的组 **/
		public var random_g:int = 0;
		/** 使用的随机因子位置 **/
		public var random_s:int = 0;
		/** 使用的随机因子长度 **/
		private var random_l:int = 0;
		
		/** 将随机因子重置, **/
		public function randomSet(g:int = 0, s:int = 0):void
		{
			this.random_g = g;
			this.random_s = s;
			this.random_l = MathRandom.seed[g].length - 1;
		}
		
		/** 按顺序获取预定的随机因子 **/
		public function get random():Number
		{
			this.random_s++;
			if (this.random_s > this.random_l) this.random_s = 0;
			return MathRandom.seed[this.random_g][this.random_s];
		}
		
		/** 计算一个随机范围的值, 和随机数计算后是像下取整 **/
		public function randomInt(min:int, max:int):int
		{
			return int((max - min) * random) + min;
		}
		
		/** 移除,清理,并回收 **/
		public function dispose():void
		{
			if (isLive)
			{
				isLive = false;
				info = null;
				if (engine)
				{
					engine.dispose();
					engine = null;
				}
				if(reader)
				{
					reader.dispose();
					reader = null;
					this.readerStart = false;
				}
				if (record)
				{
					record.dispose();
					record = null;
					this.recordStart = false;
				}
				if (report)
				{
					report.dispose();
					report = null;
					this.reportStart = false;
				}
				if (task)
				{
					task.dispose();
					task = null;
					this.taskStart = false;
				}
				if (net)
				{
					net.dispose();
					net = null;
				}
			}
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(evt:Event):Boolean
		{
			return dispatcher.dispatchEvent(evt);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return dispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return dispatcher.willTrigger(type);
		}
	}
}