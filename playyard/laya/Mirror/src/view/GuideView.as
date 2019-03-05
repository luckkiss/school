package view
{
	import ui.GuideViewUI;

	public class GuideView extends CommonForm
	{
		private var uiView: GuideViewUI;
		
		public function GuideView()
		{
		}
		
		protected function resPath(): Object
		{
			return GuideViewUI.uiView;
		}
		
		override protected function initElements(): void {
			uiView = new GuideViewUI();
			form = uiView;
		}
		
		public function draw(): void {
			
		}
	}
}