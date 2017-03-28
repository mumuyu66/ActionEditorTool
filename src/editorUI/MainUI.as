package editorUI {
	import config.WingManager;
	import config.WingConfig;
	import config.MountManager;
	import avatar.AvatarData;

	import config.MountConfig;

	import pool.ObjectPool;

	import ui.controls.Button;
	import ui.core.Component;

	import utils.OpenFile;
	import utils.PNGEncoder;

	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileReference;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	/**
	 * @author yangyiqiang
	 */
	public class MainUI extends Component {
		private var _button : Button;
		private var _button2 : Button;
		private var _button3 : Button;
		private var _button4 : Button;
		private var _button6 : Button;
		private var _save : Button;
		private var _import : Button;
		private var _main : Main;
		[Embed(source="/../assets/InspectorSwf.swf" , mimeType="application/octet-stream")]
		private static var swf : Class;

		public function MainUI(main : Main) {
			super();
			_main = main;
			_fileRefer = new FileReference();
			loadSwf();
		}

		private function loadSwf() : void {
			var load : Loader = new Loader();
			load.contentLoaderInfo.addEventListener(Event.COMPLETE, initSwf);
			var lc : LoaderContext = new LoaderContext();
			lc.allowCodeImport = true;
			load.loadBytes(new swf(), lc);
		}

		private function initSwf(event : Event) : void {
			LoaderInfo(event.currentTarget).removeEventListener(Event.COMPLETE, initSwf);
			var _domain : ApplicationDomain = LoaderInfo(event.currentTarget).applicationDomain;
			var assetClass : Class = _domain.getDefinition("InspectorSwf") as Class;
			(new assetClass).init(_main);
		}

		override protected function initializeSignalHandlers() : void {
			super.initializeSignalHandlers();
			_button.signals.click.add(onClick);
			_button2.signals.click.add(onClick2);
			_button3.signals.click.add(onOutWing);

			_button4.signals.click.add(onClick4);
			_button6.signals.click.add(onOutMount);
			_save.signals.click.add(onSave);
			_import.signals.click.add(onImport);
		}

		override protected function create() : void {
			_button = new Button();
			_button.text = "导入翅膀";
			_button.x = 960;
			_button.y = 20;
			addChild(_button);

			_button2 = new Button();
			_button2.text = "下一动作";
			_button2.x = 900;
			_button2.y = 20;
			addChild(_button2);

			_button3 = new Button();
			_button3.text = "导出翅膀";
			_button3.x = 1020;
			_button3.y = 20;
			addChild(_button3);

			_save = new Button();
			_save.text = "保存";
			_save.x = 1080;
			_save.y = 20;
			addChild(_save);

			_import = new Button();
			_import.text = "导入";
			_import.x = 1140;
			_import.y = 20;
			addChild(_import);

			_button4 = new Button();
			_button4.text = "导入座骑";
			_button4.x = 1100;
			_button4.y = 60;
			addChild(_button4);

			_button6 = new Button();
			_button6.text = "导出座骑";
			_button6.x = 1100;
			_button6.y = 80;
			addChild(_button6);
		}

		private var _num : int;

		private function onClick2(event : MouseEvent) : void {
			_main.movePlayer.body.setAction(General.actionName[_num % General.actionName.length], -1);
			_num++;
		}

		private function onOutWing(event : MouseEvent) : void {
			if (!_main.movePlayer.wing || !_main.movePlayer.wing.wingAvatar) return;
			var file : FileReference = new FileReference();
			_name = String("wing_out" + new Date().getTime());
			_data = _main.movePlayer.wing.wingAvatar.animation.data;
			_data.out();
			file.save(_main.movePlayer.wing.wingConfig.toString(), "wing" + int(Math.random() * 100) + ".xml");
			file.addEventListener(Event.SELECT, onSelect2);
			_fileRefer.save(_data.xml, name + ".xml");
		}

		private function onClick(event : MouseEvent) : void {
			var load : LoadImage = ObjectPool.getObject(LoadImage);
			load.init(_main, "wing", "wing");
			OpenFile.browseForDirectory(load.onLoadComplete);
		}

		private var _role : int = 0;

		private function onClick4(event : MouseEvent) : void {
			var load : LoadImage = ObjectPool.getObject(LoadImage);
			load.init(_main, "ride_" + (++_role), "ride");
			OpenFile.browseForDirectory(load.onLoadComplete);
		}

		private var _fileRefer : FileReference;
		private var _data : AvatarData;
		private var _name : String;

		private function onOutMount(event : MouseEvent) : void {
			if (!_main.movePlayer.ride || !_main.movePlayer.ride.mountConfig) return;
			_name = String("mount_out" + new Date().getTime());
			_data = _main.movePlayer.ride.rideAvatar.animation.data;
			_data.out();
			_fileRefer.addEventListener(Event.SELECT, onSelect2);
			_fileRefer.save(_main.movePlayer.ride.mountConfig.toString(), "mount" + int(Math.random() * 100) + ".xml");
		}

		private function onSelect2(event : Event) : void {
			var fileStream : FileStream = new FileStream();
			var ba2 : ByteArray = new ByteArray();
			ba2.writeUTFBytes(_data.xml);
			var ba : ByteArray = PNGEncoder.encode(_data.bitmapData,ba2);
			fileStream.open(File.desktopDirectory.resolvePath(_name + ".png"), FileMode.WRITE);
			fileStream.writeBytes(ba, 0, ba.length);
			fileStream.close();

//			fileStream.open(File.desktopDirectory.resolvePath(_name + ".xml"), FileMode.WRITE);
//			var ba2 : ByteArray = new ByteArray();
//			ba2.writeUTFBytes(_data.xml);
//			fileStream.writeBytes(ba2, 0, ba2.length);
//			fileStream.close();
		}

		private function onSave(event : MouseEvent) : void {
			var name:String="";
			if (_main.movePlayer.ride) {
				_fileRefer.addEventListener(Event.COMPLETE, onSaveWing);
				name="mount" + int(Math.random() * 100) + ".xml";
				_data = _main.movePlayer.ride.rideAvatar.animation.data;
				_data.out();
				_fileRefer.save(_main.movePlayer.ride.mountConfig.toString(), name);
			}
		}
		
		private function onSaveWing(event:Event):void
		{
			_fileRefer.removeEventListener(Event.COMPLETE, onSaveWing);
			if (_main.movePlayer.wing) {
				name="wing" + int(Math.random() * 100) + ".xml";
				_data = _main.movePlayer.wing.wingAvatar.animation.data;
				_data.out();
				_fileRefer.save(_main.movePlayer.wing.wingConfig.toString(), name);
			}
		}

		private function onImport(event : MouseEvent) : void {
			_fileRefer.addEventListener(Event.SELECT, onSelect);
			_fileRefer.addEventListener(Event.CANCEL, clean);
			_fileRefer.browse();
		}

		private function onSelect(event : Event) : void {
			_fileRefer.removeEventListener(Event.SELECT, onSelect);
			_fileRefer.addEventListener(Event.COMPLETE, onComplete2);
			_fileRefer.load();
		}
		
		private function clean(event:Event):void
		{
			_fileRefer.removeEventListener(Event.SELECT, onSelect);
			_fileRefer.removeEventListener(Event.COMPLETE, onComplete2);
		}

		private function onComplete2(event : Event) : void {
			_fileRefer.removeEventListener(Event.COMPLETE, onComplete2);
			parseXML(XML(_fileRefer.data));
		}
		
		private function parseXML(xml:XML):void
		{
			if(xml.localName()=="mount")
			{
				var mountConfig:MountConfig=MountManager.instance.getMountConfig();
				for each(var mXml:XML in xml.children())
				{
					mountConfig.setValue(mXml.@id, mXml.@action, mXml.@offsetX, mXml.@offsetY);
				}
			}else if(xml.localName()=="wing")
			{
				var wingConfig:WingConfig=WingManager.instance.getWing();
				for each(var wXml:XML in xml.children())
				{
					wingConfig.setValue(wXml.@id, wXml.@action, wXml.@offsetX, wXml.@offsetY);
				}
			}
		}
	}
}
