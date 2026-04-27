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
	import org.apache.royale.style.Icon;
	import org.apache.royale.style.IStyleUIBase;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.Toast;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.elements.Button;
	import org.apache.royale.style.stylebeads.StyleBeadBase;
	import org.apache.royale.style.stylebeads.anim.Animation;
	import org.apache.royale.style.stylebeads.anim.CustomAnimation;
	import org.apache.royale.style.util.AnimationManager;
	import org.apache.royale.style.stylebeads.anim.Transition;
	import org.apache.royale.style.stylebeads.flexgrid.Flex;
	import org.apache.royale.style.stylebeads.flexgrid.JustifyContent;
	import org.apache.royale.style.stylebeads.layout.Bottom;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.flexgrid.AlignItems;
	import org.apache.royale.style.stylebeads.interact.UserSelect;
	import org.apache.royale.style.stylebeads.layout.Position;
	import org.apache.royale.style.stylebeads.layout.ZIndex;
	import org.apache.royale.style.stylebeads.sizing.HeightStyle;
	import org.apache.royale.style.stylebeads.sizing.WidthStyle;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.stylebeads.states.HoverState;
	import org.apache.royale.style.stylebeads.states.attribute.DataState;
	import org.apache.royale.style.stylebeads.typography.FontSmoothing;
	import org.apache.royale.style.support.Icons;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.typography.FontSize;
	import org.apache.royale.style.stylebeads.typography.TextColor;
	import org.apache.royale.style.stylebeads.typography.FontWeight;
	import org.apache.royale.style.stylebeads.border.Border;
	import org.apache.royale.style.stylebeads.spacing.Padding;

	
	
	public class ToastSkin extends StyleSkin implements IToastSkin
	{
		
		//distance from bottom that toast should pop-up to.
		public static const arrivalOffset:uint = 30;
		
		private static const inAnimationName:String = 'toast-fadein';
		private static const outAnimationName:String = 'toast-fadeout';
		public static function getAnimation(out:Boolean):StyleBeadBase{
			var result:StyleBeadBase;
			var durationMillisecs:uint = 500;
			var name:String = out ? outAnimationName : inAnimationName;
			if (AnimationManager.has(name)) {
				//trace('optimized animation route',name)
				return new Animation(name + " " + durationMillisecs + "ms");
			}
			//trace('creating animation route',name)
			//otherwise create CustomAnimation, which registers it:
			if (out) {
				result = new CustomAnimation(name,[
					'from {bottom: '+arrivalOffset+'px; opacity: 1; visibility: visible;}',
					'to {bottom: 0px; opacity: 0; visibility: hidden;}'
				],durationMillisecs);
			} else {
				//in
				result = new CustomAnimation(name,[
					'from {bottom: 0; opacity: 0; visibility: visible; }',
					'to {bottom: '+arrivalOffset+'px; opacity: 1; visibility: visible; }'
				],durationMillisecs);
			}
			return result;
		}
		
		public function ToastSkin()
		{
			super();
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.style.Toast
		 */
		private function get host():Toast
		{
			return _strand as Toast;
		}
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			applyStyles();
		}

		private function getBackgroundShade(colorSet:ThemeColorSet,colorState:String):ColorSwatch{
			var shade:uint = 500;
			return colorSet.getSwatch(colorState,shade);
		}
		
		private function getHostFlavorColor():String{
			var hostFlavor:String = host.flavor;
			//normalize any 'specific' variations:
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
		
		private function createToastStyles():void
		{
			var multiplier:Number = getMultiplier();
			var colorState:String = getHostFlavorColor();
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet ;
			var backgroundColor:ColorSwatch = getBackgroundShade(colorSet,colorState);
			var padding:Padding = new Padding(computeSize(multiplier * 4, host.unit), host.unit);
			padding.right = padding.left = computeSize(8 * multiplier,padding.unit);
			var toastStyles:Array = [
				new Display('inline-flex'),
				/*new FlexDirection('row'),*/ //this is the default anyway
				new AlignItems('stretch'), // or new AlignItems('center')
				new BorderRadius(computeSize(4 * multiplier, host.unit)),
				padding,
				new FontSmoothing('antialiased'),
				new BackgroundColor(backgroundColor)
			];
			var textStyles:Array = [
				new FontSize(/*computeSize(14 * multiplier, host.unit)*/host.size || 'base'),
				new FontWeight(700),
				new TextColor(colorSet.getContrastSwatch(backgroundColor))
			];
			_toastStyles = toastStyles.concat(textStyles);
		}
		
		private var _toastStyles:Array;
		public function get toastContentStyles():Array
		{
			if(!_toastStyles)
				createToastStyles();
			return _toastStyles;
		}
		
		private function createBodyStyles():void
		{
			var multiplier:Number = getMultiplier();
			var padding:Padding = new Padding(null, host.unit);
			padding.right = computeSize(8 * multiplier,padding.unit);
			var styles:Array = [
				padding,
				new Display('inline-flex'),
				new AlignItems('center')
			];
			_bodyStyles = styles;
		}
		
		private var _bodyStyles:Array;
		public function get toastBodyStyles():Array
		{
			if(!_bodyStyles)
				createBodyStyles();
			return _bodyStyles;
		}
		
		private function createTextLayoutStyles():void{
			var multiplier:Number = getMultiplier();
			var padding:Padding = new Padding(computeSize(multiplier * 2, host.unit), host.unit);
			//padding.right = padding.left = computeSize(8 * multiplier,host.unit);
			padding.inline = computeSize(8 * multiplier,host.unit);
			_textLayoutStyles = [
					new Display('inline-block'),
					padding
			];
		}
		
		private var _textLayoutStyles:Array;
		public function get textLayoutStyles():Array{
			if(!_textLayoutStyles)
				createTextLayoutStyles();
			return _textLayoutStyles;
		}
		
		private function applyStyles():void
		{
			var inAnimation:StyleBeadBase = getAnimation(false);
			var outAnimation:StyleBeadBase = getAnimation(true);
			var toastContainerStyles:Array = [
					new UserSelect('none'),
					new Position('fixed'),
					new Bottom(arrivalOffset+'px'),
					new WidthStyle('100%'),
					new Display('flex'),
					new AlignItems('center'),
					new JustifyContent('center'),
					new ZIndex(100),
					new DataState('showing', [
						inAnimation
					]),
					new DataState('hiding', [
						outAnimation
					])
			];
			_styles = toastContainerStyles;
			host.setStyles(_styles, true);
			COMPILE::JS{
				host.element.addEventListener('animationend', onAnimationEnded);
			}
		}
		
		private function onAnimationEnded(e:Object):void{
			switch(e.animationName) {
				case inAnimationName:
					host.afterShow();
					break;
				case outAnimationName:
					host.afterHide();
					break;
			}
		}
		
		private function getMultiplier():Number
		{
			switch(host.size)
			{
				case "xs":
					return 0.6;
				case "sm":
					return 0.8;
				case "md":
					return 1;
				case "lg":
					return 1.2;
				case "xl":
					return 1.4;
				default:
					return 1;
			}
		}
		
		private function createButtonsLayoutStyles():void
		{
			var padding:Padding = new Padding(null,host.unit);
			var multiplier:Number = getMultiplier();
			padding.left = computeSize(5 * multiplier,host.unit);
			var colorState:String = getHostFlavorColor();
			var colorSet:ThemeColorSet = ThemeManager.instance.getTheme(host.theme).themeColorSet;
			//we need a contrast with the background color
			var borderLineColor:ColorSwatch = colorSet.getContrastSwatch(getBackgroundShade(colorSet,colorState)).getVariant(NaN,80);
			var border:Border = new Border(borderLineColor.toString(),'none',computeSize(multiplier,host.unit),null,host.unit);
			border.leftStyle = 'solid';
			_buttonsLayoutStyles = [
				new Display('inline-flex'),
				padding,
				border,
				new AlignItems('center'),
				new JustifyContent('center')
			];
		}
		
		private var _buttonsLayoutStyles:Array;
		public function get buttonsLayoutStyles():Array
		{
			if(!_buttonsLayoutStyles)
				createButtonsLayoutStyles();
			return _buttonsLayoutStyles;
		}
		
		private function getButtonHoverColor():BackgroundColor{
			var colorState:String = getHostFlavorColor();
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet ;
			var backgroundColor:ColorSwatch = getBackgroundShade(colorSet,colorState);
			return new BackgroundColor(colorSet.getContrastSwatch(backgroundColor).getVariant(NaN,20));
		}
		
		private function createCloseButton():void{
			var multiplier:Number = getMultiplier();
			var closeButton:Button = new Button();
			var dimension:String = computeSize(20 * multiplier, host.unit)
			closeButton.setStyles([
				new WidthStyle(dimension),
				new HeightStyle(dimension),
				new Display('flex'),
				new AlignItems('center'),
				new JustifyContent('center'),
				new BackgroundColor('transparent'),
				new TextColor('inherit'),
				new BorderRadius('full'),
				new Transition(),
				new HoverState([
					getButtonHoverColor()
				])
			])
			var icon:Icon = Icons.cross_Small();
		
			icon.setStyles([
					new Flex(1)
			])
			closeButton.addElement(icon);
			_closeButton = closeButton;
		}
		
		private var _closeButton:Button;
		public function getCloseButton():IStyleUIBase{
			if (!_closeButton)
				createCloseButton();
			return _closeButton;
		}
		
		public function getActionButton(action:String):IStyleUIBase{
			var button:Button = new Button();
			COMPILE::JS{
				button.element.textContent = action;
			}
			var multiplier:Number = getMultiplier();
			var padding:Padding = new Padding(computeSize(multiplier * 2, host.unit), host.unit);
			padding.inline = computeSize(8 * multiplier,host.unit);
			button.setStyles([
				new BackgroundColor('transparent'),
				padding,
				new BorderRadius('full'),
				new TextColor('inherit'), //button natively has its own text styles so we need to force inherit here to share our text styling
				new FontSize('inherit'),
				new FontWeight('inherit'),
				new Transition(),
				new HoverState([
					getButtonHoverColor()
				])
			]);
			return button;
		}
		
		public function getIcon(flavor:String):IStyleUIBase {
			var icon:Icon;
			switch(flavor) {
				case "error":
				case "warning":
				case "negative":
					icon = Icons.alert_medium();
					break;
				case "positive":
				case "success":
					icon = Icons.success_medium();
					break;
				case "info":
					icon = Icons.info_medium();
					break;
				default:
					icon = null
			}
			
			if (icon) {
				var multiplier:Number = getMultiplier();
				var dimension:String = computeSize(20 * multiplier, host.unit);
				icon.setStyles([
						new WidthStyle(dimension),
						new HeightStyle(dimension)
				])
			}
			return icon;
		}
	}
}