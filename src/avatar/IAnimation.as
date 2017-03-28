package avatar {
	import avatar.action.ActionVO;
	/**
	 * @author yangyiqiang
	 */
	public interface IAnimation {
		function refresh(index:int,action : ActionVO):void;
		function defaultAction(action:ActionVO):String;
		function clear():void;
		function get data():AvatarData;
	}
}
