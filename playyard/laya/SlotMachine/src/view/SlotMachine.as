package view
{
	import laya.display.Node;
	import laya.display.Text;
	import laya.ui.Box;
	import laya.ui.Image;
	import laya.utils.Handler;

	public class SlotMachine
	{
		public static const GroupSize: int = 6;
		private const RollTimeGap: int = 3000;
		
		private var imgs: Vector.<SlotImage> = [] as Vector.<SlotImage>;
		private var pool: Vector.<String>;
		
		private var toRollCnt: int = 0;
		private var rolledCnt: int = 0;
		private var _isRolling: Boolean = false;
		
		private var endCallback: Handler;
		
		private var broadcast: Broadcast;
		
		public function SlotMachine()
		{
		}
		
		public function init(ctn: Box, textBroadcasts: Vector.<Text>, labaCtn: Node): void {
			this.pool = Root.data.users;
			for(var i: int = 0; i < SlotMachine.GroupSize; i++) {
				var imgCtn: Box = ctn.getChildByName('p' + i) as Box;
				var img: SlotImage = new SlotImage();
				img.init(i, imgCtn);
				this.imgs.push(img);
			}
			this.broadcast = new Broadcast();
			this.broadcast.init(textBroadcasts, labaCtn);
		}
		
		public function start(rollCnt: int, callback: Handler): void {
			this._isRolling = true;
			this.toRollCnt = rollCnt;
			this.rolledCnt = 0;
			this.endCallback = callback;
			
			this.broadcast.reset();
			for(var i: int = 0; i < SlotMachine.GroupSize; i++) {
				var img: SlotImage = this.imgs[i];
				img.reset();
				if(i < rollCnt) {
					img.start(this.pool, Handler.create(this, this.onRolleEnd), this.RollTimeGap * i);
				}
			}
		}
		
//		private function rollNext(): void {
//			var img: SlotImage = this.imgs[];
//			img.start(this.pool, Handler.create(this, this.onRolleEnd));
//		}
		
		private function onRolleEnd(name: String, index: int): void {
//			console.assert(Root.data.luckyListTotal.indexOf(name) < 0 && (Root.data.isGuest || Root.data.stList.indexOf(name) < 0));
			console.assert(Root.data.luckyList[index] == name);
//			Root.data.luckyList[index] = name;
//			var idx: int = this.pool.indexOf(name);
//			this.pool.splice(idx, 1);
			if(Root.data.isGuest || Root.data.bossList.indexOf(name) < 0) {
				Root.data.luckyCnt++;
			}
			if(Root.data.bossList.indexOf(name) >= 0) {
				Root.data.bossLuckyCnt++;
			}
			this.broadcast.addMsg('恭喜 ' + name + ' 上前抽奖');
			this.rolledCnt++;
			if(this.rolledCnt >= this.toRollCnt) {
				this._isRolling = false;
				this.endCallback.run();
			}
		}
		
		public function get isRolling(): Boolean {
			return this._isRolling;
		}
	}
}