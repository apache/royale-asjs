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

package org.apache.flex.core.graphics
{
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class LinearGradient extends GradientBase implements IFill
	{
		
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
		
		public function begin(s:GraphicShape,targetBounds:Rectangle):void
		{
			commonMatrix.identity();
			commonMatrix.createGradientBox(targetBounds.width,targetBounds.height,toRad(this.rotation));
			
			s.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios,
				commonMatrix, SpreadMethod.PAD, InterpolationMethod.RGB);
		}
		
		public function end(s:GraphicShape):void
		{
			s.graphics.endFill();
		}
	}
}