package org.apache.flex.graphics
{
	COMPILE::SWF
	{
		import flash.display.Graphics;
	}

	public interface IPathCommand
	{
		function toString():String;
		COMPILE::SWF
		function execute(g:Graphics):void;
		COMPILE::JS
		function execute(ctx:Object):void;
	}
}