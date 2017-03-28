package type.parse {
	import flash.utils.ByteArray;
	import avatar.AvatarData;
	import avatar.BDUnit;
	import avatar.action.ActionVO;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * @author yangyiqiang
	 */
	public class AvatarParse {
		public static function parseBD(key:String,xml : XML, source : BitmapData,out:ByteArray) : void {
			var avatarData : AvatarData =new AvatarData();
			avatarData.topX = -60;
			avatarData.topY = int(xml.attribute("topY"));
			avatarData.dataList = [];
			avatarData.actionEndFrames = [];
			avatarData.actions = new Dictionary();
			avatarData.key=key;

			var bottomX : int = int(xml.attribute("bottomX"));
			var bottomY : int = int(xml.attribute("bottomY"));
			var i : int = 0;
			for each (var frameXML : XML in xml["frame"]) {
				var action : String = String(int(String(frameXML.@name).split("_")[1]));
				var vo : ActionVO = new ActionVO();
				vo.name = action;
				vo.startFrame = i;
				for each (var frame : XML in frameXML["item"]) {
					var unit : BDUnit = new BDUnit();
					var rect : Rectangle = new Rectangle(frame. @ x, frame. @ y, frame. @ w, frame. @ h);
					var bds : BitmapData = new BitmapData(rect.width, rect.height, true, 0);

					bds.copyPixels(source, rect, new Point());
					unit.offset = new Point(int(frame.@offsetX) + bottomX, int(frame.@offsetY) + bottomY);
					unit.bds = bds;
					avatarData.dataList.push(unit);
					i++;
				}
				vo.endFrame = i;
				avatarData.actions[action] = vo;
				avatarData.actionEndFrames.push(i);
				if (avatarData.delay == 60)
					avatarData.delay = frameXML.@time;
			}
			avatarData.serialize(out);
		}
		
		public static function parseBD2(key:String,xml : XML, source : BitmapData) :AvatarData {
			var avatarData : AvatarData =new AvatarData();
			avatarData.topX = -60;
			avatarData.topY = int(xml.attribute("topY"));
			avatarData.dataList = [];
			avatarData.actionEndFrames = [];
			avatarData.actions = new Dictionary();
			avatarData.key=key;

			var bottomX : int = int(xml.attribute("bottomX"));
			var bottomY : int = int(xml.attribute("bottomY"));
			var i : int = 0;
			for each (var frameXML : XML in xml["frame"]) {
				var action : String = String(int(String(frameXML.@name).split("_")[1]));
				var vo : ActionVO = new ActionVO();
				vo.name = action;
				vo.startFrame = i;
				for each (var frame : XML in frameXML["item"]) {
					var unit : BDUnit = new BDUnit();
					var rect : Rectangle = new Rectangle(frame. @ x, frame. @ y, frame. @ w, frame. @ h);
					var bds : BitmapData = new BitmapData(rect.width, rect.height, true, 0);

					bds.copyPixels(source, rect, new Point());
					unit.offset = new Point(int(frame.@offsetX) + bottomX, int(frame.@offsetY) + bottomY);
					unit.bds = bds;
					avatarData.dataList.push(unit);
					i++;
				}
				vo.endFrame = i;
				avatarData.actions[action] = vo;
				avatarData.actionEndFrames.push(i);
				if (avatarData.delay == 60)
					avatarData.delay = frameXML.@time;
			}
			General.assetsPool.set(avatarData.key, avatarData);
			return avatarData;
		}
	}
}
