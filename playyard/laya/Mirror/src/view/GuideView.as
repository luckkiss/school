package view
{
	import data.GuideNode;
	import data.InterfaceNode;
	
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.events.Event;
	
	import ui.GuideViewUI;

	public class GuideView extends CommonForm
	{
		private var uiView: GuideViewUI;
		
		private const RootColor: String = '#dd5452';
		private const ChildColor: String = '#ddb2b2';
		private const InterfaceColor: String = '#178edd';
		private const CircleRadius: Number = 30;
		private const LinkLength: Number = 100;
		private const LineWidth: Number = 2;
		
		private var selectedNode: GuideNode;
		
		public function GuideView()
		{
		}
		
		protected function resPath(): Object
		{
			return GuideViewUI.uiView;
		}
		
		override protected function initElements(): void {
			uiView = new GuideViewUI();
			form = uiView;
		}
		
		override protected function onOpen(): void {
			var rootNode: GuideNode = Global.guideData.rootNode;
			
			var stageW: Number = Laya.stage.width;
			var stageH: Number = Laya.stage.height;
			
			var centerX: Number = stageW / 2;
			
			this.drawCircle(centerX, 200, rootNode, 0);
			this.onClickNodeCircle(rootNode);
		}
		
		private function drawCircle(x: Number, y: Number, node: GuideNode, deep: int): void {
			var nodeCircle: Sprite = new Sprite();
			nodeCircle.mouseEnabled = true;
			nodeCircle.mouseThrough = true;
			nodeCircle.graphics.drawCircle(x, y, this.CircleRadius, 0 == deep ? this.ChildColor : this.RootColor);
			var textDesc: Text = new Text();
			textDesc.align = 'center';
			textDesc.valign = 'middle';
			textDesc.text = node.desc;
			textDesc.size(this.CircleRadius * 2, this.CircleRadius * 2);
			textDesc.pos(x - this.CircleRadius, y - this.CircleRadius);
			nodeCircle.addChild(textDesc);
			nodeCircle.on(Event.CLICK, this, this.onClickNodeCircle, [node]);
			this.uiView.addChild(nodeCircle);
			
			node.ui = nodeCircle;
			
			if(node.children) {
				var cnt: int = node.children.length;
				var angle: Number = Math.PI * 2 / (deep > 0 ? cnt + 1 : cnt);
				for(var i: int = 0; i < cnt; i++) {
					var cnode: GuideNode = node.children[i];
					cnode.parent = node;
					
					var cx: Number = x + Math.sin(angle * (deep > 0 ? i + 1 : i)) * this.LinkLength;
					var cy: Number = y + Math.cos(angle * (deep > 0 ? i + 1 : i)) * this.LinkLength;
					this.drawCircle(cx, cy, cnode);
					nodeCircle.graphics.drawLine(x, y, cx, cy, this.ChildColor, this.LineWidth, deep + 1);
				}
			}
		}
		
		private function onClickNodeCircle(node: GuideNode): void {
			this.selectedNode = node;
			this.changeAlpha(Global.guideData.rootNode);
			
			var str: String = node.desc + '\n' + node.detail;
			if(node.interfaces) {
				var icnt: int = node.interfaces.length;
				for(var i: int = 0; i < icnt; i++) {
					str += '\n';
					var inode: InterfaceNode = node.interfaces[i];
					str += inode.name + ' - ' + inode.info;
				}
			}
			if(node.cases) {
				str += '\n\nsee: '; 
				for(var i: int = 0; i < node.cases.length; i++) {
					str += '\n';
					str += node.cases[i];
				}
			}
			this.uiView.textDetail.text = str;
		}
		
		private function changeAlpha(node: GuideNode): void {
			node.ui.alpha = ((node == this.selectedNode || node.parent == this.selectedNode) ? 1 : 0.5);
			if(node.children) {
				var cnt: int = node.children.length;
				for(var i: int = 0; i < cnt; i++) {
					this.changeAlpha(node.children[i]);
				}
			}
		}
	}
}