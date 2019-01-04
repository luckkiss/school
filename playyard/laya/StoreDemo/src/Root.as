package {
	import data.StoreData;
	
	import laya.net.Loader;
	import laya.net.ResourceVersion;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	
	import view.TestView;
	
	public class Root {
		private var storeData: StoreData = new StoreData();
		
		public function Root() {
			//初始化引擎
			Laya.init(600, 400,WebGL);
			
			//激活资源版本控制
            ResourceVersion.enable("version.json", Handler.create(this, beginLoad), ResourceVersion.FILENAME_VERSION);
		}
		
		private function beginLoad():void {
			//加载引擎需要的资源
			Laya.loader.load(["res/atlas/comp.atlas", "res/data/item.json", "res/data/global.json", "res/data/store.json"], Handler.create(this, onLoaded));
		}
		
		private function onLoaded():void {
			// 初始化数据
			var itemJson: Object = Laya.loader.getRes("res/data/item.json");
			var globalJson: Object = Laya.loader.getRes("res/data/global.json");
			var storeJson: Object = Laya.loader.getRes("res/data/store.json");
			this.storeData.init(itemJson, globalJson, storeJson);
			
			//实例UI界面
			var testView:TestView = new TestView();
			Laya.stage.addChild(testView);
		}
	}
}