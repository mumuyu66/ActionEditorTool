package avatar {
	import org.osflash.signals.Signal;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author yangyiqiang
	 */
	public class AvatarView extends Sprite
	{
		private var _body : Bitmap;
		public var add : Signal = new Signal(DisplayObject);
		public var rm : Signal = new Signal(DisplayObject);

		public function AvatarView()
		{
			create();
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			return super.removeChild(child);
		}

		protected function create() : void
		{
			_body = new Bitmap();
			_body.name="body";
			_body.smoothing=true;
			addChild(_body);
		}

		public function setData(unit : BDUnit) : void
		{
			if (!unit) return;
			_body.x = unit.offset.x;
			_body.y = unit.offset.y;
			_body.bitmapData = unit.bds;
			_body.smoothing=true;
		}
	}
}
