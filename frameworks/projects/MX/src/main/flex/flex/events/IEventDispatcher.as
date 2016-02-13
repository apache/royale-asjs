package flex.events
{
	import org.apache.flex.events.IEventDispatcher;
	
	public interface IEventDispatcher extends org.apache.flex.events.IEventDispatcher
	{
		function get bindingEventDispatcher():org.apache.flex.events.IEventDispatcher;
		function get effectEventDispatcher():org.apache.flex.events.IEventDispatcher;
	}
}