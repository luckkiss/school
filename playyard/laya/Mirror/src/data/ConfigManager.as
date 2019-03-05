package data
{
	import laya.utils.Handler;

	public class ConfigManager
	{
		public var onLoaded: Handler;
		public var isReady: Boolean = false;
		
		public function ConfigManager()
		{
		}
		
		public function loadConfigs(onLoaded: Handler): void {
			Laya.loader.load('res/data/guide.json', onLoaded);
		}
	}
}