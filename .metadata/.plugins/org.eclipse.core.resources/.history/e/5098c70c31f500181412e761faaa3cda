package {
	import animals.Horse;
	
	import laya.webgl.WebGL;

	public class Root {
		
		private var myAnimals: Array = [];
		public function Root() {
			//初始化引擎
			Laya.init(1136, 640,WebGL);
			
			console.log('welcome to our zoo!');
			
			// 2只马
			var whiteHorse: Horse = new Horse();
			whiteHorse.name = 'Jimmy';
			whiteHorse.isWhite = true;
			
			var blakeHorse: Horse = new Horse();
			blakeHorse.name = 'Jerry';
			blakeHorse.isWhite = false;
			
			this.myAnimals.push(whiteHorse, blakeHorse);
			
			// 2只马都在闲逛
			for(var i: int = 0; i < this.myAnimals.length; i++) {
				var tmpHorse: Horse = this.myAnimals[i];
				tmpHorse.idle();
			}
		}		
	}
}