package {
	import pool.AssetsPool;

	import type.userInput.KeyboardManager;
	import type.userInput.MouseManager;

	import flash.display.Sprite;

	/**
	 * @author yangyiqiang
	 */
	public class General {
		public static const moseManager : MouseManager = new MouseManager();
		public static const keyboardManager : KeyboardManager = new KeyboardManager();
		public static var root : Sprite;
		public static const assetsPool : AssetsPool = new AssetsPool();
		public static const actionName : Array = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "20"];
		public static const wingName : Array =["1", "2", "3", "4", "5", "6", "fashion_id1_sex1","fashion_id1_sex2", "fashion_id2_sex1","fashion_id2_sex2","fashion_id3_sex1","fashion_id3_sex2","rider_1", "rider_2", "rider_3", "rider_4", "rider_5", "rider_6", "fashion_rider_id1_sex1", "fashion_rider_id1_sex2","fashion_rider_id2_sex1","fashion_rider_id2_sex2","fashion_rider_id3_sex1","fashion_rider_id3_sex2"];
		public static const mountName : Array = ["rider_1", "rider_2", "rider_3", "rider_4", "rider_5","rider_6","fashion_rider_id1_sex1", "fashion_rider_id1_sex2","fashion_rider_id2_sex1","fashion_rider_id2_sex2","fashion_rider_id3_sex1","fashion_rider_id3_sex2"];
	}
}
