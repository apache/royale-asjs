////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package
{
	
	public class USStatesMap
	{
		
		private var title:HTMLDivElement;
		private var map:SVGElement;
		
		public function start():void
		{
			createTitle();
			createMap();
		}
		
		/**
		 * Create title
		 */
		private function createTitle():void
		{
			this.title = HTMLDivElement(document.createElement("div"));
			title.innerHTML = "US Map (mouseover to highlight, click to animate)";
			document.body.appendChild(title);
		}
		
		/**
		 * Create svg elements for map
		 * Parse and render each state
		 */
		private function createMap():void
		{
			this.map = SVGElement(document.createElementNS("http://www.w3.org/2000/svg", "svg"));
			this.map.style.width = 1000 + "px";
			this.map.style.height = 1000 + "px";
			document.body.appendChild(map);
			
			var usmapCoords:Object = new MapCoords().usmap;
			var path:SVGPathElement;
            var poly:SVGPolygonElement;
            var line:SVGPolylineElement;
			for (var state:String in usmapCoords)
			{
                if (state == "wy" || state == "co")
                {
                    poly = SVGPolygonElement(document.createElementNS("http://www.w3.org/2000/svg", "polygon"));
                    poly.setAttribute("points", usmapCoords[state]);
                    poly.setAttribute("fill","#FF0000");
                    poly.setAttribute("opacity", Math.random());
                    poly.addEventListener("mouseover", handleStateMouseOver, false);
                    poly.addEventListener("mouseout", handleStateMouseOut, false);
                    poly.addEventListener("click", handleStateClick, false);
                    map.appendChild(poly);
                }
                else if (state == "ut")
                {
                    line = SVGPolylineElement(document.createElementNS("http://www.w3.org/2000/svg", "polyline"));
                    line.setAttribute("points", usmapCoords[state]);
                    line.setAttribute("fill","#FF0000");
                    line.setAttribute("opacity", Math.random());
                    line.addEventListener("mouseover", handleStateMouseOver, false);
                    line.addEventListener("mouseout", handleStateMouseOut, false);
                    line.addEventListener("click", handleStateClick, false);
                    map.appendChild(line);
                }
                else
                {
    				path = SVGPathElement(document.createElementNS("http://www.w3.org/2000/svg", "path"));
    				path.setAttribute("d", usmapCoords[state]);
                    path.setAttribute("fill","#FF0000");
                    path.setAttribute("opacity", Math.random());
                    path.addEventListener("mouseover", handleStateMouseOver, false);
                    path.addEventListener("mouseout", handleStateMouseOut, false);
                    path.addEventListener("click", handleStateClick, false);
                    map.appendChild(path);
                }
			}

		}
		
		/**
		 * State mouseover handler
		 */
		private function handleStateMouseOver(event:MouseEvent):void
		{
			SVGPathElement(event.target).setAttribute("fill", "#0000FF");
		}
		
		/**
		 * State mouseout handler
		 */
		private function handleStateMouseOut(event:MouseEvent):void
		{
			SVGPathElement(event.target).setAttribute("fill", "#FF0000");
		}
		
		private var pathToAnimate:SVGPathElement;
		private var scaleValue:Number = 1;
		/**
		 * State click handler
		 * Start animating
		 */
		private function handleStateClick(event:MouseEvent):void
		{
			pathToAnimate = SVGPathElement(event.target);
			animateScaleUp();
		}
		
		/**
		 * Increment scale of path element by 0.1 each frame
		 */
		private function animateScaleUp():void
		{
			scaleValue += 0.1;
			setScale(this.pathToAnimate,scaleValue);
			if(scaleValue >= 1.5)
			{
				animateScaleDown();
			}
			else
			{
				requestAnimationFrame(animateScaleUp);
			}
		}
		
		/**
		 * Decrement scale of path element by 0.1 each frame
		 */
		private function animateScaleDown():void
		{
			scaleValue -= 0.1;
			setScale(this.pathToAnimate,scaleValue);
			if(scaleValue > 1)
			{
				requestAnimationFrame(animateScaleDown);
			}
		}
		
		/**
		 * Apply scale transform; ensure element stays in place while scaling
		 */
		private function setScale(element:SVGElement,scale):void
		{
			var boundingRect:SVGRect = this.pathToAnimate.getBBox();
			var centerX:Number = boundingRect.x;
			var centerY:Number = boundingRect.y;
			element.setAttribute("transform","translate(" + centerX + "," + centerY + ") scale(" + scaleValue + ") translate(" + -1*centerX + "," + -1*centerY + ")"); 
		}
		
	}
}
