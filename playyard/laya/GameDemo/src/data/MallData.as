package data
{
	public class MallData
	{
		/**店铺名字*/
		public var name: String;
		/**商品列表，Vector.<XXX>也是一种数组，只不过Array里面的元素可以是各种类型的，而Vector则限制了只能是XXX类型
		 * 同时，从Vector中取出来的元素，编辑器知道是什么类型，所以可以直接.提示，而Array取出来的元素，编辑器只知道是
		 * Object(任意类型)，故无法提示各种属性*/
		public var items: Vector.<MallItemData>;
		
		public function MallData()
		{
		}
	}
}