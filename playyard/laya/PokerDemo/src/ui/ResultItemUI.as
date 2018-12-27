/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 

	public class ResultItemUI extends View {
		public var textInfo:Label;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":320,"height":32},"child":[{"type":"Label","props":{"var":"textInfo","top":0,"right":0,"left":0,"color":"#ffffff","bottom":0}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}