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
package org.apache.royale.textLayout.property
{
	import org.apache.royale.textLayout.elements.GlobalSettings;
	public class PropertyUtil
	{

		public static var errorHandler:Function = defaultErrorHandler;
		public static function defaultErrorHandler(p:Property,value:Object):void
		{
			throw(new RangeError(createErrorString(p,value)));
		}
		public static function createErrorString(p:Property,value:Object):String
		{
			return GlobalSettings.resourceStringFunction("badPropertyValue",[ p.name, value.toString() ]);
		}
		public static function defaultConcatHelper(currVal:*,concatVal:*):*
		{ return currVal === undefined || currVal == "inherit" ? concatVal : currVal; }

		// /////////////////////////////////////////////
		// Following static functions are used by Format classes to 
		// perform functions that iterate over all the attributes.
		// They are driven by the attributes metadata object that contains
		// definitions for all the properties.
		// /////////////////////////////////////////////
			
		/** Helper function to initialize all property values from defaults. */
		static public function defaultsAllHelper(description:Object,current:Object):void
		{
			for each (var prop:Property in description)
				current[prop.name] = prop.defaultValue;
		}
		
		/** Helper function to compare two sets of properties. */
		static public function equalAllHelper(description:Object,p1:Object,p2:Object):Boolean
		{
			if (p1 == p2)
				return true;
			// these could be "equal" if all attributes of p1 or p2 are null
			if (p1 == null || p2 == null)
				return false;
			for each (var prop:Property in description)
			{
				var name:String = prop.name;
				if (!(prop.equalHelper(p1[name],p2[name])))
					return false;
			}
			return true;
		}

		static public function extractInCategory(formatClass:Class,description:Object,props:Object,category:String,legacy:Boolean = true):Object
		{
			var rslt:Object = null;
			for each (var prop:Property in description)
			{
				if (props[prop.name] == null)
					continue;
				
				if (legacy)
				{
					if (prop.category != category)
						continue;
				}
				else if (prop.categories.indexOf(category) == -1)
					continue;
				
				if (rslt == null)
					rslt = new formatClass();
				rslt[prop.name] = props[prop.name];
			}
			return rslt;
		}
		
		/** @private Copy an object */
		static public function shallowCopy(src:Object):Object
		{
			// make a shallow copy
			var rslt:Object = {};
			for (var val:Object in src)
				rslt[val] = src[val]; 
			return rslt;
		}
		
		/** @private Copy properties from src to result if a property of the same name exists in filter */
		static public function shallowCopyInFilter(src:Object,filter:Object):Object
		{
			// make a shallow copy
			var rslt:Object = {};
			for (var val:Object in src)
			{
				if (filter.hasOwnProperty(val))
					rslt[val] = src[val];
			}
			return rslt;
		}
		
		/** @private Copy properties from src to result if a property of the same name exists in filter */
		static public function shallowCopyNotInFilter(src:Object,filter:Object):Object
		{
			// make a shallow copy
			var rslt:Object = {};
			for (var val:Object in src)
			{
				if (!filter.hasOwnProperty(val))
					rslt[val] = src[val];
			}
			return rslt;
		}
		
		static private function compareStylesLoop(o1:Object,o2:Object,description:Object):Boolean
		{
			for (var val:String in o1)
			{
				var o1val:Object = o1[val];
				var o2val:Object = o2[val];
				if (o1val != o2val)
				{
					if (!(o1val is Array) || !(o2val is Array) || o1val.length != o2val.length || !description)
						return false;	// different
					var prop:ArrayProperty = description[val];
					if (!prop || !equalAllHelper(prop.memberType["description"],o1val,o2val))
						return false;
				}
			}
			return true;
		}
		/** @private */
		static public const nullStyleObject:Object = {};
		/** @private */
		static public function equalStyles(o1:Object,o2:Object,description:Object):Boolean
		{
			if (o1 == null)
				o1 = nullStyleObject;
			if (o2 == null)
				o2 = nullStyleObject;
			// Use of prototype chains and bug https://bugzilla.mozilla.org/show_bug.cgi?id=447673 requires this two way compare
			return compareStylesLoop(o1,o2,description) && compareStylesLoop(o2,o1,description);
		}
		
		/** @private */
		static public function toNumberIfPercent(o:Object):Number
		{
			if (!(o is String))
				return NaN;
			var s:String = String(o);
			var len:int = s.length;
			
			return len != 0 && s.charAt(len-1) == "%" ? parseFloat(s) : NaN;
		}
		
		static private var prototypeFactory:Function = function():void{};
		
		/** @private Create an object with specified prototype parent */
		static public function createObjectWithPrototype(parent:Object):Object
		{
			prototypeFactory.prototype = parent;
			return new prototypeFactory();
		}
	}
}
