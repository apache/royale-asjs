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
package org.apache.royale.style.colors
{
	import org.apache.royale.debugging.assert;
	import org.apache.royale.utils.number.pinValue;

	public class CSSColor
	{
		private function CSSColor()
		{
			
		}
		public static function getColor(values:Array, opacity:Number = 100, space:String = "rgb"):String{
			assert(values && values.length == 3, "invalid color values");

			var withAlpha:Boolean = opacity < 100;
			var alphaString:String = opacity + "%";
			var channels:String = values.join(" ");

			switch (space)
			{
				case "rgb":
				case "hsl":
				case "hwb":
				case "lab":
				case "lch":
				case "oklab":
				case "oklch":
					return withAlpha ? space + "(" + channels + " / " + alphaString + ")" : space + "(" + channels + ")";
				default:
					assert(false, "Unsupported color space: " + space);
					break;
			}
			return "";
		}

		/**
		 * Returns an RGB array on a white -> base -> black ramp.
		 * 0 is white, 50 is the input color, 100 is black.
		 */
		public static function getVariation(color:uint, grayValue:Number):Array
		{
			var r:Number = (color >> 16) & 0xFF;
			var g:Number = (color >> 8) & 0xFF;
			var b:Number = color & 0xFF;

			var t:Number = pinValue(grayValue, 0, 100);
			var outR:Number;
			var outG:Number;
			var outB:Number;

			if (t <= 50)
			{
				var toBase:Number = t / 50;
				outR = 255 + (r - 255) * toBase;
				outG = 255 + (g - 255) * toBase;
				outB = 255 + (b - 255) * toBase;
			}
			else
			{
				var toBlack:Number = (t - 50) / 50;
				outR = r * (1 - toBlack);
				outG = g * (1 - toBlack);
				outB = b * (1 - toBlack);
			}

			return [Math.round(outR), Math.round(outG), Math.round(outB)];
		}

		/**
		 * Convenience helper for callers that have separate channel values.
		 */
		public static function getVariationRGB(r:Number, g:Number, b:Number, grayValue:Number):Array
		{
			var rr:uint = uint(pinValue(r, 0, 255));
			var gg:uint = uint(pinValue(g, 0, 255));
			var bb:uint = uint(pinValue(b, 0, 255));
			var color:uint = (rr << 16) | (gg << 8) | bb;
			return getVariation(color, grayValue);
		}
	}
}