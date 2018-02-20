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

package org.apache.royale.graphics
{
    COMPILE::SWF
	{
		import flash.display.Graphics;
	}

    public class PathBuilder
    {

        /**
         *  Constructor.
         *
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
		 *  @productversion Royale 0.6
         */
        public function PathBuilder(closedPath:Boolean=false)
        {
            commands = new Vector.<IPathCommand>();
			this.closedPath = closedPath;
        }

		/**
		 *  Clears the path data
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.8
		 */
        public function clear():void
        {
            commands.length = 0;
        }

		/**
		 *  Gets a string representation of the path which can be used in SVG.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.6
		 */
        public function getPathString():String
        {
			var pathString:String = commands.join(" ");
            if (closedPath)
			{
				pathString += " Z";
			}
			return pathString;
        }

		/**
		 *  Draws the paths to the specified context.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.6
		 */
        COMPILE::SWF
        public function draw(g:Graphics):void
        {
            //TODO we can probably make this more efficient by doing all the drawing commands at once.
            var i:int = -1;
            var len:int = commands.length;
            while(++i<len)
            {
                commands[i].execute(g);
            }

        }
        COMPILE::JS
        public function draw(ctx:Object):void
        {
            var i:int = -1;
            var len:int = commands.length;
            while(++i<len)
            {
                commands[i].execute(ctx);
            }
            
        }

        private var commands:Vector.<IPathCommand>;

		/**
		 *  Specifies whether the path should auto-close.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.6
         * 
         *  @royalesuppresspublicvarwarning
		 */
        public var closedPath:Boolean;
        
		/**
		 *  Adds a lineTo command
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.6
		 */
        public function lineTo(x:Number, y:Number):void
        {
            commands.push(new LineTo(x,y));
        }
        
		/**
		 *  Adds a moveTo command
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.6
		 */
        public function moveTo(x:Number, y:Number):void
        {
            commands.push(new MoveTo(x,y));
        }
        
		/**
		 *  Adds a quadraticCurveTo command
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.6
		 */
        public function quadraticCurveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void
        {
            commands.push(new QuadraticCurve(controlX,controlY,anchorX,anchorY));
        }
        
		/**
		 *  Adds a cubicCurveTo command
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.6
		 */
        public function cubicCurveTo(controlX1:Number, controlY1:Number, controlX2:Number, controlY2:Number, anchorX:Number, anchorY:Number):void
        {
            commands.push(new CubicCurve(controlX1, controlY1, controlX2, controlY2, anchorX, anchorY));
        }

		/**
		 *  Adds a drawRect command
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.6
		 */
        public function drawRect(x:Number,y:Number,width:Number,height:Number):void
        {
            commands.push(new MoveTo(x,y));
            commands.push(new LineTo(x+width,y));
            commands.push(new LineTo(x+width,y+height));
            commands.push(new LineTo(x,y+height));
            commands.push(new LineTo(x,y));
        }

		/**
		 *  Adds a drawRoundRectComplex command
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.6
		 */
        public function drawRoundRectComplex(x:Number, y:Number, 
                                                    width:Number, height:Number, 
                                                    topLeftRadius:Number, topRightRadius:Number, 
                                                    bottomLeftRadius:Number, bottomRightRadius:Number):void
        {
            var b:Array = [];
            var xw:Number = x + width;
            var yh:Number = y + height;
            
            // Make sure none of the radius values are greater than w/h.
            // These are all inlined to avoid function calling overhead
            var minSize:Number = width < height ? width * 2 : height * 2;
            topLeftRadius = topLeftRadius < minSize ? topLeftRadius : minSize;
            topRightRadius = topRightRadius < minSize ? topRightRadius : minSize;
            bottomLeftRadius = bottomLeftRadius < minSize ? bottomLeftRadius : minSize;
            bottomRightRadius = bottomRightRadius < minSize ? bottomRightRadius : minSize;
            
            // Math.sin and Math,tan values for optimal performance.
            // Math.rad = Math.PI / 180 = 0.0174532925199433
            // r * Math.sin(45 * Math.rad) =  (r * 0.707106781186547);
            // r * Math.tan(22.5 * Math.rad) = (r * 0.414213562373095);
            //
            // We can save further cycles by precalculating
            // 1.0 - 0.707106781186547 = 0.292893218813453 and
            // 1.0 - 0.414213562373095 = 0.585786437626905
            
            // bottom-right corner
            var a:Number = bottomRightRadius * 0.292893218813453;       // radius - anchor pt;
            var s:Number = bottomRightRadius * 0.585786437626905;   // radius - control pt;
            commands.push(new MoveTo(xw, yh - bottomRightRadius));
            commands.push(new QuadraticCurve(xw, yh - s, xw - a, yh - a));
            commands.push(new QuadraticCurve(xw - s, yh, xw - bottomRightRadius, yh));
            
            // bottom-left corner
            a = bottomLeftRadius * 0.292893218813453;
            s = bottomLeftRadius * 0.585786437626905;
            commands.push(new LineTo(x + bottomLeftRadius, yh));
            commands.push(new QuadraticCurve(x + s, yh, x + a, yh - a));
            commands.push(new QuadraticCurve(x, yh - s, x, yh - bottomLeftRadius));
            
            // top-left corner
            a = topLeftRadius * 0.292893218813453;
            s = topLeftRadius * 0.585786437626905;
            commands.push(new LineTo(x, y + topLeftRadius));
            commands.push(new QuadraticCurve(x, y + s, x + a, y + a));
            commands.push(new QuadraticCurve(x + s, y, x + topLeftRadius, y));
            
            // top-right corner
            a = topRightRadius * 0.292893218813453;
            s = topRightRadius * 0.585786437626905;
            commands.push(new LineTo(xw - topRightRadius, y));
            commands.push(new QuadraticCurve(xw - s, y, xw - a, y + a));
            commands.push(new QuadraticCurve(xw, y + s, xw, y + topRightRadius));
            commands.push(new LineTo(xw, yh - bottomRightRadius));
        }
        /**
         * Draws a rounded rectangle using the size of individual x and y radii to 
         * draw the rounded corners. 
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
            var xw:Number = x + width;
            var yh:Number = y + height;
            var maxXRadius:Number = width / 2;
            var maxYRadius:Number = height / 2;
            
            // Rules for determining radius for each corner:
            //  - If explicit nnnRadiusX value is set, use it. Otherwise use radiusX.
            //  - If explicit nnnRadiusY value is set, use it. Otherwise use corresponding nnnRadiusX.
            if (radiusY == 0)
                radiusY = radiusX;
            if (isNaN(topLeftRadiusX))
                topLeftRadiusX = radiusX;
            if (isNaN(topLeftRadiusY))
                topLeftRadiusY = topLeftRadiusX;
            if (isNaN(topRightRadiusX))
                topRightRadiusX = radiusX;
            if (isNaN(topRightRadiusY))
                topRightRadiusY = topRightRadiusX;
            if (isNaN(bottomLeftRadiusX))
                bottomLeftRadiusX = radiusX;
            if (isNaN(bottomLeftRadiusY))
                bottomLeftRadiusY = bottomLeftRadiusX;
            if (isNaN(bottomRightRadiusX))
                bottomRightRadiusX = radiusX;
            if (isNaN(bottomRightRadiusY))
                bottomRightRadiusY = bottomRightRadiusX;
            
            // Pin radius values to half of the width/height
            if (topLeftRadiusX > maxXRadius)
                topLeftRadiusX = maxXRadius;
            if (topLeftRadiusY > maxYRadius)
                topLeftRadiusY = maxYRadius;
            if (topRightRadiusX > maxXRadius)
                topRightRadiusX = maxXRadius;
            if (topRightRadiusY > maxYRadius)
                topRightRadiusY = maxYRadius;
            if (bottomLeftRadiusX > maxXRadius)
                bottomLeftRadiusX = maxXRadius;
            if (bottomLeftRadiusY > maxYRadius)
                bottomLeftRadiusY = maxYRadius;
            if (bottomRightRadiusX > maxXRadius)
                bottomRightRadiusX = maxXRadius;
            if (bottomRightRadiusY > maxYRadius)
                bottomRightRadiusY = maxYRadius;
            
            // Math.sin and Math,tan values for optimal performance.
            // Math.rad = Math.PI / 180 = 0.0174532925199433
            // r * Math.sin(45 * Math.rad) =  (r * 0.707106781186547);
            // r * Math.tan(22.5 * Math.rad) = (r * 0.414213562373095);
            //
            // We can save further cycles by precalculating
            // 1.0 - 0.707106781186547 = 0.292893218813453 and
            // 1.0 - 0.414213562373095 = 0.585786437626905
            
            // bottom-right corner
            var aX:Number = bottomRightRadiusX * 0.292893218813453;     // radius - anchor pt;
            var aY:Number = bottomRightRadiusY * 0.292893218813453;     // radius - anchor pt;
            var sX:Number = bottomRightRadiusX * 0.585786437626905;     // radius - control pt;
            var sY:Number = bottomRightRadiusY * 0.585786437626905;     // radius - control pt;
            commands.push(new MoveTo(xw, yh - bottomRightRadiusY));
            commands.push(new QuadraticCurve(xw, yh - sY, xw - aX, yh - aY));
            commands.push(new QuadraticCurve(xw - sX, yh, xw - bottomRightRadiusX, yh));
            
            // bottom-left corner
            aX = bottomLeftRadiusX * 0.292893218813453;
            aY = bottomLeftRadiusY * 0.292893218813453;
            sX = bottomLeftRadiusX * 0.585786437626905;
            sY = bottomLeftRadiusY * 0.585786437626905;
            commands.push(new LineTo(x + bottomLeftRadiusX, yh));
            commands.push(new QuadraticCurve(x + sX, yh, x + aX, yh - aY));
            commands.push(new QuadraticCurve(x, yh - sY, x, yh - bottomLeftRadiusY));
            
            // top-left corner
            aX = topLeftRadiusX * 0.292893218813453;
            aY = topLeftRadiusY * 0.292893218813453;
            sX = topLeftRadiusX * 0.585786437626905;
            sY = topLeftRadiusY * 0.585786437626905;
            commands.push(new LineTo(x, y + topLeftRadiusY));
            commands.push(new QuadraticCurve(x, y + sY, x + aX, y + aY));
            commands.push(new QuadraticCurve(x + sX, y, x + topLeftRadiusX, y));
            
            // top-right corner
            aX = topRightRadiusX * 0.292893218813453;
            aY = topRightRadiusY * 0.292893218813453;
            sX = topRightRadiusX * 0.585786437626905;
            sY = topRightRadiusY * 0.585786437626905;
            commands.push(new LineTo(xw - topRightRadiusX, y));
            commands.push(new QuadraticCurve(xw - sX, y, xw - aX, y + aY));
            commands.push(new QuadraticCurve(xw, y + sY, xw, y + topRightRadiusY));
            commands.push(new LineTo(xw, yh - bottomRightRadiusY));
        }
    }

}
