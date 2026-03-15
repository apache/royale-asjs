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

	public class Rotate extends LeafStyleBase
	{
		public function Rotate(value:* = null)
		{
			super("rotate", "rotate", value);
		}

		public function set rotate(value:*):void
		{
			_rotateX = _rotateY = _rotateZ = null;
			this.value = value;
		}
		private var _rotateX:*;

		public function set rotateX(value:*):void
		{
			_rotateX = _value = value;
			calculateVals();
		}
		private var _rotateY:*;

		public function set rotateY(value:*):void
		{
			_rotateY = value;
			calculateVals();
		}
		private var _rotateZ:*;

		public function set rotateZ(value:*):void
		{
			_rotateZ = value;
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
			if(_rotateX != null)
			{
				negative ||= _rotateX + "".indexOf("-") == 0;
				selectors.push("x-" + positive(_rotateX));
				rules.push("rotateX(" + parseVal(_rotateX) + ")");
			}
			if(_rotateY != null)
			{
				negative ||= _rotateY + "".indexOf("-") == 0;
				selectors.push("y-" + positive(_rotateY));
				rules.push("rotateY(" + parseVal(_rotateY) + ")");
			}
			if(_rotateZ != null)
			{
				negative ||= _rotateZ + "".indexOf("-") == 0;
				selectors.push("z-" + positive(_rotateZ));
				rules.push("rotateZ(" + parseVal(_rotateZ) + ")");
			}
			if(rules.length)
			{
				calculatedRuleValue = rules.join(" ");
				calculatedSelector = selectors.join("-");
			}
			else
			{
				calculatedRuleValue = "rotate(" + parseVal(_value) + ")";
				calculatedSelector = positive(_value);
			}
			_selectorBase = negative ? "-rotate" : "rotate";
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
			assert(false, "Invalid value for rotate: " + value);
			return value;
		}
	}
}