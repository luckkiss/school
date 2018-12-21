package {
	import data.MallData;
	
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.models.BoxMesh;
	import laya.display.Stage;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.wx.mini.MiniAdpter;

	public class Root {
		
		public function Root() {
			//初始化微信小游戏
			MiniAdpter.init();
			//初始化引擎
			Laya3D.init(0, 0,true);
			
			//适配模式
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;

			//开启统计信息
			Stat.show();
			
			//添加3D场景
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			//添加照相机
			var camera:Camera = (scene.addChild(new Camera( 0, 0.1, 100))) as Camera;
			camera.transform.translate(new Vector3(0, 3, 3));
			camera.transform.rotate(new Vector3( -30, 0, 0), true, false);
			camera.clearColor = null;

			//添加方向光
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
			directionLight.color = new Vector3(0.6, 0.6, 0.6);
			directionLight.direction = new Vector3(1, -1, 0);

			//添加自定义模型
			var box:MeshSprite3D = scene.addChild(new MeshSprite3D(new BoxMesh(1,1,1))) as MeshSprite3D;
			box.transform.rotate(new Vector3(0,45,0),false,false);
			var material:StandardMaterial = new StandardMaterial();
			material.diffuseTexture = Texture2D.load("res/layabox.png");
			box.meshRender.material = material;
			
			// 加载一个json文件，加载完成后会执行回调onLoadMallData
			Laya.loader.load('res/data/mall.json', Handler.create(this, onLoadMallData));
		}
		
		private function onLoadMallData(): void {
			// 根据文件路径获取文件内容，json文件属于文本文件，其内容自然是文本
			var mallDataContent: String = Laya.loader.getRes('res/data/mall.json');
			
			// JSON.parse可以将文本解析为一个JSON结构的Object
			var mallDataJson: Object = JSON.parse(mallDataContent);
			
			console.log('mall.json的数据为：');
			console.log(mallDataJson);
			
			// 访问mallDataJson
			console.log('一共有' + mallDataJson.items.length + '件商品');
			
			// 为了方便写代码，防止将json中的键写错，我们可以写一个类来描述json的结构
			// 然后将json当做这个类的实例来使用，要注意，as只是一种欺骗浏览器的方法
			var mallData: MallData = mallDataJson as MallData;
			console.log('店铺名字为：' + mallData.name);
			// 由于items是Vector.<MallItemData>类型的数组，所以编辑器知道mallData.items[0]是一个MallItemData
			// 故可以直接提示price属性
			console.log('第一个商品价格为：' + mallData.items[0].price);
		}
	}
}