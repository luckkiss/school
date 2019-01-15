package view {
	import laya.display.Animation;
	import laya.display.Text;
	import laya.events.Event;
	import laya.ui.Box;
	import laya.ui.Component;
	import laya.ui.Image;
	import laya.utils.Ease;
	import laya.utils.Handler;
	import laya.utils.Tween;
	
	import ui.MainViewUI;
	
	public class MainView extends MainViewUI {
		private var machine: SlotMachine;
		private var slotMachinePosBottom: int;
		
		private var maskLayer: Component;
		
		private const aniNames: Vector.<String> = ['biao1', 'moby1', 'sj', 'yuntian'] as Vector.<String>;
		private var anis: Vector.<Animation> = new Vector.<Animation>();
		private var talks: Vector.<Image> = new Vector.<Image>();
		private var lightAni1: Animation;
		private var lightAni2: Animation;
		
		private var crtRound: int = 0;
		
		public function MainView() {
			
			this.textVersion.text = '版本号：' + GameConfig.version;
			this.textRound.text = '';
			
			for each(var aniName: String in this.aniNames) {
				var ani: Animation = new Animation();
				ani.interval = 120;
				ani.loadAtlas('res/atlas/eff/' + aniName + '.atlas'); 
				ani.visible = false;
				this[aniName].addChildAt(ani, 0);
				this.anis.push(ani);
				
				var imgTalk: Image = this[aniName].getChildByName('imgTalk');
				imgTalk.visible = false;
				this.talks.push(imgTalk);
			}
			
			this.lightAni1 = new Animation();
			this.lightAni1.interval = 100;
			this.lightAni1.loadAtlas('res/atlas/eff/light.atlas'); 
			this.lightAni1.play();
			this.lightCtn1.addChild(this.lightAni1);
			this.lightAni2 = new Animation();
			this.lightAni2.interval = 100;
			this.lightAni2.loadAtlas('res/atlas/eff/light.atlas'); 
			this.lightAni2.play();
			this.lightCtn2.addChild(this.lightAni2);
			
			var textBroadcasts: Vector.<Text> = [this.textBroadcast1, this.textBroadcast2] as Vector.<Text>;
			this.slotMachinePosBottom = this.slotmachine.bottom;
			this.machine = new SlotMachine();
			this.machine.init(this.slotmachine as Box, textBroadcasts, this.labaCtn);
			this.slotmachine.visible = false;
			
			this.pop.visible = false;
			this.listLucky.itemRender = LuckyItem;
			this.listLucky.renderHandler = Handler.create(this, this.onRenderListLucky, null, false);
			
			this.maskLayer = new Component();
			this.pop.addChildAt(this.maskLayer, 0);
			
			this.loginCtn.visible = true;
//			this.inputPswd.text = Root.data.pswds[1];
			
			this.btnLogin.on(Event.CLICK, this, this.onClickBtnLogin);
			this.btnGo.on(Event.CLICK, this, this.onClickBtnGo);
			
			this.maskLayer.on(Event.CLICK, this, this.onClickMaskLayer);
			Laya.stage.on(Event.RESIZE, this, _onResize);
			_onResize();
		}
		
		private function onClickBtnLogin(e: Event): void {
			var pswd: String = this.inputPswd.text;
			var pswdIdx: int = Root.data.pswds.indexOf(pswd);
			if(pswdIdx >= 0) {
				Root.data.isGuest = pswdIdx > 0;
				if(Root.data.isGuest) {
					Root.data.luckyCntTotal = Root.data.users.length;
				}
				console.log(Root.data.toString());
				this.loginCtn.visible = false;
				this.slotmachine.bottom = -800;
				this.slotmachine.visible = true;
				Tween.to(this.slotmachine, {bottom: this.slotMachinePosBottom}, 1000, Ease.bounceOut);
				for each(var ani: Animation in this.anis) {
					ani.visible = true;
				}
				this.move_biao1.play(0, false);
				this.move_moby1.play(0, false);
				this.move_yuntian.play(0, false);
				this.move_sj.play(0, false);
				
				Laya.timer.loop(5000, this, this.onTick);
			} 
		}
		
		private function onClickBtnGo(e: Event): void {
			if(this.machine.isRolling) {
				return;
			}
			var leftLucky: int = Root.data.luckyCntTotal - Root.data.luckyCnt;
			if(leftLucky > 0) {
				this.crtRound++;
				this.textRound.text = '第 ' + this.crtRound + ' 轮';
				
				Root.data.luckyList.length = 0;
				this.machine.start(leftLucky, Handler.create(this, this.onEndRoll));
				this.btnGo.scaleY = -1;
			}
		}
		
		private function onEndRoll(): void {
			Laya.timer.once(2000, this, this.onRollEndDelay);
		}
		
		private function onRollEndDelay(): void {
			this.listLucky.array = Root.data.luckyList as Array;
			this.popBg.scaleX = 0.1;
			this.popBg.scaleY = 0.1;
			Tween.to(this.popBg, {scaleX: 1, scaleY: 1}, 1000, Ease.bounceOut);
			this.pop.visible = true;
		}
		
		private function onRenderListLucky(cell: LuckyItem, index: int): void {
			cell.update(this.listLucky.getItem(index) as String);
		}
		
		private function onClickMaskLayer(e: Event): void {
			Tween.to(this.popBg, {scaleX: 0.1, scaleY: 0.1}, 500, Ease.bounceIn, Handler.create(this, this.onPopTweenEnd));
		}
		
		private function onPopTweenEnd(): void {
			this.pop.visible = false;
			this.btnGo.scaleY = 1;
		}
		
		private function onTick(): void {
			this.playRole(Math.floor(Math.random() * this.anis.length));
		}
		
		private function playRole(index: int): void {
			this.anis[index].play(0);
			this.talks[index].visible = true;
			Laya.timer.once(3000, this, this.onPlayRoleEnd, [index], false);
		}
		
		private function onPlayRoleEnd(index: int): void {
			this.anis[index].stop();
			this.talks[index].visible = false;
		}
		
		private function _onResize(e: Event = null):void
		{
			this.maskLayer.width = Laya.stage.width;
			this.maskLayer.height = Laya.stage.height;
			this.maskLayer.graphics.clear();
			this.maskLayer.graphics.drawRect(0, 0, Laya.stage.width, Laya.stage.height, UIConfig.popupBgColor);
			this.maskLayer.alpha = UIConfig.popupBgAlpha;
		}
	}
}