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
		private const CircleRadius: Number = 40;
		private const LinkLength: Number = 180;
		private const LineWidth: Number = 2;
		
		private var selectedNode: GuideNode;
		private var nodeList: Vector.<GuideNode> = [] as Vector.<GuideNode>;
		
		private var lastKeyword: String;
		private var lastFindIdx: int = -1;
		
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
			
			uiView.btnSearch.on(Event.CLICK, this, this.onClickBtnSearch);
			uiView.inputSearch.on(Event.INPUT, this, this.onClickBtnSearch);
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
			textDesc.fontSize = 18;
			textDesc.text = node.desc;
			textDesc.wordWrap = true;
			textDesc.size(this.CircleRadius * 2, this.CircleRadius * 2);
			textDesc.pos(x - this.CircleRadius, y - this.CircleRadius);
			nodeCircle.addChild(textDesc);
			nodeCircle.on(Event.CLICK, this, this.onClickNodeCircle, [node]);
			this.uiView.addChild(nodeCircle);
			
			node.ui = nodeCircle;
			this.nodeList.push(node);
			
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
		
		private function onClickBtnSearch(): void {
			var keyword: String = this.uiView.inputSearch.text.toLowerCase();
			if('' == keyword) {
				return;
			}
			
			var startIndex = 0;
			if(this.lastKeyword != keyword) {
				this.lastKeyword = keyword;
			} else if(this.lastFindIdx >= 0) {
				startIndex = this.lastFindIdx + 1;
			}
			var findResult: GuideNode = this.find(startIndex, this.nodeList.length);
			if(!findResult && startIndex > 0) {
				findResult = this.find(0, startIndex);
			}
			
			if(findResult) {
				this.onClickNodeCircle(findResult);
			}
		}
		
		private function find(from: int, to: int): void {
			for(var i: int = from; i < to; i++) {
				var node: GuideNode = this.nodeList[i];
				var found: Boolean = false;
				if(node.desc.toLowerCase().indexOf(this.lastKeyword) >= 0 || node.detail.toLowerCase().indexOf(this.lastKeyword) >= 0) {
					found = true;
				}
				if(!found && node.interfaces) {
					for(var j: int = 0, icnt: int = node.interfaces.length; j < icnt; j++) {
						var inode: InterfaceNode = node.interfaces[j];
						if(inode.name.toLowerCase().indexOf(this.lastKeyword) >= 0 || inode.info.toLowerCase().indexOf(this.lastKeyword) >= 0) {
							found = true;
							break;
						}
					}
				}
				if(!found && node.cases) {
					for(var j: int = 0, ccnt: int = node.cases.length; j < ccnt; j++) {
						if(node.cases[j].toLowerCase().indexOf(this.lastKeyword) >= 0) {
							found = true;
							break;
						}
					}
				}
				
				if(found) {
					this.lastFindIdx = i;
					return node;
				}
			}
			return null;
		}
	}
}