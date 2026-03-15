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
package org.apache.royale.style.stylebeads.sizing
{
	import org.apache.royale.style.util.CSSUnit;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.stylebeads.LeafStyleBase;

	abstract public class MeasurementStyleBase extends LeafStyleBase
	{
		public function MeasurementStyleBase(selectorBase:String, ruleBase:String, value:* = null)
		{
			super(selectorBase, ruleBase, value);
		}
		override public function set value(value:*):void
		{
			calculatedRuleValue = calculatedSelector = _value = value;

			if(isInt(value))
			{
				calculatedRuleValue = computeSpacing(value);
				return;
			}
			else if(isNum(value))
			{
				percentSize = value * 100;
				return;
			}
			else if(isVar(value))
			{
				calculatedSelector = value;
				calculatedRuleValue = fromVar(value);
				return;
			}
			calculatedRuleValue = calculatedSelector = value;
			switch("" + value)
			{
				case "px":
					calculatedRuleValue = "1px";
					break;
				case "1px":
					calculatedSelector = "px";
					break;
				case "full":
					calculatedRuleValue = "100%";
					break;
				case "100%":
					calculatedSelector = "full";
					break;
				case "min-content":
					calculatedSelector = "min";
					break;
				case "min":
					calculatedRuleValue = "min-content";
					break;
				case "max-content":
					calculatedSelector = "max";
					break;
				case "max":
					calculatedRuleValue = "max-content";
					break;
				case "fit-content":
					calculatedSelector = "fit";
					break;
				case "fit":
					calculatedRuleValue = "fit-content";
					break;
				case "auto":
				case "stretch":
				case "none":
					return;
			}
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
			this.value = _percentSize + "%" ;
		}

		public function get fractionalSize():Number
		{
			return isNaN(_percentSize) ? 0 : _percentSize / 100;
		}

		public function set fractionalSize(value:Number):void
		{
			percentSize = value * 100;
		}

		private var _stepValue:Number;
		[Inspectable(category="General", defaultValue="NaN", minValue="0", maxValue="1000")]
		public function get stepValue():Number
		{
			return _stepValue;
		}
		public function set stepValue(value:Number):void
		{
			_value = value;
			calculatedSelector = _value = value;
			calculatedRuleValue = computeSpacing(value);
		}
		// protected function toSelector():String
		// {
		// 	if (!isNaN(_percentSize))
		// 		return percentSize + "%";
		// 	if (!isNaN(_stepValue))
		// 		return unit + "-" + stepSize + "-" + stepValue;
		// 	if(_strVal)
		// 		return _strVal;
			
		// 	assert(false, "MeasurementStyleBase: No valid measurement value.");
		// 	return "";
		// }
		// protected function toRuleVal():String
		// {
		// 	if (!isNaN(_percentSize))
		// 		return percentSize + "%";
		// 	if (!isNaN(_stepValue))
		// 		return (stepValue*stepSize) + unit;
		// 	if(_strVal)
		// 		return _strVal;
			
		// 	return "";
		// }

	}
}