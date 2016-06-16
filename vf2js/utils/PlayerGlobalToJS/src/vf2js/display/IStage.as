package vf2js.display
{

import flash.events.Event;

public interface IStage
{
	function get align():String;
	function set align(value:String):void;
	
	function get quality():String;
	function set quality(value:String):void;
	
	function get scaleMode():String;
	function set scaleMode(value:String):void;
	
	function get stageHeight():int;
	
	function get stageWidth():int;
	
	function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void;
	function dispatchEvent(event:Event):Boolean;
	function hasEventListener(type:String):Boolean;
}

}
