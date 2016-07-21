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
        import flash.display.GradientType;
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
		public function begin(s:GraphicShape,targetBounds:Rectangle, targetOrigin:Point):void
		{
			commonMatrix.identity();
			commonMatrix.createGradientBox(targetBounds.width,targetBounds.height,toRad(this.rotation),targetOrigin.x, targetOrigin.y);
			
			s.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios,
				commonMatrix, SpreadMethod.PAD, InterpolationMethod.RGB);
			
		}
		
        COMPILE::SWF
		public function end(s:GraphicShape):void
		{
			s.graphics.endFill();
		}
        
        /**
         * addFillAttrib()
         *
         * @param value The GraphicShape object on which the fill must be added.
         * @return {string}
         * @flexjsignorecoercion Node
         */
        COMPILE::JS
        public function addFillAttrib(value:GraphicShape):String 
        {
            //Create and add a linear gradient def
            var svgNS:String = value.element.namespaceURI;
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
                stop.setAttribute('offset', String(gradientEntry.ratio * 100) + '%');
                //Set Color
                var color:String = Number(gradientEntry.color).toString(16);
                if (color.length == 1) color = '00' + color;
                if (color.length == 2) color = '00' + color;
                if (color.length == 4) color = '00' + color;
                stop.setAttribute('stop-color', '#' + String(color));
                //Set Alpha
                stop.setAttribute('stop-opacity', String(gradientEntry.alpha));
                
                grad.appendChild(stop);
            }
            
            //Add defs element if not available already
            //Add newly created gradient to defs element
            var defs:Node = value.element.querySelector('defs') ||
                value.element.insertBefore(document.createElementNS(svgNS, 'defs'), value.element.firstChild);
            defs.appendChild(grad);
            
            //Return the fill attribute
            return 'fill:url(#' + gradientId + ')';
        }

	}
}
