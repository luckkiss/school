package data
{
	public class StoreData
	{
		/**所有商品配置的一个数组*/
		public var itemCfgs: Vector.<ItemCfg>;
		/**商品配置映射表，Object为{id: ItemCfg}的键值对，方便通过id来查询商品信息*/
		private var itemCfgMap: Object = {};
		
		/**所有品类配置的一个数组*/
		public var classCfgs: Vector.<ClassCfg>;
		/**品类配置映射表，Object为{id: ClassCfg}的键值对，方便通过id来查询品类信息*/
		private var classCfgMap: Object = {};
		
		/**所有商店配置的一个数组*/
		public var storeCfgs: Vector.<StoreCfg>;
		/**商店配置映射表，Object为{id: StoreCfg}的键值对，方便通过id来查询商店信息*/
		private var storeCfgMap: Object = {};
		
		public function StoreData()
		{
		}
		
		public function init(itemJson: Object, globalJson: Object, storeJson: Object): void {
			
			// 处理ItemCfg配置数据
			// item.json里面本来就是一个数组
			var itemCfgs: Vector.<ItemCfg> = itemJson as Vector.<ItemCfg>;
			for(var i: int = 0; i < itemCfgs.length; i++) {
				var itemCfg: ItemCfg = itemCfgs[i];
				// 使用ItemCfg的id作为key，其对于的Value为ItemCfg
				this.itemCfgMap[itemCfg.id] = itemCfg;
			}
			
			// 处理ClassCfg配置数据
			// Vector.<ClassCfg>表示这个数组元素的类型为ClassInfo
			var classCfgs: Vector.<ClassCfg> = globalJson.classes;
			// 以下演示了一个var关键字可以同时声明多个变量的写法
			// var后面同时声明了i和len两个变量，这么做的目的是提前取出
			// classCfgs.length的值，避免在循环过程中多次访问，可以提高性能
			for(var i: int = 0, len: int = classCfgs.length; i < len; i++) {
				var classCfg: ClassCfg = classCfgs[i];
				// 使用ClassCfg的id作为key，其对于的Value为ClassCfg
				this.classCfgMap[classCfg.id] = classCfg;
			}
			
			// 处理StoreCfg配置数据
			// store.json里面本来就是一个数组
			this.storeCfgs = storeJson as Vector.<StoreCfg>;
			for(var i: int = 0, len: int = this.storeCfgs.length; i < len; i++) {
				var storeCfg: StoreCfg = this.storeCfgs[i];
				// 使用StoreCfg的id作为key，其对于的Value为StoreCfg
				this.storeCfgMap[itemCfg.id] = storeCfg;
			}
		}
		
		/**通过id获取对应的ItemCfg*/
		public function getItemCfgById(id: String): ItemCfg {
			return this.itemCfgMap[id];
		}
		
		/**通过id获取对应的ClassCfg*/
		public function getClassCfgById(id: int): ClassCfg {
			return this.classCfgMap[id];
		}
		
		/**通过id获取对应的StoreCfg*/
		public function getStoreCfgById(id: String): StoreCfg {
			return this.storeCfgMap[id];
		}
	}
}