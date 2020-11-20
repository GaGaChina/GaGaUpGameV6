package cn.wjj.upgame.tools 
{
	
	/**
	 * 错误信息
	 * 
	 * @author GaGa
	 */
	public class ErrorMassage
	{
		
		public function ErrorMassage() { }
		
		/** 获取对应的错误码 **/
		public static function getString(errorId:int):String
		{
			//10000		系统的错误
			//20000		信息错误
			switch (errorId) 
			{
				case 20001:
					return "二进制文件版本不相符";
			}
			return "未知错误:" + errorId;
		}
	}
}