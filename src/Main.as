package {
	import utils.PNGDecoder;
	import flash.utils.ByteArray;
	import flash.geom.Rectangle;
	import avatar.AnimationController;
	import avatar.Asset;
	import avatar.Avatar;
	import avatar.AvatarAssets;
	import avatar.component.Ride;
	import avatar.component.Wing;

	import config.MountManager;
	import config.WingManager;

	import editorUI.MainUI;

	import map.MapContainer;

	import type.parse.AvatarParse;

	import word.controller.MoveController;
	import word.player.Player;

	import work.MainWork;
	import work.MessageType;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.system.Worker;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	/**
	 * @author yangyiqiang
	 */
	[ SWF ( frameRate="60" , backgroundColor=0x000000,width="1200" , height="750" ) ]
	public class Main extends Sprite {
		private var _map : MapContainer;
		private var _moveController : MoveController;
		private var _work : MainWork;
		private var _view : MainUI;
		private var _keys : Array = [Keyboard.LEFT, Keyboard.RIGHT, Keyboard.W, Keyboard.UP, Keyboard.S, Keyboard.DOWN];
		private var _avatars : Array = ["1", "2", "3", "4", "5", "6", "7","8" ,"9","A", "B","C","D","E","F","G","H","I","J","K","L","M","N","O"];
		private var _avatarKeys : Array = ["1", "2", "3", "4", "5", "6","rider_1", "rider_2", "rider_3", "rider_4", "rider_5","rider_6","fashion_id1_sex1","fashion_id1_sex2","fashion_rider_id1_sex1","fashion_rider_id1_sex2","fashion_id2_sex1","fashion_id2_sex2","fashion_rider_id2_sex1","fashion_rider_id2_sex2","fashion_id3_sex1","fashion_id3_sex2","fashion_rider_id3_sex1","fashion_rider_id3_sex2"];
		private var _key : Array = [];

		public function Main() {
			initializeStage(this.stage);
			General.root = this;
			init();
			_map = new MapContainer();
			_map.init();
			_moveController = new MoveController();
			_map.moveController = _moveController;
			_work = new MainWork();
			_work.init(this.loaderInfo.bytes);
			if (!Worker.current.isPrimordial) return;
			_work.signal.add(signal);
			for (var i : int = 0; i < _avatars.length; i++) {
				_work.runCMD(MessageType.REQUESET_PARSE, AvatarAssets.getBytes(_avatars[i]), _avatarKeys[i]);
			}
//			_work.runCMD(MessageType.REQUESET_PARSE, AvatarAssets.getBytes("1"), "1");
			for (i = 1; i < 10; i++) {
				_key.push(Keyboard.NUMBER_0 + i);
			}
			_key.push(Keyboard.A);
			_key.push(Keyboard.B);
			_key.push(Keyboard.C);
			_key.push(Keyboard.D);
			_key.push(Keyboard.E);
			_key.push(Keyboard.F);
			_key.push(Keyboard.G);
			
			_key.push(Keyboard.H);
			_key.push(Keyboard.I);
			_key.push(Keyboard.J);
			_key.push(Keyboard.K);
			
			_key.push(Keyboard.L);
			_key.push(Keyboard.M);
			_key.push(Keyboard.N);
			_key.push(Keyboard.O);
			
			this.addChild(_map);
			_view = new MainUI(this);
			addChild(_view);

			General.keyboardManager.bind(this.stage);
			for (i = 0; i < _key.length; i++) {
				General.keyboardManager.keyUp(_key[i]).add(keyUP);
			}
			for (i = 1; i < _keys.length; i++) {
				General.keyboardManager.keyUp(_keys[i]).add(keyDown);
			}
		}

		private function keyUP(name : String, key : uint) : void {
			var index : int = _key.indexOf(key);
			if (index>=0)
				setMovePlayer(_players[_avatarKeys[index]]);
		}

		private function keyDown(name : String, key : uint) : void {
			var movePlayer : Player = _map.player;
			switch(key) {
				case Keyboard.LEFT:
					movePlayer.wing.wingAvatar.x--;
					movePlayer.wing.setWingPoint();
					break;
				case Keyboard.RIGHT:
					movePlayer.wing.wingAvatar.x++;
					movePlayer.wing.setWingPoint();
					break;
				case Keyboard.UP:
					movePlayer.wing.wingAvatar.y--;
					movePlayer.wing.setWingPoint();
					break;
				case Keyboard.DOWN:
					movePlayer.wing.wingAvatar.y++;
					movePlayer.wing.setWingPoint();
					break;
				case Keyboard.W:
					movePlayer.wing.setLayer(true);
					break;
				case Keyboard.S:
					movePlayer.wing.setLayer(false);
					break;
			}
		}

		private function signal(str : String, data : Object) : void {
			trace(str, data);
			addPlayer(str);
		}

		private var _players : Dictionary = new Dictionary();

		public function addPlayer(key : String) : void {
			var _player : Player = new Player();
			_player.animationController=new AnimationController();
			var assest : Asset = new Asset(key);
			assest.state = Asset.ASSEST_DATA;
			_player.body = new Avatar(assest,_player.animationController);
			_player.body.x = this.stage.stageWidth / 2 + 300 * Math.random();
			_player.body.y = this.stage.stageHeight / 2 + 300 * Math.random();
			var index : int = _avatarKeys.indexOf(key);
			if (index>=0)
				_player.setName(_avatars[index]);
			_map.addChild(_player.body);
			_players[key] = _player;
			setMovePlayer(_player);
		}

		public var movePlayer : Player;

		public function setMovePlayer(player : Player) : void {
			if(!player)return;
			if (_moveController.runAction)
				_moveController.runAction.stand();
			_moveController.avatar = player.body;
			_moveController.init();
			_map.player = player;
			movePlayer = player;
		}

		public function addWing() : void {
			var assest : Asset = new Asset("wing");
			assest.state = Asset.ASSEST_DATA;
			for each (var player : Player in _players) {
				var wing : Avatar = new Avatar(assest,player.animationController);
				var w : Wing = new Wing(player.body, wing,WingManager.instance.getWing());
				player.addWing(w);
			}
		}

		public function addRider(key : String) : void {
//			var _player : Player = new Player();
//			var assest : Asset = new Asset(key);
//			assest.state = Asset.ASSEST_DATA;
//			_player.body = new Avatar(assest);
//			_player.body.x = this.stage.stageWidth / 2 + 300 * Math.random();
//			_player.body.y = this.stage.stageHeight / 2 + 300 * Math.random();
//			_player.setName(key);
//			_map.addChild(_player.body);
//			_players[6 + int(key.split("_")[1])] = _player;
		}

		public function addRide(key : String) : void {
			var assest : Asset = new Asset(key);
			assest.state = Asset.ASSEST_DATA;
			for each (var player : Player in _players) {
				var rideAvatar : Avatar = new Avatar(assest,player.animationController);
				var ride : Ride = new Ride(player.body, rideAvatar,MountManager.instance.getMountConfig());
				player.addRide(ride);
			}
		}

		private function initializeStage(_stage : Stage) : void {
			_stage.quality = StageQuality.HIGH;
			_stage.scaleMode = StageScaleMode.NO_SCALE;
			_stage.align = StageAlign.TOP_LEFT;
		}
		
		[Embed(source="/../assets/wing_out1384409819878.png")]
		private static var img2 : Class;
		
		public  function  init():void
		{
			var load:MyLoader=new MyLoader("../assets/wing_out1384409819878.png", onComplete,null);
			load.load();
//			var bitmapData:ByteArray=(new img2());
			
		}
		
		private function onComplete(load:MyLoader):void
		{
			PNGDecoder.decoder(load.getByteArray());
		}
	}
}

import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.errors.IOError;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.URLRequest;
import flash.net.URLStream;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.utils.ByteArray;

class MyLoader {
	protected var _stream : URLStream;
	protected var _byteArray : ByteArray;
	private var _loader : Loader;
	private var _domain : ApplicationDomain;

	private function addStreamEvents() : void {
		_stream.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		_stream.addEventListener(Event.COMPLETE, completeHandler);
		_stream.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
	}

	private function removeStreamEvents() : void {
		if (!_stream) return;
		_stream.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
		_stream.removeEventListener(Event.COMPLETE, completeHandler);
		_stream.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
	}

	private function ioErrorHandler(event : IOErrorEvent) : void {
		onError(event.text);
	}

	private function progressHandler(event : ProgressEvent) : void {
	}

	private function completeHandler(event : Event) : void {
		removeStreamEvents();
		_byteArray = new ByteArray();
		var length : int = _stream.bytesAvailable;
		_stream.readBytes(_byteArray, 0, length);
		_stream.close();
		onComplete();
	}

	protected function onComplete() : void {
		loadEnd();
	}

	protected function onError(message : String) : void {
		removeStreamEvents();
		loadEnd(true);
		trace(message);
	}

	protected function loadEnd(isError : Boolean = false) : void {
		if (!isError) {
			if (_type == "SWFLoader") {
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfCompleteHandler);
				var lc : LoaderContext = new LoaderContext();
				lc.allowCodeImport = true;
				_loader.loadBytes(_byteArray, lc);
			} else
				_onComplete(this);
		}
	}

	private function swfCompleteHandler(event : Event) : void {
		_domain = LoaderInfo(event.currentTarget).applicationDomain;
		if (_onComplete != null)
			_onComplete(this);
	}

	private var _url : String;
	private var _onComplete : Function;
	private var _version : String;
	private var _type : String;

	public function MyLoader(url : String, onComplete : Function, type : String = "SWFLoader", version : String = "") {
		_url = url;
		_onComplete = onComplete;
		_version = version;
		_type = type;
	}

	public function load() : void {
		_stream = new URLStream();
		addStreamEvents();
		var request : URLRequest = new URLRequest(_url);
		try {
			_stream.load(request);
		} catch(e : IOError) {
			onError(e.message);
		} catch(e : SecurityError) {
			onError(e.message);
		}
	}

	public function getByteArray() : ByteArray {
		return _byteArray;
	}

	public function clear() : void {
		removeStreamEvents();
		_byteArray = null;
		if (_stream && _stream.connected)
			_stream.close();
		if (_loader)
			_loader.unloadAndStop(false);
	}

	public function getClass(className : String) : Class {
		if (!_domain || !_domain.hasDefinition(className)) {
			return null;
		}
		var assetClass : Class = _domain.getDefinition(className) as Class;
		return assetClass;
	}
}
