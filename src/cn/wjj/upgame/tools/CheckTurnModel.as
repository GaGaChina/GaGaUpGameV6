package cn.wjj.upgame.tools 
{
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.upgame.common.StatusTypeRole;
	import cn.wjj.upgame.data.RoleCardModel;
	import cn.wjj.upgame.data.UpGameData;
	import cn.wjj.upgame.data.UpGameModelInfo;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 检测模型是否一直,并且保证对称
	 * 
	 * @author GaGa
	 */
	public class CheckTurnModel 
	{
		private static var angle1:Object = new Object();
		private static var angle8:Object = new Object();
		private static var angle108:Object = new Object();
		private static var angle16:Object = new Object();
		private static var angle116:Object = new Object();
		
		public function CheckTurnModel() { }
		
		/** 检测模型是否一直,并且保证对称 **/
		public static function run():void
		{
			var config_ShowUseTime:Boolean = g.log.config_ShowUseTime;
			g.log.config_ShowUseTime = false;
			runAngle();
			var cardRoleList:Vector.<RoleCardModel> = UpGameData.cardRole.getAll();
			var modelList:Array = new Array();
			for each (var cardRole:RoleCardModel in cardRoleList) 
			{
				if (cardRole.CardType == 1 || cardRole.CardType == 3 || cardRole.CardType == 4 || cardRole.CardType == 5 || cardRole.CardType == 6)
				{
					modelList.length = 0;
					
					var model_1:UpGameModelInfo = UpGameData.modelInfo.getItem("id", cardRole.Cmodel);
					var model_2:UpGameModelInfo = UpGameData.modelInfo.getItem("id", cardRole.Cmodel2);
					if (model_1 && model_2)
					{
						//检测是否对称
						if (model_1.hit_h)//方形
						{
							if (model_1.hit_h % 2 != 0)
							{
								g.log.pushLog(CheckTurnModel, LogType._ErrorLog, "模型错误,高度非偶数, ID:" + model_1.id);
							}
							if (model_1.hit_r % 2 != 0)
							{
								g.log.pushLog(CheckTurnModel, LogType._ErrorLog, "模型错误,宽度非偶数, ID:" + model_1.id);
							}
							if ( (-model_1.hit_r / 2) != model_1.hit_r_x)
							{
								g.log.pushLog(CheckTurnModel, LogType._ErrorLog, "模型错误,横轴非对称, ID:" + model_1.id);
							}
							if ( (-model_1.hit_h / 2) != model_1.hit_r_y)
							{
								g.log.pushLog(CheckTurnModel, LogType._ErrorLog, "模型错误,高度非对称, ID:" + model_1.id);
							}
						}
						else//圆心
						{
							if (model_1.hit_r_x != 0 || model_1.hit_r_y != 0)
							{
								g.log.pushLog(CheckTurnModel, LogType._ErrorLog, "模型错误,圆非中心点, ID:" + model_1.id);
							}
						}
						//检测模型ID是否一致
						modelType(model_1, model_2, StatusTypeRole.appear);
						modelType(model_1, model_2, StatusTypeRole.idle);
						modelType(model_1, model_2, StatusTypeRole.move);
						modelType(model_1, model_2, StatusTypeRole.patrol);
						modelType(model_1, model_2, StatusTypeRole.attack);
						modelType(model_1, model_2, StatusTypeRole.die);
						modelType(model_1, model_2, StatusTypeRole.skill1);
						modelType(model_1, model_2, StatusTypeRole.skill2);
						modelType(model_1, model_2, StatusTypeRole.skill3);
						modelType(model_1, model_2, StatusTypeRole.skill4);
					}
					else
					{
						if (model_1 == null && model_2 == null)
						{
							g.log.pushLog(CheckTurnModel, LogType._ErrorLog, "模型表缺少, 角色ID:" + cardRole.card_id + " 模型 1 ID:" + cardRole.Cmodel + "和模型 2 ID:" + cardRole.Cmodel2);
						}
						else if (model_1 == null)
						{
							g.log.pushLog(CheckTurnModel, LogType._ErrorLog, "模型表缺少, 角色ID:" + cardRole.card_id + " 模型 1 ID:" + cardRole.Cmodel);
						}
						else if (model_2 == null)
						{
							g.log.pushLog(CheckTurnModel, LogType._ErrorLog, "模型表缺少, 角色ID:" + cardRole.card_id + " 模型 2 ID:" + cardRole.Cmodel2);
						}
					}
				}
			}
			g.log.config_ShowUseTime = config_ShowUseTime;
		}
		
		/**
		 * 检测模型型号
		 * @param	m1
		 * @param	m2
		 * @param	type
		 * @return
		 */
		private static function modelType(m1:UpGameModelInfo, m2:UpGameModelInfo, type:int):void
		{
			var m1Id:int, m2Id:int, name:String;
			var skillId:int = 0;
			switch (type) 
			{
				case StatusTypeRole.appear:
					m1Id = m1.typeAppear;
					m2Id = m2.typeAppear;
					name = "出场";
					break;
				case StatusTypeRole.idle:
					m1Id = m1.typeIdle;
					m2Id = m2.typeIdle;
					name = "待机";
					break;
				case StatusTypeRole.move:
				case StatusTypeRole.patrol:
					m1Id = m1.typeMove;
					m2Id = m2.typeMove;
					name = "移动";
					break;
				case StatusTypeRole.attack:
					m1Id = m1.typeSkill1;
					m2Id = m2.typeSkill1;
					name = "普攻";
					skillId = 1;
					break;
				case StatusTypeRole.die:
					m1Id = m1.typeDie;
					m2Id = m2.typeDie;
					name = "死亡";
					break;
				case StatusTypeRole.skill1:
					m1Id = m1.typeSkill2;
					m2Id = m2.typeSkill2;
					name = "技能1";
					skillId = 2;
					break;
				case StatusTypeRole.skill2:
					m1Id = m1.typeSkill3;
					m2Id = m2.typeSkill3;
					name = "技能2";
					skillId = 3;
					break;
				case StatusTypeRole.skill3:
					m1Id = m1.typeSkill4;
					m2Id = m2.typeSkill4;
					name = "技能3";
					skillId = 4;
					break;
				case StatusTypeRole.skill4:
					m1Id = m1.typeSkill5;
					m2Id = m2.typeSkill5;
					name = "技能4";
					skillId = 5;
					break;
			}
			if (m1Id != m2Id)
			{
				g.log.pushLog(CheckTurnModel, LogType._ErrorLog, "模型错误," + name + "类型错误, ID:" + m1.id + " ID:" + m2.id);
			}
			//开始校验发射点
			//循环里面全部的发射点,以翻转的对应点进行比较对应点
			switch (m1Id) 
			{
				case 1:
					runHitAll(m1, m2, skillId, angle1, 1);
					break;
				case 8:
					runHitAll(m1, m2, skillId, angle8, 8);
					break;
				case 16:
					runHitAll(m1, m2, skillId, angle16, 16);
					break;
				case 108:
					runHitAll(m1, m2, skillId, angle108, 108);
					break;
				case 116:
					runHitAll(m1, m2, skillId, angle116, 116);
					break;
			}
		}
		
		/** 检测角度增长的时候对称是否可以保持 **/
		private static function runAngle():void
		{
			angle1 = new Object();
			angle8 = new Object();
			angle108 = new Object();
			angle16 = new Object();
			angle116 = new Object();
			var id_1:String, id_2:String;
			var angle_1:int, angle_2:int;
			for (angle_1 = 0; angle_1 < 360; angle_1++) 
			{
				//1面的时候
				angle_2 = angle_1 + 180;
				angle_2 = angle_2 % 360;
				id_1 = getModel1AngleId(angle_1);
				id_2 = getModel1AngleId(angle_2);
				if (angle1.hasOwnProperty(id_1))
				{
					if (angle1[id_1] != id_2)
					{
						g.log.pushLog(CheckTurnModel, LogType._ErrorLog, "基础错误, 模型1,角度翻转非对称,角度:" + angle_1 + " ID1:" + id_1 + " ID2:" + id_2 + " 记录内:" + angle1[id_1]);
					}
				}
				else
				{
					angle1[id_1] = id_2;
				}
				//翻转8面
				angle_2 = angle_1 + 180;
				angle_2 = angle_2 % 360;
				id_1 = getModel8AngleId(angle_1);
				id_2 = getModel8AngleId(angle_2);
				if (angle8.hasOwnProperty(id_1))
				{
					if (angle8[id_1] != id_2)
					{
						g.log.pushLog(CheckTurnModel, LogType._ErrorLog, "基础错误, 模型8,角度翻转非对称,角度:" + angle_1 + " ID1:" + id_1 + " ID2:" + id_2 + " 记录内:" + angle8[id_1]);
					}
				}
				else
				{
					angle8[id_1] = id_2;
				}
				//真8面
				id_1 = getModel108AngleId(angle_1);
				id_2 = getModel108AngleId(angle_2);
				if (angle108.hasOwnProperty(id_1))
				{
					if (angle108[id_1] != id_2)
					{
						g.log.pushLog(CheckTurnModel, LogType._ErrorLog, "基础错误, 模型108,角度翻转非对称,角度:" + angle_1 + " ID1:" + id_1 + " ID2:" + id_2 + " 记录内:" + angle108[id_1]);
					}
				}
				else
				{
					angle108[id_1] = id_2;
				}
				
				id_1 = getModel16AngleId(angle_1);
				id_2 = getModel16AngleId(angle_2);
				if (angle16.hasOwnProperty(id_1))
				{
					if (angle16[id_1] != id_2)
					{
						g.log.pushLog(CheckTurnModel, LogType._ErrorLog, "基础错误, 模型16,角度翻转非对称,角度:" + angle_1 + " ID1:" + id_1 + " ID2:" + id_2 + " 记录内:" + angle16[id_1]);
					}
				}
				else
				{
					angle16[id_1] = id_2;
				}
				
				id_1 = getModel116AngleId(angle_1);
				id_2 = getModel116AngleId(angle_2);
				if (angle116.hasOwnProperty(id_1))
				{
					if (angle116[id_1] != id_2)
					{
						g.log.pushLog(CheckTurnModel, LogType._ErrorLog, "基础错误, 模型116,角度翻转非对称,角度:" + angle_1 + " ID1:" + id_1 + " ID2:" + id_2 + " 记录内:" + angle116[id_1]);
					}
				}
				else
				{
					angle116[id_1] = id_2;
				}
			}
		}
		
		private static function runHitAll(m1:UpGameModelInfo, m2:UpGameModelInfo, skillId:int, o:Object, type:int):void
		{
			if (skillId)
			{
				var angleId_1:String, angleId_2:String;
				var m1hitX1:int, m1hitY1:int, m1hitX2:int, m1hitY2:int;
				var m2hitX1:int, m2hitY1:int, m2hitX2:int, m2hitY2:int;
				var angleArray:Array;
				var id_1:String, id_2:String;
				var mirror_1:Boolean, mirror_2:Boolean;
				for (angleId_1 in o) 
				{
					if (false)
					{
						angleId_2 = o[angleId_1];
						angleArray = angleId_1.split("-")
						id_1 = angleArray[0];
						if (angleArray[1] == "true")
						{
							mirror_1 = true;
						}
						else
						{
							mirror_1 = false;
						}
						m1hitX1 = m1["p" + id_1 + "s" + skillId + "x1"];
						m1hitY1 = m1["p" + id_1 + "s" + skillId + "y1"];
						m1hitX2 = m1["p" + id_1 + "s" + skillId + "x2"];
						m1hitY2 = m1["p" + id_1 + "s" + skillId + "y2"];
						m2hitX1 = m2["p" + id_1 + "s" + skillId + "x1"];
						m2hitY1 = m2["p" + id_1 + "s" + skillId + "y1"];
						m2hitX2 = m2["p" + id_1 + "s" + skillId + "x2"];
						m2hitY2 = m2["p" + id_1 + "s" + skillId + "y2"];
						if (mirror_1)
						{
							m1hitX1 = -m1hitX1;
							m1hitX2 = -m1hitX2;
							m2hitX1 = -m2hitX1;
							m2hitX2 = -m2hitX2;
						}
						if (m1hitX1 != m2hitX1 || m1hitY1 != m2hitY1 || m1hitX2 != m2hitX2 || m1hitY2 != m2hitY2)
						{
							var logStr:String = "发射点错误,ID:" + m1.id + " ID:" + m2.id + " 技" + skillId;
							logStr += " 发1[ID" + id_1 + " " + m1hitX1 + "," + m1hitY1 + "," + m1hitX2 + "," + m1hitY2 + " 镜:" + mirror_1 + "]";
							logStr += " 发2[ID" + id_2 + " " + m2hitX1 + "," + m2hitY1 + "," + m2hitX2 + "," + m2hitY2 + " 镜:" + mirror_2 + "]";
							g.log.pushLog(CheckTurnModel, LogType._ErrorLog, logStr);
						}
					}
					else
					{
						angleId_2 = o[angleId_1];
						angleArray = angleId_1.split("-")
						id_1 = angleArray[0];
						if (angleArray[1] == "true")
						{
							mirror_1 = true;
						}
						else
						{
							mirror_1 = false;
						}
						m1hitX1 = m1["p" + id_1 + "s" + skillId + "x1"];
						m1hitY1 = m1["p" + id_1 + "s" + skillId + "y1"];
						m1hitX2 = m1["p" + id_1 + "s" + skillId + "x2"];
						m1hitY2 = m1["p" + id_1 + "s" + skillId + "y2"];
						if (mirror_1)
						{
							switch (type) 
							{
								case 8:
									if (id_1 == "3")
									{
										m1hitY1 = -m1hitY1;
										m1hitY2 = -m1hitY2;
									}
									break;
								case 16:
								case 116:
									if (id_1 == "5")
									{
										m1hitY1 = -m1hitY1;
										m1hitY2 = -m1hitY2;
									}
									break;
							}
						}
						if (mirror_1)
						{
							m1hitX1 = -m1hitX1;
							m1hitX2 = -m1hitX2;
						}
						
						
						angleArray = angleId_2.split("-")
						id_2 = angleArray[0];
						if (angleArray[1] == "true")
						{
							mirror_2 = true;
						}
						else
						{
							mirror_2 = false;
						}
						m2hitX1 = m2["p" + id_2 + "s" + skillId + "x1"];
						m2hitY1 = m2["p" + id_2 + "s" + skillId + "y1"];
						m2hitX2 = m2["p" + id_2 + "s" + skillId + "x2"];
						m2hitY2 = m2["p" + id_2 + "s" + skillId + "y2"];
						if (mirror_2)
						{
							switch (type) 
							{
								case 8:
									if (id_2 == "3")
									{
										m2hitY1 = -m2hitY1;
										m2hitY2 = -m2hitY2;
									}
									break;
								case 16:
								case 116:
									if (id_2 == "5")
									{
										m2hitY1 = -m2hitY1;
										m2hitY2 = -m2hitY2;
									}
									break;
							}
						}
						
						
						if (mirror_2)
						{
							m2hitX1 = -m2hitX1;
							m2hitX2 = -m2hitX2;
						}
						if (m1hitX1 != -m2hitX1 || m1hitY1 != -m2hitY1 || m1hitX2 != -m2hitX2 || m1hitY2 != -m2hitY2)
						{
							var logStr:String = "发射点错误,ID:" + m1.id + " ID:" + m2.id + " 技" + skillId;
							logStr += " 发1[ID" + id_1 + " " + m1hitX1 + "," + m1hitY1 + "," + m1hitX2 + "," + m1hitY2 + " 镜:" + mirror_1 + "]";
							logStr += " 发2[ID" + id_2 + " " + -m2hitX1 + "," + -m2hitY1 + "," + -m2hitX2 + "," + -m2hitY2 + " 镜:" + mirror_2 + "]";
							g.log.pushLog(CheckTurnModel, LogType._ErrorLog, logStr);
						}
					}
					
				}
			}
		}
		
		/** 获取8面的角度序号 **/
		private static function getModel1AngleId(angle:Number):String
		{
			return "1-false";
		}
		
		/** 获取8面的角度序号 **/
		private static function getModel8AngleId(angle:Number):String
		{
			if (angle >= 22.5 && angle < 67.5)
			{
				return "4-true";
			}
			else if (angle >= 67.5 && angle < 112.5)
			{
				return "5-false";
			}
			else if (angle >= 112.5 && angle < 157.5)
			{
				return "4-false";
			}
			else if (angle >= 157.5 && angle < 202.5)
			{
				return "3-true";
			}
			else if (angle >= 202.5 && angle < 247.5)
			{
				return "2-true";
			}
			else if (angle >= 247.5 && angle < 292.5)
			{
				return "1-false";
			}
			else if (angle >= 292.5 && angle < 337.5)
			{
				return "2-false";
			}
			else
			{
				return "3-false";
			}
			return "";
		}
		
		/** 获取真8面的角度序号 **/
		private static function getModel108AngleId(angle:Number):String
		{
			if (angle >= 22.5 && angle < 67.5)
			{
				return "4-false";
			}
			else if (angle >= 67.5 && angle < 112.5)
			{
				return "5-false";
			}
			else if (angle >= 112.5 && angle < 157.5)
			{
				return "6-false";
			}
			else if (angle >= 157.5 && angle < 202.5)
			{
				return "7-false";
			}
			else if (angle >= 202.5 && angle < 247.5)
			{
				return "8-false";
			}
			else if (angle >= 247.5 && angle < 292.5)
			{
				return "1-false";
			}
			else if (angle >= 292.5 && angle < 337.5)
			{
				return "2-false";
			}
			else
			{
				return "3-false";
			}
			return "";
		}
		
		/** 获取16面的角度序号 **/
		private static function getModel16AngleId(angle:Number):String
		{
			if (angle >= 11.25 && angle < 33.75)
			{
				return "6-false";
			}
			else if (angle >= 33.75 && angle < 56.25)
			{
				return "7-false";
			}
			else if (angle >= 56.25 && angle < 78.75)
			{
				return "8-false";
			}
			else if (angle >= 78.75 && angle < 101.25)
			{
				return "9-false";
			}
			else if (angle >= 101.25 && angle < 123.75)
			{
				return "8-true";
			}
			else if (angle >= 123.75 && angle < 146.25)
			{
				return "7-true";
			}
			else if (angle >= 146.25 && angle < 168.75)
			{
				return "6-true";
			}
			else if (angle >= 168.75 && angle < 191.25)
			{
				return "5-true";
			}
			else if (angle >= 191.25 && angle < 213.75)
			{
				return "4-true";
			}
			else if (angle >= 213.75 && angle < 236.25)
			{
				return "3-true";
			}
			else if (angle >= 236.25 && angle < 258.75)
			{
				return "2-true";
			}
			else if (angle >= 258.75 && angle < 281.25)
			{
				return "1-false";
			}
			else if (angle >= 281.25 && angle < 303.75)
			{
				return "2-false";
			}
			else if (angle >= 303.75 && angle < 326.25)
			{
				return "3-false";
			}
			else if (angle >= 326.25 && angle < 348.75)
			{
				return "4-false";
			}
			else
			{
				return "5-false";
			}
			return "";
		}
		
		/** 获取116面的角度序号 **/
		private static function getModel116AngleId(angle:Number):String
		{
			if (angle >= 11.25 && angle < 33.75)
			{
				return "6-true";
			}
			else if (angle >= 33.75 && angle < 56.25)
			{
				return "7-true";
			}
			else if (angle >= 56.25 && angle < 78.75)
			{
				return "8-true";
			}
			else if (angle >= 78.75 && angle < 101.25)
			{
				return "9-false";
			}
			else if (angle >= 101.25 && angle < 123.75)
			{
				return "8-false";
			}
			else if (angle >= 123.75 && angle < 146.25)
			{
				return "7-false";
			}
			else if (angle >= 146.25 && angle < 168.75)
			{
				return "6-false";
			}
			else if (angle >= 168.75 && angle < 191.25)
			{
				return "5-true";
			}
			else if (angle >= 191.25 && angle < 213.75)
			{
				return "4-true";
			}
			else if (angle >= 213.75 && angle < 236.25)
			{
				return "3-true";
			}
			else if (angle >= 236.25 && angle < 258.75)
			{
				return "2-true";
			}
			else if (angle >= 258.75 && angle < 281.25)
			{
				return "1-false";
			}
			else if (angle >= 281.25 && angle < 303.75)
			{
				return "2-false";
			}
			else if (angle >= 303.75 && angle < 326.25)
			{
				return "3-false";
			}
			else if (angle >= 326.25 && angle < 348.75)
			{
				return "4-false";
			}
			else
			{
				return "5-false";
			}
			return "";
		}
		
	}
}