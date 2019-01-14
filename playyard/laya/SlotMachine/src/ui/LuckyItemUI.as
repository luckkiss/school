/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 
	import laya.display.Text;

    import laya.utils.ClassUtils;
	public class LuckyItemUI extends Box {
		public var imgHead:Image;
		public var textName:Text;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"Box","props":{"y":0,"x":0,"width":125,"height":180},"child":[{"type":"Image","props":{"var":"imgHead","skin":"p/default.jpg"}},{"type":"Text","props":{"y":136,"width":125,"var":"textName","text":"幸运儿","height":26,"fontSize":24,"color":"#ffffff","align":"center"}}]};
		public function LuckyItemUI(){
		createUI(uiView);
		}
		private function createUI(uiData:Object):void
		{
			View.regComponent("Text",Text);

			ClassUtils.createByJson(uiData, this, this);

		}

	}
}