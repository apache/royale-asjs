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
	
	import org.apache.flex.core.graphics.utils.PathHelper;

	public class Path extends GraphicShape
	{
		
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
		public function drawPath(x:Number,y:Number,data:String):void
		{
			
			graphics.clear();
			applyStroke();
			var bounds:Rectangle = PathHelper.getBounds(data);
			beginFill(bounds,new Point(bounds.left + x, bounds.top + y) );
			var graphicsPath:GraphicsPath = PathHelper.getSegments(data,x,y);
			graphics.drawPath(graphicsPath.commands, graphicsPath.data);
			endFill();
			
		}
	}
}
