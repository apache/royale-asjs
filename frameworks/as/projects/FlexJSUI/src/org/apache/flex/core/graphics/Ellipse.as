package org.apache.flex.core.graphics
{

	public class Ellipse extends GraphicShape
	{
		
		private var _x:Number;
		private var _y:Number;
		private var _width:Number;
		private var _height:Number;
		
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
				graphics.lineStyle(stroke.weight,stroke.color,stroke.alpha);
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