package data
{
	import laya.display.Sprite;

	public class GuideNode
	{
		public var desc: String;
		public var detail: String;
		
		public var children: Vector.<GuideNode>;
		public var interfaces: Vector.<InterfaceNode>;
		public var cases: Vector.<String>;
		
		public var ui: Sprite;
		public var parent: GuideNode;
		
		public function GuideNode()
		{
		}
	}
}