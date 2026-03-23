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
package org.apache.royale.style.colors
{
	import org.apache.royale.style.util.CSSLookup;
	import org.apache.royale.utils.CSSUtils;
	
	import org.apache.royale.debugging.assert;

	public class ThemeColorSet
	{
		
		public static const BASE:String = 'base';
		public static const PRIMARY:String = 'primary';
		public static const SECONDARY:String = 'secondary';
		public static const ACCENT:String = 'accent';
		public static const INFO:String = 'info';
		public static const SUCCESS:String = 'success';
		public static const WARNING:String = 'warning';
		public static const ERROR:String = 'error';
		public static const NEUTRAL:String = 'neutral';
		
		public static const BASE_CONTENT:String        = "base-content";
		public static const PRIMARY_CONTENT:String     = "primary-content";
		public static const SECONDARY_CONTENT:String   = "secondary-content";
		public static const ACCENT_CONTENT:String      = "accent-content";
		public static const INFO_CONTENT:String        = "info-content";
		public static const SUCCESS_CONTENT:String     = "success-content";
		public static const WARNING_CONTENT:String     = "warning-content";
		public static const ERROR_CONTENT:String       = "error-content";
		public static const NEUTRAL_CONTENT:String     = "neutral-content";
		
		
		private static const _fieldNames:Array = [
			BASE,
			PRIMARY,
			SECONDARY,
			ACCENT,
			INFO,
			SUCCESS,
			WARNING,
			ERROR,
			NEUTRAL,
			BASE_CONTENT,
			PRIMARY_CONTENT,
			SECONDARY_CONTENT,
			ACCENT_CONTENT,
			NEUTRAL_CONTENT,
			INFO_CONTENT,
			SUCCESS_CONTENT,
			WARNING_CONTENT,
			ERROR_CONTENT
		]
		
		public static function get validFieldNames():Array{
			return _fieldNames.slice();
		} 

		COMPILE::JS
		private const storage:Map = new Map();

		/**
		 * Subclasses must specify colorBase before calling this constructor.
		 */
		public function ThemeColorSet(config:Object = null)
		{
			if (config) fromJSON(config);
		}
		
		public function setThemeColor(key:String, value:String):void{
			assert(_fieldNames.indexOf(key) != -1, 'unknown key "'+key+'" - must be one of :"'+_fieldNames.join('","')+'"')
			if (value) {
				// do we need to validate value?
				const exceptions:Array = [	
					"transparent",
					"currentColor",
					"inherit",
					"none",
					"black",
					"white"
				]
				var valueToSet:Object = exceptions.indexOf(value) == -1 ? ColorSwatch.fromSpecifier(value) : value;
				COMPILE::JS {
					storage.set(key,valueToSet);
				}
			} else {
				COMPILE::JS {
					if (storage.has(key)) storage.delete(key);
				}
			}
		}
		
		public function getThemeColorSwatch(key:String):ColorSwatch{
			assert(_fieldNames.indexOf(key) != -1, 'unknown key "'+key+'" - must be one of :"'+_fieldNames.join('","')+'"');
			COMPILE::JS{
				//Q: should there always be a neutral default if no lookup is registered for a specific set?
				if (!storage.has(key)) {
					//do something?
					storage.set(key,ColorSwatch.fromSpecifier(ColorSwatch.NEUTRAL+'-500'/*, key*/));
				}
				return storage.get(key)
			}
			COMPILE::SWF{
				return null;
			}
		}
		
		public function fromJSON(obj:Object):void{
			if (typeof obj == 'string') obj = JSON.parse(obj as String);
			for (var key:String in obj) {
				setThemeColor(key,obj[key]);
			}
		}
		
		public function toJSON():Object{
			const obj:Object = {};
			COMPILE::JS{
				var keys:Array = Object.keys(storage);
				for each(var key:String in keys) {
					var swatch:ColorSwatch = storage.get(key);
					obj[key] = swatch.colorSpecifier;
				}
			}
			return obj;
		}
		
	}
}