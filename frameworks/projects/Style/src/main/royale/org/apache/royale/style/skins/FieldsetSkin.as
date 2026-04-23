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
	import org.apache.royale.style.Fieldset;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.const.Theme;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.flexgrid.Gap;
	import org.apache.royale.style.stylebeads.flexgrid.AlignItems;
	import org.apache.royale.style.stylebeads.flexgrid.JustifyContent;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.border.Border;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.stylebeads.sizing.WidthStyle;
	import org.apache.royale.style.stylebeads.spacing.Padding;
	import org.apache.royale.style.stylebeads.spacing.Margin;
	import org.apache.royale.style.stylebeads.typography.TextSize;
	import org.apache.royale.style.stylebeads.typography.FontWeight;
	import org.apache.royale.style.stylebeads.typography.TextColor;
	import org.apache.royale.style.stylebeads.states.attribute.DataState;
	import org.apache.royale.style.stylebeads.sizing.HeightStyle;

	public class FieldsetSkin extends StyleSkin
	{
		public function FieldsetSkin()
		{
			super();
		}

		private function get host():Fieldset
		{
			return _strand as Fieldset;
		}

		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			applyStyles();
		}

		private function applyStyles():void
		{
			if(!_styles)
			{
				var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
				var lightBorderColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 200);
				var lightBgColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 50);
				var darkBorderColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 700);
				var darkBgColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 800);
				var lightBorder:Border = new Border();
				lightBorder.color = lightBorderColor.colorSpecifier;
				lightBorder.width = "1px";
				var darkBorder:Border = new Border();
				darkBorder.color = darkBorderColor.colorSpecifier;
				darkBorder.width = "1px";
				var padding:Padding = new Padding();
				padding.padding = 4;
				padding.block = 1;

				_styles = [
					new Display("grid"),
					new WidthStyle(80),
					new HeightStyle(40),
					new Gap(1.5),
					new BorderRadius("md"),
					lightBorder,
					new BackgroundColor(lightBgColor.colorSpecifier),
					padding
				];
				host.setStyles(_styles);
			}
		}
		private var _legendStyles:Array;

		public function get legendStyles():Array
		{
			if(!_legendStyles)
				createLegendStyles();
			return _legendStyles;
		}

		private function createLegendStyles():void
		{
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var isDark:Boolean = ThemeManager.instance.current == Theme.DARK;
			var textColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, isDark ? 100 : 900);
			var margin:Margin = new Margin();
			margin.bottom = -1;
			var padding:Padding = new Padding();
			padding.block = 2;
			_legendStyles = [
				new Display("flex"),
				new AlignItems("center"),
				new JustifyContent("space-between"),
				new Gap(2),
				padding,
				margin,
				new TextSize("sm"),
				new FontWeight("semibold"),
				new TextColor(textColor.colorSpecifier)
			];
		}

		public function set legendStyles(value:Array):void
		{
			_legendStyles = value;
		}
	}
}
