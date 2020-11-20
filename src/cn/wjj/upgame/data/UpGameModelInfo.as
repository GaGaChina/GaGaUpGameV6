package cn.wjj.upgame.data
{
	import flash.utils.ByteArray;
	/**
	 * UpGame模型数据
	 */
	public class UpGameModelInfo
	{
		/** 索引字段 **/
		internal static var __keyList:Array = ["id"];
		/** [默认:0]模型Id **/
		public function get id():uint {
			if (__info.hasOwnProperty("id")) return __info["id"];
			return 0;
		}
		/** [默认:0]boss头像 : boss血条用，\assets\boss下的u2 **/
		public function get bosshead():uint {
			if (__info.hasOwnProperty("bosshead")) return __info["bosshead"];
			return 0;
		}
		/** [默认:0]基础移动速度 **/
		public function get speed():uint {
			if (__info.hasOwnProperty("speed")) return __info["speed"];
			return 0;
		}
		/** [默认:0]影子缩放类型 **/
		public function get shadowType():uint {
			if (__info.hasOwnProperty("shadowType")) return __info["shadowType"];
			return 0;
		}
		/** [默认:0]影子X轴缩放比例 **/
		public function get shadowScaleX():Number {
			if (__info.hasOwnProperty("shadowScaleX")) return __info["shadowScaleX"];
			return 0;
		}
		/** [默认:0]影子Y轴缩放比例 **/
		public function get shadowScaleY():Number {
			if (__info.hasOwnProperty("shadowScaleY")) return __info["shadowScaleY"];
			return 0;
		}
		/** [默认:0]模型缩放比例X **/
		public function get scaleX():Number {
			if (__info.hasOwnProperty("scaleX")) return __info["scaleX"];
			return 0;
		}
		/** [默认:0]模型缩放比例Y **/
		public function get scaleY():Number {
			if (__info.hasOwnProperty("scaleY")) return __info["scaleY"];
			return 0;
		}
		/** [默认:0]模型关联特效x轴缩放比例 **/
		public function get hitSkillScaleX():Number {
			if (__info.hasOwnProperty("hitSkillScaleX")) return __info["hitSkillScaleX"];
			return 0;
		}
		/** [默认:0]模型关联特效y轴缩放比例 **/
		public function get hitSkillScaleY():Number {
			if (__info.hasOwnProperty("hitSkillScaleY")) return __info["hitSkillScaleY"];
			return 0;
		}
		/** [默认:0]碰撞半径偏移X坐标 **/
		public function get hit_r_x():int {
			if (__info.hasOwnProperty("hit_r_x")) return __info["hit_r_x"];
			return 0;
		}
		/** [默认:0]碰撞半径偏移Y坐标 **/
		public function get hit_r_y():int {
			if (__info.hasOwnProperty("hit_r_y")) return __info["hit_r_y"];
			return 0;
		}
		/** [默认:0]碰撞半径或矩形的宽度 **/
		public function get hit_r():uint {
			if (__info.hasOwnProperty("hit_r")) return __info["hit_r"];
			return 0;
		}
		/** [默认:0]矩形的高度 : 圆形填0 **/
		public function get hit_h():uint {
			if (__info.hasOwnProperty("hit_h")) return __info["hit_h"];
			return 0;
		}
		/** [默认:false]是否可被击飞 : 0不能被击飞，1能被击飞 **/
		public function get bhitType():Boolean {
			if (__info.hasOwnProperty("bhitType")) return __info["bhitType"];
			return false;
		}
		/** [默认:0]血条的坐标y **/
		public function get bloodY():int {
			if (__info.hasOwnProperty("bloodY")) return __info["bloodY"];
			return 0;
		}
		/** [默认:0]血条的长度 : x坐标由模型的中心点和长度算出 **/
		public function get bloodWidth():uint {
			if (__info.hasOwnProperty("bloodWidth")) return __info["bloodWidth"];
			return 0;
		}
		/** [默认:0]血条显示类型 : 0-不显示，1-被攻击时显示，2-总是显示，3-固定显示在屏幕最顶端，4-(始终显示等级)受伤后永久显示血条，5-(显示 等级)激活后永久显示血条,并有心心, 6-(显示等级)总是显示, 7-(不显示等级,但显示图标)总是显示 **/
		public function get hpDisType():uint {
			if (__info.hasOwnProperty("hpDisType")) return __info["hpDisType"];
			return 0;
		}
		/** [默认:0]选中区域的形状 : 1矩形2圆形 **/
		public function get dragType():uint {
			if (__info.hasOwnProperty("dragType")) return __info["dragType"];
			return 0;
		}
		/** [默认:0]选中区域左下角顶点的x坐标 **/
		public function get dragX():int {
			if (__info.hasOwnProperty("dragX")) return __info["dragX"];
			return 0;
		}
		/** [默认:0]选中区域左下角顶点的y坐标 **/
		public function get dragY():int {
			if (__info.hasOwnProperty("dragY")) return __info["dragY"];
			return 0;
		}
		/** [默认:0]选中区域的宽度 **/
		public function get dragWidth():uint {
			if (__info.hasOwnProperty("dragWidth")) return __info["dragWidth"];
			return 0;
		}
		/** [默认:0]选中区域的高度 **/
		public function get dragHeight():uint {
			if (__info.hasOwnProperty("dragHeight")) return __info["dragHeight"];
			return 0;
		}
		/** [默认:0]出场震屏开始时间(毫秒) **/
		public function get appearShakeStart():uint {
			if (__info.hasOwnProperty("appearShakeStart")) return __info["appearShakeStart"];
			return 0;
		}
		/** [默认:0]出场震屏时间长度(毫秒) **/
		public function get appearShakeLength():uint {
			if (__info.hasOwnProperty("appearShakeLength")) return __info["appearShakeLength"];
			return 0;
		}
		/** [默认:0]出场震屏类型 : 1小震动，2中震动，3大震动 **/
		public function get appearShakeType():uint {
			if (__info.hasOwnProperty("appearShakeType")) return __info["appearShakeType"];
			return 0;
		}
		/** [默认:0]模型1类型待机 **/
		public function get typeIdle():int {
			if (__info.hasOwnProperty("typeIdle")) return __info["typeIdle"];
			return 0;
		}
		/** [默认:0]模型2类型移动 **/
		public function get typeMove():int {
			if (__info.hasOwnProperty("typeMove")) return __info["typeMove"];
			return 0;
		}
		/** [默认:0]模型3类型技能一普攻 **/
		public function get typeSkill1():int {
			if (__info.hasOwnProperty("typeSkill1")) return __info["typeSkill1"];
			return 0;
		}
		/** [默认:0]模型4类型死亡 **/
		public function get typeDie():int {
			if (__info.hasOwnProperty("typeDie")) return __info["typeDie"];
			return 0;
		}
		/** [默认:0]模型5类型技能二 **/
		public function get typeSkill2():int {
			if (__info.hasOwnProperty("typeSkill2")) return __info["typeSkill2"];
			return 0;
		}
		/** [默认:0]模型6类型技能三 **/
		public function get typeSkill3():int {
			if (__info.hasOwnProperty("typeSkill3")) return __info["typeSkill3"];
			return 0;
		}
		/** [默认:0]模型7类型技能四 **/
		public function get typeSkill4():int {
			if (__info.hasOwnProperty("typeSkill4")) return __info["typeSkill4"];
			return 0;
		}
		/** [默认:0]模型8类型技能五 **/
		public function get typeSkill5():int {
			if (__info.hasOwnProperty("typeSkill5")) return __info["typeSkill5"];
			return 0;
		}
		/** [默认:0]模型9类型出场 : u2尾号901，出场类型为0或者出场播放时间为0,就是没有出场 **/
		public function get typeAppear():int {
			if (__info.hasOwnProperty("typeAppear")) return __info["typeAppear"];
			return 0;
		}
		/** [默认:0]出场播放时间（毫秒） : u2里最后一帧的时间，编辑器里的单位是秒，填时减10-20毫秒 **/
		public function get appearTime():int {
			if (__info.hasOwnProperty("appearTime")) return __info["appearTime"];
			return 0;
		}
		/** [默认:0]死亡动画时间（毫秒） **/
		public function get deadTime():uint {
			if (__info.hasOwnProperty("deadTime")) return __info["deadTime"];
			return 0;
		}
		/** [默认:false]死亡动画是否默认人物层 : 0默认放人物层，1由u2决定 **/
		public function get deadU2():Boolean {
			if (__info.hasOwnProperty("deadU2")) return __info["deadU2"];
			return false;
		}
		/** [默认:0]技能1（普攻）触发点1方向1x : 16方向时：1上，2右上1，3右上2，4右上3，5右，6右下1,7右下2,8右下3，9下；8方向时：1上， 2右上，3右，4右下，5下； **/
		public function get p1s1x1():int {
			if (__info.hasOwnProperty("p1s1x1")) return __info["p1s1x1"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点1方向1y **/
		public function get p1s1y1():int {
			if (__info.hasOwnProperty("p1s1y1")) return __info["p1s1y1"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点1方向2x **/
		public function get p2s1x1():int {
			if (__info.hasOwnProperty("p2s1x1")) return __info["p2s1x1"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点1方向2y **/
		public function get p2s1y1():int {
			if (__info.hasOwnProperty("p2s1y1")) return __info["p2s1y1"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点1方向3x **/
		public function get p3s1x1():int {
			if (__info.hasOwnProperty("p3s1x1")) return __info["p3s1x1"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点1方向3y **/
		public function get p3s1y1():int {
			if (__info.hasOwnProperty("p3s1y1")) return __info["p3s1y1"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点1方向4x **/
		public function get p4s1x1():int {
			if (__info.hasOwnProperty("p4s1x1")) return __info["p4s1x1"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点1方向4y **/
		public function get p4s1y1():int {
			if (__info.hasOwnProperty("p4s1y1")) return __info["p4s1y1"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点1方向5x **/
		public function get p5s1x1():int {
			if (__info.hasOwnProperty("p5s1x1")) return __info["p5s1x1"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点1方向5y **/
		public function get p5s1y1():int {
			if (__info.hasOwnProperty("p5s1y1")) return __info["p5s1y1"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点1方向6x **/
		public function get p6s1x1():int {
			if (__info.hasOwnProperty("p6s1x1")) return __info["p6s1x1"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点1方向6y **/
		public function get p6s1y1():int {
			if (__info.hasOwnProperty("p6s1y1")) return __info["p6s1y1"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点1方向7x **/
		public function get p7s1x1():int {
			if (__info.hasOwnProperty("p7s1x1")) return __info["p7s1x1"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点1方向7y **/
		public function get p7s1y1():int {
			if (__info.hasOwnProperty("p7s1y1")) return __info["p7s1y1"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点1方向8x **/
		public function get p8s1x1():int {
			if (__info.hasOwnProperty("p8s1x1")) return __info["p8s1x1"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点1方向8y **/
		public function get p8s1y1():int {
			if (__info.hasOwnProperty("p8s1y1")) return __info["p8s1y1"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点1方向9x **/
		public function get p9s1x1():int {
			if (__info.hasOwnProperty("p9s1x1")) return __info["p9s1x1"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点1方向9y **/
		public function get p9s1y1():int {
			if (__info.hasOwnProperty("p9s1y1")) return __info["p9s1y1"];
			return 0;
		}
		/** [默认:0]技能2触发点1方向1x **/
		public function get p1s2x1():int {
			if (__info.hasOwnProperty("p1s2x1")) return __info["p1s2x1"];
			return 0;
		}
		/** [默认:0]技能2触发点1方向1y **/
		public function get p1s2y1():int {
			if (__info.hasOwnProperty("p1s2y1")) return __info["p1s2y1"];
			return 0;
		}
		/** [默认:0]技能2触发点1方向2x **/
		public function get p2s2x1():int {
			if (__info.hasOwnProperty("p2s2x1")) return __info["p2s2x1"];
			return 0;
		}
		/** [默认:0]技能2触发点1方向2y **/
		public function get p2s2y1():int {
			if (__info.hasOwnProperty("p2s2y1")) return __info["p2s2y1"];
			return 0;
		}
		/** [默认:0]技能2触发点1方向3x **/
		public function get p3s2x1():int {
			if (__info.hasOwnProperty("p3s2x1")) return __info["p3s2x1"];
			return 0;
		}
		/** [默认:0]技能2触发点1方向3y **/
		public function get p3s2y1():int {
			if (__info.hasOwnProperty("p3s2y1")) return __info["p3s2y1"];
			return 0;
		}
		/** [默认:0]技能2触发点1方向4x **/
		public function get p4s2x1():int {
			if (__info.hasOwnProperty("p4s2x1")) return __info["p4s2x1"];
			return 0;
		}
		/** [默认:0]技能2触发点1方向4y **/
		public function get p4s2y1():int {
			if (__info.hasOwnProperty("p4s2y1")) return __info["p4s2y1"];
			return 0;
		}
		/** [默认:0]技能2触发点1方向5x **/
		public function get p5s2x1():int {
			if (__info.hasOwnProperty("p5s2x1")) return __info["p5s2x1"];
			return 0;
		}
		/** [默认:0]技能2触发点1方向5y **/
		public function get p5s2y1():int {
			if (__info.hasOwnProperty("p5s2y1")) return __info["p5s2y1"];
			return 0;
		}
		/** [默认:0]技能2触发点1方向6x **/
		public function get p6s2x1():int {
			if (__info.hasOwnProperty("p6s2x1")) return __info["p6s2x1"];
			return 0;
		}
		/** [默认:0]技能2触发点1方向6y **/
		public function get p6s2y1():int {
			if (__info.hasOwnProperty("p6s2y1")) return __info["p6s2y1"];
			return 0;
		}
		/** [默认:0]技能2触发点1方向7x **/
		public function get p7s2x1():int {
			if (__info.hasOwnProperty("p7s2x1")) return __info["p7s2x1"];
			return 0;
		}
		/** [默认:0]技能2触发点1方向7y **/
		public function get p7s2y1():int {
			if (__info.hasOwnProperty("p7s2y1")) return __info["p7s2y1"];
			return 0;
		}
		/** [默认:0]技能2触发点1方向8x **/
		public function get p8s2x1():int {
			if (__info.hasOwnProperty("p8s2x1")) return __info["p8s2x1"];
			return 0;
		}
		/** [默认:0]技能2触发点1方向8y **/
		public function get p8s2y1():int {
			if (__info.hasOwnProperty("p8s2y1")) return __info["p8s2y1"];
			return 0;
		}
		/** [默认:0]技能2触发点1方向9x **/
		public function get p9s2x1():int {
			if (__info.hasOwnProperty("p9s2x1")) return __info["p9s2x1"];
			return 0;
		}
		/** [默认:0]技能2触发点1方向9y **/
		public function get p9s2y1():int {
			if (__info.hasOwnProperty("p9s2y1")) return __info["p9s2y1"];
			return 0;
		}
		/** [默认:0]技能3触发点1方向1x **/
		public function get p1s3x1():int {
			if (__info.hasOwnProperty("p1s3x1")) return __info["p1s3x1"];
			return 0;
		}
		/** [默认:0]技能3触发点1方向1y **/
		public function get p1s3y1():int {
			if (__info.hasOwnProperty("p1s3y1")) return __info["p1s3y1"];
			return 0;
		}
		/** [默认:0]技能3触发点1方向2x **/
		public function get p2s3x1():int {
			if (__info.hasOwnProperty("p2s3x1")) return __info["p2s3x1"];
			return 0;
		}
		/** [默认:0]技能3触发点1方向2y **/
		public function get p2s3y1():int {
			if (__info.hasOwnProperty("p2s3y1")) return __info["p2s3y1"];
			return 0;
		}
		/** [默认:0]技能3触发点1方向3x **/
		public function get p3s3x1():int {
			if (__info.hasOwnProperty("p3s3x1")) return __info["p3s3x1"];
			return 0;
		}
		/** [默认:0]技能3触发点1方向3y **/
		public function get p3s3y1():int {
			if (__info.hasOwnProperty("p3s3y1")) return __info["p3s3y1"];
			return 0;
		}
		/** [默认:0]技能3触发点1方向4x **/
		public function get p4s3x1():int {
			if (__info.hasOwnProperty("p4s3x1")) return __info["p4s3x1"];
			return 0;
		}
		/** [默认:0]技能3触发点1方向4y **/
		public function get p4s3y1():int {
			if (__info.hasOwnProperty("p4s3y1")) return __info["p4s3y1"];
			return 0;
		}
		/** [默认:0]技能3触发点1方向5x **/
		public function get p5s3x1():int {
			if (__info.hasOwnProperty("p5s3x1")) return __info["p5s3x1"];
			return 0;
		}
		/** [默认:0]技能3触发点1方向5y **/
		public function get p5s3y1():int {
			if (__info.hasOwnProperty("p5s3y1")) return __info["p5s3y1"];
			return 0;
		}
		/** [默认:0]技能3触发点1方向6x **/
		public function get p6s3x1():int {
			if (__info.hasOwnProperty("p6s3x1")) return __info["p6s3x1"];
			return 0;
		}
		/** [默认:0]技能3触发点1方向6y **/
		public function get p6s3y1():int {
			if (__info.hasOwnProperty("p6s3y1")) return __info["p6s3y1"];
			return 0;
		}
		/** [默认:0]技能3触发点1方向7x **/
		public function get p7s3x1():int {
			if (__info.hasOwnProperty("p7s3x1")) return __info["p7s3x1"];
			return 0;
		}
		/** [默认:0]技能3触发点1方向7y **/
		public function get p7s3y1():int {
			if (__info.hasOwnProperty("p7s3y1")) return __info["p7s3y1"];
			return 0;
		}
		/** [默认:0]技能3触发点1方向8x **/
		public function get p8s3x1():int {
			if (__info.hasOwnProperty("p8s3x1")) return __info["p8s3x1"];
			return 0;
		}
		/** [默认:0]技能3触发点1方向8y **/
		public function get p8s3y1():int {
			if (__info.hasOwnProperty("p8s3y1")) return __info["p8s3y1"];
			return 0;
		}
		/** [默认:0]技能3触发点1方向9x **/
		public function get p9s3x1():int {
			if (__info.hasOwnProperty("p9s3x1")) return __info["p9s3x1"];
			return 0;
		}
		/** [默认:0]技能3触发点1方向9y **/
		public function get p9s3y1():int {
			if (__info.hasOwnProperty("p9s3y1")) return __info["p9s3y1"];
			return 0;
		}
		/** [默认:0]技能4触发点1方向1x **/
		public function get p1s4x1():int {
			if (__info.hasOwnProperty("p1s4x1")) return __info["p1s4x1"];
			return 0;
		}
		/** [默认:0]技能4触发点1方向1y **/
		public function get p1s4y1():int {
			if (__info.hasOwnProperty("p1s4y1")) return __info["p1s4y1"];
			return 0;
		}
		/** [默认:0]技能4触发点1方向2x **/
		public function get p2s4x1():int {
			if (__info.hasOwnProperty("p2s4x1")) return __info["p2s4x1"];
			return 0;
		}
		/** [默认:0]技能4触发点1方向2y **/
		public function get p2s4y1():int {
			if (__info.hasOwnProperty("p2s4y1")) return __info["p2s4y1"];
			return 0;
		}
		/** [默认:0]技能4触发点1方向3x **/
		public function get p3s4x1():int {
			if (__info.hasOwnProperty("p3s4x1")) return __info["p3s4x1"];
			return 0;
		}
		/** [默认:0]技能4触发点1方向3y **/
		public function get p3s4y1():int {
			if (__info.hasOwnProperty("p3s4y1")) return __info["p3s4y1"];
			return 0;
		}
		/** [默认:0]技能4触发点1方向4x **/
		public function get p4s4x1():int {
			if (__info.hasOwnProperty("p4s4x1")) return __info["p4s4x1"];
			return 0;
		}
		/** [默认:0]技能4触发点1方向4y **/
		public function get p4s4y1():int {
			if (__info.hasOwnProperty("p4s4y1")) return __info["p4s4y1"];
			return 0;
		}
		/** [默认:0]技能4触发点1方向5x **/
		public function get p5s4x1():int {
			if (__info.hasOwnProperty("p5s4x1")) return __info["p5s4x1"];
			return 0;
		}
		/** [默认:0]技能4触发点1方向5y **/
		public function get p5s4y1():int {
			if (__info.hasOwnProperty("p5s4y1")) return __info["p5s4y1"];
			return 0;
		}
		/** [默认:0]技能4触发点1方向6x **/
		public function get p6s4x1():int {
			if (__info.hasOwnProperty("p6s4x1")) return __info["p6s4x1"];
			return 0;
		}
		/** [默认:0]技能4触发点1方向6y **/
		public function get p6s4y1():int {
			if (__info.hasOwnProperty("p6s4y1")) return __info["p6s4y1"];
			return 0;
		}
		/** [默认:0]技能4触发点1方向7x **/
		public function get p7s4x1():int {
			if (__info.hasOwnProperty("p7s4x1")) return __info["p7s4x1"];
			return 0;
		}
		/** [默认:0]技能4触发点1方向7y **/
		public function get p7s4y1():int {
			if (__info.hasOwnProperty("p7s4y1")) return __info["p7s4y1"];
			return 0;
		}
		/** [默认:0]技能4触发点1方向8x **/
		public function get p8s4x1():int {
			if (__info.hasOwnProperty("p8s4x1")) return __info["p8s4x1"];
			return 0;
		}
		/** [默认:0]技能4触发点1方向8y **/
		public function get p8s4y1():int {
			if (__info.hasOwnProperty("p8s4y1")) return __info["p8s4y1"];
			return 0;
		}
		/** [默认:0]技能4触发点1方向9x **/
		public function get p9s4x1():int {
			if (__info.hasOwnProperty("p9s4x1")) return __info["p9s4x1"];
			return 0;
		}
		/** [默认:0]技能4触发点1方向9y **/
		public function get p9s4y1():int {
			if (__info.hasOwnProperty("p9s4y1")) return __info["p9s4y1"];
			return 0;
		}
		/** [默认:0]技能5触发点1方向1x **/
		public function get p1s5x1():int {
			if (__info.hasOwnProperty("p1s5x1")) return __info["p1s5x1"];
			return 0;
		}
		/** [默认:0]技能5触发点1方向1y **/
		public function get p1s5y1():int {
			if (__info.hasOwnProperty("p1s5y1")) return __info["p1s5y1"];
			return 0;
		}
		/** [默认:0]技能5触发点1方向2x **/
		public function get p2s5x1():int {
			if (__info.hasOwnProperty("p2s5x1")) return __info["p2s5x1"];
			return 0;
		}
		/** [默认:0]技能5触发点1方向2y **/
		public function get p2s5y1():int {
			if (__info.hasOwnProperty("p2s5y1")) return __info["p2s5y1"];
			return 0;
		}
		/** [默认:0]技能5触发点1方向3x **/
		public function get p3s5x1():int {
			if (__info.hasOwnProperty("p3s5x1")) return __info["p3s5x1"];
			return 0;
		}
		/** [默认:0]技能5触发点1方向3y **/
		public function get p3s5y1():int {
			if (__info.hasOwnProperty("p3s5y1")) return __info["p3s5y1"];
			return 0;
		}
		/** [默认:0]技能5触发点1方向4x **/
		public function get p4s5x1():int {
			if (__info.hasOwnProperty("p4s5x1")) return __info["p4s5x1"];
			return 0;
		}
		/** [默认:0]技能5触发点1方向4y **/
		public function get p4s5y1():int {
			if (__info.hasOwnProperty("p4s5y1")) return __info["p4s5y1"];
			return 0;
		}
		/** [默认:0]技能5触发点1方向5x **/
		public function get p5s5x1():int {
			if (__info.hasOwnProperty("p5s5x1")) return __info["p5s5x1"];
			return 0;
		}
		/** [默认:0]技能5触发点1方向5y **/
		public function get p5s5y1():int {
			if (__info.hasOwnProperty("p5s5y1")) return __info["p5s5y1"];
			return 0;
		}
		/** [默认:0]技能5触发点1方向6x **/
		public function get p6s5x1():int {
			if (__info.hasOwnProperty("p6s5x1")) return __info["p6s5x1"];
			return 0;
		}
		/** [默认:0]技能5触发点1方向6y **/
		public function get p6s5y1():int {
			if (__info.hasOwnProperty("p6s5y1")) return __info["p6s5y1"];
			return 0;
		}
		/** [默认:0]技能5触发点1方向7x **/
		public function get p7s5x1():int {
			if (__info.hasOwnProperty("p7s5x1")) return __info["p7s5x1"];
			return 0;
		}
		/** [默认:0]技能5触发点1方向7y **/
		public function get p7s5y1():int {
			if (__info.hasOwnProperty("p7s5y1")) return __info["p7s5y1"];
			return 0;
		}
		/** [默认:0]技能5触发点1方向8x **/
		public function get p8s5x1():int {
			if (__info.hasOwnProperty("p8s5x1")) return __info["p8s5x1"];
			return 0;
		}
		/** [默认:0]技能5触发点1方向8y **/
		public function get p8s5y1():int {
			if (__info.hasOwnProperty("p8s5y1")) return __info["p8s5y1"];
			return 0;
		}
		/** [默认:0]技能5触发点1方向9x **/
		public function get p9s5x1():int {
			if (__info.hasOwnProperty("p9s5x1")) return __info["p9s5x1"];
			return 0;
		}
		/** [默认:0]技能5触发点1方向9y **/
		public function get p9s5y1():int {
			if (__info.hasOwnProperty("p9s5y1")) return __info["p9s5y1"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点2方向1x **/
		public function get p1s1x2():int {
			if (__info.hasOwnProperty("p1s1x2")) return __info["p1s1x2"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点2方向1y **/
		public function get p1s1y2():int {
			if (__info.hasOwnProperty("p1s1y2")) return __info["p1s1y2"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点2方向2x **/
		public function get p2s1x2():int {
			if (__info.hasOwnProperty("p2s1x2")) return __info["p2s1x2"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点2方向2y **/
		public function get p2s1y2():int {
			if (__info.hasOwnProperty("p2s1y2")) return __info["p2s1y2"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点2方向3x **/
		public function get p3s1x2():int {
			if (__info.hasOwnProperty("p3s1x2")) return __info["p3s1x2"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点2方向3y **/
		public function get p3s1y2():int {
			if (__info.hasOwnProperty("p3s1y2")) return __info["p3s1y2"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点2方向4x **/
		public function get p4s1x2():int {
			if (__info.hasOwnProperty("p4s1x2")) return __info["p4s1x2"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点2方向4y **/
		public function get p4s1y2():int {
			if (__info.hasOwnProperty("p4s1y2")) return __info["p4s1y2"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点2方向5x **/
		public function get p5s1x2():int {
			if (__info.hasOwnProperty("p5s1x2")) return __info["p5s1x2"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点2方向5y **/
		public function get p5s1y2():int {
			if (__info.hasOwnProperty("p5s1y2")) return __info["p5s1y2"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点2方向6x **/
		public function get p6s1x2():int {
			if (__info.hasOwnProperty("p6s1x2")) return __info["p6s1x2"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点2方向6y **/
		public function get p6s1y2():int {
			if (__info.hasOwnProperty("p6s1y2")) return __info["p6s1y2"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点2方向7x **/
		public function get p7s1x2():int {
			if (__info.hasOwnProperty("p7s1x2")) return __info["p7s1x2"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点2方向7y **/
		public function get p7s1y2():int {
			if (__info.hasOwnProperty("p7s1y2")) return __info["p7s1y2"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点2方向8x **/
		public function get p8s1x2():int {
			if (__info.hasOwnProperty("p8s1x2")) return __info["p8s1x2"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点2方向8y **/
		public function get p8s1y2():int {
			if (__info.hasOwnProperty("p8s1y2")) return __info["p8s1y2"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点2方向9x **/
		public function get p9s1x2():int {
			if (__info.hasOwnProperty("p9s1x2")) return __info["p9s1x2"];
			return 0;
		}
		/** [默认:0]技能1（普攻）触发点2方向9y **/
		public function get p9s1y2():int {
			if (__info.hasOwnProperty("p9s1y2")) return __info["p9s1y2"];
			return 0;
		}
		/** [默认:0]技能2触发点2方向1x **/
		public function get p1s2x2():int {
			if (__info.hasOwnProperty("p1s2x2")) return __info["p1s2x2"];
			return 0;
		}
		/** [默认:0]技能2触发点2方向1y **/
		public function get p1s2y2():int {
			if (__info.hasOwnProperty("p1s2y2")) return __info["p1s2y2"];
			return 0;
		}
		/** [默认:0]技能2触发点2方向2x **/
		public function get p2s2x2():int {
			if (__info.hasOwnProperty("p2s2x2")) return __info["p2s2x2"];
			return 0;
		}
		/** [默认:0]技能2触发点2方向2y **/
		public function get p2s2y2():int {
			if (__info.hasOwnProperty("p2s2y2")) return __info["p2s2y2"];
			return 0;
		}
		/** [默认:0]技能2触发点2方向3x **/
		public function get p3s2x2():int {
			if (__info.hasOwnProperty("p3s2x2")) return __info["p3s2x2"];
			return 0;
		}
		/** [默认:0]技能2触发点2方向3y **/
		public function get p3s2y2():int {
			if (__info.hasOwnProperty("p3s2y2")) return __info["p3s2y2"];
			return 0;
		}
		/** [默认:0]技能2触发点2方向4x **/
		public function get p4s2x2():int {
			if (__info.hasOwnProperty("p4s2x2")) return __info["p4s2x2"];
			return 0;
		}
		/** [默认:0]技能2触发点2方向4y **/
		public function get p4s2y2():int {
			if (__info.hasOwnProperty("p4s2y2")) return __info["p4s2y2"];
			return 0;
		}
		/** [默认:0]技能2触发点2方向5x **/
		public function get p5s2x2():int {
			if (__info.hasOwnProperty("p5s2x2")) return __info["p5s2x2"];
			return 0;
		}
		/** [默认:0]技能2触发点2方向5y **/
		public function get p5s2y2():int {
			if (__info.hasOwnProperty("p5s2y2")) return __info["p5s2y2"];
			return 0;
		}
		/** [默认:0]技能2触发点2方向6x **/
		public function get p6s2x2():int {
			if (__info.hasOwnProperty("p6s2x2")) return __info["p6s2x2"];
			return 0;
		}
		/** [默认:0]技能2触发点2方向6y **/
		public function get p6s2y2():int {
			if (__info.hasOwnProperty("p6s2y2")) return __info["p6s2y2"];
			return 0;
		}
		/** [默认:0]技能2触发点2方向7x **/
		public function get p7s2x2():int {
			if (__info.hasOwnProperty("p7s2x2")) return __info["p7s2x2"];
			return 0;
		}
		/** [默认:0]技能2触发点2方向7y **/
		public function get p7s2y2():int {
			if (__info.hasOwnProperty("p7s2y2")) return __info["p7s2y2"];
			return 0;
		}
		/** [默认:0]技能2触发点2方向8x **/
		public function get p8s2x2():int {
			if (__info.hasOwnProperty("p8s2x2")) return __info["p8s2x2"];
			return 0;
		}
		/** [默认:0]技能2触发点2方向8y **/
		public function get p8s2y2():int {
			if (__info.hasOwnProperty("p8s2y2")) return __info["p8s2y2"];
			return 0;
		}
		/** [默认:0]技能2触发点2方向9x **/
		public function get p9s2x2():int {
			if (__info.hasOwnProperty("p9s2x2")) return __info["p9s2x2"];
			return 0;
		}
		/** [默认:0]技能2触发点2方向9y **/
		public function get p9s2y2():int {
			if (__info.hasOwnProperty("p9s2y2")) return __info["p9s2y2"];
			return 0;
		}
		/** [默认:0]技能3触发点2方向1x **/
		public function get p1s3x2():int {
			if (__info.hasOwnProperty("p1s3x2")) return __info["p1s3x2"];
			return 0;
		}
		/** [默认:0]技能3触发点2方向1y **/
		public function get p1s3y2():int {
			if (__info.hasOwnProperty("p1s3y2")) return __info["p1s3y2"];
			return 0;
		}
		/** [默认:0]技能3触发点2方向2x **/
		public function get p2s3x2():int {
			if (__info.hasOwnProperty("p2s3x2")) return __info["p2s3x2"];
			return 0;
		}
		/** [默认:0]技能3触发点2方向2y **/
		public function get p2s3y2():int {
			if (__info.hasOwnProperty("p2s3y2")) return __info["p2s3y2"];
			return 0;
		}
		/** [默认:0]技能3触发点2方向3x **/
		public function get p3s3x2():int {
			if (__info.hasOwnProperty("p3s3x2")) return __info["p3s3x2"];
			return 0;
		}
		/** [默认:0]技能3触发点2方向3y **/
		public function get p3s3y2():int {
			if (__info.hasOwnProperty("p3s3y2")) return __info["p3s3y2"];
			return 0;
		}
		/** [默认:0]技能3触发点2方向4x **/
		public function get p4s3x2():int {
			if (__info.hasOwnProperty("p4s3x2")) return __info["p4s3x2"];
			return 0;
		}
		/** [默认:0]技能3触发点2方向4y **/
		public function get p4s3y2():int {
			if (__info.hasOwnProperty("p4s3y2")) return __info["p4s3y2"];
			return 0;
		}
		/** [默认:0]技能3触发点2方向5x **/
		public function get p5s3x2():int {
			if (__info.hasOwnProperty("p5s3x2")) return __info["p5s3x2"];
			return 0;
		}
		/** [默认:0]技能3触发点2方向5y **/
		public function get p5s3y2():int {
			if (__info.hasOwnProperty("p5s3y2")) return __info["p5s3y2"];
			return 0;
		}
		/** [默认:0]技能3触发点2方向6x **/
		public function get p6s3x2():int {
			if (__info.hasOwnProperty("p6s3x2")) return __info["p6s3x2"];
			return 0;
		}
		/** [默认:0]技能3触发点2方向6y **/
		public function get p6s3y2():int {
			if (__info.hasOwnProperty("p6s3y2")) return __info["p6s3y2"];
			return 0;
		}
		/** [默认:0]技能3触发点2方向7x **/
		public function get p7s3x2():int {
			if (__info.hasOwnProperty("p7s3x2")) return __info["p7s3x2"];
			return 0;
		}
		/** [默认:0]技能3触发点2方向7y **/
		public function get p7s3y2():int {
			if (__info.hasOwnProperty("p7s3y2")) return __info["p7s3y2"];
			return 0;
		}
		/** [默认:0]技能3触发点2方向8x **/
		public function get p8s3x2():int {
			if (__info.hasOwnProperty("p8s3x2")) return __info["p8s3x2"];
			return 0;
		}
		/** [默认:0]技能3触发点2方向8y **/
		public function get p8s3y2():int {
			if (__info.hasOwnProperty("p8s3y2")) return __info["p8s3y2"];
			return 0;
		}
		/** [默认:0]技能3触发点2方向9x **/
		public function get p9s3x2():int {
			if (__info.hasOwnProperty("p9s3x2")) return __info["p9s3x2"];
			return 0;
		}
		/** [默认:0]技能3触发点2方向9y **/
		public function get p9s3y2():int {
			if (__info.hasOwnProperty("p9s3y2")) return __info["p9s3y2"];
			return 0;
		}
		/** [默认:0]技能4触发点2方向1x **/
		public function get p1s4x2():int {
			if (__info.hasOwnProperty("p1s4x2")) return __info["p1s4x2"];
			return 0;
		}
		/** [默认:0]技能4触发点2方向1y **/
		public function get p1s4y2():int {
			if (__info.hasOwnProperty("p1s4y2")) return __info["p1s4y2"];
			return 0;
		}
		/** [默认:0]技能4触发点2方向2x **/
		public function get p2s4x2():int {
			if (__info.hasOwnProperty("p2s4x2")) return __info["p2s4x2"];
			return 0;
		}
		/** [默认:0]技能4触发点2方向2y **/
		public function get p2s4y2():int {
			if (__info.hasOwnProperty("p2s4y2")) return __info["p2s4y2"];
			return 0;
		}
		/** [默认:0]技能4触发点2方向3x **/
		public function get p3s4x2():int {
			if (__info.hasOwnProperty("p3s4x2")) return __info["p3s4x2"];
			return 0;
		}
		/** [默认:0]技能4触发点2方向3y **/
		public function get p3s4y2():int {
			if (__info.hasOwnProperty("p3s4y2")) return __info["p3s4y2"];
			return 0;
		}
		/** [默认:0]技能4触发点2方向4x **/
		public function get p4s4x2():int {
			if (__info.hasOwnProperty("p4s4x2")) return __info["p4s4x2"];
			return 0;
		}
		/** [默认:0]技能4触发点2方向4y **/
		public function get p4s4y2():int {
			if (__info.hasOwnProperty("p4s4y2")) return __info["p4s4y2"];
			return 0;
		}
		/** [默认:0]技能4触发点2方向5x **/
		public function get p5s4x2():int {
			if (__info.hasOwnProperty("p5s4x2")) return __info["p5s4x2"];
			return 0;
		}
		/** [默认:0]技能4触发点2方向5y **/
		public function get p5s4y2():int {
			if (__info.hasOwnProperty("p5s4y2")) return __info["p5s4y2"];
			return 0;
		}
		/** [默认:0]技能4触发点2方向6x **/
		public function get p6s4x2():int {
			if (__info.hasOwnProperty("p6s4x2")) return __info["p6s4x2"];
			return 0;
		}
		/** [默认:0]技能4触发点2方向6y **/
		public function get p6s4y2():int {
			if (__info.hasOwnProperty("p6s4y2")) return __info["p6s4y2"];
			return 0;
		}
		/** [默认:0]技能4触发点2方向7x **/
		public function get p7s4x2():int {
			if (__info.hasOwnProperty("p7s4x2")) return __info["p7s4x2"];
			return 0;
		}
		/** [默认:0]技能4触发点2方向7y **/
		public function get p7s4y2():int {
			if (__info.hasOwnProperty("p7s4y2")) return __info["p7s4y2"];
			return 0;
		}
		/** [默认:0]技能4触发点2方向8x **/
		public function get p8s4x2():int {
			if (__info.hasOwnProperty("p8s4x2")) return __info["p8s4x2"];
			return 0;
		}
		/** [默认:0]技能4触发点2方向8y **/
		public function get p8s4y2():int {
			if (__info.hasOwnProperty("p8s4y2")) return __info["p8s4y2"];
			return 0;
		}
		/** [默认:0]技能4触发点2方向9x **/
		public function get p9s4x2():int {
			if (__info.hasOwnProperty("p9s4x2")) return __info["p9s4x2"];
			return 0;
		}
		/** [默认:0]技能4触发点2方向9y **/
		public function get p9s4y2():int {
			if (__info.hasOwnProperty("p9s4y2")) return __info["p9s4y2"];
			return 0;
		}
		/** [默认:0]技能5触发点2方向1x **/
		public function get p1s5x2():int {
			if (__info.hasOwnProperty("p1s5x2")) return __info["p1s5x2"];
			return 0;
		}
		/** [默认:0]技能5触发点2方向1y **/
		public function get p1s5y2():int {
			if (__info.hasOwnProperty("p1s5y2")) return __info["p1s5y2"];
			return 0;
		}
		/** [默认:0]技能5触发点2方向2x **/
		public function get p2s5x2():int {
			if (__info.hasOwnProperty("p2s5x2")) return __info["p2s5x2"];
			return 0;
		}
		/** [默认:0]技能5触发点2方向2y **/
		public function get p2s5y2():int {
			if (__info.hasOwnProperty("p2s5y2")) return __info["p2s5y2"];
			return 0;
		}
		/** [默认:0]技能5触发点2方向3x **/
		public function get p3s5x2():int {
			if (__info.hasOwnProperty("p3s5x2")) return __info["p3s5x2"];
			return 0;
		}
		/** [默认:0]技能5触发点2方向3y **/
		public function get p3s5y2():int {
			if (__info.hasOwnProperty("p3s5y2")) return __info["p3s5y2"];
			return 0;
		}
		/** [默认:0]技能5触发点2方向4x **/
		public function get p4s5x2():int {
			if (__info.hasOwnProperty("p4s5x2")) return __info["p4s5x2"];
			return 0;
		}
		/** [默认:0]技能5触发点2方向4y **/
		public function get p4s5y2():int {
			if (__info.hasOwnProperty("p4s5y2")) return __info["p4s5y2"];
			return 0;
		}
		/** [默认:0]技能5触发点2方向5x **/
		public function get p5s5x2():int {
			if (__info.hasOwnProperty("p5s5x2")) return __info["p5s5x2"];
			return 0;
		}
		/** [默认:0]技能5触发点2方向5y **/
		public function get p5s5y2():int {
			if (__info.hasOwnProperty("p5s5y2")) return __info["p5s5y2"];
			return 0;
		}
		/** [默认:0]技能5触发点2方向6x **/
		public function get p6s5x2():int {
			if (__info.hasOwnProperty("p6s5x2")) return __info["p6s5x2"];
			return 0;
		}
		/** [默认:0]技能5触发点2方向6y **/
		public function get p6s5y2():int {
			if (__info.hasOwnProperty("p6s5y2")) return __info["p6s5y2"];
			return 0;
		}
		/** [默认:0]技能5触发点2方向7x **/
		public function get p7s5x2():int {
			if (__info.hasOwnProperty("p7s5x2")) return __info["p7s5x2"];
			return 0;
		}
		/** [默认:0]技能5触发点2方向7y **/
		public function get p7s5y2():int {
			if (__info.hasOwnProperty("p7s5y2")) return __info["p7s5y2"];
			return 0;
		}
		/** [默认:0]技能5触发点2方向8x **/
		public function get p8s5x2():int {
			if (__info.hasOwnProperty("p8s5x2")) return __info["p8s5x2"];
			return 0;
		}
		/** [默认:0]技能5触发点2方向8y **/
		public function get p8s5y2():int {
			if (__info.hasOwnProperty("p8s5y2")) return __info["p8s5y2"];
			return 0;
		}
		/** [默认:0]技能5触发点2方向9x **/
		public function get p9s5x2():int {
			if (__info.hasOwnProperty("p9s5x2")) return __info["p9s5x2"];
			return 0;
		}
		/** [默认:0]技能5触发点2方向9y **/
		public function get p9s5y2():int {
			if (__info.hasOwnProperty("p9s5y2")) return __info["p9s5y2"];
			return 0;
		}
		//--------------------------------------------------------------------------------------
		/** 对象引用的数据对象 **/
		private var __info:Object;
		
		/**
		 * UpGame模型数据
		 * @param	baseInfo			传入null逻辑上会有错误
		 */
		public function UpGameModelInfo(baseInfo:Object):void
		{
			__info = baseInfo;
		}
		/**
		 * UpGame模型数据
		 * @param	baseInfo			传入null逻辑上会有错误
		 * @return
		 */
		public static function getThis(baseInfo:Object ):UpGameModelInfo
		{
			return new UpGameModelInfo(baseInfo);
		}
		
		/**
		 * 获取值,当缺少自动赋初始值
		 * @param	n
		 * @return
		 */
		private function __modelGet(n:String):*
		{
			if (__info.hasOwnProperty(n))
			{
				return __info[n];
			}
			return null;
		}
	}
}
