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
package org.apache.royale.display
{
	COMPILE::JS{
		import org.apache.royale.geom.Matrix;
	}
	COMPILE::SWF{
		import flash.geom.Matrix;
		import flash.display.BitmapData;
	}
	
	/*COMPILE::JS{
		import org.apache.royale.geom.Point;
	}*/
	/**
	 * @royalesuppresspublicvarwarning
	 * @royalesuppressexport
	 */
	public class GraphicsBitmapFill implements IGraphicsFill, IGraphicsData
	{
		private static var _defaultMatrix:Matrix;
		public var bitmapData:BitmapData;
		public var matrix:Matrix;
		public var repeat:Boolean;
		public var smooth:Boolean;
		
		
		public function GraphicsBitmapFill(bitmapData:BitmapData = null, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false){
			this.bitmapData = bitmapData;
			this.matrix = matrix;
			this.repeat = repeat;
			this.smooth = smooth;
		}
		
		
		COMPILE::JS
		public function apply(graphics:Graphics, element:SVGPathElement):void {
			var fillElement:SVGPatternElement = configurePatternElement(graphics, graphics.makeBitmapPaint(bitmapData, smooth));
			element.setAttributeNS(null, 'fill', 'url(#'+ fillElement.getAttribute('id') + ')');
		}
		
		COMPILE::JS
		public function applyStroke(graphics:Graphics, element:SVGPathElement):SVGPathElement {
			//remove any stroke-opacity setting, which is not applicable
			if (element.getAttributeNS(null, 'stroke-opacity') != null) {
				element.setAttributeNS(null, 'stroke-opacity', null);
			}
			
			var strokeElement:SVGPatternElement = configurePatternElement(graphics, graphics.makeBitmapPaint(bitmapData, smooth));
			element.setAttributeNS(null, 'stroke', 'url(#'+ strokeElement.getAttribute('id') + ')');
			return element;
		}
		
		COMPILE::JS
		private function configurePatternElement(graphics:Graphics, patternElement:SVGPatternElement):SVGPatternElement{
			
			var w:String;
			var h:String;
			if (repeat) {
				w =  bitmapData.width.toString();
				h = bitmapData.height.toString();
			} else {
				w = h = '100%'; //we cannot 'pad' yet. Need to investigate options, possibly using feConvolveMatrix somehow with edgeMode = 'duplicate'
			}
			patternElement.setAttributeNS(null, 'width',w);
			patternElement.setAttributeNS(null, 'height', h);
			if (matrix) {
				var matrixString:String = 'matrix(' + matrix.a + ',' + matrix.b + ',' + matrix.c + ',' + matrix.d + ',' + matrix.tx + ',' + matrix.ty + ')';
				patternElement.setAttributeNS(null, 'patternTransform', matrixString);
			}
			
			return patternElement;
		}
			
		
    }
	
}



