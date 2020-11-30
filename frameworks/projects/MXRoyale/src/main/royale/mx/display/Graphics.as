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

package mx.display
{
	//import org.apache.royale.svg.CompoundGraphic;
	import mx.core.UIComponent;
	import mx.geom.Matrix;
	import mx.graphics.GradientEntry;
	COMPILE::JS
	{
		import org.apache.royale.display.BitmapData;
	}

	public class Graphics// extends org.apache.royale.svg.CompoundGraphic
	{
		private var displayObject:UIComponent;
        
        private static var _matrix_rotate90:Matrix;
        
        private static const FILLTYPE_NONE:String = "none";
        private static const FILLTYPE_SOLID:String = "solid";
        private static const FILLTYPE_LINEARGRADIENT:String = "linearGradient";
        
        /**
         * @royaleignorecoercion mx.geom.Matrix
         */
        public static function get MATRIX_ROTATE90():Matrix
        {
            if (!_matrix_rotate90)
            {
                _matrix_rotate90 = new Matrix().rotate(90) as Matrix;
            }
            return _matrix_rotate90;
        }
        COMPILE::JS
        private var element:HTMLElement;

        /**
         * @royaleignorecoercion HTMLElement
         */
		public function Graphics(displayObject:UIComponent)
		{
			super();
			this.displayObject = displayObject;
            COMPILE::JS
            {
                element = displayObject.element as HTMLElement;
            }
		}

        COMPILE::JS
        private var svg:HTMLElement;
        
        private var fillInProgress:Boolean;
        
        /**
         * @royaleignorecoercion HTMLElement
         */
        public function clear():void
        {
            fillInProgress = false;
            fillType = FILLTYPE_NONE;
            COMPILE::SWF
            {
                displayObject.flashgraphics.clear();
            }
            COMPILE::JS
            {
                if (svg)
                    element.removeChild(svg);
                svg = document.createElementNS("http://www.w3.org/2000/svg", "svg") as HTMLElement;
                svg.setAttribute("width", displayObject.width.toString() + "px");
                svg.setAttribute("height", displayObject.height.toString() + "px");
                svg.style.position = "absolute";
                element.appendChild(svg);
            }
        }
        
        private var pathParts:Array;
        private var fillColor:uint;
        private var fillAlpha:Number = 1.0;
        
        public function beginFill(color:uint, alpha:Number = 1.0):void
        {
            COMPILE::SWF
            {
                displayObject.flashgraphics.beginFill(color, alpha);
            }
            COMPILE::JS
            {
                if (!pathParts)
                    pathParts = [];
                fillColor = color;
                fillAlpha = alpha;
            }
            fillInProgress = true;
            fillType = FILLTYPE_SOLID;
        }
        
        /**
         * @royaleignorecoercion SVGElement
         */
		public function endFill(): void
		{
            COMPILE::SWF
            {
                displayObject.flashgraphics.endFill();
            }
            COMPILE::JS
            {
                if (pathParts && pathParts.length)
                {
                    var path:SVGElement = document.createElementNS("http://www.w3.org/2000/svg", "path") as SVGElement;
                    var colorString:String = "RGB(" + (color >> 16) + "," + ((color & 0xff00) >> 8) + "," + (color & 0xff) + ")";
                    path.setAttribute("stroke", colorString);
                    var widthString:String = thickness.toString();
                    path.setAttribute("stroke-width", widthString);
                    if (alpha != 1)
                        path.setAttribute("stroke-opacity", alpha.toString());
                    if (fillType == FILLTYPE_LINEARGRADIENT)
                    {
                        path.setAttribute("fill", "url(#gradientFill)");                        
                    }
                    else if (fillType == FILLTYPE_SOLID)
                    {
                        colorString = "RGB(" + (fillColor >> 16) + "," + ((fillColor & 0xff00) >> 8) + "," + (fillColor & 0xff) + ")";
                        path.setAttribute("fill", colorString);
                        if (fillAlpha != 1)
                            path.setAttribute("fill-opacity", fillAlpha.toString());                        
                    }
                    else
                        path.setAttribute("fill", "transparent");
                    var pathString:String = pathParts.join(" ");
                    path.setAttribute("d", pathString);
                    path.setAttribute("pointer-events", "none");
                    svg.appendChild(path);
                    pathParts = null;
                }
            }
            fillInProgress = false;
		}
		
        /**
         * JS needs some way to know the stroke is starting if there isn't going to be an beginFill call
         */
        public function beginStroke(): void
        {
            COMPILE::JS
            {
                if (!pathParts)
                    pathParts = [];
            }            
        }
        
        /**
         * JS needs some way to know the stroke is done if there isn't going to be an endFill call
         */
        public function endStroke(): void
        {
            // sometimes GraphicsUtilities.PolyLine is called to set a path for a fill
            // and not just draw a line
            if (fillInProgress) return;
            
            COMPILE::JS
            {
                if (pathParts && pathParts.length)
                {
                    var path:SVGElement = document.createElementNS("http://www.w3.org/2000/svg", "polyline") as SVGElement;
                    var colorString:String = "RGB(" + (color >> 16) + "," + ((color & 0xff00) >> 8) + "," + (color & 0xff) + ")";
                    path.setAttribute("stroke", colorString);
                    var widthString:String = thickness.toString();
                    path.setAttribute("stroke-width", widthString);
                    if (alpha != 1)
                        path.setAttribute("stroke-opacity", alpha.toString());
                    //colorString = "RGB(" + (fillColor >> 16) + "," + ((fillColor & 0xff00) >> 8) + "," + (fillColor & 0xff) + ")";
                    path.setAttribute("fill", "none");
                    //if (fillAlpha != 1)
                    //    path.setAttribute("fill-opacity", fillAlpha.toString());
                    var pathString:String = "";
                    var firstOne:Boolean = true;
                    var n:int = pathParts.length;
                    for (var i:int = 0;i < n; i++)
                    {
                        var part:String = pathParts[i];
                        if (!firstOne)
                            pathString += ",";
                        firstOne = false;
                        pathString += part.substring(1);
                    }
                    path.setAttribute("points", pathString);
                    path.setAttribute("pointer-events", "none");
                    svg.appendChild(path);
                    pathParts = null;
                }
            }            
        }
        
        private var fillType:String;
        private var gradientColors:Array;
        private var gradientAlphas:Array;
        private var graidentRatios:Array;
        private var gradientMatrix:Matrix;
        private var gradientSpreadMethod:String;
        private var gradientInterpolationMethod:String;
        private var gradientFocalPointRatio:Number;
		public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0):void
		{
            COMPILE::JS
            {
                fillType = FILLTYPE_LINEARGRADIENT;
                gradientColors = colors;
                gradientAlphas = alphas;
                graidentRatios = ratios;
                gradientMatrix = matrix;
                gradientSpreadMethod = spreadMethod;
                gradientInterpolationMethod = interpolationMethod;
                gradientFocalPointRatio = focalPointRatio;
                var gradient:SVGElement = document.createElementNS("http://www.w3.org/2000/svg", fillType) as SVGElement;
                gradient.id = "gradientFill";
                if (matrix == Graphics.MATRIX_ROTATE90)
                    gradient.setAttribute("gradientTransform", "rotate(90)");
                var n:int = colors.length;
                var chunk:Number = 100 / (n - 1);
                var chunks:Array = [];
                var k:Number = 0;
                for (var j:int = 0; j < n; j++)
                {
                    chunks.push(k);
                    k += chunk;
                }
                for (var i:int = 0; i < n; i++)
                {
                    var entry:GradientEntry = colors[i] as GradientEntry;
                    var stop:SVGElement = document.createElementNS("http://www.w3.org/2000/svg", "stop") as SVGElement;
                    var color:uint = entry.color;
                    var colorString:String = "RGB(" + (color >> 16) + "," + ((color & 0xff00) >> 8) + "," + (color & 0xff) + ")";
                    stop.setAttribute("stop-color", colorString);
                    stop.setAttribute("offset", chunks[i] + "%");
                    gradient.appendChild(stop);
                }
                var defs:SVGElement = svg.querySelector('defs') as SVGElement;
                if (!defs)
                {
                    defs = document.createElementNS("http://www.w3.org/2000/svg", "defs") as SVGElement;
                    svg.insertBefore(defs, svg.firstChild);
                }
                defs.appendChild(gradient);
            }
		} 
		
        private var thickness:Number = NaN;
        private var color:uint = 0;
        private var alpha:Number = 1.0;
        
		public function lineStyle(thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3):void
		{
            COMPILE::SWF
            {
                displayObject.flashgraphics.lineStyle(thickness, color, alpha);
            }
            COMPILE::JS
            {
                this.thickness = thickness == 0 ? 0.5 : thickness;
                this.color = color;
                this.alpha = alpha;
            }
		}
		
		public function moveTo(x:Number, y:Number):void
		{
            COMPILE::SWF
            {
                displayObject.flashgraphics.moveTo(x, y);
            }
            COMPILE::JS
            {
                if (!pathParts)
                    pathParts = [];
                pathParts.push("M" + x + " " + y);
            }
		}
		
		public function lineTo(x:Number, y:Number):void
		{
            COMPILE::SWF
            {
                displayObject.flashgraphics.lineTo(x, y);
            }
            COMPILE::JS
            {
                if (!pathParts)
                    pathParts = [];
                pathParts.push("L" + x + " " + y);
            }
		}
		
		public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void
		{
            COMPILE::SWF
            {
                displayObject.flashgraphics.curveTo(controlX, controlY, anchorX, anchorY);
            }
            COMPILE::JS
            {
                if (!pathParts)
                    pathParts = [];
                pathParts.push("Q" + controlX + " " + controlY + " " + anchorX + " " + anchorY);
            }
		}
        
        /**
         * @royaleignorecoercion SVGElement
         */
        public function drawEllipse(x:Number, y:Number, width:Number, height:Number):void
        {
            COMPILE::SWF
            {
                displayObject.flashgraphics.drawEllipse(x, y, width, height);
            }
            COMPILE::JS
            {
                var path:SVGElement = document.createElementNS("http://www.w3.org/2000/svg", "ellipse") as SVGElement;
                var colorString:String = "RGB(" + (color >> 16) + "," + ((color & 0xff00) >> 8) + "," + (color & 0xff) + ")";
                if (!isNaN(thickness))
                {
                    path.setAttribute("stroke", colorString);
                    var widthString:String = thickness.toString();
                    path.setAttribute("stroke-width", widthString);
                    if (alpha != 1)
                        path.setAttribute("stroke-opacity", alpha.toString());
                }
                if (fillType == FILLTYPE_LINEARGRADIENT)
                {
                    path.setAttribute("fill", "url(#gradientFill)");                        
                }
                else if (fillType == FILLTYPE_SOLID)
                {
                    colorString = "RGB(" + (fillColor >> 16) + "," + ((fillColor & 0xff00) >> 8) + "," + (fillColor & 0xff) + ")";
                    path.setAttribute("fill", colorString);
                    if (fillAlpha != 1)
                        path.setAttribute("fill-opacity", fillAlpha.toString());
                }
                else
                    path.setAttribute("fill", "transparent");
                path.setAttribute("cx", x.toString());
                path.setAttribute("cy", y.toString());
                path.setAttribute("rx", width.toString());
                path.setAttribute("ry", height.toString());
                path.setAttribute("pointer-events", "none");
                svg.appendChild(path);
            }
        }
        
        /**
         * @royaleignorecoercion SVGElement
         */
        public function drawRoundRect(x:Number, y:Number, width:Number, height:Number, radiusX:Number, radiusY:Number = NaN):void
        {
            COMPILE::SWF
            {
                displayObject.flashgraphics.drawRoundRect(x, y, width, height, radiusX, radiusY);
            }
            COMPILE::JS
            {
                var path:SVGElement = document.createElementNS("http://www.w3.org/2000/svg", "rect") as SVGElement;
                var colorString:String = "RGB(" + (color >> 16) + "," + ((color & 0xff00) >> 8) + "," + (color & 0xff) + ")";
                if (!isNaN(thickness))
                {
                    path.setAttribute("stroke", colorString);
                    var widthString:String = thickness.toString();
                    path.setAttribute("stroke-width", widthString);
                    if (alpha != 1)
                        path.setAttribute("stroke-opacity", alpha.toString());
                }
                if (fillType == FILLTYPE_LINEARGRADIENT)
                {
                    path.setAttribute("fill", "url(#gradientFill)");                        
                }
                else if (fillType == FILLTYPE_SOLID)
                {
                    colorString = "RGB(" + (fillColor >> 16) + "," + ((fillColor & 0xff00) >> 8) + "," + (fillColor & 0xff) + ")";
                    path.setAttribute("fill", colorString);
                    if (fillAlpha != 1)
                        path.setAttribute("fill-opacity", fillAlpha.toString());
                }
                else
                    path.setAttribute("fill", "transparent");
                path.setAttribute("x", x.toString());
                path.setAttribute("y", y.toString());
                path.setAttribute("rx", radiusX.toString());
                if (isNaN(radiusY))
                    path.setAttribute("ry", radiusX.toString());
                else
                    path.setAttribute("ry", radiusY.toString());
                path.setAttribute("width", width.toString());
                path.setAttribute("height", height.toString());
                path.setAttribute("pointer-events", "none");
                svg.appendChild(path);
            }
        }
        
        /**
         * @royaleignorecoercion SVGElement
         */
        public function drawRect(x:Number, y:Number, width:Number, height:Number):void
        {
            COMPILE::SWF
            {
                displayObject.flashgraphics.drawRect(x, y, width, height);
            }
            COMPILE::JS
            {
                var path:SVGElement = document.createElementNS("http://www.w3.org/2000/svg", "rect") as SVGElement;
                var colorString:String = "RGB(" + (color >> 16) + "," + ((color & 0xff00) >> 8) + "," + (color & 0xff) + ")";
                if (!isNaN(thickness))
                {
                    path.setAttribute("stroke", colorString);
                    var widthString:String = thickness.toString();
                    path.setAttribute("stroke-width", widthString);
                    if (alpha != 1)
                        path.setAttribute("stroke-opacity", alpha.toString());
                }
                if (fillType == FILLTYPE_LINEARGRADIENT)
                {
                    path.setAttribute("fill", "url(#gradientFill)");                        
                }
                else if (fillType == FILLTYPE_SOLID)
                {
                    colorString = "RGB(" + (fillColor >> 16) + "," + ((fillColor & 0xff00) >> 8) + "," + (fillColor & 0xff) + ")";
                    path.setAttribute("fill", colorString);
                    if (fillAlpha != 1)
                        path.setAttribute("fill-opacity", fillAlpha.toString());
                }
                else
                    path.setAttribute("fill", "transparent");
                path.setAttribute("x", x.toString());
                path.setAttribute("y", y.toString());
                path.setAttribute("width", width.toString());
                path.setAttribute("height", height.toString());
                path.setAttribute("pointer-events", "none");
                svg.appendChild(path);
            }
        }
        
        /**
         * @royaleignorecoercion SVGElement
         */
        public function drawCircle(x:Number, y:Number, radius:Number):void
        {
            COMPILE::SWF
            {
                displayObject.flashgraphics.drawCircle(x, y, radius);
            }
            COMPILE::JS
            {
                var path:SVGElement = document.createElementNS("http://www.w3.org/2000/svg", "circle") as SVGElement;
                var colorString:String = "RGB(" + (color >> 16) + "," + ((color & 0xff00) >> 8) + "," + (color & 0xff) + ")";
                if (!isNaN(thickness))
                {
                    path.setAttribute("stroke", colorString);
                    var widthString:String = thickness.toString();
                    path.setAttribute("stroke-width", widthString);
                    if (alpha != 1)
                        path.setAttribute("stroke-opacity", alpha.toString());
                }
                if (fillType == FILLTYPE_LINEARGRADIENT)
                {
                    path.setAttribute("fill", "url(#gradientFill)");                        
                }
                else if (fillType == FILLTYPE_SOLID)
                {
                    colorString = "RGB(" + (fillColor >> 16) + "," + ((fillColor & 0xff00) >> 8) + "," + (fillColor & 0xff) + ")";
                    path.setAttribute("fill", colorString);
                    if (fillAlpha != 1)
                        path.setAttribute("fill-opacity", fillAlpha.toString());
                }
                else
                    path.setAttribute("fill", "transparent");
                path.setAttribute("cx", x.toString());
                path.setAttribute("cy", y.toString());
                path.setAttribute("r", radius.toString());
                path.setAttribute("pointer-events", "none");
                svg.appendChild(path);
            }
        }

	// not implemented
	COMPILE::JS
	public function beginBitmapFill(bitmap:BitmapData, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):void
		{
		}
			

	}
	
}
