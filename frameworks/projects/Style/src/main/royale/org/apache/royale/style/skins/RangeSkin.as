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
	import org.apache.royale.style.Range;
	import org.apache.royale.style.StyleSkin;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.border.BorderColor;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.stylebeads.border.BorderWidth;
	import org.apache.royale.style.stylebeads.effects.BoxShadow;
	import org.apache.royale.style.stylebeads.effects.OpacityStyle;
	import org.apache.royale.style.stylebeads.flexgrid.AlignItems;
	import org.apache.royale.style.stylebeads.flexgrid.FlexShrink;
	import org.apache.royale.style.stylebeads.interact.Cursor;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.layout.Inset;
	import org.apache.royale.style.stylebeads.layout.Position;
	import org.apache.royale.style.stylebeads.layout.ZIndex;
	import org.apache.royale.style.stylebeads.sizing.HeightStyle;
	import org.apache.royale.style.stylebeads.sizing.MinWidth;
	import org.apache.royale.style.stylebeads.sizing.WidthStyle;
	import org.apache.royale.style.stylebeads.spacing.Margin;
	import org.apache.royale.style.stylebeads.states.GroupPseudo;
	import org.apache.royale.style.stylebeads.states.attribute.DataState;
	import org.apache.royale.style.util.ThemeManager;

	public class RangeSkin extends StyleSkin implements IRangeSkin
	{
		public function RangeSkin()
		{
			super();
		}

		private function get host():Range
		{
			return _strand as Range;
		}

		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			if (_styles)
				return;
			var size:String = computeSize(400, host.unit);
			_styles = [
					new WidthStyle(size),
					new MinWidth(size),
				];
			host.setStyles(_styles);
		}

		private var _trackStyles:Array;

		public function get trackStyles():Array
		{
			if (!_trackStyles)
				createTrackStyles();
			return _trackStyles;
		}

		private function createTrackStyles():void
		{
			if (_trackStyles)
				return;
			_trackStyles = [
					new Display("flex"),
					new AlignItems("center"),
					new Position("relative"),
					new HeightStyle("1.5rem")
				];
		}

		private var _fillStyles:Array;

		public function get fillStyles():Array
		{
			if (!_fillStyles)
				createFillStyles();
			return _fillStyles;
		}

		private function createFillStyles():void
		{
			if (_fillStyles)
				return;
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var fillColor:ColorSwatch = (host.theme && host.theme != "default") ? colorSet.getSwatch(host.theme, 500) : colorSet.getSwatch(ThemeColorSet.NEUTRAL, 900);
			var disabledFillColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 200, 50);
			var boxShadowColor:ColorSwatch = (host.theme && host.theme != "default") ? colorSet.getSwatch(host.theme, 200) : colorSet.getSwatch(ThemeColorSet.NEUTRAL, 500);
			var size:Number = getMultiplier();
			_fillStyles = [
					new HeightStyle(computeSize(size, host.unit)),
					new BorderRadius("full"),
					new BackgroundColor(fillColor),
					new BoxShadow(boxShadowColor.colorSpecifier),
					new GroupPseudo([
							new DataState("disabled", [
								new BackgroundColor(disabledFillColor),
								new Cursor("not-allowed")
						])
					], host.getWrapperStyle())
				];
		}

		private var _handleStyles:Array;

		public function get handleStyles():Array
		{
			if (!_handleStyles)
				createHandleStyles();
			return _handleStyles;
		}

		private function createHandleStyles():void
		{
			if (_handleStyles)
				return;
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var borderColor:ColorSwatch = (host.theme && host.theme != "default") ? colorSet.getSwatch(host.theme, 500) : colorSet.getSwatch(ThemeColorSet.NEUTRAL, 900);
			var disabledBorderColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 200, 50);
			var disabledBackgroundColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 100, 50);
			var size:Number = getMultiplier();
			var handleMargin:Margin = new Margin();
			handleMargin.left = handleMargin.right = computeSize(size*-0.5, host.unit);
			var borderWidth:Number = size == 5 ? 1:2;
			_handleStyles = [
					new Position("relative"),
					new ZIndex(10),
					handleMargin,
					new HeightStyle(computeSize(size, host.unit)),
					new WidthStyle(computeSize(size, host.unit)),
					new FlexShrink(0),
					new BorderRadius("full"),
					new BorderWidth(computeSize(borderWidth, host.unit)),
					new BorderColor(borderColor),
					new BackgroundColor("white"),
					new GroupPseudo([
							new DataState("disabled", [
								new BorderColor(disabledBorderColor),
								new BackgroundColor(disabledBackgroundColor),
								new Cursor("not-allowed")
						])
					], host.getWrapperStyle())
				];
		}

		private var _emptyStyles:Array;

		public function get emptyStyles():Array
		{
			if (!_emptyStyles)
				createEmptyStyles();
			return _emptyStyles;
		}

		private function createEmptyStyles():void
		{
			if (_emptyStyles)
				return;
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var emptyColor:ColorSwatch = (host.theme && host.theme != "default") ? colorSet.getSwatch(host.theme, 100) : colorSet.getSwatch(ThemeColorSet.NEUTRAL, 200);
			var disabledColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 200, 50);
			var size:Number = getMultiplier();
			_emptyStyles = [
					new HeightStyle(computeSize(size, host.unit)),
					new BorderRadius("full"),
					new BackgroundColor(emptyColor),
					new GroupPseudo([
							new DataState("disabled", [
								new BackgroundColor(disabledColor),
								new Cursor("not-allowed")
						])
					], host.getWrapperStyle())
				];
		}

		private var _inputStyles:Array;

		public function get inputStyles():Array
		{
			if (!_inputStyles)
				createInputStyles();
			return _inputStyles;
		}

		private function createInputStyles():void
		{
			if (_inputStyles)
				return;
			_inputStyles = [
					new Position("absolute"),
					new Inset(0),
					new Cursor("pointer"),
					new OpacityStyle(0),
					new HeightStyle("100%"),
					new WidthStyle("100%")
				];
		}
		private function getMultiplier():Number
		{
			switch (host.size)
			{
				case "xs":
					return 5;
				case "sm":
					return 6;
				case "md":
					return 8.8;
				case "lg":
					return 12;
				case "xl":
					return 16;
				case "2xl":
					return 20;
				default:
					return 8.8;
			}
		}
	}
}