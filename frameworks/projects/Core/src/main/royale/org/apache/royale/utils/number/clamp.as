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
	 *  Returns the value constrained to the range defined by the minimum and maximum values.
	 * 
	 *  @param value The number to constrain.
	 *  @param min The minimum value.
	 *  @param max The maximum value.
	 *  @return The value constrained to the range defined by the minimum and maximum values.
	 * 
	 *  @example
	 *  <pre>
	 *  var value:Number = 5;
	 *  var min:Number = 0;
	 *  var max:Number = 10;
	 *  trace(clamp(value, min, max)); // 5
	 *  value = -5;
	 *  trace(clamp(value, min, max)); // 0
	 *  value = 15;
	 *  trace(clamp(value, min, max)); // 10
	 *  </pre>
	 */
	public function clamp(value:Number, min:Number, max:Number):Number
	{
		if(value < min) return min;
		if(value > max) return max;
		return value;
	}
}