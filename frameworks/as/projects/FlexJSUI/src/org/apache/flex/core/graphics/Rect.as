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
	import flash.display.JointStyle;
	import flash.geom.Point;
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
			beginFill(new Rectangle(x, y, width, height), new Point(x,y));
			graphics.drawRect(x, y, width, height);
			endFill();
		}
		
	}
}