package view
{
	import data.GuideNode;
	
	import laya.display.Sprite;
	import laya.display.Text;
	
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
		
		override protected function onOpen(): void {
			var rootNode: GuideNode = Global.guideData.rootNode;
			
			var nodeRect: Sprite = new Sprite();
			nodeRect.graphics.drawRect(0, 0, 100, 100, '#ddb2b2');
			var textDesc: Text = new Text();
			textDesc.text = rootNode.desc;
			nodeRect.addChild(textDesc);
			this.uiView.addChild(nodeRect);
		}
	}
}