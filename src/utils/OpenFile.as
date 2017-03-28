package utils {
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;


	public class OpenFile extends EventDispatcher
	{
		
		public static function browseForDirectory(browseHandler:Function,title:String=""):void{
			new BrowseForDirectory(title,browseHandler);
		}
		
		public static function browseForOpen(browseHandler:Function,title:String="",fileTypes:Array = null):void{
			new BrowseForOpen(fileTypes,title,browseHandler);
		}
		
		public static function browseForOpenMultiple(browseHandler:Function,title:String="",fileTypes:Array = null):void{
			new BrowseForOpenMultiple(fileTypes,title,browseHandler);
	    }
		
		public static function browseForSave(browseHandler:Function,title:String=""):void{
			new BrowseForSave(title,browseHandler);
		}
	    
		public static function open(file:File):ByteArray{
			if(!file || !file.exists){
				return null;
			}
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ );
			var fileDate:ByteArray = new ByteArray();
			stream.readBytes( fileDate, 0, stream.bytesAvailable );
			stream.close();
			return fileDate;
			
		}
		
		public static function openAsTxt(file:File,type:String=null):String{
			var b:ByteArray = open(file);
			if(!b){
				return null;
			}
			b.position = 0;
			type = type ? type : getFileType(b);
			b.position = 0;
			return b.readMultiByte(b.bytesAvailable,type);
		}
		
		public static function openAsObj(file:File,inflate:Boolean = false):*{
			var b:ByteArray = open(file);
			if(!b){
				return null;
			}
			b.position = 0;
			if(inflate){
				b.inflate();
				b.position = 0;
			}
			return b.readObject();
		}
		
		public static function getFileType(bytes:ByteArray):String{
			var b0:int = bytes.readUnsignedByte();
			var b1:int = bytes.readUnsignedByte();
			bytes.position =0;
			if(b0==0xFF && b1==0xFE){
				return "unicode";
			}else if(b0==0xFE && b1==0xFF){
				return "unicodeFFFE";
			}else if(b0==0xEF && b1==0xBB){
				return "utf-8";
			}else{
				return "gb2312";
			}
			
		}
		
		public static function write(data:*,path:String):File{
			var stream:FileStream;
			var byte:ByteArray;
			if(data is ByteArray){
				byte = data as ByteArray;
			}else if(data is String){
				byte = new ByteArray();
				byte.writeUTFBytes(data);
			}else{
				byte = new ByteArray();
				byte.writeObject(data);
			}
			
			byte.position = 0;
			
			try{
				var _file:File =new File(path);
				stream = new FileStream();
				stream.open( _file, FileMode.WRITE );
				stream.writeBytes( byte );
				stream.close();
				return _file;
			}catch(e:Error){
				
			}
			return null;
		}
		
		
	}
}
import flash.events.Event;
import flash.events.FileListEvent;
import flash.filesystem.File;

class BrowseForDirectory{
	protected var openHandler:Function;
	protected var title:String;
	protected var file:File;
	public function BrowseForDirectory(title:String,openHandler:Function){
		this.title = title;
		this.openHandler = openHandler;
		if(this.file == null)
			this.file = new File();
		file.addEventListener(Event.SELECT,selectHandler);
		file.addEventListener(FileListEvent.SELECT_MULTIPLE,selectMultipleHandler);
		file.addEventListener(Event.CANCEL,cancelHandler);
		doOpen();
	}
	
	protected function selectMultipleHandler(event:FileListEvent):void{
		if(openHandler != null){
			openHandler(event.files);
		}
		disponse();
	}
	
	protected function selectHandler(event:Event):void{
		if(file.exists && openHandler != null){
			openHandler(file);
		}
		disponse();
	}
	
	protected function cancelHandler(event:Event):void{
		if(openHandler != null){
			openHandler(null);
		}
		disponse();
	}
	
	protected function doOpen():void{
		file.browseForDirectory(title);
	}
	
	protected function disponse():void{
		file.removeEventListener(Event.SELECT,selectHandler);
		file.removeEventListener(FileListEvent.SELECT_MULTIPLE,selectMultipleHandler);
		file.removeEventListener(Event.CANCEL,cancelHandler);
	}
}



class BrowseForOpen extends BrowseForDirectory{
	protected var fileTypes:Array;
	public function BrowseForOpen(fileTypes:Array,title:String,openHandler:Function){
		this.fileTypes = fileTypes;
		super(title,openHandler);
	}
	
	override protected function doOpen():void{
		file.browseForOpen(title,fileTypes);
	}
}

class BrowseForOpenMultiple extends BrowseForOpen{
	
	public function BrowseForOpenMultiple(fileTypes:Array,title:String,openHandler:Function){
		super(fileTypes,title,openHandler);
	}
	
	override protected function doOpen():void{
		file.browseForOpenMultiple(title,fileTypes);
	}
}

class BrowseForSave extends BrowseForDirectory{
	public function BrowseForSave(title:String,openHandler:Function){
		super(title,openHandler);
	}
	
	override protected function doOpen():void{
		file.browseForSave(title);
	}
}