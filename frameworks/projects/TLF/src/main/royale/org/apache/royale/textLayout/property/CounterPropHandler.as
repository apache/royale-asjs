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
	// [ExcludeClass]
	public class CounterPropHandler extends PropertyHandler
	{
		override public function get className():String
		{
			return "CounterPropHandler";
		}
		private var _defaultNumber:int;
		
		public function CounterPropHandler(defaultNumber:int)
		{ _defaultNumber = defaultNumber; }
		
		public function get defaultNumber():int
		{ return _defaultNumber; }
		
		// check to see if this handler has a custom exporter that must be used when owningHandlerCheck is true
		public override function get customXMLStringHandler():Boolean
		{ return true; }
		
		public override function toXMLString(val:Object):String
		{ return val["ordered"] == 1 ? "ordered" : "ordered " + val["ordered"]; }
		
		static private  const _orderedPattern:RegExp = /^\s*ordered(\s+-?\d+){0,1}\s*$/;
		
		// return a value if this handler "owns" this property - otherwise return undefined
		public override function owningHandlerCheck(newVal:*):*
		{ return newVal is String && _orderedPattern.test(newVal) || newVal.hasOwnProperty("ordered") ? newVal : undefined; }
		
		static private const _orderedBeginPattern:RegExp = /^\s*ordered\s*/g;
		
		// returns a new val based on - assumes owningHandlerCheck(newval) is true
		public override function setHelper(newVal:*):*
		{ 
			var s:String = newVal as String;
			if (s == null)
				return newVal;	// assume its an object that's been parsed already

			_orderedBeginPattern.lastIndex = 0;
			_orderedBeginPattern.test(s);
			var number:int = (_orderedBeginPattern.lastIndex != s.length) ? parseInt(s.substr(_orderedBeginPattern.lastIndex)) : _defaultNumber; 
				
			return { ordered:number }; 
		}
	}
}
