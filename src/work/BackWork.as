package work {
	import type.parse.AvatarParse;

	import pool.ObjectPool;

	import type.load.AvatarLoad;

	import flash.concurrent.Condition;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;

	/**
	 * @author yangyiqiang
	 */
	public class BackWork extends Sprite {
		private var _channelToMain : MessageChannel;
		private var _channelToBack : MessageChannel;
		private var _shareBytes : ByteArray;
		private var _condition : Condition;

		public function BackWork() {
			this.addEventListener(Event.ENTER_FRAME, onEntrFrame);
			if (Worker.current.isPrimordial) return;
			_channelToMain = Worker.current.getSharedProperty("toMain");
			_channelToBack = Worker.current.getSharedProperty("toBack");
			_shareBytes = Worker.current.getSharedProperty("shareBytes");
			_condition = Worker.current.getSharedProperty("condition");
			_channelToBack.addEventListener(Event.CHANNEL_MESSAGE, onChannelMessage, false, 0, true);
		}

		private function onChannelMessage(event : Event) : void {
			var arr:Array=(_channelToBack.receive() as String).split("|");
			var cmd : String = arr[0];
			var key:String=arr[1];
			switch(cmd) {
				case MessageType.REQUESET_PARSE:
					var byte : ByteArray = Worker.current.getSharedProperty(key);
					var bytes : ByteArray = new ByteArray();
					bytes.writeBytes(byte);
					load(bytes,key);
					break;
			}
		}

		private function load(bytes : ByteArray,key:String) : void {
			var load : AvatarLoad = ObjectPool.getObject(AvatarLoad);
			load.init();
			load.key = key;
			load.complete.add(complete);
			load.loadByteArray(bytes);
		}

		private function complete(key : String, loader : AvatarLoad) : void {
			loader.complete.removeAll();
			var text : String = (loader.getMovieClip("text")).getChildAt(0)["text"];
			var xml : XML = new XML(text);
			var source : BitmapData = new (loader.getClass("source")) as BitmapData;
			ObjectPool.disposeObject(loader);
			_condition.mutex.lock();
			try {
				AvatarParse.parseBD(key, xml, source, _shareBytes);
				_channelToMain.send(MessageType.PARSE_OK);
			} finally {
				_condition.mutex.unlock();
			}
		}

		private function onEntrFrame(event : Event) : void {
		}
	}
}