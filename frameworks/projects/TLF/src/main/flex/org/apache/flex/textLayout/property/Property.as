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
package org.apache.royale.textLayout.property
{
	import org.apache.royale.textLayout.formats.FormatValue;

	// [ExcludeClass]
	/** Base class of property metadata.  Each property in the various TextLayout attributes structures has a metadata singletion Property class instance.  The instance
	 * can be used to process the property to and from xml, find out range information and help with the attribute cascade.  The Property class also contains static functions
	 * for processing all the properties collected in a TextLayout Format object. @private  */
	public class Property
	{
	
		// storing name here is redundant but is more efficient 
		private var _name:String;
		private var _default:*;
		private var _inherited:Boolean;
		private var _categories:Vector.<String>;
		private var _hasCustomExporterHandler:Boolean;
		private var _numberPropertyHandler:Object;
		
		protected var _handlers:Vector.<PropertyHandler>;
		
		/** Initializer.  Each property has a name and a default. */
		public function Property(nameValue:String,defaultValue:*,inherited:Boolean,categories:Vector.<String>)
		{ 
			_name = nameValue;
			_default = defaultValue;
			_inherited = inherited;
			_categories = categories;
			_hasCustomExporterHandler = false;
		}
		
		/** The name of the property */
		public function get name():String
		{ return _name; }
		
		/** The default value of this property */
		public function get defaultValue():*
		{ return _default; }
		
		/** Is this property inherited */
		public function get inherited():Object
		{ return _inherited; }
		
		/** First listed Category of this property. This is the legacy category from when Properties could only be in one category.  */
		public function get category():String
		{ return _categories[0]; }
		
		/** Return the list of categories */
		public function get categories():Vector.<String>
		{ return _categories; }
				
		public function addHandlers(... rest):void
		{
			_handlers = new Vector.<PropertyHandler>(rest.length,true);
			for (var idx:int = 0; idx < rest.length; idx++)
			{
				var handler:PropertyHandler = rest[idx];
				_handlers[idx] = handler;
				if (handler.customXMLStringHandler)
					_hasCustomExporterHandler = true;
				if (handler.className == "NumberPropertyHandler")
					_numberPropertyHandler = handler;
			}
		}
		
		public function findHandler(handlerClass:String):PropertyHandler
		{
			for each (var prop:PropertyHandler in _handlers)
			{
				if (prop.className == handlerClass)
					return prop;
			}
			return null;
		}

		/** Helper function when setting the property */
		public function setHelper(currVal:*,newVal:*):*
		{
			for each (var handler:PropertyHandler in _handlers)
			{
				var checkRslt:* = handler.owningHandlerCheck(newVal);
				if (checkRslt !== undefined)
					return handler.setHelper(checkRslt);
			}
			
			PropertyUtil.errorHandler(this,newVal);
			return currVal;	
		}
				
		/** Helper function when merging the property to compute actual attributes */
		public function concatInheritOnlyHelper(currVal:*,concatVal:*):*
		{ return (_inherited && currVal === undefined) || currVal == FormatValue.INHERIT ? concatVal : currVal; }

		/** Helper function when merging the property to compute actual attributes */
		public function concatHelper(currVal:*,concatVal:*):*
		{
			if (_inherited)
				return currVal === undefined || currVal == FormatValue.INHERIT ? concatVal : currVal;
			if (currVal === undefined)
				return defaultValue;
			return currVal == FormatValue.INHERIT ? concatVal : currVal;
		}
		
		/** Helper function when comparing the property */
		public function equalHelper(v1:*,v2:*):Boolean
		{ return v1 == v2; }
		
		/** Convert the value of this property to a string appropriate for XML export */
		public function toXMLString(val:Object):String
		{
			if (_hasCustomExporterHandler)
			{
				for each (var prop:PropertyHandler in _handlers)
				{
					if (prop.customXMLStringHandler && prop.owningHandlerCheck(val) !== undefined)
						return prop.toXMLString(val);
				}				
			}
			return val.toString();
		}
		
		public function get maxPercentValue():Number
		{
			var handler:PropertyHandler = findHandler("PercentPropertyHandler");
			return handler ? handler.maxValue : NaN;
		}
		public function get minPercentValue():Number
		{
			var handler:PropertyHandler = findHandler("PercentPropertyHandler");
			return handler ? handler.minValue : NaN;
		}
		public function get minValue():Number
		{
			var numberHandler:PropertyHandler = findHandler("NumberPropertyHandler");
			if (numberHandler)
				return numberHandler.minValue;
			var intHandler:PropertyHandler = findHandler("IntPropertyHandler");
			return intHandler ? intHandler.minValue : NaN;
		}
		public function get maxValue():Number
		{
			var numberHandler:PropertyHandler = findHandler("NumberPropertyHandler");
			if (numberHandler)
				return numberHandler.maxValue;
			var intHandler:PropertyHandler = findHandler("IntPropertyHandler");
			return intHandler ? intHandler.maxValue : NaN;
		}
		
		public function computeActualPropertyValue(propertyValue:Object,percentInput:Number):Number
		{				
			var percent:Number = PropertyUtil.toNumberIfPercent(propertyValue);
			if (isNaN(percent))
				return Number(propertyValue);
			
			// its a percent - calculate and clamp
			var rslt:Number =  percentInput * (percent / 100);
			return _numberPropertyHandler ? _numberPropertyHandler.clampToRange(rslt) : rslt;
		}
	}
}
