package cn.wjj.upgame.engine 
{
	import cn.wjj.display.MPoint;
	import cn.wjj.g;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 子弹生成器
	 * 
	 * @author GaGa
	 */
	public class CBullet 
	{
		/** 子弹计算的发射角度 **/
		private static var startAngle:Number;
		
		public function CBullet() { }
		
		/**
		 * 创建一个子弹
		 * @param	upGame		游戏的场景
		 * @param	role		子弹的发射者
		 * @param	camp		阵营
		 * @param	info		子弹的信息
		 * @param	x			子弹初始坐标
		 * @param	y			子弹初始坐标
		 * @param	target		子弹对准某个目标
		 * @param	point		子弹目标点
		 */
		public static function create(u:UpGame, role:EDRole, camp:int, info:OBullet, x:int, y:int, target:EDRole = null, point:MPoint = null):void
		{
			if (role)
			{
				startAngle = role.angle;
			}
			var px:int, py:int;
			//弧度
			var a1:Number;
			//找到这个技能的目标进行攻击
			if (target)
			{
				if (role != target)
				{
					px = target.x + target.hit_r_x;
					py = target.y + target.hit_r_y;
					if (target.hit_h)
					{
						px = target.hit_r / 2 + px;
						py = target.hit_h / 2 + py;
					}
					if (point == null) point = MPoint.instance(px, py);
					px = x - px;
					py = y - py;
					if (px != 0 || py != 0)
					{
						startAngle = (Math.atan2(py, px) + Math.PI) * 180 / Math.PI;
						startAngle = startAngle % 360;
						if (startAngle < 0) startAngle += 360;
					}
				}
			}
			else if (point)
			{
				px = x - point.x;
				py = y - point.y;
				if (px != 0 || py != 0)
				{
					startAngle = (Math.atan2(py, px) + Math.PI) * 180 / Math.PI;
					startAngle = startAngle % 360;
					if (startAngle < 0) startAngle += 360;
				}
			}
			else
			{
				//按角度发出子弹,找当方向,找到到达点
				startAngle = startAngle % 360;
				if (startAngle < 0) startAngle += 360;
				if (point == null)
				{
					point = MPoint.instance();
					a1 = startAngle / 180 * Math.PI;
					point.x = Math.cos(a1) * info.range + x;
					point.y = Math.sin(a1) * info.range + y;
				}
			}
			if (info.info.type == 1)
			{
				createOne(u, role, camp, info, x, y, startAngle, point);
			}
			else
			{
				var count:uint = info.info.count;
				var b:int;
				var tempAngle:Number;
				var dist:Number;
				var tempPoint:MPoint;
				if (point)
				{
					var distX:Number = point.x - x;
					var distY:Number = point.y - y;
					dist = Math.sqrt(distX * distX + distY * distY);
				}
				for (var i:int = 0; i < count; i++)
				{
					if (i == 0)
					{
						b = 0;
					}
					else
					{
						//单数负数,双数正
						b = int((i + 1) / 2);
						if (i % 2 == 1)
						{
							b = -b;
						}
					}
					tempAngle = -b * info.info.angle + startAngle - info.info.angle1;
					if (point)
					{
						if (tempAngle == startAngle)
						{
							createOne(u, role, camp, info, x, y, tempAngle, point);
						}
						else
						{
							//计算新的Point 16关,第二阶段,BOSS
							tempPoint = MPoint.instance();
							a1 = tempAngle / 180 * Math.PI;
							tempPoint.x = int(Math.cos(a1) * dist + x);
							tempPoint.y = int(Math.sin(a1) * dist + y);
							createOne(u, role, camp, info, x, y, tempAngle, tempPoint);
						}
					}
					else
					{
						createOne(u, role, camp, info, x, y, tempAngle, null);
					}
				}
			}
		}
		
		/** 创建单颗的子弹 **/
		private static function createOne(u:UpGame, role:EDRole, camp:int, info:OBullet, x:int, y:int, angle:Number, point:MPoint):void
		{
			var ed:EDBullet = new EDBullet(u);
			var ai:AIBullet = AIBullet.instance();
			if (u.readerStart)
			{
				if (ai.readerList == null)
				{
					ai.readerList = g.speedFact.n_vector(uint);
					if (ai.readerList == null)
					{
						ai.readerList = new Vector.<uint>();
					}
				}
			}
			else if (ai.readerList)
			{
				g.speedFact.d_vector(uint, ai.readerList);
				ai.readerList = null;
			}
			ai.ed = ed;
			/** 攻击的点 **/
			ed.x = x;
			ed.y = y;
			ed.info = info;
			ed.ai = ai;
			ed.angle = angle;
			ed.point = point;
			ed.camp = camp;
			ed.owner = role;
			ed.section = u.engine.section;
			u.engine.addED(ed);
		}
	}
}