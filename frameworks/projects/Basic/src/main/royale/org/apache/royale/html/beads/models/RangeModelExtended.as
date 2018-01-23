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
package org.apache.royale.html.beads.models
{
	import org.apache.royale.events.Event;
	import org.apache.royale.events.ValueChangeEvent;
	import org.apache.royale.html.beads.models.RangeModel;

	/**
	 *  The RangeModelExtended bead expands on the RangeModel and adds a function to
	 *  display a value from the model.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class RangeModelExtended extends RangeModel
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function RangeModelExtended()
		{
			super();
		}

		private var _value:Number = 0;
		
		/**
		 * @private
		 */
		override public function get value():Number
		{
			return _value;
		}
		override public function set value(newValue:Number):void
		{
			if (_value != newValue)
			{
				var vce:ValueChangeEvent = ValueChangeEvent.createUpdateEvent(_strand, "value", _value, newValue);
				_value = newValue;
				dispatchEvent(vce);
			}
		}

		private var _labelFunction:Function;
		
		/**
		 *  A function used to format a value in the model.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get labelFunction():Function
		{
			return _labelFunction;
		}
		public function set labelFunction(value:Function):void
		{
			_labelFunction = value;
		}

		/**
		 *  Returns the label, using the labelFunction (if provided) for the value
		 *  at the given index.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function getLabelForIndex(index:Number):String
		{
			if (_labelFunction != null) {
				return _labelFunction(this, index);
			}
			else {
				return "";
			}
		}
	}
}
