package vf2js.display
{

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.LoaderInfo;
import flash.display.Stage;

public interface IDisplayObject
{
	function get loaderInfo():LoaderInfo;
	
	function get parent():DisplayObjectContainer;
	function set parent(value:DisplayObjectContainer):void;
	
	function get root():DisplayObject;
	
	function get stage():Stage;
	
	function get scaleX():Number;
	function set scaleX(value:Number):void;
	
	function get scaleY():Number;
	function set scaleY(value:Number):void;
}

}
