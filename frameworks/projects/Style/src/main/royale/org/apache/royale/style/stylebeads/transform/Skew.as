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
package org.apache.royale.style.stylebeads.transform
{
	import org.apache.royale.style.stylebeads.LeafStyleBase;
	import org.apache.royale.debugging.assert;

	public class Skew extends LeafStyleBase
	{
		public function Skew(value:* = null)
		{
			super("skew", "transform", value);
		}
		override public function get styleType():String
		{
			return selectorBase;
		}
		public function set skew(value:*):void
		{
			_skewX = _skewY = null;
			this.value = value;
		}
		private var _skewX:*;

		public function set skewX(value:*):void
		{
			_skewX = _value = value;
			calculateVals();
		}
		private var _skewY:*;

		public function set skewY(value:*):void
		{
			_skewY = value;
			calculateVals();
		}

		override public function set value(value:*):void
		{
			_value = value;
			calculateVals();
		}
		private function calculateVals():void
		{
			var negative:Boolean = false;
			var selectors:Array = [];
			var rules:Array = [];
			if(_skewX != null)
			{
				negative ||= _skewX + "".indexOf("-") == 0;
				selectors.push("x-" + positive(_skewX));
				rules.push("skewX(" + parseVal(_skewX) + ")");
			}
			if(_skewY != null)
			{
				negative ||= _skewY + "".indexOf("-") == 0;
				selectors.push("y-" + positive(_skewY));
				rules.push("skewY(" + parseVal(_skewY) + ")");
			}
			if(rules.length)
			{
				calculatedRuleValue = rules.join(" ");
				calculatedSelector = selectors.join("-");
			}
			else
			{
				calculatedRuleValue = "skewX(" + parseVal(_value) + ") " +"skewY(" + parseVal(_value) + ")";
				calculatedSelector = positive(_value);
			}
			_selectorBase = negative ? "-skew" : "skew";
		}
		private function positive(val:*):String
		{
			var valStr:String = "" + val;
			if(valStr.indexOf("-") == 0)
				return valStr.substring(1);
			return valStr;
		}
		private function parseVal(value:*):String{
			if(value == "none")
				return "none";
			if(parseFloat(value) == value)
				return value + "deg";
			if(isVar(value))
				return fromVar(value);
			assert(false, "Invalid value for skew: " + value);
			return value;
		}
	}
}