/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 

	public class GuideViewUI extends View {
		public var textDetail:Label;
		public var inputSearch:TextInput;
		public var btnSearch:Button;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"y":0,"x":0,"width":750,"top":0,"right":0,"left":0,"height":1334,"bottom":0},"child":[{"type":"Label","props":{"wordWrap":true,"width":686,"var":"textDetail","text":"label","right":32,"overflow":"scroll","left":32,"height":282,"fontSize":24,"color":"#ffffff","bottom":10,"align":"center"}},{"type":"Box","props":{"width":300,"top":12,"height":36,"centerX":0},"child":[{"type":"TextInput","props":{"var":"inputSearch","type":"text","top":0,"skin":"comp/textinput.png","right":64,"promptColor":"#979191","prompt":"输入关键字进行搜索","left":0,"color":"#000000","bottom":0}},{"type":"Button","props":{"width":64,"var":"btnSearch","top":0,"skin":"comp/button.png","right":0,"label":"搜索","bottom":0}}]}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}