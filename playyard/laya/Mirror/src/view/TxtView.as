package view
{
	import laya.events.Event;
	
	import ui.TxtViewUI;

	public class TxtView extends CommonForm
	{
		private var uiView: TxtViewUI;
		
		public function TxtView()
		{
			
		}
		override protected function resPath():Object{
			return TxtViewUI.uiView;
		}
		override protected function initElements():void{
			this.uiView = new TxtViewUI();
			form = this.uiView;
			this.uiView.btnClose.on(Event.CLICK,this,this.close);
			
		}
		override protected function onOpen():void{
			
		}
		
		
	}
}