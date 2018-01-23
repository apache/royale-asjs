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
package org.apache.royale.textLayout.property {

		


	// [ExcludeClass]
	/** A property description with a Number as its value. @private */
	public class NumberPropertyHandler extends PropertyHandler
	{
		override public function get className():String
		{
			return "NumberPropertyHandler";
		}
		private const ALL_LIMITS:String = "allLimits";
		private const LOWER_LIMIT:String ="lowerLimit";
		private const UPPER_LIMIT:String = "upperLimit";
		private var _minValue:Number;
		private var _maxValue:Number;
		private var _limits:String;
		
		public function NumberPropertyHandler(minValue:Number,maxValue:Number,limits:String = ALL_LIMITS)
		{
			_minValue = minValue;
			_maxValue = maxValue;
			_limits = limits;
		}
		
		override public function get minValue():Number
		{ return _minValue; }
		override public function get maxValue():Number
		{ return _maxValue; } 

		/** not yet enabled.  @private */
		public function checkLowerLimit():Boolean
		{ return _limits == ALL_LIMITS || _limits == LOWER_LIMIT; }
		
		/** not yet enabled.  @private */
		public function checkUpperLimit():Boolean
		{ return _limits == ALL_LIMITS || _limits == UPPER_LIMIT; }	
		
		// return true if this handler can "own" this property
		public override function owningHandlerCheck(newVal:*):*
		{			
			var newNumber:Number = newVal is String ? parseFloat(newVal) : Number(newVal);
			if (isNaN(newNumber))
				return undefined;
			if (checkLowerLimit() && newNumber < _minValue)
				return undefined;
			if (checkUpperLimit() && newNumber > _maxValue)
				return undefined;
			return newNumber;	
		}

		public function clampToRange(val:Number):Number
		{
			if (checkLowerLimit() && val < _minValue)
				return _minValue;
			if (checkUpperLimit() && val > _maxValue)
				return _maxValue;
			return val;			
		}
	}
}
