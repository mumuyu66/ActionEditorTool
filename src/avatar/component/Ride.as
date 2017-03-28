package avatar.component {
	import avatar.Avatar;
	import avatar.AvatarData;

	import config.MountConfig;

	import ui.core.Remove;

	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**
	 * @author yangyiqiang
	 */
	public class Ride {
		public var _avatar : Avatar;
		private var _rideAvatar : Avatar;
		private var _mountConfig : MountConfig;
		private var _mountConfigDic : Dictionary;

		public function Ride(avatar : Avatar, rideAvatar : Avatar, config : MountConfig = null) {
			this._avatar = avatar;
			_rideAvatar = rideAvatar;
			_rideAvatar.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_rideAvatar.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_mountConfig=config;
			_mountConfigDic=_mountConfig.getDic(_avatar.asset.assestKey);
		}

		public function get rideAvatar() : Avatar {
			return _rideAvatar;
		}

		public function reset() : void {
			Remove(_rideAvatar);
			_avatar = null;
			_rideAvatar = null;
		}
		
		public function get mountConfig():MountConfig
		{
			return _mountConfig;
		}
		
		public function get configDic():Dictionary
		{
			return _mountConfigDic;
		}
		
		public function setWingPoint():void
		{
			_mountConfig.setValue(_avatar.asset.assestKey, _avatar.action, _rideAvatar.x, _rideAvatar.y);
			trace(_mountConfig.toString());
		}

		private function onMouseDown(event : MouseEvent) : void {
			event.stopImmediatePropagation();
			_rideAvatar.startDrag();
		}

		private function onMouseUp(event : MouseEvent) : void {
			event.stopImmediatePropagation();
			_rideAvatar.stopDrag();
			setWingPoint();
//			var data : AvatarData = _rideAvatar.animation.data;
//			var k : String = this._avatar.asset.assestKey;
//			data.bottom[int(k)] = {key:k, x:_rideAvatar.x, y:_rideAvatar.y};
//			trace("_rideAvatar===>" + _rideAvatar.x, _rideAvatar.y);
		}
	}
}
