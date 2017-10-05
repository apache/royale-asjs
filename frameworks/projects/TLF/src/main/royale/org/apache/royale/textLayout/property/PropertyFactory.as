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
package org.apache.royale.textLayout.property {
	import org.apache.royale.textLayout.formats.FormatValue;
	import org.apache.royale.textLayout.property.EnumPropertyHandler;
	import org.apache.royale.textLayout.property.UndefinedPropertyHandler;
	import org.apache.royale.textLayout.property.UintPropertyHandler;
	import org.apache.royale.textLayout.formats.TextLayoutFormat;
	import org.apache.royale.textLayout.formats.ListMarkerFormat;
	public class PropertyFactory {
		// shared propertyHandler instances
		/** @private */
		static private var _sharedStringHandler:StringPropertyHandler;
		public static function get sharedStringHandler():StringPropertyHandler{
			if(_sharedStringHandler == null)
				_sharedStringHandler = new StringPropertyHandler();
			
			return _sharedStringHandler;
		}
		/** @private */
		private static var _sharedInheritEnumHandler:EnumPropertyHandler;
		public static function get sharedInheritEnumHandler():EnumPropertyHandler{
			if(_sharedInheritEnumHandler == null)
				_sharedInheritEnumHandler  = new EnumPropertyHandler([ FormatValue.INHERIT ]);
			
			return _sharedInheritEnumHandler;
		}
		/** @private */
		private static var _sharedUndefinedHandler:UndefinedPropertyHandler;
		public static function get sharedUndefinedHandler():UndefinedPropertyHandler{
			 if(_sharedUndefinedHandler == null)
				_sharedUndefinedHandler = new UndefinedPropertyHandler();
			
			return _sharedUndefinedHandler;
		}
		/** @private */
		private static var _sharedUintHandler:UintPropertyHandler;
		public static function get sharedUintHandler():UintPropertyHandler{
			if(_sharedUintHandler == null)
				_sharedUintHandler = new UintPropertyHandler();
			
			return _sharedUintHandler;
		}
		/** @private */
		private static var _sharedBooleanHandler:BooleanPropertyHandler;
		public static function get sharedBooleanHandler():BooleanPropertyHandler{
			if(_sharedBooleanHandler == null)
			 	_sharedBooleanHandler = new BooleanPropertyHandler();
			
			return _sharedBooleanHandler;
		}
		
		/** @private */
		private static var _sharedTextLayoutFormatHandler:FormatPropertyHandler;
		public static function get sharedTextLayoutFormatHandler():FormatPropertyHandler{
			if(_sharedTextLayoutFormatHandler == null)
			{
				_sharedTextLayoutFormatHandler = new FormatPropertyHandler();
				_sharedTextLayoutFormatHandler.converter = TextLayoutFormat.createTextLayoutFormat;
			}
			
			return _sharedTextLayoutFormatHandler;
		}
		/** @private */
		private static var _sharedListMarkerFormatHandler:FormatPropertyHandler;
		public static function get sharedListMarkerFormatHandler():FormatPropertyHandler{
			if(_sharedListMarkerFormatHandler == null)
			{
				_sharedListMarkerFormatHandler = new FormatPropertyHandler();
				_sharedListMarkerFormatHandler.converter = ListMarkerFormat.createListMarkerFormat;
			}
			
			return _sharedListMarkerFormatHandler;
		}
		
		public static function bool(nameValue:String, defaultValue:Boolean, inherited:Boolean, categories:Vector.<String>):Property
		{			
			var rslt:Property = new Property(nameValue, defaultValue, inherited, categories);
			rslt.addHandlers(sharedUndefinedHandler,sharedBooleanHandler,sharedInheritEnumHandler);
			return rslt;
		}
		
		public static function string(nameValue:String, defaultValue:String, inherited:Boolean, categories:Vector.<String>):Property
		{
			var rslt:Property = new Property(nameValue, defaultValue, inherited, categories);
			rslt.addHandlers(sharedUndefinedHandler,sharedStringHandler);
			return rslt;			
		}
		public static function uintProp(nameValue:String, defaultValue:uint, inherited:Boolean, categories:Vector.<String>):Property
		{
			var rslt:Property = new Property(nameValue, defaultValue, inherited, categories);
			rslt.addHandlers(sharedUndefinedHandler,sharedUintHandler,sharedInheritEnumHandler);
			return rslt;
		}

		public static function enumString(nameValue:String, defaultValue:String, inherited:Boolean, categories:Vector.<String>, ... rest):Property
		{
			var rslt:Property = new Property(nameValue, defaultValue, inherited, categories);
			rslt.addHandlers(sharedUndefinedHandler,new EnumPropertyHandler(rest),sharedInheritEnumHandler);
			return rslt;
		}
		
		public static function intOrEnum(nameValue:String, defaultValue:Object, inherited:Boolean, categories:Vector.<String>, minValue:int, maxValue:int, ... rest):Property
		{		
			var rslt:Property = new Property(nameValue, defaultValue, inherited, categories);
			rslt.addHandlers(sharedUndefinedHandler,new EnumPropertyHandler(rest),new IntPropertyHandler(minValue,maxValue),sharedInheritEnumHandler);
			return rslt;
		}
		
		public static function uintOrEnum(nameValue:String, defaultValue:Object, inherited:Boolean, categories:Vector.<String>,  ... rest):Property
		{			
			var rslt:Property = new Property(nameValue, defaultValue, inherited, categories);
			rslt.addHandlers(sharedUndefinedHandler,new EnumPropertyHandler(rest),sharedUintHandler,sharedInheritEnumHandler);
			return rslt;
		}

		public static function number(nameValue:String, defaultValue:Number, inherited:Boolean, categories:Vector.<String>, minValue:Number, maxValue:Number):Property
		{
			var rslt:Property = new Property(nameValue, defaultValue, inherited, categories);
			rslt.addHandlers(sharedUndefinedHandler,new NumberPropertyHandler(minValue,maxValue),sharedInheritEnumHandler);
			return rslt;
		}
		public static function 	numPercentEnum(nameValue:String, defaultValue:Object, inherited:Boolean, categories:Vector.<String>, minValue:Number, maxValue:Number, minPercentValue:String, maxPercentValue:String, ... rest):Property
		{
			var rslt:Property = new Property(nameValue, defaultValue, inherited, categories);
			rslt.addHandlers(sharedUndefinedHandler,new EnumPropertyHandler(rest),new PercentPropertyHandler(minPercentValue,maxPercentValue),new NumberPropertyHandler(minValue,maxValue),sharedInheritEnumHandler);
			return rslt;
		}
		public static function numPercent(nameValue:String, defaultValue:Object, inherited:Boolean, categories:Vector.<String>, minValue:Number, maxValue:Number, minPercentValue:String, maxPercentValue:String):Property
		{			
			var rslt:Property = new Property(nameValue, defaultValue, inherited, categories);
			rslt.addHandlers(sharedUndefinedHandler,new PercentPropertyHandler(minPercentValue,maxPercentValue),new NumberPropertyHandler(minValue,maxValue),sharedInheritEnumHandler);
			return rslt;
		}
		public static function numEnum(nameValue:String, defaultValue:Object, inherited:Boolean, categories:Vector.<String>, minValue:Number, maxValue:Number, ... rest):Property
		{			
			var rslt:Property = new Property(nameValue, defaultValue, inherited, categories);
			rslt.addHandlers(sharedUndefinedHandler,new EnumPropertyHandler(rest),new NumberPropertyHandler(minValue,maxValue),sharedInheritEnumHandler);
			return rslt;
		}
		public static function tabStopsProp(nameValue:String, defaultValue:Array, inherited:Boolean, categories:Vector.<String>):Property
		{
			return new TabStopsProperty(nameValue,defaultValue,inherited,categories);
		}
		public static function spacingLimitProp(nameValue:String, defaultValue:Object, inherited:Boolean, categories:Vector.<String>, minPercentValue:String, maxPercentValue:String):Property
		{
			var rslt:Property = new Property(nameValue,defaultValue,inherited,categories);
			rslt.addHandlers(sharedUndefinedHandler, new SpacingLimitPropertyHandler(minPercentValue, maxPercentValue), sharedInheritEnumHandler);
			return rslt;
		}
		
		private static const undefinedValue:* = undefined;
		
		public static function tlfProp(nameValue:String, defaultValue:Object, inherited:Boolean, categories:Vector.<String>):Property
		{
			// passing undefined as a value seems to confuse the compiler
			var rslt:Property = new Property(nameValue, undefinedValue, inherited, categories);
			rslt.addHandlers(sharedUndefinedHandler,sharedTextLayoutFormatHandler,sharedInheritEnumHandler);
			return rslt;
		}
		public static function listMarkerFormatProp(nameValue:String, defaultValue:Object, inherited:Boolean, categories:Vector.<String>):Property
		{
			// passing undefined as a value seems to confuse the compiler
			var rslt:Property = new Property(nameValue, undefinedValue, inherited, categories);
			rslt.addHandlers(sharedUndefinedHandler,sharedListMarkerFormatHandler,sharedInheritEnumHandler);
			return rslt;
		}		
	
	}
}
