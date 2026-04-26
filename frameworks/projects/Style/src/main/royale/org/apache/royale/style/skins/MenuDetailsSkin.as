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
	import org.apache.royale.style.MenuDetails;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.flexgrid.AlignItems;
	import org.apache.royale.style.stylebeads.spacing.Padding;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.stylebeads.interact.Cursor;
	import org.apache.royale.style.stylebeads.states.HoverState;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.typography.ListStyleType;
	import org.apache.royale.style.stylebeads.sizing.HeightStyle;
	import org.apache.royale.style.stylebeads.sizing.WidthStyle;
	import org.apache.royale.style.stylebeads.typography.TextColor;
	import org.apache.royale.style.stylebeads.anim.Transition;
	import org.apache.royale.style.stylebeads.anim.TransitionDuration;
	import org.apache.royale.style.stylebeads.states.attribute.DataState;
	import org.apache.royale.style.stylebeads.transform.Rotate;
	import org.apache.royale.style.stylebeads.flexgrid.JustifyContent;
	import org.apache.royale.style.Icon;
	import org.apache.royale.style.IStyleUIBase;

	public class MenuDetailsSkin extends StyleSkin implements IMenuDetailsSkin
	{
		public function MenuDetailsSkin()
		{
			super();
		}

		private var _summaryStyles:Array;

		/**
		 * @royaleignorecoercion org.apache.royale.style.MenuDetails
		 */
		override public function set strand(value:IStrand):void
		{
			var item:MenuDetails = value as MenuDetails;
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var hoverBg:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 300);

			var padding:Padding = new Padding();
			padding.block = computeSize(8, item.unit);
			padding.inline = computeSize(12, item.unit);

			_summaryStyles = [
				new Display("flex"),
				new AlignItems("center"),
				new JustifyContent("space-between"),
				new ListStyleType("none"),
				padding,
				new BorderRadius(computeSize(8, item.unit)),
				new Cursor("pointer"),
				new HoverState([
					new BackgroundColor(hoverBg.colorSpecifier)
				])
			];

			super.strand = value;
		}

		public function get summaryStyles():Array
		{
			return _summaryStyles;
		}

		public function getIcon():IStyleUIBase
		{
			var markup:XML = <svg viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="2"><path d="M7 5l5 5-5 5" stroke-linecap="round" stroke-linejoin="round"/></svg>
			var iconName:String = "menu-arrow-icon";
			Icon.registerIcon(iconName, markup);
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var textColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 500);
			var icon:Icon = new Icon(iconName);
			icon.styleBeads = [
				new HeightStyle(4),
				new WidthStyle(4),
				new TextColor(textColor),
				new Transition("transform"),
				new TransitionDuration(200),
				new DataState("open", [
					new Rotate(90)
				])
			];
			return icon;
		}
	}
}
