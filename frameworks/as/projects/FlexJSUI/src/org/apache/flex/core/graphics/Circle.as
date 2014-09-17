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
	import flash.geom.Point;
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
			beginFill(new Rectangle(x,y,radius*2, radius*2),new Point(x-radius,y-radius));
			graphics.drawCircle(x,y,radius);
			endFill();
		}
		
	}
}