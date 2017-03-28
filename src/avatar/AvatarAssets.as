package avatar {
	import flash.utils.ByteArray;

	/**
	 * @author yangyiqiang
	 */
	public class AvatarAssets {
		[Embed(source="/../assets/avatar/1.swf" , mimeType="application/octet-stream")]
		private static var avatar1 : Class;
		[Embed(source="/../assets/avatar/2.swf" , mimeType="application/octet-stream")]
		private static var avatar2 : Class;
		[Embed(source="/../assets/avatar/3.swf" , mimeType="application/octet-stream")]
		private static var avatar3 : Class;
		[Embed(source="/../assets/avatar/4.swf" , mimeType="application/octet-stream")]
		private static var avatar4 : Class;
		[Embed(source="/../assets/avatar/5.swf" , mimeType="application/octet-stream")]
		private static var avatar5 : Class;
		[Embed(source="/../assets/avatar/6.swf" , mimeType="application/octet-stream")]
		private static var avatar6 : Class;
		[Embed(source="/../assets/avatar/rider_1.swf" , mimeType="application/octet-stream")]
		private static var avatar7 : Class;
		[Embed(source="/../assets/avatar/rider_2.swf" , mimeType="application/octet-stream")]
		private static var avatar8 : Class;
		[Embed(source="/../assets/avatar/rider_3.swf" , mimeType="application/octet-stream")]
		private static var avatar9 : Class;
		[Embed(source="/../assets/avatar/rider_4.swf" , mimeType="application/octet-stream")]
		private static var avatar10 : Class;
		[Embed(source="/../assets/avatar/rider_5.swf" , mimeType="application/octet-stream")]
		private static var avatar11 : Class;
		[Embed(source="/../assets/avatar/rider_6.swf" , mimeType="application/octet-stream")]
		private static var avatar12 : Class;
		
		[Embed(source="/../assets/avatar/fashion_id1_sex1.swf" , mimeType="application/octet-stream")]
		private static var avatar13 : Class;
		[Embed(source="/../assets/avatar/fashion_id1_sex2.swf" , mimeType="application/octet-stream")]
		private static var avatar14 : Class;
		[Embed(source="/../assets/avatar/fashion_rider_id1_sex1.swf" , mimeType="application/octet-stream")]
		private static var avatar15 : Class;
		[Embed(source="/../assets/avatar/fashion_rider_id1_sex2.swf" , mimeType="application/octet-stream")]
		private static var avatar16 : Class;
		
		[Embed(source="/../assets/avatar/fashion_id2_sex1.swf" , mimeType="application/octet-stream")]
		private static var avatar17 : Class;
		[Embed(source="/../assets/avatar/fashion_id2_sex2.swf" , mimeType="application/octet-stream")]
		private static var avatar18 : Class;
		[Embed(source="/../assets/avatar/fashion_rider_id2_sex1.swf" , mimeType="application/octet-stream")]
		private static var avatar19 : Class;
		[Embed(source="/../assets/avatar/fashion_rider_id2_sex2.swf" , mimeType="application/octet-stream")]
		private static var avatar20 : Class;
		
		[Embed(source="/../assets/avatar/fashion_id3_sex1.swf" , mimeType="application/octet-stream")]
		private static var avatar21 : Class;
		[Embed(source="/../assets/avatar/fashion_id3_sex2.swf" , mimeType="application/octet-stream")]
		private static var avatar22 : Class;
		[Embed(source="/../assets/avatar/fashion_rider_id3_sex1.swf" , mimeType="application/octet-stream")]
		private static var avatar23 : Class;
		[Embed(source="/../assets/avatar/fashion_rider_id3_sex2.swf" , mimeType="application/octet-stream")]
		private static var avatar24 : Class;

		public static function getBytes(key : String) : ByteArray {
			switch(key) {
				case "1":
					return new avatar1();
				case "2":
					return new avatar2();
				case "3":
					return new avatar3();
				case "4":
					return new avatar4();
				case "5":
					return new avatar5();
				case "6":
					return new avatar6();
				case "7":
					return new avatar7();
				case "8":
					return new avatar8();
				case "9":
					return new avatar9();
				case "A":
					return new avatar10();
				case "B":
					return new avatar11();
				case "C":
					return new avatar12();
				case "D":
					return new avatar13();
				case "E":
					return new avatar14();
				case "F":
					return new avatar15();
				case "G":
					return new avatar16();
					
				case "H":
					return new avatar17();
				case "I":
					return new avatar18();
				case "J":
					return new avatar19();
				case "K":
					return new avatar20();
				
				case "L":
					return new avatar21();
				case "M":
					return new avatar22();
				case "N":
					return new avatar23();
				case "O":
					return new avatar24();
					
				default :
					return new avatar4();
			}
		}
	}
}
