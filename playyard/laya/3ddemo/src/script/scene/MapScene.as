package script.scene
{	
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.SkyBox;
	import laya.d3.resource.models.SkyRenderer;
	import laya.display.Scene;
	import laya.utils.Handler;
	
	import script.common.CameraMoveScript;

	public class MapScene
	{
		/**设置单例的引用方式，方便其他类引用 */
		public static var instance: MapScene;
		
		private var scene: Scene3D;
		public function MapScene()
		{
//			this.loadScene('res/threeDimen/scene/TerrainScene/XunLongShi.ls', "res/threeDimen/skyBox/skyBox2/skyBox2.lmat");
		}
		
		public function loadScene(url: String, skyBox: String): void {
			Laya.loader.create(url, Handler.create(this, this.onLoadComplete, [url, skyBox]), null, Laya3D.HIERARCHY);
		}
		
		private function onLoadComplete(url: String, skyBox: String): void {
			this.scene = Laya.loader.getRes(url);
			Scene.root.addChild(this.scene);
			
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
			BaseMaterial.load(skyBox, Handler.create(null, function(mat:BaseMaterial):void {
				//camera.skyboxMaterial = mat;
				//获取相机的天空渲染器
				var skyRenderer:SkyRenderer = camera.skyRenderer;
				//创建天空盒的mesh
				skyRenderer.mesh = SkyBox.instance;
				//设置天空盒材质
				skyRenderer.material = mat;
			}));
			
			//开启雾化效果
			scene.enableFog = true;
			//设置雾化的颜色
			scene.fogColor = new Vector3(0,0,0.6);
			//设置雾化的起始位置，相对于相机的距离
			scene.fogStart = 10;
			//设置雾化最浓处的距离。
			scene.fogRange = 40;
		}
		
		public function destroy(): void {
			if(this.scene) {
				this.scene.destroy();
				this.scene = null;
			}
		}
	}
}