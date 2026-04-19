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
	import org.apache.royale.style.MenuTitle;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.stylebeads.spacing.Padding;
	import org.apache.royale.style.stylebeads.typography.FontSize;
	import org.apache.royale.style.stylebeads.typography.FontWeight;
	import org.apache.royale.style.stylebeads.typography.TextColor;
	import org.apache.royale.style.stylebeads.typography.TextTransform;
	import org.apache.royale.style.stylebeads.typography.LetterSpacing;

	public class MenuTitleSkin extends StyleSkin
	{
		public function MenuTitleSkin()
		{
			super();
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.MenuTitle
		 */
		override public function set strand(value:IStrand):void
		{
			var title:MenuTitle = value as MenuTitle;
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var mutedColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 500);

			var padding:Padding = new Padding();
			padding.block = computeSize(4, title.unit);
			padding.inline = computeSize(12, title.unit);

			_styles = [
				padding,
				new FontSize(computeSize(12, title.unit)),
				new FontWeight("bold"),
				new TextTransform("uppercase"),
				new LetterSpacing(computeSize(1, title.unit)),
				new TextColor(mutedColor.colorSpecifier)
			];

			super.strand = value;
		}
	}
}
