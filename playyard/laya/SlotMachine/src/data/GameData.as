package data
{
	public class GameData
	{
		public var isGuest: Boolean = false;
		public var pswds: Vector.<String>;
		public var luckyCnt: int = 0;
		public var luckyCntTotal: int = 0; 
		public var users: Vector.<String> = [] as Vector.<String>;
		public var bossList: Vector.<String> = [] as Vector.<String>;
		public var stList: Vector.<String> = [] as Vector.<String>;
		public var luckyList: Vector.<String> = [] as Vector.<String>;
		public var luckyListTotal: Vector.<String> = [] as Vector.<String>;
		
		public function GameData()
		{
		}
		
		public function toString(): String {
			return this.isGuest + ', ' + this.luckyCntTotal + ', (' + this.users.length + ')[' + this.users.join(',') + '], (' + bossList.length + ')[' + bossList.join(',') + '], (' + stList.length + ')[' + stList.join(',') + ']';
		}
	}
}