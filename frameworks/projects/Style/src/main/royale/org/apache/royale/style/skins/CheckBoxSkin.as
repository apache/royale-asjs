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
	import org.apache.royale.style.IIcon;
	import org.apache.royale.style.Icon;
	import org.apache.royale.style.IStyleUIBase;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.CheckBox;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.interact.Cursor;
	import org.apache.royale.style.stylebeads.flexgrid.GridAutoColumns;
	import org.apache.royale.style.stylebeads.flexgrid.AlignItems;
	import org.apache.royale.style.stylebeads.flexgrid.RowGap;
	import org.apache.royale.style.stylebeads.interact.UserSelect;
	import org.apache.royale.style.stylebeads.states.DisabledState;
	import org.apache.royale.style.stylebeads.flexgrid.GridColumn;
	import org.apache.royale.style.stylebeads.flexgrid.GridColumnStart;
	import org.apache.royale.style.stylebeads.flexgrid.GridRowStart;
	import org.apache.royale.style.stylebeads.sizing.HeightStyle;
	import org.apache.royale.style.stylebeads.sizing.WidthStyle;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.stylebeads.border.BorderWidth;
	import org.apache.royale.style.stylebeads.border.BorderColor;
	import org.apache.royale.style.stylebeads.anim.Transition;
	import org.apache.royale.style.stylebeads.states.PeerPseudo;
	import org.apache.royale.style.stylebeads.states.FocusVisibleState;
	import org.apache.royale.style.stylebeads.border.Outline;
	import org.apache.royale.style.stylebeads.states.CheckedState;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.states.IndeterminateState;
	import org.apache.royale.style.stylebeads.typography.FontSize;
	import org.apache.royale.style.stylebeads.typography.TextColor;
	import org.apache.royale.style.stylebeads.typography.FontWeight;
	import org.apache.royale.style.elements.Div;
	import org.apache.royale.style.stylebeads.CompositeStyle;
	import org.apache.royale.style.stylebeads.flexgrid.PlaceContent;
	import org.apache.royale.style.stylebeads.flexgrid.PlaceSelf;
	import org.apache.royale.style.stylebeads.border.Border;
	import org.apache.royale.style.stylebeads.transform.Transform;
	import org.apache.royale.style.stylebeads.effects.OpacityStyle;
	import org.apache.royale.style.stylebeads.flexgrid.GridTemplateColumns;
	import org.apache.royale.style.stylebeads.flexgrid.ColumnGap;

	public class CheckBoxSkin extends StyleSkin implements ICheckBoxSkin
	{
		public function CheckBoxSkin()
		{
			super();
		}
		/**
		 * @royaleignorecoercion org.apache.royale.style.CheckBox
		 */
		private function get host():CheckBox
		{
			return _strand as CheckBox;
		}
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			// Manually set. Don't create the default ones.
			if(_styles)
				return;
			
			var size:Number = 16 * getMultiplier();
			var box:String = computeSize(size * 1.25, host.unit);
			var gap:String = computeSize(size * 0.75, host.unit);
			var disabledStyle:DisabledState = new DisabledState();
			disabledStyle.styles = [
				//@todo: observed that this disabled style seems not to be working ('pointer' stays active):
				new Cursor("auto")
			];
			_styles = [
				new Display("inline-grid"),
				new Cursor("pointer"),
				new GridTemplateColumns(box + " auto"),
				new AlignItems("center"),
				new ColumnGap(gap),
				new UserSelect("none"),
				disabledStyle
			];
			host.setStyles(_styles);
		}
		private function getMultiplier():Number
		{
			var multiple:Number;
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

		private var _boxStyles:Array;

		public function get boxStyles():Array
		{
			if(!_boxStyles)
				createBoxStyles();
			return _boxStyles;
		}
		private function createBoxStyles():void
		{
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var primaryColor:ColorSwatch = colorSet.getThemeColorSwatch(ThemeColorSet.PRIMARY);
			var enabledBorder:ColorSwatch = colorSet.getThemeColorSwatch(ThemeColorSet.NEUTRAL);
			var disabledBorder:ColorSwatch = colorSet.getThemeColorSwatch(ThemeColorSet.NEUTRAL).getVariant(300);
			var disabledFillColor:ColorSwatch = colorSet.getThemeColorSwatch(ThemeColorSet.NEUTRAL).getVariant(100);
			
			var size:Number = 16 * getMultiplier();
			var box:String = computeSize(size * 1.25, host.unit);
			var outline:Outline = new Outline();
			outline.width = 2;
			outline.color = primaryColor.getVariant(NaN,40).colorSpecifier;
			outline.offset = 2;
			
			_boxStyles = [
				new GridColumnStart("1"),
				new GridRowStart("1"),
				new HeightStyle(box),
				new WidthStyle(box),
				new BorderRadius(ThemeManager.instance.activeTheme.radiusSM),
				new BorderWidth(2),
				new BorderColor(enabledBorder),
				new Transition(),
				new PeerPseudo([
					new FocusVisibleState([outline]),
					new CheckedState([
						new BorderColor(primaryColor),
						new BackgroundColor(primaryColor)
					]),
					new IndeterminateState([
						new BorderColor(primaryColor),
						new BackgroundColor(primaryColor)
					]),
					new DisabledState([
						new BorderColor(disabledBorder),
						new BackgroundColor(disabledFillColor)
					])
				])
			];
		}

		public function set boxStyles(value:Array):void
		{
			_boxStyles = value;
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
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var enabledColor:ColorSwatch = colorSet.getThemeColorSwatch(ThemeColorSet.BASE_CONTENT);
			var disabledColor:ColorSwatch =	colorSet.getThemeColorSwatch(ThemeColorSet.NEUTRAL_CONTENT).getVariant(NaN, 60);
			
			_labelStyles = [
				new GridColumnStart("2"),
				new GridRowStart("1"),
				new FontSize(fontSize),
				new FontWeight("600"),
				new TextColor(enabledColor),
				new PeerPseudo([
					new DisabledState([
						new TextColor(disabledColor)
					])
				])
			];
		}

		public function set labelStyles(value:Array):void
		{
			_labelStyles = value;
		}

		private var _checkIcon:IStyleUIBase;
		/**
		 * The checkIcon should have any styles pre-applied.
		 */
		public function get checkIcon():IStyleUIBase
		{
			if(!_checkIcon){
				var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
				var enabledColor:ColorSwatch = colorSet.getThemeColorSwatch(ThemeColorSet.PRIMARY_CONTENT);
				var disabledColor:ColorSwatch = colorSet.getThemeColorSwatch(ThemeColorSet.NEUTRAL_CONTENT).getVariant(600, 40);
				
				_checkIcon = new Div();
				var size:Number = 16 * getMultiplier();
				var transform:Transform = new Transform();
				transform.translateY = "-8%";
				transform.rotate = "45deg";
	
				var borderWidth:BorderWidth = new BorderWidth();
				borderWidth.bottom = 3;
				borderWidth.right = 3;
				var styles:Array = [
					new GridColumnStart("1"),
					new GridRowStart("1"),
					new HeightStyle(computeSize(size * 0.625, host.unit)),
					new WidthStyle(computeSize(size * 0.375, host.unit)),
					new PlaceSelf("center"),
					transform,
					borderWidth,
					new BorderColor(enabledColor),
					new Transition(),
					new OpacityStyle(0),
					new PeerPseudo([
						new CheckedState([
							new OpacityStyle(100)
						]),
						new IndeterminateState([
							new OpacityStyle(0)
						]),
						new DisabledState([
							new BorderColor(disabledColor)
						])
					])
				];
				_checkIcon.setStyles(styles);
				// TODO dark mode styles
			}
			return _checkIcon;
		}

		public function set checkIcon(value:IStyleUIBase):void
		{
			_checkIcon = value;
		}

		private var _indeterminateIcon:IStyleUIBase;
		/**
		 * The indeterminateIcon should have any styles pre-applied.
		 */
		public function get indeterminateIcon():IStyleUIBase
		{
			if(!_indeterminateIcon){
				var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
				var enabledColor:ColorSwatch = colorSet.getThemeColorSwatch(ThemeColorSet.PRIMARY_CONTENT);
				var disabledColor:ColorSwatch = colorSet.getThemeColorSwatch(ThemeColorSet.NEUTRAL_CONTENT).getVariant(600, 40);
				_indeterminateIcon = new Div();
				var size:Number = 16 * getMultiplier();

				var styles:Array = [
					new GridColumnStart("1"),
					new GridRowStart("1"),
					new HeightStyle("14%"),
					new WidthStyle(computeSize(size * 0.625, host.unit)),
					new PlaceSelf("center"),
					new BorderRadius(ThemeManager.instance.activeTheme.radiusSM),
					new BackgroundColor(enabledColor),
					new Transition(),
					new OpacityStyle(0),
					new PeerPseudo([
						new IndeterminateState([
							new OpacityStyle(100)
						]),
						new DisabledState([
							new BackgroundColor(disabledColor)
						])
					])
				];
				_indeterminateIcon.setStyles(styles);
			}
			return _indeterminateIcon;
		}

		public function set indeterminateIcon(value:IStyleUIBase):void
		{
			_indeterminateIcon = value;
		}
	}
}