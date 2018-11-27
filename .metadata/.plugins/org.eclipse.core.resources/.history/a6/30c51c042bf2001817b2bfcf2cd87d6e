package {
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	
	import view.MainView;
	
	/**根*/
	public class Root {
		
		public function Root() {
			//初始化引擎
			Laya.init(750, 1334,WebGL);
			//加载引擎需要的资源
			Laya.loader.load("res/atlas/comp.atlas", Handler.create(this, onLoaded));
		}
		
		private function onLoaded():void {
			//实例UI界面
			var mainView: MainView = new MainView();
			Laya.stage.addChild(mainView);
		}
	}
}