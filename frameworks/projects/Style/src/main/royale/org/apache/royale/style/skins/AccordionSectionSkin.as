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
	import org.apache.royale.style.AccordionSection;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.IStyleUIBase;
	import org.apache.royale.style.Icon;
	import org.apache.royale.style.stylebeads.sizing.HeightStyle;
	import org.apache.royale.style.stylebeads.sizing.WidthStyle;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.stylebeads.typography.TextColor;
	import org.apache.royale.style.stylebeads.anim.Transition;
	import org.apache.royale.style.stylebeads.anim.TransitionDuration;
	import org.apache.royale.style.stylebeads.states.attribute.DataState;
	import org.apache.royale.style.stylebeads.transform.Rotate;
	import org.apache.royale.style.stylebeads.border.Border;
	import org.apache.royale.style.stylebeads.border.BorderWidth;
	import org.apache.royale.style.stylebeads.border.BorderColor;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.states.LastState;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.interact.Cursor;
	import org.apache.royale.style.stylebeads.typography.ListStyleType;
	import org.apache.royale.style.stylebeads.flexgrid.AlignItems;
	import org.apache.royale.style.stylebeads.flexgrid.JustifyContent;
	import org.apache.royale.style.stylebeads.spacing.Padding;
	import org.apache.royale.style.stylebeads.typography.TextSize;
	import org.apache.royale.style.stylebeads.typography.FontWeight;

	public class AccordionSectionSkin extends StyleSkin implements IAccordionSectionSkin
	{
		public function AccordionSectionSkin()
		{
			super();
		}
		/**
		 * @royaleignorecoercion org.apache.royale.style.AccordionSection
		 */
		private function get host():AccordionSection
		{
			return _strand as AccordionSection;
		}
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			// Manually set. Don't create the default ones.
			if(_styles)
				return;

			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var borderColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.NEUTRAL,300);
			var bgColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.NEUTRAL,50);
			var border:BorderWidth = new BorderWidth();
			border.bottom = 1;
			var lastBorder:BorderWidth = new BorderWidth();
			lastBorder.bottom = 0;
			_styles = [
				border,
				new BorderColor(borderColor),
				new BackgroundColor(bgColor),
				new TextColor(borderColor),
				new LastState([
					lastBorder
				])
				//TODO dark mode dark:border-slate-700 dark:bg-slate-800
				// group border-b border-slate-300 bg-slate-50 px-4 last:border-b-0 dark:border-slate-700 dark:bg-slate-800
			];
			host.setStyles(_styles);
		}

		private var _headerStyles:Array;

		public function get headerStyles():Array
		{
			if(!_headerStyles)
			{
				var padding:Padding = new Padding();
				padding.block = 3;
				_headerStyles = [
					new Display("flex"),
					new Cursor("pointer"),
					new ListStyleType("none"),
					new AlignItems("center"),
					new JustifyContent("space-between"),
					padding,
					new TextSize("sm"),
					new FontWeight("semibold")
				];
				// flex cursor-pointer list-none items-center justify-between py-3 text-sm font-semibold
			}
			return _headerStyles;
		}

		public function set headerStyles(value:Array):void
		{
			_headerStyles = value;
		}
		public function getIcon():IStyleUIBase
		{
			var markup:XML = <svg viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="2"><path d="M7 5l5 5-5 5" stroke-linecap="round" stroke-linejoin="round"/></svg>
			var iconName:String = "accordion-arrow-icon";
			Icon.registerIcon(iconName, markup);
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var textColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.NEUTRAL,500);
			var icon:Icon = new Icon(iconName);
			icon.styleBeads = [
				new HeightStyle(4),
				new WidthStyle(4),
				new TextColor(textColor),
				new Transition("transform"),
				new TransitionDuration(200),
				new DataState("open"[
					new Rotate(90)
				])

				// h-4 w-4 text-slate-500 transition-transform duration-200 group-open:rotate-90
			];
			return icon;
		}
	}
}