﻿package {
	import laya.webgl.WebGL;
	
	import view.MainView;
	
	/**根*/
	public class Root {
		private var myInt: int = 0;
		private var myArr: Array = [1, 2, 3, 4];
		public function Root() {
			//初始化引擎
			Laya.init(750, 1334,WebGL);
			
			this.testArray();
		}
		
		private function testArray(): void {
			// 以下展示声明数组的2种方式
			var arr1: Array = []; // 一个空的数组
			var arr2: Array = new Array();  // 一个空的数组
			
			console.log(arr1);
			
			// 向数组尾部压入新元素
			arr1.push(1);
			console.log('压入一个新元素后：');
			console.log(arr1);
			
			// 可以同时压入多个元素
			arr1.push(2, 3);
			console.log('压入多个新元素后：');
			console.log(arr1);
			
			// 查看数组的长度
			var len: int = arr1.length;
			console.log('数组长度len = ' + len);
			
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
		
		private function testObject(): void {
			// 以下展示声明Object的4种方式
			var obj1: Object = {};
			var obj2: Object = new Object();
			var obj3: * = {};
			var obj4: * = new Object();
			
			// 下面展示Object的初始化方式
			// 方式一： 通过json格式初始化
			var obj5: Object = {'secondName': 'Fullen', 'firstName': 'Cai'};
			console.log(obj5);
			
			// 方式二：通过.进行访问设置
			var obj6: Object = {};
			obj6.secondName = 'Fullen';
			obj6.firstName = 'Cai';
			console.log(obj5);
			
			// 方式三：通过[]进行访问设置
			var obj7: Object = {};
			obj7['secondName'] = 'Fullen';
			obj7['firstName'] = 'Cai';
			console.log(obj5);
			
			// 再来看一下下面这个Object
			var objLikeArr: Object = {'0': 0, '1': 1, '2': 2};
			console.log(objLikeArr);
			// 访问key为0所对应的value
			console.log('key = 0, value = ' + objLikeArr['0']);
			// 访问key为0所对应的value的另一种方式
			console.log('key = 0, value = ' + objLikeArr[0]);
			
			// 看看下面这个数组
			var arr: Array = [0, 1, 2];
			console.log(arr);
			console.log('下标为0的元素为' + arr[0]);
			
			// 在此，是否发现数组和Object很相似，实际上，数组就是一种特殊的Object，只不过其
			// key全部都是连续的数字而已
			// 实际上，Object类是所有类型的基类，也就是说，其他任何的类型，都可以看做是Object
			// 衍生出来的类型，所以Object是最基本的类型
			
			// 如下，MainView这个类也可以作为Object看待
			var mainViewAsObject: Object = new MainView();
			
		}
		
		private function testString(): void {
			// 以下展示String的一些用法
			var str: String = 'abcdefg';
			
			// 获取String的长度
			var strLen: int = str.length;
			console.log(str + '的长度为' + strLen);
			
			// 获取String的某个字符，和数组一样，字符的索引从0开始
			var charOfStr0: String = str.charAt(0);
			var charOfStr2: String = str.charAt(2);
			console.log('第0个字符为' + charOfStr0);
			console.log('第2个字符为' + charOfStr2);
			
			// 截取某段字符串
			// 第一种方式，是指定从第几个字符开始，截取几个字符
			var partOfStr1: String = str.substr(1, 3);
			console.log(partOfStr1);
			
			// 第一种方式，是指定从第几个字符开始，一直到哪个字符之前，全部都截取出来
			// 可以看出来这两种方式的结果是一样的
			var partOfStr2: String = str.substring(1, 3);
			console.log(partOfStr2);
			
			// 所有方法，假如其参数列表中有默认值，就可以省略
			// 猜猜以下两种用法和上面两种有什么区别
			var partOfStr3: String = str.substr(1);
			var partOfStr4: String = str.substring(1);
			
			// 查找字符串是否包含某些字符
			var toFind1: String = 'de'
			var idx1: int = str.indexOf(toFind1);
			if(idx1 >= 0) {
				console.log(toFind1 + '位于字符串的第' + idx1 + '位');
			} else {
				console.log('字符串不包含' + toFind1);
			}
			
			var toFind2: String = 'df'
			var idx2: int = str.indexOf(toFind2);
			if(idx2 >= 0) {
				console.log(toFind2 + '位于字符串的第' + idx2 + '位');
			} else {
				console.log('字符串不包含' + toFind2);
			}
		}
	}
}