/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 

	public class MainViewUI extends View {
		public var btnOpenGuideView:Button;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":600,"height":500},"child":[{"type":"Button","props":{"width":203,"var":"btnOpenGuideView","top":0,"skin":"comp/btn_close.png","left":0,"labelSize":30,"label":"GuideView","height":89}},{"type":"Image","props":{"y":5,"x":15,"width":560,"skin":"comp/image.png","height":488}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}