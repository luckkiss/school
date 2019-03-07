/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 

	public class GuideViewUI extends View {
		public var textDetail:Label;
		public var inputSearch:TextInput;
		public var btnSearch:Button;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"y":0,"x":0,"width":750,"height":1334},"child":[{"type":"Label","props":{"var":"textDetail","text":"label","right":32,"left":32,"height":200,"fontSize":24,"color":"#ffffff","bottom":10,"align":"center"}},{"type":"Box","props":{"width":300,"top":12,"height":36,"centerX":0},"child":[{"type":"TextInput","props":{"var":"inputSearch","top":0,"skin":"comp/textinput.png","right":64,"promptColor":"#979191","prompt":"输入关键字进行搜索","left":0,"color":"#ffffff","bottom":0}},{"type":"Button","props":{"width":64,"var":"btnSearch","top":0,"skin":"comp/button.png","right":0,"label":"搜索","bottom":0}}]}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}