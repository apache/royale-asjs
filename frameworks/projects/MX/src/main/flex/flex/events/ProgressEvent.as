package flex.events
{	
	public class ProgressEvent extends Event
	{
		public function ProgressEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,
									bytesLoaded:int = 0, bytesTotal:int = 0)
		{
			super(type, bubbles, cancelable);
			this.bytesLoaded = bytesLoaded;
			this.bytesTotal = bytesTotal;
		}
		
		public var bytesLoaded;
		public var bytesTotal;
		public static const PROGRESS:String = "progress";
	}
}