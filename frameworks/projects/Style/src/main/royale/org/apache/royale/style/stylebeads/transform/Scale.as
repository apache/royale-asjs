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

	public class Scale extends LeafStyleBase
	{
		public function Scale(value:* = null)
		{
			super("scale", "scale", value);
		}

		public function set scale(value:*):void
		{
			_scaleX = _scaleY = _scaleZ = null;
			this.value = value;
		}
		private var _scaleX:*;

		public function set scaleX(value:*):void
		{
			_scaleX = _value = value;
			calculateVals();
		}
		private var _scaleY:*;

		public function set scaleY(value:*):void
		{
			_scaleY = value;
			calculateVals();
		}
		private var _scaleZ:*;

		public function set scaleZ(value:*):void
		{
			_scaleZ = value;
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
			if(_scaleX != null)
			{
				negative ||= _scaleX + "".indexOf("-") == 0;
				selectors.push("x-" + positive(_scaleX));
				rules.push(parseVal(_scaleX));
			}
			if(_scaleY != null)
			{
				negative ||= _scaleY + "".indexOf("-") == 0;
				selectors.push("y-" + positive(_scaleY));
				rules.push(parseVal(_scaleY));
			}
			if(_scaleZ != null)
			{
				negative ||= _scaleZ + "".indexOf("-") == 0;
				selectors.push("z-" + positive(_scaleZ));
				rules.push(parseVal(_scaleZ));
			}
			if(rules.length)
			{
				calculatedRuleValue = rules.join(" ");
				calculatedSelector = selectors.join("-");
			}
			else
			{
				calculatedRuleValue = parseVal(_value) + " " + parseVal(_value);
				calculatedSelector = positive(_value);
			}
			_selectorBase = negative ? "-scale" : "scale";
		}
		private function positive(val:*):String
		{
			var valStr:String = "" + val;
			if(valStr.indexOf("-") == 0)
				return sanitizeSelector(valStr.substring(1));
			return sanitizeSelector(valStr);
		}
		private function parseVal(value:*):String{
			if(value == "none")
				return "none";
			if(isVar(value))
				return fromVar(value);
			assert(false, "Invalid value for scale: " + value);
			return value;
		}
	}
}