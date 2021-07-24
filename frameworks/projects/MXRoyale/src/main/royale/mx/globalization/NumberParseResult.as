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

package mx.globalization
{

/**
 *  A data structure that holds information about a number that was extracted by
 *  parsing a string.
 *
 *  <p>The number string can contain a prefix and suffix surrounding a number. 
 *  In such cases the <code>startIndex</code> property is set to the first 
 *  character of the number.  Also, the <code>endIndex</code> property is set to
 *  the index of the character that follows the last character of the 
 *  number.</p>
 *
 *  @see NumberFormatter#parse()
 *  @see NumberFormatter#parseNumber()
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.1
 *  @playerversion AIR 2.0
 *  @productversion Royale 0.9.8
 */
public class NumberParseResult
{
	/**
	 *  The index of the character after the last character of the numeric portion
	 *  of the input string. 
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public var endIndex:int;

	/**
	 *  The index of the first character of the numeric portion of the input 
	 *  string.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public var startIndex:int;

	/**
	 *  The value of the numeric portion of the input string.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public var value:Number;


	/**
	 *  Constructs a number parse result object.  NumberParseResult objects are 
	 *  usually created by the <code>NumberFormatter.parse()</code> and 
	 *  <code>NumberFormatter.parseNumber()</code> methods, rather than by calling
	 *  this constructor directly.
	 *
	 *  @param value The value of the numeric portion of the input string.
	 *  @param startIndex The index of the first character of the number in the 
	 *          input string.
	 *  @param endIndex The index of the character after the last character of the
	 *          number in the input string.
	 *
	 *  @see NumberFormatter#parse()
	 *  @see NumberFormatter#parseNumber()
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public function NumberParseResult(value:Number = NaN, startIndex:int = 0x7fffffff, endIndex:int = 0x7fffffff)
	{
		this.value = value;
		this.startIndex = startIndex;
		this.endIndex = endIndex;
	}
}

}
