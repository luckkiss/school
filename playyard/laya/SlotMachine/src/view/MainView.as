package view {
	import laya.display.Animation;
	import laya.events.Event;
	import laya.ui.Component;
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
		private var lightAni1: Animation;
		private var lightAni2: Animation;
		
		public function MainView() {
			
			for each(var aniName: String in this.aniNames) {
				var ani: Animation = new Animation();
				ani.interval = 120;
				ani.loadAtlas('res/atlas/eff/' + aniName + '.atlas'); 
				ani.play();
				ani.visible = false;
				this[aniName].addChild(ani);
				this.anis.push(ani);
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
			
			this.slotMachinePosBottom = this.slotmachine.bottom;
			this.machine = new SlotMachine();
			this.machine.init(this.slotmachine);
			this.slotmachine.visible = false;
			
			this.pop.visible = false;
			this.listLucky.itemRender = LuckyItem;
			this.listLucky.renderHandler = Handler.create(this, this.onRenderListLucky, null, false);
			
			this.maskLayer = new Component();
			this.pop.addChildAt(this.maskLayer, 0);
			
			this.loginCtn.visible = true;
			this.inputPswd.text = Root.data.pswds[0];
			
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
//				console.log(Root.data.toString());
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
			} 
		}
		
		private function onClickBtnGo(e: Event): void {
			if(this.machine.isRolling) {
				return;
			}
			Root.data.luckyList.length = 0;
			this.machine.start(Handler.create(this, this.onEndRoll));
			this.btnGo.scaleY = -1;
		}
		
		private function onEndRoll(): void {
			this.btnGo.scaleY = 1;
			
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
			this.pop.visible = false;
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