package view
{
	import laya.ui.Box;
	import laya.ui.Image;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Tween;
	
	import utils.ArrayTool;
	
	public class SlotImage
	{
		private const ImgCnt: int = 2;
		
		private var image1: Image;
		private var image2: Image;
		private var imgHeight: Number;
		
		private var pool: Vector.<String>;
		
		private const TweenDrtBase: int = 500;
		private const TweenDrtMin: int = 100;
		private const TweenDrtMax: int = 2000;
		
		private static const StateNone: int = 0;
		private static const StateSpeeding: int = 1;
		private static const StateHolding: int = 2;
		private static const StateSlowing: int = 3;
		private static const StateResult: int = 4;
		
		private static const HoldingTime: int = 4000;
		private static const tweenDrtStep: int = 10;
		private static const ResultTime: int = 2000;
		
		private var startRollAt: Number = 0;
		private var tweenDrt: int = 500;
		private var tweenDrtState: int = 0;
		private var changeStateAt: Number = 0;
		
		private var luckyName: String;
		private var poolIndex: int = 0;
		private var isRolling: Boolean = false;
		
		private var endCallback: Handler;
		private var index: int = 0;
		
		private const designedRollTimes: Vector.<int> = [4, 74, 4, 4] as Vector.<int>;
		private var rollTimes: Vector.<int> = [] as Vector.<int>;
		
		private var tweenTargetType: int = 0;
		private var tween: Tween;
		
		public function SlotImage()
		{
			super();
		}
		
		public function init(index: int, ctn: Box): void {
			this.index = index;
			
			this.imgHeight = ctn.height;
			this.image1 = new Image();
			this.image1.size(ctn.width, ctn.height);
			ctn.addChild(this.image1);
			this.image2 = new Image();
			this.image2.size(ctn.width, ctn.height);
			ctn.addChild(this.image2);
			this.image1.skin = "p/default.png";
			this.image2.skin = "p/default.png";
			
			this.image1.size(ctn.width, ctn.height);
			this.image2.size(ctn.width, ctn.height);
		}
		
		public function reset(): void {
			this.image1.skin = "p/default.png";
			this.image2.skin = "p/default.png";
			this.image1.y = 0;
			this.image2.y = -this.imgHeight;
		}
		
		public function start(pool: Vector.<String>, callback: Handler, delay: int): void {
			this.pool = ArrayTool.disarrange(pool as Array) as Vector.<String>;
			this.luckyName = Root.data.luckyList[this.index];
			var luckyIdx: int = this.pool.indexOf(this.luckyName);
			var totalTimes: int = 0;
			for each(var t: int in this.designedRollTimes) {
				totalTimes += t;
			}
			this.poolIndex = (luckyIdx + this.pool.length - (totalTimes % this.pool.length)) % this.pool.length;
			if(this.poolIndex < 0) {
				this.poolIndex = luckyIdx - this.poolIndex;
			}
			this.endCallback = callback;
			this.rollTimes.length = 0;
			if(delay > 0) {
				Laya.timer.once(delay, this, this.doRoll);
			} else {
				this.doRoll();
			}
			
		}
		
		private function doRoll(): void {
			this.tweenDrt = this.TweenDrtBase;
			this.tweenDrtState = SlotImage.StateSpeeding;
			this.startRollAt = this.changeStateAt = Browser.now();
			this.isRolling = true;
			
			this.getP(this.image1);
			this.tween = Tween.to(this.image1, {y: this.imgHeight}, this.tweenDrt, null, Handler.create(this, this.onTweenComplete, [this.image1, 1]), 0, true);
			this.tween.update = Handler.create(this, this.onTweenUpdate, [1], false);
			
			this.getP(this.image2);
		}
		
		private function onTweenComplete(img: Image, targetType: int): void {
			var now: Number = Browser.now();
			
			if(this.tweenDrtState == SlotImage.StateResult) {
				if((0 == targetType && img.name == this.luckyName) || (1 == targetType && this.image2.name == this.luckyName)) {
					this.isRolling = false;
					Tween.clearAll(this.image1);
					this.tween = null;
					this.endCallback.runWith([this.luckyName, this.index]);
					return;
				}
			}
			
			var oldTime: int = this.rollTimes[this.tweenDrtState - 1];
			if(undefined == oldTime) {
				oldTime = 0;
			}
			this.rollTimes[this.tweenDrtState - 1] = oldTime + 1;
			var timesout: Boolean = this.rollTimes[this.tweenDrtState - 1] >= this.designedRollTimes[this.tweenDrtState - 1];
			if(timesout && this.tweenDrtState < SlotImage.StateResult) {
				this.tweenDrtState++;
			}
			
			if(this.tweenDrtState == SlotImage.StateSpeeding) {
				this.tweenDrt -= (now - this.changeStateAt) / 100 * SlotImage.tweenDrtStep;
			}
			else if(this.tweenDrtState == SlotImage.StateHolding) {
				this.tweenDrt = this.TweenDrtMin;
			}
			else if(this.tweenDrtState == SlotImage.StateSlowing) {
				if(this.tweenDrt < this.TweenDrtMax) {
					this.tweenDrt += (now - this.changeStateAt) / 100 * SlotImage.tweenDrtStep;
				}
			}
			else if(this.tweenDrtState == SlotImage.StateResult) {
				this.tweenDrt = this.TweenDrtMax;
			}
			
			if(0 == targetType) {
				this.getP(this.image2);
				this.tween = Tween.to(img, {y: this.imgHeight}, this.tweenDrt, null, Handler.create(this, this.onTweenComplete, [img, 1]), 0, true);
			} else {
				img.y = -this.imgHeight;
				this.getP(img);
				this.tween = Tween.to(img, {y: 0}, this.tweenDrt, null, Handler.create(this, this.onTweenComplete, [img, 0]), 0, true);
			}
			this.tween.update = Handler.create(this, this.onTweenUpdate, [1 - targetType], false);
		}
		
		private function onTweenUpdate(targetType: int): void {
			if(0 == targetType) {
				this.image2.y = this.image1.y + this.imgHeight;
			} else {
				this.image2.y = this.image1.y - this.imgHeight;
			}
		}
		
		private function getP(img: Image): void {
			var poolLen: int = this.pool.length;
			if(this.poolIndex >= poolLen) {
				this.poolIndex = 0;
			}
			var p: String = this.pool[this.poolIndex];
			img.skin = 'p/' + p + '.jpg';
			img.name = p;
			if(++this.poolIndex >= poolLen) {
				this.poolIndex = 0;
			}
		}
		
		private function getDistance2Lucky(name: String): int {
			var lidx: int = this.pool.indexOf(Root.data.luckyList[this.index]);
			var nidx: int = this.pool.indexOf(name);
			if(lidx >= nidx) {
				return lidx - nidx;
			}
			return this.pool.length - nidx + lidx;
		}
	}
}