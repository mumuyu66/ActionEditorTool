package type.load {
	import org.osflash.signals.Signal;

	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	/**
	 * @author yangyiqiang
	 */
	public class AvatarLoad {
		private var _loader:Loader;
		private var _domain : ApplicationDomain;
		public const complete:Signal=new Signal(String,AvatarLoad); 
		public function AvatarLoad()
		{
			
		}
		
		public function init():void
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			var lc : LoaderContext = new LoaderContext();
			lc.allowCodeImport = true;
			_byteArray=null;
			_key="";
			_domain=null;
		}
		
		
		private var _key:String;
		public function set key(value:String):void
		{
			_key=value;	
		}
		
		private function completeHandler(event:Event):void
		{
			_domain = LoaderInfo(event.currentTarget).applicationDomain;
			complete.dispatch(_key,this);
		}
		
		private var _byteArray:ByteArray;
		public function loadByteArray(bytes:ByteArray):void
		{
			_byteArray=bytes;
			_loader.loadBytes(_byteArray);
		}
		
		public function get byteArray():ByteArray
		{
			return _byteArray;
		}
		
		public function get load():Loader
		{
			return _loader;
		}
		
		public function getClass(className : String) : Class {
			if (!_domain || !_domain.hasDefinition(className)) {
				//Logger.error("SWFLoader:" + className + " not find in " + _libData.url);
				return null;
			}
			var assetClass : Class = _domain.getDefinition(className) as Class;
			return assetClass;
		}

		public function getMovieClip(className : String) : MovieClip {
			return getObj(className);
		}

		public function getObj(className : String) : * {
			var assetClass : Class = getClass(className);
			if (assetClass == null) return null;
			var mc : * = new assetClass() ;
			if (mc == null) {
				return mc;
			}
			return mc;
		}
	}
}
