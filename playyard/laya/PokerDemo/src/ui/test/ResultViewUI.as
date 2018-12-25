/**Created by the LayaAirIDE,do not modify.*/
package ui.test {
	import laya.ui.*;
	import laya.display.*; 

	public class ResultViewUI extends View {
		public var list:List;
		public var btnContinue:Button;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":694,"height":560},"child":[{"type":"Image","props":{"width":694,"skin":"ui/dialog/bg_dlgII.png","height":560,"sizeGrid":"60,24,24,24"},"child":[{"type":"Label","props":{"y":4,"text":"结算","fontSize":24,"color":"#ffffff","centerX":0}},{"type":"List","props":{"width":320,"var":"list","height":400,"centerY":-20,"centerX":0}},{"type":"Button","props":{"var":"btnContinue","skin":"ui/btn/btn_gold.png","label":"继续","centerX":0,"bottom":20,"stateNum":1,"labelPadding":"0,0,4,0","labelSize":24}}]}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}