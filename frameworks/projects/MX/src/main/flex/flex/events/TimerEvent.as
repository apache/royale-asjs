package flex.events
{	
	public class TimerEvent extends Event
	{
		public function TimerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public static const TIMER:String = "timer";
	}
}