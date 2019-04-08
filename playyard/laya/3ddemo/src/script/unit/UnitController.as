package script.unit
{
	import laya.d3.component.Animator;
	import laya.d3.component.AnimatorState;
	import laya.d3.core.Sprite3D;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.display.Animation;
	import laya.utils.Handler;
	
	import script.scene.MapScene;
	import script.tween.TweenPath;

	public class UnitController
	{
		public var model: Sprite3D;
		private var _tweenPath: TweenPath;
		private var speed: Number = 0.5;
		
		public function UnitController()
		{
			_tweenPath = new TweenPath();
		}
		
		public function loadModel(onLoaded: Handler = null): void {
			//加载精灵
			Sprite3D.load("res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh", Handler.create(null, function(sp){
				model = MapScene.instance.scene.addChild(sp);
				model.transform.localScale = new Vector3(0.5, 0.5, 0.5);
				model.transform.localPosition = new Vector3(-11, 8, 0);
//				var qtn: Quaternion = new Quaternion();
//				Quaternion.createFromYawPitchRoll(180, 0, 0, qtn);
//				model.transform.localRotation = qtn;
				
				var aniSprite3d: Sprite3D = model.getChildAt(0) as Sprite3D;
				aniSprite3d.transform.rotate(new Vector3(0, 180, 0), false, false);
				var animator: Animator = aniSprite3d.getComponent(Animator) as Animator;
				var state: AnimatorState = new AnimatorState();
				state.name = 'run';
				state.clipStart = 40 / 150;
				state.clipEnd = 70 / 150;
				state.clip = animator.getDefaultState().clip;
				animator.addState(state);
				animator.play('run');
				
				if(onLoaded) {
					onLoaded.run();
				}
			}));
		}
		
		public function moveTo(pos: Vector3): void {
			var curPos: Vector3 = model.transform.position;
			var path: Array = MapScene.instance.pathFingding.findPath(curPos.x, curPos.z, pos.x, pos.z);
			if(path) {
				var vecArr: Vector.<Vector3> = [] as Vector.<Vector3>;
				var plen: int = path.length;
				for(var i: int = (1 == plen ? 0 : 1); i < plen; i++) {
					var px: Number = path[i][0];
					var pz: Number = path[i][1];
					var py: Number = MapScene.instance.terrainSprite.getHeight(px, pz);
					if(isNaN(py)) {
						py = curPos.y;
					}
					vecArr.push(new Vector3(px, py, pz));
				}
				_tweenPath.begin(this.model, this.model, speed, vecArr, 0, 0, 0);
//				this._tweenPath.onFinished = Handler.create(this, this.onTweenPathFinished, null, false);
//				this.changeState(UnitState.Move);
			}
		}
	}
}