package {
	import data.GameData;
	
	import laya.display.Stage;
	import laya.net.Loader;
	import laya.net.ResourceVersion;
	import laya.utils.Browser;
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
			
			Laya.loader.load('ver_md5.txt?' + Browser.now(), Handler.create(this, versionMd5, null, false));
		}
		
		private function versionMd5(md5: String): void {
			//激活资源版本控制
			console.log("use version: " + md5);
            ResourceVersion.enable("version" + md5 + ".json", Handler.create(this, beginLoad), ResourceVersion.FILENAME_VERSION);
		}
		
		private function beginLoad():void {
			//加载引擎需要的资源
			Laya.loader.load(["res/atlas/ui.atlas", "res/out.tp"], Handler.create(this, onLoaded));
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
			
			Root.data.luckyCntTotal = byte.getByte();
			
			var userImgSkins: Array = [];
			var userCnt: int = byte.getUint32();
			for(var i: int = 0; i < userCnt; i++) {
				var uname: String = byte.getUTFBytes(9)
				Root.data.users.push(uname);
				userImgSkins.push('p/' + uname + '.jpg');
			}
			
			var stCnt: int = byte.getByte();
			for(var i: int = 0; i < stCnt; i++) {
				var idx: int = byte.getByte();
				Root.data.stList.push(Root.data.users[idx]);
			}
			
			var bossCnt: int = byte.getByte();
			for(var i: int = 0; i < bossCnt; i++) {
				var idx: int = byte.getByte();
				Root.data.bossList.push(Root.data.users[idx]);
			}
			
			console.assert(Root.data.luckyCntTotal == Root.data.users.length - stCnt - bossCnt);
			
			Laya.loader.load(userImgSkins);
			
			var mainView: MainView = new MainView();
			Laya.stage.addChild(mainView);
		}
	}
}