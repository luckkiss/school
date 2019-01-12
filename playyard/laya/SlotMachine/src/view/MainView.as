package view {
	import laya.events.Event;
	import laya.ui.Box;
	import laya.ui.Label;
	import laya.utils.Handler;
	import laya.utils.Tween;
	
	import ui.MainViewUI;
	
	public class MainView extends MainViewUI {
		private var machine: SlotMachine;
		
		public function MainView() {
			this.playCtn.visible = false;
			
			this.machine = new SlotMachine();
			this.machine.init(this.slotmachine);
			
			this.loginCtn.visible = true;
			this.inputUser.text = 'teppei';
			this.inputPswd.text = Root.data.pswds[0];
			this.btnLogin.on(Event.CLICK, this, this.onClickBtnLogin);
			
			this.btnGo.on(Event.CLICK, this, this.onClickBtnGo);
		}
		
		private function onClickBtnLogin(e: Event): void {
			var user: String = this.inputUser.text;
			if(!user) {
				return;
			}
			var pswd: String = this.inputPswd.text;
			var pswdIdx: int = Root.data.pswds.indexOf(pswd);
			if(pswdIdx >= 0) {
				Root.data.isGuest = pswdIdx > 0;
				console.log(Root.data.toString());
				this.loginCtn.visible = false;
				this.playCtn.visible = true;
			} 
		}
		
		private function onClickBtnGo(e: Event): void {
			if(this.machine.isRolling) {
				return;
			}
			this.machine.start(Handler.create(this, this.onEndRoll));
			this.btnGo.scaleY = -1;
		}
		
		private function onEndRoll(): void {
			this.btnGo.scaleY = 1;
		}
	}
}