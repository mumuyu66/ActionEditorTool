package avatar {
	import org.osflash.signals.Signal;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	/**
	 * @author yangyiqiang
	 */
	public class Avatar extends Sprite {
		public var changed : Signal = new Signal();
		private var _asset : Asset;
		private var _body : DisplayObjectContainer;
		private var _defaluView : AvatarView;
		private var _animation : Animation;
		private var _animationController : AnimationController;

		public function Avatar(asset : Asset = null, controller : AnimationController = null) {
			_defaluView = new AvatarView();
			_animationController = controller;
			if (!_animationController) _animationController = new AnimationController();
			resetAsset(asset);
		}

		public function resetAsset(value : Asset) : void {
			if (_asset) _asset.remove(changeState);
			_asset = value;
			if (_animation) _animation.resetData(_asset);
			if (!_asset) {
				createBody(_defaluView);
				return;
			}
			_asset.add(changeState);
			if (_asset.state == Asset.ASSEST_DATA)
				create();
			else {
				createBody(_defaluView);
			}
		}

		public function setAction(value : String, loop : int = -1) : void {
			_animationController.setAction(value, false, loop);
		}

		private function changeState(state : String) : void {
			if (state == Asset.ASSEST_DATA)
				create();
		}

		private function create() : void {
			if (_asset && _asset.isMc) {
				createBody(_asset.mc);
			} else
				createBody(new AvatarView());
			if (!_animation)
			{
				_animation = new Animation(_body, _asset);
				_animationController.addAnimation(_animation);
			}
			_animation.targe = body;
			
			changed.dispatch();
		}

		private function createBody(value : DisplayObjectContainer) : void {
			var parent : DisplayObjectContainer = _body ? _body.parent : null;
			var index : int;
			if (parent) {
				index = parent.getChildIndex(_body);
				parent.removeChild(_body);
			}
			_body = value;
			if (!_body) {
				createBody(_defaluView);
				return;
			}
			addChildAt(_body, index);
			flipH = _flipH;
		}

		public function hide() : void {
			resetAsset(null);
			if (_body && _body.parent) _body.parent.removeChild(_body);
			if (this.parent) this.parent.removeChild(this);
		}

		public function dispose() : void {
			if (_asset)
				_asset.dispose();
		}

		public function get asset() : Asset {
			return _asset;
		}

		private var _flipH : Boolean = false;

		public function set flipH(value : Boolean) : void {
			_flipH = value;
			_body.scaleX = Math.abs(_body.scaleX) * (value ? -1 : 1);
		}

		public function get flipH() : Boolean {
			return _flipH;
		}

		public function get body() : DisplayObjectContainer {
			return _body;
		}

		public function getTopX(action:String=null) : Number {
			if (_animation) return _animation.getTopX(action);
			return -24;
		}

		public function getTopY() : Number {
			if (_animation) return _animation.getTopY(action);
			return -81;
		}

		public function get animation() : Animation {
			return _animation;
		}

		public function get action() : String {
			return _animationController.actionName;
		}
		
		public function get actionChanged():Signal
		{
			return _animationController.actionChanged;
		}
	}
}
