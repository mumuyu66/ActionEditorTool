package utils {
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	/**
	 * @author yangyiqiang
	 */
	public class PNGDecoder {
		public static function decoder(bytes : ByteArray) : BitmapData {
			// Write PNG signature
			bytes.readUnsignedInt();
			bytes.readUnsignedInt();

			// len1
			var len : uint=bytes.readUnsignedInt();
			// type1
			bytes.readUnsignedInt();

			var w : int = bytes.readInt();
			var h : int = bytes.readInt();
			bytes.readUnsignedInt();
			bytes.readByte();
			// check
			bytes.readUnsignedInt();
			
			var bitmapData : BitmapData = new BitmapData(w, h);

			// len2
			len  = bytes.readUnsignedInt();
			// type2
			var type:uint=bytes.readUnsignedInt();
			trace("0x"+type.toString(16));
			var bys : ByteArray = new ByteArray();
			bytes.readBytes(bys, 0, len);
			bys.uncompress();
			
			bys.position=0;

			for (var i : int = 0; i < h; i++) {
				// no filter
				bys.readByte();
				var p : uint;
				var j : int;
				for (j = 0; j < w; j++) {
					p=bys.readUnsignedInt();
					p=(p>>>8)+((p&0xff)<<24);
					bitmapData.setPixel(j, i, p);
				}
			}
			
			if(bytes.bytesAvailable)
			{
				bytes.readUnsignedInt();
				bytes.readUnsignedInt();
				trace("bytes.readUTF()===>"+bytes.readUTF());
			}
			
			return bitmapData;
		}
	}
}
