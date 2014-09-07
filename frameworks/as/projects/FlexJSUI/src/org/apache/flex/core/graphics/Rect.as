package org.apache.flex.core.graphics
{

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
			if(stroke)
			{
				graphics.lineStyle(stroke.weight,stroke.color,stroke.alpha);
			}
			if(fill)
			{
				graphics.beginFill(fill.color,fill.alpha);
			}
			graphics.drawRect(x, y, width, height);
			graphics.endFill();
		}
		
	}
}