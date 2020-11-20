package cn.wjj.upgame.tools {
	/**
	 * 创建随机因子
	 * 
	 * import cn.wjj.upgame.tools.MathRandomCreateSeed;
	 * trace(MathRandomCreateSeed.make(10, 500, 0, 100, 1, true));
	 * 
	 * @author GaGa
	 */
	public class MathRandomCreateSeed 
	{
		
		public function MathRandomCreateSeed() { }
		
		/**
		 * 生成一个随机数组
		 * 
		 * @param	g			共多少组随机数
		 * @param	doNumber	打乱次数
		 * @param	min			最小的起始数
		 * @param	max			最大的起始数
		 * @param	addInt		每次叠加的大小
		 * @param	isSmall		是否是小数
		 */
		public static function make(g:int = 10, doNumber:int = 500, min:int = 0, max:int = 100, addInt:int = 1, isSmall:Boolean = true):String
		{
			var s:String = "var seed:Array = \n";
			var tempArray:Array = new Array();
			for (var j:int = min; j <= max; j += addInt) 
			{
				if (isSmall && j != 0)
				{
					if (j == 0)
					{
						tempArray.push(j);
					}
					else if (max == j && (max == 100 || max == 10 || max == 1000 || max == 10000 || max == 100000))
					{
						tempArray.push(1);
					}
					else
					{
						if (j < 10)
						{
							tempArray.push(Number(String("0.0" + j)));
						}
						else
						{
							tempArray.push(Number(String("0." + j)));
						}
					}
				}
				else
				{
					tempArray.push(j);
				}
			}
			
			s += "	[\n";
			for (var i:int = 0; i < g; i++) 
			{
				if (i != 0)
				{
					s += ",\n";
					s += "		\n";
				}
				s += "		// " +  i + "\n";
				s += "		[\n";
				j = min;
				fuckArray(tempArray);
				s += getArrayString(tempArray, max, isSmall) + "\n";
				s += "		]";
			}
			
			s += "\n	];\n";
			return s;
		}
		
		/** 对数组进行打乱 **/
		private static function fuckArray(tempArray:Array, doNumber:int = 500):void
		{
			var length:int = tempArray.length;
			if (length)
			{
				var random:Number;
				var temp:*;
				while (--doNumber > -1) 
				{
					random = Math.random();
					temp = tempArray.splice(int(random * length), 1);
					if (random < 0.5)
					{
						tempArray.push(temp);
					}
					else
					{
						tempArray.unshift(temp);
					}
				}
			}
		}
		
		/** 把数组组合起来 **/
		private static function getArrayString(tempArray:Array, max:int, isSmall:Boolean):String
		{
			var length:int = tempArray.length;
			var maxLength:int = String(max).length;
			if (isSmall)
			{
				maxLength += 2;
			}
			var s:String = "";
			var temp:String;
			for (var i:int = 0; i < length; i++) 
			{
				if (i != 0 && i % 10 == 0)
				{
					s += "\n			";
				}
				else if (i == 0)
				{
					s += "			";
				}
				temp = String(tempArray[i]);
				temp = getStringMax(temp, maxLength);
				if (i + 1 != length)
				{
					s += temp + ",";
				}
				else
				{
					s += temp;
				}
			}
			return s;
		}
		
		private static function getStringMax(temp:String, length:int):String
		{
			while (temp.length < length)
			{
				temp = temp + " ";
			}
			return temp;
		}
	}

}