package cn.wjj.upgame.render 
{
	import flash.display.DisplayObject;
	
	import cn.wjj.display.ui2d.IU2Base;
	import cn.wjj.display.ui2d.info.U2InfoBaseInfo;
	import cn.wjj.upgame.UpGame;
	import cn.wjj.upgame.data.SkillActiveModel;
	import cn.wjj.upgame.engine.EDRole;
	
	/**
	 * -1的大特效
	 * @author GaGa
	 */
	public class EngineSkillBigEffectNegative1 extends EngineSkillBigEffectBase 
	{
		/** 主内容显示对象 **/
		private var role:IU2Base;
		
		public function EngineSkillBigEffectNegative1(u:UpGame, ed:EDRole, skill:SkillActiveModel, timeStart:int) 
		{
			super(u, ed, skill, timeStart);
		}
		
		override public function start():void 
		{
			var isRun:Boolean = false;
			if (u.modeTurn)
			{
				if (u.reader.map.layer_ground.canInLayer( -ed.x, -ed.y, 250))
				{
					isRun = true;
				}
			}
			else
			{
				if (u.reader.map.layer_ground.canInLayer(ed.x, ed.y, 250))
				{
					isRun = true;
				}
			}
			if (isRun)
			{
				var info:U2InfoBaseInfo = u.reader.u2Info("assets/uief/zd/zd_gb_01.u2");
				if (info && info.layer.isPlay && info.layer.timeLength)
				{
					timeEnd = timeStart + info.layer.timeLength;
					display = u.reader.u2UseInfo(info, false, timeStart) as IU2Base;
					display.x = ed.x + ed.hit_r_x;
					display.y = ed.y + ed.hit_r_y;
					if (ed.hit_h)
					{
						display.x += int(ed.hit_r / 2);
						display.y += int(ed.hit_h / 2);
					}
					if (u.modeTurn)
					{
						display.x = -display.x;
						display.y = -display.y;
					}
					u.reader.map.addChild(display as DisplayObject);
					return;
					/*
					var displayEDRole:DisplayEDRole = u.reader.map.edToDisplay(ed) as DisplayEDRole;
					if (displayEDRole && displayEDRole.displayId)
					{
						var path:String = "assets/model/" + ed.model.id + "/" + displayEDRole.displayId + ".u2";
						var pathDisplay:DisplayObject = u.reader.u2(path);
						if (pathDisplay)
						{
							var core:int = timeStart;
							if (displayEDRole.display.timer)
							{
								core = timeStart + displayEDRole.display.timer.time;
							}
							role = pathDisplay as IU2Base;
							role.scaleX = ed.model.scaleX;
							role.scaleY = ed.model.scaleY;
							role.timer.timeCore(core, timeStart, true, false);
							if (ed.displayMirror)
							{
								if (pathDisplay.scaleX > 0) pathDisplay.scaleX = -pathDisplay.scaleX;//要负数
							}
							else if (pathDisplay.scaleX < 0)
							{
								pathDisplay.scaleX = -pathDisplay.scaleX;//要正数
							}
							u.reader.map.addChild(role as DisplayObject);
						}
					}
					*/
				}
			}
		}
		
		override public function run(time:int):Boolean 
		{
			(display as Object).timer.timeCore(time, -1, false, false);
			if (timeEnd > time)
			{
				//添加震屏
				var x:int = int(u.reader.map.shockMaxX * (0.5 - Math.random()));
				var y:int = int(u.reader.map.shockMaxY * (0.5 - Math.random()));
				u.reader.map.shock(x, y);
				return false;
			}
			u.reader.map.shock(0, 0);
			return true;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			if (role)
			{
				role.dispose();
				role = null;
			}
		}
	}
}