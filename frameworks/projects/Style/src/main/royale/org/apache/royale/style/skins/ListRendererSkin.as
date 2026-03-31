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
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.flexgrid.FlexDirection;
	import org.apache.royale.style.stylebeads.flexgrid.AlignItems;
	import org.apache.royale.style.stylebeads.flexgrid.Gap;
	import org.apache.royale.style.stylebeads.flexgrid.JustifyContent;
	import org.apache.royale.style.stylebeads.flexgrid.RowGap;
	import org.apache.royale.style.stylebeads.typography.TextSize;
	import org.apache.royale.style.stylebeads.typography.FontWeight;
	import org.apache.royale.style.stylebeads.spacing.Margin;
	import org.apache.royale.style.stylebeads.states.HoverState;
	import org.apache.royale.style.stylebeads.interact.Cursor;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.states.attribute.SelectedState;
	import org.apache.royale.style.stylebeads.typography.TextColor;
	import org.apache.royale.style.IStyleUIBase;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.stylebeads.spacing.Padding;

	public class ListRendererSkin extends StyleSkin
	{
		public function ListRendererSkin()
		{
			super();
		}
		/**
		 * @royaleignorecoercion org.apache.royale.style.IStyleUIBase
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			if(_styles)
				return;

			var host:IStyleUIBase = value as IStyleUIBase;
			// var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			// var colorName:String = host ? host.theme : ThemeColorSet.NEUTRAL;
			// var selectedColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.PRIMARY,500);
			// var enabledBorder:ColorSwatch = colorSet.getSwatch(ThemeColorSet.NEUTRAL,500);

			var selectedColor:ColorSwatch = new ColorSwatch("slate",800);
			var hoverColor:ColorSwatch = selectedColor.getVariant(100);
			var textColor:ColorSwatch = new ColorSwatch("slate",800);
			var selectedTextColor:ColorSwatch = selectedColor.isDark() ? textColor.getVariant(50) : textColor.getVariant(900);
			var padding:Padding = new Padding();
			padding.block = 1;
			padding.inline = .75;
			_styles = [
				new Display("flex"),
				new FlexDirection("row"),
				new AlignItems("center"),
				new JustifyContent("start"),
				new RowGap(1),
				padding,
				new TextSize("sm"),
				new FontWeight("normal"),
				new Cursor("pointer"),
				new BackgroundColor("transparent"),
				new TextColor(textColor),
				new HoverState([
					new BackgroundColor(hoverColor),
				]),
				new SelectedState([
					new BackgroundColor(selectedColor),
					new TextColor(selectedTextColor)
				])
			];
			host.setStyles(styles);
		}
	}
}
/**
 * border-radius: var(--radius-field);
      text-align: start;
      text-wrap: balance;
      -webkit-user-select: none;
      user-select: none;
      grid-auto-columns: minmax(auto,max-content) auto max-content;
      grid-auto-flow: column;
      align-content: flex-start;
      align-items: center;
      gap: .5rem;
      padding-block: .375rem;
      padding-inline: .75rem;
      transition-property: color,background-color,box-shadow;
      transition-duration: .2s;
      transition-timing-function: cubic-bezier(0,0,.2,1);
      display: grid;
			layer utilities {
  @layer daisyui.l1.l2 {
    :where(:not(ul, details, .menu-title, .btn)).menu-active {
      color: var(--menu-active-fg);
      background-color: var(--menu-active-bg);
      background-size: auto,calc(var(--noise)*100%);
      background-image: none,var(--fx-noise);
    }
  }
@layer utilities {
  @layer daisyui.l1.l2.l3 {
    @supports (color:color-mix(in lab,red,red)) {
      .menu :where(li:not(.menu-title, .disabled) > :not(ul, details, .menu-title):not(.menu-active, :active, .btn):hover, li:not(.menu-title, .disabled) > details > summary:not(.menu-title):not(.menu-active, :active, .btn):hover) {
        background-color: color-mix(in oklab,var(--color-base-content)10%,transparent);
      }
    }
  }
}
    list-style-type: none;
    margin-top: 4px;
    margin-bottom: 4px;
    margin-left: 0px;
    margin-right: 0px;
		font-size: 14px;
    font-weight: 400;
    line-height: 1.5;
    font-style: normal;
		.spectrum--light, .spectrum--light .spectrum-Body {
    color: rgb(75, 75, 75);

    position: relative;
    display: inline-flex;
    align-items: center;
    justify-content: left;
    box-sizing: border-box;
    width: 100%;
    min-height: 32px;
    padding-left: 12px;
    padding-right: 12px;
    padding-top: 5px;
    padding-bottom: 5px;
    font-size: 14px;
    font-weight: 400;
    font-style: normal;
    word-break: break-word;
    hyphens: auto;
    cursor: pointer;
    border-radius: 4px;
    text-decoration: none;
    transition: background-color 130ms ease-out, color 130ms ease-out;
}
 */