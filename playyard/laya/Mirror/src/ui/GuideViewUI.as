/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 

	public class GuideViewUI extends View {

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":750,"height":1334},"child":[{"type":"Image","props":{"top":0,"skin":"ui/bg/bg_cube_gold.png","right":0,"left":0,"bottom":0},"child":[{"type":"Rect","props":{"y":599,"x":105,"width":100,"lineWidth":1,"height":100,"fillColor":"#ddb2b2"}}]}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}