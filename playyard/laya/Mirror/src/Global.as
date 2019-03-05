package
{
	import data.ConfigManager;
	import data.GuideData;
	
	import view.UIManager;

	public class Global
	{
		public static const cfgMgr: ConfigManager = new ConfigManager();
		public static const guideData: GuideData = new GuideData();
		
		public static const uiMgr: UIManager = new UIManager();
		
		public function Global()
		{
		}
	}
}