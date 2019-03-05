package data
{
	public class GuideData
	{
		public var rootNode: GuideNode;
		
		public function GuideData()
		{
		}
		
		public function onCfgReady(): void {
			this.rootNode = Laya.loader.getRes('guide.json') as GuideNode;
		}
	}
}