/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 

	public class TxtViewUI extends View {
		public var labeltextInfo:Label;
		public var btnClose:Button;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":600,"height":500},"child":[{"type":"Label","props":{"wordWrap":true,"width":600,"var":"labeltextInfo","top":50,"text":"label","right":0,"left":0,"height":500,"fontSize":30,"color":"#f4e6e6","bottom":0,"align":"center"}},{"type":"Button","props":{"width":50,"var":"btnClose","top":0,"skin":"comp/btn_close.png","right":0,"labelSize":25,"labelColors":"#ffffff","height":50}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}