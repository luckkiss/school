package script.unit
{
	import laya.d3.core.Sprite3D;
	import laya.d3.math.Vector3;
	import laya.utils.Handler;
	
	import script.scene.MapScene;

	public class UnitController
	{
		public var model: Sprite3D;
		
		public function UnitController()
		{
		}
		
		public function loadModel(onLoaded: Handler = null): void {
			//加载精灵
			Sprite3D.load("res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh", Handler.create(null, function(sp){
				model = MapScene.instance.scene.addChild(sp);
				model.transform.localScale = new Vector3(1, 1, 1);
				model.transform.localPosition = new Vector3(-11, 8, 0);
				
				if(onLoaded) {
					onLoaded.run();
				}
			}));
		}
	}
}