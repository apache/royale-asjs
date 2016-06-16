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
		
		public var bytesLoaded:int;
		public var bytesTotal:int;
		public static const PROGRESS:String = "progress";
	}
}
