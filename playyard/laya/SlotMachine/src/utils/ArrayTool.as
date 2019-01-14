package utils
{
	public class ArrayTool
	{
		public static function disarrange(arr: Array): Array
		{
			var tmpArr: Array = arr.concat();
			var out: Array = [];
			var len: int = arr.length;
			for(var i: int = 0; i < len; i++) {
				var idx: int = Math.floor(Math.random() * (len - i));
				out[i] = tmpArr[idx];
				tmpArr.splice(idx, 1);
			}
			return out;
		}
	}
}