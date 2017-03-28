package ui.controls {
	import org.osflash.signals.natives.base.SignalTextField;

	import flash.events.Event;

	/**
	 * @author yangyiqiang
	 */
	public class Lable extends SignalTextField {
		public function Lable() {
			super();
			this.signals.addedToStage.add(addToStageHandler);
			this.width=60;
		}

		private function addToStageHandler(event : Event) : void {
			if (_changed) onRender();
			this.signals.removedFromStage.add(removeFromStageHandler);
			this.signals.render.add(renderHandler);
			this.signals.addedToStage.remove(addToStageHandler);
		}

		private function removeFromStageHandler(event : Event) : void {
			this.signals.removedFromStage.remove(removeFromStageHandler);
			this.signals.render.remove(renderHandler);
			this.signals.addedToStage.add(addToStageHandler);
		}

		private var _changed : Boolean = false;

		protected function invalidate() : void {
			_changed = true;
			if (stage) stage.invalidate();
		}

		protected function onRender() : void {
			if (!_changed) return;
			if (_isHtmlText)
				super.htmlText = _text;
			else
				super.text = _text;
			_changed = false;
		}

		private function renderHandler(event : Event) : void {
			onRender();
		}

		private var _text : String;
		private var _htmlText : String;
		private var _isHtmlText : Boolean = false;

		override public function set text(value : String) : void {
			if (value === _text) return;
			_text = value;
			_isHtmlText = false;
			_changed = true;
			if (stage) stage.invalidate();
		}

		override public function set htmlText(value : String) : void {
			if (value === _htmlText) return;
			_htmlText = value;
			_isHtmlText = true;
			_changed = true;
			if (stage) stage.invalidate();
		}
	}
}
