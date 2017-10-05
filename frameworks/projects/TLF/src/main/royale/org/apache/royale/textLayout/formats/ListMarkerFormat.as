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
package org.apache.royale.textLayout.formats
{
	import org.apache.royale.textLayout.property.CounterContentHandler;
	import org.apache.royale.textLayout.property.CounterPropHandler;
	import org.apache.royale.textLayout.property.EnumPropertyHandler;
	import org.apache.royale.textLayout.property.Property;
	import org.apache.royale.textLayout.property.PropertyFactory;
	import org.apache.royale.textLayout.property.PropertyUtil;

	

	
	/** Defines the marker format in a ListItemElement.
	 *  
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @langversion 3.0 
	 * 
	 *  @see org.apache.royale.textLayout.elements.ListItemElement
	 */
	public class ListMarkerFormat extends TextLayoutFormat implements IListMarkerFormat
	{
		/** @private */
		public static function createCounterResetProperty(nameValue:String, defaultValue:String, inherited:Boolean, categories:Vector.<String>):Property
		{
			var rslt:Property = new Property(nameValue, defaultValue, inherited, categories);
			rslt.addHandlers(PropertyFactory.sharedUndefinedHandler, new EnumPropertyHandler([ FormatValue.NONE ]),new CounterPropHandler(0));
			return rslt;			
		}
		
		/** @private */
		public static function createCounterIncrementProperty(nameValue:String, defaultValue:String, inherited:Boolean, categories:Vector.<String>):Property
		{
			var rslt:Property = new Property(nameValue, defaultValue, inherited, categories);
			rslt.addHandlers(PropertyFactory.sharedUndefinedHandler, new EnumPropertyHandler([ FormatValue.NONE ]),new CounterPropHandler(1));
			return rslt;			
		}
		
		/** @private */
		public static function createCounterContentProperty(nameValue:String, defaultValue:String, inherited:Boolean, categories:Vector.<String>):Property
		{
			var rslt:Property = new Property(nameValue, defaultValue, inherited, categories);
			rslt.addHandlers(PropertyFactory.sharedUndefinedHandler, new EnumPropertyHandler([ FormatValue.NONE ]),new CounterContentHandler());
			return rslt;			
		}

		/** @private */
		static private var _counterResetProperty:Property;
		static public function get counterResetProperty():Property{
			if(_counterResetProperty == null)
				_counterResetProperty = createCounterResetProperty("counterReset", FormatValue.NONE, false, Vector.<String>([Category.LIST]));
			
			return _counterResetProperty;
		}
		/** @private */
		static private var _counterIncrementProperty:Property;
		static public function get counterIncrementProperty():Property{
			if(_counterIncrementProperty == null)
				_counterIncrementProperty = createCounterResetProperty("counterIncrement", "ordered 1", false, Vector.<String>([Category.LIST]));
			
			return _counterIncrementProperty;
		}
		/** @private */
		static private var _beforeContentProperty:Property;
		static public function get beforeContentProperty():Property{
			if(_beforeContentProperty == null)
				_beforeContentProperty = PropertyFactory.string("beforeContent", null, false, Vector.<String>([Category.LIST]));
			
			return _beforeContentProperty;
		}
		/** @private */
		static private var _contentProperty:Property;
		static public function get contentProperty():Property{
			if(_contentProperty == null)
				_contentProperty = createCounterContentProperty("content", "counter(ordered)", false, Vector.<String>([Category.LIST]));
			
			return _contentProperty;
		}
		/** @private */
		static private var _afterContentProperty:Property;
		static public function get afterContentProperty():Property{
			if(_afterContentProperty == null)
			 	_afterContentProperty = PropertyFactory.string("afterContent", null, false, Vector.<String>([Category.LIST]));
				
				return _afterContentProperty;
		}
		/** @private */
		static private var _suffixProperty:Property;
		static public function get suffixProperty():Property{
			if(_suffixProperty == null)
				_suffixProperty = PropertyFactory.enumString("suffix", Suffix.AUTO, false, Vector.<String>([Category.LIST]), Suffix.AUTO, Suffix.NONE);
			
			return _suffixProperty;
		}
		
		static private var _lmfDescription:Object;
		static private function get lmfDescription():Object{
			if(_lmfDescription == null){
				_lmfDescription = {
					"counterReset":counterResetProperty,
					"counterIncrement":counterIncrementProperty,
					"beforeContent":beforeContentProperty,
					"content":contentProperty,
					"afterContent":afterContentProperty,
					"suffix":suffixProperty
				};
			}
			return _lmfDescription;
		}
		
		// at this point we know that both TextLayoutFormat and ListMarkerFormat are initialized so can setup the Property objects
		// (moved to getter initialization in PropertyFactory)
		// PropertyFactory.sharedTextLayoutFormatHandler.converter = TextLayoutFormat.createTextLayoutFormat;
		// PropertyFactory.sharedListMarkerFormatHandler.converter = ListMarkerFormat.createListMarkerFormat;

		
		/** Create a ListMarkerFormat that holds all the properties possible for a list marker.  
		 * 
		 *  @param initialValues An optional instance from which to copy initial values.
		 * 
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @langversion 3.0 
	 	 */
		public function ListMarkerFormat(initialValues:IListMarkerFormat = null)
		{
			super(initialValues);
		}
		
		/** @private */
		private function setLMFStyle(styleProp:Property,newValue:*):void
		{
			var name:String = styleProp.name;
			newValue = styleProp.setHelper(getStyle(name),newValue);
			super.setStyleByName(name,newValue);
		}
		
		/** @private */
		public override function setStyle(styleProp:String,newValue:*):void
		{
			var lmfStyle:Property = lmfDescription[styleProp];
			if (lmfStyle)
				setLMFStyle(lmfStyle,newValue);
			else
				super.setStyle(styleProp,newValue);
		}
		
		/**
		 * Controls resetting the value of the counter.  
		 * <p>Legal values for this property are:
		 *  <ul>
		 * 	  <li><code>none</code> - No reset.</li>
		 * 	  <li><code>ordered</code> - Reset the counter to zero.</li>
		 * 	  <li><code>ordered <i>integer</i></code> - Reset the counter to <code><i>integer</i></code>.</li>
		 *  </ul>
		 * </p>
		 * <p>If <code>undefined</code>, the default value of this property is "none".</p>
		 * <p>Note: The <code>counterReset</code> property is applied before the <code>counterIncrement</code> property.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get counterReset():*
		{ return getStyle(counterResetProperty.name); }
		public function set counterReset(value:*):void
		{ setLMFStyle(counterResetProperty,value); }
		
		/**
		 * Controls incrementing the value of the counter.  
		 * <p>Legal values for this string are:
		 *  <ul>
		 * 		<li><code>none</code> - No increment.</li>
		 * 		<li><code>ordered</code> - Increment the counter by one.</li>
		 * 		<li><code>ordered <i>integer</i></code> - Increment the counter by <code><i>integer</i></code>.</li>
		 *  </ul>
		 * </p>
		 * <p>If undefined, the default vaule of this property is <code>"ordered 1"</code>.</p>
		 * <p>Note: The <code>counterIncrement</code> property is applied before the <code>counterReset</code> property.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get counterIncrement():*
		{ return getStyle(counterIncrementProperty.name); }
		public function set counterIncrement(value:*):void
		{ setLMFStyle(counterIncrementProperty,value); }
		
		/**
		 * Controls the content of the marker. 
		 * <p>Legal values for this string are:
		 * <ul>
		 * 	<li><code>none</code> - No marker.</li>
		 * 	<li><code>counter(ordered)</code> - Display the marker.</li>
		 * 	<li><code>counter(ordered,ListStyleType)</code> - Display the marker but change the listStyleType to the specified value.</li>
		 * 	<li><code>counters(ordered)</code> - Starting from the top-most parent ListElement creating a string of values of the ordered counter in each counters specified listStyleType separated by the suffix for each.  This is used for outline number - for example I.1., I.2. etc.</li>
		 * 	<li><code>counters(ordered,"&lt;string&gt;")</code> - Similar to the previous value, except the suffix for each ordered counter is replaced by &lt;string&gt;.</li>
		 * 	<li><code>counters(ordered,"&lt;string&gt;",ListStyleType)</code> - Similar to the previous value, except each counter's <code>listStyleType</code> is replaced with the specified value.</li>
		 * </ul>
		 * </p>
		 * <p>If undefined, the default vaule of this property is <code>"counter(ordered)"</code>.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */		
		public function get content():*
		{ return getStyle(contentProperty.name); }
		public function set content(value:*):void
		{ setLMFStyle(contentProperty,value); }
		
		/** Specifies a string that goes before the marker. Default is the empty string. 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0	
		 */
		public function get beforeContent():*
		{ return getStyle(beforeContentProperty.name); }
		public function set beforeContent(value:*):void
		{ setLMFStyle(beforeContentProperty,value); }
		
		/** Specifies a string that goes after the marker. Default is the empty string. 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0	
		 */
		public function get afterContent():*
		{ return getStyle(afterContentProperty.name); }
		public function set afterContent(value:*):void
		{ setLMFStyle(afterContentProperty,value); }
		
		/**
		 * Controls the application of the suffix in the generated text in the ListItemElement.
		 * <p>Legal values are:
		 * <ul>
		 *   <li><code>org.apache.royale.textLayout.formats.Suffix.NONE</code> - No suffix.</li>		 
		 *   <li><code>org.apache.royale.textLayout.formats.Suffix.AUTO</code> - Follow CSS rules for adding a suffix.</li>
		 * </ul> 
		 * </p>
		 * <p>Default value is <code>Suffix.AUTO</code>.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * @see org.apache.royale.textLayout.formats.Suffix
		 */
		public function get suffix():*
		{ return getStyle(suffixProperty.name); }
		public function set suffix(value:*):void
		{ setLMFStyle(suffixProperty,value); }
		
		static private var _description:Object;
		
		/** Property descriptions accessible by name. @private */
		static public function get description():Object
		{ 
			if (!_description)
			{
				// use prototype chaining
				_description = PropertyUtil.createObjectWithPrototype(TextLayoutFormat.description);
				var lmfd:Object = lmfDescription;
				for (var key:String in lmfd)
					_description[key] = lmfd[key];
			}
			return _description; 
		}
		
		/** @private */
		public override function copy(incoming:ITextLayoutFormat):void
		{
			super.copy(incoming);
			
			var lmf:IListMarkerFormat = incoming as IListMarkerFormat;
			if (lmf)
			{
				var lmfd:Object = lmfDescription;
				for (var key:String in lmfd)
					this[key] = lmf[key];
			}
		}
		
		/** @private */
		public override function concat(incoming:ITextLayoutFormat):void
		{
			super.concat(incoming);
			var lmf:IListMarkerFormat = incoming as IListMarkerFormat;
			if (lmf)
			{
				var lmfd:Object = lmfDescription
				for each (var prop:Property in lmfd)
				{
					var name:String = prop.name;
					setLMFStyle(prop,prop.concatHelper(this[name],lmf[name]));
				}
			}
		}
		
		/** @private */
		public override function concatInheritOnly(incoming:ITextLayoutFormat):void
		{
			super.concatInheritOnly(incoming);
			var lmf:IListMarkerFormat = incoming as IListMarkerFormat;
			if (lmf)
			{
				var lmfd:Object = lmfDescription;
				for each (var prop:Property in lmfd)
				{
					var name:String = prop.name;
					setLMFStyle(prop,prop.concatInheritOnlyHelper(this[name],lmf[name]));
				}
			}
		}
		
		/** @private */
		public override function apply(incoming:ITextLayoutFormat):void
		{
			super.apply(incoming);
			var lmf:IListMarkerFormat = incoming as IListMarkerFormat;
			if (lmf)
			{
				var lmfd:Object = lmfDescription;
				for each (var prop:Property in lmfd)
				{
					var name:String = prop.name;
					var val:* = lmf[name];
					if (val !== undefined)
						this[name] = val;
				}
			}
		}
		
		/** @private */
		public override function removeMatching(incoming:ITextLayoutFormat):void
		{
			super.removeMatching(incoming);
			var lmf:IListMarkerFormat = incoming as IListMarkerFormat;
			if (lmf)
			{
				var lmfd:Object = lmfDescription;
				for each (var prop:Property in lmfd)
				{
					var name:String = prop.name;
					if (prop.equalHelper(this[name],lmf[name]))
						this[name] = undefined;
				}
			}

		}
		
		/** @private */
		public override function removeClashing(incoming:ITextLayoutFormat):void
		{
			super.removeClashing(incoming);
			var lmf:IListMarkerFormat = incoming as IListMarkerFormat;
			if (lmf)
			{
				var lmfd:Object = lmfDescription;
				for each (var prop:Property in lmfd)
				{
					var name:String = prop.name;
					if (!prop.equalHelper(this[name],lmf[name]))
						this[name] = undefined;
				}
			}
		}
		
		/**
		 * Creates a new ListMarkerFormat object. All settings are empty or, optionally, are initialized from the
		 * supplied <code>initialValues</code> object.
		 * 
		 * @param initialValues Optional instance from which to copy initial values. If the object is of type IListMarkerFormat or ITextLayoutFormat, the values are copied.  
		 * Otherwise the <code>initialValues</code> parameter is treated like a ObjectMap or Object and iterated over.
		 * 
		 * @return The new ListMarkerFormat object.
		 * 
		 * @see #defaultFormat
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public static function createListMarkerFormat(initialValues:Object):ListMarkerFormat
		{
			var lmf:IListMarkerFormat = initialValues as IListMarkerFormat;
			var rslt:ListMarkerFormat = new ListMarkerFormat(lmf);
			if (lmf == null && initialValues)
			{
				for (var key:String in initialValues)
					rslt.setStyle(key,initialValues[key]);
			}
			return rslt;
		}
	}
}
