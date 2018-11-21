/**Created by the LayaAirIDE,do not modify.*/
package ui.test {
	import laya.ui.*;
	import laya.display.*; 

	public class MainViewUI extends View {
		public var textDesc:Label;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":750,"top":0,"right":0,"left":0,"height":1334,"bottom":0},"child":[{"type":"Image","props":{"top":0,"skin":"images/Cochem.jpg","right":0,"left":0,"bottom":0}},{"type":"Label","props":{"var":"textDesc","text":"Hello, World.","fontSize":32,"color":"#ffffff","centerX":0,"bottom":300}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}