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
	import org.apache.royale.style.colors.CSSColor;
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

	}
}