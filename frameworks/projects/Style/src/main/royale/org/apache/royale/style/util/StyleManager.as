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
package org.apache.royale.style.util
{
	import org.apache.royale.debugging.assert;

	public class StyleManager
	{
		private function StyleManager()
		{
			// Static only class.
		}
		COMPILE::JS
		private static const styleList:Set = new Set();

		public static function hasStyle(selector:String):Boolean
		{
			COMPILE::JS
			{
				return styleList.has(selector);
			}
			COMPILE::SWF
			{
				return false;
			}
		}
		public static function addStyle(selector:String, normalizedSelector:String, rule:String):void
		{
			COMPILE::JS
			{
				assert(!styleList.has(selector), "Style " + selector + " already exists");
				styleList.add(selector);
				addRule(normalizedSelector, rule);
			}
		}

		private static var ruleIdx:int = 0;

		private static function addRule(selector:String, rule:String):void
		{
			COMPILE::JS
			{
				getStyleSheet().insertRule(selector + "{" + rule + "}", ruleIdx++);
			}
		}
		COMPILE::JS
		private static var ss:CSSStyleSheet;
		COMPILE::JS
		private static function getStyleSheet():CSSStyleSheet
		{
			if (!ss)
			{
				var styleElement:HTMLStyleElement = document.createElement('style') as HTMLStyleElement;
				document.head.appendChild(styleElement);
				ss = styleElement.sheet as CSSStyleSheet;
			}
			return ss;
		}
		COMPILE::JS
		private static const mediaList:Map = new Map();

		public static function hasQuery(identifier:String):Boolean
		{
			COMPILE::JS
			{
				return mediaList.has(identifier);
			}
			COMPILE::SWF
			{
				return false;
			}
		}
		/**
		 * TODO: Should really be CSSGroupingRule.
		 * It needs to be added to typedefs
		 * */
		COMPILE::JS
		public static function getQuery(identifier:String):CSSRule
		{
			if (!mediaList.has(identifier))
			{
				return null;
			}
			return mediaList.get(identifier) as CSSRule;
		}
		
		/**
		 * 
		 * @param identifier
		 * @param query
		 * @param parentId
		 *
		 * @royaleignorecoercion CSSStyleSheet
		 */
		public static function addQuery(identifier:String, query:String,parentId:String = null):void
		{
			COMPILE::JS
			{
				assert(!mediaList.has(identifier), "Media query " + identifier + " already exists");
				var idx:int;
				var rule:CSSRule;
				if(parentId)
				{
					var parentQuery:CSSRule = getQuery(parentId);
					assert(parentQuery, "Parent query " + parentId + " does not exist");
					// TODO remove this once we have CSSGroupingRule in the typedefs
					var fakeType:CSSStyleSheet = parentQuery as CSSStyleSheet;
					idx = fakeType.insertRule(query, fakeType.cssRules.length);
					rule = fakeType.cssRules.item(idx);
					mediaList.set(identifier, rule);
				}
				else
				{
					idx = getStyleSheet().insertRule(query, ruleIdx++);
					rule = getStyleSheet().cssRules.item(idx);
					mediaList.set(identifier, rule);
				}
			}
		}
		
		/**
		 * 
		 * @param identifier
		 * @param selector
		 * @param normalizedSelector
		 * @param rule
		 * 
		 * 
		 * @royaleignorecoercion CSSStyleSheet
		 */
		public static function addGroupedRule(identifier:String, selector:String, normalizedSelector:String, rule:String):void
		{
			COMPILE::JS
			{
				// TODO Change this once we have CSSGroupingRule in the typedefs
				var toGroup:CSSRule = getQuery(identifier);
				// TODO remove this once we have CSSGroupingRule in the typedefs
				var fakeType:CSSStyleSheet = toGroup as CSSStyleSheet;
				//var fakeType:CSSGroupingRule = toGroup as CSSGroupingRule;
				var len:int = fakeType.cssRules.length;
				fakeType.insertRule(normalizedSelector + "{" + rule + "}", len);
				styleList.add(selector);
			}
		}
		
		
		public static function addCustomProperty(propertyName:String,syntax:String,inherits:Boolean = true,initialValue:String = null):Boolean{
			assert(propertyName && propertyName.indexOf('--') == 0, "propertyName " + propertyName + " not correctly specified");
			assert(syntax && syntax.charAt(0) == "<" && syntax.charAt(syntax.length - 1) == ">", "syntax " + syntax + " not correctly specified");
			var uniquePropertyDeclaration:String = "@property " + propertyName ;
			
			var hasInitial:Boolean = initialValue != null && initialValue.replace(/\s+/g, "").length > 0;
			var rule:String = 	uniquePropertyDeclaration + " {\n" +
								"  syntax: \"" + syntax + "\";\n" +
								"  inherits: " + (inherits ? "true" : "false") + ";\n" +
								(hasInitial ? "  initial-value: " + initialValue + ";\n" : "") +
								"}";
			
			var success:Boolean = false;
			
			COMPILE::JS
			{
				assert(!styleList.has(uniquePropertyDeclaration), "Custom Property " + uniquePropertyDeclaration + " already exists");
				try {
					getStyleSheet().insertRule(rule, ruleIdx++);
					styleList.add(uniquePropertyDeclaration);
					success = true;
				} catch (e:Error) {}
			}
			
			return success
		}
		
		public static function hasCustomProperty(propertyName:String):Boolean{
			COMPILE::JS
			{
				assert(propertyName && propertyName.indexOf('--') == 0, "propertyName " + propertyName + " not correctly specified");
				var uniquePropertyDeclaration:String = "@property " + propertyName ;
				return styleList.has(uniquePropertyDeclaration);
			}
			COMPILE::SWF
			{
				return false;
			}
		}

	}
}