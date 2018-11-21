package view
{
	import data.SingleInfo;
	
	import laya.display.Sprite;
	
	public class CandleChart extends Sprite
	{
		private var chartWidth: Number = 960;
		private var chartHeight: Number = 140;
		
		private var barDefaultWidth: Number = 14;
		private var barScale: Number = 1;
		private var infoArr: Vector.<SingleInfo> = new Vector.<SingleInfo>();
		
		public function CandleChart()
		{
			super();
		}
		
		public function setChartSize(width: Number, height: Number): void {
			this.chartWidth = width;
			this.chartHeight = height;
		}
		
		public function draw(infoContent: String): void {
			this.redraw();
		}
		
		private function redraw(): void {
			this.graphics.clear();
			var barWidth: Number = this.barDefaultWidth * this.barScale;
			var len: int = this.infoArr.length;
			for(var i: int = 0; i < len; i++) {
				var info: SingleInfo = this.infoArr[i];
				var cx: Number = i * barWidth;
				var openY: Number = this.chartHeight - (info.open - info.min) / (info.max - info.min) * this.chartHeight;
				var closeY: Number = this.chartHeight - (info.close - info.min) / (info.max - info.min) * this.chartHeight;
							
				
				var tailX: Number = cx + barWidth / 2;
				var highestY: Number = this.chartHeight - (info.highest - info.min) / (info.max - info.min) * this.chartHeight;
				var lowestY: Number  = this.chartHeight - (info.lowest - info.min) / (info.max - info.min) * this.chartHeight;
				
				if(info.open > info.close) {
					this.graphics.drawRect(cx, openY, barWidth, closeY - openY);
					this.graphics.drawLine(tailX, openY, tailX, highestY);
					this.graphics.drawLine(tailX, closeY, tailX, lowestY);
				} else {
					this.graphics.drawRect(cx, closeY, barWidth, openY - closeY);
					this.graphics.drawLine(tailX, closeY, tailX, highestY);
					this.graphics.drawLine(tailX, closeY, tailX, lowestY);
				}
			}			
		}
	}
}