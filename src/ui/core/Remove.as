package ui.core {
	import flash.display.DisplayObject;
	
	public function Remove(obj:DisplayObject) : void
	{
		if(obj&&obj.parent)obj.parent.removeChild(obj);
	}
}
