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
	import org.apache.royale.style.util.CSSLookup;
	import org.apache.royale.utils.CSSUtils;

	public class ColorSwatch
	{
		// Tailwind color names.
		public static const RED:String = "red";
		public static const ORANGE:String = "orange";
		public static const AMBER:String = "amber";
		public static const YELLOW:String = "yellow";
		public static const LIME:String = "lime";
		public static const GREEN:String = "green";
		public static const EMERALD:String = "emerald";
		public static const TEAL:String = "teal";
		public static const CYAN:String = "cyan";
		public static const SKY:String = "sky";
		public static const BLUE:String = "blue";
		public static const INDIGO:String = "indigo";
		public static const VIOLET:String = "violet";
		public static const PURPLE:String = "purple";
		public static const FUCHSIA:String = "fuchsia";
		public static const PINK:String = "pink";
		public static const ROSE:String = "rose";
		public static const SLATE:String = "slate";
		public static const GRAY:String = "gray";
		public static const ZINC:String = "zinc";
		public static const NEUTRAL:String = "neutral";
		public static const STONE:String = "stone";
		public static const TAUPE:String = "taupe";
		public static const MAUVE:String = "mauve";
		public static const MIST:String = "mist";
		public static const OLIVE:String = "olive";

		// Tailwind 500 base colors keyed by Tailwind swatch name.
		private static const BASE_COLORS:Object = {
			"red": 0xFB2C36,
			"orange": 0xFF6900,
			"amber": 0xFE9A00,
			"yellow": 0xF0B100,
			"lime": 0x7CCF00,
			"green": 0x00C950,
			"emerald": 0x00BC7D,
			"teal": 0x00BBA7,
			"cyan": 0x00B8DB,
			"sky": 0x00A6F4,
			"blue": 0x2B7FFF,
			"indigo": 0x615FFF,
			"violet": 0x8E51FF,
			"purple": 0xAD46FF,
			"fuchsia": 0xE12AFB,
			"pink": 0xF6339A,
			"rose": 0xFF2056,
			"slate": 0x62748E,
			"gray": 0x6A7282,
			"zinc": 0x71717B,
			"neutral": 0x737373,
			"stone": 0x79716B,
			"taupe": 0x7C6D67,
			"mauve": 0x79697B,
			"mist": 0x67787C,
			"olive": 0x7C7C67
		};

		/**
		 * Subclasses must specify colorBase before calling this constructor.
		 */
		public function ColorSwatch(swatch:String,shade:Number,opacity:Number = 100)
		{
			var base:Object = BASE_COLORS[swatch] || CSSLookup.getProperty(swatch);
			assert(base, "Invalid color swatch: " + swatch);
			// Convert from 50,100,200... to 5,10,20... for easier math.
			shade = Math.round(shade/10);
			var colorVals:Array = CSSColor.getVariation(CSSUtils.toColor(base),shade);

			assert(opacity >= 0 && opacity <= 100, "Opacity must be between 0 and 100");
			colorBase = swatch;
			colorShade = shade;
			colorOpacity = opacity;
			colorSpecifier = colorBase + "-" + shade;
			if(opacity < 100)
			{
				colorSpecifier += "/" + opacity;
			}
			colorValue = CSSColor.getColor(colorVals, opacity, colorSpace);
			CSSLookup.register(colorSpecifier,colorValue);
		}
		public var colorBase:String;
		public var colorShade:Number;
		public var colorOpacity:Number;
		public var colorValue:String;
		public var colorSpace:String = "rgb";
		public var colorSpecifier:String;
		public static function fromSpecifier(specifier:String):ColorSwatch
		{
			var parts:Array = specifier.split("-");
			assert(parts.length == 2, "Invalid color specifier: " + specifier);
			var base:String = parts[0];
			var shadeAndOpacity:String = parts[1];
			var shadeParts:Array = shadeAndOpacity.split("/");
			var shade:Number = Number(shadeParts[0]);
			var opacity:Number = shadeParts.length > 1 ? Number(shadeParts[1]) : 100;
			return new ColorSwatch(base, shade, opacity);
		}
	}
}