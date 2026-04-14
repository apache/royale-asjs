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
	import org.apache.royale.style.Card;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.layout.Overflow;
	import org.apache.royale.style.stylebeads.flexgrid.FlexDirection;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.border.Border;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.stylebeads.states.attribute.DataState;

	public class CardSkin extends StyleSkin
	{
		public function CardSkin()
		{
			super();
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.Card
		 */
		private function get host():Card
		{
			return _strand as Card;
		}

		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			applyStyles();
		}

		private function applyStyles():void
		{
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var bgColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 0);
			var borderColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 200);

			var defaultBorder:Border = new Border();
			defaultBorder.color = borderColor.colorSpecifier;
			defaultBorder.style = "solid";
			defaultBorder.width = "1px";

			var dashBorder:Border = new Border();
			dashBorder.color = borderColor.colorSpecifier;
			dashBorder.style = "dashed";
			dashBorder.width = "1px";

			if(!_styles)
			{
				_styles = [
					new Display("flex"),
					new FlexDirection("column"),
					new Overflow("hidden"),
					new BorderRadius(computeSize(8, host.unit)),
					new BackgroundColor(bgColor.colorSpecifier),
					defaultBorder,
					new DataState("dash", [
						dashBorder
					])
				];
				host.setStyles(_styles);
			}
		}
	}
}
