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
	import org.apache.royale.style.Step;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.flexgrid.FlexDirection;
	import org.apache.royale.style.stylebeads.flexgrid.FlexGrow;
	import org.apache.royale.style.stylebeads.flexgrid.AlignItems;
	import org.apache.royale.style.stylebeads.flexgrid.JustifyContent;
	import org.apache.royale.style.stylebeads.flexgrid.Gap;
	import org.apache.royale.style.stylebeads.sizing.HeightStyle;
	import org.apache.royale.style.stylebeads.sizing.WidthStyle;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.border.Border;
	import org.apache.royale.style.stylebeads.border.BorderColor;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.stylebeads.typography.TextColor;
	import org.apache.royale.style.stylebeads.typography.FontSize;
	import org.apache.royale.style.stylebeads.typography.FontWeight;
	import org.apache.royale.style.stylebeads.states.attribute.DataState;
	import org.apache.royale.style.stylebeads.spacing.Padding;

	public class StepSkin extends StyleSkin implements IStepSkin
	{
		public function StepSkin()
		{
			super();
		}

		private var _connectorStyles:Array;
		private var _circleStyles:Array;
		private var _beforeLineStyles:Array;
		private var _afterLineStyles:Array;
		private var _labelStyles:Array;

		/**
		 * @royaleignorecoercion org.apache.royale.style.Step
		 */
		private function get host():Step
		{
			return _strand as Step;
		}

		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			if (_styles)
				return;
			processStyles();
		}

		override public function update():void
		{
			processStyles();
		}

		private function getMultiplier():Number
		{
			switch(host.size)
			{
				case "sm":
					return 0.875;
				case "lg":
					return 1.125;
				case "xl":
					return 1.25;
				case "md":
				default:
					return 1;
			}
		}

		private function processStyles():void
		{
			var hostUnit:String = host.unit;
			var vert:Boolean = host.vertical;
			var mult:Number = getMultiplier();
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;

			var completedBg:ColorSwatch = colorSet.getSwatch(ThemeColorSet.PRIMARY, 500);
			var completedText:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 0);
			var incompleteBg:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 100);
			var incompleteBorder:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 300);
			var incompleteText:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 500);
			var lineBg:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 300);

			var hostSize:String = host.size;
			var circleSize:Number = 8 * mult;
			var lineThickness:Number = 2 * mult;

			var completedDataState:DataState = new DataState("completed", [
				new BackgroundColor(completedBg.colorSpecifier)
			]);

			// Label styles: shared for both orientations
			_labelStyles = [
				new TextColor(incompleteText),
				new DataState("completed", [
					new TextColor(colorSet.getSwatch(ThemeColorSet.BASE, 700))
				])
			];

			// Line base: shared appearance for connectors
			var lineBase:Array = [
				new FlexGrow(1),
				new BackgroundColor(lineBg.colorSpecifier),
				completedDataState
			];

			if (vert)
			{
				_styles = [
					new Display("flex"),
					new FlexDirection("row"),
					new Gap(computeSize(16 * mult, hostUnit)),
					new FontSize(hostSize)
				];
				_connectorStyles = [
					new Display("flex"),
					new FlexDirection("column"),
					new AlignItems("center")
				];
				_beforeLineStyles = [new Display("none")];
				_afterLineStyles = [new WidthStyle(computeSize(lineThickness, hostUnit))].concat(lineBase);

				var labelPad:Padding = new Padding();
				labelPad.top = computeSize(4 * mult, hostUnit);
				labelPad.bottom = computeSize(32 * mult, hostUnit);
				_labelStyles.unshift(labelPad);
			}
			else
			{
				_styles = [
					new Display("flex"),
					new FlexDirection("column"),
					new AlignItems("center"),
					new FlexGrow(1),
					new Gap(computeSize(8 * mult, hostUnit)),
					new FontSize(hostSize)
				];
				_connectorStyles = [
					new Display("flex"),
					new WidthStyle("full"),
					new AlignItems("center")
				];
				_beforeLineStyles = _afterLineStyles = [new HeightStyle(computeSize(lineThickness, hostUnit))].concat(lineBase);
			}

			// Circle styles: same for both orientations
			var border:Border = new Border();
			border.color = incompleteBorder.colorSpecifier;
			border.style = "solid";
			border.width = computeSize(1, hostUnit);

			_circleStyles = [
				new Display("flex"),
				new HeightStyle(circleSize),
				new WidthStyle(circleSize),
				new AlignItems("center"),
				new JustifyContent("center"),
				new BorderRadius("9999px"),
				new FontSize(hostSize),
				new FontWeight("600"),
				new BackgroundColor(incompleteBg.colorSpecifier),
				new TextColor(incompleteText),
				border,
				new DataState("completed", [
					new BackgroundColor(completedBg.colorSpecifier),
					new TextColor(completedText),
					new BorderColor("border", "border-color", "transparent")
				])
			];

			host.setStyles(_styles);
		}

		public function get connectorStyles():Array
		{
			return _connectorStyles;
		}

		public function get circleStyles():Array
		{
			return _circleStyles;
		}

		public function get beforeLineStyles():Array
		{
			return _beforeLineStyles;
		}

		public function get afterLineStyles():Array
		{
			return _afterLineStyles;
		}

		public function get labelStyles():Array
		{
			return _labelStyles;
		}
	}
}
