/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.royale.svg
{
    import org.apache.royale.graphics.ICompoundGraphic;
    import org.apache.royale.graphics.IFill;
    import org.apache.royale.graphics.IStroke;
    import org.apache.royale.graphics.PathBuilder;
    import org.apache.royale.graphics.SolidColor;

    COMPILE::SWF
    {
        import flash.display.GraphicsPath;
        import flash.display.Shape;
        import flash.display.Sprite;
        import flash.geom.Point;
        import flash.geom.Rectangle;
        import flash.text.TextFieldType;

        import org.apache.royale.core.CSSTextField;
        import org.apache.royale.graphics.utils.PathHelper;
    }
    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.html.util.createSVG;
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
         *  @productversion Royale 0.0
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
         *  @productversion Royale 0.0
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
         *  @productversion Royale 0.0.3
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
         *  @productversion Royale 0.7.0
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
         *  @productversion Royale 0.0.3
         *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
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
                drawRoundRect(x, y, width, height, NaN);
            }
        }

        /**
         *  Draws a rounded rectangle.
         *  Note: The radius values are different than the Flash API of the same name. Flash uses diameter instead of radius.
         *  @param x The x position of the top-left corner of the rectangle.
         *  @param y The y position of the top-left corner.
         *  @param width The width of the rectangle.
         *  @param height The height of the rectangle.
         *  @param radiusX The horizontal radius of the rounded corners (in pixels).
         *  @param radiusY The vertical radius of the rounded corners (in pixels). Optional; if no value is specified, the default value matches that provided for the <code>radiusX</code> parameter.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0.3
         *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        public function drawRoundRect(x:Number, y:Number, width:Number, height:Number, radiusX:Number, radiusY:Number = NaN):void
        {
            COMPILE::SWF
            {
                applyStroke();
                beginFill(new Rectangle(x,y,width,height), new Point(x,y));
                radiusX *=2;
                radiusY = isNaN(radiusY) ? radiusY : radiusY*2;
                graphics.drawRoundRect(x,y,width,height,radiusX,radiusY);
                endFill();
            }
            COMPILE::JS
            {
                if(isNaN(radiusY))
                    radiusY = radiusX;

                var style:String = getStyleStr();
                var rect:WrappedHTMLElement = createSVG('rect') as WrappedHTMLElement;
                rect.royale_wrapper = this;
                rect.style.left = x + "px";
                rect.style.top = y + "px";
                rect.setAttribute('style', style);
                rect.setAttribute('x', x);
                rect.setAttribute('y', y);
                rect.setAttribute('width', width);
                rect.setAttribute('height', height);
                if(!isNaN(radiusX))
                {
                    rect.setAttribute('rx', radiusX);
                    rect.setAttribute('ry', radiusY);
                }
                addElementToSurface(rect);
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
         *  @productversion Royale 0.0.3
         *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
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
                var ellipse:WrappedHTMLElement = createSVG('ellipse') as WrappedHTMLElement;
                ellipse.royale_wrapper = this;
                ellipse.style.left = x + "px";
                ellipse.style.top = y + "px";
                ellipse.setAttribute('style', style);
                ellipse.setAttribute('cx', x + width / 2);
                ellipse.setAttribute('cy', y + height / 2);
                ellipse.setAttribute('rx', width / 2);
                ellipse.setAttribute('ry', height / 2);
                addElementToSurface(ellipse);
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
         *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
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
                var circle:WrappedHTMLElement = createSVG('ellipse') as WrappedHTMLElement;
                circle.royale_wrapper = this;
                circle.style.left = x + "px";
                circle.style.top = y + "px";
                circle.setAttribute('style', style);
                circle.setAttribute('cx', x);
                circle.setAttribute('cy', y);
                circle.setAttribute('rx', radius);
                circle.setAttribute('ry', radius);
                addElementToSurface(circle);

            }
        }

        /**
         *  Draw the path.
         *  @param data A PathBuilder object containing a vector of drawing commands.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        public function drawPathCommands(data:PathBuilder):void
        {
            drawStringPath(data.getPathString());
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
         *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        public function drawStringPath(data:String):void
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
                var path:WrappedHTMLElement = createSVG('path') as WrappedHTMLElement;
                path.royale_wrapper = this;
                path.style.left = "0px";
                path.style.top = "0px";
                path.setAttribute('style', style);
                path.setAttribute('d', data);
                addElementToSurface(path);
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
         *  @productversion Royale 1.0.0
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
                drawStringPath(builder.getPathString());
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
     *  @productversion Royale 1.0.0
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
            drawStringPath(builder.getPathString());
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
         *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         *  @royaleignorecoercion Node
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
                var text:WrappedHTMLElement = createSVG('text') as WrappedHTMLElement;
                text.royale_wrapper = this;
                text.style.left = x + "px";
                text.style.top = y + "px";
                text.setAttribute('style', style);
                text.setAttribute('x', x);
                text.setAttribute('y', y + 15);
                var textNode:Node = document.createTextNode(value) as Node;
                text.appendChild(textNode);
                addElementToSurface(text);
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

		/*
               *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		*/
		COMPILE::JS
		protected function addElementToSurface(e:WrappedHTMLElement):void
		{
			element.appendChild(e);
		}

    }
}
