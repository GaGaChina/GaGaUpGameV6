package cn.wjj.upgame.engine
{
	import cn.wjj.display.draw.BezierPoint;
	import cn.wjj.display.MPoint;
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.gagaframe.client.speedfact.SpeedLib;
	import cn.wjj.upgame.common.StatusTypeBullet;

	/**
	 * 抛物线弹道,中间不碰,到达目的地命中
	 * 
	 * 【放大到最大的距离】= 【总距离】*2/3 - 总距离X(sinA)/3
	 * 【偏移的高度】 = 【加速度】* 绝对值（cosA）
	 * 
	 * 抛物线的弹道在空中飞行的时间是恒定的 【飞行的时间】= 【最大射程】/【飞行速度】
	 * 注：抛物线弹道不支持加速度，【加速度】的字段用于计算偏移高度的计算时使用
	 * 
	 * 抛物线的弹道分为四段进行处理（前两段飞行时间 分别为 = 【飞行时间】/3，后面两段飞行时间为 = 【飞行时间】/6）
	 * 首先根据上述公式获得 【偏移高度】和【放大到最大的总距离】
	 * 
	 * 第一段 2/3时间
	 * 移动的距离长度 = 放大到最大的总距离
	 * 子弹素材放大的比例 = 原始尺寸X 2       放大比例 (现在比例  - 2) / 时间 = 现在比例
	 * 子弹偏移的高度 = 【偏移高度】 * 2
	 * 
	 * 第二段 1/3时间
	 * 移动的距离长度 = 【射程距离】-【放大到最大的总距离】
	 * 子弹素材放大的比例 = 原始尺寸 1
	 * 子弹偏移的高度 = 0
	 * 
	 * @author GaGa
	 */
	public class AIBulletTrackParabolaNo extends AIBulletTrack
	{
		/** 对象池 **/
		private static var __f:SpeedLib = new SpeedLib(100);
		/** 对象池强引用的最大数量 **/
		static public function get __m():uint {return __f.length;}
		/** 对象池强引用的最大数量 **/
		static public function set __m(value:uint):void {__f.length = value;}
		public function AIBulletTrackParabolaNo() { }
		/** 初始化 **/
		public static function instance():AIBulletTrackParabolaNo
		{
			var o:AIBulletTrackParabolaNo = __f.instance() as AIBulletTrackParabolaNo;
			if (o) return o;
			return new AIBulletTrackParabolaNo();
		}
		
		/** 移除,清理,并回收 **/
		override public function dispose():void
		{
			super.dispose();
			if (this.ed != null) this.ed = null;
			if (this.point1)
			{
				this.point1.dispose();
				this.point1 = null;
			}
			if (this.point2)
			{
				this.point2.dispose();
				this.point2 = null;
			}
			if (this.point3)
			{
				this.point3.dispose();
				this.point3 = null;
			}
			if (this.pointMove)
			{
				this.pointMove.dispose();
				this.pointMove = null;
			}
			__f.recover(this);
		}
		
		/** 起始位置 **/
		private var _x:Number = 0;
		private var _y:Number = 0;
		/** 起始时间 **/
		private var _t:uint = 0;
		
		/** 距离目标的距离 **/
		private var _l:Number = 0;
		/** 飞行总时间 **/
		internal var maxTime:Number;
		/** 一半时间 **/
		private var halfTime:Number;
		/** 第一段长度 **/
		private var count1:Number;
		/** 第二段长度 **/
		private var count2:Number;
		
		/** 4个要走的点 **/
		private var point1:MPoint;
		private var point2:MPoint;
		private var point3:MPoint;
		/** 现在的移动点 **/
		private var pointMove:MPoint;
		
		override public function start(ed:EDBullet):void
		{
			super.start(ed);
			ed.status = StatusTypeBullet.fly;
			//通过运行的时间,来算出距离,用距离和角度,算出每次叠加的x,y轴的距离,每次运行都加值
			if (ed.point)
			{
				var x:Number = ed.x - ed.point.x;
				var y:Number = ed.y - ed.point.y;
				_l = Math.sqrt(x * x + y * y);
				if (_l == 0)
				{
					isHit = true;
				}
				else
				{
					_x = ed.x;
					_y = ed.y;
					_t = ed.u.engine.time.timeGame;
					var _a:Number = ed.angle / 180 * Math.PI;
					//最大总距离
					count1 = _l * (2 / 3 - (Math.sin(_a) / 3));
					count2 = _l - count1;
					//偏移高度
					var maxHeigth:Number = -Math.cos(_a);
					maxHeigth = ed.info.info.acceleration * maxHeigth * _l / 1000;
					//飞行总时间
					maxTime = _l / ed.info.info.speed * 1000;
					halfTime = maxTime / 2;
					point1 = MPoint.instance(_x, _y);
					//----------------------------第一点----------------------------
					var a1:Number = Math.atan2(maxHeigth, count1);
					var c1:Number = count1 / Math.cos(a1);
					a1 = a1 + _a;
					point2 = MPoint.instance();
					point2.x = Math.cos(a1) * c1 + _x;
					point2.y = Math.sin(a1) * c1 + _y;
					point3 = MPoint.instance(ed.point.x, ed.point.y);
					pointMove = MPoint.instance();
				}
			}
			else
			{
				isHit = true;
				g.log.pushLog(this, LogType._ErrorLog, "弹道缺少目标点, 弹道类型 : " + ed.info.info.track);
			}
		}
		
		override public function move():void 
		{
			super.move();
			if (isHit == false)
			{
				var useTime:Number = ed.u.engine.time.timeGame - _t;
				if (useTime >= maxTime)
				{
					isHit = true;
					ed.x = ed.point.x;
					ed.y = ed.point.y;
					ed.scaleX = 1;
					ed.scaleY = 1;
				}
				else if(ed.u.readerStart)
				{
					var t:Number;
					//第一段
					if (useTime < halfTime)
					{
						ed.scaleX = (useTime / halfTime) * 2 + 1;
						ed.scaleY = ed.scaleX;
					}
					else//第二段
					{
						ed.scaleX = 3 - ((useTime - halfTime) / halfTime * 2);
						ed.scaleY = ed.scaleX;
					}
					t = useTime / maxTime;
					if (t > 1) t = 1;
					BezierPoint.Bezier2(point1, point2, point3, t, pointMove);
					ed.x = int(pointMove.x);
					ed.y = int(pointMove.y);
				}
			}
		}
	}
}