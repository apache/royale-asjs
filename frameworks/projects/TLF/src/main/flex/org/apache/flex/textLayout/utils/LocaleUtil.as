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
package org.apache.royale.textLayout.utils
{
	import org.apache.royale.text.engine.JustificationStyle;
	
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.formats.JustificationRule;
	import org.apache.royale.textLayout.formats.LeadingModel;

	
	

	/** 
	 * Utilities for managing and getting information about Locale based defaults.
	 * The methods of this class are static and must be called using
	 * the syntax <code>LocaleUtil.method(<em>parameter</em>)</code>.
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	// [ExcludeClass]
	public final class LocaleUtil
	{
		public function LocaleUtil()
		{
		}
		
		
		/** @private */
		static private var _localeSettings:Object = null;
		static private var _lastLocaleKey:String = "";
		static private var _lastLocale:LocaleSettings = null;
		
		static public function justificationRule(locale:String):String 
		{
			var localeSet:LocaleSettings = fetchLocaleSet(locale);
			CONFIG::debug{ assert(localeSet != null, "Failed to get LocaleSettings from locale! locale = " + locale); }
			
			return localeSet.justificationRule;
		}
		
		static public function justificationStyle(locale:String):String
		{
			var localeSet:LocaleSettings = fetchLocaleSet(locale);
			CONFIG::debug{ assert(localeSet != null, "Failed to get LocaleSettings from locale! locale = " + locale); }
			
			return localeSet.justificationStyle;
		}
		
		static public function leadingModel(locale:String):String
		{
			var localeSet:LocaleSettings = fetchLocaleSet(locale);
			CONFIG::debug{ assert(localeSet != null, "Failed to get LocaleSettings from locale! locale = " + locale); }
			
			return localeSet.leadingModel;
		}
		
		
		static public function dominantBaseline(locale:String):String
		{
			var localeSet:LocaleSettings = fetchLocaleSet(locale);
			CONFIG::debug{ assert(localeSet != null, "Failed to get LocaleSettings from locale! locale = " + locale); }
			
			return localeSet.dominantBaseline;
		}
		
		
		/** @private */
		static private function addLocale(locale:String):LocaleSettings
		{
			CONFIG::debug{ assert(_localeSettings[locale] == null, "Cannot add a new locale property set when it already exists.  Locale == " + locale); }
			_localeSettings[locale] = new LocaleSettings();
			return _localeSettings[locale];
		}
		
		/** @private */
		static private function initializeDefaultLocales():void
		{
			CONFIG::debug{ assert(_localeSettings == null, "Should not call initializeDefaultLocales when dictionary exists!"); }
			_localeSettings = {};
			
			{
				var locale:LocaleSettings = addLocale("en");
				CONFIG::debug{ assert(locale != null, "Failed to create new locale for 'en'!"); }
	
				locale.justificationRule = JustificationRule.SPACE;
				locale.justificationStyle = JustificationStyle.PUSH_IN_KINSOKU;
				locale.leadingModel = LeadingModel.ROMAN_UP;
				locale.dominantBaseline = "roman";
				
				locale = addLocale("ja");
				CONFIG::debug{ assert(locale != null, "Failed to create new locale for 'ja'!"); }
	
				locale.justificationRule = JustificationRule.EAST_ASIAN;
				locale.justificationStyle = JustificationStyle.PUSH_IN_KINSOKU;
				locale.leadingModel = LeadingModel.IDEOGRAPHIC_TOP_DOWN;
				locale.dominantBaseline = "ideographicCenter";
				
				locale = addLocale("zh");
				CONFIG::debug{ assert(locale != null, "Failed to create new locale for 'zh'!"); }
	
				locale.justificationRule = JustificationRule.EAST_ASIAN;
				locale.justificationStyle = JustificationStyle.PUSH_IN_KINSOKU;
				locale.leadingModel = LeadingModel.IDEOGRAPHIC_TOP_DOWN;
				locale.dominantBaseline = "ideographicCenter";
			}		
		}
		
		/** @private */
		static private function getLocale(locale:String):LocaleSettings
		{
			var lowerLocale:String = locale.toLowerCase().substr(0,2);
			var rslt:LocaleSettings = _localeSettings[lowerLocale];
			return rslt == null ? _localeSettings["en"] : rslt;
		}
		
		/** @private */
		static private function fetchLocaleSet(locale:String):LocaleSettings
		{
			if(_localeSettings == null)
				initializeDefaultLocales();
			
			if(locale == _lastLocaleKey)
				return _lastLocale;
			
			var localeSet:LocaleSettings = getLocale(locale);
			
			//update the last locale data
			_lastLocale = localeSet;
			_lastLocaleKey = locale;
			return localeSet;
		}
	}
}


import org.apache.royale.textLayout.debug.assert;

import org.apache.royale.textLayout.formats.TextLayoutFormat;



class LocaleSettings
{
	public function LocaleSettings()
	{}
	
	private var _justificationRule:String = null;
	private var _justificationStyle:String = null;
	private var _leadingModel:String = null;
	private var _dominantBaseline:String = null;
	
	public function get justificationRule():String { return _justificationRule; }
	public function set justificationRule(newValue:String):void 
	{ 
		var setValue:Object = TextLayoutFormat.justificationRuleProperty.setHelper(_justificationRule,newValue);
		//don't assert if the newValue is null, only if it is invalid
		CONFIG::debug{ assert(newValue == null || setValue != null, "LocaleUtil should never be providing an invalid JustificationRule!"); }
		
		_justificationRule = setValue == null ? null : (setValue as String);
	}
	
	public function get justificationStyle():String { return _justificationStyle; }
	public function set justificationStyle(newValue:String):void 
	{ 
		var setValue:Object = TextLayoutFormat.justificationStyleProperty.setHelper(_justificationStyle,newValue);
		//don't assert if the newValue is null, only if it is invalid
		CONFIG::debug{ assert(newValue == null || setValue != null, "LocaleUtil should never be providing an invalid LeadingDirection!"); }
		
		_justificationStyle = setValue == null ? null : (setValue as String);
	}
	
	public function get leadingModel():String { return _leadingModel; }
	public function set leadingModel(newValue:String):void 
	{ 
		var setValue:Object = TextLayoutFormat.leadingModelProperty.setHelper(_leadingModel,newValue);
		//don't assert if the newValue is null, only if it is invalid
		CONFIG::debug{ assert(newValue == null || setValue != null, "LocaleUtil should never be providing an invalid JustificationStyle!"); }
		
		_leadingModel = setValue == null ? null : (setValue as String);
	}
	
	
	public function get dominantBaseline():String { return _dominantBaseline; }
	public function set dominantBaseline(newValue:String):void 
	{ 
		var setValue:Object = TextLayoutFormat.dominantBaselineProperty.setHelper(_dominantBaseline,newValue);
		//don't assert if the newValue is null, only if it is invalid
		CONFIG::debug{ assert(newValue == null || setValue != null, "LocaleUtil should never be providing an invalid TextBaseline!"); }
		
		_dominantBaseline = setValue == null ? null : (setValue as String);
	}
}
