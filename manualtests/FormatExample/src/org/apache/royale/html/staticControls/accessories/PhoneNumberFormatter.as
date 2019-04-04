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
package org.apache.royale.html.staticControls.accessories
{
	import org.apache.royale.core.FormatBase;

	/**
	 *  The PhoneNumberFormatter class bead formats a numeric string into a 
	 *  US style phone number. The format bead listens for changes to a property
	 *  in a model, formats the value, and dispatches a formatChanged event.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class PhoneNumberFormatter extends FormatBase
	{
		/**
		 *  constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function PhoneNumberFormatter()
		{
		}
		
		/**
		 *  The formatted string.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */		override public function format(value:Object):String
		{
			if (value == null) return "";
			
			var source:String = String(value);
			if (source.length != 10) return source;
			
			var areaCode:String = "";
			var exchange:String;
			var num:String;
			
			var pos:int = 0;
			if (source.length == 10) {
				areaCode = source.substr(pos,3);
				pos += 3;
			}
			
			exchange = source.substr(pos,3);
			pos += 3;
			
			num = source.substr(pos,4);
			
			var result:String = "";
			if (source.length == 10) {
				result = result + "("+areaCode+") ";
			}
			result = result + exchange + "-" + num;
			return result;
		}
	}
}
