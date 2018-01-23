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
	import org.apache.royale.graphics.GradientBase;
	import org.apache.royale.graphics.GradientEntry;
	import org.apache.royale.graphics.IFill;
	import org.apache.royale.graphics.IGraphicShape;
	import org.apache.royale.utils.CSSUtils;

    COMPILE::SWF
    {
        import flash.display.GradientType;
        import flash.display.Graphics;
        import flash.display.InterpolationMethod;
        import flash.display.SpreadMethod;
        import flash.geom.Matrix;
        import flash.geom.Point;
        import flash.geom.Rectangle;            
    }
	
	public class LinearGradient extends GradientBase implements IFill
	{
		COMPILE::SWF
		private static var commonMatrix:Matrix = new Matrix();
        
		private var _scaleX:Number;
		
		/**
		 *  The horizontal scale of the gradient transform, which defines the width of the (unrotated) gradient
		 */
		public function get scaleX():Number
		{
			return _scaleX;
		}
		
		public function set scaleX(value:Number):void
		{
			_scaleX = value;
		}
		
        COMPILE::SWF
		public function begin(g:Graphics,targetBounds:Rectangle, targetOrigin:Point):void
		{
			commonMatrix.identity();
			commonMatrix.createGradientBox(targetBounds.width,targetBounds.height,toRad(this.rotation),targetOrigin.x, targetOrigin.y);
			
			g.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios,
				commonMatrix, SpreadMethod.PAD, InterpolationMethod.RGB);
			
		}
		
        COMPILE::SWF
		public function end(g:Graphics):void
		{
			g.endFill();
		}
        
        /**
         * addFillAttrib()
         *
         * @param value The IGraphicShape object on which the fill must be added.
         * @return {string}
         * @royaleignorecoercion Node
         * @royaleignorecoercion HTMLElement
         */
        COMPILE::JS
        public function addFillAttrib(value:IGraphicShape):String 
        {
            //Create and add a linear gradient def
            var valueElement:HTMLElement = value.element as HTMLElement;
            var svgNS:String = valueElement.namespaceURI;
            var grad:HTMLElement = document.createElementNS(svgNS, 'linearGradient') as HTMLElement;
            var gradientId:String = this.newId;
            grad.setAttribute('id', gradientId);
            
            //Set x1, y1, x2, y2 of gradient
            grad.setAttribute('x1', '0%');
            grad.setAttribute('y1', '0%');
            grad.setAttribute('x2', '100%');
            grad.setAttribute('y2', '0%');
            
            //Apply rotation to the gradient if rotation is a number
            if (rotation)
            {
                grad.setAttribute('gradientTransform', 'rotate(' + rotation + ' 0.5 0.5)');
            }
            
            //Process gradient entries and create a stop for each entry
            var entries:Array = this.entries;
            for (var i:int = 0; i < entries.length; i++)
            {
                var gradientEntry:GradientEntry = entries[i];
                var stop:HTMLElement = document.createElementNS(svgNS, 'stop') as HTMLElement;
                //Set Offset
                stop.setAttribute('offset', "" + (gradientEntry.ratio * 100) + '%');
                //Set Color
				CSSUtils.attributeFromColor(gradientEntry.color)
                stop.setAttribute('stop-color', CSSUtils.attributeFromColor(gradientEntry.color));
                //Set Alpha
                stop.setAttribute('stop-opacity', gradientEntry.alpha);
                
                grad.appendChild(stop);
            }
            
            //Add defs element if not available already
            //Add newly created gradient to defs element
            var defs:Node = valueElement.querySelector('defs') ||
                valueElement.insertBefore(document.createElementNS(svgNS, 'defs'), valueElement.firstChild);
            defs.appendChild(grad);
            
            //Return the fill attribute
            return 'fill:url(#' + gradientId + ')';
        }

	}
}
