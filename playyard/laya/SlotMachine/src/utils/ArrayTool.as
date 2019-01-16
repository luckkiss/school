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
		
		public static function pickOnNotIn(from: Array, notIn: Array, cnt: int): Array {
			var tmpArr: Array = [];
			for each(var elem: * in from) {
				if(notIn.indexOf(elem) < 0 && (Root.data.isGuest || (Root.data.stList.indexOf(elem) < 0 && (Root.data.bossList.indexOf(elem) < 0 || Root.data.bossLuckyCnt < Root.data.bossLuckyMaxCnt)))) {
					tmpArr.push(elem);
				}
			}
			
			tmpArr = disarrange(tmpArr);
			tmpArr.length = cnt;
			return tmpArr;
		}
	}
}