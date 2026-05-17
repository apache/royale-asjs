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
	import org.apache.royale.style.StyleSkin;
	import org.apache.royale.style.TextInput;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.stylebeads.spacing.Padding;
	import org.apache.royale.style.stylebeads.border.Outline;
	import org.apache.royale.style.stylebeads.typography.TextSize;
	import org.apache.royale.style.stylebeads.anim.TransitionProperty;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.stylebeads.sizing.HeightStyle;
	import org.apache.royale.style.stylebeads.sizing.WidthStyle;
	import org.apache.royale.style.stylebeads.border.BorderColor;
	import org.apache.royale.style.stylebeads.border.BorderWidth;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.typography.TextColor;
	import org.apache.royale.style.stylebeads.states.FocusState;
	import org.apache.royale.style.stylebeads.states.pseudo.PlaceholderState;
	import org.apache.royale.style.stylebeads.states.DisabledState;
	import org.apache.royale.style.stylebeads.interact.Cursor;
	import org.apache.royale.style.stylebeads.border.BorderStyle;
	import org.apache.royale.style.stylebeads.border.Border;
	
	public class TextInputSkin extends StyleSkin
	{
		public function TextInputSkin()
		{
			super();
		}
		/**
		 * @royaleignorecoercion org.apache.royale.style.TextInput
		 */
		private function get host():TextInput
		{
			return _strand as TextInput;
		}
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			// Manually set. Don't create the default ones.
			if(_styles)
				return;
			applyStyles();
		}
		private function getMultiplier():Number
		{
			switch(host.size)
			{
				case "sm":
					return 0.875;
				case "md":
					return 1;
				case "lg":
					return 1.125;
				case "xl":
					return 1.25;
				default:
					return 1;
			}
		}
		private function applyStyles():void
		{
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var size:String = host.size || "base";
			var haveTheme:Boolean = host.theme && host.theme != "default";
			var black:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 900);
			var baseColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 300);
			var borderColor:ColorSwatch = haveTheme ? colorSet.getSwatch(host.theme, 400) : baseColor;
			var focusBorderColor:ColorSwatch = haveTheme ? colorSet.getSwatch(host.theme, 400) : black;
			var disabledBgColor:ColorSwatch = haveTheme ? colorSet.getSwatch(host.theme, 100) : colorSet.getSwatch(ThemeColorSet.BASE, 100);
			var disabledColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.NEUTRAL, 300);
			
			var padding:Padding = new Padding();
			padding.inline = 4;

			var focusOutline:Outline = new Outline();
			focusOutline.width = 0.5;
			focusOutline.color = focusBorderColor.colorSpecifier;
			focusOutline.style = "solid";
			focusOutline.offset = 0.5;

			var borderSize:Number = 16 * getMultiplier();
			var borderWidth:String = computeSize(borderSize * 0.05, host.unit);

			var outline:Outline = new Outline();
			outline.width = 0.5;
			outline.color = "transparent";
			outline.style = "solid";
			outline.offset = 0.5;

			var height:int = getAppliedSize(size);

			_styles = [
				new TextSize(size),
				new TransitionProperty("default"),
				new BorderRadius("lg"),
				new HeightStyle(height),
				new WidthStyle("full"),
				new BorderColor(borderColor),
				new BorderWidth(borderWidth, host.unit),
				new BackgroundColor("white"),
				new TextColor(black),
				padding,
				outline,
				new FocusState([
					focusOutline,
					new BorderColor(focusBorderColor)
				]),
				new PlaceholderState([
					new TextColor(baseColor)
				]),
				new DisabledState([
					new Cursor("not-allowed"),
					new BackgroundColor(disabledBgColor),
					new TextColor(disabledColor),
					new BorderStyle("none"),
					new Border("transparent")
				])
			];
			host.setStyles(_styles);
		}

		private function getAppliedSize(size:String):Number
		{
			switch(size)
			{
				case "xs":
					return 6;
				case "sm":
					return 8;
				case "lg":
					return 12;
				case "xl":
					return 14;
				case "md":
				default:
					return 10;
			}
		}

	}
}