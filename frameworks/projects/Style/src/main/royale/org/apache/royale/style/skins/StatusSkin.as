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
	import org.apache.royale.style.StyleSkin;
	import org.apache.royale.style.Status;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.stylebeads.border.Outline;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.layout.Overflow;
	import org.apache.royale.style.stylebeads.layout.Position;
	import org.apache.royale.style.stylebeads.layout.Left;
	import org.apache.royale.style.stylebeads.layout.Top;
	import org.apache.royale.style.stylebeads.sizing.HeightStyle;
	import org.apache.royale.style.stylebeads.sizing.WidthStyle;
	import org.apache.royale.style.stylebeads.typography.VerticalAlign;
	import org.apache.royale.style.stylebeads.effects.OpacityStyle;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.util.ThemeManager;

	public class StatusSkin extends StyleSkin
	{
		public function StatusSkin()
		{
			super();
		}

		private function get host():Status
		{
			return _strand as Status;
		}
		// Currently using the simplest implementation.
		// There are additional styling options available for the status indicator
		// (e.g. different animations, and visual effects)
		// clsses:
		// <span class="relative inline-block h-2 w-2 overflow-hidden animate-bounce rounded-full bg-[#3abff8] shadow-[0_2.8px_3.5px_-0.7px_rgba(15,23,42,0.22)] after:absolute after:left-[18%] after:top-[16%] after:h-[38%] after:w-[38%] after:rounded-full after:bg-white/60 after:blur-[1.4px] after:content-['']"></span>
		// <span class="relative inline-flex h-2 w-2 overflow-hidden rounded-full bg-[#f87272] shadow-[0_2.8px_3.5px_-0.7px_rgba(15,23,42,0.22)] after:absolute after:left-[18%] after:top-[16%] after:h-[38%] after:w-[38%] after:rounded-full after:bg-white/60 after:blur-[1.4px] after:content-['']"></span>
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			if (_styles)
				return;
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var baseColor:ColorSwatch = (host.theme && host.theme != "default") ? colorSet.getSwatch(host.theme, 600) : colorSet.getSwatch(ThemeColorSet.NEUTRAL, 300);
			_styles = [
					new Position("relative"),
					new Display("inline-block"),
					new HeightStyle(getSize() + "px"),
					new WidthStyle(getSize() + "px"),
					new Overflow("hidden"),
					new BorderRadius("9999px"),
					new VerticalAlign("middle"),
					new BackgroundColor(baseColor),
				];

			host.setStyles(_styles);
		}
		private function getSize():Number
		{
			switch (host.size)
			{
				case "xs":
					return 4;
				case "sm":
					return 6;
				case "md":
					return 9;
				case "lg":
					return 11;
				case "xl":
					return 13;
				default:
					return 9;
			}
		}
	}
}
