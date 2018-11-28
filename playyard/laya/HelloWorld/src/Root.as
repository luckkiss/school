package {
	import laya.webgl.WebGL;
	
	/**根*/
	public class Root {
		private var myInt: int = 0;
		private var myArr: Array = [1, 2, 3, 4];
		public function Root() {
			//初始化引擎
			Laya.init(750, 1334,WebGL);
			
			// 阅读以下代码，运行查看控制台输出
			
			var a: int = this.myArr[0];
			var b: int = this.myArr[1];
			var c: int = a + b;
			console.log('a = ' + a);
			console.log('b = ' + b);
			console.log('c = ' + c);
			
			console.log(this.myArr);
			this.myArr.push(c);
			console.log(this.myArr);
		}
		
		private function testArray(): void {
			// 以下展示声明数组的两种方式
			var arr1: Array = []; // 一个空的数组
			var arr2: Array = new Array();  // 一个空的数组
			
			console.log(arr1);
			
			// 向数组尾部压入新元素
			arr1.push(1);
			console.log(arr1);
			
			// 可以同时压入多个元素
			arr1.push(2, 3);
			console.log(arr1);
			console.log(arr1);
			
			// 查看数组的长度
			var len: int = arr1.length;
			console.log('len = ' + len);
			
			// 通过下标访问数组元素
			console.log('arr1的第一个元素为' + arr1[0]);
			console.log('arr1的最后一个元素为' + arr1[len - 1]);
			
			// 向数组头部压入新元素
			arr1.unshift(0);
			console.log(arr1);
			
			// 从数组尾部取出1个元素
			var e1: int = arr1.pop();
			console.log('e1 = ' + e1);
			console.log(arr1);
			
			// 从数组头部取出1个元素
			var e2: int = arr1.shift();
			console.log('e2 = ' + e2);
			
			var arr3: Array = ['a', 'b', 'c'];
			var arr4: Array = ['a', 'b', 'c'];
			console.log(arr3);
			console.log(arr4);
			
			// 只有数字、字符串、布尔值等简单数据类型才能直接比较
			if(arr3 == arr4) {
				console.log('arr3和arr4相等');
			} 
			else {
				console.log('arr3和arr4不相等');
			}
			
			// 数组的元素为简单类型 -- 数字，可以进行比较
			if(arr3[0] == arr4[0]) {
				console.log('arr3的第一个元素和arr4的第一个元素相等');
			} 
			else {
				console.log('arr3的第一个元素和arr4的第一个元素不相等');
			}
		}
	}
}