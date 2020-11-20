package cn.wjj.upgame.render 
{
	import cn.wjj.display.ui2d.info.U2InfoBaseInfo;
	import cn.wjj.gagaframe.client.speedfact.SpeedLib;
	import cn.wjj.upgame.engine.EDRole;
	import cn.wjj.upgame.engine.EDSkillBuff;
	import cn.wjj.upgame.UpGame;
	import flash.utils.Dictionary;
	

	/**
	 * Buff列表,控制Buff的播放
	 * 
	 * @author GaGa
	 */
	public class DisplayEDRoleBuff
	{
		/** 对象池 **/
		private static var __f:SpeedLib = new SpeedLib(100);
		/** 对象池强引用的最大数量 **/
		static public function get __m():uint { return __f.length; }
		/** 对象池强引用的最大数量 **/
		static public function set __m(value:uint):void { __f.length = value; }
		public static function instance():DisplayEDRoleBuff
		{
			var o:DisplayEDRoleBuff = __f.instance() as DisplayEDRoleBuff;
			if (o == null) o = new DisplayEDRoleBuff();
			return o;
		}
		
		/** 移除,清理,并回收 **/
		public function dispose():void
		{
			if (this.length)
			{
				for each (var item:Object in this.buff) 
				{
					delete this.buff[item];
				}
				this.effectList.length = 0;
				this.effectLength.length = 0;
				for each (var link:DisplayEDU2LinkInfo in this.effectLink) 
				{
					link.dispose();
				}
				this.effectLink.length = 0;
			}
			__f.recover(this);
		
		}
		
		/** 把Buff保存起来 **/
		private var buff:Dictionary = new Dictionary(true);
		/** 添加了多少特效 **/
		private var length:int = 0;
		/** 特效的列表ID **/
		private var effectList:Vector.<uint> = new Vector.<uint>();
		/** 每一个列表现在加了多少个 **/
		private var effectLength:Vector.<int> = new Vector.<int>();
		/** 现在对应的显示列表数量 **/
		private var effectLink:Vector.<DisplayEDU2LinkInfo> = new Vector.<DisplayEDU2LinkInfo>();
		/** 没有技能的ID **/
		private static var noSkillId:Vector.<uint> = new Vector.<uint>();
		/** 没有技能的ID长度 **/
		private static var noSkillLength:int = 0;
		
		public function DisplayEDRoleBuff() { }
		
		/**
		 * 刷新buff列表
		 * @param	ed
		 * @param	display
		 * @param	list
		 */
		public function reFresh(upGame:UpGame, ed:EDRole, display:DisplayEDRole, list:Array, core:int):void
		{
			var link:DisplayEDU2LinkInfo;
			var id:uint;
			var index:int;
			var u2Info:U2InfoBaseInfo;
			var path:String;
			for each (var item:EDSkillBuff in list) 
			{
				if (item.effect.effect.hitEffect && buff[item] == null)
				{
					id = item.effect.effect.hitEffect;
					if (noSkillLength && noSkillId.indexOf(id) != -1)
					{
						continue;
					}
					path = "assets/effect/skill/" + id + ".u2";
					u2Info = upGame.reader.u2Info(path);
					if(u2Info)
					{
						buff[item] = true;
						index = effectList.indexOf(id);
						if (index == -1)
						{
							link = DisplayEDU2LinkInfo.instance();
							link.setEmb("ground", display);
							link.sendTime(core);
							if (upGame.modeTurn)
							{
								link.setThis(upGame, ed, path, -ed.x, -ed.y, 0, 1, 1, 1, u2Info);
							}
							else
							{
								link.setThis(upGame, ed, path, ed.x, ed.y, 0, 1, 1, 1, u2Info);
							}
							length++;
							effectList.push(id);
							effectLength.push(1);
							effectLink.push(link);
						}
						else
						{
							effectLength[index] = effectLength[index] + 1;
						}
					}
					else
					{
						noSkillId.push(id);
						noSkillLength++;
					}
				}
			}
			if (length)
			{
				for each (link in effectLink) 
				{
					link.sendTime(core);
					if (upGame.modeTurn)
					{
						link.changeInfo( -ed.x, -ed.y);
					}
					else
					{
						link.changeInfo(ed.x, ed.y);
					}
				}
			}
		}
		
		/** 移除一个Buff **/
		public function removeBuff(item:EDSkillBuff):void
		{
			if (buff[item])
			{
				var id:uint = item.effect.effect.hitEffect;
				var index:int = effectList.indexOf(id);
				if (index != -1)
				{
					effectLength[index] = effectLength[index] - 1;
					if (effectLength[index] == 0)
					{
						length--;
						effectList.splice(index, 1);
						effectLength.splice(index, 1);
						var link:DisplayEDU2LinkInfo = effectLink[index];
						effectLink.splice(index, 1);
						link.dispose();
						link = null;
					}
				}
			}
			delete buff[item];
		}
	}
}