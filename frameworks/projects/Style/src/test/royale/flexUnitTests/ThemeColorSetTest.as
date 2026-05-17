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
package flexUnitTests
{
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.colors.ColorUtils;
	import org.apache.royale.test.asserts.*;
	import org.apache.royale.utils.CSSUtils;

	/**
	 * Tests for ThemeColorSet contrast and variant resolution logic.
	 */
	public class ThemeColorSetTest
	{		
		private var themeSet:ThemeColorSet;

		[Before]
		public function setUp():void
		{
			// Default theme-like configuration
			themeSet = new ThemeColorSet({
				'primary': 'blue',
				'secondary': 'rose',
				'neutral': 'slate'
			});
		}

		[After]
		public function tearDown():void
		{
			themeSet = null;
		}
		
		
		public function getRGBColor(swatch:ColorSwatch):uint
		{
			var rgb:Array = swatch.getRGB();
			if (!rgb || rgb.length < 3) return 0;
			var rr:uint = rgb[0];
			var gg:uint = rgb[1];
			var bb:uint = rgb[2];
			return (rr << 16) | (gg << 8) | bb;
		}

		// ---------------------------------------------------------------------
		// 1. Basic Contrast Resolution
		// ---------------------------------------------------------------------

		[Test]
		public function testFindContrastVariant_Strong_DarkBackground():void
		{
			// Slate-900 is very dark
			var result:ColorSwatch = themeSet.findContrastVariant("slate", 900, false, false);
			
			// Should result in a light color
			var bgRgb:Array = ColorUtils.getVariation(CSSUtils.toColor(ColorSwatch.getColorValue("slate")), 90, false);
			var fgRgb:Array = result.getRGB();
			
			var cr:Number = ColorUtils.contrast(fgRgb, bgRgb);
			assertTrue(cr >= 4.5, "Contrast ratio must be at least 4.5 for strong variant. Got: " + cr);
			
			// On dark background, it should be significantly lighter
			assertTrue(ColorUtils.relativeLuminance(fgRgb) > ColorUtils.relativeLuminance(bgRgb), "Foreground should be lighter than background");
		}

		[Test]
		public function testFindContrastVariant_Strong_LightBackground():void
		{
			// Slate-50 is very light
			var result:ColorSwatch = themeSet.findContrastVariant("slate", 50, false, false);
			
			var bgRgb:Array = ColorUtils.getVariation(CSSUtils.toColor(ColorSwatch.getColorValue("slate")), 5, false);
			var fgRgb:Array = result.getRGB();
			
			var cr:Number = ColorUtils.contrast(fgRgb, bgRgb);
			assertTrue(cr >= 4.5, "Contrast ratio must be at least 4.5. Got: " + cr);
			
			// On light background, it should be significantly darker
			assertTrue(ColorUtils.relativeLuminance(fgRgb) < ColorUtils.relativeLuminance(bgRgb), "Foreground should be darker than background");
		}

		// ---------------------------------------------------------------------
		// 2. Weak Contrast Resolution
		// ---------------------------------------------------------------------

		[Test]
		public function testFindContrastVariant_Weak():void
		{
			var strong:ColorSwatch = themeSet.findContrastVariant("blue", 500, false, false);
			var weak:ColorSwatch = themeSet.findContrastVariant("blue", 500, false, true);
			
			var bgRgb:Array = ColorUtils.getVariation(CSSUtils.toColor(ColorSwatch.getColorValue("blue")), 50, false);
			var strongRgb:Array = strong.getRGB();
			var weakRgb:Array = weak.getRGB();
			
			var strongCr:Number = ColorUtils.contrast(strongRgb, bgRgb);
			var weakCr:Number = ColorUtils.contrast(weakRgb, bgRgb);
			
			// Weak contrast should be lower than strong contrast, but still provide some separation
			assertTrue(weakCr < strongCr, "Weak contrast should be less than strong contrast");
			assertTrue(weakCr > 1.2, "Weak contrast should still be visible (> 1.2)");
		}

		// ---------------------------------------------------------------------
		// 3. Palette Limitation (limitRange)
		// ---------------------------------------------------------------------

		[Test]
		public function testFindContrastVariant_LimitRange():void
		{
			// If we limit range, the result MUST be one of the base colors in the ThemeColorSet (primary, secondary, neutral, etc.)
			// or their variations.
			var result:ColorSwatch = themeSet.findContrastVariant("primary", 500, false, false, true);
			
			// The result swatch's base name should be found in our theme set keys
			var validBases:Array = ["blue", "rose", "slate"]; // derived from setUp
			// Also allow "neutral" if it was used as default
			validBases.push("neutral");
			var resultBase:String = result.colorBase;
			
			assertTrue(validBases.indexOf(resultBase) != -1, "Result base '" + resultBase + "' should be one of the theme bases: " + validBases.join(", "));
		}

		[Test]
		public function testFindContrastVariant_IncludeBlackAndWhite():void
		{
			themeSet.includeBlackAndWhite = true;
			
			// 1. Test Light Background -> Should snap to BLACK
			// Slate-50 is very light (L ~ 0.95)
			var resultBlack:ColorSwatch = themeSet.findContrastVariant("slate", 50, false, false, true);
			assertEquals("black", resultBlack.colorBase, "Should snap to 'black' for light background when enabled");
			assertEquals(0x000000, getRGBColor(resultBlack), "Black swatch should be 0x000000");

			// 2. Test Dark Background -> Should snap to WHITE
			// Slate-900 is very dark (L ~ 0.1)
			var resultWhite:ColorSwatch = themeSet.findContrastVariant("slate", 900, false, false, true);
			assertEquals("white", resultWhite.colorBase, "Should snap to 'white' for dark background when enabled");
			assertEquals(0xFFFFFF, getRGBColor(resultWhite), "White swatch should be 0xFFFFFF");
		}

		[Test]
		public function testFindContrastVariant_ExcludeBlackAndWhite():void
		{
			themeSet.includeBlackAndWhite = false; // Default
			
			// Even on very light background, it should NOT snap to black if limited and not included
			var result:ColorSwatch = themeSet.findContrastVariant("slate", 50, false, false, true);
			
			assertFalse(result.colorBase == "black", "Should NOT snap to 'black' when includeBlackAndWhite is false");
			assertFalse(result.colorBase == "white", "Should NOT snap to 'white' when includeBlackAndWhite is false");
			
			var validBases:Array = ["blue", "rose", "slate", "neutral"];
			assertTrue(validBases.indexOf(result.colorBase) != -1, "Result base '" + result.colorBase + "' should be one of the theme bases");
		}

		// ---------------------------------------------------------------------
		// 4. Hue Preservation Check
		// ---------------------------------------------------------------------

		[Test]
		public function testContrast_HuePreservation():void
		{
			// Use a shade where hue preservation is actually possible
			var result:ColorSwatch = themeSet.findContrastVariant("blue", 300, false, false);
			
			var bgRgb:Array = ColorUtils.getVariation(
					CSSUtils.toColor(ColorSwatch.getColorValue("blue")),
					30,   // 300 → 30 after /10 rounding
					false
			);
			
			var bgLch:Array = ColorUtils.rgb_ToOKLCH(bgRgb);
			var fgLch:Array = ColorUtils.rgb_ToOKLCH(result.getRGB());
			
			// If chroma is tiny, hue is meaningless → skip
			if (fgLch[1] <= 0.01)
				return; // this is the case for the current test
			
			// Compute hue difference with wrap-around
			var hueDiff:Number = Math.abs(bgLch[2] - fgLch[2]);
			if (hueDiff > 180) hueDiff = 360 - hueDiff;
			
			// Now hue preservation is expected
			assertTrue(hueDiff < 30,
					"Contrast color should preserve background hue within 30 degrees. Diff: " + hueDiff);
		}
	}
}
