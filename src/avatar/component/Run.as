package avatar.component
{
	import avatar.Avatar;
	/**
	 * @author yangyiqiang
	 */
	public class Run
	{
		private var _avatar : Avatar;

		public function Run(value : Avatar)
		{
			_avatar = value;
			_avatar.changed.add(onChanged);
		}

		private function onChanged() : void
		{
		}

		private var _isRun : Boolean;

		protected function to8Direction(angle : Number, isRun : Boolean = false) : void
		{
			_isRun = isRun;
			if (angle < 0)
			{
				angle += 360;
			}
			if (angle >= 337.5 || angle < 22.5)
			{
				_direction = 3;
				_avatar.flipH = false;
			}
			else if (angle >= 22.5 && angle < 67.5)
			{
				_direction = 2;
				_avatar.flipH = false;
			}
			else if (angle >= 67.5 && angle < 112.5)
			{
				_direction = 1;
				_avatar.flipH = false;
			}
			else if (angle >= 112.5 && angle < 157.5)
			{
				_direction = 2;
				_avatar.flipH = true;
			}
			else if (angle >= 157.5 && angle < 202.5)
			{
				_direction = 3;
				_avatar.flipH = true;
			}
			else if (angle >= 202.5 && angle < 247.5)
			{
				_direction = 4;
				_avatar.flipH = true;
			}
			else if (angle >= 247.5 && angle < 292.5)
			{
				_direction = 5;
				_avatar.flipH = false;
			}
			else if (angle >= 292.5 && angle < 337.5)
			{
				_direction = 4;
				_avatar.flipH = false;
			}
			trace("_direction===>" + _direction);
			_avatar.setAction(String(isRun ? (_direction + 5) : _direction),0);
		}

		protected function to4Direction(angle : Number, isRun : Boolean = false) : void
		{
			_isRun = isRun;
			if (angle < 0)
			{
				angle += 360;
			}
			if (angle >= 360 || angle < 90)
			{
				_direction = 1;
				_avatar.flipH = false;
			}
			else if (angle >= 90 && angle < 180)
			{
				_direction = 1;
				_avatar.flipH = true;
			}
			else if (angle >= 180 && angle < 270)
			{
				_direction = 2;
				_avatar.flipH = false;
			}
			else if (angle >= 270 && angle < 360)
			{
				_direction = 2;
				_avatar.flipH = true;
			}
			_avatar.setAction(String(isRun ? (_direction + 2) : _direction),0);
		}

		/** 站立 */
		public function stand() : void
		{
			_avatar.setAction(String(_direction));
			_isRun = false;
		}

		/** 打坐 */
		public function sitdown() : void
		{
			_avatar.setAction("20");
			_isRun = false;
		}

		protected var _direction : int = 1;

		public function run(goX : int, goY : int, targetX : int, targetY : int, direction : int = 8) : void
		{
			var x_distance : Number = goX - targetX; 
			var y_distance : Number = goY - targetY;
			if (x_distance == 0 && y_distance == 0)
			{
				_avatar.setAction(String(_direction + 5));
				return;
			}
			var angle : Number = Math.atan2(y_distance, x_distance) * 180 / Math.PI;
			if (direction == 8)
				to8Direction(angle, true);
			else to4Direction(angle, true);
		}

		public function standDirection(targetX : int, targetY : int, x : int = 0, y : int = 0, direction : int = 8) : void
		{
			if (x == 0 && y == 0)
			{
				x = _avatar.x;
				y = _avatar.y;
			}
			var x_distance : Number = targetX - x;
			var y_distance : Number = targetY - y;

			var angle : Number = Math.atan2(y_distance, x_distance) * 180 / Math.PI;
			if (direction == 8)
				to8Direction(angle);
			else to4Direction(angle);
		}
	}
}
