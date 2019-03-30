package script.unit
{
	import laya.components.Script;
	import laya.d3.core.Sprite3D;
	import laya.d3.math.Vector3;
	
	public class UnitFollower extends Script
	{
		public var target: Sprite3D;
		public var yOffset: Number = 8;
		public var zOffset: Number = -12;
		
		public function UnitFollower()
		{
			super();
		}
		
		override public function onUpdate():void {
			if(!target) {
				return;
			}
			
			var ownerSp3: Sprite3D = owner as Sprite3D;
			var pos: Vector3 = target.transform.localPosition;
			var cameraPos: Vector3 = ownerSp3.transform.localPosition;
			cameraPos.x = pos.x;
			cameraPos.y = pos.y + yOffset;
			cameraPos.z = pos.z + zOffset;
			ownerSp3.transform.localPosition = cameraPos;
		}
	}
}