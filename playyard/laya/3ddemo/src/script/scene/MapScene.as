package script.scene
{	
	import PathFinding.core.Grid;
	import PathFinding.core.Heuristic;
	
	import laya.d3.component.PathFind;
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.MeshTerrainSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.math.Ray;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.physics.HitResult;
	import laya.d3.physics.PhysicsCollider;
	import laya.d3.physics.shape.MeshColliderShape;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SkyBox;
	import laya.d3.resource.models.SkyRenderer;
	import laya.display.Node;
	import laya.display.Scene;
	import laya.events.Event;
	import laya.events.MouseManager;
	import laya.net.Loader;
	import laya.utils.Handler;
	import laya.webgl.resource.BaseTexture;
	import laya.webgl.resource.Texture2D;
	
	import script.common.CameraMoveScript;
	import script.unit.UnitController;
	import script.unit.UnitFollower;

	public class MapScene
	{
		/**设置单例的引用方式，方便其他类引用 */
		public static var instance: MapScene;
		private var unitCtrl: UnitController;
		
		public var scene: Scene3D;
		
		public var ray: Ray = new Ray(new Vector3(0, 0, 0), new Vector3(0, 0, 0));
		private var point: Vector2 = new Vector2();
		private var hitResult: HitResult = new HitResult();
		private var camera:Camera;
		public var pathFingding:PathFind;
		public var terrainSprite: MeshTerrainSprite3D;
		
		private var url: String;
		private var skyBoxUrl: String;
		private var heightMapUrl: String;
		private var astarMapUrl: String;
		
		private var isCreateComplete: Boolean;
		private var isLoadComplete: Boolean;
		
		public function MapScene()
		{
//			this.loadScene('res/threeDimen/scene/TerrainScene/XunLongShi.ls', "res/threeDimen/skyBox/skyBox2/skyBox2.lmat");
			Laya3D._enbalePhysics = true;
		}
		
		public function loadScene(url: String, skyBoxUrl: String, heightMapUrl: String, astarMapUrl: String): void {
			this.url = url;
			this.skyBoxUrl = skyBoxUrl;
			this.heightMapUrl = heightMapUrl;
			this.astarMapUrl = astarMapUrl;
			
			this.isCreateComplete = false;
			this.isLoadComplete = false;
			
			Laya.loader.create([url, skyBoxUrl], Handler.create(this, this.onCreateComplete));
			Laya.loader.create([heightMapUrl, astarMapUrl], Handler.create(this, this.onLoadComplete), null, null, [0, 0, 1, true, true]);
		}
		
		private function onCreateComplete(): void {
			this.isCreateComplete = true;
			this.buildScene();
		}		
		
		private function onLoadComplete(): void {
			this.isLoadComplete = true;
			this.buildScene();
		}
		
		private function buildScene(): void {
			if(!this.isCreateComplete || !this.isLoadComplete || scene) {
				return;
			}
			
			this.scene = Laya.loader.getRes(url);
			Scene.root.addChild(this.scene);
			
			//获取摄像机
			camera = scene.getChildByName("Main Camera") as Camera;
			//清除摄像机的标记
			camera.clearFlag = BaseCamera.CLEARFLAG_SKY;
			//加入摄像机移动控制脚本
//			camera.addComponent(CameraMoveScript);
			
			//添加光照
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
			directionLight.color = new Vector3(1, 1, 1);
			directionLight.transform.rotate(new Vector3( -3.14 / 3, 0, 0));
			
			//材质加载        
			BaseMaterial.load(skyBoxUrl, Handler.create(null, function(mat:BaseMaterial):void {
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
			
			unitCtrl = new UnitController();
			unitCtrl.loadModel(Handler.create(this, this.onHeroLoaded));
			
			//获取可行走区域模型
			var meshSprite3D:MeshSprite3D = scene.getChildByName('Scenes').getChildByName('HeightMap') as MeshSprite3D;
			//使可行走区域模型隐藏
//			meshSprite3D.active = false;
			var meshCollider: PhysicsCollider = meshSprite3D.addComponent(PhysicsCollider);
			var meshShape: MeshColliderShape = new MeshColliderShape();
			meshShape.mesh = meshSprite3D.meshFilter.sharedMesh as Mesh;
			meshCollider.colliderShape = meshShape;
			
			var heightMap:Texture2D = Loader.getRes(heightMapUrl) as Texture2D;
			//初始化MeshTerrainSprite3D
			terrainSprite = MeshTerrainSprite3D.createFromMeshAndHeightMap(meshSprite3D.meshFilter.sharedMesh as Mesh, heightMap, 6.574996471405029, 10.000000953674316);
			//更新terrainSprite世界矩阵(为可行走区域世界矩阵)
			terrainSprite.transform.worldMatrix = meshSprite3D.transform.worldMatrix;
			
			//给terrainSprite添加PathFind组件
			pathFingding = terrainSprite.addComponent(PathFind) as PathFind;
			pathFingding.setting = {allowDiagonal: true, dontCrossCorners: false, heuristic: Heuristic.manhattan, weight: 1};
			var aStarMap:Texture2D = Loader.getRes(astarMapUrl) as Texture2D;
			pathFingding.grid = Grid.createGridFromAStarMap(aStarMap);
			
			Laya.stage.on(Event.CLICK, this, this.onClickStage);
			
//			Sprite3D.load("res/Laya/204081.lh", Handler.create(null, function(sp){
//				var model: Sprite3D = MapScene.instance.scene.addChild(sp);
//				model.transform.localScale = new Vector3(0.5, 0.5, 0.5);
//				model.transform.localPosition = new Vector3(-12, 10, 0);
//			}));
		}
		
		private function onHeroLoaded(): void {
			var follower: UnitFollower = camera.addComponent(UnitFollower);
			follower.target = unitCtrl.model;
		}
		
		private function onClickStage(): void {
			point.x = MouseManager.instance.mouseX;
			point.y = MouseManager.instance.mouseY;
			camera.viewportPointToRay(point, ray);
			
			scene.physicsSimulation.rayCast(ray, hitResult);
			if(hitResult.succeeded) {
//				unitCtrl.model.transform.position = hitResult.point;
				unitCtrl.moveTo(hitResult.point);
//				var cameraPos: Vector3 = new Vector3(hitResult.point.x, hitResult.point.y + 8, hitResult.point.z - 12);
//				camera.transform.localPosition = cameraPos;
//				console.log('raycast at: ' + hitResult.point.toString());
			} 
		}
		
		public function destroy(): void {
			if(this.scene) {
				this.scene.destroy();
				this.scene = null;
			}
		}
	}
}