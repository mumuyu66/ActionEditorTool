package config {
	import flash.utils.Dictionary;
	/**
	 * @author yangyiqiang
	 */
	public class MountConfig {
		private var _dic : Dictionary = new Dictionary();

		public function addMergeId(key : String, item : Dictionary) : void {
			_dic[key] = item;
		}

		public function setValue(id : String, action : String, offsetX : int, offsetY : int, layer : int = -1) : void {
			if(!_dic[id])return;
			var item :WingItem = _dic[id][action];
			if (item) {
				item.offsetX = offsetX;
				item.offsetY = offsetY;
				if (layer != -1)
					item.layer = layer;
			}
		}

		public function getDic(id : String) : Dictionary {
			return _dic[id];
		}

		private var _arr : Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

		public function init() : void {
			var dic : Dictionary;
			var j : int = 0;
			var item :WingItem;
			for each (var key : String in General.mountName){
				j = 0;
				dic = new Dictionary();
				for each (var name : String in General.actionName) {
					item = new WingItem();
					item.action = name;
					item.key = key;
					item.layer = 0;
					item.offsetX = 111;
					item.offsetY = 63;
					item.layer = _arr[j];
					dic[name] = item;
					j++;
				}
				addMergeId(key, dic);
			}
		}

		public function toString() : String {
			var str : String = "<mount>\n";
			var item :WingItem;
			var dic:Dictionary;
			for each(var key:String in General.mountName)
			{
				dic=_dic[key];
				for each (var name : String in General.actionName) {
					item = dic[name];
					if (item) {
						str += item.toString() ;
						str += "\n";
					}
				}
			}
			return str + "</mount>";
		}
	}
}
