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
package org.apache.flex.html.staticControls.accessories
{
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IFormatBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.events.IEventDispatcher;
	
	/**
	 * The NumberFormatter class formats a value in separated groups. The formatter listens
	 * to a property on a model and when the property changes, formats it and dispatches a
	 * formatChanged event.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class NumberFormatter extends EventDispatcher implements IFormatBead
	{
		/**
		 *  constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function NumberFormatter()
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
		 *  @productversion Royale 0.0
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
		private var _groupSize:Number = 3;
		private var _thousandsSeparator:String = ",";
		
		/**
		 *  The name of the property on the model to format.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
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
		 *  Character to use to separate thousands groups. The default is
		 *  the comma (,).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get thousandsSeparator():String
		{
			return _thousandsSeparator;
		}
		public function set thousandsSeparator(value:String):void
		{
			_thousandsSeparator = value;
		}
		
		/**
		 *  The formatted string.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
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
		 * @private
		 */
		private function format(value:Object):String
		{
			if (value == null) return "";
			
			var num:Number = Number(value);
			var source:String = String(value);
			var parts:Array = source.split(thousandsSeparator);
			source = parts.join("");
			
			var l:int = source.length;
			var result:String = "";
			var group:int = 0;
			
			for(var i:int=l-1; i >= 0; i--)
			{
				if (group == _groupSize && result.length > 0) {
					result = thousandsSeparator + result;
					group = 0;
				}
				result = source.charAt(i) + result;
				group++;
			}
			
			return result;
		}
	}
}
