package config {
	import flash.utils.Dictionary;
	/**
	 * @author yangyiqiang
	 */
	public class MountManager {
		
		private static var _instance : MountManager;

		public function MountManager()
		{
			if (_instance)
			{
				throw Error("---MountManager--is--a--single--model---");
			}
			addMount(1);
		}

		public static function get instance() : MountManager
		{
			if (_instance == null)
			{
				_instance = new MountManager();
			}
			return _instance;
		}
		
		private var _wings:Dictionary=new Dictionary();
		
		public function addMount(id:int):void
		{
			var config2:MountConfig=new MountConfig();
			config2.init();
			_wings[id]=config2;
		}
		
		public function getMountConfig():MountConfig
		{
			return _wings[1];
		}
	}
}
