package script.common {
	import laya.d3.component.Script3D;
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.events.Event;
	import laya.events.KeyBoardManager;
	
	/**
	 * ...
	 * @author
	 */
	public class CameraMoveScript extends Script3D {
		
		/** @private */
		protected var _tempVector3:Vector3 = new Vector3();
		protected var lastMouseX:Number;
		protected var lastMouseY:Number;
		protected var yawPitchRoll:Vector3 = new Vector3();
		protected var resultRotation:Quaternion = new Quaternion();
		protected var tempRotationZ:Quaternion = new Quaternion();
		protected var tempRotationX:Quaternion = new Quaternion();
		protected var tempRotationY:Quaternion = new Quaternion();
		protected var isMouseDown:Boolean;
		protected var rotaionSpeed:Number = 0.00006;
		protected var camera:BaseCamera;
		protected var scene:Scene3D;
		
		public function CameraMoveScript() {
			
		}
		
		/**
		 * @private
		 */
		protected function _updateRotation():void {
			if (Math.abs(yawPitchRoll.y) < 1.50) {
				Quaternion.createFromYawPitchRoll(yawPitchRoll.x, yawPitchRoll.y, yawPitchRoll.z, tempRotationZ);
				tempRotationZ.cloneTo(camera.transform.localRotation);
				camera.transform.localRotation = camera.transform.localRotation;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onAwake():void {
			Laya.stage.on(Event.MOUSE_DOWN, this, mouseDown);
			Laya.stage.on(Event.MOUSE_UP, this, mouseUp);
			//Laya.stage.on(Event.RIGHT_MOUSE_OUT, this, mouseOut);
			camera = owner as Camera;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onUpdate():void {
			var elapsedTime:Number = Laya.timer.delta;
			if (!isNaN(lastMouseX) && !isNaN(lastMouseY) && isMouseDown) {
				var scene:Scene3D = owner.scene;
				KeyBoardManager.hasKeyDown(87) && moveForward(-0.01 * elapsedTime);//W
				KeyBoardManager.hasKeyDown(83) && moveForward(0.01 * elapsedTime);//S
				KeyBoardManager.hasKeyDown(65) && moveRight(-0.01 * elapsedTime);//A
				KeyBoardManager.hasKeyDown(68) && moveRight(0.01 * elapsedTime);//D
				KeyBoardManager.hasKeyDown(81) && moveVertical(0.01 * elapsedTime);//Q
				KeyBoardManager.hasKeyDown(69) && moveVertical(-0.01 * elapsedTime);//E
				
				var offsetX:Number = Laya.stage.mouseX - lastMouseX;
				var offsetY:Number = Laya.stage.mouseY - lastMouseY;
				
				var yprElem:Vector3 = yawPitchRoll;
				yprElem.x -= offsetX * rotaionSpeed * elapsedTime;
				yprElem.y -= offsetY * rotaionSpeed * elapsedTime;
				_updateRotation();
			}
			lastMouseX = Laya.stage.mouseX;
			lastMouseY = Laya.stage.mouseY;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onDestroy():void {
			Laya.stage.off(Event.MOUSE_DOWN, this, mouseDown);
			Laya.stage.off(Event.MOUSE_UP, this, mouseUp);
			//Laya.stage.off(Event.RIGHT_MOUSE_OUT, this, mouseOut);
		}
		
		protected function mouseDown(e:Event):void {
			camera.transform.localRotation.getYawPitchRoll(yawPitchRoll);
			
			lastMouseX = Laya.stage.mouseX;
			lastMouseY = Laya.stage.mouseY;
			isMouseDown = true;
		}
		
		protected function mouseUp(e:Event):void {
			isMouseDown = false;
		}
		
		protected function mouseOut(e:Event):void {
			isMouseDown = false;
		}
		
		/**
		 * 向前移动。
		 * @param distance 移动距离。
		 */
		public function moveForward(distance:Number):void {
			_tempVector3.x = _tempVector3.y = 0;
			_tempVector3.z = distance;
			camera.transform.translate(_tempVector3);
			console.log(camera.transform.localPosition.toString());
		}
		
		/**
		 * 向右移动。
		 * @param distance 移动距离。
		 */
		public function moveRight(distance:Number):void {
			_tempVector3.y = _tempVector3.z = 0;
			_tempVector3.x = distance;
			camera.transform.translate(_tempVector3);
			console.log(camera.transform.localPosition.toString());
		}
		
		/**
		 * 向上移动。
		 * @param distance 移动距离。
		 */
		public function moveVertical(distance:Number):void {
			_tempVector3.x = _tempVector3.z = 0;
			_tempVector3.y = distance;
			camera.transform.translate(_tempVector3, false);
			console.log(camera.transform.localPosition.toString());
		}
	
	}

}