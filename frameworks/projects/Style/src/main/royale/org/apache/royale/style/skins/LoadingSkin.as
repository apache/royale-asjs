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
    import org.apache.royale.style.colors.ThemeColorSet;
    import org.apache.royale.style.stylebeads.anim.Animation;
    import org.apache.royale.style.stylebeads.border.Border;
    import org.apache.royale.style.stylebeads.sizing.HeightStyle;
    import org.apache.royale.style.stylebeads.sizing.WidthStyle;
    import org.apache.royale.style.util.ThemeManager;
    import org.apache.royale.style.Loading;
    import org.apache.royale.style.colors.ColorSwatch;

    public class LoadingSkin extends StyleSkin
    {
        public function LoadingSkin()
        {
            super();
        }
        override public function set strand(value:IStrand):void
        {
            super.strand = value;
            if (_styles)
                return;
            var host:Loading = _strand as Loading;
            var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
            var spinnerSize:String = computeSize(getSpinnerSize(host), host.unit);
            var spinnerColor:ColorSwatch = (host.theme && host.theme != "default") ?  colorSet.getSwatch(host.theme, 500) : colorSet.getSwatch(ThemeColorSet.NEUTRAL, 900);
            var border:Border = new Border();
            border.width = computeSize(3, host.unit);
            border.color = "transparent";
            border.topColor =  border.rightColor = spinnerColor.colorSpecifier;
            border.radius = "full";
            _styles = [
                new HeightStyle(spinnerSize),
                new WidthStyle(spinnerSize),
				new Animation(host.animation || "spin"),
                border
            ];
            host.setStyles(_styles);
        }

		private function getSpinnerSize(host:StyleUIBase):Number
		{
			switch(host.size)
			{
				case "xs":
					return 12;
				case "sm":
					return 16;
				case "lg":
					return 24;
                case "xl":
                    return 32;
				case "md":
				default:
					return 20;
			}
		}
    }
}