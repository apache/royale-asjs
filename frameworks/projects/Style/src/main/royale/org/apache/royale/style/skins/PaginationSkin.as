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
	import org.apache.royale.style.Pagination;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.layout.Overflow;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.stylebeads.border.Border;
	import org.apache.royale.style.stylebeads.border.BorderWidth;
	import org.apache.royale.style.stylebeads.typography.FontSize;

	public class PaginationSkin extends StyleSkin
	{
		public function PaginationSkin()
		{
			super();
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.Pagination
		 */
		private function get host():Pagination
		{
			return _strand as Pagination;
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

				var border:Border = new Border();
				border.color = borderColor.colorSpecifier;
				border.style = "solid";

				var borderWidth:BorderWidth = new BorderWidth();
				borderWidth.width = 1;

				_styles = [
					new Display("inline-flex"),
					new Overflow("hidden"),
					new BorderRadius(computeSize(12, host.unit)), // rounded-xl (0.75rem)
					borderWidth,
					border,
					new FontSize(host.size || "base")
				];
				host.setStyles(_styles);
			}
		}
	}
}
