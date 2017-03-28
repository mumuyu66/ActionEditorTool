package utils {
	import avatar.BDUnit;

	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BDUtil {
		
		public static function getOffBD(source : BitmapData) : BDUnit {
			if (!source) return null;
			var rect : Rectangle = new Rectangle(0, 0, source.width, source.height);
			var vc : Vector.<uint>=source.getVector(rect);
			var max : int = vc.length;
			var minOffX : int = rect.width;
			var minOffY : int = rect.height;
			var maxOffX : int = 0;
			var maxOffY : int = 0;
			for (var i : int = 0;i < max;i++) {
				if (vc[i] != 0) {
					var n : int = int(i % rect.width);
					maxOffX = n > maxOffX ? n : maxOffX;
					minOffX = n < minOffX ? n : minOffX;
					n = int(i / rect.width);
					maxOffY = n > maxOffY ? n : maxOffY;
					minOffY = n < minOffY ? n : minOffY;
				}
			}
			source.lock();
			var newRect : Rectangle = new Rectangle(minOffX, minOffY, maxOffX - minOffX, maxOffY - minOffY);
			var copyBD : BitmapData = new BitmapData(maxOffX - minOffX, maxOffY - minOffY, true, 0);
			copyBD.copyPixels(source, newRect, new Point(0, 0));
			source.unlock();
			var unit : BDUnit = new BDUnit();
			unit.offset = new Point(minOffX, minOffY);
			unit.bds = copyBD;
			return unit;
		}

		
		public static  function stopMC(mc : MovieClip, frame : int = -1) : void {
			for (var i : int = 0; i < mc.numChildren; i++) {
				var c : MovieClip = mc.getChildAt(i) as MovieClip;
				if (c) stopMC(c,frame);
			}
			if (frame < 0)
				mc.stop();
			else
				mc.gotoAndStop(frame);
		}

		public static  function playMC(mc : MovieClip, frame : int = -1) : void {
			for (var i : int = 0; i < mc.numChildren; i++) {
				var c : MovieClip = mc.getChildAt(i) as MovieClip;
				if (c) playMC(c,frame);
			}
			if (frame < 0)
				mc.play();
			else
				mc.gotoAndPlay(frame);
		}
	}
}

