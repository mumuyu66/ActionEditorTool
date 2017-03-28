package avatar {
	import org.osflash.signals.ISlot;
	import org.osflash.signals.Signal;

	import flash.display.MovieClip;

	/**
	 * @author yangyiqiang
	 */
	public class Asset extends Signal
	{
		public static const ASSEST_NULL : String = "assestNull";
		public static const ASSEST_LOADING : String = "loading";
		public static const ASSEST_LOADED : String = "loaded";
		public static const ASSEST_PARSEING : String = "parseing";
		public static const ASSEST_DATA : String = "data";
		public static const ASSEST_TODISPOSE : String = "todispose";
		private var _state : String = ASSEST_NULL;
		public var 	assestKey : String;
		public var assetUrl : String;
		public var actionDefinition : Object;
		public var isMc : Boolean = false;
		
		/** MC类的源CLASSKEY 及frame **/
		public var  classKey : String = null;
		public var sourceFrame:int=30;

		public function Asset(key : String, classKey : String = null, isMc : Boolean = false, assetUrl : String = null, actionDefinition : Object = null)
		{
			assestKey = key;
			this.classKey = classKey;
			this.isMc = isMc;
			this.assetUrl = assetUrl;
			super(String);
		}

		public function isNeetLoad() : Boolean
		{
			return _state == ASSEST_NULL;
		}

		public function isNeetParse() : Boolean
		{
			return _state == ASSEST_LOADED;
		}

		public function get url() : String
		{
			return assetUrl;
		}

		public function get mc() : MovieClip
		{
			return null;
		}
		
		public function set state(value : String) : void
		{
			if (value != _state)
			{
				_state = value;
				trace("set state ===>" + _state, "  assestKey===>" + assestKey);
				dispatch(_state);
			}
		}

		public function get state() : String
		{
			return _state;
		}

		override public function remove(listener : Function) : ISlot
		{
			const slot : ISlot = super.remove(listener);
			// if (!slots.nonEmpty)
			// {
			// _state = ASSEST_TODISPOSE;
			// }
			return slot;
		}

		override public function removeAll() : void
		{
			super.removeAll();
			// _state = ASSEST_TODISPOSE;
		}

		override public function add(listener : Function) : ISlot
		{
			// if (_state == ASSEST_TODISPOSE) _state = ASSEST_NULL;
			return registerListener(listener);
		}

		public function dispose() : void
		{
			removeAll();
			_state = ASSEST_NULL;
		}
	}
}
