package cn.wjj.upgame.info 
{
	import cn.wjj.gagaframe.client.speedfact.SByte;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 获取图形的数据
	 * @author GaGa
	 */
	public class InfoEngineByte 
	{
		
		public function InfoEngineByte() { }
		
		public static function openByte(byte:SByte):UpInfo
		{
			var o:UpInfo = new UpInfo(UpGame.VER);
			o.setByte(byte);
			return o;
		}
	}

}