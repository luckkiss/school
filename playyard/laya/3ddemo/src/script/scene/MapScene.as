package script.scene
{
	import common.CameraMoveScript;
	
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.SkyBox;
	import laya.d3.resource.models.SkyRenderer;
	import laya.utils.Handler;

	public class MapScene
	{
		private var scene: Scene3D;
		public function MapScene()
		{
			this.loadScene('res/threeDimen/scene/TerrainScene/XunLongShi.ls');
		}
		
		public function loadScene(url: String): void {
			Laya.loader.create(url, Handler.create(this, this.onLoadComplete, [url]), null, Laya3D.HIERARCHY);
		}
		
		private function onLoadComplete(url: String): void {
			this.scene = Laya.loader.getRes(url);
			Laya.stage.addChild(this.scene);
			
			//获取摄像机
			var camera:Camera = scene.getChildByName("Main Camera") as Camera;
			//清除摄像机的标记
			camera.clearFlag = BaseCamera.CLEARFLAG_SKY;
			//加入摄像机移动控制脚本
			camera.addComponent(CameraMoveScript);
			//添加光照
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
			directionLight.color = new Vector3(1, 1, 1);
			directionLight.transform.rotate(new Vector3( -3.14 / 3, 0, 0));
			
			//材质加载        
			BaseMaterial.load("res/threeDimen/skyBox/skyBox2/skyBox2.lmat", Handler.create(null, function(mat:BaseMaterial):void {
				//camera.skyboxMaterial = mat;
				//获取相机的天空渲染器
				var skyRenderer:SkyRenderer = camera.skyRenderer;
				//创建天空盒的mesh
				skyRenderer.mesh = SkyBox.instance;
				//设置天空盒材质
				skyRenderer.material = mat;
			}));
		}
	}
}