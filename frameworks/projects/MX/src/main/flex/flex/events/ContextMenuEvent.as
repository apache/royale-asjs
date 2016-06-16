package flex.events
{	
	public class ContextMenuEvent extends Event
	{
		public function ContextMenuEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public static const MENU_SELECT:String = "menuSelect";
	}
}
