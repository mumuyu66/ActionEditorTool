package ui.core {
	import flash.display.DisplayObjectContainer;

	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.base.SignalSprite;

	import flash.events.Event;

	/**
	 * @author yangyiqiang
	 */
	public class Component extends SignalSprite implements IComponent {
		protected var _width : int;
		protected var _height : int;
		protected var _source : *;
		private var _added : Signal;
		private var _removed : Signal;

		private function addToStageHandler(event : Event) : void {
			if (_changed) onRender();
			this.signals.removedFromStage.add(removeFromStageHandler);
			this.signals.render.add(renderHandler);
			this.signals.addedToStage.remove(addToStageHandler);
			_added.dispatch();
		}

		private function removeFromStageHandler(event : Event) : void {
			this.signals.removedFromStage.remove(removeFromStageHandler);
			this.signals.render.remove(renderHandler);
			this.signals.addedToStage.add(addToStageHandler);
			_removed.dispatch();
		}

		protected function initializeSignals() : void {
			_added = new Signal();
			_removed = new Signal();
		}

		protected function initializeSignalHandlers() : void {
			_added.add(addedHandler);
			_removed.add(removedHandler);
		}

		private function addedHandler() : void {
			_perent = this.parent;
		}

		private function removedHandler() : void {
		}

		private function renderHandler(event : Event) : void {
			onRender();
		}

		protected function init() : void {
			create();
			layout();
			initializeSignals();
			initializeSignalHandlers();
			invalidate();
		}

		protected function create() : void {
		}

		protected function layout() : void {
		}

		private var _changed : Boolean = false;

		protected function invalidate() : void {
			_changed = true;
			if (stage) stage.invalidate();
		}

		protected function onRender() : void {
			if (!_changed) return;
			_changed = false;
		}

		public function Component() {
			init();
			this.signals.addedToStage.add(addToStageHandler);
		}

		public function stageResizeHandler() : void {
		}

		final public function get added() : Signal {
			return _added;
		}

		final public function get removed() : Signal {
			return _removed;
		}

		private var _align : GAlign;

		final public function set align(value : GAlign) : void {
		}

		final public function get align() : GAlign {
			return _align;
		}

		override public function set width(value : Number) : void {
			if (_width == value) return;
			_width = value;
			layout();
		}

		override public function set height(value : Number) : void {
			if (_height == value) return;
			_height = value;
			layout();
		}

		private var _perent : DisplayObjectContainer;

		public function set perent(value : DisplayObjectContainer) : void {
			_perent = value;
		}

		public function show() : void {
			if (_perent) _perent.addChild(this);
		}

		public function hide() : void {
			Remove(this);
		}

		public function set source(value : *) : void {
			_source = value;
			invalidate();
		}

		public function get source() : * {
			return _source;
		}
	}
}
