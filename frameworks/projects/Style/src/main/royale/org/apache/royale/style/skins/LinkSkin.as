// //////////////////////////////////////////////////////////////////////////////
//
// Licensed to the Apache Software Foundation (ASF) under one or more
// contributor license agreements.  See the NOTICE file distributed with
// this work for additional information regarding copyright ownership.
// The ASF licenses this file to You under the Apache License, Version 2.0
// (the "License"); you may not use this file except in compliance with
// the License.  You may obtain a copy of the License at
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
    import org.apache.royale.style.Link;
    import org.apache.royale.style.StyleSkin;
    import org.apache.royale.style.colors.ColorSwatch;
    import org.apache.royale.style.colors.ThemeColorSet;
    import org.apache.royale.style.stylebeads.background.BackgroundColor;
    import org.apache.royale.style.stylebeads.border.Border;
    import org.apache.royale.style.stylebeads.border.BorderRadius;
    import org.apache.royale.style.stylebeads.effects.OpacityStyle;
    import org.apache.royale.style.stylebeads.interact.Cursor;
    import org.apache.royale.style.stylebeads.interact.PointerEvents;
    import org.apache.royale.style.stylebeads.layout.Display;
    import org.apache.royale.style.stylebeads.spacing.Padding;
    import org.apache.royale.style.stylebeads.states.DisabledState;
    import org.apache.royale.style.stylebeads.states.HoverState;
    import org.apache.royale.style.stylebeads.typography.FontSize;
    import org.apache.royale.style.stylebeads.typography.FontWeight;
    import org.apache.royale.style.stylebeads.typography.TextColor;
    import org.apache.royale.style.util.ThemeManager;
    import org.apache.royale.style.stylebeads.border.BorderWidth;
    import org.apache.royale.style.stylebeads.border.BorderColor;
    import org.apache.royale.style.stylebeads.typography.TextDecorationLine;
    import org.apache.royale.style.stylebeads.states.attribute.DataState;

    public class LinkSkin extends StyleSkin
    {
        public function LinkSkin()
        {
            super();
        }
        private function get host():Link
        {
            return _strand as Link;
        }

        override public function set strand(value:IStrand):void
        {
            super.strand = value;
            if (_styles)
                return;
            var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
            var haveTheme:Boolean = host.theme && host.theme != "default";
            var textColor:ColorSwatch = haveTheme ? colorSet.getSwatch(host.theme, 600) : colorSet.getSwatch(ThemeColorSet.NEUTRAL, 600);
            var hoverColor:ColorSwatch = haveTheme ? colorSet.getSwatch(host.theme, 800) : colorSet.getSwatch(ThemeColorSet.NEUTRAL, 800);

            _styles = [
                    new Display("inline-flex"),
                    new FontSize(host.size || "base"),
                    new FontWeight("semibold"),
                    new Cursor("pointer"),
                    new TextColor(textColor),
                    new TextDecorationLine("underline"),
                    new HoverState([
                            new TextColor(hoverColor)
                        ]),
                    new DataState("disabled", [
                            new Cursor("default"),
                            new OpacityStyle(60),
                            new PointerEvents("none"),
                            new TextColor(colorSet.getSwatch(ThemeColorSet.NEUTRAL, 400)),
                        ])
                ];
            host.setStyles(_styles);
        }
    }
}