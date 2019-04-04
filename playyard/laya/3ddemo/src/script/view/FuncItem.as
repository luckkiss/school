package script.view
{
	import ui.FunctemUI;
	
	public class FuncItem extends FunctemUI
	{
		public function FuncItem()
		{
			super();
		}
		
		public function update(desc: String): void {
			this.textDesc.text = desc;
		}
	}
}