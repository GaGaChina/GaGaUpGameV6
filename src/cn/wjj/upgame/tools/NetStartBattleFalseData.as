package cn.wjj.upgame.tools 
{
	import cn.wjj.upgame.data.MonsterAttributeModel;
	import cn.wjj.upgame.data.MonsterAttributeModel_ArrayLib;
	
	/**
	 * 获取一份假数据
	 * 
	 * @author GaGa
	 */
	public class NetStartBattleFalseData 
	{
		
		public function NetStartBattleFalseData() { }
		
		/**
		 * 创建一个模拟数据
		 * @param	maxCount	怪物波次总数
		 * @param	battleID	战场ID
		 * @return
		
		public static function getData(monster:MonsterAttributeModel_ArrayLib, maxRound:uint, battleID:uint):SC_PACK_PLAYER_START_BATTLE_RS
		{
			var o:SC_PACK_PLAYER_START_BATTLE_RS = new SC_PACK_PLAYER_START_BATTLE_RS();
			var info:Stru_INST_DATA = new Stru_INST_DATA();
			o.moInstData.push(info);
			info.miBattleID = battleID;
			info.miGroupCount = maxRound;
			//副本相关数据
			var monsterNum:int;
			//缓存某一个怪物的数据  monsterLib[10] = MonsterAttributeModel
			var monsterLib:Object = new Object();
			var pos:Array = [5, 6, 7, 8, 100, 101];
			for (var i:int = 0; i < maxRound; i++) 
			{
				//添加怪物
				monsterNum = int(Math.random() * 4) + 2;
				while (--monsterNum > -1)
				{
					pushMonster(info, monster, monsterLib, i, pos[int(pos.length * Math.random())]);
				}
				//添加好友NPC
				monsterNum = int(Math.random() * 1);
				while (--monsterNum > -1)
				{
					pushFriendNpc(info, monster, monsterLib, i, pos[int(pos.length * Math.random())]);
				}
			}
			////
			//助战好友, 先放弃这个, 现在没有这个东西
			//o.miAssitId = 88888888;
			//o.moAssistCaptainData.moCardDisplayInfo.miCardTypeID = 123;
			//o.moAssistCaptainData.moCardDisplayInfo.miCardID = 99999999;
			//o.moAssistCaptainData.moCardDisplayInfo.miNormalAdvSkillLv = 1;
			//o.moAssistCaptainData.moCardDisplayInfo.miAdvSkillLv = 1;
			//o.moAssistCaptainData.moCardDisplayInfo.miAdvSkill2Lv = 1;
			//setAssistProperty(o.moAssistCaptainData);
			return o;
		}
		 */
		
		/** 添加好友NPC
		private static function pushFriendNpc(moInstData:Stru_INST_DATA, monster:MonsterAttributeModel_ArrayLib, monsterLib:Object, round:uint, pos:uint):void
		{
			var monsterInstData:Stru_MONSTER_INST_DATA = new Stru_MONSTER_INST_DATA();
			var info:MonsterAttributeModel = getMonsterType(monster, moInstData, monsterLib);
			monsterInstData.miIdx = round;
			monsterInstData.miMonsterID = int(Math.random() * 100000);
			monsterInstData.miMonsterTypeID = info.Id;
			monsterInstData.miPos = pos;//地图上的位置
			monsterInstData.miCurHP = info.Hp;
			moInstData.moFriendNpc.push(monsterInstData);
			moInstData.miFriendNpcCount = moInstData.moMonstList.length;
		}
		 **/
		/**
		 * 为副本数据添加怪物
		 * @param	moInstData	操作数据引用
		 * @param	type		添加的怪物类型,这个可以自动生成的
		 * @param	round
		 * @param	pos
		
		private static function pushMonster(moInstData:Stru_INST_DATA, monster:MonsterAttributeModel_ArrayLib, monsterLib:Object, round:uint, pos:uint):void
		{
			var monsterInstData:Stru_MONSTER_INST_DATA = new Stru_MONSTER_INST_DATA();
			var info:MonsterAttributeModel = getMonsterType(monster, moInstData, monsterLib);
			monsterInstData.miIdx = round;
			monsterInstData.miMonsterID = int(Math.random() * 100000);
			monsterInstData.miMonsterTypeID = info.Id;
			monsterInstData.miPos = pos;//地图上的位置
			monsterInstData.miCurHP = info.Hp;
			moInstData.moMonstList.push(monsterInstData);
			moInstData.miMonsterCount = moInstData.moMonstList.length;
		}
		 */
		/**
		 * 从怪物表里随机出表, 没有的添加到添加怪物属性
		 * 
		 * @param	moInstData
		 * @param	monsterLib
		 * @return
		
		private static function getMonsterType(monster:MonsterAttributeModel_ArrayLib, moInstData:Stru_INST_DATA, monsterLib:Object):MonsterAttributeModel
		{
			var a:Array = monster.getArray();
			var o:Object = monster.getArray()[int(a.length * Math.random())];
			var info:MonsterAttributeModel = new MonsterAttributeModel(o);
			if (!monsterLib.hasOwnProperty(info.Id))
			{
				monsterLib[info.Id] = info;
				var monsterData:Stru_MONSTER_DATA = new Stru_MONSTER_DATA();
				monsterData.miPropsTypeID = info.Id;
				setCombatProperty(monsterData, info);
				moInstData.miMonsterTypeList.push(monsterData);
				moInstData.miMonsterTypeCount = moInstData.miMonsterTypeList.length;
			}
			return info;
		}
		 */
		/**
		 * 添加默认的属性
		
		private static function setCombatProperty(monsterData:Stru_MONSTER_DATA, info:MonsterAttributeModel):void
		{
			monsterData.moCombatProperty.length = 0;
			setProperty(monsterData.moCombatProperty, info);
			monsterData.miCombatPropertyCount = monsterData.moCombatProperty.length;
		}
		 */
		/**
		 * 添加默认的属性
		
		private static function setAssistProperty(cardDetailInfo:Stru_CARD_DETAIL_INFO, info:MonsterAttributeModel):void
		{
			cardDetailInfo.moCombatInfo.length = 0;
			setProperty(cardDetailInfo.moCombatInfo, info);
			cardDetailInfo.miCombatInfoCount = cardDetailInfo.moCombatInfo.length;
		}
		 */
		private static function setProperty(v:Vector.<int>, info:MonsterAttributeModel):void
		{
			v.push(info.Att);		// 攻击
			v.push(0);				// 攻击频率
			v.push(info.def);		// 防御
			v.push(info.Hp);		// 生命
			v.push(info.attsp);		// 攻击间隔
			v.push(info.Sp);		// 移动速度
			v.push(info.Hit);		// 命中
			v.push(info.Dod);		// 闪避
			v.push(info.seal);		// 封印命中 -- 封命
			v.push(info.sealres);	// 封印闪避 -- 封抗
			v.push(info.lethality);	// 致命率
			v.push(info.tenacity);	// 韧性
			v.push(info.Finjury);	// 致命伤害
			v.push(info.finjuryres);// 致命伤害抵抗 - 暴击抵抗
			v.push(info.attX);		// 攻击增强
			v.push(info.hpX);		// 生命增强
			v.push(info.attspX);	// 攻速修正
			v.push(info.cureX);		// 治疗增强
			v.push(info.defx);		// 防御比例
			v.push(info.betreated);	// 被治疗比例
			v.push(info.Regenerationvalue);		// 再生值
			v.push(info.initialcdreduce1);		// 技能1初始cd降低值
			v.push(info.initialcdreduce2);		// 技能2初始cd降低值
			v.push(info.initialcdreduce3);		// 技能3初始cd降低值
			v.push(info.initialcdreduce4);		// 技能4初始cd降低值
			v.push(info.cdreduce1);		// 技能1cd降低值
			v.push(info.cdreduce2);		// 技能2cd降低值
			v.push(info.cdreduce3);		// 技能3cd降低值
			v.push(info.cdreduce4);		// 技能4cd降低值
			v.push(info.Card);		// 形象
			v.push(info.Boss);		// 是否为BOSS
			v.push(info.look);		// 视野范围
			v.push(info.sensitive);	// 敏感范围
			v.push(info.Pskillid);	// 普通技能
			v.push(info.Gskillid);	// 技能1
			v.push(info.Gskillid2);	// 技能2
			v.push(info.Gskillid3);	// 技能3
			v.push(info.Gskillid4);	// 技能4
			v.push(info.hpdisplaytype);	// 血条显示类型
			v.push(info.hpdisplaynum);	// 血条显示层数
			v.push(info.monsterid1);	// 召唤技能召唤的角色1,ID
			v.push(info.monsterid2);	// 召唤技能召唤的角色2,ID
			v.push(info.actionStart);	// 是否直接走入场景 : 0怪刷出后直接走入场景，1怪被激活后再走入场景
			v.push(info.ai);			// AI类型
			v.push(info.first);			// 怪物出来的初始角度
		}
	}
}