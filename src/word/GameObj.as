package word {
	import word.controller.AbstractController;

	import flash.display.Sprite;

	/**
	 * @author yangyiqiang
	 */
	public class GameObj {
		private var _targe : Sprite;
		private var _controllers : Vector.<AbstractController>;

		public function GameObj() {
			_controllers=new Vector.<AbstractController>();
		}
	}
} 
