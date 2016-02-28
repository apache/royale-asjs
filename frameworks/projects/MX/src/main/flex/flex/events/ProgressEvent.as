package flex.events
{	
	public class ProgressEvent extends Event
	{
		public function ProgressEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public static const PROGRESS:String = "progress";
	}
}