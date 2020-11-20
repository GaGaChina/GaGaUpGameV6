package cn.wjj.upgame.engine 
{
	import cn.wjj.upgame.common.InfoHeroAddSkill;
	import cn.wjj.upgame.common.InfoHeroAddSkill;
	import flash.geom.Rectangle;
	/**
	 * 角色数据
	 * 
	 * @author GaGa
	 */
	public class ORole
	{
		/** 建筑的默认重量 **/
		public static var weightBuilding:int = 9999;
		
		/** 角色序号 **/
		public var order:int = 0;
		
		/** 人物所属的序号 **/
		public var idx:int = 0;
		/** 角色在策划文档里的ID **/
		public var id:uint = 0;
		/** ID的类型 1:在卡牌表ID, 2:在怪物表ID **/
		public var idType:uint = 1;
		/** 角色在服务器上的ID号 **/
		public var serverId:uint = 0;
		/** 是否是好友 **/
		public var isFriend:Boolean = false;
		/** 是否自动运行 **/
		public var isAuto:Boolean = true;
		/** 是否为召唤怪物 **/
		public var isCall:Boolean = false;
		/** 层级的类型:1 陆地, 2 空中, 3 建筑, 4 基地, 5 不能被攻击 **/
		public var typeProperty:int = 0;
		/** 是否激活后在播放出场动画,true:怪刷出后直接走入场景，false:怪被激活后再走入场景 **/
		public var actionStart:Boolean = false;
		/** 模型ID **/
		public var modelId:uint = 0;
		/** 等级 **/
		public var level:uint = 0;
		/** 是否是BOSS **/
		public var boss:Boolean = false;
		/** 是否是英雄 **/
		public var hero:Boolean = false;
		/**
		 * 血条显示类型
		 * -1-未设置
		 * 0-不显示
		 * 1-被攻击时显示
		 * 2-总是显示
		 * 3-固定显示在屏幕最顶端
		 * 4-(始终显示等级)受伤后永久显示血条, 一般角色
		 * 5-(显示等级)激活后永久显示血条,并有心心,总部老家,显示血量
		 * 6-(显示等级)总是显示血条,其他建筑
		 * 7-(不显示等级,但显示图标)总是显示,并显示血量,箭塔
		 */
		public var hpDisplayType:int = -1;
		/** 血条显示层数 **/
		public var hpDisplayNum:uint = 1;
		/** 角色所使用的AI类型, 1正常AI, 2固定AI, 3固定AI但是需要自己找,被挤等会重新找 **/
		public var aiType:int = 1;
		/** 前摇时间,如果发生移动就充值 **/
		public var attackPrepose:int = 500;
		/** 视野范围,像素, 激活后,会先处理仇恨列表 **/
		public var rangeView:int = 500;
		/** 视野范围,像素, 激活后,会先处理仇恨列表(平方) **/
		public var rangeView2:int = 250000;
		/** 警戒范围,像素, 互助的范围 **/
		public var rangeGuard:int = 100;
		/** 警戒范围,像素, 互助的范围(平方) **/
		public var rangeGuard2:int = 10000;
		/** 攻击力 **/
		private var _atk_a:int = 0;
		private var _atk_b:int = 0;
		private var _atk_c:int = 0;
		private var _atk_d:int = 0;
		/** 攻击频率(暂时没用) **/
		public var atkRate:int = 0;
		/** 攻击力增强,百分比 **/
		public var atkUp:int = 0;
		/** 防御力 **/
		public var def:int = 0;
		/** 防御力增强,百分比 **/
		public var defUp:int = 0;
		/** 生命值 **/
		private var _hp_a:int = 0;//合并值 a
		private var _hp_b:int = 0;//合并值 b
		private var _hp_c:int = 0;//校验减值 - hpMax
		private var _hp_d:int = 0;//校验加值 + hpMax
		/** 最大生命值 **/
		public var hpMax:int = 0;
		/** 生命值增强,百分比 **/
		public var hpUp:int = 0;
		/** 攻击间隔,普通攻击,攻击间隔,攻速,毫秒 **/
		public var atkTime:int = 0;
		/** 攻击间隔修正 **/
		public var atkTimeUp:int = 0;
		/** 移动速度 **/
		public var speed:int = 0;
		/** 移动速度和形象的比例 **/
		public var speedScale:Number = 1;
		/** 减速的最低速度 **/
		public var speedMin:int = 0;
		/** 基础的数据,操作的时候用 **/
		public var speedBase:int = 0;
		/** 工具速度,每次运行的最大距离 **/
		public var speedDist:Number;
		/** 命中值 **/
		public var hit:int = 0;
		/** 回避值 **/
		public var dodge:int = 0;
		/** 封命值 **/
		public var sealHit:int = 0;
		/** 封抗值 **/
		public var sealDodge:int = 0;
		/** 暴击率 **/
		public var crit:int = 0;
		/** 暴击伤害值 **/
		public var critHurt:int = 0;
		/** 暴击抵抗 **/
		public var critDef:int = 0;
		/** 韧性 **/
		public var tenacity:int = 0;
		/** [直接用攻击力]治疗 **/
		public var treat:int = 0;
		/** 治疗增强,是百分比 **/
		public var treatUp:int = 0;
		/** 被治疗效果,是百分比 **/
		public var treatEffect:int = 0;
		/** 再生值 **/
		public var regeneration:int = 0;
		/** 141技能的召唤参数 **/
		public var callMonster1:int = 0;
		/** 142怪物的召唤ID2 **/
		public var callMonster2:int = 0;
		/** 143怪物的召唤ID3 **/
		public var callMonster3:int = 0;
		/** 怪物出来的初始角度,-1是通过程序设置 **/
		public var startAngle:int = -1;
		/** 最大的召唤怪物数量 **/
		public var maxCall:int = 0;
		/** 技能里CD有关的各项值 **/
		public var skillInfo:Vector.<ORoleSkill> = new Vector.<ORoleSkill>();
		/** 是否开启自动巡逻 **/
		public var autoPatrol:Boolean = false;
		/** 死亡的时候释放的技能 **/
		public var dieSkill:int = 0;
		/** (毫秒)启动时间,就是可以攻击别人的时间 **/
		public var timeInit:int = 0;
		/** 体重 **/
		public var weight:int = 0;
		/** 尺寸,占位 **/
		public var size:int = 0;
		/** 尺寸区域 **/
		public var sizeRect:Rectangle;
		/** 是否可以跳跃 **/
		public var canJump:Boolean = false;
		
		/** 英雄的数据 **/
		public var heroInfo:InfoHeroAddSkill;
		/** 死亡产生的经验值 **/
		public var expDie:int = 0;
		/** 技能的基础速度 **/
		public var skillSpeed:int = 10000;
		/** 技能CD的增长速度 **/
		public var skillScale:Number = 1;
		
		/** 防止修改生命值 **/
		private var c1:int;
		private var c2:int;
		private var c3:int;
		private var cr:int;
		
		public function ORole():void
		{
			var skill:ORoleSkill = new ORoleSkill();
			skill.index = 0;
			skillInfo.push(skill);
			skill = new ORoleSkill();
			skill.index = 1;
			skillInfo.push(skill);
			skill = new ORoleSkill();
			skill.index = 2;
			skillInfo.push(skill);
			skill = new ORoleSkill();
			skill.index = 3;
			skillInfo.push(skill);
			skill = new ORoleSkill();
			skill.index = 4;
			skillInfo.push(skill);
			cr = int(Math.random() * 10000);
		}
		/** 生命值 **/
		public function get hp():int 
		{
			c1 = _hp_a + _hp_b;
			c2 = _hp_c + cr;
			c3 = _hp_d - cr;
			if (c1 == c2 && c2 == c3)
			{
				return c1;
			}
			else if (c1 == c2)
			{
				return c1;
			}
			else if (c2 == c3)
			{
				return c2;
			}
			return 0;
		}
		/** 生命值 **/
		public function set hp(value:int):void 
		{
			_hp_a = -int(value / 3);
			_hp_b = value - _hp_a;
			_hp_c = value - cr;
			_hp_d = value + cr;
		}
		/** 攻击力 **/
		public function get atk():int 
		{
			c1 = _atk_a + _atk_b;
			c2 = _atk_c + cr;
			c3 = _atk_d - cr;
			if (c1 == c2 && c2 == c3)
			{
				return c1;
			}
			else if (c1 == c2)
			{
				return c1;
			}
			else if (c2 == c3)
			{
				return c2;
			}
			return 0;
		}
		/** 攻击力 **/
		public function set atk(value:int):void
		{
			_atk_a = -int(value / 3);
			_atk_b = value - _atk_a;
			_atk_c = value - cr;
			_atk_d = value + cr;
		}
		
		/** 克隆一套数据出来 **/
		public function clone():ORole
		{
			var o:ORole = new ORole();
			o.order = order;
			o.idx = idx;
			o.id = id;
			o.idType = idType;
			o.serverId = serverId;
			o.isFriend = isFriend;
			o.isAuto = isAuto;
			o.isCall = isCall;
			o.typeProperty = typeProperty;
			o.actionStart = actionStart;
			o.modelId = modelId;
			o.level = level;
			o.boss = boss;
			o.hero = hero;
			o.hpDisplayType = hpDisplayType;
			o.hpDisplayNum = hpDisplayNum;
			o.aiType = aiType;
			o.attackPrepose = attackPrepose;
			o.rangeView = rangeView;
			o.rangeView2 = rangeView2;
			o.rangeGuard = rangeGuard;
			o.rangeGuard2 = rangeGuard2;
			o.atkRate = atkRate;
			o.atkUp = atkUp;
			o.def = def;
			o.defUp = defUp;
			o.hpMax = hpMax;
			o.hpUp = hpUp;
			o.atkTime = atkTime;
			o.atkTimeUp = atkTimeUp;
			o.speed = speed;
			o.speedScale = speedScale;
			o.speedMin = speedMin;
			o.speedBase = speedBase;
			o.speedDist = speedDist;
			o.hit = hit;
			o.dodge = dodge;
			o.sealHit = sealHit;
			o.sealDodge = sealDodge;
			o.crit = crit;
			o.critHurt = critHurt;
			o.critDef = critDef;
			o.tenacity = tenacity;
			o.treat = treat;
			o.treatUp = treatUp;
			o.treatEffect = treatEffect;
			o.regeneration = regeneration;
			o.callMonster1 = callMonster1;
			o.callMonster2 = callMonster2;
			o.callMonster3 = callMonster3;
			o.startAngle = startAngle;
			o.maxCall = maxCall;
			//Vector.<ORoleSkill> = new Vector.<ORoleSkill>();
			var skill:ORoleSkill;
			for (var i:int = 0; i < 5; i++) 
			{
				o.skillInfo[i].id = skillInfo[i].id;
				o.skillInfo[i].index = skillInfo[i].index;
				o.skillInfo[i].lv = skillInfo[i].lv;
				o.skillInfo[i].cd = skillInfo[i].cd;
				o.skillInfo[i].cdStart = skillInfo[i].cdStart;
			}
			o.autoPatrol = autoPatrol;
			o.dieSkill = dieSkill;
			o.timeInit = timeInit;
			o.weight = weight;
			o.size = size;
			o.sizeRect = sizeRect;//Rectangle
			if (sizeRect)
			{
				o.sizeRect = new Rectangle();
				o.sizeRect.x = sizeRect.x;
				o.sizeRect.y = sizeRect.y;
				o.sizeRect.width = sizeRect.width;
				o.sizeRect.height = sizeRect.height;
			}
			o.canJump = canJump;
			o.heroInfo = heroInfo;//InfoHeroAddSkill
			if (heroInfo)
			{
				o.heroInfo = new InfoHeroAddSkill();
				o.heroInfo.card1 = heroInfo.card1;
				o.heroInfo.card2 = heroInfo.card2;
				o.heroInfo.card3 = heroInfo.card3;
				o.heroInfo.card4 = heroInfo.card4;
				o.heroInfo.cardSkill1 = heroInfo.cardSkill1;
				o.heroInfo.cardSkill2 = heroInfo.cardSkill2;
				o.heroInfo.cardSkill3 = heroInfo.cardSkill3;
				o.heroInfo.cardSkill4 = heroInfo.cardSkill4;
				o.heroInfo.selfHealing = heroInfo.selfHealing;
				o.heroInfo.expVal = heroInfo.expVal;
				o.heroInfo.expNext = heroInfo.expNext;
				o.heroInfo.expStar = heroInfo.expStar;
				o.heroInfo.expAddUp = heroInfo.expAddUp;
				o.heroInfo.timeRevive = heroInfo.timeRevive;
			}
			o.expDie = expDie;
			o.skillSpeed = skillSpeed;
			o.skillScale = skillScale;
			return o;
		}
	}
}