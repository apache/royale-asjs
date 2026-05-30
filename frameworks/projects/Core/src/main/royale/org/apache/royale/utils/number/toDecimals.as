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
package org.apache.royale.utils.number
{
	import org.apache.royale.debugging.assert;

	/**
	 *  Rounds a number to the specified number of decimal places.
	 *
	 *  @param value The number to round.
	 *
	 *  @param precision The number of decimal places to keep. Positive values
	 *  keep digits to the right of the decimal point. Negative values are not supported.
	 *
	 *  @return The rounded value.
	 *
	 *  @example
	 *  <pre>
	 *  trace(toDecimals(3.14159, 3)) // 3.142
	 *  trace(toDecimals(3.14159, 2)) // 3.14
	 *  trace(toDecimals(3.14159, 0)) // 3
	 *  </pre>
	 *
	 *  @langversion 3.0
	 *  @productversion Royale 0.9.10
	 */
	public function toDecimals(value:Number, precision:int = 0):Number
	{
		assert(precision >= 0, "Negative precision is not supported.");
		var decimalPlaces:Number = Math.pow(10, precision);
		return Math.round(decimalPlaces * value) / decimalPlaces;
	}
}