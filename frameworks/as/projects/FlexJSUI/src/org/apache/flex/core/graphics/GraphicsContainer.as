/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
package org.apache.flex.core.graphics
{
	import flash.display.GraphicsPath;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFieldType;
	
	import org.apache.flex.core.CSSTextField;
	import org.apache.flex.core.graphics.utils.PathHelper;
	
	/**
	 * GraphicsContainer is a surface on which you can 
	 * draw various graphic elements such as Rect, Circle,
	 * Ellipse, Path etc.
	 * Use this class if you want to draw multiple graphic
	 * shapes on a single container. 
	 * 
	 */
	public class GraphicsContainer extends GraphicShape
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
		 *  @productversion FlexJS 0.0.3
		 */
		public function drawRect(x:Number, y:Number, width:Number, height:Number):void
		{
			applyStroke();
			beginFill(new Rectangle(x, y, width, height), new Point(x,y) );
			graphics.drawRect(x, y, width, height);
			endFill();
		}
		
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
		 *  @productversion FlexJS 0.0.3
		 */
		public function drawEllipse(x:Number, y:Number, width:Number, height:Number):void
		{
			applyStroke();
			beginFill(new Rectangle(x,y,width,height), new Point(x,y));
			graphics.drawEllipse(x,y,width,height);
			endFill();
		}
		
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
			applyStroke();
			beginFill(new Rectangle(x,y,radius*2, radius*2),new Point(x-radius,y-radius));
			graphics.drawCircle(x,y,radius);
			endFill();
		}
		
		/**
		 *  Draw the path.
		 *  @param data A string containing a compact represention of the path segments.
		 *  The value is a space-delimited string describing each path segment. Each
		 *  segment entry has a single character which denotes the segment type and
		 *  two or more segment parameters.
		 * 
		 *  If the segment command is upper-case, the parameters are absolute values.
		 *  If the segment command is lower-case, the parameters are relative values.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function drawPath(data:String):void
		{
			applyStroke();
			var bounds:Rectangle = PathHelper.getBounds(data);
			beginFill(bounds,bounds.topLeft);
			var graphicsPath:GraphicsPath = PathHelper.getSegments(data);
			graphics.drawPath(graphicsPath.commands, graphicsPath.data);
			endFill();
		}
		
		public function drawLine():void
		{
			
		}
		
		public function drawPolygon():void
		{
			
		} 
		
		/**
		 *  Draw a string of characters.
		 *  @param value The string to draw.
		 *  @param x The x location of the center of the circle
		 *  @param y The y location of the center of the circle.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function drawText(value:String, x:Number, y:Number):void
		{
			var textField:CSSTextField = new CSSTextField();
			addChild(textField);
			
			textField.selectable = false;
			textField.type = TextFieldType.DYNAMIC;
			textField.mouseEnabled = false;
			textField.autoSize = "left";
			textField.text = value;
			
			var lineColor:SolidColorStroke = stroke as SolidColorStroke;
			if (lineColor) {
				textField.textColor = lineColor.color;
				textField.alpha = lineColor.alpha;
			}
			
			textField.x = x;
			textField.y = y;
		}
	}
}