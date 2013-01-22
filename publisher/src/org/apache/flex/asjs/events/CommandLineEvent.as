package org.apache.flex.asjs.events
{
import flash.events.Event;

public class CommandLineEvent extends Event
{
	public static const EXIT:String = "exit";
	
	public function CommandLineEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
	{
		super(type, bubbles, cancelable);
	}
}
}