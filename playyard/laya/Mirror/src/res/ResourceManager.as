package res
{
	public class ResourceManager
	{
		public static var loadedFontArry:Array = [];
		
		public function ResourceManager()
		{
		}
		
		/**获取依赖资源列表*/
		public static function getDependResources(info:Object, uiArr:Array, fontArr:Array):void
		{
			var atlasBasePath:String = "res/atlas/";
			if ((info["skin"] && (String(info["skin"]).indexOf("ui/") >= 0 || String(info["skin"]).indexOf("comp/") >= 0)))
			{
				// 找出图集信息
				var real:String = String(info["skin"]);
				var tmpPath:String = atlasBasePath + real.slice(0, real.lastIndexOf("/")) + ".atlas";
				if (uiArr.indexOf(tmpPath) < 0)
					uiArr.push(tmpPath);
			}
			
			if (info["font"] && ResourceManager.loadedFontArry.indexOf(info["font"]) < 0 && fontArr.indexOf(String(info["font"])) < 0)
			{
				// 找出字体信息
				if (uiArr.indexOf(atlasBasePath + "bitmapFont.atlas") <= 0)
				{
					uiArr.push(atlasBasePath + "bitmapFont.atlas");
				}
				
				fontArr.push(String(info["font"]));
			}
			
			// 递归查找信息
			for (var key:String in info)
			{
				if (String(info[key]).indexOf("Object") >= 0)
				{
					getDependResources(info[key], uiArr, fontArr);
				}
			}
		}
	}
}