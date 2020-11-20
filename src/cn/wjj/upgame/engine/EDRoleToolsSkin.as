package cn.wjj.upgame.engine 
{
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.upgame.common.StatusTypeRole;

	/**
	 * 设置U2模型的资源连接
	 * 
	 * 16方向时：1上，2右上1，3右上2，4右上3，5右，6右下1,7右下2,8右下3，9下；
	 * 8方向时：1上， 2右上，3右，4右下，5下；
	 * 
	 * @author GaGa
	 */
	public class EDRoleToolsSkin 
	{
		/** 模型的ID **/
		private static var modelId:String = "";
		/** 角度ID **/
		private static var angleId:int = 0;
		/** 技能ID **/
		private static var skillId:int = 0;
		/** 模型类型 **/
		private static var modelType:int = 0;
		/** 模型文件 **/
		private static var modelFile:String = "";
		
		public function EDRoleToolsSkin() { }
		
		/**
		 * 根据ED里的角度,状态来设置模型的ID和镜像情况
		 * @param	o
		 * @return		是否有改变
		 */
		public static function changeSkin(o:EDRole, modeTurn:Boolean):void
		{
			if(o.model)
			{
				switch (o.status) 
				{
					case StatusTypeRole.appear:
						modelId = "09";
						if (skillId != 0) skillId = 0;
						modelType = o.model.typeAppear;
						break;
					case StatusTypeRole.idle:
						modelId = "01";
						if (skillId != 0) skillId = 0;
						modelType = o.model.typeIdle;
						break;
					case StatusTypeRole.move:
					case StatusTypeRole.patrol:
						modelId = "02";
						if (skillId != 0) skillId = 0;
						modelType = o.model.typeMove;
						break;
					case StatusTypeRole.attack:
						modelId = "03";
						if (skillId != 1) skillId = 1;
						modelType = o.model.typeSkill1;
						break;
					case StatusTypeRole.die:
						modelId = "04";
						if (skillId != 0) skillId = 0;
						modelType = o.model.typeDie;
						break;
					case StatusTypeRole.skill1:
						modelId = "05";
						if (skillId != 2) skillId = 2;
						modelType = o.model.typeSkill2;
						break;
					case StatusTypeRole.skill2:
						modelId = "06";
						if (skillId != 3) skillId = 3;
						modelType = o.model.typeSkill3;
						break;
					case StatusTypeRole.skill3:
						modelId = "07";
						if (skillId != 4) skillId = 4;
						modelType = o.model.typeSkill4;
						break;
					case StatusTypeRole.skill4:
						modelId = "08";
						if (skillId != 5) skillId = 5;
						modelType = o.model.typeSkill5;
						break;
				}
				//var runY:Boolean = false;
				switch (modelType) 
				{
					case 1:
						angleId = getModel1AngleId(o);
						break;
					case 8:
						angleId = getModel8AngleId(o, modeTurn);
						//if (o.displayMirror && angleId == 3) runY = true;
						break;
					case 16:
						angleId = getModel16AngleId(o, modeTurn);
						//if (o.displayMirror && angleId == 5) runY = true;
						break;
					case 108:
						angleId = getModel108AngleId(o, modeTurn);
						break;
					case 116:
						angleId = getModel116AngleId(o, modeTurn);
						//if (o.displayMirror && angleId == 5) runY = true;
						break;
				}
				/*
				if (skillId)
				{
					if (modeTurn)
					{
						o.hitX1 = -o.model["p" + angleId + "s" + skillId + "x1"];
						o.hitY1 = -o.model["p" + angleId + "s" + skillId + "y1"];
						o.hitX2 = -o.model["p" + angleId + "s" + skillId + "x2"];
						o.hitY2 = -o.model["p" + angleId + "s" + skillId + "y2"];
					}
					else
					{
						o.hitX1 = o.model["p" + angleId + "s" + skillId + "x1"];
						o.hitY1 = o.model["p" + angleId + "s" + skillId + "y1"];
						o.hitX2 = o.model["p" + angleId + "s" + skillId + "x2"];
						o.hitY2 = o.model["p" + angleId + "s" + skillId + "y2"];
					}
					if (runY)
					{
						o.hitY1 = -o.hitY1;
						o.hitY2 = -o.hitY2;
					}
					if (o.displayMirror)
					{
						o.hitX1 = -o.hitX1;
						o.hitX2 = -o.hitX2;
					}
					
					//测试通过
					var tempX:int = 5;
					var tempY:int = 10;
					if (o.angle >= 0 && o.angle < 90)
					{
						o.hitX1 = tempX;
						o.hitY1 = -tempY;
						o.hitX2 = tempX;
						o.hitY2 = -tempY;
					}
					else if (o.angle >= 90 && o.angle < 180)
					{
						o.hitX1 = -tempX;
						o.hitY1 = -tempY;
						o.hitX2 = -tempX;
						o.hitY2 = -tempY;
					}
					else if (o.angle >= 180 && o.angle < 270)
					{
						o.hitX1 = -tempX;
						o.hitY1 = tempY;
						o.hitX2 = -tempX;
						o.hitY2 = tempY;
					}
					else
					{
						o.hitX1 = tempX;
						o.hitY1 = tempY;
						o.hitX2 = tempX;
						o.hitY2 = tempY;
					}
				}
				else
				{
					if (o.hitX1 != 0) o.hitX1 = 0;
					if (o.hitY1 != 0) o.hitY1 = 0;
					if (o.hitX2 != 0) o.hitX2 = 0;
					if (o.hitY2 != 0) o.hitY2 = 0;
				}
				*/
				//4位模型ID, 2位动作类型, 2位方向
				if (angleId < 10)
				{
					modelFile = "0" + angleId;
				}
				else
				{
					modelFile = String(angleId);
				}
				o.displayId = uint(o.model.id + modelId + modelFile);
			}
			else
			{
				g.log.pushLog(EDRoleToolsSkin, LogType._ErrorLog, "[策划]模型表缺少模型数据 : " + o.info.modelId);
			}
		}
		
		/** 获取8面的角度序号 **/
		private static function getModel1AngleId(o:EDRole):int
		{
			o.displayMirror = false;
			return 1;
		}
		
		/** 获取8面的角度序号 **/
		private static function getModel8AngleId(o:EDRole, modeTurn:Boolean):int
		{
			var id:int = 0;
			var angle:int = o.angle;
			if (modeTurn)
			{
				if (angle < 180)
				{
					angle += 180;
				}
				else
				{
					angle -= 180;
				}
			}
			if (angle >= 22.5 && angle < 67.5)
			{
				o.displayMirror = true;
				id = 4;
			}
			else if (angle >= 67.5 && angle < 112.5)
			{
				o.displayMirror = false;
				id = 5;
			}
			else if (angle >= 112.5 && angle < 157.5)
			{
				o.displayMirror = false;
				id = 4;
			}
			else if (angle >= 157.5 && angle < 202.5)
			{
				o.displayMirror = true;
				id = 3;
			}
			else if (angle >= 202.5 && angle < 247.5)
			{
				o.displayMirror = true;
				id = 2;
			}
			else if (angle >= 247.5 && angle < 292.5)
			{
				o.displayMirror = false;
				id = 1;
			}
			else if (angle >= 292.5 && angle < 337.5)
			{
				o.displayMirror = false;
				id = 2;
			}
			else
			{
				o.displayMirror = false;
				id = 3;
			}
			return id;
		}
		
		/** 获取真8面的角度序号 **/
		private static function getModel108AngleId(o:EDRole, modeTurn:Boolean):int
		{
			var id:int = 0;
			var angle:int = o.angle;
			if (modeTurn)
			{
				if (angle < 180)
				{
					angle += 180;
				}
				else
				{
					angle -= 180;
				}
			}
			if(o.displayMirror) o.displayMirror = false;
			if (angle >= 22.5 && angle < 67.5)
			{
				id = 4;
			}
			else if (angle >= 67.5 && angle < 112.5)
			{
				id = 5;
			}
			else if (angle >= 112.5 && angle < 157.5)
			{
				id = 6;
			}
			else if (angle >= 157.5 && angle < 202.5)
			{
				id = 7;
			}
			else if (angle >= 202.5 && angle < 247.5)
			{
				id = 8;
			}
			else if (angle >= 247.5 && angle < 292.5)
			{
				id = 1;
			}
			else if (angle >= 292.5 && angle < 337.5)
			{
				id = 2;
			}
			else
			{
				id = 3;
			}
			return id;
		}
		
		/** 获取16面的角度序号 **/
		private static function getModel16AngleId(o:EDRole, modeTurn:Boolean):int
		{
			var id:int = 0;
			var angle:int = o.angle;
			if (modeTurn)
			{
				if (angle < 180)
				{
					angle += 180;
				}
				else
				{
					angle -= 180;
				}
			}
			if (angle >= 11.25 && angle < 33.75)
			{
				o.displayMirror = false;
				id = 6;
			}
			else if (angle >= 33.75 && angle < 56.25)
			{
				o.displayMirror = false;
				id = 7;
			}
			else if (angle >= 56.25 && angle < 78.75)
			{
				o.displayMirror = false;
				id = 8;
			}
			else if (angle >= 78.75 && angle < 101.25)
			{
				o.displayMirror = false;
				id = 9;
			}
			else if (angle >= 101.25 && angle < 123.75)
			{
				o.displayMirror = true;
				id = 8;
			}
			else if (angle >= 123.75 && angle < 146.25)
			{
				o.displayMirror = true;
				id = 7;
			}
			else if (angle >= 146.25 && angle < 168.75)
			{
				o.displayMirror = true;
				id = 6;
			}
			else if (angle >= 168.75 && angle < 191.25)
			{
				o.displayMirror = true;
				id = 5;
			}
			else if (angle >= 191.25 && angle < 213.75)
			{
				o.displayMirror = true;
				id = 4;
			}
			else if (angle >= 213.75 && angle < 236.25)
			{
				o.displayMirror = true;
				id = 3;
			}
			else if (angle >= 236.25 && angle < 258.75)
			{
				o.displayMirror = true;
				id = 2;
			}
			else if (angle >= 258.75 && angle < 281.25)
			{
				o.displayMirror = false;
				id = 1;
			}
			else if (angle >= 281.25 && angle < 303.75)
			{
				o.displayMirror = false;
				id = 2;
			}
			else if (angle >= 303.75 && angle < 326.25)
			{
				o.displayMirror = false;
				id = 3;
			}
			else if (angle >= 326.25 && angle < 348.75)
			{
				o.displayMirror = false;
				id = 4;
			}
			else
			{
				o.displayMirror = false;
				id = 5;
			}
			return id;
		}
		
		/** 获取116面的角度序号 **/
		private static function getModel116AngleId(o:EDRole, modeTurn:Boolean):int
		{
			var id:int = 0;
			var angle:int = o.angle;
			if (modeTurn)
			{
				if (angle < 180)
				{
					angle += 180;
				}
				else
				{
					angle -= 180;
				}
			}
			if (angle >= 11.25 && angle < 33.75)
			{
				o.displayMirror = true;
				id = 6;
			}
			else if (angle >= 33.75 && angle < 56.25)
			{
				o.displayMirror = true;
				id = 7;
			}
			else if (angle >= 56.25 && angle < 78.75)
			{
				o.displayMirror = true;
				id = 8;
			}
			else if (angle >= 78.75 && angle < 101.25)
			{
				o.displayMirror = false;
				id = 9;
			}
			else if (angle >= 101.25 && angle < 123.75)
			{
				o.displayMirror = false;
				id = 8;
			}
			else if (angle >= 123.75 && angle < 146.25)
			{
				o.displayMirror = false;
				id = 7;
			}
			else if (angle >= 146.25 && angle < 168.75)
			{
				o.displayMirror = false;
				id = 6;
			}
			else if (angle >= 168.75 && angle < 191.25)
			{
				o.displayMirror = true;
				id = 5;
			}
			else if (angle >= 191.25 && angle < 213.75)
			{
				o.displayMirror = true;
				id = 4;
			}
			else if (angle >= 213.75 && angle < 236.25)
			{
				o.displayMirror = true;
				id = 3;
			}
			else if (angle >= 236.25 && angle < 258.75)
			{
				o.displayMirror = true;
				id = 2;
			}
			else if (angle >= 258.75 && angle < 281.25)
			{
				o.displayMirror = false;
				id = 1;
			}
			else if (angle >= 281.25 && angle < 303.75)
			{
				o.displayMirror = false;
				id = 2;
			}
			else if (angle >= 303.75 && angle < 326.25)
			{
				o.displayMirror = false;
				id = 3;
			}
			else if (angle >= 326.25 && angle < 348.75)
			{
				o.displayMirror = false;
				id = 4;
			}
			else
			{
				o.displayMirror = false;
				id = 5;
			}
			return id;
		}
	}
}