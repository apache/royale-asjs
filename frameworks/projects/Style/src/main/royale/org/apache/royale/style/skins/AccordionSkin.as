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
	import org.apache.royale.style.Accordion;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.stylebeads.layout.Overflow;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.stylebeads.border.Border;
	import org.apache.royale.style.stylebeads.border.BorderColor;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.stylebeads.border.BorderWidth;

	public class AccordionSkin extends StyleSkin implements IAccordionSkin
	{
		public function AccordionSkin()
		{
			super();
		}
		/**
		 * @royaleignorecoercion org.apache.royale.style.Accordion
		 */
		private function get host():Accordion
		{
			return _strand as Accordion;
		}
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			// Manually set. Don't create the default ones.
			if(_styles)
				return;
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var borderColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.NEUTRAL,300);
			_styles = [
				new Overflow("hidden"),
				new BorderRadius("xl"),
				new BorderWidth(1),
				new BorderColor(borderColor)
				//TODO dark mode dark:border-slate-700
// overflow-hidden rounded-xl border border-slate-300 dark:border-slate-700	
			];
			host.setStyles(_styles);
		}
	}
}