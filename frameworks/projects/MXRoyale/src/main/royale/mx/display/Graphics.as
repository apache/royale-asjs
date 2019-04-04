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

	public class Graphics// extends org.apache.royale.svg.CompoundGraphic
	{
		private var displayObject:UIComponent;
        
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
            COMPILE::SWF
            {
                displayObject.graphics.clear();
            }
            COMPILE::JS
            {
                if (svg)
                    element.removeChild(svg);
                svg = document.createElementNS("http://www.w3.org/2000/svg", "svg") as HTMLElement;
                svg.setAttribute("width", displayObject.width.toString() + "px");
                svg.setAttribute("height", displayObject.height.toString() + "px");
                element.appendChild(svg);
            }
        }
        
        private var pathParts:Array;
        private var fillColor:uint;
        private var fillAlpha:Number;
        
        public function beginFill(color:uint, alpha:Number = 1.0):void
        {
            COMPILE::SWF
            {
                displayObject.graphics.beginFill(color, alpha);
            }
            COMPILE::JS
            {
                if (!pathParts)
                    pathParts = [];
                fillColor = color;
                fillAlpha = alpha;
            }
            fillInProgress = true;
        }
        
        /**
         * @royaleignorecoercion SVGElement
         */
		public function endFill(): void
		{
            COMPILE::SWF
            {
                displayObject.graphics.endFill();
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
                    colorString = "RGB(" + (fillColor >> 16) + "," + ((fillColor & 0xff00) >> 8) + "," + (fillColor & 0xff) + ")";
                    path.setAttribute("fill", colorString);
                    if (fillAlpha != 1)
                        path.setAttribute("fill-opacity", fillAlpha.toString());
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
        
		public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0):void
		{
		} 
		
        private var thickness:Number = 0.5;
        private var color:uint = 0;
        private var alpha:Number = 1.0;
        
		public function lineStyle(thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3):void
		{
            COMPILE::SWF
            {
                displayObject.graphics.lineStyle(thickness, color, alpha);
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
                displayObject.graphics.moveTo(x, y);
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
                displayObject.graphics.lineTo(x, y);
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
                displayObject.graphics.curveTo(controlX, controlY, anchorX, anchorY);
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
                displayObject.graphics.drawEllipse(x, y, width, height);
            }
            COMPILE::JS
            {
                var path:SVGElement = document.createElementNS("http://www.w3.org/2000/svg", "ellipse") as SVGElement;
                var colorString:String = "RGB(" + (color >> 16) + "," + ((color & 0xff00) >> 8) + "," + (color & 0xff) + ")";
                path.setAttribute("stroke", colorString);
                var widthString:String = thickness.toString();
                path.setAttribute("stroke-width", widthString);
                if (alpha != 1)
                    path.setAttribute("stroke-opacity", alpha.toString());
                colorString = "RGB(" + (fillColor >> 16) + "," + ((fillColor & 0xff00) >> 8) + "," + (fillColor & 0xff) + ")";
                path.setAttribute("fill", colorString);
                if (fillAlpha != 1)
                    path.setAttribute("fill-opacity", fillAlpha.toString());
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
                displayObject.graphics.drawRoundRect(x, y, width, height, radiusX, radiusY);
            }
            COMPILE::JS
            {
                var path:SVGElement = document.createElementNS("http://www.w3.org/2000/svg", "rect") as SVGElement;
                var colorString:String = "RGB(" + (color >> 16) + "," + ((color & 0xff00) >> 8) + "," + (color & 0xff) + ")";
                path.setAttribute("stroke", colorString);
                var widthString:String = thickness.toString();
                path.setAttribute("stroke-width", widthString);
                if (alpha != 1)
                    path.setAttribute("stroke-opacity", alpha.toString());
                colorString = "RGB(" + (fillColor >> 16) + "," + ((fillColor & 0xff00) >> 8) + "," + (fillColor & 0xff) + ")";
                path.setAttribute("fill", colorString);
                if (fillAlpha != 1)
                    path.setAttribute("fill-opacity", fillAlpha.toString());
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
                displayObject.graphics.drawRect(x, y, width, height);
            }
            COMPILE::JS
            {
                var path:SVGElement = document.createElementNS("http://www.w3.org/2000/svg", "rect") as SVGElement;
                var colorString:String = "RGB(" + (color >> 16) + "," + ((color & 0xff00) >> 8) + "," + (color & 0xff) + ")";
                path.setAttribute("stroke", colorString);
                var widthString:String = thickness.toString();
                path.setAttribute("stroke-width", widthString);
                if (alpha != 1)
                    path.setAttribute("stroke-opacity", alpha.toString());
                colorString = "RGB(" + (fillColor >> 16) + "," + ((fillColor & 0xff00) >> 8) + "," + (fillColor & 0xff) + ")";
                path.setAttribute("fill", colorString);
                if (fillAlpha != 1)
                    path.setAttribute("fill-opacity", fillAlpha.toString());
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
                displayObject.graphics.drawCircle(x, y, radius);
            }
            COMPILE::JS
            {
                var path:SVGElement = document.createElementNS("http://www.w3.org/2000/svg", "circle") as SVGElement;
                var colorString:String = "RGB(" + (color >> 16) + "," + ((color & 0xff00) >> 8) + "," + (color & 0xff) + ")";
                path.setAttribute("stroke", colorString);
                var widthString:String = thickness.toString();
                path.setAttribute("stroke-width", widthString);
                if (alpha != 1)
                    path.setAttribute("stroke-opacity", alpha.toString());
                colorString = "RGB(" + (fillColor >> 16) + "," + ((fillColor & 0xff00) >> 8) + "," + (fillColor & 0xff) + ")";
                path.setAttribute("fill", colorString);
                if (fillAlpha != 1)
                    path.setAttribute("fill-opacity", fillAlpha.toString());
                path.setAttribute("cx", x.toString());
                path.setAttribute("cy", y.toString());
                path.setAttribute("r", radius.toString());
                path.setAttribute("pointer-events", "none");
                svg.appendChild(path);
            }
        }

	}
	
}
