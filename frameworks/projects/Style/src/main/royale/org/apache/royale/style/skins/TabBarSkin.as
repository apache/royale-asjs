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
	import org.apache.royale.style.TabBar;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.flexgrid.AlignItems;
	import org.apache.royale.style.stylebeads.flexgrid.FlexWrap;
	import org.apache.royale.style.stylebeads.border.Border;
	import org.apache.royale.style.stylebeads.border.BorderWidth;

	public class TabBarSkin extends StyleSkin
	{
		public function TabBarSkin()
		{
			super();
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.TabBar
		 */
		private function get host():TabBar
		{
			return _strand as TabBar;
		}

		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			applyStyles();
		}

		private function applyStyles():void
		{
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var borderColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 200);

			var border:Border = new Border();
			border.bottomColor = borderColor.colorSpecifier;
			border.bottomStyle = "solid";

			var borderWidth:BorderWidth = new BorderWidth();
			borderWidth.bottom = 1;

			_styles = [
				new Display("flex"),
				new AlignItems("end"),
				new FlexWrap("wrap"),
				borderWidth,
				border
			];
			host.setStyles(_styles);
		}
	}
}
