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

// originally flash.xx
import mx.globalization.LastOperationStatus;
import mx.globalization.LocaleID;

import mx.formatters.NumberBase;
import mx.formatters.NumberFormatter;


public class NumberFormatter
{
	public var actualLocaleIDName:String;
	public var lastOperationStatus:String;
	public var requestedLocaleIDName:String;

	public var decimalSeparator:String;
	public var digitsType:uint;
	public var fractionalDigits:int;
	public var groupingPattern:String;
	public var groupingSeparator:String;
	public var leadingZero:Boolean;
	public var negativeNumberFormat:uint;
	public var negativeSymbol:String;
	public var trailingZeros:Boolean;
	public var useGrouping:Boolean;


	public function NumberFormatter(requestedLocaleIDName:String)
	{
		// TODO
		if( requestedLocaleIDName == LocaleID.DEFAULT )
		{
			// TODO
		}
		actualLocaleIDName = "";
		lastOperationStatus = LastOperationStatus.USING_DEFAULT_WARNING;  /* or NO_ERROR */
		this.requestedLocaleIDName = requestedLocaleIDName;

		fmt = new mx.formatters.NumberFormatter();

		decimalSeparator = "";
		digitsType = 0;
		fractionalDigits = 0;
		groupingPattern = "";
		groupingSeparator = "";
		leadingZero = false;
		negativeNumberFormat = 0;
		negativeSymbol = "";
		trailingZeros = false;
		useGrouping = false;
	}

	public static function getAvailableLocaleIDNames():Vector.<String>
	{
		// HOW? This is a static function... lastOperationStatus = LastOperationStatus.UNSUPPORTED_ERROR;
		return null;
	}

	public function formatInt(value:int):String
	{
		var s:String;

		// TODO
		s = fmt.format(value);

		lastOperationStatus = LastOperationStatus.NO_ERROR;
		return s;
	}

	public function formatNumber(value:Number):String
	{
		var s:String;

		// TODO
		s = fmt.format(value);

		lastOperationStatus = LastOperationStatus.NO_ERROR;
		return s;
	}

	public function formatUint(value:uint):String
	{
		var s:String;

		// TODO
		s = fmt.format(value);

		lastOperationStatus = LastOperationStatus.NO_ERROR;
		return s;
	}

	public function parse(parseString:String):NumberParseResult
	{
		// TODO
		return new NumberParseResult(parseNumber(parseString));
	}

	public function parseNumber(parseString:String):Number
	{
		// TODO
		var parser:NumberBase = new NumberBase(".", ",", ".", ",");
		var num:Number = Number(parser.parseNumberString(parseString));
		return num;
	}
 	 	

	private var fmt:mx.formatters.NumberFormatter;
}

}
