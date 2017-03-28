package ui.core {
	import org.osflash.signals.Signal;

	/**
	 * @author yangyiqiang
	 */
	public interface IComponent {
		function get added() : Signal;

		function get removed() : Signal;

		function set align(value : GAlign) : void

		function get align() : GAlign ;
	}
}
