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
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IFormatBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.events.IEventDispatcher;
	
	/**
	 * The CurrencyFormatter class formats a value in separated groups. The formatter listens
	 * to a property on a model and when the property changes, formats it and dispatches a
	 * formatChanged event.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class CurrencyFormatter extends EventDispatcher implements IFormatBead
	{
		/**
		 *  constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function CurrencyFormatter()
		{
			super();
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
			// Listen for the change in the model
			var model:IBeadModel = _strand.getBeadByType(IBeadModel) as IBeadModel;
			model.addEventListener(eventName,propertyChangeHandler);
			model.addEventListener(propertyName+"Change",propertyChangeHandler);
			
			// format the current value of that property
			propertyChangeHandler(null);
		}
		
		private var _propertyName:String;
		private var _eventName:String;
		private var _formattedResult:String;
		private var _fractionalDigits:Number = 2;
        private var _currencySymbol:String = "$";
		
		/**
		 *  The name of the property on the model to format.
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
		 *  The event dispatched by the model when the property changes. The
		 *  default is propertyName+"Changed".
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
		 *  Number of digits after the decimal separator
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get fractionalDigits():int
		{
			return _fractionalDigits;
		}
		public function set fractionalDigits(value:int):void
		{
            _fractionalDigits = value;
		}
		
        /**
         *  The currency symbol, such as "$"
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get currencySymbol():String
        {
            return _currencySymbol;
        }
        public function set currencySymbol(value:String):void
        {
            _currencySymbol = value;
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
			// When the property changes, fetch it from the model and
			// format it, storing the result in _formattedResult.
			var model:IBeadModel = _strand.getBeadByType(IBeadModel) as IBeadModel;
			var value:Object = model[propertyName];
			_formattedResult = format(value);
			
			// Dispatch the formatChanged event so any bead that's interested in
			// the formatted string knows to use it.
			var newEvent:Event = new Event("formatChanged");
			this.dispatchEvent(newEvent);
		}
		
        /**
         *  Computes the formatted string.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function format(value:Object):String
		{
			if (value == null) return "";
			
			var num:Number = Number(value);
            var source:String = num.toPrecision(fractionalDigits);
			
			return currencySymbol + source;
		}
	}
}
