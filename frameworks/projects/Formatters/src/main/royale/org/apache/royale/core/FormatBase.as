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
package org.apache.royale.core
{
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
	
	public class FormatBase extends EventDispatcher implements IFormatBead
	{
		public function FormatBase()
		{
		}
		
		/**
		 *  Retrieves the current value of the property from the strand.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get propertyValue():Object
		{
			var model:IBeadModel = _strand.getBeadByType(IBeadModel) as IBeadModel;
			var value:Object = model[propertyName];
			return value;
		}
		
		private var _propertyName:String;
		
		/**
		 *  The name of the property in the model holding the value to be
		 *  formatted. The default is text.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get propertyName():String
		{
			if (_propertyName == null) {
				_propertyName = "text";
			}
			return _propertyName;
		}
		public function set propertyName(value:String):void
		{
			_propertyName = value;
		}
		
		private var _eventName:String;
		
		/**
		 *  The name of the event dispatched when the property changes. The
		 *  default is propertyName + "Changed".
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
		 *  The resulting formatted value as a string.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get formattedString():String
		{
			// override to produce actual result
			return null;
		}
		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
	}
}
