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
	public class PropertyHandler
	{
		public static function createRange(rest:Array):Object
		{
			var range:Object = {};
			// rest is the list of possible values
			for (var i:int = 0; i < rest.length; i++)
				range[rest[i]] = null;
			return range;
		}
		public function get className():String
		{
			return "PropertyHandler";
		}
		
		// check to see if this handler has a custom exporter that must be used when owningHandlerCheck is true
		public function get customXMLStringHandler():Boolean
		{ return false; }
	
		public function toXMLString(val:Object):String	// No PMD
		{ return null; }

		// return a value if this handler "owns" this property - otherwise return undefined
		public function owningHandlerCheck(newVal:*):*	// No PMD
		{ return undefined; }
		
			
		// returns a new val based on - assumes owningHandlerCheck(newval) is true
		public function setHelper(newVal:*):*
		{ return newVal; }

		public function get maxValue():Number
		{
			return NaN;
		}
		public function get minValue():Number
		{
			return NaN;
		}
	}

}
