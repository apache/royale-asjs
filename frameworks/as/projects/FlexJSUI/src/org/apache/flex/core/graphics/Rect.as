package org.apache.flex.core.graphics
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.geom.Rectangle;

	public class Rect extends GraphicShape
	{
		
		/**
		 *  Draw the rectangle.
		 *  @param x The x position of the top-left corner of the rectangle.
		 *  @param y The y position of the top-left corner.
		 *  @param width The width of the rectangle.
		 *  @param height The height of the rectangle.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function drawRect(x:Number, y:Number, width:Number, height:Number):void
		{
			graphics.clear();
			applyStroke();
			beginFill(new Rectangle(x, y, width, height));
			graphics.drawRect(x, y, width, height);
			endFill();
		}
		
	}
}