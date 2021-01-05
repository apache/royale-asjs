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
import mx.globalization.DateTimeStyle;

import mx.formatters.DateFormatter;


public class DateTimeFormatter
{
	public var actualLocaleIDName:String;
	public var lastOperationStatus:String;
	public var requestedLocaleIDName:String;

	public function DateTimeFormatter(requestedLocaleIDName:String, dateStyle:String = "long", timeStyle:String = "long")
	{
		if (dateStyle == null || timeStyle == null)
		{
			lastOperationStatus = LastOperationStatus.ILLEGAL_ARGUMENT_ERROR;
			return;
		}

		// TODO
		if (requestedLocaleIDName == LocaleID.DEFAULT)
		{
			// TODO
		}
		actualLocaleIDName = "";
		lastOperationStatus = LastOperationStatus.USING_DEFAULT_WARNING;  /* or NO_ERROR */
		this.requestedLocaleIDName = requestedLocaleIDName;

		this._dateStyle = dateStyle;
		this._timeStyle = timeStyle;
		this._dateTimePattern = calculateDateTimePattern(dateStyle, timeStyle);
		fmtDateTimePattern = convertDateTimePatternToFmt(this._dateTimePattern);
		fmt = new mx.formatters.DateFormatter();
	}

	public function format(dateTime:Date):String
	{
		var s:String;

		// TODO
		fmt.formatString = fmtDateTimePattern;
		s = fmt.format(dateTime);

		lastOperationStatus = LastOperationStatus.NO_ERROR;
		return s;
	}
 	 	
	public function formatUTC(dateTime:Date):String
	{
		var s:String;

		// TODO
		fmt.formatString = fmtDateTimePattern;
		s = fmt.format(dateTime);

		lastOperationStatus = LastOperationStatus.NO_ERROR;
		return s;
	}

	public static function getAvailableLocaleIDNames():Vector.<String>
	{
		// HOW? This is a static function... lastOperationStatus = LastOperationStatus.UNSUPPORTED_ERROR;
		return null;
	}
 	 	
	public function getDateStyle():String
	{
		lastOperationStatus = LastOperationStatus.NO_ERROR;
		return _dateStyle;
	}

	public function getDateTimePattern():String
	{
		lastOperationStatus = LastOperationStatus.NO_ERROR;
		return _dateTimePattern;
	}

	public function getFirstWeekday():int
	{
		lastOperationStatus = LastOperationStatus.NO_ERROR;
		// TODO
		return 0;  // Sunday
	}
 	 	
	public function getMonthNames(nameStyle:String = "full", context:String = "standalone"):Vector.<String>
	{
		// TODO
		var full_months:Vector.<String> = new <String>["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
		var abbrev_months:Vector.<String> = new <String>["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
		lastOperationStatus = LastOperationStatus.NO_ERROR;
		return nameStyle == "full" ? full_months : abbrev_months;
	}

	public function getTimeStyle():String
	{
		lastOperationStatus = LastOperationStatus.NO_ERROR;
		return _timeStyle;
	}

	public function getWeekdayNames(nameStyle:String = "full", context:String = "standalone"):Vector.<String>
	{
		// TODO
		var full_weekdays:Vector.<String> = new <String>["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
		var abbrev_weekdays:Vector.<String> = new <String>["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
		lastOperationStatus = LastOperationStatus.NO_ERROR;
		return nameStyle == "full" ? full_weekdays : abbrev_weekdays;
	}

	public function setDateTimePattern(pattern:String):void
	{
		if (pattern == null)
		{
			lastOperationStatus = LastOperationStatus.ILLEGAL_ARGUMENT_ERROR;
			return;
		}
		this._dateTimePattern = pattern;
		this._dateStyle = DateTimeStyle.CUSTOM;
		this._timeStyle = DateTimeStyle.CUSTOM;
		fmtDateTimePattern = convertDateTimePatternToFmt(this._dateTimePattern);
		lastOperationStatus = LastOperationStatus.NO_ERROR;
	}
 	 	
	public function setDateTimeStyles(dateStyle:String, timeStyle:String):void
	{
		if (dateStyle == null || timeStyle == null)
		{
			lastOperationStatus = LastOperationStatus.ILLEGAL_ARGUMENT_ERROR;
			return;
		}
		this._dateStyle = dateStyle;
		this._timeStyle = timeStyle;
		this._dateTimePattern = calculateDateTimePattern(dateStyle, timeStyle);
		fmtDateTimePattern = convertDateTimePatternToFmt(this._dateTimePattern);
		lastOperationStatus = LastOperationStatus.NO_ERROR;
	}


	private function calculateDateTimePattern(dateStyle:String, timeStyle:String):String
	{
		var pattern:String = "";
		if (dateStyle == DateTimeStyle.LONG)
		{
			pattern += "MMM dd, yyyy";
		}
		else // SHORT, etc.
		{
			pattern += "yyyy/MM/dd";
		}
		pattern += " ";
		if (timeStyle == DateTimeStyle.LONG)
		{
			pattern += "HH:mm:ss";
		}
		else // SHORT, etc.
		{
			pattern += "HH:mm:ss";
		}
		return pattern;
	}

	private function convertDateTimePatternToFmt(pattern:String):String
	{
		var fmt : String;

		// translate pattern to the lower-level API that we're currently using
		fmt = pattern;
		fmt = fmt.replace(/Y/g, "");
		fmt = fmt.replace(/y/g, "Y");
		fmt = fmt.replace(/D/g, "");
		fmt = fmt.replace(/d/g, "D");
		fmt = fmt.replace(/N/g, "");
		fmt = fmt.replace(/m/g, "N");
		fmt = fmt.replace(/S/g, "");
		fmt = fmt.replace(/s/g, "S");
		return fmt;
	}


	private var fmt:mx.formatters.DateFormatter;
	private var fmtDateTimePattern:String;

	private var _dateTimePattern:String;
	private var _dateStyle:String;
	private var _timeStyle:String;
}

}
