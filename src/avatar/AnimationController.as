package avatar {
	import avatar.action.ActionVO;
	import avatar.action.ActorAction;

	import framerate.FrameTimer;
	import framerate.IFrame;

	import org.osflash.signals.Signal;

	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * @author yangyiqiang
	 */
	public class AnimationController implements IFrame {
		public var actionChanged : Signal = new Signal(String, int);
		public var layout : Signal = new Signal(AnimationController);
		public var add : Signal = new Signal(IAnimation);
		public var remove : Signal = new Signal(IAnimation);
		private var _animations : Vector.<IAnimation>=new Vector.<IAnimation>();
		private var _actions : Dictionary;
		private var _currentActionVO : ActionVO;

		public function AnimationController(actions : Dictionary = null) {
			_actions = actions;
		}

		public function addAnimation(animation : IAnimation) : void {
			if (!_actions) {
				_actions = animation.data.actions;
				_delay = animation.data.delay;
				setAction(_action, false, _loop);
			}
			var index : int = _animations.indexOf(animation);
			if (index < 0)
			{
				_animations.push(animation);
				add.dispatch(animation);
			}
		}

		public function setActions(actions : Dictionary, delay : int) : void {
			_actions = actions;
			_delay = delay;
		}

		public function removeAnimation(animation : IAnimation) : void {
			var index : int = _animations.indexOf(animation);
			if (index >= 0) 
			{
				_animations.splice(index, 1);
				add.dispatch(animation);
			}
		}

		public function get actionName() : String {
			return _action;
		}

		private var _loop : int = -1;
		private var _action : String = "1";

		public function setAction(action : String, stop : Boolean = false, loop : int = -1) : void {
			actionChanged.dispatch(action,loop);
			layout.dispatch(this);
			_action = action;
			_loop = loop;
			if (!_actions) return;
			if (hasAction(action)) {
				_loop = loop;
				_count = 0;
				_currentActionVO = _actions[action];
				_index = _currentActionVO.startFrame;

				if (stop)
					FrameTimer.remove(this);
				else
					FrameTimer.add(this);
			} else {
				if (action == (ActorAction.STORE_POWER + "2")) {
					setAction(ActorAction.HANDS_UP + "2");
					return;
				} else if (action == (ActorAction.HANDS_UP + "2")) {
					setAction(ActorAction.ATTACK + "2");
					return;
				}
				onActionEnd();
			}
		}

		public function hasAction(action : String) : Boolean {
			return _actions && _actions[action] != null;
		}

		private var _lastTime : uint;
		private var _delay : Number;
		private var _index : int;

		public function action(time : uint) : void {
			if (!_currentActionVO) return;
			if ((time - _lastTime) >= _delay) {
				if (_index >= _currentActionVO.endFrame) {
					onActionEnd();
					return;
				} else {
					for each (var animation : IAnimation in _animations) {
						animation.refresh(_index, _currentActionVO);
					}
				}
				_index++;
				_lastTime = getTimer();
			}
		}

		private var _count : int;

		private function onActionEnd() : void {
			if (_loop == -1) {
				defaultAction();
			} else {
				if (_loop > 0) {
					_count++;
					if (_count == _loop) {
						_loop = -1;
						defaultAction();
						return;
					}
				} else {
					_index = _currentActionVO.startFrame;
				}
			}
		}

		private function defaultAction() : void {
			var nextAction : String = null;
			for each (var animation : IAnimation in _animations)
				nextAction = animation.defaultAction(_currentActionVO);
			if (nextAction) setAction(nextAction);
			else _index = _currentActionVO.startFrame;
		}
	}
}
