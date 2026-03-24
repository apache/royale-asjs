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

		/**
		 * Returns an RGB array on a white -> base -> black ramp.
		 * 0 is white, 50 is the input color, 100 is black.
		 */
		public static function getVariation(color:uint, grayValue:Number, darkMode:Boolean = false):Array
		{
			var r:Number = (color >> 16) & 0xFF;
			var g:Number = (color >> 8) & 0xFF;
			var b:Number = color & 0xFF;

			//convert to 0 - 1000 range
			var t:Number = pinValue(grayValue, 0, 100) * 10;
			
			//pass through lch color space for shading
			var lch:Array = rgb_ToOKLCH([r,g,b]);
			//shade it
			lch = lchShade(lch,factorForShadeTableInterpolated(t,darkMode));
			return oklch_ToRGB(lch);
			
			/*var outR:Number;
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

			return [Math.round(outR), Math.round(outG), Math.round(outB)];*/
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
		
		/**
		 * convert rgb to oklch format
		 * @param rgb Array of rgb values in 3 element array
		 * @return array of lch values
		 */
		public static function rgb_ToOKLCH(rgb:Array):Array {
			var r:uint = rgb[0];
			var g:uint = rgb[1];
			var b:uint = rgb[2];
			//Math.cbrt;
			const cube_root:Function = Math['cbrt'] as Function; //not yet in Royale js typedefs
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
			
			var l_:Number = cube_root(l);
			var m_2:Number = cube_root(m);
			var s_2:Number = cube_root(s);
			
			var L:Number = 0.2104542553 * l_ + 0.7936177850 * m_2 - 0.0040720468 * s_2;
			var a:Number = 1.9779984951 * l_ - 2.4285922050 * m_2 + 0.4505937099 * s_2;
			var b2:Number = 0.0259040371 * l_ + 0.7827717662 * m_2 - 0.8086757660 * s_2;
			
			var C:Number = Math.sqrt(a * a + b2 * b2);
			var H:Number = (Math.atan2(b2, a) * 180 / Math.PI + 360) % 360;
			
			return  [L, C, H];
		}
		
		/**
		 * convert from lch to rgb
		 * @param lch lch values in 3 element array
		 * @return rgb values in 3 element array
		 */
		public static function oklch_ToRGB(lch:Array):Array {
			
			// --- 1. OKLCH → OKLab ---
			const L:Number = lch[0];
			const C:Number = lch[1];
			const hRad:Number = lch[2] * Math.PI / 180.0;
			
			const a_:Number = C * Math.cos(hRad);
			const b_:Number = C * Math.sin(hRad);
			
			// --- 2. OKLab → LMS (non-linear) ---
			const l_:Number = L + 0.3963377774 * a_ + 0.2158037573 * b_;
			const m_:Number = L - 0.1055613458 * a_ - 0.0638541728 * b_;
			const s_:Number = L - 0.0894841775 * a_ - 1.2914855480 * b_;
			
			// cube them (inverse of cbrt)
			const l:Number = l_ * l_ * l_;
			const m:Number = m_ * m_ * m_;
			const s:Number = s_ * s_ * s_;
			
			// --- 3. LMS → linear RGB ---
			var rLin:Number =
					+ 4.0767416621 * l
					- 3.3077115913 * m
					+ 0.2309699292 * s;
			
			var gLin:Number =
					- 1.2684380046 * l
					+ 2.6097574011 * m
					- 0.3413193965 * s;
			
			var bLin:Number =
					- 0.0041960863 * l
					- 0.7034186147 * m
					+ 1.7076147010 * s;
			
			// --- 4. linear RGB → sRGB clamped ---
			var r:uint = uint(pinValue(linearToSrgb(rLin),0,1) * 255);
			var g:uint = uint(pinValue(linearToSrgb(gLin),0,1) * 255);
			var b:uint = uint(pinValue(linearToSrgb(bLin),0,1) * 255);
			
			return [r ,g ,b];
		}
		
		private static function srgbToLinear(x:Number):Number {
			return (x <= 0.04045) ? x / 12.92 : Math.pow((x + 0.055) / 1.055, 2.4);
		}
		
		private static function linearToSrgb(x:Number):Number {
			return (x <= 0.0031308)	? 12.92 * x	: 1.055 * Math.pow(x, 1.0 / 2.4) - 0.055;
		}
		
		/*private static function lerp(a:Number, b:Number, t:Number):Number {
			return a + (b - a) * t;
		}*/
		
		public static function lchShade(base:Array, factor:Number):Array
		{
			const baseL:Number = base[0];
			const baseC:Number = base[1];
			const baseH:Number = base[2];
			
			// Your table ranges roughly 0.45–1.60.
			// factor > 1  → lighter than base
			// factor < 1  → darker than base
			
			var newL:Number;
			var newC:Number;
			
			if (factor >= 1.0) {
				// LIGHTER SIDE (50–400)
				// Normalize factor so:
				//   factor = 1.0 → t = 0 (base)
				//   factor = 1.6 → t = 1 (lightest)
				var tLight:Number = (factor - 1.0) / (1.6 - 1.0);
				if (tLight < 0) tLight = 0;
				if (tLight > 1) tLight = 1;
				
				// Move L toward a very light target (~0.97)
				newL = baseL + (0.97 - baseL) * tLight;
				
				// Reduce chroma as we get lighter
				//  t = 0 → baseC
				//  t = 1 → ~30% of baseC
				newC = baseC * (1.0 - 0.7 * tLight);
			} else {
				// DARKER SIDE (600–900)
				// Normalize factor so:
				//   factor = 1.0 → t = 0 (base)
				//   factor = 0.45 → t = 1 (darkest)
				var tDark:Number = (1.0 - factor) / (1.0 - 0.45);
				if (tDark < 0) tDark = 0;
				if (tDark > 1) tDark = 1;
				
				// Move L toward a dark target (~0.12)
				newL = baseL + (0.12 - baseL) * tDark;
				
				// Slightly increase chroma as we get darker
				//  t = 0 → baseC
				//  t = 1 → ~120% of baseC
				newC = baseC * (1.0 + 0.2 * tDark);
			}
			
			return [
				pinValue(newL, 0, 1),
				pinValue(newC, 0, 0.4),
				baseH
			];
		}
		
		private static const shading_factors:Object = {
			50: 1.80,
			100: 1.60,
			200: 1.40,
			300: 1.20,
			400: 1.08,
			500: 1.00,
			600: 0.90,
			700: 0.75,
			800: 0.60,
			900: 0.45
		}
		
		private static var inverted_factors:Object;
				
		private static const SHADE_KEYS:Array = [];
		private static const INVERTED_SHADE_KEYS:Array = [];
		
		COMPILE::JS
		private static const lookups:Map = new Map();
		COMPILE::SWF
		private static const lookups:Object = {};
	
		private static function factorForShadeTableInterpolated(shade:uint, darkMode:Boolean):Number {
			assert(shade>=0 && shade<=1000, 'bad parameter')
			if (darkMode && !inverted_factors) {
				inverted_factors = invertTable(shading_factors);
				trace('inverted', inverted_factors);
			}
			const factors:Object = darkMode ? inverted_factors : shading_factors;
			const shadeKeys:Array = darkMode ? CSSColor.INVERTED_SHADE_KEYS : CSSColor.SHADE_KEYS;
			if (!shadeKeys.length) {
				//populate it first time
				COMPILE::JS{
					var keys:Array = Object.keys(factors).map(function(k:String):int { return uint(k); });
				}
				COMPILE::SWF{
					var keys:Array = [];
					for (var key:String in factors) keys.push(key);
					keys = keys.map(function(k:String):int { return uint(k); });
				}
				
				keys.sort(Array.NUMERIC);
				shadeKeys.push.apply(shadeKeys, keys);
			}
			
			// clamp to valid range
			if (shade <= 50) return factors[50];
			if (shade >= 900) return factors[900];
			
			// exact match
			if (factors[shade] != null)
				return factors[shade];

			var resultMap:Object;
			var result:Number;
			COMPILE::JS {
				resultMap = lookups.get(shade);
				if (!resultMap) {
					resultMap = { dark:NaN,light:NaN};
					lookups.set(shade, resultMap);
				}
			}
			COMPILE::SWF {
				resultMap = lookups[shade];
				if (!resultMap) {
					resultMap = { dark:NaN,light:NaN};
					lookups[shade] = resultMap;
				}
			}
			result = darkMode ? resultMap.dark : resultMap.light;
			if (isNaN(result)) {
				// find neighbors
				var lower:int = 50;
				var upper:int = 900;
				
				for (var i:int = 0; i < shadeKeys.length - 1; i++) {
					var a:int = shadeKeys[i];
					var b:int = shadeKeys[i+1];
					
					if (shade > a && shade < b) {
						lower = a;
						upper = b;
						break;
					}
				}
				
				var f1:Number = factors[lower];
				var f2:Number = factors[upper];
				
				var t:Number = (shade - lower) / (upper - lower);
				result = f1 + t * (f2 - f1);
				
				if (darkMode) {
					resultMap.dark = result;
				} else {
					resultMap.light = result;
				}
			}
			return result;
		}
		
		
		private static function invertTable(table:Object):Object {
			COMPILE::JS{
				const keys:Array = Object.keys(table).sort(Array.NUMERIC);
			}
			COMPILE::SWF{
				var keys:Array = [];
				for (var key:String in table) keys.push(key);
				keys = keys.sort(Array.NUMERIC);
			}
			
			const values:Array = keys.map(function(key:String):Number{return table[key]}).reverse();
			
			const inverted:Object = {};
			for (var i:int = 0; i < keys.length; i++) {
				inverted[keys[i]] = values[i];
			}
			return inverted;
		}
		
		
		/*public static function testRoundTrip():void {
			
			const tests:Array = [
				0x000000, 0xFFFFFF,
				0xFF0000, 0x00FF00, 0x0000FF,
				0xFFFF00, 0xFF00FF, 0x00FFFF,
				0x808080, 0xC0C0C0, 0x404040
			];
			
			// add random colors
			for (var i:int = 0; i < 20; i++) {
				tests.push(Math.random() * 0xFFFFFF);
			}
			
			for each (var rgb:uint in tests) {
				var r1:uint = (rgb >> 16) & 0xFF;
				var g1:uint = (rgb >> 8) & 0xFF;
				var b1:uint = rgb & 0xFF;
				var oklch:Array = rgbToOKLCH([r1,g1,b1]);
				var rgb2:Array = oklchToRGB(oklch);
				
				var r2:uint = rgb2[0];
				var g2:uint = rgb2[1];
				var b2:uint = rgb2[2];
				
				var rgbOut:uint = r2<<16 | g2<<8 | b2;
				
				var dr:int = r2 - r1;
				var dg:int = g2 - g1;
				var db:int = b2 - b1;
				
				trace(
						"RGB:", rgb.toString(16),
						"→", rgbOut.toString(16),
						"Δ:", dr, dg, db
				);
			}
		}*/
	}
}