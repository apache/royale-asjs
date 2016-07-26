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
    import org.apache.flex.graphics.ICompoundGraphic;
    import org.apache.flex.graphics.IFill;
    import org.apache.flex.graphics.IStroke;
    import org.apache.flex.graphics.PathBuilder;
    import org.apache.flex.graphics.SolidColor;

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
     * CompoundGraphic is a surface on which you can
     * draw various graphic elements such as Rect, Circle,
     * Ellipse, Path etc.
     * Use this class if you want to draw multiple graphic
     * shapes on a single container.
     *
     */
    public class CompoundGraphic extends GraphicShape implements ICompoundGraphic
    {
        private var _textFill:IFill;

        public function get textFill():IFill
        {
            return _textFill;
        }
        /**
         *  The color of the text.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion FlexJS 0.0
         */
        public function set textFill(value:IFill):void
        {
            _textFill = value;
        }

        private var _textStroke:IStroke;

        public function get textStroke():IStroke
        {
            return _textStroke;
        }
        /**
         *  The stroke color of the text.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion FlexJS 0.0
         */
        public function set textStroke(value:IStroke):void
        {
            _textStroke = value;
        }

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
            clear();
        }
        
        /**
         *  Clears all of the drawn path data.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.7.0
         */
        public function clear():void
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
         * Draws a rounded rectangle using the size of a radius to draw the rounded corners. 
         * You must set the line style, fill, or both 
         * on the Graphics object before 
         * you call the <code>drawRoundRectComplex()</code> method 
         * by calling the <code>linestyle()</code>, 
         * <code>lineGradientStyle()</code>, <code>beginFill()</code>, 
         * <code>beginGradientFill()</code>, or 
         * <code>beginBitmapFill()</code> method.
         * 
         * @param graphics The Graphics object that draws the rounded rectangle.
         *
         * @param x The horizontal position relative to the 
         * registration point of the parent display object, in pixels.
         * 
         * @param y The vertical position relative to the 
         * registration point of the parent display object, in pixels.
         * 
         * @param width The width of the round rectangle, in pixels.
         * 
         * @param height The height of the round rectangle, in pixels.
         * 
         * @param topLeftRadius The radius of the upper-left corner, in pixels.
         * 
         * @param topRightRadius The radius of the upper-right corner, in pixels.
         * 
         * @param bottomLeftRadius The radius of the bottom-left corner, in pixels.
         * 
         * @param bottomRightRadius The radius of the bottom-right corner, in pixels.
         *
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function drawRoundRectComplex(x:Number, y:Number, 
                                                    width:Number, height:Number, 
                                                    topLeftRadius:Number, topRightRadius:Number, 
                                                    bottomLeftRadius:Number, bottomRightRadius:Number):void
        {
            COMPILE::SWF
            {
                applyStroke();
                beginFill(new Rectangle(x,y,width,height), new Point(x,y));
                graphics.drawRoundRectComplex(x,y,width,height,topLeftRadius,topRightRadius,bottomLeftRadius,bottomRightRadius);
                endFill();
            }
            COMPILE::JS
            {
                var builder:PathBuilder = new PathBuilder();
                builder.drawRoundRectComplex(x, y, width, height, topLeftRadius, topRightRadius, bottomLeftRadius, bottomRightRadius);
                drawPath(builder.getPathString());
            }


    }
    
    /**
     * Draws a rounded rectangle using the size of individual x and y radii to 
     * draw the rounded corners. 
     * You must set the line style, fill, or both 
     * on the Graphics object before 
     * you call the <code>drawRoundRectComplex2()</code> method 
     * by calling the <code>linestyle()</code>, 
     * <code>lineGradientStyle()</code>, <code>beginFill()</code>, 
     * <code>beginGradientFill()</code>, or 
     * <code>beginBitmapFill()</code> method.
     * 
     * @param graphics The Graphics object that draws the rounded rectangle.
     *
     * @param x The horizontal position relative to the 
     * registration point of the parent display object, in pixels.
     * 
     * @param y The vertical position relative to the 
     * registration point of the parent display object, in pixels.
     * 
     * @param width The width of the round rectangle, in pixels.
     * 
     * @param height The height of the round rectangle, in pixels.
     * 
     * @param radiusX The default radiusX to use, if corner-specific values are not specified.
     * This value must be specified.
     * 
     * @param radiusY The default radiusY to use, if corner-specific values are not specified. 
     * If 0, the value of radiusX is used.
     * 
     * @param topLeftRadiusX The x radius of the upper-left corner, in pixels. If NaN, 
     * the value of radiusX is used.
     * 
     * @param topLeftRadiusY The y radius of the upper-left corner, in pixels. If NaN,
     * the value of topLeftRadiusX is used.
     * 
     * @param topRightRadiusX The x radius of the upper-right corner, in pixels. If NaN,
     * the value of radiusX is used.
     * 
     * @param topRightRadiusY The y radius of the upper-right corner, in pixels. If NaN,
     * the value of topRightRadiusX is used.
     * 
     * @param bottomLeftRadiusX The x radius of the bottom-left corner, in pixels. If NaN,
     * the value of radiusX is used.
     * 
     * @param bottomLeftRadiusY The y radius of the bottom-left corner, in pixels. If NaN,
     * the value of bottomLeftRadiusX is used.
     * 
     * @param bottomRightRadiusX The x radius of the bottom-right corner, in pixels. If NaN,
     * the value of radiusX is used.
     * 
     * @param bottomRightRadiusY The y radius of the bottom-right corner, in pixels. If NaN,
     * the value of bottomRightRadiusX is used.
     * 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function drawRoundRectComplex2(x:Number, y:Number, 
                                                width:Number, height:Number, 
                                                radiusX:Number, radiusY:Number,
                                                topLeftRadiusX:Number, topLeftRadiusY:Number,
                                                topRightRadiusX:Number, topRightRadiusY:Number,
                                                bottomLeftRadiusX:Number, bottomLeftRadiusY:Number,
                                                bottomRightRadiusX:Number, bottomRightRadiusY:Number):void
    {
        var builder:PathBuilder = new PathBuilder();
        builder.drawRoundRectComplex2(x, y, width, height, radiusX, radiusY,topLeftRadiusX, topLeftRadiusY,topRightRadiusX, topRightRadiusY,bottomLeftRadiusX, bottomLeftRadiusY,bottomRightRadiusX, bottomRightRadiusY);

        COMPILE::SWF
        {
            applyStroke();
            beginFill(new Rectangle(x,y,width,height), new Point(x,y));
            builder.draw(graphics);
            endFill();
        }
        COMPILE::JS
        {
            drawPath(builder.getPathString());
        }
    }
    
        /*
        What about these?
        beginBitmapFill
        beginFill
        beginGradientFill
        beginShaderFill
        drawGraphicsData
        drawRoundRect
        drawTriangles
        */

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

                var color:SolidColor = textFill as SolidColor;
                if (color) {
                    textField.textColor = color.color;
                    textField.alpha = color.alpha;
                }

                textField.x = x;
                textField.y = y + textField.textHeight/4;

                return textField;

            }
            COMPILE::JS
            {
                var style:String = getTxtStyleStr();
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

                /**
         * @return {string} The style attribute.
         */
        COMPILE::JS
        public function getTxtStyleStr():String
        {
            var fillStr:String;
            if (textFill)
            {
                fillStr = textFill.addFillAttrib(this);
            }
            else
            {
                fillStr = 'fill:none';
            }

            var strokeStr:String;
            if (textStroke)
            {
                strokeStr = textStroke.addStrokeAttrib(this);
            }
            else
            {
                strokeStr = 'stroke:none';
            }
            return fillStr + ';' + strokeStr;


        }

    }
}
