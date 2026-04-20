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
	import org.apache.royale.style.MenuItem;
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

	public class MenuItemSkin extends StyleSkin
	{
		public function MenuItemSkin()
		{
			super();
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.MenuItem
		 */
		override public function set strand(value:IStrand):void
		{
			var item:MenuItem = value as MenuItem;
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var hoverBg:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 300);

			var padding:Padding = new Padding();
			padding.block = computeSize(8, item.unit);
			padding.inline = computeSize(12, item.unit);

			_styles = [
				new Display("flex"),
				new AlignItems("center"),
				padding,
				new BorderRadius(computeSize(8, item.unit)),
				new Cursor("pointer"),
				new HoverState([
					new BackgroundColor(hoverBg.colorSpecifier)
				])
			];

			super.strand = value;
		}
	}
}
