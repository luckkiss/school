package view
{
	import laya.events.Event;
	
	import ui.MainViewUI;

	public class MainView extends CommonForm
	{
		private var uiView: MainViewUI;
//		private var guideView: GuideView;  // 这个变量没有意义
		public function MainView()
		{
			
			
		}
		override protected function resPath():Object{
			return MainViewUI.uiView;
		}
		override protected function initElements():void{
			uiView =  new MainViewUI();
			form = uiView;
			uiView.btnOpenGuideView.on(Event.CLICK,this,this.onClickbtnOpenGuideView);
			
		}
		private function onClickbtnOpenGuideView():void{
			var guideView: GuideView;
			guideView = new GuideView();
			guideView.createForm();
			guideView.open();
			Global.uiMgr.guideView = guideView;
			console.log(';;;;');
				
			
			
		}
	}
}