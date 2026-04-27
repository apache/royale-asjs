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
	import org.apache.royale.style.Modal;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.stylebeads.spacing.Padding;
	import org.apache.royale.style.stylebeads.sizing.MaxWidth;
	import org.apache.royale.style.stylebeads.layout.Overflow;
	import org.apache.royale.style.stylebeads.effects.OpacityStyle;
	import org.apache.royale.style.stylebeads.states.pseudo.BackdropState;

	public class ModalSkin extends StyleSkin
	{
		public function ModalSkin()
		{
			super();
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.Modal
		 */
		private function get host():Modal
		{
			return _strand as Modal;
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
				var bgColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 0);

				var padding:Padding = new Padding();
				padding.padding = computeSize(24, host.unit);

				var backdropColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 900);

				_styles = [
					new BackgroundColor(bgColor.colorSpecifier),
					new BorderRadius(computeSize(16, host.unit)),
					padding,
					new MaxWidth(computeSize(448, host.unit)), // Tailwind max-w-md (28rem)
					new Overflow("auto"),
					new BackdropState([
						new BackgroundColor(backdropColor.colorSpecifier),
						new OpacityStyle(40)
					])
				];
				host.setStyles(_styles);
			}
		}
	}
}
