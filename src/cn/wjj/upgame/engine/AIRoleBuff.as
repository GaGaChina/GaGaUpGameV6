package cn.wjj.upgame.engine 
{
	import cn.wjj.g;
	/**
	 * 角色身上带的BUFF
	 * 
	 * @author GaGa
	 */
	public class AIRoleBuff 
	{
		/** 是否存活 **/
		public var isLive:Boolean = true;
		/** 所属对象 **/
		public var ed:EDRole;
		/** 身上的BUFF列表 **/
		public var buffList:Array;
		/** 遍历的时候处理 **/
		private var buffCopy:Array;
		/** 长度 **/
		public var length:int = 0;
		/** 是否正在运行runBuff函数,如果在最后要执行edStop,所以前面的edStop全部可以跳过 **/
		private var inRunBuff:Boolean = false;
		
		public function AIRoleBuff()
		{
			buffList = g.speedFact.n_array();
			buffCopy = g.speedFact.n_array();
		}
		
		/** 不停的运行现在身上的Buff **/
		public function runBuff():void
		{
			if (isLive && length)
			{
				buffCopy.push.apply(null, buffList);
				inRunBuff = true;
				for each (var buff:EDSkillBuff in buffCopy) 
				{
					buff.aiRun();
				}
				buffCopy.length = 0;
				inRunBuff = false;
				edStop();
			}
		}
		
		/** 检测现在buff里还有需要停止的内容没有 **/
		private function edStop():void
		{
			if (isLive && inRunBuff == false)
			{
				var stop:Boolean = false;
				var stun:Boolean = false;
				if (length)
				{
					for each (var buff:EDSkillBuff in buffList) 
					{
						if (stop == false && buff.isStop) stop = true;
						if (stun == false && buff.isStun) stun = true;
						if (stop && stun)
						{
							break;
						}
					}
				}
				ed.aiStop = stop;
				ed.aiStun = stun;
			}
		}
		
		/** 添加一个Buff效果 **/
		public function addBuff(buff:EDSkillBuff):void
		{
			if (length)
			{
				var remove:EDSkillBuff;
				var type:uint = buff.effect.effect.buffDel;
				if (buff.effect.effect.buffClear == 1)
				{
					for each (remove in buffList) 
					{
						remove.dispose();
					}
					buffList.length = 0;
					length = 0;
				}
				else if (type != 0)
				{
					var l:uint = length;
					while (--l > -1)
					{
						remove = buffList[l];
						if (remove.effect.effect.buffType == type)
						{
							//删除 , 把Buff影响的值,在处理回去 (在 dispose 里)
							remove.dispose();
							buffList.splice(l, 1);
							length--;
						}
					}
				}
			}
			buffList.push(buff);
			length++;
			if(ed) buff.aiRun();
			edStop();
		}
		
		/** 移除一个Buff效果 **/
		public function removeBuff(buff:EDSkillBuff):void
		{
			if(length)
			{
				var index:int = buffList.indexOf(buff);
				if (index != -1)
				{
					buffList.splice(index, 1);
					buff.dispose();
					length--;
				}
				edStop();
			}
		}
		
		/** 清除Buff效果 **/
		public function clearBuff():void
		{
			if (isLive && length)
			{
				for each (var buff:EDSkillBuff in buffList) 
				{
					buff.dispose();
				}
				buffList.length = 0;
				length = 0;
				edStop();
			}
		}
		
		public function clear():void
		{
			clearBuff();
			ed = null;
			isLive = false;
		}
	}
}