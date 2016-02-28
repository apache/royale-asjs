package flex.events
{	
	public class IOErrorEvent extends Event
	{
		public function IOErrorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public static const IO_ERROR:String = "ioError";
	}
}