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
 *  A data structure that represents a currency amount and currency symbol or 
 *  string that were extracted by parsing a currency value.
 *
 *  @see CurrencyFormatter.parse()
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.1
 *  @playerversion AIR 2.0
 *  @productversion Royale 0.9.8
 */
public class CurrencyParseResult
{
	/**
	 *  The portion of the input string that corresponds to the currency symbol or
	 *  currency string.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public var currencyString : String;

	/**
	 *  The currency amount value that was extracted from the input string.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public var value : Number;

	/**
	 *  Constructs a currency parse result object.
	 *
	 *  @param value A number representing the currency amount value.
	 *  @param symbol A string representing the currency symbol.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public function CurrencyParseResult(value:Number = NaN, symbol:String = "")
	{
		this.value = value;
		this.currencyString = symbol;
	}
}

}
