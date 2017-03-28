package word.controller {
	import avatar.Avatar;
	import avatar.component.Run;
	/**
	 * @author yangyiqiang
	 */
	public class MoveController {
		public var runAction:Run;
		public var avatar:Avatar;
		
		public function init():void
		{
			runAction=new Run(avatar);
		}
		
		public function run(goX : int, goY : int, targetX : int, targetY : int, direction : int = 8) : void
		{
			runAction.run(goX, goY, targetX, targetY,direction);
		}
	}
}
