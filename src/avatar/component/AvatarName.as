package avatar.component {
	import avatar.Avatar;

	import utils.Filters;

	import word.controller.AbstractController;

	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * @author yangyiqiang
	 */
	public class AvatarName {
		
		private var _avatar:Avatar;
		public function AvatarName(avatar:Avatar)
		{
			_avatar=avatar;	
			_avatar.changed.add(onChange);
		}
		
		private function onChange() : void
		{
			if (!_text) return;
			_text.x = _avatar.getTopX();
			_text.y = _avatar.getTopY();
			_avatar.addChild(_text);
		}
		private var _container:AbstractController;
		private function createText() : void {
			var textFormat : TextFormat = new TextFormat();
			textFormat.align = TextFormatAlign.CENTER;
			textFormat.font = "SimSun,宋体,Microsoft YaHei,微软雅黑";
			textFormat.color = 0x0099FF;
			textFormat.size = 12;
			textFormat.leading = 3;
			_text = new TextField();
			_text.width = 120;
			_text.height = 20;
			_text.defaultTextFormat = textFormat;
			_text.filters = Filters.getEdgeFilters(0x111111, 0.8, 17);
			_text.mouseEnabled = false;
			_text.cacheAsBitmap = true;
			_text.x=_avatar.getTopX();
			_text.y=_avatar.getTopY();
			_avatar.addChild(_text);
		}
		
		public function setController(container:AbstractController):void
		{
			_container=container;
		}

		private var _text : TextField;
		public function setName(str : String) : void {
			if (!_text) createText();
			_text.htmlText = str;
		}
	}
}
