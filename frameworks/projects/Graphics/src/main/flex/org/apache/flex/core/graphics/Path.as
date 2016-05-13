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
    COMPILE::AS3
    {
        import flash.display.GraphicsPath;
        import flash.geom.Point;
        import flash.geom.Rectangle;
    }
	COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }

	import org.apache.flex.core.graphics.utils.PathHelper;

	public class Path extends GraphicShape
	{

		private var _data:String;

		public function get data():String
		{
			return _data;
		}

		public function set data(value:String):void
		{
			_data = value;
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
		 *  @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
		public function drawPath(xp:Number,yp:Number,data:String):void
		{
			COMPILE::AS3
            {
                graphics.clear();
                applyStroke();
                var bounds:Rectangle = PathHelper.getBounds(data);
                this.width = bounds.width;
                this.height = bounds.height;
                beginFill(bounds,new Point(bounds.left + xp, bounds.top + yp) );
                var graphicsPath:GraphicsPath = PathHelper.getSegments(data,xp,yp);
                graphics.drawPath(graphicsPath.commands, graphicsPath.data);
                endFill();
            }
            COMPILE::JS
            {
                if (data == null || data.length === 0) return;
                var style:String = getStyleStr();
                var path:WrappedHTMLElement = document.createElementNS('http://www.w3.org/2000/svg', 'path') as WrappedHTMLElement;
                path.flexjs_wrapper = this;
                path.setAttribute('style', style);
                path.setAttribute('d', data);
                element.appendChild(path);

                resize(x, y, path['getBBox']());

            }
		}

		override protected function draw():void
		{
			drawPath(0, 0, data);
		}
	}
}
