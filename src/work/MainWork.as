package work {
	import avatar.AvatarData;
	import org.osflash.signals.Signal;

	import flash.concurrent.Condition;
	import flash.concurrent.Mutex;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;

	/**
	 * @author yangyiqiang
	 */
	public class MainWork {
		private var _work : Worker;
		public var signal : Signal = new Signal(String, Object);

		public function init(bytes:ByteArray) : void {
			if (Worker.current.isPrimordial)
				createBackWork(bytes);
			else {
				new BackWork();
			}
		}

		private var _channelToMain : MessageChannel;
		private var _channelToBack : MessageChannel;
		private var _shareBytes : ByteArray;
		private var _condition : Condition;

		private function createBackWork(bytes:ByteArray) : void {
			_work = WorkerDomain.current.createWorker(bytes);
			_channelToMain = _work.createMessageChannel(Worker.current);
			_channelToBack = Worker.current.createMessageChannel(_work);
			_shareBytes = new ByteArray();
			_shareBytes.shareable = true;
			_condition = new Condition(new Mutex());
			_work.setSharedProperty("toMain", _channelToMain);
			_work.setSharedProperty("toBack", _channelToBack);
			_work.setSharedProperty("shareBytes", _shareBytes);
			_work.setSharedProperty("condition", _condition);
			_channelToMain.addEventListener(Event.CHANNEL_MESSAGE, onChannel, false, 0, true);
			_work.start();
		}

		private function onChannel(event : Event) : void {
			var cmd : String = _channelToMain.receive();
			_condition.mutex.lock();
			try {
				switch(cmd) {
					case MessageType.PARSE_OK:
						var avatarData:AvatarData=new AvatarData();
						avatarData.parse(_shareBytes);
						General.assetsPool.set(avatarData.key, avatarData);
						signal.dispatch(avatarData.key,avatarData);
						break;
				}
			} finally {
				_condition.mutex.unlock();
			}
		}

		public function runCMD(cmd : String, parameter : ByteArray,key:String) : void {
			if (!Worker.current.isPrimordial) return;
			_condition.mutex.lock();
			try {
				parameter.shareable=true;
				_work.setSharedProperty(key, parameter);
				_channelToBack.send(cmd+"|"+key);
			} finally {
				_condition.mutex.unlock();
			}
		}
	}
}
