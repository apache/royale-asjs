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
	import org.apache.royale.style.Toggle;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.layout.Position;
	import org.apache.royale.style.stylebeads.layout.Left;
	import org.apache.royale.style.stylebeads.layout.Top;
	import org.apache.royale.style.stylebeads.interact.Cursor;
	import org.apache.royale.style.stylebeads.interact.UserSelect;
	import org.apache.royale.style.stylebeads.sizing.HeightStyle;
	import org.apache.royale.style.stylebeads.sizing.WidthStyle;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.stylebeads.border.Outline;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.anim.Transition;
	import org.apache.royale.style.stylebeads.transform.Transform;
	import org.apache.royale.style.stylebeads.typography.FontSize;
	import org.apache.royale.style.stylebeads.typography.TextColor;
	import org.apache.royale.style.stylebeads.states.PeerPseudo;
	import org.apache.royale.style.stylebeads.states.GroupPseudo;
	import org.apache.royale.style.stylebeads.states.CheckedState;
	import org.apache.royale.style.stylebeads.states.DisabledState;
	import org.apache.royale.style.stylebeads.states.FocusVisibleState;
	import org.apache.royale.style.stylebeads.states.attribute.DataState;
	import org.apache.royale.style.stylebeads.flexgrid.AlignItems;
	import org.apache.royale.style.stylebeads.flexgrid.ColumnGap;

	public class ToggleSkin extends StyleSkin implements IToggleSkin
	{
		public function ToggleSkin()
		{
			super();
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.Toggle
		 */
		private function get host():Toggle
		{
			return _strand as Toggle;
		}

		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			applyStyles();
		}

		private function applyStyles():void
		{
			var size:Number = 16 * getMultiplier();
			var gap:String = computeSize(size * 0.5, host.unit);

			_styles = [
				new Display("inline-flex"),
				new AlignItems("center"),
				new ColumnGap(gap),
				new UserSelect("none"),
				new Cursor("pointer"),
				new DataState("disabled", [
					new Cursor("default")
				])
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

		private var _trackStyles:Array;

		public function get trackStyles():Array
		{
			if(!_trackStyles)
				createTrackStyles();
			return _trackStyles;
		}

		public function set trackStyles(value:Array):void
		{
			_trackStyles = value;
		}

		private function createTrackStyles():void
		{
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var primaryColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.PRIMARY, 500);
			var uncheckedColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.NEUTRAL, 300);
			var disabledColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 200, 50);

			var size:Number = 16 * getMultiplier();
			var trackHeight:String = computeSize(size * 1.5, host.unit);
			var trackWidth:String = computeSize(size * 2.75, host.unit);

			var outline:Outline = new Outline();
			outline.unit = host.unit;
			outline.width = 0.5;
			outline.style = "solid";
			outline.color = primaryColor.getVariant(NaN, 40).colorSpecifier;
			outline.offset = 0.5;

			_trackStyles = [
				new Position("relative"),
				new HeightStyle(trackHeight),
				new WidthStyle(trackWidth),
				new BorderRadius("9999px"),
				new BackgroundColor(uncheckedColor),
				new Transition(),
				new PeerPseudo([
					new FocusVisibleState([outline]),
					new CheckedState([
						new BackgroundColor(primaryColor)
					]),
					new DisabledState([
						new BackgroundColor(disabledColor)
					])
				])
			];
		}

		private var _thumbStyles:Array;

		public function get thumbStyles():Array
		{
			if(!_thumbStyles)
				createThumbStyles();
			return _thumbStyles;
		}

		public function set thumbStyles(value:Array):void
		{
			_thumbStyles = value;
		}

		private function createThumbStyles():void
		{
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var thumbColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 0);
			var disabledThumbColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 100, 50);

			var size:Number = 16 * getMultiplier();
			var thumbSize:String = computeSize(size * 1.25, host.unit);
			var inset:String = computeSize(size * 0.125, host.unit);
			var slideDistance:String = computeSize(size * 1.25, host.unit);

			var left:Left = new Left();
			left.value = inset;

			var top:Top = new Top();
			top.value = inset;

			var checkedTransform:Transform = new Transform();
			checkedTransform.translateX = slideDistance;

			_thumbStyles = [
				new Position("absolute"),
				left,
				top,
				new HeightStyle(thumbSize),
				new WidthStyle(thumbSize),
				new BorderRadius("9999px"),
				new BackgroundColor(thumbColor),
				new Transition(),
				new GroupPseudo([
					new DataState("checked", [checkedTransform]),
					new DataState("disabled", [
						new BackgroundColor(disabledThumbColor)
					])
				], host.getWrapperStyle())
			];
		}

		private var _labelStyles:Array;

		public function get labelStyles():Array
		{
			if(!_labelStyles)
				createLabelStyles();
			return _labelStyles;
		}

		public function set labelStyles(value:Array):void
		{
			_labelStyles = value;
		}

		private function createLabelStyles():void
		{
			var size:Number = 16 * getMultiplier();
			var fontSize:String = computeSize(size, host.unit);
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var enabledColor:ColorSwatch = colorSet.baseContent;
			var disabledColor:ColorSwatch = colorSet.baseContentWeak;

			_labelStyles = [
				new FontSize(fontSize),
				new TextColor(enabledColor),
				new PeerPseudo([
					new DisabledState([
						new TextColor(disabledColor)
					])
				])
			];
		}
	}
}
