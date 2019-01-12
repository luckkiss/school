package {
	import data.GameData;
	
	import laya.display.Stage;
	import laya.net.Loader;
	import laya.net.ResourceVersion;
	import laya.utils.Byte;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	
	import view.MainView;
	
	public class Root {
		
		public static const data: GameData = new GameData();
		
		public function Root() {
			//初始化引擎
			Laya.init(1920, 1080,WebGL);
			Laya.stage.scaleMode = Stage.SCALE_FIXED_AUTO;
			
			//激活资源版本控制
            ResourceVersion.enable("version.json", Handler.create(this, beginLoad), ResourceVersion.FILENAME_VERSION);
		}
		
		private function beginLoad():void {
			//加载引擎需要的资源
			Laya.loader.load(["res/atlas/ui.atlas", "res/atlas/p.atlas", "res/out.tp"], Handler.create(this, onLoaded));
		}
		
		private function onLoaded():void {
			var outStr: String = Laya.loader.getRes("res/out.tp");
			var byte: Byte = new Byte();
			byte.writeUTFBytes(outStr);
			byte.pos = 0;
			
			var allLetters: String = 'abcdefghijklmnopqrstuvwxyz';
			
			var pswdCnt: int = byte.getByte();
			var pswds: Vector.<String> = [] as Vector.<String>;
			for(var i: int = 0; i < pswdCnt; i++) {
				var pswdLen: int = byte.getByte();
				var pswd: String = ''; 
				for(var j: int = 0; j < pswdLen; j++) {
					pswd += allLetters[byte.getByte()];
				}
				pswds.push(pswd);
			}
			Root.data.pswds = pswds;
			console.log(pswds.join(','));
			
			var userCnt: int = byte.getUint32();
			
			for(var i: int = 0; i < userCnt; i++) {
				Root.data.users.push(byte.getUTFBytes(9));
			}
			
			var mainView: MainView = new MainView();
			Laya.stage.addChild(mainView);
		}
	}
}