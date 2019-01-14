package view
{
	import laya.ui.Box;
	import laya.ui.Image;
	import laya.utils.Handler;

	public class SlotMachine
	{
		private const GroupSize: int = 6;
		private const RollTimeGap: int = 3000;
		
		private var imgs: Vector.<SlotImage> = [] as Vector.<SlotImage>;
		private var pool: Vector.<String>;
		
		private var rolledCnt: int = 0;
		private var _isRolling: Boolean = false;
		
		private var endCallback: Handler;
		
		public function SlotMachine()
		{
		}
		
		public function init(ctn: Box): void {
			this.pool = Root.data.users;
			for(var i: int = 0; i < this.GroupSize; i++) {
				var imgCtn: Box = ctn.getChildByName('p' + i) as Box;
				var img: SlotImage = new SlotImage();
				img.init(imgCtn);
				this.imgs.push(img);
			}
		}
		
		public function start(callback: Handler): void {
			this._isRolling = true;
			this.rolledCnt = 0;
			this.endCallback = callback;
			for(var i: int = 0; i < this.GroupSize; i++) {
				var img: SlotImage = this.imgs[i];
				img.reset();
				img.start(this.pool, Handler.create(this, this.onRolleEnd), this.RollTimeGap * i);
			}
		}
		
//		private function rollNext(): void {
//			var img: SlotImage = this.imgs[];
//			img.start(this.pool, Handler.create(this, this.onRolleEnd));
//		}
		
		private function onRolleEnd(name: String): void {
			Root.data.luckyList.push(name);
			Root.data.luckyListTotal.push(name);
			var idx: int = this.pool.indexOf(name);
			this.pool.splice(idx, 1);
			this.rolledCnt++;
			if(this.rolledCnt >= this.GroupSize) {
				this._isRolling = false;
				this.endCallback.run();
			}
		}
		
		public function get isRolling(): Boolean {
			return this._isRolling;
		}
	}
}