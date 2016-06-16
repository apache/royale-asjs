package vf2js.display
{

import flash.events.Event;

public interface ILoaderInfo
{
	function get bytesLoaded():uint;

	function get bytesTotal():uint;

	function get height():int;
	
	function get url():String;
	
	function get width():int;

	function dispatchEvent(event:Event):void;
}

}
