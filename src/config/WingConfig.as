package config {
	import flash.utils.Dictionary;

	/**
	 * @author yangyiqiang
	 */
	public class WingConfig {
		/**
		 * 
		 * id=1 action=1 offsetX=-79 offsetY=-122 layer=0
		id=1 action=2 offsetX=-63 offsetY=-123 layer=0
		id=1 action=3 offsetX=-84 offsetY=-128 layer=0
		id=1 action=4 offsetX=-79 offsetY=-122 layer=0
		id=1 action=5 offsetX=-90 offsetY=-130 layer=0
		id=1 action=6 offsetX=-90 offsetY=-130 layer=0
		id=1 action=7 offsetX=-90 offsetY=-130 layer=0
		id=1 action=8 offsetX=-90 offsetY=-130 layer=0
		id=1 action=9 offsetX=-79 offsetY=-122 layer=0
		id=1 action=10 offsetX=-78 offsetY=-144 layer=0
		id=1 action=20 offsetX=-90 offsetY=-130 layer=0
		 */
		private var _wingDic : Dictionary = new Dictionary();
		
		public function WingConfig()
		{
			init();
		}

		public function addMergeId(key :String, item : Dictionary) : void {
			_wingDic[key] = item;
		}

		public function setValue(id : String, action : String, offsetX : int, offsetY : int, layer : int = -1) : void {
			var item :WingItem = _wingDic[id][action];
			if (item) {
				item.offsetX = offsetX;
				item.offsetY = offsetY;
				if (layer != -1)
					item.layer = layer;
			}
		}

		public function getWingDic(id : String) : Dictionary {
			return _wingDic[id];
		}

		private var _arr : Array = [0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1];
		/**
		 * <item id= '1' action='1' offsetX='88' offsetY='46' layer='0'/>
<item id= '1' action='2' offsetX='85' offsetY='36' layer='0'/>
<item id= '1' action='3' offsetX='76' offsetY='28' layer='0'/>
<item id= '1' action='4' offsetX='80' offsetY='33' layer='1'/>
<item id= '1' action='5' offsetX='79' offsetY='32' layer='1'/>
<item id= '1' action='6' offsetX='79' offsetY='42' layer='0'/>
<item id= '1' action='7' offsetX='78' offsetY='38' layer='0'/>
<item id= '1' action='8' offsetX='82' offsetY='32' layer='1'/>
<item id= '1' action='9' offsetX='80' offsetY='26' layer='1'/>
<item id= '1' action='10' offsetX='78' offsetY='30' layer='1'/>
<item id= '1' action='20' offsetX='82' offsetY='73' layer='0'/>
		 */
		private var _arr2 : Array = [{x:88,y:46}, {x:85,y:36}, {x:76,y:28}, {x:80,y:33}, {x:79,y:32}, {x:79,y:42}, {x:78,y:38}, {x:82,y:32}, {x:80,y:26}, {x:78,y:30}, {x:82,y:73}];
		public function init() : void {
			var dic : Dictionary;
			var j : int = 0;
			var item :WingItem;
			for each (var key : String in General.wingName){
				j = 0;
				dic = new Dictionary();
				for each (var name : String in General.actionName) {
					item = new WingItem();
					item.action = name;
					item.key = key;
					item.layer = 0;
					item.offsetX = _arr2[j]["x"];
					item.offsetY = _arr2[j]["y"];
					item.layer = _arr[j];
					dic[name] = item;
					j++;
				}
				addMergeId(key, dic);
			}
		}

		public function toString() : String {
			var str : String = "<wing>\n";
			var item :WingItem;
			var dic:Dictionary;
			for each(var key:String in General.wingName)
			{
				dic=_wingDic[key];
//			for each (var dic : Dictionary in _wingDic) {
				for each (var name : String in General.actionName) {
					item = dic[name];
					if (item) {
						str += item.toString() ;
						str += "\n";
					}
				}
			}
			return str + "</wing>";
		}
	}
}
