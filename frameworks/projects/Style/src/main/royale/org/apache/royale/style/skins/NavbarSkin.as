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
package org.apache.royale.style.skins
{
	import org.apache.royale.style.StyleSkin;
	import org.apache.royale.style.Navbar;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.flexgrid.AlignItems;
	import org.apache.royale.style.stylebeads.spacing.Padding;
	import org.apache.royale.style.stylebeads.sizing.MinHeight;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.border.BorderRadius;

	public class NavbarSkin extends StyleSkin
	{
		public function NavbarSkin()
		{
			super();
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.Navbar
		 */
		override public function set strand(value:IStrand):void
		{
			var nav:Navbar = value as Navbar;
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var bgColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 200);

			var padding:Padding = new Padding();
			padding.left = computeSize(16, nav.unit);
			padding.right = computeSize(16, nav.unit);

			_styles = [
				new Display("flex"),
				new AlignItems("center"),
				new MinHeight(computeSize(56, nav.unit)),
				padding,
				new BackgroundColor(bgColor.colorSpecifier),
				new BorderRadius(computeSize(12, nav.unit))
			];

			super.strand = value;
		}
	}
}
