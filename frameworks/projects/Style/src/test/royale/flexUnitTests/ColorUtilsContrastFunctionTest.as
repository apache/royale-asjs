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
	
	public class ColorUtilsContrastFunctionTest
	{
		[Before] public function setUp():void {}
		[After] public function tearDown():void {}
		[BeforeClass] public static function setUpBeforeClass():void {}
		[AfterClass] public static function tearDownAfterClass():void {}
		
		
		
		// -------------------------------------------------------------
		// 1. Relative luminance correctness
		// -------------------------------------------------------------
		[Test]
		public function testRelativeLuminance_PureColors():void
		{
			// Expected WCAG luminances
			// White: 1.0
			// Black: 0.0
			// Red:   0.2126
			// Green: 0.7152
			// Blue:  0.0722
			
			assertCloseTo(ColorUtils.relativeLuminance([255,255,255]), 1.0, 0.0001, "White luminance");
			assertCloseTo(ColorUtils.relativeLuminance([0,0,0]),       0.0, 0.0001, "Black luminance");
			
			assertCloseTo(ColorUtils.relativeLuminance([255,0,0]),   0.2126, 0.0001, "Red luminance");
			assertCloseTo(ColorUtils.relativeLuminance([0,255,0]),   0.7152, 0.0001, "Green luminance");
			assertCloseTo(ColorUtils.relativeLuminance([0,0,255]),   0.0722, 0.0001, "Blue luminance");
		}
		
		// -------------------------------------------------------------
		// 2. Known WCAG contrast ratios
		// -------------------------------------------------------------
		[Test]
		public function testContrast_KnownPairs():void
		{
			// White vs Black = 21.0
			assertCloseTo(
					ColorUtils.contrast([255,255,255], [0,0,0]),
					21.0, 0.001,
					"White/Black contrast"
			);
			
			// White vs mid-gray (#777777)
			// Expected ≈ 4.48
			assertCloseTo(
					ColorUtils.contrast([255,255,255], [119,119,119]),
					4.49, 0.05,
					"White vs #777777"
			);
			
			// Black vs mid-gray (#777777)
			// Expected ≈ 5.32
			assertCloseTo(
					ColorUtils.contrast([0,0,0], [119,119,119]),
					4.69, 0.05,
					"Black vs #777777"
			);
		}
		
		// -------------------------------------------------------------
		// 3. Symmetry: contrast(a,b) == contrast(b,a)
		// -------------------------------------------------------------
		[Test]
		public function testContrast_Symmetry():void
		{
			var a:Array = [200, 50, 100];
			var b:Array = [20, 180, 220];
			
			var ab:Number = ColorUtils.contrast(a, b);
			var ba:Number = ColorUtils.contrast(b, a);
			
			assertCloseTo(ab, ba, 0.000001, "Contrast must be symmetric");
		}
		
		// -------------------------------------------------------------
		// 4. Monotonicity: lighter colors produce higher contrast
		// -------------------------------------------------------------
		[Test]
		public function testContrast_Monotonicity():void
		{
			var black:Array = [0,0,0];
			
			var c1:Number = ColorUtils.contrast([50,50,50], black);
			var c2:Number = ColorUtils.contrast([120,120,120], black);
			var c3:Number = ColorUtils.contrast([200,200,200], black);
			
			assertTrue(c1 < c2, "Contrast should increase with luminance");
			assertTrue(c2 < c3, "Contrast should increase with luminance");
		}
		
		// -------------------------------------------------------------
		// 5. Edge cases: identical colors → contrast = 1.0
		// -------------------------------------------------------------
		[Test]
		public function testContrast_IdenticalColors():void
		{
			assertCloseTo(
					ColorUtils.contrast([100,100,100], [100,100,100]),
					1.0, 0.0001,
					"Identical colors must have contrast 1.0"
			);
		}
	}
}
