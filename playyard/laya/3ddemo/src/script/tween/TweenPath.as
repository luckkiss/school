package script.tween
{
	import laya.d3.core.Sprite3D;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Tween;

	public class TweenPath
	{
		private var tweenMove:Tween;
		private var tweenRotate:Tween;
		private var path:Vector.<Vector3>
		private var moveObj:Sprite3D;
		private var rotateObj:Sprite3D;
		/**  1/速度 */
		private var speedReciprocal:Number = 1;
		public var onFinished:Handler;
		public var onApproach:Handler;
		private var destination:Vector3;
		private var approachDistanceInWorld:Number;
		private var lookQuaternion:Quaternion = new Quaternion();
		private var tweenQuaternion:Quaternion = new Quaternion();
		private var _enabled:Boolean;
		private var jumpHeight:Number;
		private var delay:Number;

		private var m_destination:Vector3;

		public function TweenPath()
		{

		}

		private var index:int = -1;

		public function get pathIndex():int
		{
			if (index < 0)
				return 0;
			return index;
		}

		public function get wholePath():Vector.<Vector3>
		{
			return path.concat();
		}

		public function get Speed():Number
		{
			return speedReciprocal;
		}

		public function set Speed(value:Number):void
		{
			if (speedReciprocal != value)
			{
				speedReciprocal = value;
//				duration = value;
//				this.UpdateDirection(from, to);
			}
		}

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function get to():Vector3
		{
			return m_destination;
		}

		public function set enabled(value:Boolean):void
		{
			if (_enabled != value)
			{
				_enabled = value;
				if (enabled == false)
					cleanTween(false);
			}
		}

		public function begin(moveObj:Sprite3D, rotateObj:Sprite3D, speedReciprocal:Number, path:Vector.<Vector3>, jumpHeight:Number, delay:Number, approachDistanceInWorld:Number):void
		{
			if (!enabled)
				enabled = true;
			this.moveObj = moveObj;
			this.rotateObj = rotateObj;
			this.speedReciprocal = speedReciprocal;
			this.jumpHeight = jumpHeight;
			this.delay = delay;
			this.path = path;
			this.destination = path[path.length - 1];
			this.approachDistanceInWorld = approachDistanceInWorld;
			this.index = -1;

			tweening();
		}

		private function tweening():void
		{
			cleanTween();
			if (path.length == 0)
			{
				var callback:Handler = onFinished;
				dispose();
				if (callback != null)
					callback.run();
				return;
			}

			if (moveObj == null || moveObj.destroyed)
			{
				cleanTween();
				return;
			}
			var location:Vector3 = moveObj.transform.position.clone();
			var destination:Vector3 = path.shift();
			this.index++;
			var direction:Vector3 = new Vector3();
			Vector3.subtract(destination, location, direction);

			onMove(location, destination);
			onRotate(location, destination, direction);
		}



		private function onRotate(location:Vector3, destination:Vector3, direction:Vector3):void
		{
			if (rotateObj != null && !Vector3.equals(direction, Vector3.ZERO))
			{
				var targetQuaternion:Quaternion = rotateObj.transform.rotation;
				Quaternion.lookAt(location, destination, Vector3.Up, lookQuaternion);
				lookQuaternion.invert(lookQuaternion);

				var t:Object = {value: 0};
				var time:Number = Vector3.angle(rotateObj.transform.forward, direction) / 720 * 1000;
				var min:Number = 220;
				if (time < min)
					time = min;
				tweenRotate = Tween.to(t, {value: 1}, time, null, Handler.create(this, rotateComplete, null, false), 0, false, false);

				tweenRotate.update = Handler.create(null, function():void{
						if (rotateObj == null)return;
						Quaternion.slerp(targetQuaternion, lookQuaternion, t.value, tweenQuaternion);
						rotateObj.transform.localRotation = tweenQuaternion;
//						rotateObj.transform.rotate(new Vector3(0, 180, 0), false, false);
					}, null, false);
			}
		}

		private function onMove(location:Vector3, destination:Vector3):void
		{
			m_destination = destination;
			var direction:Vector3 = new Vector3();
			Vector3.subtract(location, destination, direction);
			direction.z /= 2; //doubleYScale
			var duration:Number = direction.magnitude * speedReciprocal * 1000;
			var t:Object = {value: 0};
			tweenMove = Tween.to(t, {value: 1}, duration, null, Handler.create(this, moveComplete, null, false), 0, false, false);

			tweenMove.update = Handler.create(null, function(... args):void{
					if (moveObj == null)return;
					var position:Vector3 = new Vector3();
					Vector3.lerp(location, destination, t.value, position);
					moveObj.transform.position = position;
					if (0 != jumpHeight)
					{
						var yOffset:Number = (4 * jumpHeight * t.value) * (1 - t.value);
						if (null != rotateObj)
						{
							rotateObj.transform.localPosition = new Vector3(0, yOffset, 0);
						}
					}

					if (onApproach != null && approachDistanceInWorld > 0)
					{
						var x:Number = moveObj.transform.position.x;
						var y:Number = moveObj.transform.position.z;
						var distance:Number = Math.sqrt(Math.pow(x - destination.x, 2) + Math.pow(y - destination.z, 2));
						onApproach.runWith([distance]);
					}
				}, null, false);

		}


		private function rotateComplete():void
		{
			clearRotate();
		}

		private function clearRotate():void
		{
			if (tweenRotate != null)
			{
				tweenRotate.clear();
				tweenRotate = null;
			}
		}

		private function moveComplete():void
		{
			clearMove();
			tweening();
		}

		private function clearMove():void
		{
			if (tweenMove != null)
			{
				tweenMove.clear();
				tweenMove = null;
			}
		}

		private function cleanTween(updateEase:Boolean = false):void
		{
			if (updateEase && tweenMove != null && moveObj != null && !moveObj.destroyed)
				tweenMove._updateEase(Browser.now())
			clearMove();
			if (updateEase && tweenRotate != null && rotateObj != null && !rotateObj.destroyed)
				tweenRotate._updateEase(Browser.now())
			clearRotate();
		}

		public function dispose():void
		{
			cleanTween(false);
		}
	}
}
