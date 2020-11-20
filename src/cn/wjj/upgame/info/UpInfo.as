package cn.wjj.upgame.info 
{
	import cn.wjj.g;
	import cn.wjj.gagaframe.client.log.LogType;
	import cn.wjj.gagaframe.client.speedfact.SByte;
	import cn.wjj.upgame.common.IUpInfo;
	import cn.wjj.upgame.common.UpInfoType;
	import cn.wjj.upgame.UpGame;
	
	/**
	 * 全部的数据部分
	 * 
	 * @author GaGa
	 */
	public class UpInfo extends UpInfoBase
	{
		/** 信息的版本号 **/
		public var ver:uint;
		/** 信息ID **/
		public var id:uint = 0;
		/** 信息名称 **/
		public var name:String = "";
		/** [编辑有用]编辑的时候的GFile名称 **/
		public var gfileName:String = "";
		/** [编辑有用]保存的路径 **/
		public var path:String = "";
		/** 场景信息 **/
		public var stageInfo:UpInfoStageInfo;
		/** 场景里的全部数据 **/
		public var map:UpInfoMap;
		/** 场景的A*数据 **/
		public var aStar:UpInfoAStar;
		
		public function UpInfo(ver:uint)
		{
			this._type = UpInfoType.info;
			this.ver = ver;
			stageInfo = new UpInfoStageInfo();
			map = new UpInfoMap();
			aStar = new UpInfoAStar();
		}
		
		/** 获取这个对象的全部属性信息 **/
		override public function getByte():SByte 
		{
			var b:SByte = super.getByte();
			b.writeByte(UpGame.VER);
			b.writeUnsignedInt(id);
			b._w_String(name);
			b._w_String(gfileName);
			b._w_String(path);
			var bb:SByte = stageInfo.getByte();
			b._w_CByteArray(bb);
			bb.dispose();
			bb = map.getByte();
			b._w_CByteArray(bb, 32);
			bb.dispose();
			bb = aStar.getByte();
			b._w_CByteArray(bb, 32);
			bb.dispose();
			return b;
		}
		
		/** 读取这个内容, 返回错误信息, 0为成功 **/
		override public function setByte(b:SByte):void 
		{
			try
			{
				var b_ver:uint = b.readUnsignedByte();
				if (b_ver != ver)
				{
					g.log.pushLog(this, LogType._UserAction, "版本不匹配 : " + b_ver + " 本地:" + ver);
					ver = b_ver;
				}
				if (map.ver != ver) map.ver = ver;
				id = b.readUnsignedInt();
				name = b._r_String();
				gfileName = b._r_String();
				path = b._r_String();
				b.readUnsignedShort();
				stageInfo.setByte(b);
				if (ver > 2)
				{
					b.readUnsignedInt();
					map.setByte(b);
					b.readUnsignedInt();
					aStar.setByte(b);
				}
				else
				{
					b.readUnsignedShort();
					map.setByte(b);
					b.readUnsignedShort();
					aStar.setByte(b);
				}
			}
			catch(e:Error)
			{
				g.log.pushLog(this, LogType._UserAction, "长度出现错误,可能是版本兼容问题");
			}
		}
		
		override public function clone():IUpInfo 
		{
			var o:UpInfo = new UpInfo(ver);
			o.ver = ver;
			o.id = id;
			o.name = name;
			o.gfileName = gfileName;
			o.path = path;
			o.stageInfo = stageInfo.clone() as UpInfoStageInfo;
			o.map = map.clone() as UpInfoMap;
			o.aStar = aStar.clone() as UpInfoAStar;
			return o;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			stageInfo.dispose();
			map.dispose();
			aStar.dispose();
		}
		
		/** 获取这个界面的保存文件名称 .upmap **/
		public function get fileName():String { return name + ".upmap"; }
		
		/** 获取这个界面的相对路径,包含文件名 **/
		public function get filePath():String { return path + fileName; }
	}
}