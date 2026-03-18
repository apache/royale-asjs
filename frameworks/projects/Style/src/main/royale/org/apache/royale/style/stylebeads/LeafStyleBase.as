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
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.util.CSSLookup;
	import org.apache.royale.style.util.StyleData;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.util.CSSUnit;
	import org.apache.royale.style.util.StyleManager;
	/**
	 * @royalesuppressexport
	 */
	abstract public class LeafStyleBase extends StyleBeadBase implements ILeafStyleBead
	{
		public function LeafStyleBase(selectorBase:String, ruleBase:String, value:* = null)
		{
			super();
			_selectorBase = selectorBase;
			_ruleBase = ruleBase;
			if(value)
				this.value = value;
		}
		override public function get isLeaf():Boolean
		{
			return true;
		}
		override public function getLeaves():Array
		{
			// Walk up the chain decorating the styles.
			if(parentStyle)
				parentStyle.decorateChildStyle(this,[]);
			return [this];
		}
		protected var _value:*;

		public function get value():*
		{
			return _value;
		}

		abstract public function set value(value:*):void;

		protected var _selectorBase:String = "";
		/**
		 * The base of the selector.
		 * This is used to generate the final selector by appending the calculatedSelector value.
		 */
		public function get selectorBase():String
		{
			return _selectorBase;
		}
		/**
		 * The type of the style.
		 * This is used to ensure that all style types are only applied once.
		 * 
		 * This is usually the same as the ruleBase, but it can be overridden if necessary.
		 * 
		 * In many classes the ruleBase can be shared across multiple style types.
		 */
		public function get styleType():String
		{
			return ruleBase;
		}
		private var _selectorPrefix:String = "";
		/**
		 * A prefix to the selector.
		 * This is used to generate the final selector by prepending the prefix to the selectorBase and calculatedSelector.
		 * This value should be decorated by parent styles when necessary to generate the appropriate selector
		 * for the style being applied.
		 */
		public function get selectorPrefix():String
		{
			return _selectorPrefix;
		}

		public function set selectorPrefix(value:String):void
		{
			_selectorPrefix = value;
		}
		protected var _ruleBase:String = "";
		/**
		 * The base of the rule.
		 * This is used to generate the final rule by appending the calculatedRuleValue.
		 */
		public function get ruleBase():String
		{
			return _ruleBase;
		}

		public function set ruleBase(value:String):void
		{
			_ruleBase = value;
		}
		private var _rulePrefix:String = "";
		/**
		 * A prefix to the rule.
		 * This is used to generate the final rule by prepending the prefix to the ruleBase and calculatedRuleValue.
		 * This value should be decorated by parent styles when necessary to generate the appropriate rule
		 * for the style being applied.
		 */
		public function get rulePrefix():String
		{
			return _rulePrefix;
		}

		public function set rulePrefix(value:String):void
		{
			_rulePrefix = value;
		}
		private var _ruleSuffix:String = "";

		/**
		 * A suffix to the rule.
		 * This is used to generate the final rule by appending the suffix to the ruleBase and calculatedRuleValue.
		 * This value should be decorated by parent styles when necessary to generate the appropriate rule
		 * for the style being applied.
		 */
		public function get ruleSuffix():String
		{
			return _ruleSuffix;
		}

		public function set ruleSuffix(value:String):void
		{
			_ruleSuffix = value;
		}
		/**
		 * All subclasses should set this value when the value is set.
		 * This allows the base class to generate
		 * the appropriate selectors and rules.
		 */
		protected var _calculatedSelector:String;

		protected function get calculatedSelector():String
		{
			return _calculatedSelector;
		}

		protected function set calculatedSelector(value:String):void
		{
			_calculatedSelector = sanitizeSelector(value);
		}
		protected var calculatedRuleValue:String;
		public function getSelector():String
		{
			if(!calculatedSelector)
				return "";
			
			var str:String = selectorPrefix + selectorBase;
			if(str)
				str += "-";
			var selector:String = str + calculatedSelector;
			/**
			 * Always add the rule automatically when accessing the selector if needed.
			 */
			var selectorForRule:String = rulePrefix + normalizeSelector(selector) + ruleSuffix;
			if (!StyleManager.hasStyle(selectorForRule))
			{
				if(parentQueryId)
					StyleManager.addGroupedRule(parentQueryId, selectorForRule, getRule());
				else
					StyleManager.addStyle(selectorForRule, getRule());
			}

			return selector;
		}
		private function normalizeSelector(selector:String):String
		{			// TODO this is pretty naive. We should probably be doing some kind of parsing here.
			return "." + selector.replace(/:/g, "\\:").replace(/\./g, "\\.").replace(/\//g, "\\/");
		}

		public function getRule():String
		{
			if(!calculatedRuleValue)
				return "";
			return ruleBase + ":" + calculatedRuleValue + ";";
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
		protected function acceptVar(value:String):String
		{
			return isVar(value) ? fromVar(value) : value;
		}
		protected function getAfterDash(value:String):String
		{
			var dashIndex:int = value.indexOf("-");
			if(dashIndex >= 0)
				return value.substring(dashIndex + 1);
			return value;
		}
		protected function getBeforeDash(value:String):String
		{
			var dashIndex:int = value.indexOf("-");
			if(dashIndex >= 0)
				return value.substring(0, dashIndex);
			return value;
		}
		protected function isVar(value:String):Boolean
		{
			return CSSLookup.has(value);
		}
		protected function fromVar(value:String):String
		{
			return CSSLookup.getProperty(value);
		}
		protected function isNum(value:*):Boolean
		{
			return parseFloat(value) == value;
		}
		protected function isInt(value:*):Boolean
		{
			return int(value) == value;
		}
		protected function isNegative(value:*):Boolean
		{
			return ("" + value).indexOf("-") == 0;
		}

		private var _unit:String = "rem";
		[Inspectable(category="General", enumeration="px,em,rem", defaultValue="rem")]
		public function get unit():String
		{
			return _unit;
		}

		public function set unit(value:String):void
		{
			_unit = value;
		}
		protected function computeSpacing(value:Number):String
		{
			var pixelValue:Number = ThemeManager.instance.activeTheme.spacing * value;
			return CSSUnit.convert(pixelValue, CSSUnit.PX, unit) + unit;
		}
		private var _parentQueryId:String;
		/**
		 * The id of the parent query if one exists.
		 * Used to add the rule to the correct nested group.
		 */
		public function get parentQueryId():String
		{
			return _parentQueryId;
		}

		public function set parentQueryId(value:String):void
		{
			_parentQueryId = value;
		}
		override public function decorateChildStyle(style:ILeafStyleBead, decorations:Array):void
		{
			assert(false, "Leaf styles should not have child styles.");
		}
	}
}