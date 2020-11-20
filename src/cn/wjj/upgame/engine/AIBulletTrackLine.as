package cn.wjj.upgame.engine
{
	import cn.wjj.gagaframe.client.speedfact.SpeedLib;
	import cn.wjj.upgame.common.StatusTypeBullet;
	
	/**
	 * 8 [匀速][碰撞]光线弹道
	 * 
	 * @author GaGa
	 */
	public class AIBulletTrackLine extends AIBulletTrack
	{
		
		/** 对象池 **/
		private static var __f:SpeedLib = new SpeedLib(100);
		/** 对象池强引用的最大数量 **/
		static public function get __m():uint {return __f.length;}
		/** 对象池强引用的最大数量 **/
		static public function set __m(value:uint):void {__f.length = value;}
		public function AIBulletTrackLine() { }
		/** 初始化 **/
		public static function instance():AIBulletTrackLine
		{
			var o:AIBulletTrackLine = __f.instance() as AIBulletTrackLine;
			if (o) return o;
			return new AIBulletTrackLine();
		}
		
		/** 移除,清理,并回收 **/
		override public function dispose():void
		{
			super.dispose();
			if (this.ed != null) this.ed = null;
			if (this._x != 0) this._x = 0;
			if (this._y != 0) this._y = 0;
			if (this._t != 0) this._t = 0;
			if (this._r != 0) this._r = 0;
			if (this._a != 0) this._a = 0;
			__f.recover(this);
		}
		
		/** 起始位置 **/
		private var _x:Number = 0;
		private var _y:Number = 0;
		/** 起始时间 **/
		private var _t:uint = 0;
		/** 飞行角度 **/
		private var _r:Number = 0;
		private var _a:Number = 0;
		
		override public function start(ed:EDBullet):void 
		{
			super.start(ed);
			ed.status = StatusTypeBullet.fly;
			//通过运行的时间,来算出距离,用距离和角度,算出每次叠加的x,y轴的距离,每次运行都加值
			_x = ed.x;
			_y = ed.y;
			_t = ed.u.engine.time.timeGame;
			_r = ed.angle % 360;
			if (_r < 0) _r += 360;
			_a = ed.angle / 180 * Math.PI;
		}
		
		override public function move():void 
		{
			super.move();
			var h:Number = ed.info.info.speed * (ed.u.engine.time.timeGame - _t) / 1000;
			if (ed.info.range == 0 || ed.info.range < h)
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