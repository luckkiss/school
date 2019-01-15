/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 
	import laya.display.Text;

	public class MainViewUI extends View {
		public var move_yuntian:FrameAnimation;
		public var move_sj:FrameAnimation;
		public var move_biao1:FrameAnimation;
		public var move_moby1:FrameAnimation;
		public var yuntian:Box;
		public var slotmachine:Image;
		public var lightCtn1:Box;
		public var lightCtn2:Box;
		public var labaCtn:Box;
		public var btnGo:Image;
		public var textBroadcast1:Text;
		public var textBroadcast2:Text;
		public var textRound:Label;
		public var frame:Image;
		public var sj:Box;
		public var biao1:Box;
		public var moby1:Box;
		public var xchn:Image;
		public var loginCtn:Box;
		public var inputPswd:TextInput;
		public var btnLogin:Button;
		public var textVersion:Label;
		public var pop:Box;
		public var popBg:Image;
		public var listLucky:List;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":1920,"top":0,"right":0,"name":"imgTalk","left":0,"height":1080,"bottom":0},"child":[{"type":"Image","props":{"top":0,"skin":"ui/bg.png","right":0,"left":0,"bottom":0}},{"type":"Box","props":{"width":320,"var":"yuntian","right":300,"height":320,"bottom":170},"compId":99,"child":[{"type":"Image","props":{"y":-110,"x":-8,"skin":"ui/kane.png","name":"imgTalk"}}]},{"type":"Image","props":{"var":"slotmachine","skin":"ui/slotmachine.png","centerX":0,"bottom":30,"width":559,"height":796},"child":[{"type":"Box","props":{"y":116,"x":30,"width":500,"var":"lightCtn1","height":260}},{"type":"Box","props":{"y":350,"x":30,"width":500,"var":"lightCtn2","height":260}},{"type":"Box","props":{"y":18,"x":18,"width":140,"var":"labaCtn","height":125}},{"type":"Image","props":{"y":364,"x":521,"var":"btnGo","skin":"ui/handler.png","pivotY":142}},{"type":"Box","props":{"y":185,"x":83,"width":128,"name":"p0","height":125},"child":[{"type":"Box","props":{"top":0,"right":0,"renderType":"mask","left":0,"bottom":0},"child":[{"type":"Rect","props":{"y":0,"x":0,"width":128,"lineWidth":1,"height":125,"fillColor":"#ff0000"}}]}]},{"type":"Box","props":{"y":185,"x":214,"width":128,"name":"p1","height":125},"child":[{"type":"Box","props":{"top":0,"right":0,"renderType":"mask","left":0,"bottom":0},"child":[{"type":"Rect","props":{"y":0,"x":0,"width":128,"lineWidth":1,"height":125,"fillColor":"#ff0000"}}]}]},{"type":"Box","props":{"y":185,"x":344,"width":128,"name":"p2","height":125},"child":[{"type":"Box","props":{"top":0,"right":0,"renderType":"mask","left":0,"bottom":0},"child":[{"type":"Rect","props":{"y":0,"x":0,"width":128,"lineWidth":1,"height":125,"fillColor":"#ff0000"}}]}]},{"type":"Box","props":{"y":415,"x":83,"width":125,"name":"p3","height":125},"child":[{"type":"Box","props":{"top":0,"right":0,"renderType":"mask","left":0,"bottom":0},"child":[{"type":"Rect","props":{"y":0,"x":0,"width":128,"lineWidth":1,"height":125,"fillColor":"#ff0000"}}]}]},{"type":"Box","props":{"y":415,"x":214,"width":128,"name":"p4","height":125},"child":[{"type":"Box","props":{"top":0,"right":0,"renderType":"mask","left":0,"bottom":0},"child":[{"type":"Rect","props":{"y":0,"x":0,"width":128,"lineWidth":1,"height":125,"fillColor":"#ff0000"}}]}]},{"type":"Box","props":{"y":415,"x":344,"width":128,"name":"p5","height":125},"child":[{"type":"Box","props":{"top":0,"right":0,"renderType":"mask","left":0,"bottom":0},"child":[{"type":"Rect","props":{"y":0,"x":0,"width":128,"lineWidth":1,"height":125,"fillColor":"#ff0000"}}]}]},{"type":"Box","props":{"y":40,"x":140,"width":400,"height":78},"child":[{"type":"Text","props":{"y":12,"x":0,"width":400,"var":"textBroadcast1","text":"恭喜XXX获得一次抽奖机会","fontSize":22,"color":"#ffffff"}},{"type":"Text","props":{"y":42,"x":0,"width":400,"var":"textBroadcast2","text":"恭喜XXX获得一次抽奖机会","fontSize":22,"color":"#ffffff"}},{"type":"Box","props":{"top":0,"right":0,"renderType":"mask","left":0,"bottom":0},"child":[{"type":"Rect","props":{"width":400,"lineWidth":1,"height":78,"fillColor":"#ff0000"}}]}]},{"type":"Image","props":{"y":172,"x":83,"skin":"ui/slotMask.png"}},{"type":"Image","props":{"y":403,"x":83,"skin":"ui/slotMask.png"}},{"type":"Label","props":{"var":"textRound","text":"第 X 轮","fontSize":24,"color":"#ffffff","centerX":0,"bottom":156}}]},{"type":"Image","props":{"var":"frame","top":0,"skin":"ui/frame.png","right":0,"left":0,"bottom":0}},{"type":"Box","props":{"width":300,"var":"sj","right":260,"height":300,"bottom":72},"compId":100,"child":[{"type":"Image","props":{"y":-66,"x":98,"skin":"ui/roskin.png","name":"imgTalk"}}]},{"type":"Box","props":{"x":272,"width":260,"var":"biao1","height":300,"bottom":200},"compId":101,"child":[{"type":"Image","props":{"y":-109,"x":-47,"skin":"ui/bill.png","name":"imgTalk"}}]},{"type":"Box","props":{"x":400,"width":320,"var":"moby1","height":320,"bottom":176},"compId":102,"child":[{"type":"Image","props":{"y":-120,"x":-150,"skin":"ui/moby.png","name":"imgTalk"}}]},{"type":"Image","props":{"y":72,"x":628,"var":"xchn","top":72,"skin":"ui/xchn.png","centerX":0}},{"type":"Box","props":{"y":0,"x":0,"var":"loginCtn","top":0,"right":0,"left":0,"bottom":0},"child":[{"type":"TextInput","props":{"width":539,"var":"inputPswd","type":"password","skin":"ui/inputBg.png","restrict":"a-z","prompt":"请输入访问密码","padding":"0,40,0,40","height":90,"fontSize":30,"color":"#ffffff","centerY":-80,"centerX":0}},{"type":"Button","props":{"var":"btnLogin","skin":"ui/btn_login.png","centerY":120,"centerX":0,"width":267,"height":255,"stateNum":1}},{"type":"Label","props":{"var":"textVersion","text":"版本号：0.0.0","fontSize":20,"color":"#ffffff","centerX":0,"bottom":10,"align":"center"}}]},{"type":"Box","props":{"var":"pop","top":0,"right":0,"left":0,"bottom":0},"child":[{"type":"Image","props":{"y":540,"x":960,"var":"popBg","skin":"ui/popBg.png","pivotY":540,"pivotX":621.5,"centerY":0,"centerX":0,"width":1243,"height":1080},"child":[{"type":"List","props":{"width":537,"var":"listLucky","spaceY":10,"spaceX":12,"repeatX":3,"height":370,"centerY":0,"centerX":0}}]}]}],"animations":[{"nodes":[{"target":99,"keyframes":{"right":[{"value":-500,"tweenMethod":"linearNone","tween":true,"target":99,"key":"right","index":0},{"value":400,"tweenMethod":"linearNone","tween":true,"target":99,"key":"right","index":15}]}}],"name":"move_yuntian","id":1,"frameRate":24,"action":0},{"nodes":[{"target":100,"keyframes":{"right":[{"value":-500,"tweenMethod":"linearNone","tween":true,"target":100,"key":"right","index":0},{"value":260,"tweenMethod":"linearNone","tween":true,"target":100,"key":"right","index":15}]}}],"name":"move_sj","id":2,"frameRate":24,"action":0},{"nodes":[{"target":101,"keyframes":{"x":[{"value":-300,"tweenMethod":"linearNone","tween":true,"target":101,"key":"x","index":0},{"value":272,"tweenMethod":"linearNone","tween":true,"target":101,"key":"x","index":15}]}}],"name":"move_biao1","id":3,"frameRate":24,"action":0},{"nodes":[{"target":102,"keyframes":{"x":[{"value":-400,"tweenMethod":"linearNone","tween":true,"target":102,"key":"x","index":0},{"value":480,"tweenMethod":"linearNone","tween":true,"target":102,"key":"x","index":15}]}}],"name":"move_moby1","id":4,"frameRate":24,"action":0}]};
		override protected function createChildren():void {
			View.regComponent("Text",Text);
			super.createChildren();
			createView(uiView);

		}

	}
}