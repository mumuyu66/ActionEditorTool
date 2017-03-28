package utils {
	import flash.filters.GlowFilter;
	/**
	 * @author yangyiqiang
	 */
	public class Filters {
		public static function getEdgeFilters(edgeColor : uint = 0x000000, edgeAlpha : Number = 1, strength : Number = 3,blurX:Number=2,blurY:Number=2) : Array
		{
			return [new GlowFilter(edgeColor, edgeAlpha, blurX, blurY, strength, 1, false, false)];
		}
	}
}
