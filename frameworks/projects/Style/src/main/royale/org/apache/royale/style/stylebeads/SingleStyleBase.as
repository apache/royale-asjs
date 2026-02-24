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
	abstract public class SingleStyleBase extends StyleBeadBase
	{
		public function SingleStyleBase(selectorPrefix:String, rulePrefix:String)
		{
			super();
			_selectorPrefix = selectorPrefix;
			_rulePrefix = rulePrefix;
		}
		protected var _value:*;

		public function get value():*
		{
			return _value;
		}

		abstract public function set value(value:*):void;

		protected var _selectorPrefix:String = "";

		public function get selectorPrefix():String
		{
			return _selectorPrefix;
		}
		private var _rulePrefix:String = "";

		public function get rulePrefix():String
		{
			return _rulePrefix;
		}

		public function set rulePrefix(value:String):void
		{
			_rulePrefix = value;
		}
		/**
		 * All subclasses should set this value when the value is set.
		 * This allows the base class to generate
		 * the appropriate selectors and rules.
		 */
		protected var calculatedSelector:String;
		protected var calculatedRuleValue:String;
		override public function get selectors():Array
		{
			return selector ? [selector] : [];
		}
		override public function get rules():Array
		{
			return rule ? [rule] : [];
		}
		public function get selector():String
		{
			if(!calculatedSelector)
				return "";
			return selectorPrefix + "-" + calculatedSelector;
		}
		public function get rule():String
		{
			if(!calculatedRuleValue)
				return "";
			return rulePrefix + ":" + calculatedRuleValue + ";";
		}
		protected function sanitizeSelector(value:String):String
		{
			var strVal:String = "" + value;
			if(strVal.indexOf("-") == 0)
				strVal = strVal.substring(1);
			if(strVal == "100%")
				return "full";
			if(strVal.indexOf("%") >= 0)
				strVal = strVal.replace(/%/g, "p");
			
			return strVal.replace(/[\.\s]/g, "-");
		}

	}
}