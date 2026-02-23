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
				_instance = new ThemeManager();

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

