package view {
	import laya.events.Event;
	import laya.net.HttpRequest;
	import laya.ui.Box;
	import laya.ui.Label;
	
	import ui.MainViewUI;
	
	public class MainView extends MainViewUI	 {
		private var stockCode: int;
		private var chart: CandleChart;
		
		private var dataUtl: String = 'http://quotes.money.163.com/service/chddata.html?code={0}&start=20140101&end=20181121&fields=TCLOSE;HIGH;LOW;TOPEN;LCLOSE;CHG;PCHG;VOTURNOVER;VATURNOVER';
		private var code: String = '000400';
		
		public function MainView() {
			this.chart = new CandleChart();
			this.addChild(this.chart);
			
			this.draw(code);
		}
		
		private function draw(code: String): void {
			var isSz: Boolean = (code.match(/^000/) || code.match(/^001/) || code.match(/^002/) || code.match(/^000/) || code.match(/^200/) || code.match(/^300/))
			var url: String = this.dataUtl.replace('{0}', (isSz ? '1' : '0') + code);
			var request:HttpRequest = new HttpRequest();
			request.once(Event.COMPLETE, this, onLoadComplete);
			request.once(Event.ERROR, this, onLoadError);
			request.send(url);
		}
		
		private function onLoadComplete(data: String): void {
			console.log(data);
		}
		
		private function onLoadError(e: Error): void {
			console.log(e);
		}
	}
}