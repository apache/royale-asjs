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
	import org.apache.royale.style.elements.Label;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.stylebeads.flexgrid.AlignItems;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.spacing.Margin;
	import org.apache.royale.style.stylebeads.spacing.Padding;
	import org.apache.royale.style.stylebeads.typography.FontSize;
	import org.apache.royale.style.stylebeads.typography.TextColor;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.core.IStrand;

	public class LabelSkin extends StyleSkin implements ILabelSkin
	{
		public function LabelSkin()
		{
			super();
		}
		private function get host():Label
		{
			return _strand as Label;
		}
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			var spacing:Margin = new Margin(1);
			_styles = [
				new Display("inline-flex"),
				new AlignItems("center"),
				spacing
			];
			host.setStyles(_styles);
		}
		private var _labelStyles:Array;
		public function get labelStyles():Array
		{
			if (!_labelStyles) {
				createLabelStyles();
			}
			return _labelStyles;
		}
		private function createLabelStyles():void
		{
			var appliedSize:Object = getAppliedSize(host.size);
			var pad:Padding = new Padding();
			pad.inline = computeSize(appliedSize.inline, host.unit);
			pad.top = computeSize(appliedSize.block, host.unit);
			pad.bottom = computeSize(appliedSize.block, host.unit);
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var bgColor:ColorSwatch = (host.theme && host.theme != "default") ? colorSet.getSwatch(host.theme) : colorSet.getSwatch(ThemeColorSet.NEUTRAL);
			_labelStyles = [
				new BorderRadius("sm"),
				pad,
				new FontSize(appliedSize.textSize),
				new TextColor("white"),
				new BackgroundColor(bgColor)
			];
		}
		private function getAppliedSize(size:String):Object
		{
			switch (size) {
				case "xs":
					return {inline: 8, block: 3, textSize: "10px"};
				case "sm":
					return {inline: 10, block: 4, textSize: "11px"};
				case "md":
					return {inline: 12, block: 5, textSize: "12px"};
				case "lg":
					return {inline: 14, block: 6, textSize: "14px"};
				case "xl":
					return {inline: 16, block: 7, textSize: "16px"};
				default:
					return {inline: 12, block: 5, textSize: "12px"};
			}
		}
	}
}
