/**Created by the LayaAirIDE,do not modify.*/
package ui.test {
	import laya.ui.*;
	import laya.display.*; 

	public class MainViewUI extends View {
		public var btnGo:Button;
		public var textCountDown:Label;
		public var textRound:Label;
		public var leftPlayerCtn:Box;
		public var rightPlayerCtn:Box;
		public var imgLeftCard:Image;
		public var imgRightCard:Image;
		public var roundResult:Image;
		public var textResult:Label;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":1024,"height":768},"child":[{"type":"Button","props":{"var":"btnGo","skin":"ui/btn/btn_gold.png","label":"开始","centerX":0,"bottom":24,"stateNum":1,"labelPadding":"0,0,4,0","labelSize":24}},{"type":"Label","props":{"var":"textCountDown","text":"5","fontSize":42,"color":"#ffffff","centerY":0,"centerX":0}},{"type":"Label","props":{"y":20,"x":10,"var":"textRound","text":"第n场","fontSize":42,"color":"#ffffff","centerX":0}},{"type":"Box","props":{"width":80,"var":"leftPlayerCtn","left":0,"height":120,"centerY":0}},{"type":"Box","props":{"width":80,"var":"rightPlayerCtn","right":0,"height":120,"centerY":0}},{"type":"Image","props":{"width":120,"var":"imgLeftCard","left":100,"height":120,"centerY":0}},{"type":"Image","props":{"width":120,"var":"imgRightCard","right":100,"height":120,"centerY":0}},{"type":"Image","props":{"width":360,"var":"roundResult","skin":"ui/dialog/brown.png","height":180,"centerY":-120,"centerX":0},"child":[{"type":"Label","props":{"var":"textResult","fontSize":42,"color":"#ffffff","centerY":0,"centerX":0}}]}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}