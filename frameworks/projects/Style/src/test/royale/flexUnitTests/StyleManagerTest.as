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

	import org.apache.royale.test.asserts.*;
	import org.apache.royale.style.stylebeads.ILeafStyleBead;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.states.media.ContainerBreakpoint;
	import org.apache.royale.style.stylebeads.states.media.MediaBetween;
	import org.apache.royale.style.stylebeads.states.media.MediaBreakpoint;
	import org.apache.royale.style.util.StyleManager;
	import org.apache.royale.style.util.StyleTheme;
	import org.apache.royale.style.util.ThemeManager;

	public class StyleManagerTest
	{
		[Before]
		public function setUp():void
		{
		}

		[After]
		public function tearDown():void
		{
		}

		[BeforeClass]
		public static function setUpBeforeClass():void
		{
			COMPILE::JS
			{
				ThemeManager.instance.registerTheme(new StyleTheme());
			}
		}

		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}

		[Test]
		public function testInsert():void
		{
			COMPILE::JS
			{
				assertFalse(StyleManager.hasStyle(".foo"));
				StyleManager.addStyle(".foo", ".foo", "display:flex;");
				assertTrue(StyleManager.hasStyle(".foo"));
			}
		}

		[Test]
		public function testMediaBreakpointUsesThemeBreakpoint():void
		{
			COMPILE::JS
			{
				var display:Display = new Display("flex");
				var media:MediaBreakpoint = new MediaBreakpoint("md", [display]);
				var leaves:Array = media.getLeaves();
				(leaves[0] as ILeafStyleBead).getSelector();

				var rule:CSSRule = StyleManager.getQuery("media-min-width-md");
				assertNotNull(rule);
				assertTrue(rule.cssText.indexOf("@media (min-width: 48rem)") != -1);
				assertTrue(rule.cssText.indexOf(".flex") != -1);
				assertTrue(rule.cssText.indexOf("display: flex") != -1 || rule.cssText.indexOf("display:flex") != -1);
			}
		}

		[Test]
		public function testMediaBetweenUsesThemeBreakpoints():void
		{
			COMPILE::JS
			{
				var display:Display = new Display("grid");
				var media:MediaBetween = new MediaBetween("md", "xl", [display]);
				var leaves:Array = media.getLeaves();
				(leaves[0] as ILeafStyleBead).getSelector();

				var rule:CSSRule = StyleManager.getQuery("media-between-min-md-max-xl");
				assertNotNull(rule);
				assertTrue(rule.cssText.indexOf("@media (min-width: 48rem) and (width < 80rem)") != -1);
				assertTrue(rule.cssText.indexOf(".grid") != -1);
				assertTrue(rule.cssText.indexOf("display: grid") != -1 || rule.cssText.indexOf("display:grid") != -1);
			}
		}

		[Test]
		public function testContainerBreakpointUsesThemeBreakpoint():void
		{
			COMPILE::JS
			{
				if(canInsertContainerRule())
				{
					var display:Display = new Display("block");
					var container:ContainerBreakpoint = new ContainerBreakpoint("lg", [display]);
					var leaves:Array = container.getLeaves();
					(leaves[0] as ILeafStyleBead).getSelector();

					var rule:CSSRule = StyleManager.getQuery("container-min-width-lg");
					assertNotNull(rule);
					assertTrue(rule.cssText.indexOf("@container (width >= 64rem)") != -1);
					assertTrue(rule.cssText.indexOf(".block") != -1);
					assertTrue(rule.cssText.indexOf("display: block") != -1 || rule.cssText.indexOf("display:block") != -1);
				}
				else
				{
					var helper:ContainerBreakpointTestHelper = new ContainerBreakpointTestHelper("lg");

					assertEquals("container-min-width-lg", helper.styleType);
					assertEquals("@container (width >= 64rem) { }", helper.queryRule);
				}
			}
		}

		COMPILE::JS
		private function canInsertContainerRule():Boolean
		{
			var styleElement:HTMLStyleElement = document.createElement('style') as HTMLStyleElement;
			document.head.appendChild(styleElement);
			var sheet:CSSStyleSheet = styleElement.sheet as CSSStyleSheet;
			var supported:Boolean = true;
			try
			{
				sheet.insertRule("@container (width >= 1rem) { }", 0);
			}
			catch(error:Error)
			{
				supported = false;
			}
			document.head.removeChild(styleElement);
			return supported;
		}

	}

}
