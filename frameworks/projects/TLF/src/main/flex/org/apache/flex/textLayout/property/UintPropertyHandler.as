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
	/** A property description with an unsigned integer as its value.  Typically used for color. @private */
	public class UintPropertyHandler extends PropertyHandler
	{	
		override public function get className():String
		{
			return "UintPropertyHandler";
		}
		public override function get customXMLStringHandler():Boolean
		{ return true; }
		
		public override function toXMLString(val:Object):String
		{		
			var result:String = val.toString(16);
			if (result.length < 6)
				result = "000000".substr(0, 6 - result.length) + result;
			result = "#" + result;
			return result;
		}
		
		/** @private */
		public override function owningHandlerCheck(newVal:*):*
		{			
			if (newVal is uint)
				return newVal;
			
			var newRslt:Number;
			if (newVal is String)
			{
				var str:String = String(newVal);
				// Normally, we could just cast a string to a uint. However, the casting technique only works for
				// normal numbers and numbers preceded by "0x". We can encounter numbers of the form "#ffffffff"					
				if (str.substr(0, 1) == "#")
					str = "0x" + str.substr(1, str.length-1);
				newRslt = (str.toLowerCase().substr(0, 2) == "0x") ? parseInt(str) : NaN;
			}
			else if (newVal is Number || newVal is int)
				newRslt = Number(newVal);
			else
				return undefined;
			
			if (isNaN(newRslt))
				return undefined;

			if (newRslt < 0 || newRslt > 0xffffffff)
				return undefined;
			
			return newRslt;			
		}
	}
}
