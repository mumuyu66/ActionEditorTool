package avatar.action {
	import flash.utils.ByteArray;
	/**
	 * @author yangyiqiang
	 */
	public class ActionVO
	{
		public var name : String;
		public var startFrame : int;
		public var endFrame : int;

		private var _temp:uint=0;		
		public function parse(bytes:ByteArray):void
		{
			name=bytes.readUTF();
			_temp=bytes.readUnsignedInt();
			startFrame=_temp&0xffff;
			endFrame=_temp>>>16;
		}
		
		public function serialize(out:ByteArray):void
		{
			out.writeUTF(name);
			_temp=startFrame+(endFrame<<16);
			out.writeUnsignedInt(_temp);
		}
		
	}
}
