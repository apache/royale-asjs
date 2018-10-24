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
	import org.apache.royale.svg.CompoundGraphic;
	import mx.geom.Matrix;
    import mx.core.UIComponent;

	public class Graphics extends org.apache.royale.svg.CompoundGraphic
	{
		private var displayObject:UIComponent;

		public function Graphics(displayObject:UIComponent)
		{
			super();
			this.displayObject = displayObject;
		}

		public function endFill(): void
		{
		}
		public function beginFill(color:uint, alpha:Number = 1.0):void
		{
		}
		
		public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0):void
		{
		} 
		
		public function lineStyle(thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3):void
		{
		}
		
		public function moveTo(x:Number, y:Number):void
		{
		}
		
		public function lineTo(x:Number, y:Number):void
		{
		}
		
		public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void
		{
		}
	}
	
}
