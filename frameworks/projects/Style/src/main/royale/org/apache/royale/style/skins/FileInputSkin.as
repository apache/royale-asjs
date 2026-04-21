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
    import org.apache.royale.core.IStrand;
    import org.apache.royale.style.StyleSkin;
    import org.apache.royale.style.StyleUIBase;
    import org.apache.royale.style.colors.ColorSwatch;
    import org.apache.royale.style.colors.ThemeColorSet;
    import org.apache.royale.style.stylebeads.background.BackgroundColor;
    import org.apache.royale.style.stylebeads.border.Border;
    import org.apache.royale.style.stylebeads.border.Outline;
    import org.apache.royale.style.stylebeads.interact.Cursor;
    import org.apache.royale.style.stylebeads.sizing.MaxWidth;
    import org.apache.royale.style.stylebeads.spacing.Margin;
    import org.apache.royale.style.stylebeads.spacing.Padding;
    import org.apache.royale.style.stylebeads.states.FocusState;
    import org.apache.royale.style.stylebeads.states.pseudo.FileState;
    import org.apache.royale.style.stylebeads.typography.FontSize;
    import org.apache.royale.style.stylebeads.typography.FontWeight;
    import org.apache.royale.style.util.ThemeManager;
    import org.apache.royale.style.stylebeads.border.BorderColor;

    public class FileInputSkin extends StyleSkin
    {
        public function FileInputSkin()
        {
            super();
        }

        override public function set strand(value:IStrand):void
        {
            super.strand = value;
            if (_styles)
                return;
            var host:StyleUIBase = _strand as StyleUIBase;
            var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
            var fileTextColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.NEUTRAL, 700);
            var borderColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.NEUTRAL, 200);
            var filebgColor:ColorSwatch;
            var fileMargin:Margin = new Margin();
            fileMargin.inlineEnd = 4;
            var filePadding:Padding = new Padding();
            filePadding.inline = 3;
            filePadding.block = 2;
            var fileBorder:Border = new Border();
            fileBorder.inlineEndWidth = 0.25;
            fileBorder.color = borderColor.colorSpecifier;
            var focusOutline:Outline = new Outline();
            focusOutline.width = "2px";
            focusOutline.style = "solid";
            focusOutline.color = borderColor.colorSpecifier;
            focusOutline.offset = "0";
            var fontSize:FontSize = new FontSize(host.size);
            var fileState:FileState = new FileState([
                fileMargin,
                new Cursor("pointer"),
                fileBorder,
                filePadding,
                new FontWeight("semibold")
            ]);
            if (host.theme && host.theme != "default") {
                borderColor = filebgColor = colorSet.getSwatch(host.theme, 400);
                fileState.styles.push(
                    new BorderColor(colorSet.getContrastSwatch(filebgColor)),
                    new BackgroundColor(filebgColor)
                );
            } 
            _styles = [
                new MaxWidth("24rem"),
                new Cursor("pointer"),
                new Border(borderColor.colorSpecifier, "solid", "1px", "md"),
                fontSize,
                new FocusState([
                    focusOutline
                ]),
                fileState
            ];
            host.setStyles(_styles);
        }
    }
}