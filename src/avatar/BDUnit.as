package avatar {
	import config.WingItem;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	public class BDUnit {
		private var _offset : Point;
		private var _bds : BitmapData;

		public function BDUnit(o : Point = null, b : BitmapData = null) {
			offset = o;
			bds = b;
		}

		public function output(bd:BitmapData,indexX:int,indexY:int,maxHight:int) :Object {
			var _xml:String="<item";
			if (indexX+ _bds.width > 2880) {
				indexX= 0;
				indexY += maxHight;
				maxHight = _bds.height;
			} else
				maxHight = _bds.height > maxHight ? _bds.height : maxHight;
			_xml += " x=" + "\'" + indexX + "\'";
			_xml += " y=" + "\'" + indexY+ "\'";
			_xml += " w=" + "\'" + _bds.width + "\'";
			_xml += " h=" + "\'" + _bds.height + "\'";
			_xml += " offsetX=" + "\'" + _offset.x + "\'";
			_xml += " offsetY=" + "\'" + _offset.y+ "\'";
			_xml+=" />";
			_bds.lock();
			bd.lock();
			bd.copyPixels(_bds, new Rectangle(0, 0, _bds.width, _bds.height), new Point(indexX,indexY));
			indexX += _bds.width;
			_bds.unlock();
			bd.unlock();
			return {x:indexX,y:indexY,hight:maxHight,xml:_xml};
		}

		private var _temp2 : uint;

		public function parse(bytes : ByteArray) : void {
			_offset = new Point(bytes.readInt(), bytes.readInt());
			_temp2 = bytes.readUnsignedInt();
			var rect : Rectangle = new Rectangle(0, 0, _temp2 & 0xffff, _temp2 >>> 16);
			_bds = new BitmapData(rect.width, rect.height);
			_bds.setPixels(rect, bytes);
		}

		public function serialize(out : ByteArray) : void {
			if (!_bds) return;
			_temp2 = _bds.width + (_bds.height << 16);
			out.writeInt(_offset.x);
			out.writeInt(_offset.y);
			out.writeUnsignedInt(_temp2);
			out.writeBytes(_bds.getPixels(new Rectangle(0, 0, _bds.width, _bds.height)));
		}

		public function merge(unit : BDUnit, itemConfig : WingItem) : BDUnit {
			var bdunit : BDUnit = new BDUnit();
			if (!unit) return this;
			var unitOffset : Point = new Point(unit.offset.x + itemConfig.offsetX, unit.offset.y + itemConfig.offsetY);
			bdunit.offset = new Point(Math.min(unitOffset.x, offset.x), Math.min(unitOffset.y, offset.y));
			var bitmapData : BitmapData = new BitmapData(Math.max(unitOffset.x + unit.bds.width - bdunit.offset.x, bds.width + offset.x - bdunit.offset.x), Math.max(unitOffset.y + unit.bds.height - bdunit.offset.y, offset.y + bds.height - bdunit.offset.y), true, 0);
			if (itemConfig.layer) {
				bitmapData.copyPixels(bds, bds.rect, offset.subtract(bdunit.offset), null, null, true);
				bitmapData.copyPixels(unit.bds, unit.bds.rect, unitOffset.subtract(bdunit.offset), null, null, true);
			} else {
				bitmapData.copyPixels(unit.bds, unit.bds.rect, unitOffset.subtract(bdunit.offset), null, null, true);
				bitmapData.copyPixels(bds, bds.rect, offset.subtract(bdunit.offset), null, null, true);
			}
			bdunit.bds = bitmapData;
			return bdunit;
		}

		public function get offset() : Point {
			return _offset;
		}

		public function set offset(p : Point) : void {
			_offset = p;
		}

		public function set bds(bit : BitmapData) : void {
			_bds = bit;
		}

		public function get bds() : BitmapData {
			return _bds;
		}

		public function dispose() : void {
			if (bds != null) bds.dispose();
			_bds = null;
		}

		public function get size() : int {
			if (!_bds)
				return 0;
			return _bds.width * _bds.height * 4;
		}
	}
}