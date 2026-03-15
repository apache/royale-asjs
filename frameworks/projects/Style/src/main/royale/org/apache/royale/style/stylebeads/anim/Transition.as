package org.apache.royale.style.stylebeads.anim
{
	import org.apache.royale.style.stylebeads.CompositeStyle;
	import org.apache.royale.style.util.ThemeManager;

	public class Transition extends CompositeStyle
	{
		public function Transition(property:String= "default")
		{
			super();
			_property = property;
			propStyle = new TransitionProperty(property);
			timingStyle = new TransitionTimingFunction("default");
			durationStyle = new TransitionDuration("default");
			styles = [
				propStyle,
				timingStyle,
				durationStyle
			];
		}
		private var _property:String = "default";

		public function get property():String
		{
			return _property;
		}
		private var propStyle:TransitionProperty;
		public function set property(value:String):void
		{
			propStyle.value = _property = value;
		}

		private var _timingFunction:String = "default";
		private var timingStyle:TransitionTimingFunction;
		public function get timingFunction():String
		{
			return _timingFunction;
		}

		public function set timingFunction(value:String):void
		{
			timingStyle.value = _timingFunction = value;
		}

		private var _duration:String = "default";
		public function get duration():String
		{
			return _duration;
		}
		private var durationStyle:TransitionDuration;
		public function set duration(value:String):void
		{
			durationStyle.value = _duration = value;
		}

	}
}