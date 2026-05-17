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
	import org.apache.royale.style.Radio;
	import org.apache.royale.style.stylebeads.anim.Transition;
	import org.apache.royale.style.stylebeads.anim.TransitionDuration;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.border.BorderColor;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.stylebeads.border.BorderWidth;
	import org.apache.royale.style.stylebeads.effects.OpacityStyle;
	import org.apache.royale.style.stylebeads.flexgrid.GridColumnStart;
	import org.apache.royale.style.stylebeads.flexgrid.GridRowStart;
	import org.apache.royale.style.stylebeads.flexgrid.PlaceItems;
	import org.apache.royale.style.stylebeads.flexgrid.PlaceSelf;
	import org.apache.royale.style.stylebeads.interact.Cursor;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.layout.Position;
	import org.apache.royale.style.stylebeads.sizing.HeightStyle;
	import org.apache.royale.style.stylebeads.sizing.WidthStyle;
	import org.apache.royale.style.stylebeads.states.CheckedState;
	import org.apache.royale.style.stylebeads.states.PeerPseudo;
	import org.apache.royale.style.stylebeads.typography.TextColor;
	import org.apache.royale.style.stylebeads.states.DisabledState;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.util.ThemeManager;

	public class RadioSkin extends StyleSkin implements IRadioSkin
	{
		public function RadioSkin()
		{
			super();
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.Radio
		 */
		private function get host():Radio
		{
			return _strand as Radio;
		}

		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			if (_styles)
				return;
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var baseColor:* = (host.theme && host.theme != "default") ? colorSet.getSwatch(host.theme, 600) : "black";
			_styles = [
					new Display("inline-grid"),
					new Position("relative"),
					new HeightStyle(6),
					new WidthStyle(6),
					new PlaceItems("center"),
					new Cursor("pointer"),
					// new TextColor(baseColor)
				];
			host.setStyles(_styles);
		}

		private var _boxStyles:Array;

		public function get boxStyles():Array
		{
			if (!_boxStyles)
			{
				var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			    var baseColor:* = (host.theme && host.theme != "default") ? colorSet.getSwatch(host.theme, 600) : "black";
				var disabledBorder:* = colorSet.getSwatch(ThemeColorSet.NEUTRAL, 300);
				var disabledFill:* = colorSet.getSwatch(ThemeColorSet.NEUTRAL, 100);
				var Size:String = computeSize(getBoxSizePx(), host.unit);
				_boxStyles = [
						new GridColumnStart("1"),
						new GridRowStart("1"),
						new PlaceSelf("center"),
						new HeightStyle(Size),
						new WidthStyle(Size),
						new BorderRadius("full"),
						new BorderWidth("2px"),
						new BorderColor(baseColor),
						new BackgroundColor("white"),
						new PeerPseudo([
							new DisabledState([
								new BorderColor(disabledBorder),
								new BackgroundColor(disabledFill),
								new Cursor("not-allowed")
							])
						])
					];
			}
			return _boxStyles;
		}

		public function set boxStyles(value:Array):void
		{
			_boxStyles = value;
		}

		private var _dotStyles:Array;

		public function get dotStyles():Array
		{
			if (!_dotStyles)
			{
				var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
				var baseColor:* = (host.theme && host.theme != "default") ? colorSet.getSwatch(host.theme, 600) : "black";
				var disabledDot:* = colorSet.getSwatch(ThemeColorSet.NEUTRAL, 300);
				var Size:String = computeSize(getDotSizePx(), host.unit);
				_dotStyles = [
						new GridColumnStart("1"),
						new GridRowStart("1"),
						new PlaceSelf("center"),
						new HeightStyle(Size),
						new WidthStyle(Size),
						new BorderRadius("full"),
						new BackgroundColor(baseColor),
						new OpacityStyle(0),
						new Transition("opacity"),
						new TransitionDuration(150),
						new PeerPseudo([
								new CheckedState([
										new OpacityStyle(100)
									]),
								new DisabledState([
										new BackgroundColor(disabledDot),
										new Cursor("not-allowed")
									])
							])
					];
			}
			return _dotStyles;
		}

		public function set dotStyles(value:Array):void
		{
			_dotStyles = value;
		}

		private function getBoxSizePx():Number
		{
			switch (host.size)
			{
				case "xs":
					return 18;
				case "sm":
					return 19;
				case "md":
					return 21;
				case "lg":
					return 25;
				case "xl":
					return 29;
				default:
					return 21;
			}
		}
		private function getDotSizePx():Number
		{
			return Math.max(Math.round(getBoxSizePx() * 0.5), 1);
		}

	}
}