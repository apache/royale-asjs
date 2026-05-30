// //////////////////////////////////////////////////////////////////////////////
// 
// Licensed to the Apache Software Foundation (ASF) under one or more
// contributor license agreements.  See the NOTICE file distributed with
// this work for additional information regarding copyright ownership.
// The ASF licenses this file to You under the Apache License, Version 2.0
// (the "License"); you may not use this file except in compliance with
// the License.  You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// 
// //////////////////////////////////////////////////////////////////////////////
package org.apache.royale.style.skins
{
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.StyleSkin;
	import org.apache.royale.style.Textarea;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.stylebeads.anim.Transition;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.border.BorderColor;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.stylebeads.border.BorderWidth;
	import org.apache.royale.style.stylebeads.border.Outline;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.sizing.HeightStyle;
	import org.apache.royale.style.stylebeads.sizing.MaxWidth;
	import org.apache.royale.style.stylebeads.sizing.WidthStyle;
	import org.apache.royale.style.stylebeads.spacing.Margin;
	import org.apache.royale.style.stylebeads.spacing.Padding;
	import org.apache.royale.style.stylebeads.states.FocusState;
	import org.apache.royale.style.stylebeads.states.FocusVisibleState;
	import org.apache.royale.style.stylebeads.states.attribute.AriaState;
	import org.apache.royale.style.stylebeads.typography.FontSize;
	import org.apache.royale.style.stylebeads.typography.TextColor;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.stylebeads.states.RequiredState;
	import org.apache.royale.style.stylebeads.states.pseudo.PlaceholderState;
	import org.apache.royale.style.IIcon;
	import org.apache.royale.style.Icon;
	import org.apache.royale.style.stylebeads.flexgrid.AlignItems;
	import org.apache.royale.style.stylebeads.flexgrid.JustifyContent;
	import org.apache.royale.style.stylebeads.svg.Stroke;
	import org.apache.royale.style.elements.Th;
	import org.apache.royale.style.const.Theme;
	import org.apache.royale.style.stylebeads.states.InvalidState;

	public class TextareaSkin extends StyleSkin
	{
		public function TextareaSkin()
		{
			super();
		}

		private function get host():Textarea
		{
			return _strand as Textarea;
		}

		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			if (_styles)
				return;
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var baseColor:ColorSwatch = (host.theme && host.theme != "default") ? colorSet.getSwatch(host.theme, 600) : colorSet.getSwatch(ThemeColorSet.NEUTRAL, 400);
			var focusBorder:ColorSwatch = baseColor;
			var focusRing:ColorSwatch = baseColor;
			var fontSize:String = computeSize(getFontSizePx(), host.unit);
			var focusOutline:Outline = new Outline();
			focusOutline.style = "solid";
			focusOutline.width = "2px";
			focusOutline.color = focusRing.colorSpecifier;
			focusOutline.offset = "4px";
			var invalidOutline:Outline = new Outline();
			invalidOutline.style = "solid";
			invalidOutline.width = "2px";
			invalidOutline.color = colorSet.getSwatch(ThemeColorSet.ERROR, 500).colorSpecifier;
			invalidOutline.offset = "4px";
			var invalidState:InvalidState = new InvalidState([
						new BorderColor(colorSet.getSwatch(ThemeColorSet.ERROR, 500)),
						new BorderWidth("1px"),
						invalidOutline
					]);
			var focusState:FocusState = new FocusState([
						new BorderColor(focusBorder),
						new BorderWidth("1px"),
						focusOutline
					]);
			var margins:Margin = new Margin();
			margins.top = computeSize(12, host.unit);
			margins.left = "auto";
			margins.right = "auto";
			var paddings:Padding = new Padding();
			paddings.left = computeSize(12, host.unit);
			paddings.right = computeSize(12, host.unit);
			paddings.top = computeSize(8, host.unit);
			paddings.bottom = computeSize(8, host.unit);
			_styles = [
					new BackgroundColor("transparent"),
					new BorderWidth("1px"),
					new BorderColor(baseColor),
					new BorderRadius(ThemeManager.instance.activeTheme.radiusMD),
					new MaxWidth(ThemeManager.instance.activeTheme.container2XL),
					new TextColor(colorSet.getSwatch(ThemeColorSet.NEUTRAL, 700)),
					new FontSize(fontSize),
					new WidthStyle("100"),
					new HeightStyle(computeSize(96, host.unit)),
					margins,
					paddings,
					new Transition("colors"),
				    focusState,
					invalidState
				];
			host.setStyles(_styles);
		}

		private function getFontSizePx():Number
		{
			switch (host.size)
			{
				case "xs":
					return 13;
				case "sm":
					return 14;
				case "md":
					return 16;
				case "lg":
					return 20;
				case "xl":
					return 24;
				default:
					return 16;
			}
		}
	}
}