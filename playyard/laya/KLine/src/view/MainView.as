package view {
	import data.SingleInfo;
	
	import laya.events.Event;
	import laya.net.HttpRequest;
	import laya.ui.Box;
	import laya.ui.Label;
	import laya.utils.Handler;
	
	import ui.MainViewUI;
	
	public class MainView extends MainViewUI	 {
		private var stockCode: int;
		private var chart: CandleChart;
		
		private var code: String = '000400';
		
		private var dataMap: Object = {};
		
		public function MainView() {
			this.chartCtn.vScrollBar = '';
			this.chartCtn.hScrollBar = '';
			
			this.chart = new CandleChart();
			this.chartCtn.addChild(this.chart);
			
			this.draw(code);
		}
		
		private function draw(code: String): void {
			var codeData: Vector.<SingleInfo> = this.dataMap[code];
			if(codeData) {				
				this.chart.draw(codeData);
			} else {
				this.dataMap[code] = [];
				Laya.loader.load('res/data/' + this.code + '.csv', Handler.create(this, onLoadComplete));
			}			
		}
		
		private function onLoadComplete(content: String): void {
			var codeData: Vector.<SingleInfo> = this.dataMap[code];
			
			var arr: Array = content.split(/[\r|\n]+/);
			var len: int = arr.length;
			if(arr.length > 1) {				
				for(var i: int = 1; i < len; i++) {
					//TCLOSE;HIGH;LOW;TOPEN;LCLOSE;CHG;PCHG;VOTURNOVER;VATURNOVER
					var info: SingleInfo = new SingleInfo();
					codeData.push(info);
					
					var oneLine: String = arr[i];
					var lineArr: Array = oneLine.split(',');
					var lineLen: int = lineArr.length;
					if(lineLen > 3) {
						info.close = lineArr[3];
					}
					if(lineLen > 4) {
						info.high = lineArr[4];
					}
					if(lineLen > 5) {
						info.low = lineArr[5];
					}
					if(lineLen > 6) {
						info.open = lineArr[6];
					}
					if(lineLen > 7) {
						info.lastClose = lineArr[7];
					}
					if(lineLen > 8) {
						info.changed = lineArr[8];
					}
					if(lineLen > 9) {
						info.percentChanged = lineArr[9];
					}
					if(lineLen > 10) {
						info.voTurnOver = lineArr[10];
					}
					if(lineLen > 11) {
						info.vaTurnOver = lineArr[11];
					}
				}
			}
			
			this.chart.draw(codeData);
		}
	}
}