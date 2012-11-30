package models
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	public class MyModel extends EventDispatcher
	{
		public function MyModel()
		{
		}
		
		private var _labelText:String;
		
		public function get labelText():String
		{
			return _labelText;
		}
		
		public function set labelText(value:String):void
		{
			if (value != _labelText)
			{
				_labelText = value;
				dispatchEvent(new Event("labelTextChanged"));
			}
		}
	}
}