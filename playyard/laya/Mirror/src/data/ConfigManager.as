package data
{
	import laya.net.Loader;
	import laya.utils.Handler;

	public class ConfigManager
	{
		public var onLoaded: Handler;
		public var isReady: Boolean = false;
		
		public function ConfigManager()
		{
		}
		
		public function loadConfigs(onLoaded: Handler): void {
			Laya.loader.load([{url: 'res/data/guide.json', type: Loader.JSON}], onLoaded);
		}
	}
}