package models
{
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;

	public class Alert extends EventDispatcher
	{
		public function Alert()
		{
			super();
			message = "";
		}
		
		private var _symbol:String;
		private var _value:Number;
		private var _greaterThan:Boolean;
		private var _message:String;
		private var _stock:Stock;
		
		[Binding("symbolChanged")]
		public function get symbol():String
		{
			return _symbol;
		}
		public function set symbol(value:String):void
		{
			_symbol = value;
			dispatchEvent(new Event("symbolChanged"));
		}
		
		[Binding("messageChanged")]
		public function get message():String
		{
			return _message;
		}
		public function set message(value:String):void
		{
			_message = value;
			dispatchEvent(new Event("messageChanged"));
		}
		
		[Binding("valueChanged")]
		public function get value():Number
		{
			return _value;
		}
		public function set value(newValue:Number):void
		{
			_value = newValue;
			dispatchEvent(new Event("valueChanged"));
		}
		
		[Binding("greaterThanChanged")]
		public function get greaterThan():Boolean
		{
			return _greaterThan;
		}
		public function set greaterThan(value:Boolean):void
		{
			_greaterThan = value;
			dispatchEvent(new Event("greaterThanChanged"));
		}
		
		[Binding("stockChanged")]
		public function get stock():Stock
		{
			return _stock;
		}
		public function set stock(value:Stock):void
		{
			_stock = value;
			dispatchEvent(new Event("stockChanged"));
		}
		
	}
}