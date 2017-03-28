package avatar.component {
	import avatar.Avatar;

	import config.WingConfig;

	import ui.core.Remove;

	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**
	 * @author yangyiqiang
	 */
	public class Wing {
		private var _avatar : Avatar;
		private var _wingAvatar : Avatar;
		private var _wingConfig : WingConfig;
		private var _wingConfigDic : Dictionary;

		public function Wing(avatar : Avatar, a : Avatar, config : WingConfig = null) {
			_avatar = avatar;
			_avatar.mouseEnabled = false;
			if (config)
				_wingConfig = config ;
			else {
				_wingConfig = new WingConfig();
				_wingConfig.init();
			}
			_wingConfigDic = _wingConfig.getWingDic(_avatar.asset.assestKey);
			_wingAvatar = a;
			_wingAvatar.x = -90;
			_wingAvatar.y = -130;
			_avatar.actionChanged.add(onChange);
			_wingAvatar.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_wingAvatar.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		public function get config() : Dictionary {
			return _wingConfigDic;
		}

		private function onMouseDown(event : MouseEvent) : void {
			event.stopImmediatePropagation();
			_wingAvatar.startDrag();
		}

		private function onMouseUp(event : MouseEvent) : void {
			event.stopImmediatePropagation();
			_wingAvatar.stopDrag();
			setWingPoint();
		}

		public function setWingPoint() : void {
			_wingConfig.setValue(_avatar.asset.assestKey, _wingAvatar.action, _wingAvatar.x, _wingAvatar.y);
			trace(_wingConfig.toString());
		}

		public function setLayer(add : Boolean = false) : void {
			_wingConfig.setValue(_avatar.asset.assestKey, _wingAvatar.action, _wingAvatar.x, _wingAvatar.y, add ? _wingConfigDic[ _wingAvatar.action]["layer"] + 1 : 0);
		}

		public function get wingAvatar() : Avatar {
			return _wingAvatar;
		}

		public function get wingConfig() : WingConfig {
			return _wingConfig;
		}

		public function reset() : void {
			_avatar.changed.remove(onChange);
			Remove(_wingAvatar);
			_avatar = null;
			_wingAvatar = null;
			_wingConfig = null;
			_wingConfigDic = null;
		}

		private function onChange(name : String, loop : int) : void {
			if (name == "20") {
				_avatar.setAction("1", -1);
			} 
//				_avatar.setAction(name, -1);
		}
	}
}
