package vf2js.events
{

public interface IEvent
{
	function get bubbles():Boolean;
	
	function get cancelable():Boolean;
	
	function get type():String;
	
	function toString():String;
}

}