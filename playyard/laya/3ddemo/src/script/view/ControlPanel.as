package script.view
{
	import laya.display.Scene;
	import laya.events.Event;
	import laya.utils.Handler;
	
	import script.scene.MapScene;
	
	import ui.test.ControlPanelUI;
	
	public class ControlPanel extends ControlPanelUI
	{
		private var funcs: Vector.<String> = ['2D物理', '3D场景'] as Vector.<String>;
		public function ControlPanel()
		{
			super();
		}
		
		override public function onEnable():void {			
			this.btnToggle.on(Event.CLICK, this, this.onClickBtnToggle);
			
			this.listFunc.itemRender = FuncItem;
			this.listFunc.renderHandler = Handler.create(this, this.onRenderItem, null, false);
			this.listFunc.selectHandler = Handler.create(this, this.onSelectListFunc, null, false);
			this.listFunc.array = funcs as Array;
		}
		
		private function onClickBtnToggle(): void {
			this.listFunc.visible = !this.listFunc.visible;
		}
		
		private function onRenderItem(cell: FuncItem, index: int): void {
			cell.update(this.funcs[index]);
		}
		
		private function onSelectListFunc(index: int): void {
			if(0 == index) {
				Scene.open('test/TestScene.scene', false);
				MapScene.instance.destroy();
			} else {
				Scene.close('test/TestScene.scene');
				MapScene.instance.loadScene('res/threeDimen/scene/TerrainScene/XunLongShi.ls', "res/threeDimen/skyBox/skyBox2/skyBox2.lmat", 'res/threeDimen/scene/TerrainScene/Assets/HeightMap.png', "res/threeDimen/scene/TerrainScene/Assets/AStarMap.png");
			}
			this.listFunc.visible = false;
		}
	}
}