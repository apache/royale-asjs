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
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.StyleSkin;
	import org.apache.royale.style.AccordionContent;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.stylebeads.spacing.Padding;
	import org.apache.royale.style.stylebeads.typography.TextSize;
	import org.apache.royale.style.stylebeads.typography.TextColor;

	public class AccordionContentSkin extends StyleSkin
	{
		public function AccordionContentSkin()
		{
			super();
		}
		/**
		 * @royaleignorecoercion org.apache.royale.style.AccordionContent
		 */
		private function get host():AccordionContent
		{
			return _strand as AccordionContent;
		}
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			// Manually set. Don't create the default ones.
			if(_styles)
				return;
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var textColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.NEUTRAL,600);
			var padding:Padding = new Padding();
			padding.bottom = 3;
			_styles = [
				padding,
				new TextSize("sm"),
				new TextColor(textColor)
				//TODO dark mode dark:border-slate-300
				// pb-3 text-sm text-slate-600 dark:text-slate-300
			];
			host.setStyles(_styles);
		}
	}
}