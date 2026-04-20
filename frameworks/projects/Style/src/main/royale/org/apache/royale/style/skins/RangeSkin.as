// //////////////////////////////////////////////////////////////////////////////
// 
// Licensed to the Apache Software Foundation (ASF) under one or more
// contributor license agreements.  See the NOTICE file distributed with
// this work for additional information regarding copyright ownership.
// The ASF licenses this file to You under the Apache License, Version 2.0
// (the "License"); you may not use this file except in compliance with
// the License.  You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// 
// //////////////////////////////////////////////////////////////////////////////
package org.apache.royale.style.skins
{
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.Range;
	import org.apache.royale.style.StyleSkin;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.stylebeads.border.BorderColor;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.stylebeads.border.BorderWidth;
	import org.apache.royale.style.stylebeads.interact.AccentColor;
	import org.apache.royale.style.stylebeads.sizing.WidthStyle;
	import org.apache.royale.style.stylebeads.spacing.Padding;
	import org.apache.royale.style.util.ThemeManager;

	public class RangeSkin extends StyleSkin
	{
		public function RangeSkin()
		{
			super();
		}

		private function get host():Range
		{
			return _strand as Range;
		}
		//Right now, We can't add the Sizes because the width of the Range can't be expanded and this goes against the Tailwind classes 
		//:warning: If you're using Tailwind
		// Tailwind utilities like h-10 won't affect the slider track. 
		//You still need custom CSS (or a plugin) because Tailwind doesn't style pseudo-elements like ::-webkit-slider-thumb out of the box.
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			if (_styles)
				return;
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var baseColor:ColorSwatch = (host.theme && host.theme != "default") ? colorSet.getSwatch(host.theme, 600) : colorSet.getSwatch(ThemeColorSet.NEUTRAL, 400);
			var borderColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.NEUTRAL, 300);
			var paddings:Padding = new Padding();
			var sliderWidth:String = computeSize(192, host.unit);
			paddings.padding = computeSize(12, host.unit);
			_styles = [
					new WidthStyle(sliderWidth),
					new BorderWidth("1px"),
					new BorderColor(borderColor),
					paddings,
					new AccentColor(baseColor)
				];
				host.setStyles(_styles);
		}
	}
}