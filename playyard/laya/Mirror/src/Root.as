﻿package {
	import laya.net.Loader;
	import laya.net.ResourceVersion;
	import laya.utils.Handler;
	import view.LoginView;
	import laya.wx.mini.MiniAdpter;
	import laya.webgl.WebGL;
	
	public class Root {
		
		public function Root() {
			//初始化微信小游戏
			MiniAdpter.init();

			//初始化引擎
			Laya.init(600, 400,WebGL);
			
			//激活资源版本控制
            ResourceVersion.enable("version.json", Handler.create(this, beginLoad), ResourceVersion.FILENAME_VERSION);
		}
		
		private function beginLoad():void {
			//加载引擎需要的资源
			Laya.loader.load("res/atlas/comp.atlas", Handler.create(this, onLoaded));
		}
		
		private function onLoaded():void {
			//实例UI界面
			var loginView:LoginView = new LoginView();
			Laya.stage.addChild(loginView);
		}
	}
}