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
	import org.apache.royale.core.IDeferredModel;
			
	/**
	 *  The DeferredRangeModel class bead defines a set of for a numeric range of values
	 *  which includes a minimum, maximum, and current value.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.10
	 */
	public class DeferredRangeModel extends RangeModel implements IDeferredModel
	{
		
		private var _deferredMaximum:Number = 100;
		
		/**
		 *  Whether or not model population is deferred
		 * 
		 *  @copy org.apache.royale.core.IDeferredModel#deferred
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.10
		 */
		override public function get maximum():Number
		{
			return _deferred ? _deferredMaximum : super.maximum;
		}
		
		override public function set maximum(value:Number):void
		{
			if (_deferred)
			{
				_deferredMaximum = value;
			} else
			{
				super.maximum = value;
			}
		}
		
		private var _deferredMinimum:Number = 0;
		
		/**
		 *  The minimum value for the range (defaults to 0).
		 * 
		 *  @copy org.apache.royale.core.IRangeModel#minimum
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.10
		 */
		override public function get minimum():Number
		{
			return _deferred ? _deferredMinimum : super.minimum;
		}
		
		override public function set minimum(value:Number):void
		{
			if (_deferred)
			{
				_deferredMinimum = value;
			} else
			{
				super.minimum = value;
			}
		}

		private var _deferredSnapInterval:Number = 1;
		
		/**
		 *  The modulus value for the range. 
		 * 
		 *  @copy org.apache.royale.core.IRangeModel#snapInterval
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.10
		 */
		override public function get snapInterval():Number
		{
			return _deferred ? _deferredSnapInterval : super.snapInterval;
		}
		
		override public function set snapInterval(value:Number):void
		{
			if (_deferred)
			{
				_deferredSnapInterval = value;
			} else
			{
				super.snapInterval = value;
			}
		}
		private var _decimals:int;
		
		private var _deferredStepSize:Number = 1;
		
		/**
		 *  The amount to adjust the value either up or down toward the edge of the range.
		 * 
		 *  @copy org.apache.royale.core.IRangeModel#stepSize
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.10
		 */
		override public function get stepSize():Number
		{
			return _deferred ? _deferredStepSize : super.stepSize;
		}
		
		override public function set stepSize(value:Number):void
		{
			if (_deferred)
			{
				_deferredStepSize = value;
			} else
			{
				super.stepSize = value;
			}
		}
		
		private var _deferredValue:Number = 0;
		
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
		 *  @productversion Royale 0.9.10
		 */
		override public function get value():Number
		{
			return _deferred ? _deferredValue : super.value;
		}
		
		override public function set value(newValue:Number):void
		{
			if (_deferred)
			{
				_deferredValue = newValue;
			} else
			{
				super.value = newValue;
			}
		}

		private var _deferred:Boolean = true;
		public function set deferred(value:Boolean):void
		{
			_deferred = value;
			if (!value)
			{
				// It's important to maintain the right order, specifically value should be populated last
				super.snapInterval = _deferredSnapInterval;
				super.stepSize = _deferredStepSize;
				super.minimum = _deferredMinimum;
				super.maximum = _deferredMaximum;
				super.value = _deferredValue;
			}
		}
	}
}
