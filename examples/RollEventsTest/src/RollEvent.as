package
{
	import org.apache.flex.events.Event;
	
	public class RollEvent extends Event
	{
		public function RollEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super("rollEvent", bubbles, cancelable);
			rollEventType = type;
		}
		
		public var rollEventType:String;
	}
}