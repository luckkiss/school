package view
{
	import laya.events.Event;
	import laya.utils.Handler;
	
	import ui.ResultItemUI;
	import ui.test.ResultViewUI;
	
	public class ResultView extends ResultViewUI
	{
		private var callback: Handler;
		
		public function ResultView()
		{
			super();
			
			this.list.itemRender = ResultItemUI;
			this.list.renderHandler = Handler.create(this, this.onRenderList);
			
			this.btnContinue.on(Event.CLICK, this, this.onClickBtnContinue);
		}
		
		public function showResult(resultData: Array, callback: Handler): void {
			this.visible = true;
			this.list.array = resultData;
			this.callback = callback;
		}
		
		private function onRenderList(cell: ResultItemUI, index: int): void {
			var result: int = this.list.getItem(index);
			var resultStr = '平手';
			if(result > 0) {
				resultStr = '胜利';
			} else if(result < 0) {
				resultStr = '失败';
			}
			cell.textInfo.text = '第' + (index + 1) + '场    ' + resultStr;
		}
		
		private function onClickBtnContinue(): void {
			this.visible = false;
			if(this.callback) {
				this.callback.run();
			}
		}
	}
}