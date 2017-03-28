package avatar {
	import avatar.action.ActionVO;

	import org.osflash.signals.Signal;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 * @author yangyiqiang
	 */
	public class Animation implements IAnimation {
		public var event : Signal = new Signal(String, String);
		private var _data : AvatarData;
		private var _targe : DisplayObject;
		private var _asset : Asset;

		public function Animation(targe : DisplayObject, asset : Asset) {
			_asset = asset;
			_targe = targe;
			if (General.assetsPool.has(_asset.assestKey)) {
				_data = General.assetsPool.get(_asset.assestKey);
			} else {
				_data = new AvatarData();
				General.assetsPool.set(_asset.assestKey, _data);
			}
		}
		
		public function set targe(value:DisplayObject):void{
			_targe=value;
		}

		public function resetData(asset : Asset, data : AvatarData = null) : void {
			_asset = asset;
			_events = new Dictionary();
			_data = data;
			if (!_data) {
				if (General.assetsPool.has(_asset.assestKey)) {
					_data = General.assetsPool.get(_asset.assestKey);
				} else {
					_data = new AvatarData();
					General.assetsPool.set(_asset.assestKey, _data);
				}
			}
		}

		public function clear() : void {
			_data = null;
			_targe = null;
			_events = null;
		}

		public function defaultAction(action : ActionVO) : String {
			if (!action || !_asset.actionDefinition) return null;
			var actionConfig : Object = _asset.actionDefinition[action.name];
			if (!actionConfig) return null;

			// 发送动作结束事件
			if (actionConfig["completeEvent"] == true) {
				dispatchActionEvent("complete");
			}

			// 继续下一默认动作
			if (actionConfig["nextAction"]) {
				return actionConfig["nextAction"];
			}
			return null;
		}

		private var _events : Dictionary = new Dictionary();

		public function refresh(index : int, action : ActionVO) : void {
			if (_targe is MovieClip) {
				_targe["gotoAndStop"](index);
				if (_data.eventFrames[index] && !_events[index]) {
					_events[index] = true;
					dispatchActionEvent(_data.eventFrames[index], action.name);
				}
			} else if (_targe is AvatarView && _data.dataList) {
				_targe["setData"](_data.dataList[index]);
			}
		}
		
		private var _point:Point=new Point();
		public function getTopX(actionName:String=null) : int {
			if (!_data) return 0;
			_point = _data.topPoint[actionName];
			if (_point)return _point.x;
			return _data.topX;
		}

		public function getTopY(actionName:String=null) : int {
			if (!_data) return 0;
			_point = _data.topPoint[actionName];
			if (_point)return _point.y;
			return _data.topY;
		}
		
		public function getPoint(actionName:String):Point
		{
			if (!_data) return _point;
			_point = _data.topPoint[actionName];
			if(!_point)
			{
				_point=new Point(_data.topX,_data.topY);
			}
			return _point;
		}

		public function get data() : AvatarData {
			return _data;
		}

		private function dispatchActionEvent(type : String, name : String = "") : void {
			event.dispatch(type, name);
		}
	}
}
