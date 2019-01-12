/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 

	public class MainViewUI extends View {
		public var playCtn:Box;
		public var slotmachine:Image;
		public var btnGo:Image;
		public var loginCtn:Box;
		public var inputUser:TextInput;
		public var inputPswd:TextInput;
		public var btnLogin:Button;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":1920,"top":0,"right":0,"left":0,"height":1080,"bottom":0},"child":[{"type":"Image","props":{"top":0,"skin":"ui/bg.png","right":0,"left":0,"bottom":0}},{"type":"Box","props":{"y":0,"x":0,"var":"playCtn","top":0,"right":0,"left":0,"bottom":0},"child":[{"type":"Image","props":{"y":254,"x":681,"var":"slotmachine","skin":"ui/slotmachine.png","centerX":0,"bottom":30,"width":559,"height":796},"child":[{"type":"Image","props":{"y":364,"x":521,"var":"btnGo","skin":"ui/handler.png","pivotY":142}},{"type":"Box","props":{"y":185,"x":86,"width":125,"name":"p0","height":125},"child":[{"type":"Box","props":{"top":0,"right":0,"renderType":"mask","left":0,"bottom":0},"child":[{"type":"Rect","props":{"y":0,"x":0,"width":125,"lineWidth":1,"height":125,"fillColor":"#ff0000"}}]}]},{"type":"Box","props":{"y":185,"x":216,"width":125,"name":"p1","height":125},"child":[{"type":"Box","props":{"top":0,"right":0,"renderType":"mask","left":0,"bottom":0},"child":[{"type":"Rect","props":{"y":0,"x":0,"width":125,"lineWidth":1,"height":125,"fillColor":"#ff0000"}}]}]},{"type":"Box","props":{"y":185,"x":346,"width":125,"name":"p2","height":125},"child":[{"type":"Box","props":{"top":0,"right":0,"renderType":"mask","left":0,"bottom":0},"child":[{"type":"Rect","props":{"y":0,"x":0,"width":125,"lineWidth":1,"height":125,"fillColor":"#ff0000"}}]}]},{"type":"Box","props":{"y":415,"x":86,"width":125,"name":"p3","height":125},"child":[{"type":"Box","props":{"top":0,"right":0,"renderType":"mask","left":0,"bottom":0},"child":[{"type":"Rect","props":{"y":0,"x":0,"width":125,"lineWidth":1,"height":125,"fillColor":"#ff0000"}}]}]},{"type":"Box","props":{"y":415,"x":216,"width":125,"name":"p4","height":125},"child":[{"type":"Box","props":{"top":0,"right":0,"renderType":"mask","left":0,"bottom":0},"child":[{"type":"Rect","props":{"y":0,"x":0,"width":125,"lineWidth":1,"height":125,"fillColor":"#ff0000"}}]}]},{"type":"Box","props":{"y":415,"x":346,"width":125,"name":"p5","height":125},"child":[{"type":"Box","props":{"top":0,"right":0,"renderType":"mask","left":0,"bottom":0},"child":[{"type":"Rect","props":{"y":0,"x":0,"width":125,"lineWidth":1,"height":125,"fillColor":"#ff0000"}}]}]}]}]},{"type":"Box","props":{"y":0,"x":0,"var":"loginCtn","top":0,"right":0,"left":0,"bottom":0},"child":[{"type":"TextInput","props":{"width":539,"var":"inputUser","skin":"ui/inputBg.png","prompt":"用户名","padding":"0,40,0,40","height":90,"fontSize":30,"color":"#ffffff","centerY":-160,"centerX":0}},{"type":"TextInput","props":{"width":539,"var":"inputPswd","type":"password","skin":"ui/inputBg.png","restrict":"a-z","prompt":"密码","padding":"0,40,0,40","height":90,"fontSize":30,"color":"#ffffff","centerY":-40,"centerX":0}},{"type":"Button","props":{"var":"btnLogin","skin":"ui/btn_login.png","centerY":160,"centerX":0,"width":267,"height":255,"stateNum":1}}]},{"type":"Image","props":{"top":0,"skin":"ui/frame.png","right":0,"left":0,"bottom":0}},{"type":"Image","props":{"y":72,"x":628,"top":72,"skin":"ui/xchn.png","centerX":0}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}