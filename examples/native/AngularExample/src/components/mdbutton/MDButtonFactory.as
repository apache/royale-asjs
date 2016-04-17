package components.mdbutton {
	public class MDButtonFactory {
		private static var _instance : MDButtonFactory;
		protected var elementName : String = "md-button";
		protected var baseComponent : Object = MDButton;
		protected var componentClass : Object;
		protected var alreadyRegistered: Boolean = false;

		public function MDButtonFactory() {
			if (_instance) {
				throw new Error("MDButtonFactory is a singleton. Use getInstance instead.");
			}
			_instance = this;
		}

		public static function	getInstance() : MDButtonFactory {
			if (!_instance) {
				new MDButtonFactory();
			}
			return _instance;
		}
		
		protected function registerComponent() : void {
			if(!alreadyRegistered)
			{
				var classProto:Object = Object["create"](components.mdbutton.MDButton['prototype']);
				componentClass = document["registerElement"](elementName, {'prototype':classProto});
				alreadyRegistered = true;
			}
		}
		
		public function getButtonClass():Object
		{
			registerComponent();
			return componentClass;	
		}
	}
}
