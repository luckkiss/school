package view
{
	import laya.display.BitmapFont;
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.utils.Handler;
	
	import res.ResourceManager;

	/**CommonForm实现了自动加载图集，是所有面板的基类*/
	public class CommonForm
	{
		/**面板ui*/
		public var form: Sprite;
		
		/**正在加载的ui图集*/
		private var uiRequest: Array = [];
		/**正在加载的字体图集*/
		private var fontRequest: Array = [];
		/**剩余的正在加载的字体图集总数*/
		private var fontNum: int = 0;
		
		/**ui图集目录*/
		private const atlasBasePath: String = "res/atlas/";
		/**字体图集目录*/
		private const fontBasePath: String = "bitmapFont/";
		
		/**是否打开面板*/
		protected var _opened:Boolean = false;
		
		public function CommonForm()
		{
		}
		
		/**
		 * 初始化ui，所有子类均需覆盖本接口。
		 *
		 */
		protected function initElements():void
		{
		}
		
		/**
		 * 获取本面板相关联的ui。可以返回一个Object，也可以返回一个数组。
		 * @return 单个（Object）或者多个（Array）UI的uiView。
		 * 
		 */		
		protected function resPath(): Object
		{
			return null;
		}
		
		/**
		 * 面板打开时调用本接口，可以在此做界面渲染相关的操作。
		 * 
		 */		
		protected function onOpen():void
		{
		}
		
		/**
		 * 面板关闭时调用本接口，可以在此做界面清理相关的操作。
		 * 
		 */		
		protected function onClose():void
		{
		}
		
		/**
		 * 打开面板。如果面板所需图集尚未加载完成，则会启动加载或者等待加载完成。
		 * @param args
		 * 
		 */		
		public function open(...args): void {
			if (this._opened == true)
			{
				return;
			}
			this._opened = true;
			
			if (this.form != null)
			{
				// 面板ui已经创建出来，直接显示即可
				this.form.visible = true;
				this.onOpen();
			}
		}
		
		/**
		 * 关闭面板。
		 * 
		 */		
		public function close():void
		{
			if (this._opened == false)
			{
				return;
			}
			this._opened = false;
			
			if (this.uiRequest.length > 0)
			{
				this.uiRequest.length = 0;
			}
			
			if (this.fontRequest.length > 0)
			{
				this.fontRequest.length = 0;
			}
			
			if (null != this.form)
			{
				// 清除所有相关的定时器
				Laya.timer.clearAll(this);
				// 调用onClose，进行界面清理相关的工作
				this.onClose();
				// 直接隐藏
				this.form.visible = false;
			}
		}
		
		/**
		 * 创建面板，如果需要使用到图集和字体，则自动开始下载。
		 * 
		 */		
		public function createForm(): void
		{
			if (this.form != null || this.uiRequest.length > 0 || this.fontRequest.length > 0)
			{
				return;
			}
			var res:Object = resPath();
			if (res is Array)
			{
				for each (var o:Object in res)
				{
					ResourceManager.getDependResources(o,uiRequest,fontRequest)
				}
			}
			else
			{
				ResourceManager.getDependResources(res,uiRequest,fontRequest)
			}
			
			// 加载ui图集
			Laya.loader.load(this.uiRequest, Handler.create(this, this._onLoadForm));
			
			// 加载字体
			fontNum = this.fontRequest.length;
			for (var i:int = 0; i < this.fontRequest.length; i++)
			{
				var bmFont: BitmapFont = new BitmapFont();
				bmFont.loadFont(this.fontBasePath + this.fontRequest[i] + ".fnt", new Handler(this, _onFontLoaded, [this.fontRequest[i], bmFont]))
			}
			
			_onAfterAllLoaded();
		}
		
		/**ui图集加载后的回调*/
		private function _onLoadForm(assetRequest:Object):void
		{
			if (!assetRequest)
			{
				console.error('assetRequest加载失败:');
				return;
			}
			
			// 标记ui图集加载完成
			this.uiRequest.length = 0;
			_onAfterAllLoaded();
		}
		
		/**字体加载后的回调*/
		private function _onFontLoaded(fontName:String, bmFont:BitmapFont):void
		{
			this.fontNum--;
			ResourceManager.loadedFontArry.push(fontName);
			Text.registerBitmapFont(fontName, bmFont);
			if (this.fontNum <= 0)
			{
				// 所有字体都加载好了
				this.fontRequest.length = 0;
				_onAfterAllLoaded();
			}
		}
		
		/**检查ui图集和字体是否全部加载完成*/
		private function _onAfterAllLoaded():void
		{
			if (this.uiRequest.length > 0 || this.fontRequest.length > 0)
			{
				// 还在加载
				return;
			}
			
			// 初始化ui
			this.initElements();
			form.name = this.name;
			// 添加到舞台上
			Laya.stage.addChild(form);
			
			(form as Object).commonForm = this;
			
			if (this._opened)
			{
				// 需要打开界面则自动打开
				this.form.visible = true;
				this.onOpen();
			}
			else
			{
				// 否则将面板隐藏
				this.form.visible = false;
			}
		}
		
		public function get name():String
		{
			return 'Form.' + this["__proto__"]["__class"].name;
		}
	}
}