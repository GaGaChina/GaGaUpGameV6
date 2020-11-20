package cn.wjj.upgame.data
{
	import cn.wjj.data.ObjectPointer;
	import cn.wjj.tool.VectorObjectUtil;
	/**
	 * RoleCardModel数组列表辅助类型
	 */
	public class RoleCardModel_ArrayLib
	{
		/** 对象引用的数据对象Array **/
		private var __info:Array;
		
		/**
		 * RoleCardModel数组列表辅助类型
		 * @param	baseInfo			传入null并且thisGroupName=""的时候,生成一个new Object()
		 */
		public function RoleCardModel_ArrayLib(baseInfo:Array):void {
			__info = baseInfo;
			if(!ObjectPointer.hasArray(__info) && RoleCardModel.__keyList.length > 0)
			{
				ObjectPointer.createArrayKeyList(__info, RoleCardModel.__keyList);
			}
		}
		
		/**
		 * RoleCardModel数组列表辅助类型
		 * @param	baseInfo			传入null并且thisGroupName=""的时候,生成一个new Object()
		 * @return
		 */
		public static function getThis(baseInfo:Array):RoleCardModel_ArrayLib
		{
			return new RoleCardModel_ArrayLib(baseInfo);
		}
		
		/** 获取数据模型引用的对象 **/
		public function getArray():Array {
			return __info;
		}
		
		/**
		 * 获取这个库里全部的数据列表
		 * @return
		 */
		public function getAll():Vector.<RoleCardModel> {
			var lib:Vector.<RoleCardModel> = new Vector.<RoleCardModel>();
			var item:Object;
			for each (item in __info){
				lib.push(new RoleCardModel(item));
			}
			return lib;
		}
		
		/**
		 * 从数组列表中查询子对象的属性名为p的值为vars,关系为equal的对象,返回第一个查到的对象,没有返回null
		 * @param	p		属性的名称
		 * @param	vars	值
		 * @param	equal	关系 : == != > < >= <= === !==
		 * @return
		 */
		public function getItemObj(p:String, vars:*, equal:String = "=="):Object{
			if(__info == null)return null;	
			if(equal == "==" && RoleCardModel.__keyList.indexOf(p) != -1)
			{
				return ObjectPointer.getArrayItem(__info, p, vars);
			}
			var item:Object;
			switch (equal) {
				case "==":
					for each (item in __info) {
						if (item.hasOwnProperty(p) && item[p] == vars)
						{
							return item;
						}
					}
					break;
				case "!=":
					for each (item in __info){
						if (item.hasOwnProperty(p) && item[p] != vars)
						{
							return item;
						}
					}
					break;
				case ">":
					for each (item in __info){
						if (item.hasOwnProperty(p) && item[p] > vars)
						{
							return item;
						}
					}
					break;
				case "<":
					for each (item in __info){
						if (item.hasOwnProperty(p) && item[p] < vars)
						{
							return item;
						}
					}
					break;
				case ">=":
					for each (item in __info){
						if (item.hasOwnProperty(p) && item[p] >= vars)
						{
							return item;
						}
					}
					break;
				case "<=":
					for each (item in __info){
						if (item.hasOwnProperty(p) && item[p] <= vars)
						{
							return item;
						}
					}
					break;
				case "===":
					for each (item in __info){
						if (item.hasOwnProperty(p) && item[p] === vars)
						{
							return item;
						}
					}
					break;
				case "!==":
					for each (item in __info){
						if (item.hasOwnProperty(p) && item[p] !== vars)
						{
							return item;
						}
					}
					break;
				default:
			}
			return null;
		}
		
		/**
		 * 从数组列表中查询子对象的属性名为p的值为vars,关系为equal的对象,返回第一个查到的对象,没有返回null
		 * @param	p		属性的名称
		 * @param	vars	值
		 * @param	equal	关系 : == != > < >= <= === !==
		 * @return
		 */
		public function getItem(p:String, vars:*, equal:String = "=="):RoleCardModel{
			var item:Object = getItemObj(p, vars, equal);
			if (item) return new RoleCardModel(item);
			return null;
		}
		
		/**
		 * 从数组列表中查询子对象的属性名为p的值为vars,关系为equal的对象,返回Vector.<RoleCardModel>查到的对象,没有返回null
		 * @param	p	属性的名称
		 * @param	vars			值
		 * @param	equal			关系 : == != > < >= <= === !==
		 * @return
		 */
		public function getListObj(p:String, vars:*, equal:String = "=="):Vector.<Object> {
			var lib:Vector.<Object> = new Vector.<Object>();
			if(__info == null)return lib;
			var item:Object;
			if(equal == "==" && RoleCardModel.__keyList.indexOf(p) != -1)
			{
				return ObjectPointer.getArrayList(__info, p, vars);
			}
			switch (equal) 
			{
				case "==":
					for each (item in __info) {
						if (item.hasOwnProperty(p) && item[p] == vars)
						{
							lib.push(item);
						}
					}
					break;
				case "!=":
					for each (item in __info){
						if (item.hasOwnProperty(p) && item[p] != vars)
						{
							lib.push(item);
						}
					}
					break;
				case ">":
					for each (item in __info){
						if (item.hasOwnProperty(p) && item[p] > vars)
						{
							lib.push(item);
						}
					}
					break;
				case "<":
					for each (item in __info){
						if (item.hasOwnProperty(p) && item[p] < vars)
						{
							lib.push(item);
						}
					}
					break;
				case ">=":
					for each (item in __info){
						if (item.hasOwnProperty(p) && item[p] >= vars)
						{
							lib.push(item);
						}
					}
					break;
				case "<=":
					for each (item in __info){
						if (item.hasOwnProperty(p) && item[p] <= vars)
						{
							lib.push(item);
						}
					}
					break;
				case "===":
					for each (item in __info){
						if (item.hasOwnProperty(p) && item[p] === vars)
						{
							lib.push(item);
						}
					}
					break;
				case "!==":
					for each (item in __info){
						if (item.hasOwnProperty(p) && item[p] !== vars)
						{
							lib.push(item);
						}
					}
					break;
				default:
			}
			return lib;
		}
		
		/**
		 * 从数组列表中查询子对象的属性名为p的值为vars,关系为equal的对象,返回Vector.<RoleCardModel>查到的对象,没有返回null
		 * @param	p	属性的名称
		 * @param	vars			值
		 * @param	equal			关系 : == != > < >= <= === !==
		 * @return
		 */
		public function getList(p:String, vars:*, equal:String = "=="):Vector.<RoleCardModel> {
			var lib:Vector.<RoleCardModel> = new Vector.<RoleCardModel>();
			var libO:Vector.<Object> = getListObj(p, vars, equal);
			for each (var item:Object in libO) 
			{
				lib.push(new RoleCardModel(item));
			}
			return lib;
		}
		
		/**
		 * 多项匹配,比如__getInfo([name,id,email],[gaga,1,1@gamil.com],["==","!=","==","!="],[false,false,false,false])
		 * @param	progArr		数据
		 * @param	vars		值
		 * @param	equal		关系 : == != > < >= <= === !==
		 * @param	useAdd		对应编号的条件是要同其他条件一起触发[true],还是只要本条件触发就出现在结果中[false]
		 * @return
		 */
		private function __getInfo(progArr:Array, vars:Array, equal:Array, useAdd:Array):Vector.<RoleCardModel>
		{
			var lib:Vector.<RoleCardModel> = new Vector.<RoleCardModel>();
			if(__info == null)return lib;	
			var item:Object;
			var l:int = progArr.length;
			var libO:Vector.<Object>, temp:Vector.<Object>;
			for (var i:int = 0; i < l; i++) {
				temp = getListObj(progArr[i], vars[i], equal[i]);
				if (libO == null) {
					libO = temp;
				}else {
					if (useAdd[i]) {
						libO = VectorObjectUtil.createShare(libO, temp);
					}else {
						for each (item in temp) {
							libO.push(item);
						}
					}
				}
			}
			libO = VectorObjectUtil.createUniqueCopy(libO)
			for each (item in libO){
				lib.push(new RoleCardModel(item));
			}
			return lib;
		}
		
		/**
		 * 多项匹配,比如__getInfo([name,id,email],[gaga,1,1@gamil.com],["==","!=","==","!="],[false,false,false,false])
		 * @param	progArr		数据
		 * @param	vars		值
		 * @param	equal		关系 : == != > < >= <= === !==
		 * @param	useAdd		对应编号的条件是要同其他条件一起触发[true],还是只要本条件触发就出现在结果中[false]
		 * @return
		 */
		public function getItemArr(progArr:Array, vars:Array, equal:Array, useAdd:Array):RoleCardModel{
			var lib:Vector.<RoleCardModel> = __getInfo(progArr, vars, equal, useAdd);
			for each (var item:RoleCardModel in lib){
				return item;
			}
			return null;
		}
		
		/**
		 * 多项匹配,比如__getInfo([name,id,email],[gaga,1,1@gamil.com],["==","!=","==","!="],[false,false,false,false])
		 * @param	progArr		数据
		 * @param	vars		值
		 * @param	equal		关系 : == != > < >= <= === !==
		 * @param	useAdd		对应编号的条件是要同其他条件一起触发[true],还是只要本条件触发就出现在结果中[false]
		 * @return
		 */
		public function getListArr(progArr:Array, vars:Array, equal:Array, useAdd:Array):Vector.<RoleCardModel>{
			return __getInfo(progArr, vars, equal, useAdd);
		}
	}
}
