/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 

	public class GuideViewUI extends View {
		public var textDetail:Label;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":750,"height":1334},"child":[{"type":"Label","props":{"var":"textDetail","text":"label","right":32,"left":32,"height":100,"fontSize":24,"color":"#ffffff","bottom":10,"align":"center"}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}