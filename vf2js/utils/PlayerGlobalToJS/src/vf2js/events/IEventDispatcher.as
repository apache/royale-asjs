package vf2js.events
{

import flash.events.Event;

public interface IEventDispatcher
{
	function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void;
	function dispatchEvent(event:Event):void;
	function hasEventListener(type:String):void;
	function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void;
	function toString():String;
}

}