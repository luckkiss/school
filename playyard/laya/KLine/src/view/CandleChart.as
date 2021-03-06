package view
{
	import data.SingleInfo;
	
	import laya.display.Sprite;
	
	public class CandleChart extends Sprite
	{
		private var chartWidth: Number = 960;
		private var chartHeight: Number = 140;
		
		private var showMaxCnt: int = 500;
		
		private var barDefaultWidth: Number = 14;
		private var barScale: Number = 1;
		private var codeData: Vector.<SingleInfo> = new Vector.<SingleInfo>();
		
		public function CandleChart()
		{
			super();
		}
		
		public function setChartSize(width: Number, height: Number): void {
			this.chartWidth = width;
			this.chartHeight = height;
		}
		
		public function draw(codeData: Vector.<SingleInfo>): void {
			this.codeData = codeData;
			this.redraw();
		}
		
		private function redraw(): void {
			this.graphics.clear();
			var barWidth: Number = this.barDefaultWidth * this.barScale;
			var len: int = this.codeData.length;
			var info: SingleInfo;
			
			var min: Number = 0;
			var max: Number = 0;
			var start: int = len - this.showMaxCnt;
			if(start < 0) {
				start = 0;
			}
			for(var i: int = start; i < len; i++) {
				info = this.codeData[i];
				if(0 == min || info.low < min) {
					min = info.low;
				}
				if(info.high > max) {
					max = info.high;
				}
			}
			for(var i: int = start; i < len; i++) {
				info = this.codeData[i];
				var color: String = info.close > info.open ? '#ff0000' : '#00fff00';
				
				var cx: Number = (i - start) * barWidth;
				var openY: Number = this.chartHeight - (info.open - min) / (max - min) * this.chartHeight;
				var closeY: Number = this.chartHeight - (info.close - min) / (max - min) * this.chartHeight;
							
				
				var tailX: Number = cx + barWidth / 2;
				var highestY: Number = this.chartHeight - (info.high - min) / (max - min) * this.chartHeight;
				var lowestY: Number  = this.chartHeight - (info.low - min) / (max - min) * this.chartHeight;
				
				if(info.open > info.close) {
					this.graphics.drawRect(cx, openY, barWidth, closeY - openY, color);
					this.graphics.drawLine(tailX, openY, tailX, highestY, color);
					this.graphics.drawLine(tailX, closeY, tailX, lowestY, color);
				} else {
					this.graphics.drawRect(cx, closeY, barWidth, openY - closeY, color);
					this.graphics.drawLine(tailX, closeY, tailX, highestY, color);
					this.graphics.drawLine(tailX, closeY, tailX, lowestY, color);
				}
			}			
		}
	}
}