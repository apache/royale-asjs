package org.apache.flex.core.graphics
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;

	public class Ellipse extends GraphicShape
	{
		
		/**
		 *  Draw the ellipse.
		 *  @param x The x position of the top-left corner of the bounding box of the ellipse.
		 *  @param y The y position of the top-left corner of the bounding box of the ellipse.
		 *  @param width The width of the ellipse.
		 *  @param height The height of the ellipse.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function drawEllipse(x:Number, y:Number, width:Number, height:Number):void
		{
			graphics.clear();
			if(stroke)
			{
				graphics.lineStyle(stroke.weight,stroke.color,stroke.alpha,false,"normal",CapsStyle.SQUARE,JointStyle.MITER);
			}
			if(fill)
			{
				graphics.beginFill(fill.color,fill.alpha);
			}
			graphics.drawEllipse(x,y,width,height);
			graphics.endFill();
		}
		
	}
}