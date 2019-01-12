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
		private const TweenDrtMin: int = 200;
		private const TweenDrtMax: int = 2000;
		
		private static const StateNone: int = 0;
		private static const StateSpeeding: int = 1;
		private static const StateHolding: int = 2;
		private static const StateSlowing: int = 3;
		private static const StateResult: int = 4;
		
		private static const HoldingTime: int = 5000;
		private static const tweenDrtStep: int = 10;
		private static const ResultTime: int = 3000;
		
		private var tweenDrt: int = 500;
		private var tweenDrtState: int = 0;
		private var changeStateAt: Number = 0;
		
		private var poolIndex: int = 0;
		private var isRolling: Boolean = false;
		
		private var endCallback: Handler;
		
		public function SlotImage()
		{
			super();
		}
		
		public function init(ctn: Box): void {
			this.imgHeight = ctn.height;
			this.image1 = new Image();
			this.image1.size(ctn.width, ctn.height);
			ctn.addChild(this.image1);
			this.image2 = new Image();
			this.image2.size(ctn.width, ctn.height);
			ctn.addChild(this.image2);
			this.image1.skin = "p/default.jpg";
			this.image2.skin = "p/default.jpg";
		}
		
		public function reset(): void {
			this.image1.skin = "p/default.jpg";
			this.image2.skin = "p/default.jpg";
			this.image1.y = 0;
			this.image2.y = -this.imgHeight;
		}
		
		public function start(pool: Vector.<String>, callback: Handler): void {
			console.log(pool.join(','));
			this.pool = ArrayTool.disarrange(pool);
			this.endCallback = callback;
			
			this.tweenDrt = this.TweenDrtBase;
			this.tweenDrtState = SlotImage.StateSpeeding;
			this.changeStateAt = Browser.now();
			this.isRolling = true;
			
			this.getP(this.image1);
			Tween.to(this.image1, {y: this.imgHeight}, this.tweenDrt, null, Handler.create(this, this.onTweenComplete, [this.image1, 1, 1]));
			
			this.getP(this.image2);
			Tween.to(this.image2, {y: 0}, this.tweenDrt, null, Handler.create(this, this.onTweenComplete, [this.image2, 2, 0]));
		}
		
		private function onTweenComplete(img: Image, index: int, targetType: int): void {
			var now: Number = Browser.now();
			if(targetType == 0 && this.tweenDrtState == SlotImage.StateResult && now - this.changeStateAt >= SlotImage.ResultTime) {
				this.isRolling = false;
				Tween.clearAll(this.image1);
				Tween.clearAll(this.image2);
				this.endCallback.runWith(img.name);
				return;
			}
			
			if(index == 2) {
				if(this.tweenDrtState == SlotImage.StateSpeeding) {
					this.tweenDrt -= (now - this.changeStateAt) / 120 * SlotImage.tweenDrtStep;
					if(this.tweenDrt <= this.TweenDrtMin) {
						this.tweenDrtState = SlotImage.StateHolding;
						this.changeStateAt = now;
						console.log('StateHolding' + this.tweenDrt);
					}
				}
				else if(this.tweenDrtState == SlotImage.StateHolding) {
					if(now - this.changeStateAt >= SlotImage.HoldingTime) {
						this.tweenDrtState = SlotImage.StateSlowing;
						this.changeStateAt = now;
						console.log('StateSlowing: ' + this.tweenDrt);
					}
				}
				else if(this.tweenDrtState == SlotImage.StateSlowing) {
					this.tweenDrt += (now - this.changeStateAt) / 100 * SlotImage.tweenDrtStep;
					if(this.tweenDrt >= this.TweenDrtMax) {
						this.tweenDrtState = SlotImage.StateResult;
						this.changeStateAt = now;
						console.log('StateResult' + this.tweenDrt);
					}
				}
			}
			
			if(0 == targetType) {
				Tween.to(img, {y: this.imgHeight}, this.tweenDrt, null, Handler.create(this, this.onTweenComplete, [img, index, 1]));
			} else {
				img.y = -this.imgHeight;
				this.getP(img);
				Tween.to(img, {y: 0}, this.tweenDrt, null, Handler.create(this, this.onTweenComplete, [img, index, 0]));
			}
		}
		
		private function getP(img: Image): String {
			var p: String = this.pool[this.poolIndex];
			img.skin = 'p/' + p + '.jpg';
			img.name = p;
			if(++this.poolIndex >= this.pool.length) {
				this.poolIndex = 0;
			}
		}
	}
}