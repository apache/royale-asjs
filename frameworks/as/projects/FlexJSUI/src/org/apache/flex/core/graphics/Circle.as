package org.apache.flex.core.graphics
{
	import flash.geom.Rectangle;

	public class Circle extends GraphicShape
	{
		
		/**
		 *  Draw the circle.
		 *  @param x The x location of the center of the circle
		 *  @param y The y location of the center of the circle.
		 *  @param radius The radius of the circle.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function drawCircle(x:Number, y:Number, radius:Number):void
		{
			graphics.clear();
			applyStroke();
			beginFill(new Rectangle(x, y, radius*2, radius*2));
			graphics.drawCircle(x,y,radius);
			endFill();
		}
		
	}
}