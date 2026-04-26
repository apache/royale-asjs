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
	import org.apache.royale.style.Tab;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.stylebeads.interact.Cursor;
	import org.apache.royale.style.stylebeads.interact.UserSelect;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.border.Border;
	import org.apache.royale.style.stylebeads.border.BorderWidth;
	import org.apache.royale.style.stylebeads.border.Outline;
	import org.apache.royale.style.stylebeads.spacing.Padding;
	import org.apache.royale.style.stylebeads.anim.Transition;
	import org.apache.royale.style.stylebeads.typography.FontSize;
	import org.apache.royale.style.stylebeads.typography.TextColor;
	import org.apache.royale.style.stylebeads.states.attribute.DataState;
	import org.apache.royale.style.stylebeads.states.FocusVisibleState;

	public class TabSkin extends StyleSkin implements ITabSkin
	{
		public function TabSkin()
		{
			super();
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.Tab
		 */
		private function get host():Tab
		{
			return _strand as Tab;
		}

		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			applyStyles();
		}

		private function applyStyles():void
		{
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var primaryColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.PRIMARY, 500);
			var disabledColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 300, 50);

			var size:Number = 16 * getMultiplier();
			var paddingH:String = computeSize(size * 0.75, host.unit);
			var paddingV:String = computeSize(size * 0.5, host.unit);

			var outline:Outline = new Outline();
			outline.unit = host.unit;
			outline.width = 0.5;
			outline.style = "solid";
			outline.color = primaryColor.getVariant(NaN, 40).colorSpecifier;
			outline.offset = 0.5;

			var padding:Padding = new Padding();
			padding.left = paddingH;
			padding.right = paddingH;
			padding.top = paddingV;
			padding.bottom = paddingV;

			var borderWidth:BorderWidth = new BorderWidth();
			borderWidth.bottom = 2;

			var defaultBorder:Border = new Border();
			defaultBorder.bottomColor = "transparent";
			defaultBorder.bottomStyle = "solid";

			var selectedBorder:Border = new Border();
			selectedBorder.bottomColor = primaryColor.colorSpecifier;

			_styles = [
				new BackgroundColor("transparent"),
				padding,
				borderWidth,
				defaultBorder,
				new Cursor("pointer"),
				new UserSelect("none"),
				new Transition(),
				new DataState("selected", [
					selectedBorder,
					new TextColor(primaryColor)
				]),
				new DataState("disabled", [
					new TextColor(disabledColor),
					new Cursor("default")
				]),
				new FocusVisibleState([outline])
			];
			host.setStyles(_styles);
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

		private var _labelStyles:Array;

		public function get labelStyles():Array
		{
			if(!_labelStyles)
				createLabelStyles();
			return _labelStyles;
		}

		private function createLabelStyles():void
		{
			var size:Number = 16 * getMultiplier();
			var fontSize:String = computeSize(size, host.unit);

			_labelStyles = [
				new FontSize(fontSize)
			];
		}
	}
}
