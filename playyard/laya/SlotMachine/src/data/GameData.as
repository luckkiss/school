package data
{
	public class GameData
	{
		public var isGuest: Boolean = false;
		public var pswds: Vector.<String>;
		public var users: Vector.<String> = [] as Vector.<String>;
		public var bossList: Vector.<String> = [] as Vector.<String>;
		public var stList: Vector.<String> = [] as Vector.<String>;
		
		public function GameData()
		{
		}
		
		public function toString(): String {
			return 'isGuest = ' + this.isGuest + ', users = ' + this.users.join(',') + ', bossList = ' + bossList.join(',') + ', stList = ' + stList.join(',');
		}
	}
}