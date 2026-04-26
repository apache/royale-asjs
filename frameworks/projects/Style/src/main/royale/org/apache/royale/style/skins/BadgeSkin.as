// ///////////////////////////////////////////////////////////////////////////////
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
// ///////////////////////////////////////////////////////////////////////////////
package org.apache.royale.style.skins
{
    import org.apache.royale.style.StyleSkin;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.style.StyleUIBase;
    import org.apache.royale.style.colors.ColorSwatch;
    import org.apache.royale.style.colors.ThemeColorSet;
    import org.apache.royale.style.stylebeads.layout.Display;
    import org.apache.royale.style.stylebeads.flexgrid.AlignItems;
    import org.apache.royale.style.stylebeads.background.BackgroundColor;
    import org.apache.royale.style.stylebeads.border.Border;
    import org.apache.royale.style.stylebeads.spacing.Padding;
    import org.apache.royale.style.stylebeads.typography.FontSize;
    import org.apache.royale.style.stylebeads.typography.FontWeight;
    import org.apache.royale.style.stylebeads.typography.TextColor;
    import org.apache.royale.style.util.ThemeManager;

    public class BadgeSkin extends StyleSkin
    {
        public function BadgeSkin()
        {
            super();
        }

        /**
         * @royaleignorecoercion org.apache.royale.style.StyleUIBase
         */
        override public function set strand(value:IStrand):void
        {
            super.strand = value;
            if (_styles)
                return;
            var host:StyleUIBase = _strand as StyleUIBase;
            var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
            if ((host.theme && host.theme != "default")) {
                var bgColor:ColorSwatch = colorSet.getSwatch(host.theme);
                var tColor:ColorSwatch = colorSet.getContrastSwatch(bgColor);
            }
            var borderColor:ColorSwatch = (host.theme && host.theme != "default") ? colorSet.getSwatch(host.theme, 400) : colorSet.getSwatch(ThemeColorSet.NEUTRAL, 100);
            var border:Border = new Border(borderColor.colorSpecifier, "solid", "1px", "md");
            var padding:Padding = new Padding();
            padding.inline = computeSize(10, host.unit);
            padding.top = computeSize(2, host.unit);
            padding.bottom = computeSize(2, host.unit);
            _styles = [
                new Display("inline-flex"),
                new AlignItems("center"),
                border,
                padding,
                new FontSize(host.size)
            ];
            if (bgColor) {
                _styles.push(
                    new BackgroundColor(bgColor)
                );
            }
            if (tColor) {
                _styles.push(
                    new TextColor(tColor)
                );
            }
            host.setStyles(_styles);
        }
    }
}