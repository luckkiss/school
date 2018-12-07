package {
	import animals.BlackHorse;
	import animals.Horse;
	import animals.WhiteHorse;
	
	import laya.webgl.WebGL;

	public class Root {
		
		private var myAnimals: Array = [];
		public function Root() {
			//初始化引擎
			Laya.init(1136, 640,WebGL);
			
			console.log('welcome to our zoo!');
			
			// 2只马
			var whiteHorse: WhiteHorse = new WhiteHorse();
			// 给第1只马起名字
			whiteHorse.name = 'Jimmy';
			// 将马添加到舞台上
			Laya.stage.addChild(whiteHorse);
			
			var blakeHorse: BlackHorse = new BlackHorse();
			// 给第2只马起名字
			blakeHorse.name = 'Jerry';
			// 将马添加到舞台上
			Laya.stage.addChild(blakeHorse);
			
			this.myAnimals.push(whiteHorse, blakeHorse);
			
			// 2只马都在闲逛
			for(var i: int = 0; i < this.myAnimals.length; i++) {
				var tmpHorse: Horse = this.myAnimals[i];
				tmpHorse.idle();
			}
		}		
	}
}