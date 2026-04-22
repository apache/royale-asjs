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
	import org.apache.royale.style.colors.ColorUtils;
	import org.apache.royale.test.asserts.*;
	
	public class ColorUtilsContrastTest
	{
		[Before] public function setUp():void {}
		[After] public function tearDown():void {}
		[BeforeClass] public static function setUpBeforeClass():void {}
		[AfterClass] public static function tearDownAfterClass():void {}
		
		private function contrast(rgb1:Array, rgb2:Array):Number
		{
			return ColorUtils.contrast(rgb1, rgb2);
		}
		
		private function toRGB(lch:Array):Array
		{
			return ColorUtils.oklch_ToRGB(lch);
		}
		
		private function toLCH(rgb:Array):Array
		{
			return ColorUtils.rgb_ToOKLCH(rgb);
		}
		
		// -------------------------------------------------------------
		// 1. Very Dark Background (navy)
		// -------------------------------------------------------------
		[Test]
		public function testVeryDarkBackground():void
		{
			var bg:Array = [0.08, 0.12, 260]; // navy blue
			var wantLight:Boolean = true;
			
			var fg:Array = ColorUtils.generateContrastLCH(bg, wantLight);
			
			assertTrue(fg[0] > bg[0], "Foreground should be lighter");
			
			if (fg[1] > 0.02)
			{
				var dh:Number = Math.abs(fg[2] - bg[2]);
				dh = Math.min(dh, 360 - dh);
				assertTrue(dh < 5.0, "Hue should be preserved");
			}
			
			assertTrue(contrast(toRGB(fg), toRGB(bg)) >= 4.5);
		}
		
		// -------------------------------------------------------------
		// 2. Very Light Background (pastel warm green)
		// -------------------------------------------------------------
		[Test]
		public function testVeryLightBackground():void
		{
			var bg:Array = [0.96, 0.03, 100];
			var wantLight:Boolean = false;
			
			var fg:Array = ColorUtils.generateContrastLCH(bg, wantLight);
			
			assertTrue(fg[0] < bg[0], "Foreground should be darker");
			
			if (fg[1] > 0.02)
			{
				var dh:Number = Math.abs(fg[2] - bg[2]);
				dh = Math.min(dh, 360 - dh);
				assertTrue(dh < 5.0);
			}
			
			assertTrue(contrast(toRGB(fg), toRGB(bg)) >= 4.5);
		}
		
		// -------------------------------------------------------------
		// 3. Mid‑tone Saturated Blue (blue‑500‑like)
		// -------------------------------------------------------------
		[Test]
		public function testMidToneBlue():void
		{
			var bg:Array = [0.55, 0.20, 250];
			var wantLight:Boolean = false;
			
			var fg:Array = ColorUtils.generateContrastLCH(bg, wantLight);
			
			assertTrue(fg[0] < bg[0], "Foreground should be darker");
			
			if (fg[1] > 0.02)
			{
				var dh:Number = Math.abs(fg[2] - bg[2]);
				dh = Math.min(dh, 360 - dh);
				assertTrue(dh < 5.0);
			}
			// Soft sanity check only – not a hard 4.5 requirement
			assertTrue(contrast(toRGB(fg), toRGB(bg)) >= 3.0, "Contrast should be reasonably high");
		}
		
		//rgb version api
		[Test]
		public function testChooseContrastRGB_MidToneBlue():void
		{
			var bgLch:Array = [0.55, 0.20, 250];
			var bgRgb:Array = toRGB(bgLch);
			
			var fgRgb:Array = ColorUtils.chooseContrastRGB(bgRgb);
			
			assertTrue(contrast(fgRgb, bgRgb) >= 4.5, "UI contrast must be >= 4.5");
		}
		
		[Test]
		public function testMidToneBlue2():void
		{
			// There is no light foreground that can reach 4.5:1 on this bg.
			var bg:Array = [0.663, 0.266, 255.3];
			var wantLight:Boolean = true;
			
			var fg:Array = ColorUtils.generateContrastLCH(bg, wantLight);
			
			// Foreground must be lighter
			assertTrue(fg[0] > bg[0], "Foreground should be lighter");
			
			// If chroma is significant, hue must be preserved
			if (fg[1] > 0.02)
			{
				var dh:Number = Math.abs(fg[2] - bg[2]);
				dh = Math.min(dh, 360 - dh);
				assertTrue(dh < 5.0, "Hue should be preserved");
			}
			
			// We expect the solver to return the lightest possible (white),
			// even though contrast will be < 4.5.
			var cr:Number = ColorUtils.contrast(
					ColorUtils.oklch_ToRGB(fg),
					ColorUtils.oklch_ToRGB(bg)
			);
			assertTrue(cr < 4.5);
			assertEquals(1, fg[0]);   // L = 1
			assertEquals(0, fg[1]);   // C = 0
			
		}
		
		// -------------------------------------------------------------
		// 4. Mid‑tone Neutral Gray
		// -------------------------------------------------------------
		[Test]
		public function testNeutralGray():void
		{
			var bg:Array = [0.55, 0.005, 0]; // mid‑tone neutral gray
			var wantLight:Boolean = false;
			
			var fg:Array = ColorUtils.generateContrastLCH(bg, wantLight);
			
			assertTrue(fg[0] < bg[0], "Foreground should be darker");
			assertTrue(fg[1] <= bg[1] + 0.03, "Chroma should remain low");
			// Soft sanity check only
			assertTrue(contrast(toRGB(fg), toRGB(bg)) >= 3.0, "Contrast should be reasonably high");
		}
		
		//rgb version api
		[Test]
		public function testChooseContrastRGB_NeutralGray():void
		{
			var bgLch:Array = [0.55, 0.005, 0]; // mid‑tone neutral gray
			var bgRgb:Array = toRGB(bgLch);
			
			var fgRgb:Array = ColorUtils.chooseContrastRGB(bgRgb);
			
			assertTrue(contrast(fgRgb, bgRgb) >= 4.5, "UI contrast must be >= 4.5");
		}
		
		// -------------------------------------------------------------
		// 5. Highly Saturated Red
		// -------------------------------------------------------------
		[Test]
		public function testSaturatedRed():void
		{
			var bg:Array = [0.60, 0.28, 25];
			var wantLight:Boolean = false;
			
			var fg:Array = ColorUtils.generateContrastLCH(bg, wantLight);
			
			assertTrue(fg[0] < bg[0], "Foreground should be darker");
			assertTrue(fg[1] < bg[1], "Chroma should be reduced");
			
			assertTrue(contrast(toRGB(fg), toRGB(bg)) >= 4.5);
		}
		
		// -------------------------------------------------------------
		// 6. Low‑Chroma Pastel Green
		// -------------------------------------------------------------
		[Test]
		public function testPastelGreen():void
		{
			var bg:Array = [0.88, 0.04, 130];
			var wantLight:Boolean = false;
			
			var fg:Array = ColorUtils.generateContrastLCH(bg, wantLight);
			
			assertTrue(fg[0] < bg[0], "Foreground should be darker");
			assertTrue(fg[1] <= 0.05, "Chroma should remain low");
			
			assertTrue(contrast(toRGB(fg), toRGB(bg)) >= 4.5);
		}
		
		// -------------------------------------------------------------
		// 7. Black Background
		// -------------------------------------------------------------
		[Test]
		public function testBlackBackground():void
		{
			var bg:Array = [0.00, 0.00, 0];
			var wantLight:Boolean = true;
			
			var fg:Array = ColorUtils.generateContrastLCH(bg, wantLight);
			
			assertTrue(fg[0] > 0.50, "Foreground should be lighter");
			assertTrue(fg[1] <= 0.02, "Chroma should remain near zero");
			
			assertTrue(contrast(toRGB(fg), toRGB(bg)) >= 4.5);
		}
		
		// -------------------------------------------------------------
		// 8. White Background
		// -------------------------------------------------------------
		[Test]
		public function testWhiteBackground():void
		{
			var bg:Array = [0.97, 0.00, 0]; // corrected white
			var wantLight:Boolean = false;
			
			var fg:Array = ColorUtils.generateContrastLCH(bg, wantLight);
			
			assertTrue(fg[0] < bg[0], "Foreground should be darker");
			assertTrue(fg[1] <= 0.02, "Chroma should remain near zero");
			
			assertTrue(contrast(toRGB(fg), toRGB(bg)) >= 4.5);
		}
		
		// -------------------------------------------------------------
		// 9. Hue Preservation Across Multiple Hues
		// -------------------------------------------------------------
		[Test]
		public function testHuePreservation():void
		{
			var hues:Array = [0, 30, 60, 120, 180, 240, 300];
			
			for each (var h:Number in hues)
			{
				var bg:Array = [0.50, 0.12, h]; // gamut‑safe chroma
				var wantLight:Boolean = false;
				
				var fg:Array = ColorUtils.generateContrastLCH(bg, wantLight);
				
				if (fg[1] > 0.02)
				{
					var dh:Number = Math.abs(fg[2] - h);
					dh = Math.min(dh, 360 - dh);
					assertTrue(dh < 5.0, "Hue should be preserved for h=" + h);
				}
			}
		}
		
		// -------------------------------------------------------------
		// 10. Round‑Trip OKLCH Validity
		// -------------------------------------------------------------
		[Test]
		public function testRoundTripStability():void
		{
			var bg:Array = [0.40, 0.15, 200]; // gamut‑safe chroma
			var wantLight:Boolean = true;
			
			var fg:Array = ColorUtils.generateContrastLCH(bg, wantLight);
			var rt:Array = toLCH(toRGB(fg));
			
			assertTrue(Math.abs(rt[0] - fg[0]) < 0.02);
		}
	}
}
