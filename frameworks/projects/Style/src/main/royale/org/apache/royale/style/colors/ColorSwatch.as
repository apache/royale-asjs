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
			"slate": 0x62748E,
			"stone": 0x79716B,
			"taupe": 0x7C6D67,
			"teal": 0x00BBA7,
			"violet": 0x8E51FF,
			"yellow": 0xF0B100,
			"zinc": 0x71717B
		};

		/**
		 * Subclasses must specify colorBase before calling this constructor.
		 */
		public function ColorSwatch(swatch:String,shade:Number,opacity:Number = 100)
		{
			var base:Object = BASE_COLORS[swatch] || CSSLookup.getProperty(swatch);
			assert(base, "Invalid color swatch: " + swatch);
			
			var baseColor:uint = CSSUtils.toColor(base);
			var rgbComponents:Array= [(baseColor & 0xff0000)>>16,(baseColor & 0xff00)>>8,(baseColor & 0xff)];
			var lch:Array = rgbToOKLCH(rgbComponents[0],rgbComponents[1],rgbComponents[2]);
			
			// Convert from 50,100,200... to 5,10,20... for easier math.
			
			
			
		//	shade = Math.round(shade/10);
		//	var colorVals:Array = CSSColor.getVariation(CSSUtils.toColor(base),shade);
			
			var colorVals:Array = lchShade(lch,factorForShade(shade));
			colorSpace = 'oklch';

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

			CSSLookup.register (colorSpecifier,colorValue);
		}
		public var colorBase:String;
		public var colorShade:Number;
		public var colorOpacity:Number;
		public var colorValue:String;
		public var colorSpace:String = "rgb";
		public var colorSpecifier:String;

		
		/**
		 * create a ColorSwatch variant from this instance
		 * @param alternateShade - alternate shade. If you want to keep the same shade and adjust opacity, set this to NaN
		 * @param alternateOpacity - if not set it will inherit the original value from this instance
		 * @return a new ColorSwatch with different shade or opacity (or both)
		 */
		public function getVariant(alternateShade:Number, alternateOpacity:Number = NaN):ColorSwatch{
			if (isNaN(alternateShade)) alternateShade = colorShade;
			if (isNaN(alternateOpacity)) alternateOpacity = colorOpacity;
			var alternate:ColorSwatch = new ColorSwatch(colorBase,alternateShade,alternateOpacity);
			assert(alternate.colorShade != colorShade || alternate.colorOpacity != colorOpacity, "parameters not configured to create a variant");
			return alternate;
		}
		
		public function toString():String{
			return colorSpecifier;
		}
		
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
		
		public static function rgbToOKLCH(r:int, g:int, b:int):Array {
			// Normalize
			var R:Number = r / 255;
			var G:Number = g / 255;
			var B:Number = b / 255;
			
			// Convert to linear
			R = srgbToLinear(R);
			G = srgbToLinear(G);
			B = srgbToLinear(B);
			
			// Convert to OKLab
			var l:Number = 0.4122214708 * R + 0.5363325363 * G + 0.0514459929 * B;
			var m:Number = 0.2119034982 * R + 0.6806995451 * G + 0.1073969566 * B;
			var s:Number = 0.0883024619 * R + 0.2817188376 * G + 0.6299787005 * B;
			
			var l_:Number = Math['cbrt'](l);
			var m_2:Number = Math['cbrt'](m);
			var s_2:Number = Math['cbrt'](s);
			
			var L:Number = 0.2104542553 * l_ + 0.7936177850 * m_2 - 0.0040720468 * s_2;
			var a:Number = 1.9779984951 * l_ - 2.4285922050 * m_2 + 0.4505937099 * s_2;
			var b2:Number = 0.0259040371 * l_ + 0.7827717662 * m_2 - 0.8086757660 * s_2;
			
			var C:Number = Math.sqrt(a * a + b2 * b2);
			var H:Number = (Math.atan2(b2, a) * 180 / Math.PI + 360) % 360;
			
			return  [L, C, H];
		}
		private static function srgbToLinear(x:Number):Number {
			return (x <= 0.04045) ? x / 12.92 : Math.pow((x + 0.055) / 1.055, 2.4);
		}
		
		private static const factors:Object = {
			50: 1.60,
			100: 1.45,
			200: 1.30,
			300: 1.15,
			400: 1.05,
			500: 1.00,
			600: 0.90,
			700: 0.75,
			800: 0.60,
			900: 0.45
		}
		public static function lchShade(base:Array, factor:Number):Array {
			return [
					base[0] * factor,                 // adjust lightness
					base[1] * (0.5 + factor / 2),     // adjust chroma
					base[2]                           // keep hue constant
			];
		}
		private static const SHADE_KEYS:Array = [50,100,200,300,400,500,600,700,800,900];
		
		public static function factorForShade(shade:int):Number {
			
			// clamp to valid range
			if (shade <= 50) return factors[50];
			if (shade >= 900) return factors[900];
			
			// exact match
			if (factors[shade] != null)
				return factors[shade];
			
			// find neighbors
			var lower:int = 50;
			var upper:int = 900;
			
			for (var i:int = 0; i < SHADE_KEYS.length - 1; i++) {
				var a:int = SHADE_KEYS[i];
				var b:int = SHADE_KEYS[i+1];
				
				if (shade > a && shade < b) {
					lower = a;
					upper = b;
					break;
				}
			}
			
			var f1:Number = factors[lower];
			var f2:Number = factors[upper];
			
			var t:Number = (shade - lower) / (upper - lower);
			
			return f1 + t * (f2 - f1);
		}
		
	}
}