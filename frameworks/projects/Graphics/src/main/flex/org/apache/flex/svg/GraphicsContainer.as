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

package org.apache.flex.svg
{
    COMPILE::SWF
    {
        import flash.display.GraphicsPath;
        import flash.display.Shape;
        import flash.display.Sprite;
        import flash.geom.Point;
        import flash.geom.Rectangle;
        import flash.text.TextFieldType;

        import org.apache.flex.core.CSSTextField;
        import org.apache.flex.graphics.utils.PathHelper;
    }
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }

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
		 *  Removes all of the drawn elements of the container.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0.3
		 */
		public function removeAllElements():void
		{
            COMPILE::SWF
            {
                graphics.clear();
            }
            COMPILE::JS
            {
                var svg:HTMLElement = element;
                while (svg.lastChild) {
                    svg.removeChild(svg.lastChild);
                }
            }
		}

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
         *  @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
		public function drawRect(x:Number, y:Number, width:Number, height:Number):void
		{
            COMPILE::SWF
            {
                applyStroke();
                beginFill(new Rectangle(x, y, width, height), new Point(x,y) );
                graphics.drawRect(x, y, width, height);
                endFill();
            }
            COMPILE::JS
            {
                var style:String = getStyleStr();
                var rect:WrappedHTMLElement = document.createElementNS('http://www.w3.org/2000/svg', 'rect') as WrappedHTMLElement;
                rect.flexjs_wrapper = this;
                rect.style.left = x;
                rect.style.top = y;
                rect.setAttribute('style', style);
                rect.setAttribute('x', String(x) + 'px');
                rect.setAttribute('y', String(y) + 'px');
                rect.setAttribute('width', String(width) + 'px');
                rect.setAttribute('height', String(height) + 'px');
                element.appendChild(rect);
            }
		}

        COMPILE::SWF
		public function createRect(x:Number, y:Number, width:Number, height:Number):void
		{
			var color:uint = (fill as SolidColor).color;
			var alpha:uint = (fill as SolidColor).alpha;

			var shape:Sprite = new Sprite();
			shape.graphics.beginFill(color,alpha);
			shape.graphics.drawRect(0, 0, width, height);
			shape.graphics.endFill();
			shape.x = x;
			shape.y = y;
			addChild(shape);
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
         *  @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
		public function drawEllipse(x:Number, y:Number, width:Number, height:Number):void
		{
            COMPILE::SWF
            {
                applyStroke();
                beginFill(new Rectangle(x,y,width,height), new Point(x,y));
                graphics.drawEllipse(x,y,width,height);
                endFill();
            }
            COMPILE::JS
            {
                var style:String = getStyleStr();
                var ellipse:WrappedHTMLElement = document.createElementNS('http://www.w3.org/2000/svg', 'ellipse') as WrappedHTMLElement;
                ellipse.flexjs_wrapper = this;
                ellipse.style.left = x;
                ellipse.style.top = y;
                ellipse.setAttribute('style', style);
                ellipse.setAttribute('cx', String(x + width / 2));
                ellipse.setAttribute('cy', String(y + height / 2));
                ellipse.setAttribute('rx', String(width / 2));
                ellipse.setAttribute('ry', String(height / 2));
                element.appendChild(ellipse);
            }
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
         *  @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
		public function drawCircle(x:Number, y:Number, radius:Number):void
		{
            COMPILE::SWF
            {
                applyStroke();
                beginFill(new Rectangle(x,y,radius*2, radius*2),new Point(x-radius,y-radius));
                graphics.drawCircle(x,y,radius);
                endFill();
            }
            COMPILE::JS
            {
                var style:String = getStyleStr();
                var circle:WrappedHTMLElement = document.createElementNS('http://www.w3.org/2000/svg', 'ellipse') as WrappedHTMLElement;
                circle.flexjs_wrapper = this;
                circle.style.left = x;
                circle.style.top = y;
                circle.setAttribute('style', style);
                circle.setAttribute('cx', String(x));
                circle.setAttribute('cy', String(y));
                circle.setAttribute('rx', String(radius));
                circle.setAttribute('ry', String(radius));
                element.appendChild(circle);

            }
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
		public function drawPath(data:String):void
		{
            COMPILE::SWF
            {
                applyStroke();
                var bounds:Rectangle = PathHelper.getBounds(data);
                beginFill(bounds,bounds.topLeft);
                var graphicsPath:GraphicsPath = PathHelper.getSegments(data);
                graphics.drawPath(graphicsPath.commands, graphicsPath.data);
                endFill();
            }
            COMPILE::JS
            {
                var style:String = getStyleStr();
                var path:WrappedHTMLElement = document.createElementNS('http://www.w3.org/2000/svg', 'path') as WrappedHTMLElement;
                path.flexjs_wrapper = this;
                path.style.left = 0;
                path.style.top = 0;
                path.setAttribute('style', style);
                path.setAttribute('d', data);
                element.appendChild(path);
            }
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
         *  @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         *  @flexjsignorecoercion Text
         *  @flexjsignorecoercion Node
		 */
		public function drawText(value:String, x:Number, y:Number):Object
		{
            COMPILE::SWF
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
                textField.y = y + textField.textHeight/4;

                return textField;

            }
            COMPILE::JS
            {
                var style:String = getStyleStr();
                var text:WrappedHTMLElement = document.createElementNS('http://www.w3.org/2000/svg', 'text') as WrappedHTMLElement;
                text.flexjs_wrapper = this;
                text.style.left = x;
                text.style.top = y;
                text.setAttribute('style', style);
                text.setAttribute('x', String(x) + 'px');
                text.setAttribute('y', String(y + 15) + 'px');
                var textNode:Text = document.createTextNode(value) as Text;
                text.appendChild(textNode as Node);
                element.appendChild(text);
                return text;
            }
		}
	}
}
