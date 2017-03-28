package map {
	import flash.geom.Point;
	import word.player.Player;
	import type.userInput.MouseManager;

	import word.controller.MoveController;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author yangyiqiang
	 */
	public class MapContainer extends Sprite {
		public function MapContainer() {
		}

		private var _map : Bitmap;
		private var _mouse : MouseManager;
		private var _moveController : MoveController;
		private var _myPlayer:Player;

		public function init() : void {
			_mouse = General.moseManager;
			_map = MapAssets.getMap();
			addChild(_map);
			_mouse.bind(this);
			_mouse.mouseUp.add(mouseClick);
			_targeX = this.x;
			_targeY = this.y;
		}

		public function set moveController(value : MoveController) : void {
			_moveController = value;
		}
		
		public function set player(value:Player):void
		{
			_myPlayer=value;
		}
		
		public function get player():Player
		{
			return _myPlayer;
		}

		private var _targeX : Number;
		private var _targeY : Number;
		private var _speed : int = 4;

		public function moveTo(x : Number, y : Number) : void {
			_targeX = this.stage.stageWidth / 2 - x;
			_targeY = this.stage.stageHeight / 2 - y;
			_moveController.run( _mouse.stageX, _mouse.stageY,this.stage.stageWidth / 2, this.stage.stageHeight / 2);
			this.addEventListener(Event.ENTER_FRAME, onFrame);
		}

		private function mouseClick() : void {
			moveTo(_mouse.x, _mouse.y);
		}

		private function onFrame(event : Event) : void {
			var n : int;
			if (Math.abs(this.x - _targeX) <= _speed) {
				this.x = _targeX;
			} else {
				n = this.x > _targeX ? -1 : 1;
				this.x += _speed * n;
			}

			if (Math.abs(this.y - _targeY) <= _speed) {
				this.y = _targeY;
			} else {
				n = this.y > _targeY ? -1 : 1;
				this.y += _speed * n;
			}
			var point:Point=globalToLocal(new Point(this.stage.stageWidth / 2 ,this.stage.stageHeight / 2 ));
			_myPlayer.body.x=point.x;
			_myPlayer.body.y=point.y;

			if (this.x == _targeX && this.y == _targeY) {
				this.removeEventListener(Event.ENTER_FRAME, onFrame);
				_moveController.runAction.stand();
			}
		}
	}
}
