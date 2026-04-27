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
package org.apache.royale.style
{
	import org.apache.royale.core.Application;
	import org.apache.royale.binding.ApplicationDataBinding;
	import org.apache.royale.core.CSSClassList;
	import org.apache.royale.core.AllCSSValuesImpl;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.util.StyleTheme;

	public class Application extends org.apache.royale.core.Application
	{
		private static var _current:org.apache.royale.style.Application;
		/**
		 * Global getter to get a reference to the top-level application
		 */
		public static function get current():org.apache.royale.style.Application{
			return _current;
		}
		public function Application()
		{
			super();
			valuesImpl = new AllCSSValuesImpl();
     		addBead(new ApplicationDataBinding());
			_current = this;
			ThemeManager.instance.registerTheme(new StyleTheme());
		}

		private var _theme:String = "";

		public function get theme():String
		{
			return _theme;
		}

		public function set theme(value:String):void
		{
			_theme = value;
		}
		COMPILE::JS
		override public function start():void
		{
			super.start();
		}

	}
}