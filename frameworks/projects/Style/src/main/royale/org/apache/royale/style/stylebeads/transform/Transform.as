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

	public class Transform extends LeafStyleBase
	{
		public function Transform(value:* = null)
		{
			super("transform", "transform", value);
		}
		override public function set value(value:*):void
		{
			if(value == null)
			{
				_value = null;
				calculateValue();
				return;
			}
			assert(isVar(value) || value == "none", "Invalid value for transform: " + value);
			calculatedSelector = calculatedRuleValue = _value = value;
			if(isVar(value))
				calculatedRuleValue = fromVar(value);
		}
		private function calculateValue():void
		{
			var result:Array = [];
			var selectors:Array = [];
			if(translateX)
			{
				result.push("translateX(" + translateX + ")");
				selectors.push("translate-x-" + translateX);
			}
			if(translateY)
			{
				result.push("translateY(" + translateY + ")");
				selectors.push("translate-y-" + translateY);
			}
			if(rotate)
			{
				result.push("rotate(" + rotate + ")");
				selectors.push("rotate-" + rotate);
			}
			if(skewX)
			{
				result.push("skewX(" + skewX + ")");
				selectors.push("skew-x-" + skewX);
			}
			if(skewY)
			{
				result.push("skewY(" + skewY + ")");
				selectors.push("skew-y-" + skewY);
			}
			if(scaleX)
			{
				result.push("scaleX(" + scaleX + ")");
				selectors.push("scale-x-" + scaleX);
			}
			if(scaleY)
			{
				result.push("scaleY(" + scaleY + ")");
				selectors.push("scale-y-" + scaleY);
			}
			calculatedRuleValue = result.join(" ");
			calculatedSelector = selectors.join("-");
		}
		private var _translateX:String;

		public function get translateX():String
		{
			return _translateX;
		}

		public function set translateX(value:String):void
		{
			_translateX = value;
			calculateValue();
		}
		private var _translateY:String;

		public function get translateY():String
		{
			return _translateY;
		}

		public function set translateY(value:String):void
		{
			_translateY = value;
			calculateValue();
		}
		private var _rotate:String;

		public function get rotate():String
		{
			return _rotate;
		}

		public function set rotate(value:String):void
		{
			_rotate = value;
			calculateValue();
		}
		private var _skewX:String;

		public function get skewX():String
		{
			return _skewX;
		}

		public function set skewX(value:String):void
		{
			_skewX = value;
			calculateValue();
		}
		private var _skewY:String;

		public function get skewY():String
		{
			return _skewY;
		}

		public function set skewY(value:String):void
		{
			_skewY = value;
			calculateValue();
		}
		private var _scaleX:String;

		public function get scaleX():String
		{
			return _scaleX;
		}

		public function set scaleX(value:String):void
		{
			_scaleX = value;
			calculateValue();
		}
		private var _scaleY:String;

		public function get scaleY():String
		{
			return _scaleY;
		}

		public function set scaleY(value:String):void
		{
			_scaleY = value;
			calculateValue();
		}
	}
}

/**
     transform:
		 translate(var(--tw-translate-x),
		 var(--tw-translate-y))
		 rotate(var(--tw-rotate))
		 skewX(var(--tw-skew-x))
		 skewY(var(--tw-skew-y))
		 scaleX(var(--tw-scale-x))
		 scaleY(var(--tw-scale-y));
 */