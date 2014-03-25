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
package org.apache.flex.html.accessories
{
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IFormatBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.events.IEventDispatcher;

	/**
	 *  The PhoneNumberFormatter class bead formats a numeric string into a 
	 *  US style phone number. The format bead listens for changes to a property
	 *  in a model, formats the value, and dispatches a formatChanged event.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class PhoneNumberFormatter extends EventDispatcher implements IBead, IFormatBead
	{
		/**
		 *  constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function PhoneNumberFormatter()
		{
		}
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			// Listen for the beadsAdded event which signals when all of a strand's
			// beads have been added.
			IEventDispatcher(value).addEventListener("beadsAdded",handleBeadsAdded);
		}
		
		/**
		 * @private
		 */
		private function handleBeadsAdded(event:Event):void
		{
			// Listen for the change in the model.
			var model:IBeadModel = _strand.getBeadByType(IBeadModel) as IBeadModel;
			model.addEventListener(eventName,propertyChangeHandler);
			model.addEventListener(propertyName+"Change",propertyChangeHandler);
			
			// format the current value of that property
			propertyChangeHandler(null);
		}
		
		private var _propertyName:String;
		private var _eventName:String;
		private var _formattedResult:String;
		
		/**
		 *  The name of the property in the model holding the value to be
		 *  formatted. The default is text.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get propertyName():String
		{
			if (_propertyName == null) {
				return "text";
			}
			return _propertyName;
		}
		public function set propertyName(value:String):void
		{
			_propertyName = value;
		}
		
		/**
		 *  The name of the event dispatched when the property changes. The
		 *  default is propertyName + "Changed".
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get eventName():String
		{
			if (_eventName == null) {
				return _propertyName+"Changed";
			}
			return _eventName;
		}
		public function set eventName(value:String):void
		{
			_eventName = value;
		}
		
		/**
		 *  The formatted string.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get formattedString():String
		{
			return _formattedResult;
		}
		
		/**
		 * @private
		 */
		private function propertyChangeHandler(event:Event):void
		{
			// When the model's value changes, format it and store it in
			// _formattedResult.
			var model:IBeadModel = _strand.getBeadByType(IBeadModel) as IBeadModel;
			var value:Object = model[propertyName];
			_formattedResult = format(value);
			
			// Dispatch the formatChanged event so other beads can use the newly
			// formatted value.
			var newEvent:Event = new Event("formatChanged");
			this.dispatchEvent(newEvent);
		}
		
		/**
		 * @private
		 */
		private function format(value:Object):String
		{
			if (value == null) return "";
			
			var source:String = String(value);
			if (source.length != 10) return source;
			
			var areaCode:String = "";
			var exchange:String;
			var num:String;
			
			var pos:int = 0;
			if (source.length == 10) {
				areaCode = source.substr(pos,3);
				pos += 3;
			}
			
			exchange = source.substr(pos,3);
			pos += 3;
			
			num = source.substr(pos,4);
			
			var result:String = "";
			if (source.length == 10) {
				result = result + "("+areaCode+") ";
			}
			result = result + exchange + "-" + num;
			return result;
		}
	}
}
