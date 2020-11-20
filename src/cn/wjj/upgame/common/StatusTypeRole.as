package cn.wjj.upgame.common 
{
	/**
	 * 人物状态
	 * 
	 * @author GaGa
	 */
	public class StatusTypeRole 
	{
		/** 还没创建 **/
		public static const no:uint = 0;
		
		/** 出场 **/
		public static const appear:uint = 1;
		
		/** 待机 **/
		public static const idle:uint = 2;
		
		/** 行走 **/
		public static const move:uint = 3;
		
		/** 飞行 **/
		public static const fly:uint = 4;
		
		/** 闪避 **/
		public static const dudge:uint = 6;
		
		/** 跳 **/
		public static const jump:uint = 7;
		
		/** 击飞 **/
		public static const hit:uint = 8;
		
		/** 死亡 **/
		public static const die:uint = 9;
		
		/** 击退 **/
		public static const collision:uint = 10;
		
		/** 巡逻 **/
		public static const patrol:uint = 11;
		
		/** 普通攻击 **/
		public static const attack:uint = 1000;
		
		/** 技能1 **/
		public static const skill1:uint = 1001;
		
		/** 技能2 **/
		public static const skill2:uint = 1002;
		
		/** 技能3 **/
		public static const skill3:uint = 1003;
		
		/** 技能4 **/
		public static const skill4:uint = 1004;
		
		public function StatusTypeRole() { }
		
		/**
		 * 通过ID编码获取到状态名称
		 * @param	id
		 * @return
		 */
		public static function getName(id:int):String
		{
			switch (id) 
			{
				case StatusTypeRole.no:
					return "no";
				case StatusTypeRole.appear:
					return "出场";
				case StatusTypeRole.idle:
					return "待机";
				case StatusTypeRole.move:
					return "移动";
				case StatusTypeRole.fly:
					return "fly";
				case StatusTypeRole.dudge:
					return "闪避";
				case StatusTypeRole.jump:
					return "跳跃";
				case StatusTypeRole.hit:
					return "击飞";
				case StatusTypeRole.die:
					return "死亡";
				case StatusTypeRole.collision:
					return "击退";
				case StatusTypeRole.patrol:
					return "巡逻";
				case StatusTypeRole.attack:
					return "技1";
				case StatusTypeRole.skill1:
					return "技2";
				case StatusTypeRole.skill2:
					return "技3";
				case StatusTypeRole.skill3:
					return "技4";
				case StatusTypeRole.skill4:
					return "技5";
			}
			return "未知状态";
		}
		
	}
}