package vf2js.display
{

import flash.display.DisplayObject;

public interface IDisplayObjectContainer
{
	function addChild(child:DisplayObject):	DisplayObject;
	function addChildAt(child:DisplayObject, index:int):DisplayObject;
}

}