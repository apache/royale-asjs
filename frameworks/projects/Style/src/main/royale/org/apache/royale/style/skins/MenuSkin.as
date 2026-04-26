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
	import org.apache.royale.style.Menu;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.flexgrid.FlexDirection;
	import org.apache.royale.style.stylebeads.flexgrid.Gap;
	import org.apache.royale.style.stylebeads.spacing.Padding;
	import org.apache.royale.style.stylebeads.spacing.Margin;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.border.Border;
	import org.apache.royale.style.stylebeads.border.BorderRadius;

	public class MenuSkin extends StyleSkin
	{
		public function MenuSkin()
		{
			super();
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.Menu
		 */
		override public function set strand(value:IStrand):void
		{
			var menu:Menu = value as Menu;
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;

			_styles = [
				new Display("flex"),
				new FlexDirection("column"),
				new Gap(computeSize(2, menu.unit))
			];

			if (menu.submenu)
			{
				var borderColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 300);

				var border:Border = new Border();
				border.leftColor = borderColor.colorSpecifier;
				border.style = "solid";
				border.width = computeSize(1, menu.unit);

				var margin:Margin = new Margin();
				margin.left = computeSize(16, menu.unit);
				margin.top = computeSize(2, menu.unit);

				_styles.push(border, margin);
			}
			else
			{
				var bgColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 200);

				var padding:Padding = new Padding();
				padding.block = computeSize(8, menu.unit);
				padding.inline = computeSize(8, menu.unit);

				_styles.push(
					padding,
					new BackgroundColor(bgColor.colorSpecifier),
					new BorderRadius(computeSize(12, menu.unit))
				);
			}

			super.strand = value;
		}
	}
}
