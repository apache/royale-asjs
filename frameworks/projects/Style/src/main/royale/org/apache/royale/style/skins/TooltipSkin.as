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
	import org.apache.royale.style.Icon;
	import org.apache.royale.style.IStyleUIBase;
	import org.apache.royale.style.StyleSkin;
	import org.apache.royale.style.Tooltip;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.const.AppLayers;
	import org.apache.royale.style.stylebeads.anim.Transition;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.border.Border;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.stylebeads.effects.OpacityStyle;
	import org.apache.royale.style.stylebeads.flexgrid.AlignItems;
	import org.apache.royale.style.stylebeads.flexgrid.Flex;
	import org.apache.royale.style.stylebeads.flexgrid.Gap;
	import org.apache.royale.style.stylebeads.interact.PointerEvents;
	import org.apache.royale.style.stylebeads.interact.UserSelect;
	import org.apache.royale.style.stylebeads.layout.Bottom;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.layout.Left;
	import org.apache.royale.style.stylebeads.layout.Position;
	import org.apache.royale.style.stylebeads.layout.Right;
	import org.apache.royale.style.stylebeads.layout.Top;
	import org.apache.royale.style.stylebeads.layout.Visibility;
	import org.apache.royale.style.stylebeads.layout.ZIndex;
	import org.apache.royale.style.stylebeads.sizing.HeightStyle;
	import org.apache.royale.style.stylebeads.sizing.MaxWidth;
	import org.apache.royale.style.stylebeads.sizing.WidthStyle;
	import org.apache.royale.style.stylebeads.spacing.Margin;
	import org.apache.royale.style.stylebeads.spacing.Padding;
	import org.apache.royale.style.stylebeads.states.GroupPseudo;
	import org.apache.royale.style.stylebeads.states.attribute.AttributeState;
	import org.apache.royale.style.stylebeads.states.attribute.DataState;
	import org.apache.royale.style.stylebeads.transform.Transform;
	import org.apache.royale.style.stylebeads.typography.FontSize;
	import org.apache.royale.style.stylebeads.typography.FontWeight;
	import org.apache.royale.style.stylebeads.typography.LineHeight;
	import org.apache.royale.style.stylebeads.typography.OverflowWrap;
	import org.apache.royale.style.stylebeads.typography.TextColor;
	import org.apache.royale.style.stylebeads.typography.Whitespace;
	import org.apache.royale.style.stylebeads.typography.WordBreak;
	import org.apache.royale.style.support.Icons;
	import org.apache.royale.style.util.ThemeManager;

	public class TooltipSkin extends StyleSkin implements ITooltipSkin
	{
		public function TooltipSkin()
		{
			super();
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.Tooltip
		 */
		private function get host():Tooltip
		{
			return _strand as Tooltip;
		}

		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			applyStyles();
		}
		
		//common reference values:
		private static const inline_padding:uint = 10;
		private static const block_padding:uint = 5;
		private static const border_radius:uint = 4;
		private static const nominal_font_size:uint = 12;
		private static const nominal_icon_size:uint = 14;
		private static const nominal_text_width:uint = 120;
		private static const font_weight:uint = 400;
		

		private function applyStyles():void
		{

			var transition:Transition = new Transition()
			transition.property = 'transform,opacity';
			transition.duration = '130ms';
			transition.timingFunction ='ease-in-out';
			const inPopup:Boolean = host.forDisplayInPopup;
			
			var openStates:Array = [	
				new Visibility('visible'),
				new OpacityStyle(100)
			]
			if (inPopup) {
				var tipMargin:String = computeSize(2 * border_radius * getMultiplier(),host.unit);
				var transformTop:Transform = new Transform();
				transformTop.translateY = '-' + tipMargin;
				var transformBottom:Transform = new Transform();
				transformBottom.translateY = tipMargin;
				var transformLeft:Transform = new Transform();
				transformLeft.translateX = '-' + tipMargin;
				var transformRight:Transform = new Transform();
				transformRight.translateX = tipMargin;
				openStates.push(new DataState('direction-top',[transformTop]));
				openStates.push(new DataState('direction-left',[transformLeft]));
				openStates.push(new DataState('direction-right',[transformRight]));
				openStates.push(new DataState('direction-bottom',[transformBottom]));
				openStates.push(new ZIndex(AppLayers.POPUP_TOOL_TIPS));
			}
			
			var positionStyle:String = inPopup ? 'absolute' : 'relative';
			var styles:Array = [
				new Display('inline-flex'),
				new AlignItems('center'),
				new Position(positionStyle),
				new UserSelect('none'),
				new PointerEvents('none'),
				transition,
				new Visibility('hidden'),
				new OpacityStyle(0),
				new AttributeState('is-open',openStates)
			];
			
			host.setStyles(styles, true);
		}

		private function getHostFlavorColor():String
		{
			var hostFlavor:String = host.flavor;
			switch(hostFlavor) {
				case 'negative':
					hostFlavor = 'error';
					break;
				case 'positive':
					hostFlavor = 'success';
					break;
				default:
			}
			return hostFlavor || ThemeColorSet.NEUTRAL;
		}

		private function getBackgroundShade(colorSet:ThemeColorSet, colorState:String):ColorSwatch
		{
			var shade:uint = 700; // Tooltips are usually darker
			return colorSet.getSwatch(colorState, shade);
		}

		private function createContentStyles():void
		{
			var multiplier:Number = getMultiplier();
			var colorState:String = getHostFlavorColor();
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var backgroundColor:ColorSwatch = getBackgroundShade(colorSet, colorState);
			var padding:Padding = new Padding(computeSize(multiplier * block_padding, host.unit), host.unit);
			padding.inline = computeSize(inline_padding * multiplier, host.unit);
			
			//we will use a smaller font size rather than the theme lookups.
			var textSizing:String = computeSize(nominal_font_size * multiplier, host.unit);

			var styles:Array = [
				new Display('inline-flex'),
				new AlignItems('flex-start'),
				new Gap(padding.inline), //make the gap the same as the inline padding
				new BorderRadius(computeSize(border_radius * multiplier, host.unit)),
				padding,
				new BackgroundColor(backgroundColor),
				new FontSize(textSizing),
				new LineHeight(textSizing),
				new FontWeight(font_weight),
				new Whitespace('pre-wrap'),
				new WordBreak('normal'),
				new OverflowWrap('anywhere'),
				new MaxWidth(computeSize((nominal_text_width + nominal_icon_size) * multiplier, host.unit)),
				new TextColor(colorSet.getContrastSwatch(backgroundColor))
			];
			_contentStyles = styles;
		}

		private var _contentStyles:Array;
		public function get tooltipContentStyles():Array
		{
			if (!_contentStyles)
				createContentStyles();
			return _contentStyles;
		}

		public function get tipStyles():Array
		{
			var unit:String = host.unit;
			// The tip (arrow) shares the background color of the content
			var colorState:String = getHostFlavorColor();
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var backgroundColor:ColorSwatch = getBackgroundShade(colorSet, colorState);
			var multiplier:Number = getMultiplier();
			var tipWidth:String = computeSize(border_radius * multiplier,host.unit);
			
			var border:Border = new Border('transparent','solid',tipWidth,'0',unit);
			border.topColor = backgroundColor.colorSpecifier;
			
			//location related:
			var tipPosition:String = host.tipPosition;
			var sideLocation:String;
			if (tipPosition == 'center') {
				sideLocation = '50%';
			} else {
				var cornerExclusionZone:String = computeSize(border_radius * 1.5 * multiplier,unit);
				sideLocation = 'calc(' + (tipPosition == 'start' ? '0% + ' : '100% - ') + cornerExclusionZone + ')';
			}
			
			var verticalPlacementMarginTop:Margin = new Margin(null,unit);
			verticalPlacementMarginTop.left = '-'+tipWidth;
			var verticalPlacementMarginBottom:Margin = new Margin(null,unit);
			verticalPlacementMarginBottom.left = '-'+tipWidth;
			var horizontalPlacementMarginLeft:Margin = new Margin(null,unit);
			horizontalPlacementMarginLeft.top = '-'+tipWidth;
			var horizontalPlacementMarginRight:Margin = new Margin(null,unit);
			horizontalPlacementMarginRight.top = '-'+tipWidth;
			
			var bottomRotate:Transform = new Transform();
			bottomRotate.rotate = '180deg';
			var leftRotate:Transform = new Transform();
			leftRotate.rotate = '-90deg';
			var rightRotate:Transform = new Transform();
			rightRotate.rotate = '90deg';
			
			var locationStyles:Array = [
				new GroupPseudo([
					new DataState('direction-top', [
						verticalPlacementMarginTop,
						new Top('100%'),
						new Left(sideLocation)
					]),
					new DataState('direction-left', [
						horizontalPlacementMarginLeft,
						leftRotate,
						new Left('100%'),
						new Top(sideLocation)
					]),
					new DataState('direction-right', [
						horizontalPlacementMarginRight,
						rightRotate,
						new Right('100%'),
						new Top(sideLocation)
					]),
					new DataState('direction-bottom', [
						verticalPlacementMarginBottom,
						bottomRotate,
						new Bottom('100%'),
						new Left(sideLocation)
					])
				], host.getWrapperStyle())
			]
			
			return [
				new Position('absolute'),
					new WidthStyle('0'),
					new HeightStyle('0'),
					border
				
			].concat(locationStyles);
		}

		public function getIcon(flavor:String):IStyleUIBase
		{
			var icon:Icon;
			switch(flavor) {
				case "error":
				case "negative":
					icon = Icons.alert_medium();
					break;
				case "success":
				case "positive":
					icon = Icons.success_medium();
					break;
				case "info":
					icon = Icons.info_medium();
					break;
				case "help":
					icon = Icons.help_medium();
					break;
				default:
					icon = null;
			}
			
			if (icon) {
				var multiplier:Number = getMultiplier();
				var dimension:String = computeSize(nominal_icon_size * multiplier, host.unit);
				icon.setStyles([
					 new WidthStyle(dimension),
					 new HeightStyle(dimension),
					 new Flex('0 0 auto')
				]);
			}
			return icon;
		}

		private function getMultiplier():Number
		{
			switch(host.size)
			{
				case "xs": return 0.6;
				case "sm": return 0.8;
				case "md": return 1;
				case "lg": return 1.2;
				case "xl": return 1.4;
				default: return 1;
			}
		}
		
		//Q:why are these here? 
		//A: because the absolutely positioned tip child does not contribute to the host component's measured height and width
		//these are needed for adaptive positioning. Putting this support in the skin will mean different skins can do different things internally
		public function getExtraHeight():Number{
			var dir:String = host.direction;
			if (dir =='bottom' || dir=='top') {
				return 2 * border_radius;
			}
			return 0;
		}
		
		public function getExtraWidth():Number{
			var dir:String = host.direction;
			if (dir =='left' || dir=='right') {
				return 2 * border_radius;
			}
			return 0;
		}
	}
}
