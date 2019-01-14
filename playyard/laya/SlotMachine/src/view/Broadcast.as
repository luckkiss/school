package view
{
	import laya.display.Animation;
	import laya.display.Node;
	import laya.display.Text;
	import laya.utils.Handler;
	import laya.utils.Tween;

	public class Broadcast
	{
		private const PosTop: int = -100;
		private const PosBottom: int = 120;
		private const TweenDuration: int = 1000;
		
		private var textPool: Vector.<Text>;
		private var crtTexts: Vector.<Text> = [] as Vector.<Text>;
		private var compPosYs: Vector.<Number> = [] as Vector.<Number>;
		
		private var maxShowCnt: int = 0;
		private var textWidth: Number;
		private var textHeight: Number;
		private var textX: Number;
		private var textParent: Node;
		private var textColor: String;
		private var textFontSize: int;
		
		private var newText: Text;
		
		private var labaAni: Animation;
		
		public function Broadcast()
		{
		}
		
		public function init(textComps: Vector.<Text>, labaCtn: Node): void {
			this.maxShowCnt = textComps.length;
			this.compPosYs.push(this.PosTop);
			this.textPool = textComps;
			for each(var textComp: Text in textComps) {
				textComp.visible = false;
				this.compPosYs.push(textComp.y);
			}
			this.compPosYs.push(this.PosBottom);
			
			var oneText: Text = textComps[0];
			this.textWidth = oneText.width;
			this.textHeight = oneText.height;
			this.textX = oneText.x;
			this.textParent = oneText.parent;
			this.textColor = oneText.color;
			this.textFontSize = oneText.fontSize;
			
			this.labaAni = new Animation();
			this.labaAni.interval = 100;
			this.labaAni.loadAtlas('res/atlas/eff/laba.atlas');
			labaCtn.addChild(this.labaAni);
		}
		
		public function reset(): void {
			for(var i: int = 0; i < this.crtTexts.length; i++) {
				var textComp: Text = this.crtTexts[i];
				textComp.visible = false;
				Tween.clearAll(textComp);
				this.textPool.push(textComp);
			}
			this.crtTexts.length = 0;
		}
		
		public function addMsg(msg: String): void {
			var textComp: Text;
			var crtLen: int = this.crtTexts.length;
			if(crtLen < this.maxShowCnt) {
				textComp = this.getOneText(msg);
				(textComp as Object).pos = crtLen + 1;
				Tween.to(textComp, {y: this.compPosYs[crtLen + 1]}, this.TweenDuration, null, Handler.create(this, this.onTweenEnd, [textComp]), 0, true);
			} else {				
				for(var i: int = 0; i < this.crtTexts.length; i++) {
					textComp = this.crtTexts[i];
					var tpos: int = (textComp as Object).pos;
					if(tpos > 0) {
						(textComp as Object).pos = tpos - 1;
						Tween.to(textComp, {y: this.compPosYs[tpos - 1]}, this.TweenDuration, null, Handler.create(this, this.onTweenEnd, [textComp]), 0, true);
					}
				}
				textComp = this.getOneText(msg);
				(textComp as Object).pos = this.maxShowCnt;
				Tween.to(textComp, {y: this.compPosYs[this.maxShowCnt]}, this.TweenDuration, null, Handler.create(this, this.onTweenEnd, [textComp]), 0, true);
			}
			this.labaAni.play(0, false);
		}
		
		private function onTweenEnd(text: Text): void {
			if((text as Object).pos == 0) {
				var idx: int = this.crtTexts.indexOf(text);
				if(idx >= 0) {
					this.crtTexts.splice(idx, 1);
				}
				this.textPool.push(text);
			}
		}
		
		private function getOneText(msg: String): Text {
			var text: Text;
			if(this.textPool.length > 0) {
				text = this.textPool.shift();
			} else {
				text = new Text();
				text.size(this.textWidth, this.textHeight);
				text.x = this.textX;
				text.color = this.textColor;
				text.fontSize = this.textFontSize;
				this.textParent.addChild(text);
			}
			text.y = 120;
			text.text = msg;
			text.visible = true;
			this.crtTexts.push(text);
			return text;
		}
	}
}