package cn.wjj.upgame.engine 
{
	import cn.wjj.upgame.render.DisplayEDCardBase;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 获取静态的屁股
	 * @author GaGa
	 */
	public class EDRoleToolsSkinIdle 
	{
		
		/** 角度ID **/
		private static var angleId:int = 0;
		/** 技能ID **/
		private static var skillId:int = 0;
		/** 模型文件 **/
		private static var modelFile:String = "";
		
		public function EDRoleToolsSkinIdle() { }
		
		/**
		 * 根据ED里的角度,状态来设置模型的ID和镜像情况
		 * @param	u				UpGame
		 * @param	o				对象 [DisplayEDCard || DisplayEDLoading]
		 * @param	modelId			o.model.id
		 * @param	modelType		o.model.typeIdle
		 * @param	angle			角度
		 */
		public static function changeSkin(u:UpGame, o:Object, modelId:uint, modelType:int, angle:int):void
		{
			if(o is DisplayEDCardBase)
			{
				var mirror:Boolean = false;
				angleId = 0;
				if (u.modeTurn)
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
				switch (modelType) 
				{
					case 1:
						mirror = false;
						angleId = 1;
						break;
					case 8:
						if (angle >= 22.5 && angle < 67.5)
						{
							mirror = true;
							angleId = 4;
						}
						else if (angle >= 67.5 && angle < 112.5)
						{
							mirror = false;
							angleId = 5;
						}
						else if (angle >= 112.5 && angle < 157.5)
						{
							mirror = false;
							angleId = 4;
						}
						else if (angle >= 157.5 && angle < 202.5)
						{
							mirror = true;
							angleId = 3;
						}
						else if (angle >= 202.5 && angle < 247.5)
						{
							mirror = true;
							angleId = 2;
						}
						else if (angle >= 247.5 && angle < 292.5)
						{
							mirror = false;
							angleId = 1;
						}
						else if (angle >= 292.5 && angle < 337.5)
						{
							mirror = false;
							angleId = 2;
						}
						else
						{
							mirror = false;
							angleId = 3;
						}
						break;
					case 16:
						if (angle >= 11.25 && angle < 33.75)
						{
							mirror = false;
							angleId = 6;
						}
						else if (angle >= 33.75 && angle < 56.25)
						{
							mirror = false;
							angleId = 7;
						}
						else if (angle >= 56.25 && angle < 78.75)
						{
							mirror = false;
							angleId = 8;
						}
						else if (angle >= 78.75 && angle < 101.25)
						{
							mirror = false;
							angleId = 9;
						}
						else if (angle >= 101.25 && angle < 123.75)
						{
							mirror = true;
							angleId = 8;
						}
						else if (angle >= 123.75 && angle < 146.25)
						{
							mirror = true;
							angleId = 7;
						}
						else if (angle >= 146.25 && angle < 168.75)
						{
							mirror = true;
							angleId = 6;
						}
						else if (angle >= 168.75 && angle < 191.25)
						{
							mirror = true;
							angleId = 5;
						}
						else if (angle >= 191.25 && angle < 213.75)
						{
							mirror = true;
							angleId = 4;
						}
						else if (angle >= 213.75 && angle < 236.25)
						{
							mirror = true;
							angleId = 3;
						}
						else if (angle >= 236.25 && angle < 258.75)
						{
							mirror = true;
							angleId = 2;
						}
						else if (angle >= 258.75 && angle < 281.25)
						{
							mirror = false;
							angleId = 1;
						}
						else if (angle >= 281.25 && angle < 303.75)
						{
							mirror = false;
							angleId = 2;
						}
						else if (angle >= 303.75 && angle < 326.25)
						{
							mirror = false;
							angleId = 3;
						}
						else if (angle >= 326.25 && angle < 348.75)
						{
							mirror = false;
							angleId = 4;
						}
						else
						{
							mirror = false;
							angleId = 5;
						}
						break;
					case 108:
						if (angle >= 22.5 && angle < 67.5)
						{
							angleId = 4;
						}
						else if (angle >= 67.5 && angle < 112.5)
						{
							angleId = 5;
						}
						else if (angle >= 112.5 && angle < 157.5)
						{
							angleId = 6;
						}
						else if (angle >= 157.5 && angle < 202.5)
						{
							angleId = 7;
						}
						else if (angle >= 202.5 && angle < 247.5)
						{
							angleId = 8;
						}
						else if (angle >= 247.5 && angle < 292.5)
						{
							angleId = 1;
						}
						else if (angle >= 292.5 && angle < 337.5)
						{
							angleId = 2;
						}
						else
						{
							angleId = 3;
						}
						break;
					case 116:
						if (angle >= 11.25 && angle < 33.75)
						{
							mirror = true;
							angleId = 6;
						}
						else if (angle >= 33.75 && angle < 56.25)
						{
							mirror = true;
							angleId = 7;
						}
						else if (angle >= 56.25 && angle < 78.75)
						{
							mirror = true;
							angleId = 8;
						}
						else if (angle >= 78.75 && angle < 101.25)
						{
							mirror = false;
							angleId = 9;
						}
						else if (angle >= 101.25 && angle < 123.75)
						{
							mirror = false;
							angleId = 8;
						}
						else if (angle >= 123.75 && angle < 146.25)
						{
							mirror = false;
							angleId = 7;
						}
						else if (angle >= 146.25 && angle < 168.75)
						{
							mirror = false;
							angleId = 6;
						}
						else if (angle >= 168.75 && angle < 191.25)
						{
							mirror = true;
							angleId = 5;
						}
						else if (angle >= 191.25 && angle < 213.75)
						{
							mirror = true;
							angleId = 4;
						}
						else if (angle >= 213.75 && angle < 236.25)
						{
							mirror = true;
							angleId = 3;
						}
						else if (angle >= 236.25 && angle < 258.75)
						{
							mirror = true;
							angleId = 2;
						}
						else if (angle >= 258.75 && angle < 281.25)
						{
							mirror = false;
							angleId = 1;
						}
						else if (angle >= 281.25 && angle < 303.75)
						{
							mirror = false;
							angleId = 2;
						}
						else if (angle >= 303.75 && angle < 326.25)
						{
							mirror = false;
							angleId = 3;
						}
						else if (angle >= 326.25 && angle < 348.75)
						{
							mirror = false;
							angleId = 4;
						}
						else
						{
							mirror = false;
							angleId = 5;
						}
						break;
				}
				//4位模型ID, 2位动作类型, 2位方向
				if (angleId < 10)
				{
					modelFile = "0" + String(angleId);
				}
				else
				{
					modelFile = String(angleId);
				}
				o.mirror = mirror;
				o.displayId = uint(String(String(modelId) + "01" + modelFile));
			}
			else
			{
				throw new Error();
			}
		}
	}

}