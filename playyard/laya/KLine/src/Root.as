package {
	import laya.net.Loader;
	import laya.net.ResourceVersion;
	import laya.utils.Handler;
	import view.MainView;
	import laya.webgl.WebGL;
	
	public class Root {
		
		public function Root() {
			//初始化引擎
			Laya.init(600, 400,WebGL);
			//加载引擎需要的资源
			Laya.loader.load("res/atlas/comp.atlas", Handler.create(this, onLoaded));
		}
		
		private function onLoaded():void {
			//实例UI界面
			var testView:MainView = new MainView();
			Laya.stage.addChild(testView);
		}
	}
}