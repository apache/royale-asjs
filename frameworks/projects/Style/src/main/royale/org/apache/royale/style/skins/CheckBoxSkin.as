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
	import org.apache.royale.style.stylebeads.flexgrid.AlignSelf;
	import org.apache.royale.style.stylebeads.flexgrid.JustifyItems;
	import org.apache.royale.style.stylebeads.flexgrid.GridTemplateRows;
	import org.apache.royale.style.stylebeads.flexgrid.RowGap;
	import org.apache.royale.style.stylebeads.interact.UserSelect;
	import org.apache.royale.style.stylebeads.states.DisabledState;
	import org.apache.royale.style.stylebeads.states.HasState;
	import org.apache.royale.style.stylebeads.flexgrid.GridColumn;
	import org.apache.royale.style.stylebeads.flexgrid.GridColumnStart;
	import org.apache.royale.style.stylebeads.flexgrid.GridRowStart;
	import org.apache.royale.style.stylebeads.sizing.HeightStyle;
	import org.apache.royale.style.stylebeads.sizing.WidthStyle;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.stylebeads.states.LeafDecorator;
	import org.apache.royale.style.stylebeads.states.NotState;
	import org.apache.royale.style.stylebeads.states.HoverState;
	import org.apache.royale.style.stylebeads.states.attribute.DataState;
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
	import org.apache.royale.style.stylebeads.spacing.Padding;
	import org.apache.royale.style.stylebeads.spacing.Margin;

	import org.apache.royale.style.stylebeads.states.attribute.AttributeState;
	import org.apache.royale.style.stylebeads.states.GroupPseudo;
	
	import org.apache.royale.style.stylebeads.typography.VerticalAlign;
	
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
			applyStyles();
		}

		public function updateStyles():void
		{
			_styles = null;
			_boxStyles = null;
			_labelStyles = null;
			_checkIcon = null;
			_indeterminateIcon = null;
			applyStyles();
		}

		private function applyStyles():void
		{
			var size:Number = 16 * getMultiplier();
			var box:String = computeSize(size * 1.25, host.unit);
			var gapValue:Number = size * 0.375;
			var gap:String = computeSize(gapValue, host.unit);
			
			var padding:Padding = new Padding();
			padding.unit = host.unit;
			padding.right = gap;
			var layoutStyles:Array = [
				new Display("inline-grid"),
				new VerticalAlign("top"),
				new GridTemplateColumns(box + " auto"),
				new GridTemplateRows("auto"),
				new AlignItems("center"),
				new ColumnGap(gap),
				padding
			];
			
			_styles = [
				new UserSelect("none"),
				new Cursor("pointer"),
				new DataState("disabled", [
					new Cursor("auto")
				])
			].concat(layoutStyles);
			
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
			var primaryColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.PRIMARY,500);
			var enabledBorder:ColorSwatch = colorSet.getSwatch(ThemeColorSet.NEUTRAL,500);
			var disabledBorder:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 300,50);
			var disabledFillColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 200, 50);
			
			
			var size:Number = 16 * getMultiplier();
			var box:String = computeSize(size * 1.25, host.unit);
			
			var boxColumn:String = "1";// the grid column to place the box in
			var boxRow:String = "1";// the grid row to place the box in
			
			var outline:Outline = new Outline();
			outline.unit = host.unit;
			outline.width = 0.5;
			outline.style = "solid";
			outline.color = primaryColor.getVariant(NaN,40).colorSpecifier;
			outline.offset = 0.5;
			
			_boxStyles = [
				new GridColumnStart(boxColumn),
				new GridRowStart(boxRow),
				new HeightStyle(box),
				new WidthStyle(box),
				new AlignSelf("center"),
				new BorderRadius(ThemeManager.instance.activeTheme.radiusSM),
				new BorderWidth(0.5),
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
				])/*,
				
				//for reference, this also works instead of PeerPseudo/DisabledState above:
				// Apply disabled styles when the parent (wrapper) is disabled.
				// host.getWrapperStyle() ensures this matches the component's top-level class.
				// This is added at the end so it has higher priority in CSS than PeerPseudo styles.
				new GroupPseudo([
					new DataState("disabled", [
						new BorderColor(disabledBorder),
						new BackgroundColor(disabledFillColor)
					])
				], host.getWrapperStyle())*/
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
			var enabledColor:ColorSwatch = colorSet.baseContent;
			var disabledColor:ColorSwatch = colorSet.baseContentWeak;
			
			var labelColumn:String = "2"; // the grid column to place the label in
			var labelRow:String = "1"; // the grid row to place the label in
			
			_labelStyles = [
				new GridColumnStart(labelColumn),
				new GridRowStart(labelRow),
				new FontSize(fontSize),
				new FontWeight("600"),
				new TextColor(enabledColor),
				new PeerPseudo([
					new DisabledState([
						new TextColor(disabledColor)
					])
				])/*
				//for reference, this also works instead of PeerPseudo/DisabledState above:
				new GroupPseudo([
					new DataState("disabled", [
						new TextColor(disabledColor)
					])
				], host.getWrapperStyle())*/
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
				var enabledColor:ColorSwatch = colorSet.getContrastSwatch(colorSet.getSwatch(ThemeColorSet.PRIMARY,500));
				//weak contrast against disabled fill:
				var disabledFillColor:ColorSwatch  = colorSet.getSwatch(ThemeColorSet.BASE, 200, 50);
				var disabledColor:ColorSwatch = colorSet.getWeakContrastSwatch(disabledFillColor);
				
				_checkIcon = new Div();
				var size:Number = 16 * getMultiplier();
				
				var boxColumn:String = "1"; // the grid column to place the icon in
				var boxRow:String = "1"; // the grid row to place the icon in

				var transform:Transform = new Transform();
				transform.rotate = "45deg";
				transform.translateY = "-8%";
	
				var borderWidth:BorderWidth = new BorderWidth();
				borderWidth.bottom = 0.75;
				borderWidth.right = 0.75;

				var styles:Array = [
					new GridColumnStart(boxColumn),
					new GridRowStart(boxRow),
					new HeightStyle(computeSize(size * 0.625, host.unit)),
					new WidthStyle(computeSize(size * 0.375, host.unit)),
					new AlignSelf("center"),
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
					])/*,
					//for reference, this also works instead of PeerPseudo/DisabledState above:
					new GroupPseudo([
						new DataState("disabled", [
							new BorderColor(disabledColor)
						])
					], host.getWrapperStyle())*/
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
				var enabledColor:ColorSwatch = colorSet.getContrastSwatch(colorSet.getSwatch(ThemeColorSet.PRIMARY,500));
				var disabledFillColor:ColorSwatch  = colorSet.getSwatch(ThemeColorSet.BASE, 200, 50);
				var disabledColor:ColorSwatch = colorSet.getWeakContrastSwatch(disabledFillColor);
				
				_indeterminateIcon = new Div();
				var size:Number = 16 * getMultiplier();
				var unit:String = host.unit;

				var boxColumn:String = "1"; // the grid column to place the icon in
				var boxRow:String = "1";// the grid row to place the icon in
				
				var styles:Array = [
					new GridColumnStart(boxColumn),
					new GridRowStart(boxRow),
					new HeightStyle(/*"14%"*/computeSize(size * 0.175,unit)), //note 0.175 is 14% of 1.25
					new WidthStyle(computeSize(size * 0.625, unit)),
					new AlignSelf("center"),
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
					/*,
					//for reference, this also works instead of PeerPseudo/DisabledState above:
					new GroupPseudo([
						new DataState("disabled", [
							new BackgroundColor(disabledColor)
						])
					], host.getWrapperStyle())*/
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