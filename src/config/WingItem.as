package config {
	/**
	 * @author yangyiqiang
	 */
	public class WingItem {
		public var action : String;
		public var key :String;
		public var offsetX : int;
		public var offsetY : int;
		// 0 为最底层
		public var layer : int = 0;

		public function toString() : String {
			return "<item id= '" + key + "' action='" + action + "' offsetX='" + offsetX + "' offsetY='" + offsetY + "' layer='" + layer + "'/>";
		}
	}
}
