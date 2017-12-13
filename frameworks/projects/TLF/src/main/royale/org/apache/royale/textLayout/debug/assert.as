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
package org.apache.royale.textLayout.debug 
{

		


	/** @private
	 *  Debug only function that prints a trace message if condition is false.
	 *  @return count of errors reported this assert: 1 or 0.
	 * */
	CONFIG::debug
	public function assert(condition:Boolean, warning:String):int
	{
		if (!condition)
		{
			trace("ERROR: " + warning);
			// throw if the bit is set
			if (Debugging.throwOnAssert)
				throw(new Error("TextLayoutAssert: " + warning));
			return 1;
		}
		return 0;
	}
	/** @private */
	CONFIG::release 
	public function assert(condition:Boolean, warning:String):void 
	{
	} 
} // end package
