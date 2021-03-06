package cn.wjj.upgame.engine 
{
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.gagaframe.client.speedfact.SpeedLib;
	import cn.wjj.upgame.common.StatusTypeBullet;
	/**
	 * 加速碰撞弹道
	 * 这个可以有方向
	 * 
	 * [加速][碰撞]
	 * @author GaGa
	 */
	public class AIBulletTrackAcceleratePtHit extends AIBulletTrack
	{
		/** 对象池 **/
		private static var __f:SpeedLib = new SpeedLib(100);
		/** 对象池强引用的最大数量 **/
		static public function get __m():uint {return __f.length;}
		/** 对象池强引用的最大数量 **/
		static public function set __m(value:uint):void {__f.length = value;}
		public function AIBulletTrackAcceleratePtHit() { }
		/** 初始化 **/
		public static function instance():AIBulletTrackAcceleratePtHit
		{
			var o:AIBulletTrackAcceleratePtHit = __f.instance() as AIBulletTrackAcceleratePtHit;
			if (o) return o;
			return new AIBulletTrackAcceleratePtHit();
		}
		
		/** 移除,清理,并回收 **/
		override public function dispose():void
		{
			super.dispose();
			if (this.ed != null) this.ed = null;
			__f.recover(this);
		}
		
		/** 开始的位移坐标 **/
		private var _x:Number = 0;
		private var _y:Number = 0;
		
		/** 开始位移时间,毫秒 **/
		private var startTime:uint = 0;
		/** 加速到最大速度所需时间,秒 **/
		private var maxTime:Number = 0;
		/** 加速到最大速度所需距离 **/
		private var maxLength:Number = 0;
		
		/** 现在的角度 **/
		private var _r:Number = 0;
		private var _a:Number = 0;
		
		override public function start(ed:EDBullet):void 
		{
			super.start(ed);
			ed.status = StatusTypeBullet.fly;
			//通过运行的时间,来算出距离,用距离和角度,算出每次叠加的x,y轴的距离,每次运行都加值
			if (ed.info.range)
			{
				//记录原始坐标
				_x = ed.x;
				_y = ed.y;
				startTime = ed.u.engine.time.timeGame;
				if(ed.info.info.acceleration != 0)
				{
					maxTime = (ed.info.info.speed - ed.info.info.startSpeed) / ed.info.info.acceleration;
					maxLength = (ed.info.info.startSpeed * maxTime) + (ed.info.info.acceleration * maxTime * maxTime / 2);
				}
				_r = ed.angle % 360;
				if (_r < 0) _r += 360;
				_a = ed.angle / 180 * Math.PI;
			}
			else
			{
				outRange = true;
				g.log.pushLog(this, LogType._ErrorLog, "弹道缺少目标点, 弹道类型 : " + ed.info.info.track);
			}
		}
		
		override public function move():void 
		{
			super.move();
			if (isHit == false && outRange == false)
			{
				var h:Number;
				//使用时间秒
				if(ed.info.info.acceleration != 0 )
				{
					var useTime:Number = (ed.u.engine.time.timeGame - startTime) / 1000;
					if (maxTime > useTime)//还没有到达最大速度
					{
						//现在移动的距离,像素
						h = (ed.info.info.startSpeed * useTime) + (ed.info.info.acceleration * useTime * useTime / 2);
					}
					else
					{
						h = (useTime - maxTime) * ed.info.info.speed + maxLength;
					}
				}
				else
				{
					h = ed.info.info.speed * (ed.u.engine.time.timeGame - startTime) / 1000;
				}
				if (ed.info.range < h)
				{
					outRange = true;
					h = ed.info.range;
				}
				switch (_r) 
				{
					case 0:
						ed.x = int(_x + h);
						break;
					case 90:
						ed.y = int(_y + h);
						break;
					case 180:
						ed.x = int(_x - h);
						break;
					case 270:
						ed.y = int(_y - h);
						break;
					default:
						ed.x = int(Math.cos(_a) * h + _x);
						ed.y = int(Math.sin(_a) * h + _y);
				}
			}
		}
	}
}