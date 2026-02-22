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
package org.apache.royale.style.stylebeads
{
	import org.apache.royale.style.util.CSSUnit;
	import org.apache.royale.debugging.assert;

	abstract public class MeasurementStyleBase extends StyleBeadBase implements IMeasurementStyleBead
	{
		public function MeasurementStyleBase()
		{
			super();
		}

		protected var _strVal:String;
		private var _unit:String;

		public function get unit():String
		{
			return _unit || CSSUnit.PX;
		}

		public function set unit(value:String):void
		{
			_unit = value;
		}

		private var _percentSize:Number;
		/**
		 * The percent size of the measurement.
		 */
		public function get percentSize():Number
		{
			return _percentSize;
		}

		public function set percentSize(value:Number):void
		{
			_percentSize = Math.round(value * 100) / 100;
		}

		public function get fractionalSize():Number
		{
			return isNaN(_percentSize) ? 0 : _percentSize / 100;
		}

		public function set fractionalSize(value:Number):void
		{
			percentSize = value * 100;
		}

		private var _stepSize:Number = 4;

		public function get stepSize():Number
		{
			return _stepSize;
		}

		public function set stepSize(value:Number):void
		{
			_stepSize = value;
		}

		private var _stepValue:Number;
		[Inspectable(category="General", defaultValue="NaN", minValue="0", maxValue="1000")]
		public function get stepValue():Number
		{
			return _stepValue;
		}
		public function set stepValue(value:Number):void
		{
			_stepValue = value;
		}
		protected function toSelector():String
		{
			if (!isNaN(_percentSize))
				return percentSize + "%";
			if (!isNaN(_stepValue))
				return unit + "-" + stepSize + "-" + stepValue;
			if(_strVal)
				return _strVal;
			
			assert(false, "MeasurementStyleBase: No valid measurement value.");
			return "";
		}
		protected function toRuleVal():String
		{
			if (!isNaN(_percentSize))
				return percentSize + "%";
			if (!isNaN(_stepValue))
				return (stepValue*stepSize) + unit;
			if(_strVal)
				return _strVal;
			
			return "";
		}

	}
}