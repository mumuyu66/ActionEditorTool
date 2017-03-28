package avatar {
	import flash.geom.Rectangle;
	import avatar.action.ActionVO;

	import utils.DictionaryUtil;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * @author yangyiqiang
	 */
	public class AvatarData {
		public var key : String;
		public var topX : int ;
		public var topY : int;
		public var bottomX : int;
		public var bottomY : int;
		public var bottom : Dictionary = new Dictionary();
		public var topPoint : Dictionary = new Dictionary();
		public var actions : Dictionary = new Dictionary();
		public var eventFrames : Dictionary;
		public var actionEndFrames : Array = [] ;
		public var dataList : Array = [];
		public var delay : int = 60;
		private var _xml : String = null;
		private var _bitmapData : BitmapData;

		public function get bitmapData() : BitmapData {
			return _bitmapData;
		}

		public function get xml() : String {
			return _xml;
		}

		public function parse(bytes : ByteArray) : void {
			key = bytes.readUTF();
			topX = bytes.readInt();
			topY = bytes.readInt();
			var temp : uint = bytes.readUnsignedInt();
			delay = temp & 0xff;
			var len : uint = (temp >>> 8) & 0xff;
			for (var i : int = 0; i < len; i++) {
				var vo : ActionVO = new ActionVO();
				vo.parse(bytes);
				actions[vo.name] = vo;
			}
			len = temp >>> 16;
			for (i = 0; i < len; i++) {
				var data : BDUnit = new BDUnit();
				data.parse(bytes);
				dataList.push(data);
			}
		}

		public function out() : void {
			var obj : Object;
			var xml : String = "<action";
			xml += " topX=" + "\'0\'" ;
			xml += " topY=" + "\'0\'";
			xml += " bottomX=" + "\'0 \'";
			xml += " bottomY=" + "\'0 \'";
			xml += " >";
			var vo : ActionVO;
			var i : int;
			var unit : BDUnit;
			var indexX : int = 0;
			var indexY : int = 0;
			var maxHight : int = 0;
			
			var temp : BitmapData = new BitmapData(2880, 2880, true, 0);
			for each (var name : String in General.actionName) {
				vo = actions[name] != null ? actions[name] : actions["1"];
				xml += "<frame name=" + "\'aaaaaa_" + name + "\' >";
				for (i = vo.startFrame; i < vo.endFrame; i++) {
					unit = dataList[i];
					obj = unit.output(temp, indexX, indexY, maxHight);
					indexX = obj["x"];
					indexY = obj["y"];
					maxHight = obj["hight"];
					xml += obj["xml"];
				}
				xml += "</frame>";
			}
			xml += "</action>";
			_xml = xml;
			if(_bitmapData)return;
			_bitmapData = new BitmapData(2880, indexY + maxHight);
			_bitmapData.copyPixels(temp, _bitmapData.rect, new Point());
		}

		public function serialize(out : ByteArray) : void {
			out.writeUTF(key);
			out.writeInt(topX);
			out.writeInt(topY);
			var temp : uint = delay + (actionEndFrames.length << 8) + (dataList.length << 16);
			out.writeUnsignedInt(temp);
			for each (var vo : ActionVO in actions) {
				vo.serialize(out);
			}
			for each (var unit : BDUnit in dataList) {
				unit.serialize(out);
			}
		}

		public function merge(data : AvatarData, config : Dictionary) : AvatarData {
			var key : String = data.key + "|" + key;
			var avatarData : AvatarData = General.assetsPool.get(key);
			if (!avatarData) {
				avatarData = new AvatarData();
				General.assetsPool.set(key, avatarData);
			}
			avatarData.key = key;
			avatarData.topX = Math.max(data.topX, topX);
			avatarData.topY = Math.max(data.topY, topY);
			avatarData.delay = Math.min(data.delay, delay);
			avatarData.actions = new Dictionary();
			avatarData.actionEndFrames = actionEndFrames;
			avatarData.eventFrames = eventFrames;
			avatarData.dataList = [];
			var action2 : ActionVO;
			var unit : BDUnit;
			var k : uint = 0;
			var vo : ActionVO;
			for each (var actionVO : ActionVO in actions) {
				action2 = data.actions[actionVO.name];
				vo = new ActionVO();
				vo.name = actionVO.name;
				vo.startFrame = k;
				for (var i : int = actionVO.startFrame,j : int = action2.startFrame; i < actionVO.endFrame; i++,j++) {
					unit = dataList[i];
					avatarData.dataList.push(unit.merge(data.dataList[j], config[actionVO.name]));
					k++;
				}
				vo.endFrame = k;
				avatarData.actions[vo.name] = vo;
			}
			return avatarData;
		}
	}
}
