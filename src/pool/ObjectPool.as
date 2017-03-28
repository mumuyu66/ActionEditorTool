package pool {
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author yangyiqiang
	 */
	public class ObjectPool {
		private static var recyclers : Dictionary = new Dictionary();

		private static function getRecycler(type : Class) : Recycler {
			return type in recyclers ? recyclers[type] : recyclers[type] = new Recycler();
		}

		public static function getObject(type : Class, ...parameters) : * {
			var  recycler : Recycler = getRecycler(type);
			var value : *=recycler.get();
			if ( value) {
				return value;
			} else {
				value = getNewClass(type, parameters);
			}
			return value;
		}

		public static function disposeObject(object : *, type : Class = null) : void {
			if ( !type ) {
				var typeName : String = getQualifiedClassName(object);
				type =  ApplicationDomain.currentDomain.getDefinition(typeName) as Class;
			}
			var recycler : Recycler = getRecycler(type);
			recycler.push(object);
		}

		public static function clear() : void {
			for each (var recy : Recycler in recyclers) {
				recy.reset();
			}
			recyclers = new Dictionary();
		}

		private static function getNewClass(classRef : Class, initParms : Array) : * {
			if (initParms && initParms.length) {
				switch(initParms.length) {
					case 1:
						return new classRef(initParms[0]);
					case 2:
						return new classRef(initParms[0], initParms[1]);
					case 3:
						return new classRef(initParms[0], initParms[1], initParms[2]);
					case 4:
						return new classRef(initParms[0], initParms[1], initParms[2], initParms[3]);
					case 5:
						return new classRef(initParms[0], initParms[1], initParms[2], initParms[3], initParms[4]);
				}
			}
			return new classRef();
		}
	}
}
import flash.utils.Dictionary;


/**
     * 对象缓存复用工具类，可用于构建对象池。
     * 利用了Dictionary弱引用特性。一段时间后会自动回收对象。
     */
class Recycler {
	public function Recycler() {
	}

	private var cache : Dictionary = new Dictionary(true);

	public function push(object : *) : void {
		cache[object] = null;
	}

	public function get() : * {
		for (var object : * in cache) {
			delete cache[object];
			return object;
		}
	}

	public function reset() : void {
		cache = new Dictionary(true);
	}
}
