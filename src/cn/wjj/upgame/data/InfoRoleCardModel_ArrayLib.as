package cn.wjj.upgame.data
{
	import cn.wjj.g;
	import cn.wjj.data.ObjectPointer;
	import cn.wjj.tool.VectorObjectUtil;
	import cn.wjj.data.ObjectAction;
	
	/**
	 * InfoRoleCardModel数组列表辅助类型
	 */
	public class InfoRoleCardModel_ArrayLib
	{
		/** 对象引用的数据对象Array **/
		private var __info:Array;
		/** AllData的在框架g.bridge.getObjByName引用的名称 **/
		private var __allDataBridgeName:String;
		/** 这个对象在allData上的引用位置 **/
		private var __thisGroupName:String;
		
		/**
		 * InfoRoleCardModel数组列表辅助类型
		 * @param	baseInfo			传入null并且thisGroupName=""的时候,生成一个new Object()
		 * @param	allDataBridgeName	全部数据在框架g.bridge.getObjByName引用的名称,默认allData
		 * @param	thisGroupName		这个数据在全部数据集合上的引用位置(设置后将自动弃用baseInfo,而是从位置里获取内容)
		 * @return
		 */
		public function InfoRoleCardModel_ArrayLib(baseInfo:Array = null, allDataBridgeName:String = "allInfo", thisGroupName:String = ""):void {
			__allDataBridgeName = allDataBridgeName;
			if (baseInfo && allDataBridgeName && thisGroupName) {
				ObjectAction.setGroupVar(g.bridge.getObjByName(allDataBridgeName), thisGroupName, baseInfo);
			}
			if (!baseInfo && !thisGroupName) {
				setArray(null);
				return;
			}
			if (allDataBridgeName && thisGroupName) {
				setGroupInfo(allDataBridgeName, thisGroupName);
			}else {
				setArray(baseInfo);
			}
		}
		
		/**
		 * InfoRoleCardModel数组列表辅助类型
		 * @param	baseInfo			传入null并且thisGroupName=""的时候,生成一个new Object()
		 * @param	allDataBridgeName	全部数据在框架g.bridge.getObjByName引用的名称,默认allData
		 * @param	thisGroupName		这个数据在全部数据集合上的引用位置(设置后将自动弃用baseInfo,而是从位置里获取内容)
		 * @return
		 */
		public static function getThis(baseInfo:Array = null, allDataBridgeName:String = "allInfo", thisGroupName:String = ""):InfoRoleCardModel_ArrayLib
		{
			return new InfoRoleCardModel_ArrayLib(baseInfo, allDataBridgeName, thisGroupName);
		}
		
		/** 获取值,当缺少自动赋初始值 **/
		private function __autoLoaderInfo():void {
			if (__allDataBridgeName && __thisGroupName) {
				__info = ObjectAction.getGroupVar(g.bridge.getObjByName(__allDataBridgeName), __thisGroupName);
			}
		}
		
		/**
		 * 设置对象在一个数据集合中的位置,并且获取这个对象数据,写入这个对象里
		 * @param	allDataBridgeName		全部数据在框架g.bridge.getObjByName引用的名称,默认allData
		 * @param	thisGroupName			这个数据在全部数据集合上的引用位置(设置后自动覆盖这里的数据对象)
		 */
		public function setGroupInfo(allDataBridgeName:String = "allInfo", thisGroupName:String = ""):InfoRoleCardModel_ArrayLib {
			__allDataBridgeName = allDataBridgeName;
			__thisGroupName = thisGroupName;
			if (allDataBridgeName && thisGroupName) {
				__info = ObjectAction.getGroupVar(g.bridge.getObjByName(allDataBridgeName), thisGroupName);
			}
			createPointer();
			return this;
		}
		
		/** 获取数据模型引用的对象 **/
		public function getArray():Array {
			return __info;
		}
		
		/**
		 * 设置这个对象引用的数据对象
		 * @param	baseInfo	当传入null的时候,自动生成一个new Object()
		 * @return
		 */
		public function setArray(baseInfo:Array = null):InfoRoleCardModel_ArrayLib {
			if (baseInfo == null) {
				baseInfo = new Array();
			}
			__info = baseInfo;
			createPointer();
			return this;
		}
		
		//----------------------------------------------------------------------------------------------------
		/** 添加一个对象 **/
		public function addItem(item:InfoRoleCardModel):void {
			createPointer();
			__info.push(item.getObject());
		}
		
		/**
		 * 获取这个库里全部的数据列表
		 * @return
		 */
		public function getAll():Vector.<InfoRoleCardModel> {
			var lib:Vector.<InfoRoleCardModel> = new Vector.<InfoRoleCardModel>();
			var item:Object;
			for each (item in __info){
				lib.push(InfoRoleCardModel.getThis(item));
			}
			return lib;
		}
		
		/**
		 * 获取这个库里全部的数据列表
		 * @return
		 */
		public function delAll():Vector.<InfoRoleCardModel> {
			var lib:Vector.<InfoRoleCardModel> = getAll();
			__info.length = 0;
			createPointer();
			return lib;
		}
		
		/**
		 * 从数组列表中查询子对象的属性名为p的值为vars,关系为equal的对象,返回第一个查到的对象,没有返回null
		 * @param	p		属性的名称
		 * @param	vars	值
		 * @param	equal	关系 : == != > < >= <= === !==
		 * @return
		 */
		public function delItem(p:String, vars:*, equal:String = "==", isRunEvent:Boolean = false):InfoRoleCardModel {
			var item:Object = getItemObj(p, vars, equal);
			if(item) {
				var id:int = __info.indexOf(item);
				if (id != -1) {
					__info.splice(id, 1);
					createPointer();
					if (isRunEvent) {
						g.event.runEventData(g.bridge.getObjByName(__allDataBridgeName));
					}
					return new InfoRoleCardModel(item);
				}
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
		public function delList(p:String, vars:*, equal:String = "==", isRunEvent:Boolean = false):Vector.<InfoRoleCardModel> {
			var list:Vector.<InfoRoleCardModel> = getList(p, vars, equal);
			var del:Vector.<InfoRoleCardModel> = new Vector.<InfoRoleCardModel>();
			var id:int;
			for each (var item:InfoRoleCardModel in list) 
			{
				id = __info.indexOf(item.getObject());
				if (id != -1) {
					__info.splice(id, 1);
					if (isRunEvent) {
						g.event.runEventData(g.bridge.getObjByName(__allDataBridgeName));
					}
					del.push(item);
				}
			}
			if (del.length) {
				createPointer();
				if (isRunEvent) {
					g.event.runEventData(g.bridge.getObjByName(__allDataBridgeName));
				}
			}
			return del;
		}
		
		/**
		 * 从数组列表中查询子对象的属性名为p的值为vars,关系为equal的对象,返回第一个查到的对象,没有返回null
		 * @param	p		属性的名称
		 * @param	vars	值
		 * @param	equal	关系 : == != > < >= <= === !==
		 * @return
		 */
		public function getItemObj(p:String, vars:*, equal:String = "=="):Object{
			__autoLoaderInfo();	
			if(equal == "==" && InfoRoleCardModel.__keyList.indexOf(p) != -1)
			{
				return ObjectPointer.getArrayItem(__info, p, vars);
			}
			var item:Object;
			var isD:Boolean = false;
			switch (equal) {
				case "==":
					if (InfoRoleCardModel.defaultObject[p] == vars) isD = true;
					break;
				case "!=":
					if (InfoRoleCardModel.defaultObject[p] != vars) isD = true;
					break;
				case ">":
					if (InfoRoleCardModel.defaultObject[p] > vars) isD = true;
					break;
				case "<":
					if (InfoRoleCardModel.defaultObject[p] < vars) isD = true;
					break;
				case ">=":
					if (InfoRoleCardModel.defaultObject[p] >= vars) isD = true;
					break;
				case "<=":
					if (InfoRoleCardModel.defaultObject[p] <= vars) isD = true;
					break;
				case "===":
					if (InfoRoleCardModel.defaultObject[p] === vars) isD = true;
					break;
				case "!==":
					if (InfoRoleCardModel.defaultObject[p] === vars) isD = true;
					break;
			}
			switch (equal) {
				case "==":
					for each (item in __info) {
						if (item.hasOwnProperty(p))
						{
							if (item[p] == vars) return item;
						}
						else if (isD)
						{
							return item;
						}
					}
					break;
				case "!=":
					for each (item in __info){
						if (item.hasOwnProperty(p))
						{
							if (item[p] != vars) return item;
						}
						else if (isD)
						{
							return item;
						}
					}
					break;
				case ">":
					for each (item in __info){
						if (item.hasOwnProperty(p))
						{
							if (item[p] > vars) return item;
						}
						else if (isD)
						{
							return item;
						}
					}
					break;
				case "<":
					for each (item in __info){
						if (item.hasOwnProperty(p))
						{
							if (item[p] < vars) return item;
						}
						else if (isD)
						{
							return item;
						}
					}
					break;
				case ">=":
					for each (item in __info){
						if (item.hasOwnProperty(p))
						{
							if (item[p] >= vars) return item;
						}
						else if (isD)
						{
							return item;
						}
					}
					break;
				case "<=":
					for each (item in __info){
						if (item.hasOwnProperty(p))
						{
							if (item[p] <= vars) return item;
						}
						else if (isD)
						{
							return item;
						}
					}
					break;
				case "===":
					for each (item in __info){
						if (item.hasOwnProperty(p))
						{
							if (item[p] === vars) return item;
						}
						else if (isD)
						{
							return item;
						}
					}
					break;
				case "!==":
					for each (item in __info){
						if (item.hasOwnProperty(p))
						{
							if (item[p] !== vars) return item;
						}
						else if (isD)
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
		public function getItem(p:String, vars:*, equal:String = "=="):InfoRoleCardModel{
			var item:Object = getItemObj(p, vars, equal);
			if (item) return new InfoRoleCardModel(item);
			return null;
		}
		
		/**
		 * 从数组列表中查询子对象的属性名为p的值为vars,关系为equal的对象,返回Vector.<InfoRoleCardModel>查到的对象,没有返回null
		 * @param	p		属性的名称
		 * @param	vars	值
		 * @param	equal	关系 : == != > < >= <= === !==
		 * @return
		 */
		public function getListObj(p:String, vars:*, equal:String = "=="):Vector.<Object> {
			__autoLoaderInfo();	
			if(equal == "==" && InfoRoleCardModel.__keyList.indexOf(p) != -1)
			{
				return ObjectPointer.getArrayList(__info, p, vars);
			}
			var item:Object;
			var lib:Vector.<Object> = new Vector.<Object>();
			var isD:Boolean = false;
			switch (equal) {
				case "==":
					if (InfoRoleCardModel.defaultObject[p] == vars) isD = true;
					break;
				case "!=":
					if (InfoRoleCardModel.defaultObject[p] != vars) isD = true;
					break;
				case ">":
					if (InfoRoleCardModel.defaultObject[p] > vars) isD = true;
					break;
				case "<":
					if (InfoRoleCardModel.defaultObject[p] < vars) isD = true;
					break;
				case ">=":
					if (InfoRoleCardModel.defaultObject[p] >= vars) isD = true;
					break;
				case "<=":
					if (InfoRoleCardModel.defaultObject[p] <= vars) isD = true;
					break;
				case "===":
					if (InfoRoleCardModel.defaultObject[p] === vars) isD = true;
					break;
				case "!==":
					if (InfoRoleCardModel.defaultObject[p] === vars) isD = true;
					break;
			}
			switch (equal) 
			{
				case "==":
					for each (item in __info) {
						if (item.hasOwnProperty(p))
						{
							if (item[p] == vars) lib.push(item);
						}
						else if (isD)
						{
							lib.push(item);
						}
					}
					break;
				case "!=":
					for each (item in __info){
						if (item.hasOwnProperty(p))
						{
							if (item[p] != vars) lib.push(item);
						}
						else if (isD)
						{
							lib.push(item);
						}
					}
					break;
				case ">":
					for each (item in __info){
						if (item.hasOwnProperty(p))
						{
							if (item[p] > vars) lib.push(item);
						}
						else if (isD)
						{
							lib.push(item);
						}
					}
					break;
				case "<":
					for each (item in __info){
						if (item.hasOwnProperty(p))
						{
							if (item[p] < vars) lib.push(item);
						}
						else if (isD)
						{
							lib.push(item);
						}
					}
					break;
				case ">=":
					for each (item in __info){
						if (item.hasOwnProperty(p))
						{
							if (item[p] >= vars) lib.push(item);
						}
						else if (isD)
						{
							lib.push(item);
						}
					}
					break;
				case "<=":
					for each (item in __info){
						if (item.hasOwnProperty(p))
						{
							if (item[p] <= vars) lib.push(item);
						}
						else if (isD)
						{
							lib.push(item);
						}
					}
					break;
				case "===":
					for each (item in __info){
						if (item.hasOwnProperty(p))
						{
							if (item[p] === vars) lib.push(item);
						}
						else if (isD)
						{
							lib.push(item);
						}
					}
					break;
				case "!==":
					for each (item in __info){
						if (item.hasOwnProperty(p))
						{
							if (item[p] !== vars) lib.push(item);
						}
						else if (isD)
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
		 * 从数组列表中查询子对象的属性名为p的值为vars,关系为equal的对象,返回Vector.<InfoRoleCardModel>查到的对象,没有返回null
		 * @param	p		属性的名称
		 * @param	vars	值
		 * @param	equal	关系 : == != > < >= <= === !==
		 * @return
		 */
		public function getList(p:String, vars:*, equal:String = "=="):Vector.<InfoRoleCardModel> {
			__autoLoaderInfo();	
			var lib:Vector.<InfoRoleCardModel> = new Vector.<InfoRoleCardModel>();
			var libO:Vector.<Object> = getListObj(p, vars, equal);
			for each (var item:Object in libO) 
			{
				lib.push(new InfoRoleCardModel(item));
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
		private function __getInfo(progArr:Array, vars:Array, equal:Array, useAdd:Array):Vector.<InfoRoleCardModel>
		{
			__autoLoaderInfo();
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
			var lib:Vector.<InfoRoleCardModel> = new Vector.<InfoRoleCardModel>();
			for each (item in libO){
				lib.push(new InfoRoleCardModel(item));
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
		public function getItemArr(progArr:Array, vars:Array, equal:Array, useAdd:Array):InfoRoleCardModel{
			var lib:Vector.<InfoRoleCardModel> = __getInfo(progArr, vars, equal, useAdd);
			for each (var item:InfoRoleCardModel in lib){
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
		public function getListArr(progArr:Array, vars:Array, equal:Array, useAdd:Array):Vector.<InfoRoleCardModel>{
			return __getInfo(progArr, vars, equal, useAdd);
		}
		 
		 /** 重建索引,操作子对象索引值的时候手动调用 **/
		public function createPointer():void {
			if(InfoRoleCardModel.__keyList.length > 0)
			{
				ObjectPointer.createArrayKeyList(__info, InfoRoleCardModel.__keyList);
			}
		}
	}
}
