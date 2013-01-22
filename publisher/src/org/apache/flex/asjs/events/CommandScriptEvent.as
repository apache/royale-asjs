package org.apache.flex.asjs.events
{
import flash.events.Event;

public class CommandScriptEvent extends Event
{
	public static const DONE:String = "done";
	
	public function CommandScriptEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
	{
		super(type, bubbles, cancelable);
	}
}
}