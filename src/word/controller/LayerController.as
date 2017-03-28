package word.controller {
	import avatar.AvatarView;

	import word.player.Player;

	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;

	/**
	 * @author yangyiqiang
	 */
	public class LayerController {
		private var _play : Player;

		public function LayerController(value : Player) {
			_play = value;
			_play.body.actionChanged.add(onChanged);
		}

		public function clean() : void {
			_play = null;
		}

		private var _lastY : int;
		private var _topPoint : Point = new Point();

		private function updateDisplays(action : String = "") : void {
			_topPoint = _play.avatar.animation.getPoint(action);
			_lastY = _topPoint.y + 10;
			if (_play.ride) {
				_lastY += _play.ride._avatar.getTopY();
				if (_play.avatar.body is AvatarView)
					_play.avatar.body["setOffPoint"](0, _play.ride._avatar.getTopY());
			} else {
				if (_play.avatar.body is AvatarView)
					_play.avatar.body["setOffPoint"](0, 0);
			}
		}

		private function onChanged(name : String, loop : int) : void {
			var layer : int;
			var parent : DisplayObjectContainer = _play.body.body;
			if (_play.wing && _play.wing.config) {
				_play.wing.wingAvatar.x = _play.wing.config[name]["offsetX"];
				_play.wing.wingAvatar.y = _play.wing.config[name]["offsetY"];
				layer = _play.wing.config[name]["layer"];
				layer = layer > 0 ? parent.numChildren : 0;
				if (name == "20") layer = 0;
				parent.addChildAt(_play.wing.wingAvatar, layer);
			}
			if (_play.ride && _play.ride.configDic) {
				trace(_play.ride.configDic[name]["offsetX"], _play.ride.configDic[name]["offsetY"]);
				_play.ride.rideAvatar.x = _play.ride.configDic[name]["offsetX"];
				_play.ride.rideAvatar.y = _play.ride.configDic[name]["offsetY"];
				layer = _play.ride.configDic[name]["layer"];
				layer = layer > 0 ? parent.numChildren : 0;
				if (name == "20") layer = 0;
				parent.addChildAt(_play.ride.rideAvatar, layer);
			}
		}
	}
}
