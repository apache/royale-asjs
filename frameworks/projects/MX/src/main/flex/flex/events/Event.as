package flex.events
{
	import org.apache.flex.events.Event;
	
	public class Event extends org.apache.flex.events.Event
	{
		public function Event(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public static const ADDED:String = "added";
		public static const CHANGE:String = "change";
		public static const ENTER_FRAME:String = "enterFrame";
		public static const REMOVED:String = "removed";
		public static const REMOVED_FROM_STAGE:String = "removedFromStage";
	}
}