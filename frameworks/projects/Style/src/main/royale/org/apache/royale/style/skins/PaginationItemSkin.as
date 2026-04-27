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
	import org.apache.royale.style.PaginationItem;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.border.Border;
	import org.apache.royale.style.stylebeads.border.BorderWidth;
	import org.apache.royale.style.stylebeads.spacing.Padding;
	import org.apache.royale.style.stylebeads.interact.Cursor;
	import org.apache.royale.style.stylebeads.typography.TextColor;
	import org.apache.royale.style.stylebeads.effects.OpacityStyle;
	import org.apache.royale.style.stylebeads.states.attribute.DataState;
	import org.apache.royale.style.stylebeads.states.HoverState;

	public class PaginationItemSkin extends StyleSkin
	{
		public function PaginationItemSkin()
		{
			super();
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.PaginationItem
		 */
		private function get host():PaginationItem
		{
			return _strand as PaginationItem;
		}

		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			applyStyles();
		}

		private function applyStyles():void
		{
			if(!_styles)
			{
				var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
				var borderColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 300);
				var selectedBg:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 900);
				var selectedText:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 0);
				var hoverBg:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 100);

				var borderWidth:BorderWidth = new BorderWidth();
				borderWidth.right = 1;

				var border:Border = new Border();
				border.rightColor = borderColor.colorSpecifier;
				border.rightStyle = "solid";

				var padding:Padding = new Padding();
				padding.left = computeSize(12, host.unit);
				padding.right = computeSize(12, host.unit);
				padding.top = computeSize(8, host.unit);
				padding.bottom = computeSize(8, host.unit);

				_styles = [
					new BackgroundColor("transparent"),
					borderWidth,
					border,
					padding,
					new Cursor("pointer"),
					new HoverState([
						new BackgroundColor(hoverBg.colorSpecifier)
					]),
					new DataState("selected", [
						new BackgroundColor(selectedBg.colorSpecifier),
						new TextColor(selectedText)
					]),
					new DataState("disabled", [
						new OpacityStyle(40),
						new Cursor("default")
					])
				];
				host.setStyles(_styles);
			}
		}
	}
}
