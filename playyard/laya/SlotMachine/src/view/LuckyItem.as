package view
{
	import ui.LuckyItemUI;
	
	public final class LuckyItem extends LuckyItemUI
	{
		public function LuckyItem()
		{
			super();
		}
		
		public function update(name: String): void {
			
			this.imgHead.skin = 'p/' + name + '.jpg';
			this.textName.text = name;
		}
	}
}