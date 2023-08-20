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
		/**
	 *  Rounds a number to the specified precision (the number of digits in a
	 *  decimal number). The precision can range from 0 to 28. If you omit this
	 *  parameter, Math.round() rounds to the nearest integer.
	 *
	 *  @param value The number to round.
	 *
	 *  @param precision The number of decimal places to which to round. If you
	 *  omit this parameter, Math.round() rounds to the nearest integer.
	 *
	 *  @return The rounded value.
	 *
	 *  @example
	 *  <pre>
	 *  trace(MathUtil.round(3.14159, 3)) // 3.142
	 *  trace(MathUtil.round(3.14159, 2)) // 3.14
	 *  trace(MathUtil.round(3.14159, 1)) // 3.1
	 *  trace(MathUtil.round(3.14159, 0)) // 3
	 *  trace(MathUtil.round(3.14159, -1)) // 0
	 *  trace(MathUtil.round(314159, -2)) // 314200
	 *  trace(MathUtil.round(314159, -3)) // 314000
	 *  trace(MathUtil.round(314159, -4)) // 310000
	 *  </pre>
	 * 
	 *  @langversion 3.0
	 *  @productversion Royale 0.9.10
	 * 
	 */
	public function toDecimals(value:Number, precision:int = 0):Number
	{
		var decimalPlaces:Number = Math.pow(10, precision);
		return Math.round(decimalPlaces * value) / decimalPlaces;
	}
}