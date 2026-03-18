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
package org.apache.royale.style.util
{
	import org.apache.royale.debugging.assert;

	/**
	 * @royalesuppressexport
	 */
	public class ThemeManager
	{
		public function ThemeManager()
		{
			
		}
		private static var _instance:ThemeManager;
		public static function get instance():ThemeManager
		{
			if(!_instance)
			{
				_instance = new ThemeManager();
				// Set css preflight defaults. These are the same as Tailwind's preflight defaults.
				// See https://tailwindcss.com/docs/preflight for more details.
				//TODO make this more PAYG
				StyleManager.addStyle("img, svg, video, canvas, audio, iframe, embed, object", "display: block; vertical-align: middle;")
				StyleManager.addStyle("img, video", "max-width: 100%; height: auto;");
				StyleManager.addStyle(":host, html", 'line-height: 1.5; -webkit-text-size-adjust: 100%; -moz-tab-size: 4; tab-size: 4; font-family: ui-sans-serif, system-ui, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji"; font-feature-settings: normal; font-variation-settings: normal; -webkit-tap-highlight-color: transparent');
				StyleManager.addStyle("body", 'margin: 0; line-height: inherit;');
				StyleManager.addStyle("code, kbd, pre, samp", 'font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace; font-feature-settings: normal; font-variation-settings: normal; font-size: 1em');

			}

			return _instance;
		}
		private var _current:String;
		public function get current():String
		{
			return _current;
		}
		public function set current(value:String):void
		{
			_current = value;
		}
		COMPILE::JS
		private var themeSet:Map = new Map();
		private var themes:Vector.<StyleTheme> = new Vector.<StyleTheme>();
		public function registerTheme(theme:StyleTheme):void
		{
			COMPILE::JS
			{
				if(themeSet.has(theme.themeName))
					return;
				themeSet.set(theme.themeName, theme);
				themes.push(theme);
				if(!current)
					setTheme(theme.themeName);
				
			}
		}

		public function get activeTheme():StyleTheme
		{
			COMPILE::JS
			{
				if(!_activeTheme)
					_activeTheme = themeSet.get(current);
				
				assert(_activeTheme, "Active theme not found: " + current);
			}
			return _activeTheme;
		}

		public function getTheme(themeName:String):StyleTheme
		{
			var theme:StyleTheme;
			COMPILE::JS
			{
				theme = themeSet.get(themeName);
				assert(theme, "Theme " + themeName + " not found");
			}
			return theme;
		}
		private var _activeTheme:StyleTheme;
		public function setTheme(themeName:String):void
		{
			COMPILE::JS
			{
				if(_current == themeName)
					return;
				var theme:StyleTheme = themeSet.get(themeName);
				assert(theme, "Theme " + themeName + " not found");
				_activeTheme = theme;
				_current = themeName;
			}
		}

	}	
}

