package ui.controls {
	import ui.core.Component;

	import flash.display.Bitmap;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * @author yangyiqiang
	 */
	public class Button extends Component {
		public function Button() {
			super();
			this.mouseChildren=false;
			this.buttonMode=true;
		}

		override protected function initializeSignals() : void {
			super.initializeSignals();
		}

		override protected function initializeSignalHandlers() : void {
			super.initializeSignalHandlers();
		}

		override protected function create() : void {
			_skin = new Bitmap();
			addChild(_skin);
		}

		public function get lable() : Lable {
			return _lable;
		}

		public function set lable(value : Lable) : void {
			_lable = value;
		}

		private var _lable : Lable;
		private var _skin : Bitmap;

		public function set text(value : String) : void {
			if (!_lable) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.align = TextFormatAlign.CENTER;
				textFormat.font = "SimSun,宋体,Microsoft YaHei,微软雅黑";
				textFormat.color = 0;
				textFormat.size = 12;
				textFormat.leading = 3;
				_lable = new Lable();
				_lable.defaultTextFormat = textFormat;
				_lable.selectable=false;
				_lable.mouseEnabled=false;
				addChild(_lable);
			}
			_lable.text = value;
		}
	}
}
