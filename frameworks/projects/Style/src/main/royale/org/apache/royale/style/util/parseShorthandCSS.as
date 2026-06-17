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

	public function parseShorthandCSS(value:*):Array
	{
			if(value is Array)
			{
				assert(value.length > 0 && value.length <= 4, "shorthand accepts one to four values: " + value);
				return value;
			}
			if(!(value is String))
				return [value];
			var stringValue:String = value;
			var values:Array = [];
			var token:String = "";
			var parenDepth:int = 0;
			for(var i:int = 0; i < stringValue.length; i++)
			{
				var code:int = stringValue.charCodeAt(i);
				if(code == 40)
					parenDepth++;
				else if(code == 41)
					parenDepth--;
				if(parenDepth == 0 && (code == 32 || code == 9 || code == 10 || code == 13 || code == 12))
				{
					if(token.length > 0)
					{
						values.push(token);
						token = "";
					}
				}
				else
				{
					token += stringValue.charAt(i);
				}
			}
			if(token.length > 0)
				values.push(token);
			assert(values.length > 0, "padding shorthand accepts one to four values: " + value);
			assert(values.length <= 4, "padding shorthand accepts one to four values: " + value);
			return values;
	}
}