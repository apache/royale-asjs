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
	import org.apache.royale.style.RadialProgress;
	import org.apache.royale.style.StyleSkin;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.StyleUIBase;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.stylebeads.anim.Transition;
	import org.apache.royale.style.stylebeads.background.BackgroundPosition;
	import org.apache.royale.style.stylebeads.background.BackgroundRepeat;
	import org.apache.royale.style.stylebeads.border.BorderColor;
	import org.apache.royale.style.stylebeads.flexgrid.PlaceContent;
	import org.apache.royale.style.stylebeads.layout.BoxSizing;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.interact.UserSelect;
	import org.apache.royale.style.stylebeads.layout.Inset;
	import org.apache.royale.style.stylebeads.layout.Position;
	import org.apache.royale.style.stylebeads.sizing.HeightStyle;
	import org.apache.royale.style.stylebeads.sizing.WidthStyle;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.stylebeads.typography.TextColor;
	import org.apache.royale.style.stylebeads.typography.VerticalAlign;
	import org.apache.royale.style.util.StyleManager;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.spacing.Padding;
	import org.apache.royale.style.util.ThemeManager;
	
	
	public class RadialProgressSkin extends StyleSkin implements IRadialProgressSkin
	{
		
		private static const radialProgress:String = '--radialProgress'; //this will be a declared @property - for use in transitions
		private static const thickness:String = '--rp_thickness';
		private static const size:String = '--rp_size';
		private static const value:String = '--rp_value';
		
		private static const nominalPxSize:uint = 80;
		
		private static function cssVar(varName:String):String{
			return 'var('+varName+')'
		}
		
		private static function standardiseTransition(transition:Transition):void{
			transition.duration = '300ms';
			transition.timingFunction = 'linear';
		}
		
		private static var propertyDefined:Boolean;
		
		/**
		 * this creates the custom rotation-centric property that is used in transitions.
		 */
		private static function createProperty():void{
			propertyDefined = StyleManager.addCustomProperty(radialProgress,'<angle>',true,'0deg'); //using angle instead of percentage to have common transition property
		}
		
		public function RadialProgressSkin()
		{
			super();
			if (!propertyDefined) createProperty();
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.style.RadialProgress
		 */
		private function get host():RadialProgress
		{
			return _strand as RadialProgress;
		}
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			applyStyles();
		}
		
		public function setColors():void{
			var foreground:String = host.flavor;
			if (foreground == 'default') foreground = 'base';
			const colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			const background:String = host.background;
			const backgroundColor:BackgroundColor = new BackgroundColor();
			const borderColor:BorderColor = new BorderColor();
			const foregroundColor:TextColor = new TextColor(colorSet.getSwatch(foreground,900))
			
			var styles:Array = [foregroundColor,backgroundColor,borderColor];
			//some arbitrary color rules - may need revision:
			if (background != 'default') {
				var color:ColorSwatch = colorSet.getSwatch(background,400);
				backgroundColor.value = borderColor.value = color;
				if (background == foreground) {
					foregroundColor.value = colorSet.getSwatch(foreground,900);
				} else {
					foregroundColor.value = colorSet.getSwatch(foreground,600);
				}
			} else {
				backgroundColor.value = borderColor.value = 'transparent';
				if (foreground == 'base') {
					foregroundColor.value = colorSet.getSwatch(foreground,900);
				} else {
					foregroundColor.value = colorSet.getSwatch(foreground,500);
				}
			}
			host.setStyles(styles,true);
		}
		
		public function setSize():void{
			const nominalSize:uint = nominalPxSize;
			const multiplier:Number= getMultiplier();
			var hostUnit:String = host.unit;
			var calcSize:String;
			var customSize:Number = host.customSize;
			if (customSize) {
				calcSize = customSize + hostUnit;
			} else {
				calcSize = computeSize(nominalSize * multiplier,hostUnit);
			}
			
			host.setStyleProperty(size, calcSize);
		}
		
		public function applyThickNess():void{
			var ratio:Number = host.thickness/200;
			host.setStyleProperty(thickness,'calc('+cssVar(size) + ' * '+ratio+')');
		}
		
		public function processValue():void{
			var setVal:Number = host.value;
			host.setStyleProperty(value,setVal);
		}
		
		private function applyStyles():void
		{
			setSize();
			setColors();
			applyThickNess();
			processValue();
			
			var transparentBorder:BorderColor = new BorderColor();
			transparentBorder.value = 'transparent';
			
			var radialContainerStyles:Array = [
					new UserSelect('none'),
					new Position('relative'),
					new WidthStyle(cssVar(size)),
					new HeightStyle(cssVar(size)),
					new VerticalAlign('middle'),
					new Display('inline-grid'),
					new BoxSizing('content-box'),
					new BorderRadius('full'),
					new PlaceContent('center'),
					transparentBorder //by default
			];
			_styles = radialContainerStyles;
			//these are non-atomic, and unlikely to be shared for any other components anyway, so we will set it directly on the element.style:
			host.setStyleProperty(radialProgress,'calc('+cssVar(value)+' * 3.6deg)');
			
			//using this font size approach. alternate is to set to medium here, and scale inside setSize method
			host.setStyle('font-size','calc('+cssVar(size) + ' * 0.2)');
			host.setStyle('border-width', 'calc('+cssVar(size) + ' * 0.05)')
			
			host.setStyles(_styles, true);
		}
		
		public function processBackgroundRadialStyles(background:StyleUIBase):void{
			//the following seems like it does not suit the atomic declaration styling, so setting these directly on local styles:
			background.setStyle('background-image','radial-gradient(farthest-side, currentColor 98%, #0000), conic-gradient(currentColor '+cssVar(radialProgress)+', #0000 0)');
			
			background.setStyle('background-image','radial-gradient(farthest-side, currentColor 98%, #0000), conic-gradient(currentColor '+cssVar(radialProgress)+', #0000 0)');
			background.setStyle('background-position','top, center');
			background.setStyle('background-size',cssVar(thickness) + ' ' + cssVar(thickness) + ', cover')
			background.setStyle('mask','radial-gradient(farthest-side, #0000 calc(100% - '+cssVar(thickness)+'), #000 calc(100% + .5px - '+cssVar(thickness)+'))')
			
			var transition:Transition = new Transition(radialProgress);
			standardiseTransition(transition);
			
			//these appear more atomic/shareable:
			background.setStyles([
					new BorderRadius('full'),
					new BackgroundPosition('top,center'),
					new BackgroundRepeat('no-repeat'),
					new Position('absolute'),
					new Inset('0'),
					new Padding('0'),
					transition
			])
		}
		
		public function processForegroundRadialStyles(foreground:StyleUIBase):void{
			foreground.setStyle('inset','calc(50% - ' + cssVar(thickness) + ' / 2)');
			foreground.setStyle('transform','rotate(calc(' + cssVar(radialProgress) + ' - 90deg)) translate(calc('+cssVar(size)+' / 2 - 50%))');
			var transition:Transition = new Transition(radialProgress);
			standardiseTransition(transition);
			
			foreground.setStyles([
				new BorderRadius('full'),
				new Position('absolute'),
				new BackgroundColor('currentColor'),
				transition
			])
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
		
	
	}
}