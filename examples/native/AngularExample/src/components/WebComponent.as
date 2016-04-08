package components {
	import components.IWebComponent;

	/**
	 * @author omuppirala
	 */
	public class WebComponent extends HTMLElement implements IWebComponent {

		protected var sr : ShadowRoot;

		public function createdCallback() : void {
			sr = this['createShadowRoot']();
			setupComponent();
		}

		public function setupComponent() : void {
			//override in subclass
		}
	}
}
