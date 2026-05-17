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
		
		private static const lchLookups:Object = {init:false};
		private static function getLCHLookups():Object{
			if (lchLookups.init === false) {
				delete lchLookups.init;
				for (var key:String in BASE_COLORS) {
					var col:uint = BASE_COLORS[key];
					lchLookups[key] = ColorUtils.rgb_ToOKLCH([(col>>16)&0xff,(col>>8)&0xff,col&0xff])
				}
			}
			return lchLookups;
		}
		
		public static function estimateFromRGB(rgb:Array, customOklchLookups:Object = null):ColorSwatch{
			var BASE_COLORS_OKLCH:Object = customOklchLookups || getLCHLookups();
			var bestName:String = null;
			var inputAsOKLCH:Array =  ColorUtils.rgb_ToOKLCH(rgb);
			var bestDist:Number = Number.MAX_VALUE;
			for (var name:String in BASE_COLORS_OKLCH) {
				var ref:Array = BASE_COLORS_OKLCH[name];
				var d:Number = ColorUtils.oklchDistance(inputAsOKLCH, ref);
				
				// Bias toward black/white if they are in the lookups
				if (name == "white" || name == "black") {
					d *= 0.01;
					// If the input is very extreme (L close to 0 or 1), force a very small distance
					if (name == "white" && inputAsOKLCH[0] > 0.99) d = 0;
					if (name == "black" && inputAsOKLCH[0] < 0.01) d = 0;
				}

				if (d < bestDist) {
					bestDist = d;
					bestName = name;
				}
			}
			var base:Array = BASE_COLORS_OKLCH[bestName];
			if (bestName == "white") return new ColorSwatch("white", 0);
			if (bestName == "black") return new ColorSwatch("black", 0);
			var ramp:Object = ColorUtils.getOklchRamp(base);
			var bestShade:uint = 500;
			bestDist = Number.MAX_VALUE;
			for (var shadeKey:String in ramp) {
				ref = ramp[shadeKey];
				d = ColorUtils.oklchDistance(inputAsOKLCH, ref);
				if (d < bestDist)
				{
					bestDist = d;
					bestShade = Number(shadeKey);
				}
			}
			return new ColorSwatch(bestName,bestShade);
		}
		
		
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
			if (swatch == "white") {
				rgb = [255,255,255];
			} else if (swatch == "black") {
				rgb = [0,0,0];
			} else {
				var base:Object = BASE_COLORS[swatch] || CSSLookup.getProperty(swatch);
				assert(base, "Invalid color swatch: " + swatch);
				var baseColor:uint = CSSUtils.toColor(base);
				rgb = ColorUtils.getVariation(baseColor,Math.round(shade/10),darkMode);
			}
			assert(shade>=0 && shade<=1000, "Invalid shade: " + shade);
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
         * @param applyDelta if true, the alternate values will be applied as deltas to existing values to create the variant
         * @return a new ColorSwatch with different shade or opacity (or both)
         */
		public function getVariant(alternateShade:Number, alternateOpacity:Number = NaN, applyDelta:Boolean = false):ColorSwatch{
			if (isNaN(alternateShade)) alternateShade = colorShade;
			else if (applyDelta) alternateShade = colorShade + alternateShade;
			if (isNaN(alternateOpacity)) alternateOpacity = colorOpacity;
			else if (applyDelta) alternateOpacity = colorOpacity + alternateOpacity;
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
		
		public static function getColorValue(name:String):uint{
			return BASE_COLORS[name];
		}
		
		public static function isExceptionValue(value:String):Boolean{
			return exceptions.indexOf(value) != -1;
		}
		public function getRGB():Array{
			return rgb;
		}
		/**
		 * Returns true if this color swatch is considered a "dark" color,
		 * meaning that it would require light text for good contrast.
		 * This is based on the base color, shade, not the opacity.
		 */
		public function isDark():Boolean
		{
			if (!rgb || rgb.length < 3)
			{
				return false;
			}

			var r:Number = Number(rgb[0]) / 255;
			var g:Number = Number(rgb[1]) / 255;
			var b:Number = Number(rgb[2]) / 255;

			var rLinear:Number = toLinearChannel(r);
			var gLinear:Number = toLinearChannel(g);
			var bLinear:Number = toLinearChannel(b);

			var luminance:Number = 0.2126 * rLinear + 0.7152 * gLinear + 0.0722 * bLinear;
			return luminance < 0.179;
		}

		private function toLinearChannel(channel:Number):Number
		{
			return (channel <= 0.04045) ? channel / 12.92 : Math.pow((channel + 0.055) / 1.055, 2.4);
		}
	}
}