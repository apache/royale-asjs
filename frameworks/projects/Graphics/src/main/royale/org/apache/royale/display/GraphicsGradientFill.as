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
	}
	
	/*COMPILE::JS{
		import org.apache.royale.geom.Point;
	}*/
	/**
	 * @royalesuppresspublicvarwarning
	 * @royalesuppressexport
	 */
	public class GraphicsGradientFill implements IGraphicsFill, IGraphicsData
	{
		private static var _defaultMatrix:Matrix;
		public var alphas:Array;
		public var colors:Array;
		public var ratios:Array;
		public var matrix:Matrix;
		public var spreadMethod:String;
		public var type:String;
		
		public var interpolationMethod:String;
		public var focalPointRatio:Number;
		
		
		public function GraphicsGradientFill(type:String = "linear", colors:Array = null, alphas:Array = null, ratios:Array = null, matrix:* = null, spreadMethod:* = 'pad', interpolationMethod:String = "rgb", focalPointRatio:Number = 0.0){
			this.type = type;
			this.colors = colors;
			this.alphas = alphas;
			this.ratios = ratios;
			this.matrix = matrix;
			this.spreadMethod = spreadMethod;
			this.interpolationMethod = interpolationMethod;
			this.focalPointRatio = focalPointRatio;
		}
		
		
		COMPILE::JS
		public function apply(graphics:Graphics, element:SVGPathElement):void {
			var fillElement:SVGGradientElement = configureGradientElement(graphics, graphics.makeGradient(this.type =='linear' ? 'linearGradient' : 'radialGradient'));
			
			element.setAttributeNS(null, 'fill', 'url(#'+ fillElement.getAttribute('id') + ')');
			if (interpolationMethod == InterpolationMethod.LINEAR_RGB) {
				element.setAttributeNS(null, 'filter',  graphics.getLinearRGBfilter());
			}
		}
		
		COMPILE::JS
		public function applyStroke(graphics:Graphics, element:SVGPathElement):SVGPathElement {
			//remove any stroke-opacity setting, which is not applicable
			if (element.getAttributeNS(null, 'stroke-opacity') != null) {
				element.setAttributeNS(null, 'stroke-opacity', null);
			}
			var linearRGB:Boolean = interpolationMethod == InterpolationMethod.LINEAR_RGB;
			if (element.getAttributeNS(null, 'fill') !== 'none') {
				//deal with possible filter-based emulations
				var filterCheck:String = element.getAttributeNS(null, 'filter');
				if ((linearRGB && filterCheck != graphics.getLinearRGBfilter()) || (!linearRGB && filterCheck != null)) {
					element = graphics.spawnStroke(true);
					return element;
				}
			}
			//var strokeElement:SVGGradientElement = graphics.makeGradient(this.type =='linear' ? 'linearGradient' : 'radialGradient');
			var strokeElement:SVGGradientElement = configureGradientElement(graphics, graphics.makeGradient(this.type =='linear' ? 'linearGradient' : 'radialGradient'));
			element.setAttributeNS(null, 'stroke', 'url(#'+ strokeElement.getAttribute('id') + ')');
			if (linearRGB) {
				element.setAttributeNS(null, 'filter', graphics.getLinearRGBfilter());
			}
			return element;
		}
		
		COMPILE::JS{
			
			private static var _utilMatrix:Matrix;
			private static function getUtilMatrix(copyFrom:Matrix):Matrix{
				var ret:Matrix = _utilMatrix;
				if (!ret) {
					ret = _utilMatrix = new Matrix();
				}
				ret.copyFrom(copyFrom);
				return  ret;
			}
			
			private function configureGradientElement(graphics:Graphics, gradientElement:SVGGradientElement):SVGGradientElement{
				
				//make stops
				var l:uint = colors.length;
				for (var i:uint = 0; i< l;i++) {
					var hexColor:String = '#'+('00000'+uint(colors[i]).toString(16)).substr(-6);
					var stopElement:SVGStopElement = graphics.makeGradientStop();
					var alpha:Number = alphas[i];
					var ratio:Number = ratios[i]/255;
					stopElement.setAttributeNS(null,'stop-color', hexColor);
					if (alpha != 1)
						stopElement.setAttributeNS(null,'stop-opacity', alpha.toString());
					stopElement.setAttributeNS(null,'offset', ratio.toString());
					gradientElement.appendChild(stopElement);
				}
				var matrix:Matrix = this.matrix;
				if (!matrix) {
					if (_defaultMatrix) matrix = _defaultMatrix;
					else {
						//observed behavior in swf, reproduced via trial and error
						matrix = _defaultMatrix = new Matrix(0.1220703125,0,0,0.1220703125);
					}
				}
				var utilMatrix:Matrix = matrix;
				var h_len:Number = 819.2;
				var isRadial:Boolean = type == 'radial';
				var isLinear:Boolean = type == 'linear';
				var gTransform:Boolean = false;

				if (Math.abs(utilMatrix.c) > 0.000001 || Math.abs(utilMatrix.b) >  0.000001) {
					
					if (-1.0 * (Math.round(utilMatrix.a * utilMatrix.c * 1000000)/1000000) !== Math.round(utilMatrix.d * utilMatrix.b * 1000000)/1000000) {
						utilMatrix = getUtilMatrix(matrix);

						utilMatrix.translate(-matrix.tx, -matrix.ty);
						var skewY:Number =  Math.atan2( utilMatrix.b, utilMatrix.a);
						var skewX:Number =  -1 * Math.atan2(-utilMatrix.c, utilMatrix.d);
						
						var diff:Number = (Math.PI/2) - (Math.abs(skewX) + Math.abs(skewY));
						
						if (skewX > 0) diff = -diff;
						var axis_rot:Number = skewY + diff;
						utilMatrix.rotate(axis_rot);
						
						skewX = Math.tan(skewX + skewY);
						utilMatrix.a += utilMatrix.b * skewX;
						utilMatrix.c += utilMatrix.d * skewX;
						utilMatrix.tx += utilMatrix.ty * skewX;
						
						if (isRadial) {
							gTransform = uniformScaleAdjusted(utilMatrix);
						}
						
						utilMatrix.rotate(-axis_rot);
						utilMatrix.translate(matrix.tx, matrix.ty);
					} else {
						if (isRadial) {
							utilMatrix = getUtilMatrix(matrix);

							utilMatrix.translate(-matrix.tx, -matrix.ty);
							axis_rot = Math.atan2( utilMatrix.b, utilMatrix.a);
							if (axis_rot) utilMatrix.rotate(-axis_rot);
							gTransform = uniformScaleAdjusted(utilMatrix);
							if (gTransform) {
								if (axis_rot) utilMatrix.rotate(axis_rot);
								utilMatrix.translate(matrix.tx, matrix.ty);
							} else utilMatrix = matrix;
						}
					}
					
				} else {
					if (isRadial) {
						utilMatrix = getUtilMatrix(matrix);

						utilMatrix.b = utilMatrix.c = 0;
						utilMatrix.translate(-matrix.tx, -matrix.ty);
						gTransform = uniformScaleAdjusted(utilMatrix);
						utilMatrix.translate(matrix.tx, matrix.ty);
					}
				}
				
				if (isLinear) {
					gradientElement.setAttributeNS(null,'x1', (utilMatrix.a * -h_len + utilMatrix.tx).toString());
					gradientElement.setAttributeNS(null,'y1', (utilMatrix.b * -h_len + utilMatrix.ty).toString());
					gradientElement.setAttributeNS(null,'x2', (utilMatrix.a * h_len + utilMatrix.tx).toString());
					gradientElement.setAttributeNS(null,'y2', (utilMatrix.b * h_len + utilMatrix.ty).toString());
				}
				else if (isRadial) {
					var fr:Number = focalPointRatio;
					if (isNaN(fr)) fr = -1; //observed in flash
					if (Math.abs(fr) > 1) {
						fr = fr < 0 ? -1 : 1;
					}
					if (fr) {
						fr *= h_len;
						gradientElement.setAttributeNS(null, 'fx', (utilMatrix.a * fr + utilMatrix.tx).toString());
						gradientElement.setAttributeNS(null, 'fy', (utilMatrix.b * fr + utilMatrix.ty).toString());
					}
					
					h_len *= h_len;
					gradientElement.setAttributeNS(null, 'r', Math.sqrt(utilMatrix.a *utilMatrix.a * h_len + utilMatrix.b * utilMatrix.b * h_len).toString());
					
					gradientElement.setAttributeNS(null, 'cx', matrix.tx.toString());
					gradientElement.setAttributeNS(null, 'cy', matrix.ty.toString());

					if (gTransform) {
						//can mutate utilMatrix here, because original matrix content is no longer needed
						utilMatrix.invert();
						utilMatrix.concat(matrix);
						gradientElement.setAttributeNS(null, 'gradientTransform', 'matrix( '+ utilMatrix.a + ',' + utilMatrix.b + ',' + utilMatrix.c + ',' + utilMatrix.d + ',' + utilMatrix.tx + ',' + utilMatrix.ty + ')');
					}
				}

				//common
				gradientElement.setAttributeNS(null, 'spreadMethod', spreadMethod);
				
				//Note: it should be possible to use 'color-interpolation' here to support 'interpolationMethod' as linearRGB according to the spec,
				//but in practice it is not implemented anywhere that I could see (in browsers, or Inkscape)
				//so for now, interpolationMethod is supported elsewhere via a filter on the graphic element, which provides the
				//required match for 'linearRGB' swf output.
				//references: (an old bug about this) https://bugzilla.mozilla.org/show_bug.cgi?id=298281#c3
				//live browser test comparison of svg (actual) vs. png (expected) :
				// https://www.w3.org/Graphics/SVG/Test/20030813/htmlframe/full-painting-render-01-b.html
				
				return gradientElement;
			}
			
			
			private static function uniformScaleAdjusted(matrix:Matrix):Boolean {
				var x_s:Number =matrix.a * matrix.a + matrix.b * matrix.b;
				var y_s:Number = matrix.c * matrix.c + matrix.d * matrix.d;
				if (y_s != x_s) {
					if (y_s < x_s) {
						matrix.b = matrix.c = 0;
						matrix.a = matrix.d =  Math.sqrt(x_s);
					}	else {
						matrix.b = matrix.c = 0;
						matrix.a = matrix.d = Math.sqrt(y_s);
					}
					return true;
				}
				return false;
			}
			
		}
    }
	
}



