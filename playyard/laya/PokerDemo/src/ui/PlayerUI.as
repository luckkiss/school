/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 
	import laya.display.Text;

	public class PlayerUI extends View {
		public var imgHead:Image;
		public var textName:Text;
		public var textScore:Text;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":80,"height":120},"child":[{"type":"Image","props":{"var":"imgHead","skin":"ui/roleHead/boy.png"}},{"type":"Text","props":{"y":72,"width":80,"var":"textName","text":"玩家名字","fontSize":16}},{"type":"Text","props":{"y":92,"width":80,"var":"textScore","text":"得分：100","fontSize":16}}]};
		override protected function createChildren():void {
			View.regComponent("Text",Text);
			super.createChildren();
			createView(uiView);

		}

	}
}