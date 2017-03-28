package map {
	import type.parse.AvatarParse;
	import flash.display.BitmapData;
	import avatar.AvatarData;
	import flash.display.Bitmap;

	/**
	 * @author yangyiqiang
	 */
	public class MapAssets {
		[Embed(source="/../assets/map.jpg")]
		private static var img : Class;
		
		[Embed(source="/../assets/a1375960788320.png")]
		private static var img2 : Class;
		
		[Embed(source="/../assets/a1375960788320.xml" , mimeType="application/octet-stream")]
		private static var xml : Class;
		
		private static var _map : Bitmap;
		public static function getMap() : Bitmap {
			if (!_map) _map = new img();
			return _map;
		}
		
		public static function get avatarBD():String
		{
			var xml:XML= XML(new xml());
			var bitmapData:BitmapData=(new img2()).bitmapData;
			 return AvatarParse.parseBD2(Math.random()+"a", xml, bitmapData).key;
		}
	}
}
