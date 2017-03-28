package editorUI {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import avatar.AvatarData;
	import avatar.BDUnit;
	import avatar.action.ActionVO;

	import pool.ObjectPool;

	import utils.BDUtil;
	import utils.OpenFile;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.Dictionary;

	/**
	 * @author yangyiqiang
	 */
	public class LoadImage {
		private var _main : Main;
		private var _key : String;
		private var _type : String;
		private var _actions : Dictionary = new Dictionary();

		public function LoadImage() {
		}

		public function init(main : Main, key : String, type : String = "wing") : void {
			_main = main;
			_key = key;
			_type = type;
			_total = 0;
			_num = 0;
			_end = false;
			_isOK = false;
			_actions = new Dictionary();
		}

		private var _load : Loader;
		private var _end : Boolean = false;

		public function onLoadComplete(file : File) : void {
			if (!file) return;
			var fileList : Array = file.getDirectoryListing();
			var tempList : Array;
			fileList.sortOn("name");
			_end = false;
			for each (var f : File in fileList) {
				var arr : Array = [];
				if (!f.isDirectory || f.nativePath.indexOf(".svn") >= 0) continue;
				trace(f.nativePath);
				tempList = f.getDirectoryListing();
				tempList.sortOn("name");
				for each (var f2 : File in tempList) {
					if (f2.isDirectory) continue;
					if (f2.name.indexOf(".png") < 0) continue;
					_total++;
					_load = ObjectPool.getObject(Loader);
					_load.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
					_load.x = 500 * Math.random();
					_load.y = 500 * Math.random();
					_load.loadBytes(OpenFile.open(f2));
					// trace(f2.nativePath);

					// var bit:BitmapData=PNGDecoder.decoder(OpenFile.open(f2));
					// addChild(new Bitmap(bit));
					// addChild(_load);
					arr.push(_load);
				}
				_actions[String(int(f.name.split("_")[1]))] = arr;
			}
			_end = true;
		}

		private var _num : int;
		private var _total : int;
		private var _isOK : Boolean = false;

		public function onComplete(event : Event) : void {
			LoaderInfo(event.currentTarget).removeEventListener(Event.COMPLETE, onComplete);
			ObjectPool.disposeObject(event.target);
			_num++;
			if (_end && _total <= _num) _isOK = true;
			if (!_isOK) return;
			// PNGDecoder.decoder(PNGEncoder.encode(((_actions["1"][0] as Loader).content as Bitmap).bitmapData));
			var avatarData : AvatarData = new AvatarData();
			avatarData.topX = -60;
			avatarData.topY = 10;
			avatarData.dataList = [];
			avatarData.actionEndFrames = [];
			avatarData.actions = new Dictionary();
			avatarData.key = _key;
			var arr : Array;
			var i : int = 0;
			for each (var key : String in General.actionName) {
				var vo : ActionVO = new ActionVO();
				vo.name = key;
				vo.startFrame = i;
				arr = _actions[key];
				for each (var loader : Loader in arr) {
					var bitmap:BitmapData=(loader.content as Bitmap).bitmapData;
					var unit : BDUnit = BDUtil.getOffBD(bitmap);
					unit.offset=new Point(unit.offset.x-bitmap.width,unit.offset.y-bitmap.height);
					avatarData.dataList.push(unit);
					i++;
				}
				vo.endFrame = i;
				avatarData.actions[key] = vo;
				avatarData.actionEndFrames.push(i);
				avatarData.delay = 60;
			}
			if(_type=="wing")
			{
				vo  = new ActionVO();
				vo.name = "20";
				vo.startFrame = i;
				var vo2:ActionVO=avatarData.actions["1"];
				for (var j:int=vo2.startFrame;j<vo2.endFrame;j++)
				{
					avatarData.dataList.push(avatarData.dataList[j]);
					i++;
				}
				vo.startFrame = i;
				avatarData.actions[vo.name] = vo;
				avatarData.actionEndFrames.push(i);
			}
			General.assetsPool.set(_key, avatarData);
			switch(_type) {
				case "wing":
					_main.addWing();
					break;
				case "ride":
					_main.addRide(_key);
					break;
				case "rider":
					_main.addRider(_key);
					break;
			}

			_main = null;
			_load = null;
			_total = 0;
			_num = 0;
			_end = false;
			_isOK = false;
			_actions = new Dictionary();
			ObjectPool.disposeObject(this);
		}
	}
}
