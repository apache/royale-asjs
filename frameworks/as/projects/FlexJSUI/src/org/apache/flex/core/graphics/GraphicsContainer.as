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
	import flash.display.CapsStyle;
	import flash.display.GraphicsPath;
	import flash.display.JointStyle;
	
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
			if(stroke)
			{
				graphics.lineStyle(stroke.weight,stroke.color,stroke.alpha,false,"normal",CapsStyle.SQUARE,JointStyle.MITER);
			}
			if(fill)
			{
				graphics.beginFill(fill.color,fill.alpha);
			}
			graphics.drawRect(x, y, width, height);
			graphics.endFill();
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
			if(stroke)
			{
				graphics.lineStyle(stroke.weight,stroke.color,stroke.alpha,false,"normal",CapsStyle.SQUARE,JointStyle.MITER);
			}
			if(fill)
			{
				graphics.beginFill(fill.color,fill.alpha);
			}
			graphics.drawCircle(x,y,radius);
			graphics.endFill();
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
			if(stroke)
			{
				graphics.lineStyle(stroke.weight,stroke.color,stroke.alpha,false,"normal",CapsStyle.SQUARE,JointStyle.MITER);
			}
			if(fill)
			{
				graphics.beginFill(fill.color,fill.alpha);
			}
			var graphicsPath:GraphicsPath = PathHelper.getSegments(data);
			graphics.drawPath(graphicsPath.commands, graphicsPath.data);
			graphics.endFill();
		}
		
		public function drawLine():void
		{
			
		}
		
		public function drawPolygon():void
		{
			
		} 
	}
}