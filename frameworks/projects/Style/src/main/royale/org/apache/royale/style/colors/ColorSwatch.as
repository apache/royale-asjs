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
	import org.apache.royale.style.elements.Col;
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
			"amber": 0xFE9A00,
			"blue": 0x2B7FFF,
			"cyan": 0x00B8DB,
			"emerald": 0x00BC7D,
			"fuchsia": 0xE12AFB,
			"gray": 0x6A7282,
			"green": 0x00C950,
			"indigo": 0x615FFF,
			"lime": 0x7CCF00,
			"mauve": 0x79697B,
			"mist": 0x67787C,
			"neutral": 0x737373,
			"olive": 0x7C7C67,
			"orange": 0xFF6900,
			"pink": 0xF6339A,
			"purple": 0xAD46FF,
			"red": 0xFB2C36,
			"rose": 0xFF2056,
			"sky": 0x00A6F4,
			"slate": 0x64748B,
			"stone": 0x79716B,
			"taupe": 0x7C6D67,
			"teal": 0x00BBA7,
			"violet": 0x8E51FF,
			"yellow": 0xF0B100,
			"zinc": 0x71717B
		};
		
		private static const exceptions:Array = [
			"transparent",
			"currentColor",
			"inherit",
			"none",
			"black",
			"white"
		]
	
		/**
		 * Subclasses must specify colorBase before calling this constructor.
		 */
		public function ColorSwatch(swatch:String,shade:Number,opacity:Number = 100,darkMode:Boolean=false)
		{
			var base:Object = BASE_COLORS[swatch] || CSSLookup.getProperty(swatch);
			assert(base, "Invalid color swatch: " + swatch);
			assert(shade>=0 && shade<=1000, "Invalid shade: " + shade);
			var baseColor:uint = CSSUtils.toColor(base);
			// Convert from 50,100,200... to 5,10,20... for easier math.
		//	shade = Math.round(shade/10);
			rgb = CSSColor.getVariation(baseColor,Math.round(shade/10),darkMode);
			assert(opacity >= 0 && opacity <= 100, "Opacity must be between 0 and 100");
			colorBase = swatch;
			colorShade = shade;
			colorOpacity = opacity;
			colorSpecifier = colorBase + "-" + shade;
			if(opacity < 100)
			{
				colorSpecifier += "/" + opacity;
			}
			colorValue = CSSColor.getColor(rgb, opacity, colorSpace);
			dark = darkMode;
			CSSLookup.register (colorSpecifier,colorValue);
		}
		private var rgb:Array;
		public var colorBase:String;
		public var colorShade:Number;
		public var colorOpacity:Number;
		public var colorValue:String;
		public var colorSpace:String = "rgb";
		public var colorSpecifier:String;
		public var dark:Boolean;
		
		/**
		 * create a ColorSwatch variant from this instance
		 * @param alternateShade - alternate shade. If you want to keep the same shade and adjust opacity, set this to NaN
		 * @param alternateOpacity - if not set it will inherit the original value from this instance
		 * @return a new ColorSwatch with different shade or opacity (or both)
		 */
		public function getVariant(alternateShade:Number, alternateOpacity:Number = NaN):ColorSwatch{
			if (isNaN(alternateShade)) alternateShade = colorShade;
			if (isNaN(alternateOpacity)) alternateOpacity = colorOpacity;
			var alternate:ColorSwatch = new ColorSwatch(colorBase,alternateShade,alternateOpacity,dark);
			assert(alternate.colorShade != colorShade || alternate.colorOpacity != colorOpacity, "parameters not configured to create a variant");
			return alternate;
		}
		
		public function toString():String{
			return colorSpecifier;
		}
		
		public static function fromSpecifier(specifier:String,darkMode:Boolean=false):ColorSwatch
		{
			var parts:Array = specifier.split("-");
			assert(parts.length == 2, "Invalid color specifier: " + specifier);
			var base:String = parts[0];
			var shadeAndOpacity:String = parts[1];
			var shadeParts:Array = shadeAndOpacity.split("/");
			var shade:Number = Number(shadeParts[0]);
			var opacity:Number = shadeParts.length > 1 ? Number(shadeParts[1]) : 100;
			return new ColorSwatch(base, shade, opacity, darkMode);
		}
		
		public static function isColorName(name:String):Boolean{
			return name in BASE_COLORS;
		}
		
		public static function getColorValue(name:String):Boolean{
			return BASE_COLORS[name];
		}
		
		public static function isExceptionValue(value:String):Boolean{
			return exceptions.indexOf(value) != -1;
		}
		public function getRGB():Array{
			return rgb;
		}
	}
}