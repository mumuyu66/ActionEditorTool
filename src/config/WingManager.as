package config {
	import flash.utils.Dictionary;
	/**
	 * @author yangyiqiang
	 */
	public class WingManager {
		
		private static var _instance : WingManager;

		public function WingManager()
		{
			if (_instance)
			{
				throw Error("---WingManager--is--a--single--model---");
			}
			addWing(1);
		}

		public static function get instance() : WingManager
		{
			if (_instance == null)
			{
				_instance = new WingManager();
			}
			return _instance;
		}
		
		private var _wings:Dictionary=new Dictionary();
		
		public function addWing(id:int):void
		{
			_wings[id]=new WingConfig();
		}
		
		public function getWing():WingConfig
		{
			return _wings[1];
		}
	}
}
