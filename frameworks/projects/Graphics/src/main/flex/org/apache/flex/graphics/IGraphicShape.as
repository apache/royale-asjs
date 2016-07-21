package org.apache.flex.graphics
{
	import org.apache.flex.core.IUIBase;

	COMPILE::SWF
	{
		import flash.display.Graphics;
	}

	public interface IGraphicShape extends IUIBase
	{
		COMPILE::SWF
		function get graphics():Graphics;
		
	}
}