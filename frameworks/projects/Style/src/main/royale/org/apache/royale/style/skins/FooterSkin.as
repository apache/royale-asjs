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
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.Footer;
	import org.apache.royale.style.StyleSkin;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.stylebeads.flexgrid.AlignItems;
	import org.apache.royale.style.stylebeads.flexgrid.FlexWrap;
	import org.apache.royale.style.stylebeads.flexgrid.Gap;
	import org.apache.royale.style.stylebeads.flexgrid.JustifyContent;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.spacing.Padding;
	import org.apache.royale.style.util.ThemeManager;

	public class FooterSkin extends StyleSkin
	{
		public function FooterSkin()
		{
			super();
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.Footer
		 */
		override public function set strand(value:IStrand):void
		{
			var footer:Footer = value as Footer;
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var bgColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 200);

			var padding:Padding = new Padding();
			padding.block = computeSize(16, footer.unit);
			padding.inline = computeSize(20, footer.unit);

			_styles = [
				new Display("flex"),
				new FlexWrap("wrap"),
				new AlignItems("center"),
				new JustifyContent("space-between"),
				new Gap(computeSize(12, footer.unit)),
				padding,
				new BorderRadius(computeSize(12, footer.unit)),
				new BackgroundColor(bgColor.colorSpecifier)
			];

			super.strand = value;
		}
	}
}
