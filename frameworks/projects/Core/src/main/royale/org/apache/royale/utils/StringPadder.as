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
package org.apache.royale.utils
{
	/**
	 *  The StringPadder utility class is an all-static class with methods for
	 *  working with String objects.
	 *  You do not create instances of StringPadder;
	 *  instead you call methods such as 
	 *  the <code>StringPadder.pad()</code> method.  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 1.0.0
	 *  @productversion Royale 0.0
	 */
	public class StringPadder
	{

		/**
		 *  Pads a string with an arbitrary string.
		 *
		 *  @param str The string to be padded.
		 *
		 *  @param padChar The character used to pad the string. This should be a single character.
		 *
		 *  @param size The size of the padded string.
		 *
		 *  @param padRight Which side to add the padding on. By default it's added to the left.
		 *
		 *  @return The padded string.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 1.0.0.1
		 *  @productversion Royale 0.0
		 */
		public static function pad(str:String,padChar:String,size:int,padRight:Boolean=false):String
		{
			str = str ? str : "";

			size+=1;
			size -= str.length;
			var p:String = new Array(size).join(padChar);
			if(padRight)
				return str + p;
			else
				return p + str;
		}
	}
}
