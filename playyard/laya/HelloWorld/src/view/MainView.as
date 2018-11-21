package view {
	import laya.events.Event;
	import laya.ui.Box;
	import laya.ui.Label;
	
	import ui.test.MainViewUI;
	
	public class MainView extends MainViewUI {
		
		public function MainView() {
			//btn是编辑器界面设定的，代码里面能直接使用，并且有代码提示
//			btn.on(Event.CLICK, this, onBtnClick);
//			btn2.on(Event.CLICK, this, onBtn2Click);
		}
		
		private function onBtnClick(e:Event):void {
			//手动控制组件属性
//			radio.selectedIndex = 1;
//			clip.index = 8;
//			tab.selectedIndex = 2;
//			combobox.selectedIndex = 0;
//			check.selected = true;
		}
	}
}