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
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.formats.FormatValue;

		

		
	// [ExcludeClass]
	/** A property description with an Array value.@private */
	public class ArrayProperty extends Property
	{
		private var _memberType:*;
		
		public function ArrayProperty(nameValue:String, defaultValue:Array, inherited:Boolean, categories:Vector.<String>, mType:Class)
		{
			super(nameValue, defaultValue, inherited, categories); 
			_memberType = mType;
			CONFIG::debug { assert(_memberType.description != null,"Array member class must have description"); }
			// can defaultValue be INHERIT?
			CONFIG::debug { assert(checkArrayTypes(defaultValue),"Array has bad defaultValue"); }
		}
		
		/** The type the members of the array are required to be. */
		public function get memberType():*
		{ return _memberType; }
		
		protected function checkArrayTypes(val:Object):Boolean
		{
			if (val == null)
				return true;
			if (!(val is Array))
				return false;
			if (_memberType == null)
				return true;
			for each (var obj:Object in (val as Array))
			{
				if (!(obj is _memberType))
					return false;
			}
			return true;
		}
		
		/** @private */
		public override function get defaultValue():*
		{ return super.defaultValue == null ? null : (super.defaultValue as Array).slice();	}
				
		/** @private */
		public override function setHelper(currVal:*,newVal:*):*
		{
			if (newVal === null)
				newVal = undefined;
			
			if (newVal == undefined || newVal == FormatValue.INHERIT)
				return newVal;

			if (newVal is String)
				newVal = this.valueFromString(String(newVal));
			
			if (!checkArrayTypes(newVal))
			{
				PropertyUtil.errorHandler(this,newVal);
				return currVal;
			}
			return (newVal as Array).slice(); 
		}

		/** @private */
		public override function concatInheritOnlyHelper(currVal:*,concatVal:*):*
		{
			return (inherited && currVal === undefined) || currVal == FormatValue.INHERIT ? ((concatVal is Array) ? (concatVal as Array).slice() : concatVal) : currVal;

		}	
		/** @private */
		public override function concatHelper(currVal:*,concatVal:*):*
		{
			if (inherited)
				return currVal === undefined || currVal == FormatValue.INHERIT ? ((concatVal is Array) ? (concatVal as Array).slice() : concatVal) : currVal;
			if (currVal === undefined)
				return defaultValue;
			return currVal == FormatValue.INHERIT ? ((concatVal is Array) ? (concatVal as Array).slice() : concatVal) : currVal;

		}	
		/** @private */
		public override function equalHelper(v1:*,v2:*):Boolean
		{
			if (_memberType != null)
			{			
				var v1Array:Array = v1 as Array;
				var v2Array:Array = v2 as Array;
		
				if (v1Array && v2Array)
				{			
					if (v1Array.length == v2Array.length)
					{
						var desc:Object = _memberType.description;
						for (var i:int=0; i < v1Array.length; ++i)
						{
							if (!PropertyUtil.equalAllHelper(desc, v1[i], v2[i]))
								return false;
						}
						return true;
					}
				}
			}
			return v1 == v2;				
		}
		
		/** @private */
		public override function toXMLString(val:Object):String
		{
			if (val == FormatValue.INHERIT)
				return String(val);
			// TODO-7/7/2008-The XML format for array properties (as implemented below)
			// is appropriate for what it is currently used, but can be ambiguous.
			// For example, what if XML representations of contained elements contain the delimiters used here? 
			 
			// TODO: Check for description?
			var desc:Object = _memberType.description;
			var rslt:String = "";
			var addSemi:Boolean = false;
			for each (var member:Object in val)
			{
				if (addSemi)
					rslt += "; ";
				// export each element ',' separated
				var addComma:Boolean = false;
				for each (var prop:Property in desc)
				{
					var memberVal:Object = member[prop.name];
					if (memberVal != null)
					{
						if (addComma)
							rslt += ", ";
						rslt += prop.name + ":" + prop.toXMLString(memberVal);
						addComma = true;
					}
				}
				addSemi = true;
			}
			return rslt;
		}
		
		/** @private */
		private function valueFromString(str:String):*
		{ 	
			// TODO-7/7/2008-The XML format for array properties can be ambiguous.
			// See comment in toXMLString.
			if ((str == null) || (str == "")) 
				return null;
			if (str == FormatValue.INHERIT)
				return str;
			var result:Array = new Array();
			var desc:Object = _memberType.description;
			
			var attrsAll:Array = str.split('; '); 
			for each (var attrs:String in attrsAll)
			{
			 	var obj:Object = new _memberType();	// NO PMD
			 	
			 	var attrsOne:Array = attrs.split(', ');
			 	for each (var attr:String in attrsOne)
			 	{
			 		var nameValArr:Array = attr.split(':');
			 		var propName:String = nameValArr[0];
			 		var propVal:String = nameValArr[1];
			 	
				 	for each (var prop:Property in desc)
				 	{
				 		if (prop.name == propName)
				 		{
				 			obj[propName] = prop.setHelper(propVal,obj[propName]);
				 			break;
				 		}
			 		}
			 	}
			 	result.push(obj);
			}
				
			return result; 
		}
	}
}
