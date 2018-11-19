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
package org.apache.royale.jewel.beads.models
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IRangeModel;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.ValueChangeEvent;
			
	/**
	 *  The RangeModel class bead defines a set of for a numeric range of values
	 *  which includes a minimum, maximum, and current value.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class RangeModel extends EventDispatcher implements IBead, IRangeModel
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function RangeModel()
		{
		}
		
		protected var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}

		private var _maximum:Number = 100;
		
		/**
		 *  The maximum value for the range (defaults to 100).
		 * 
		 *  @copy org.apache.royale.core.IRangeModel#maximum
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get maximum():Number
		{
			return _maximum;
		}
		
		public function set maximum(value:Number):void
		{
			if (value != _maximum)
			{
				_maximum = value;
				if (_value > _maximum) _value = _maximum;
				dispatchEvent(new Event("maximumChange"));
			}
		}
		
		private var _minimum:Number = 0;
		
		/**
		 *  The minimum value for the range (defaults to 0).
		 * 
		 *  @copy org.apache.royale.core.IRangeModel#minimum
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get minimum():Number
		{
			return _minimum;
		}
		
		public function set minimum(value:Number):void
		{
			if (value != _minimum)
			{
				_minimum = value;
				if (_value < _minimum) _value = _minimum;
				dispatchEvent(new Event("minimumChange"));
			}
		}

		private var _snapInterval:Number = 1;
		
		/**
		 *  The modulus value for the range. 
		 * 
		 *  @copy org.apache.royale.core.IRangeModel#snapInterval
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get snapInterval():Number
		{
			return _snapInterval;
		}
		
		public function set snapInterval(value:Number):void
		{
			if (value != _snapInterval)
			{
				_snapInterval = value;
				dispatchEvent(new Event("snapIntervalChange"));
			}
			if(("" + value).indexOf(".") == -1)
			{
				_decimals = 0;
			}
			else
			{
				var str:String = "" + value;
				_decimals = str.substr(str.indexOf(".")+1).length;
			}
		}
		private var _decimals:int;
		
		private var _stepSize:Number = 1;
		
		/**
		 *  The amount to adjust the value either up or down toward the edge of the range.
		 * 
		 *  @copy org.apache.royale.core.IRangeModel#stepSize
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get stepSize():Number
		{
			return _stepSize;
		}
		
		public function set stepSize(value:Number):void
		{
			if (value != _stepSize)
			{
				_stepSize = value;
				dispatchEvent(new Event("stepSizeChange"));
			}
		}
		
		private var _value:Number = 0;
		
		/**
		 *  The current value of the range, between the minimum and maximum values. Attempting
		 *  to set the value outside of the minimum-maximum range changes the value to still be
		 *  within the range. Note that the value is adjusted by the stepSize.
		 * 
		 *  @copy org.apache.royale.core.IRangeModel#value
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get value():Number
		{
			return _value;
		}
		
		public function set value(newValue:Number):void
		{
			if (newValue != _value)
			{
				// value must lie within the boundaries of minimum & maximum
				// and be on a step interval, so the value is adjusted to 
				// what is coming in.
				newValue = Math.max(minimum, newValue);
				newValue = Math.min(maximum, newValue);
				var oldValue:Number = _value;
				_value = snap(newValue);
				dispatchEvent(ValueChangeEvent.createUpdateEvent(_strand, "value", oldValue, _value));
			}
		}
		
		/**
		 * @private
		 */
		protected function snap(value:Number):Number
		{
			var si:Number = snapInterval;
			var n:Number = Math.round((value - minimum) / si) * si + minimum;
			if(_decimals)
				n = Number(n.toFixed(_decimals));
			if (value > 0)
			{
				if (value - n < n + si - value)
					return n;
				return n + si;
				
			}
			if (value - n > n + si - value)
				return n + si;
			return n;
		}
		
	}
}
