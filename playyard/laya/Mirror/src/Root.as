package {
	import laya.display.Stage;
	import laya.net.Loader;
	import laya.net.ResourceVersion;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	import laya.wx.mini.MiniAdpter;
	
	import view.GuideView;
	import view.LoginView;
	
	public class Root {
		
		public function Root() {
			//初始化微信小游戏
			MiniAdpter.init();

			//初始化引擎
			Laya3D.init(750, 1334, true);
			Laya.stage.scaleMode = Stage.SCALE_FIXED_AUTO;
			
			//激活资源版本控制
            ResourceVersion.enable("version.json", Handler.create(this, beginLoad), ResourceVersion.FILENAME_VERSION);
		}
		
		private function beginLoad():void {
			//加载引擎需要的资源
			Global.cfgMgr.loadConfigs(Handler.create(this, this.onCfgLoaded));
		}
		
		/**json数据加载完毕*/
		private function onCfgLoaded(o: Object): void {
			console.log(o);
			// 读取guide.json
			Global.guideData.onCfgReady();
			Global.cfgMgr.isReady = true;
			
			// 初始化界面
			this.initView();
		}
		
		private function initView(): void {
			// GuiView继承自CommonForm
			var guideView: GuideView = new GuideView();
			// 调用createForm使其开始图集加载
			guideView.createForm();
			// 调用open使其在加载完成后自动打开
			guideView.open();
			// 所有面板都必须管理起来，使用UIManager进行管理
			Global.uiMgr.guideView = guideView;
		}
	}
}