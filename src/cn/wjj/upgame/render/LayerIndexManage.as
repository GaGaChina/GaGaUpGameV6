package cn.wjj.upgame.render 
{
	import cn.wjj.upgame.info.UpInfoStageInfo;
	import cn.wjj.upgame.UpGame;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	/**
	 * 图层的内容显示对象,层级管理器
	 * 需要把索引挂入图层,只有打开索引控制的图层才有作用
	 * 
	 * 二维数组存储索引内容[x][y] (放弃,我们有负数,我们不适合,我们要用正数,哈哈哈)
	 * 
	 * 算出横向的最大索引值
	 * 算出纵向最大索引值
	 * 个体索引等于取模+ 纵向* 横向最大索引值
	 * 以地图左上角为起点,创建索引值
	 * 每次创建索引值会全部重置
	 * <需要保证地图的尺寸不能变化>
	 * 
	 * 物品移除场景,不对其做索引处理
	 * 物品移除过来反向移除索引内容
	 * 
	 * 每个索引区域,有内容的数量,如果数量为0就over
	 * 每个索引区域,有所有的内容对象的映射(弱引用)
	 * 
	 * 
	 * dict = new Dictionary(true);
	 * dictlen = 1;  这个每次遍历维护,只会多,不会少
	 * 
	 * @author GaGa
	 */
	public class LayerIndexManage 
	{
		/** 驱动层 **/
		private var upGame:UpGame;
		private var stageInfo:UpInfoStageInfo;
		private var grid:Vector.<Object>;
		
		/** X的最大坐标 **/
		private var minX:Number;
		private var minY:Number;
		private var maxX:Number;
		private var maxY:Number;
		
		/** 区域内索引划分的尺寸 **/
		private var minWidth:uint = 200;
		/** 区域内索引的划分尺寸 **/
		private var minHeight:uint = 200;
		/** 横向有多少内容 **/
		private var xNum:int = 0;
		
		public function LayerIndexManage(upGame:UpGame) 
		{
			stageInfo = upGame.info.stageInfo;
			minX = stageInfo.x;
			minY = stageInfo.y;
			maxX = minX + stageInfo.width;
			maxY = minY + stageInfo.height;
		}
		
		/** 创建索引 **/
		public function createIndex(minWidth:uint = 200, minHeight:uint = 200):void
		{
			this.minWidth = minWidth;
			this.minHeight = minHeight;
			if (stageInfo.width % this.minWidth == 0)
			{
				xNum = stageInfo.width / this.minWidth;
			}
			else
			{
				xNum = Math.ceil(stageInfo.width / this.minWidth);
			}
			var yNum:int = 0;
			if (stageInfo.height % this.minHeight == 0)
			{
				yNum = stageInfo.height / this.minHeight;
			}
			else
			{
				yNum = Math.ceil(stageInfo.height / this.minHeight);
			}
			grid = new Vector.<Object>(xNum * yNum);
			var item:Object;
			for (var i:int = 0; i < xNum; i++) 
			{
				for (var j:int = 0; j < yNum; j++) 
				{
					item = new Object();
					item["dict"] = new Dictionary(true);
					item["dictlen"] = 0;
					grid.push(item);
				}
			}
		}
		
		public function reSetIndex(display:DisplayObject):void
		{
			/** 旧的索引区域 **/
			var oldIndex:int = 0;

			var x:Number = display.x;
			var y:Number = display.y;
			if (x < minX || x > maxX || y < minY || y > maxY)
			{
				
				//没有在区域内
				//如果自身有区域,就删除掉
				
			}
			else
			{
				x = (display.x - stageInfo.x) / minWidth
				y = (display.y - stageInfo.y) / minHeight * xNum;
				var obj:Object = grid[x + y];
				
				
				
				//查看有没有在区域
				//开始有区域,非现在区域就移除
			}
		}
		
	}

}