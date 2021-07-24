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


/**
 *  The DateTimeFormatter class provides locale-sensitive formatting for Date 
 *  objects and access to localized date field names. The methods of this class 
 *  use functions and settings provided by the operating system. 
 *
 *  <p>There are two ways to select a date time format: using a predefined 
 *  pattern or a custom pattern. For most applications the predefined styles 
 *  specified by the DateTimeStyle constants (<code>LONG</code>, 
 *  <code>MEDIUM</code>, <code>NONE</code>, or <code>SHORT</code> should be 
 *  used.  These constants specify the default patterns for the requested 
 *  locale or the default patterns based on the user's operating system 
 *  settings.</p>
 *
 *  <p>For example the following code creates a date string using the default 
 *  short date format:</p>
 *
 *  <listing version="3.0">
 
 *  var df:DateTimeFormatter = new DateTimeFormatter(LocaleID.DEFAULT, DateTimeStyle.SHORT, DateTimeStyle.NONE);
 *  var currentDate:Date = new Date();
 *  var shortDate:String = df.format(currentDate);
 *  </listing>
 *
 *  <p>When an instance of this class is created, if the requested locale is 
 *  supported by the operating system then the properties of the instance are 
 *  set according to the conventions and defaults of the requested locale and 
 *  the constructor's <code>dateStyle</code> and <code>timeStyle</code> 
 *  parameters.  If the requested locale is not available, then the properties 
 *  are set according to a fallback or default system locale, which can be 
 *  retrieved using the <code>actualLocaleIDName</code> property.</p>
 *
 *  <p>This class contains additional methods to get localized strings for month 
 *  names and weekday names, and to retrieve the first day of the week that can 
 *  be used in a calendar picker or other similar application.</p>
 *
 *  <p>Due to the use of the user's settings, the use of formatting patterns
 *  provided by the operating system, and the use of a fallback locale when a 
 *  requested locale is not supported, different users can see different 
 *  formatting results even when using the same locale ID.</p>
 *
 *  @includeExample examples/DateTimeFormatterExample.mxml
 *
 *  @see #actualLocaleIDName
 *  @see DateTimeStyle
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.1
 *  @playerversion AIR 2.0
 *  @productversion Royale 0.9.8
 */
public class DateTimeFormatter
{
	/**
	 *  The name of the actual locale ID used by this DateTimeFormatter object.
	 *
	 *  <p>There are three possibilities for the value of the name, depending on 
	 *  operating system and the value of the <code>requestedLocaleIDName</code> 
	 *  parameter passed to the <code>Collator()</code> constructor.</p>
	 *
	 *  <ol>
	 *  <li>If the requested locale was not <code>LocaleID.DEFAULT</code> and the 
	 *  operating system provides support for the requested locale, then the name 
	 *  returned is the same as the <code>requestedLocaleIDName</code> 
	 *  property.</li>
	 *  <li>If <code>LocaleID.DEFAULT</code> was used as the value for the 
	 *  <code>requestedLocaleIDName</code> parameter to the constructor, then the 
	 *  name of the current locale specified by the user's operating system is 
	 *  used. The <code>LocaleID.DEFAULT</code> value preserves user's customized 
	 *  setting in the OS. Passing an explicit value as the 
	 *  <code>requestedLocaleIDName</code> parameter does not necessarily give the 
	 *  same result as using the <code>LocaleID.DEFAULT</code> even if the two 
	 *  locale ID names are the same. The user might have customized the locale 
	 *  settings on their machine, and by requesting an explicit locale ID name 
	 *  rather than using <code>LocaleID.DEFAULT</code> your application would not 
	 *  retrieve those customized settings.</li>
	 *  <li>If the system does not support the <code>requestedLocaleIDName</code> 
	 *  specified in the constructor then a fallback locale ID name is 
	 *  provided.</li>
	 *  </ol>
	 *
	 *  @see LocaleID
	 *  @see #requestedLocaleIDName
	 *  @see #DateTimeFormatter()
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public var actualLocaleIDName:String;

	/**
	 *  The status of previous operation that this DateTimeFormatter object 
	 *  performed.  The <code>lastOperationStatus</code> property is set whenever 
	 *  the constructor or a method of this class is called, or another property 
	 *  is set. For the possible values see the description for each method.
	 *
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public var lastOperationStatus:String;

	/**
	 *  The name of the requested locale ID that was passed to the constructor of 
	 *  this DateTimeFormatter object.
	 *
	 *  <p>If the <code>LocaleID.DEFAULT</code> value was used then the name 
	 *  returned is "i-default".  The actual locale used can differ from the 
	 *  requested locale when a fallback locale is applied.  The name of the actual
	 *  locale can be retrieved using the <code>actualLocaleIDName</code> property.</p>
	 *
	 *  @see LocaleID
	 *  @see #actualLocaleIDName
	 *  @see #DateTimeFormatter()
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public var requestedLocaleIDName:String;


	/**
	 *  Constructs a new DateTimeFormatter object to format dates and times 
	 *  according to the conventions of the specified locale and the provided date 
	 *  and time formatting styles. Date and time styles are used to set date and 
	 *  time formatting patterns to predefined, locale dependent patterns from the 
	 *  operating system.
	 *
	 *  <p>This constructor determines if the current operating system supports 
	 *  the requested locale ID name.  If it is not supported then a fallback 
	 *  locale is used instead.  The name of the fallback locale ID can be 
	 *  determined from the <code>actualLocaleIDName</code> property.</p>
	 *
	 *  <p>If a fallback is used for any of the <code>requestedLocaleIDName</code>,
	 *  <code>dateStyle</code> or <code>timeStyle</code> parameters then the 
	 *  <code>lastOperationStatus</code> property is set to indicate the type of 
	 *  fallback.</p>
	 *
	 *  <p>To format based on the user's current operating system preferences, pass
	 *  the value <code>LocaleID.DEFAULT</code> in the 
	 *  <code>requestedLocaleIDName</code> parameter to the constructor.</p>
	 *
	 *  <p>When the constructor is called and it completes successfully, the 
	 *  <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>When the requested locale ID name is not available then the 
	 *  <code>lastOperationStatus</code> is set to one of the following:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.USING_FALLBACK_WARNING</code></li>
	 *  <li><code>LastOperationStatus.USING_DEFAULT_WARNING</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one 
	 *  of the constants defined in the LastOperationStatus class.</p>
	 *
	 *  <p>For details on the warnings listed above and other possible values of 
	 *  the <code>lastOperationStatus</code> property see the descriptions in the 
	 *  <code>LastOperationStatus</code> class.</p>
	 *
	 *  @param requestedLocaleIDName The preferred locale ID name to use when 
	 *          determining date or time formats.
	 *  @param dateStyle Specifies the style to use when formatting dates.  The 
	 *          value corresponds to one of the values enumerated by the 
	 *          DateTimeStyle class:
	 *          <ul>
	 *              <li><code>DateTimeStyle.LONG</code> </li>
	 *              <li><code>DateTimeStyle.MEDIUM</code></li>
	 *              <li><code>DateTimeStyle.SHORT</code> </li>
	 *              <li><code>DateTimeStyle.NONE</code> </li>
	 *          </ul>
	 *  @param timeStyle Specifies the style to use when formatting times.  The 
	 *          value corresponds to one of the values enumerated by the 
	 *          DateTimeStyle class:
	 *          <ul>
	 *              <li><code>DateTimeStyle.LONG</code> </li>
	 *              <li><code>DateTimeStyle.MEDIUM</code></li>
	 *              <li><code>DateTimeStyle.SHORT</code> </li>
	 *              <li><code>DateTimeStyle.NONE</code> </li>
	 *          </ul>
	 *
	 *  @throws ArgumentError if the <code>dateStyle</code> or 
	 *          <code>timeStyle</code> parameter is not a valid DateTimeStyle 
	 *          constant.
	 *  @throws TypeError if the <code>dateStyle</code> or <code>timeStyle</code>
	 *          parameter is null.
	 *
	 *  @see #lastOperationStatus
	 *  @see #requestedLocaleIDName
	 *  @see #actualLocaleIDName
	 *  @see DateTimeStyle
	 *  @see LastOperationStatus
	 *  @see LocaleID
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
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

	/**
	 *  Formats a display string for a Date object that is interpreted as being in 
	 *  the user's local time (using the local time components of the Date object 
	 *  such as: date, day, fullYear, hours, minutes, month, and seconds).  The 
	 *  formatting is done using the conventions of the locale ID and the date 
	 *  style and time style, or customized date pattern and time pattern, 
	 *  specified for this DateTimeFormatter instance.
	 *
	 *  <p>When this method is called and it completes successfully, the 
	 *  <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one of
	 *  the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @param dateTime A <code>Date</code> value to be formatted. Valid range is 
	 *          from Jan 1, 1601 to Dec 31, 30827.
	 *
	 *  @return A formatted string representing the date or time value.
	 *
	 *  @see #setDateTimeStyles()
	 *  @see #setDateTimePattern()
	 *  @see #getDateStyle()
	 *  @see #getTimeStyle()
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public function format(dateTime:Date):String
	{
		var s:String;

		// TODO
		fmt.formatString = fmtDateTimePattern;
		s = fmt.format(dateTime);

		lastOperationStatus = LastOperationStatus.NO_ERROR;
		return s;
	}
 	 	
	/**
	 *  Formats a display string for a Date object that is interpreted as being in
	 *  UTC time (using the UTC components of the Date object such as: dateUTC, 
	 *  dayUTC, fullYearUTC, hoursUTC, minutesUTC, monthUTC, and secondsUTC), 
	 *  according to the dateStyle, timeStyle or date time pattern.  The formatting
	 *  is done using the conventions of the locale ID and the date style and time 
	 *  style, or customized date pattern and time pattern, specified for this 
	 *  DateTimeFormatter instance.
	 *
	 *  <p>When this method is called and it completes successfully, the 
	 *  <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one 
	 *  of the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @param dateTime A <code>Date</code> value to be formatted. Valid range is 
	 *          from Jan 1, 1601 to Dec 31, 30827. 
	 *
	 *  @return A formatted string representing the date or time value.
	 *
	 *  @see #setDateTimeStyles()
	 *  @see #setDateTimePattern()
	 *  @see #getDateStyle()
	 *  @see #getTimeStyle()
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public function formatUTC(dateTime:Date):String
	{
		var s:String;

		// TODO
		fmt.formatString = fmtDateTimePattern;
		s = fmt.format(dateTime);

		lastOperationStatus = LastOperationStatus.NO_ERROR;
		return s;
	}

	/**
	 *  Lists all of the locale ID names supported by this class.
	 *
	 *  <p>If this class is not supported on the current operating system, this 
	 *  method returns a null value.</p>
	 *
	 *  <p>When this method is called and it completes successfully, the 
	 *  <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one 
	 *  of the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @return A vector of strings containing all of the locale ID names 
	 *          supported by this class.
	 *
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *  @see LocaleID
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public static function getAvailableLocaleIDNames():Vector.<String>
	{
		// HOW? This is a static function... lastOperationStatus = LastOperationStatus.UNSUPPORTED_ERROR;
		return null;
	}
 	 	
	/**
	 *  Gets the date style for this instance of the DateTimeFormatter. The date 
	 *  style is used to retrieve a predefined date formatting pattern from the 
	 *  operating system.  The date style value can be set by the 
	 *  <code>DateTimeFormatter()</code> constructor, the 
	 *  <code>setDateTimeStyles()</code> method or the 
	 *  <code>setDateTimePattern()</code> method.
	 *
	 *  <p>When this method is called and it completes successfully, the 
	 *  <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one of
	 *  the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @return The date style string for this formatter.
	 *          <p>Possible values: </p>
	 *          <ul>
	 *            <li><code>DateTimeStyle.LONG</code> </li>
	 *            <li><code>DateTimeStyle.MEDIUM</code> </li>
	 *            <li><code>DateTimeStyle.SHORT </code></li>
	 *            <li><code>DateTimeStyle.NONE </code></li>
	 *            <li><code>DateTimeStyle.CUSTOM </code></li>
	 *          </ul>	 
	 *
	 *  @see #setDateTimeStyles()
	 *  @see #setDateTimePattern()
	 *  @see #lastOperationStatus
	 *  @see DateTimeStyle
	 *  @see DateTimeFormatter
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public function getDateStyle():String
	{
		lastOperationStatus = LastOperationStatus.NO_ERROR;
		return _dateStyle;
	}

	/**
	 *  Returns the pattern string used by this DateTimeFormatter object to format
	 *  dates and times.
	 *
	 *  <p>This pattern can be set in one of three ways:</p>
	 *
	 *  <ol>
	 *  <li>By the <code>dateStyle</code> and <code>timeStyle</code> parameters 
	 *  used in the constructor</li>
	 *  <li>By the <code>setDateTimeStyles()</code> method</li>
	 *  <li>By the <code>setDateTimePattern()</code> method.</li>
	 *  </ol>
	 *
	 *  <p>For a description of the pattern syntax, see the 
	 *  <code>setDateTimePattern()</code> method.</p>
	 *
	 *  <p>When this method is called and it completes successfully, the 
	 *  <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one 
	 *  of the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @return A string containing the pattern used by this DateTimeFormatter 
	 *          object to format dates and times.
	 *
	 *  @see DateTimeFormatter
	 *  @see #setDateTimeStyles()
	 *  @see #setDateTimePattern()
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public function getDateTimePattern():String
	{
		lastOperationStatus = LastOperationStatus.NO_ERROR;
		return _dateTimePattern;
	}

	/**
	 *  Returns an integer corresponding to the first day of the week for this 
	 *  locale and calendar system.  A value of 0 corresponds to Sunday, 1 
	 *  corresponds to Monday, and so on, with 6 corresponding to Saturday.
	 *
	 *  <p>When this method is called and it completes successfully, the 
	 *  <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one 
	 *  of the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @return An integer corresponding to the first day of the week for this 
	 *          locale and calendar system.
	 *
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus	 
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public function getFirstWeekday():int
	{
		lastOperationStatus = LastOperationStatus.NO_ERROR;
		// TODO
		return 0;  // Sunday
	}
 	 	
	/**
	 *  Retrieves a list of localized strings containing the month names for the 
	 *  current calendar system.  The first element in the list is the name for 
	 *  the first month of the year.
	 *
	 *  <p>When this method is called and it completes successfully, the 
	 *  <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one 
	 *  of the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @param nameStyle Indicates the style of name string to be used.  Valid 
	 *          values are:
	 *          <ul>
	 *            <li><code>DateTimeNameStyle.FULL</code></li>
	 *            <li><code>DateTimeNameStyle.LONG_ABBREVIATION</code></li>
	 *            <li><code>DateTimeNameStyle.SHORT_ABBREVIATION</code></li>
	 *          </ul>		         
	 *  @param context A code indicating the context in which the formatted string
	 *          is used.  This context makes a difference only for certain 
	 *          locales. Valid values are:
	 *          <ul>
	 *            <li><code>DateTimeNameContext.FORMAT</code></li>
	 *            <li><code>DateTimeNameContext.STANDALONE</code></li>
	 *          </ul> 
	 *
	 *  @return A vector of localized strings containing the month names for the 
	 *          specified locale, name style, and context.  The first element in 
	 *          the vector, at index 0, is the name for the first month of the 
	 *          year; the next element is the name for the second month of the 
	 *          year; and so on. 
	 *
	 *  @throws TypeError if the <code>nameStyle</code> or <code>context</code> 
	 *          parameter is null.
	 *
	 *  @see #lastOperationStatus
	 *  @see DateTimeNameContext
	 *  @see DateTimeNameStyle
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public function getMonthNames(nameStyle:String = "full", context:String = "standalone"):Vector.<String>
	{
		// TODO
		var full_months:Vector.<String> = new <String>["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
		var abbrev_months:Vector.<String> = new <String>["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
		lastOperationStatus = LastOperationStatus.NO_ERROR;
		return nameStyle == "full" ? full_months : abbrev_months;
	}

	/**
	 *  Gets the time style for this instance of the DateTimeFormatter. The time 
	 *  style is used to retrieve a predefined time formatting pattern from the 
	 *  operating system.  The time style value can be set by the 
	 *  <code>DateTimeFormatter()</code> constructor, the 
	 *  <code>setDateTimeStyles()</code> method or the 
	 *  <code>setDateTimePattern()</code> method.
	 *
	 *  <p>When this method is called and it completes successfully, the 
	 *  <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one 
	 *  of the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @return The time style string for this formatter.
	 *          <p>Possible values: </p>
	 *          <ul>
	 *            <li><code>DateTimeStyle.LONG</code> </li>
	 *            <li><code>DateTimeStyle.MEDIUM</code> </li>
	 *            <li><code>DateTimeStyle.SHORT </code></li>
	 *            <li><code>DateTimeStyle.NONE </code></li>
	 *            <li><code>DateTimeStyle.CUSTOM </code></li>
	 *          </ul> 
	 *
	 *  @see #setDateTimeStyles()
	 *  @see #setDateTimePattern()
	 *  @see #lastOperationStatus
	 *  @see DateTimeStyle
	 *  @see DateTimeFormatter
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public function getTimeStyle():String
	{
		lastOperationStatus = LastOperationStatus.NO_ERROR;
		return _timeStyle;
	}

	/**
	 *  Retrieves a list of localized strings containing the names of weekdays for
	 *  the current calendar system.  The first element in the list represents the
	 *  name for Sunday.
	 *
	 *  <p>When this method is called and it completes successfully, the 
	 *  <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one 
	 *  of the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @param nameStyle Indicates the style of name string to be used.  Valid 
	 *          values are:
	 *          <ul>
	 *            <li><code>DateTimeNameStyle.FULL</code></li>
	 *            <li><code>DateTimeNameStyle.LONG_ABBREVIATION</code></li>
	 *            <li><code>DateTimeNameStyle.SHORT_ABBREVIATION</code></li>
	 *          </ul>		         
	 *  @param context A code indicating the context in which the formatted string
	 *          is used.  This context only applies for certain locales where the 
	 *          name of a month changes depending on the context.  For example, in
	 *          Greek the month names are different if they are displayed alone 
	 *          versus displayed along with a day.  Valid values are:
	 *          <ul>
	 *            <li><code>DateTimeNameContext.FORMAT</code></li>
	 *            <li><code>DateTimeNameContext.STANDALONE</code></li>
	 *          </ul> 
	 *
	 *  @return A vector of localized strings containing the month names for the 
	 *          specified locale, name style, and context.  The first element in 
	 *          the vector, at index 0, is the name for Sunday; the next element 
	 *          is the name for Monday; and so on.
	 *
	 *  @throws TypeError if the <code>nameStyle</code> or <code>context</code> 
	 *          parameter is null.
	 *
	 *  @see #lastOperationStatus
	 *  @see DateTimeNameContext
	 *  @see DateTimeNameStyle
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public function getWeekdayNames(nameStyle:String = "full", context:String = "standalone"):Vector.<String>
	{
		// TODO
		var full_weekdays:Vector.<String> = new <String>["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
		var abbrev_weekdays:Vector.<String> = new <String>["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
		lastOperationStatus = LastOperationStatus.NO_ERROR;
		return nameStyle == "full" ? full_weekdays : abbrev_weekdays;
	}

	/**
	 *  Sets the pattern string used by this DateTimeFormatter object to format 
	 *  dates and times.
	 *
	 *  <p>The pattern used to format dates can be set in one of three ways:</p>
	 *
	 *  <ol>
	 *  <li>By the <code>dateStyle</code> and <code>timeStyle</code> parameters 
	 *  used in the constructor</li>
	 *  <li>By the <code>setDateTimeStyles()</code> method</li>
	 *  <li>By this <code>setDateTimePattern()</code> method.</li>
	 *  </ol>
	 *
	 *  <p>As a side effect this method overrides the current time and date styles
	 *  for this DateTimeFormatter object and set them to the value 
	 *  <code>DateTimeStyle.CUSTOM</code>.</p>
	 *
	 *  <p>A pattern string defines how date and times are formatted. The pattern 
	 *  contains sequences of letters that are replaced with date and time values 
	 *  in the formatted string.  For example, in the pattern "yyyy/MM" the 
	 *  characters "yyyy" are replaced with a four-digit year, followed by a "/" 
	 *  character, and the characters "MM" are replaced with a two-digit month.</p>
	 *
	 *  <p>Many of the letters used in patterns can be repeated more than once to 
	 *  produce different outputs, as described in the table below.</p>
	 *
	 *  <p>If a sequence exceeds the maximum number of letters supported by a 
	 *  pattern, it is mapped back to the longest supported sequence for that 
	 *  pattern letter.  For example:</p>
	 *
	 *  <ul>
	 *  <li> MMMMMM is replaced with MMMM</li>
	 *  <li> dddd is replaced with dd</li>
	 *  <li> EEEEEEE is replaced with EEEE</li>
	 *  <li> aa is replaced with a</li>
	 *  <li> hhh is replaced with hh</li>
	 *  <li> mmmm is replaced with mm</li>
	 *  </ul>
	 *
	 *  <p>In theory a pattern can contain up to 255 characters, but some 
	 *  platforms have stricter limit.  If the pattern exceeds the pattern 
	 *  character limit, the <code>lastOperationStatus</code> property is set to 
	 *  the value <code>LastOperationStatus.PATTERN_SYNTAX_ERROR</code>.</p>
	 *
	 *  <p>Not all possible patterns are supported on each operating system. If a 
	 *  pattern is not supported on the platform then a fallback pattern is used
	 *  and the <code>lastOperationStatus</code> property is set to indicate the 
	 *  use of a fallback.  If no reasonable fallback pattern can be provided, an 
	 *  empty string is used and the <code>lastOperationStatus</code> property is 
	 *  set to indicate that the pattern was unsupported.</p>
	 *
	 *  <p>The following table describes the valid pattern letters and their 
	 *  meaning.</p>
	 *
	 *  <table class="innertable">
	 *  <tbody>
	 *  <tr>
	 *  <td>Pattern letter</td>
	 *  <td>Description</td>
	 *  </tr>
	 *  <tr>
	 *  <td>G</td>
	 *  <td>Era. Replaced by the Era string for the current date and calendar. 
	 *    This pattern is not supported on all operating systems. On operating 
	 *    systems that do not support the era, the letters of the input pattern 
	 *    are replaced by an empty string.
	 *    <p>There can be one to five letters in era patterns that are interpreted 
	 *    as follows:</p>
	 *    <ul>
	 *    <li> If the number of pattern letters is one to three, the abbreviated 
	 *    form is used. </li>
	 *    <li> If the number of pattern letters is four, the format is interpreted 
	 *    as the full form. </li>
	 *    <li> If the number of pattern letters is five, the format is interpreted 
	 *    as the short abbreviation. </li>
	 *    </ul>
	 *    <p>Examples with the Gregorian Calendar(for operating systems that 
	 *    support this pattern):</p>
	 *    <ul>
	 *    <li> G, GG, GGG = AD </li>
	 *    <li> GGGG = Anno Domini</li>
	 *    <li> GGGGG = A</li>
	 *    </ul>
	 *  </td>
	 *  </tr>
	 *  <tr>
	 *  <td>y</td>
	 *  <td>Year. If the number of pattern letters is two, the last two digits of 
	 *    the year are displayed; otherwise the number of letters determines the 
	 *    number of digits. If the year value requires more digits than provided 
	 *    by the number of letters, then the full year value is provided. If there 
	 *    are more letters than required by the value, then the year values are 
	 *    padded with zeros.  The following list shows the results for the years 1 
	 *    and 2005.
	 *    <p>Examples:</p>
	 *    <ul>
	 *    <li> y = 1</li>
	 *    <li> y = 2005 </li>
	 *    <li> yy = 01</li>
	 *    <li> yy = 05</li>
	 *    <li> yyyy = 0001 or 01, Depending on the operating system.</li>
	 *    <li> yyyy = 2005</li>
	 *    <li> yyyyy = 01 or  0001, Depending on the operating system. More than 
	 *    four y's fall back to the maximum number of digits supported on the 
	 *    operating system.</li>
	 *    <li> yyyyy = 2005</li>
	 *    </ul>
	 *  </td>
	 *  </tr>
	 *  <tr>
	 *  <td>M </td>
	 *  <td>Month in year. There can be one to five letters in month patterns that
	 *    are interpreted as follows:
	 *    <ul>
	 *    <li> If the number of pattern letters is one, the format is interpreted 
	 *    as numeric in one or two digits. </li>
	 *    <li> If the number of pattern letters is two, the format is interpreted 
	 *    as numeric in two digits. </li>
	 *    <li> If the number of pattern letters is three, the format is 
	 *    interpreted as the long abbreviation. </li>
	 *    <li> If the number of pattern letters is four, the format is interpreted
	 *    as the full name. </li>
	 *    <li> If the number of pattern letters is five, the format is interpreted
	 *    as the short abbreviation. This format is not supported on all operating
	 *    systems and falls back to the long abbreviation. </li>
	 *    </ul>
	 *    <p>Examples:</p>
	 *    <ul>
	 *    <li> M = 7 </li>
	 *    <li> MM = 07</li>
	 *    <li> MMM = Jul, 7月</li>
	 *    <li> MMMM = July, 7月</li>
	 *    <li> MMMMM = J  or Jul, 7 or 7月 depending on the operating system.</li>
	 *    </ul>
	 *  </td>
	 *  </tr>
	 *  <tr>
	 *  <td>d </td>
	 *  <td>Day of the month.  There can be one or two letters in day of the month
	 *    patterns that are interpreted as follows:
	 *    <ul>
	 *    <li> If the number of pattern letters is one, the format is interpreted 
	 *    as numeric in one or two digits. </li>
	 *    <li> If the number of pattern letters is two, the format is interpreted 
	 *    as numeric in two digits. </li>
	 *    </ul>
	 *    <p>Examples:</p>
	 *    <ul>
	 *    <li> d = 4 </li>
	 *    <li> dd = 04</li>
	 *    <li> dd = 14</li>
	 *    </ul>
	 *  </td>
	 *  </tr>
	 *  <tr>
	 *  <td>E</td>
	 *  <td>Day in week.  There can be one to five letters in day of the week 
	 *    patterns that are interpreted as follows:
	 *    <ul>
	 *    <li> If the number of pattern letters is one to three, the format is 
	 *    interpreted as the long abbreviation. </li><li> If the number of pattern
	 *    letters is four, the format is interpreted as the full name. </li>
	 *    <li> If the number of pattern letters is five, the format is interpreted
	 *    as the short abbreviation. This format is not supported on all operating 
	 *    systems and falls back to the long abbreviation. </li>
	 *    </ul>
	 *    <p>Examples:</p>
	 *    <ul>
	 *    <li> E, EE, EEE = Tues</li>
	 *    <li> EEEE = Tuesday</li>
	 *    <li> EEEEE = T or Tues depending on the operating system.</li>
	 *    </ul>
	 *  </td>
	 *  </tr>
	 *  <tr>
	 *  <td>Q</td>
	 *  <td>Quarter. Some platforms do not support this pattern. There can be one 
	 *    to four letters in quarter patterns that are interpreted as follows:
	 *    <ul>
	 *    <li> If the number of pattern letters is one, the format is interpreted 
	 *    as numeric in one digit. </li>
	 *    <li> If the number of pattern letters is two, the format is interpreted 
	 *    as numeric in two digits. </li>
	 *    <li> If the number of pattern letters is three, the format is 
	 *    interpreted as the abbreviation. </li>
	 *    <li> If the number of pattern letters is four, the format is interpreted
	 *    as the full name. </li>
	 *    </ul>
	 *    <p>Examples (for operating systems that support this pattern):</p>
	 *    <ul>
	 *    <li> Q = 2 </li>
	 *    <li> QQ = 02</li>
	 *    <li> QQQ = Q2</li>
	 *    <li> QQQQ = second quarter</li>
	 *    </ul>
	 *  </td>
	 *  </tr>
	 *  <tr>
	 *  <td>w</td>
	 *  <td>Week of the year.  Some platforms do not support this pattern. There 
	 *    can be one to two letters in this pattern that are interpreted as 
	 *    follows.
	 *    <ul>
	 *    <li> If the number of pattern letters is one, the format is interpreted 
	 *    as numeric in one or two digits. </li>
	 *    <li> If the number of pattern letters is two, the format is interpreted 
	 *    as numeric in two digits. </li>
	 *    </ul>
	 *    <p>Examples for the second week of the year (for operating systems that 
	 *    support this pattern):</p>
	 *    <ul>
	 *    <li> w = 2 </li>
	 *    <li> ww = 02</li>
	 *    </ul>
	 *  </td>
	 *  </tr>
	 *  <tr>
	 *  <td>W</td>
	 *  <td>Week of the month. Some platforms do not support this pattern. This 
	 *    pattern allows one letter only.
	 *    <p>Examples for the second week of July (for operating systems that 
	 *    support this pattern):</p>
	 *    <ul>
	 *    <li> W = 2 </li>
	 *    </ul>
	 *  </td>
	 *  </tr>
	 *  <tr>
	 *  <td>D</td>
	 *  <td>Day of the year. Some platforms do not support this pattern. There can
	 *    be one to three letters in this pattern.
	 *    <p>Examples for the second day of the year (for operating systems that 
	 *    support this pattern):</p>
	 *    <ul>
	 *    <li> D = 2 </li>
	 *    <li> DD = 02</li>
	 *    <li> DDD = 002</li>
	 *    </ul>
	 *  </td>
	 *  </tr>
	 *  <tr>
	 *  <td>F</td>
	 *  <td>Occurrence of a day of the week within a calendar month. For example, 
	 *    this element displays "3" if used to format the date for the third Monday
	 *    in October.  This pattern allows one letter only. 
	 *    <p>Examples for the second Wednesday in July (for operating systems that 
	 *    support this pattern):</p>
	 *    <ul>
	 *    <li> F = 2</li>
	 *    </ul>
	 *  </td>
	 *  </tr>
	 *  <tr>
	 *  <td>a</td>
	 *  <td>AM/PM indicator.  This pattern allows one letter only, a or p.
	 *    <p>Examples:</p>
	 *    <ul>
	 *    <li> a = AM, 午前</li>
	 *    <li> p = PM, 午後</li>
	 *    </ul>
	 *  </td>
	 *  </tr>
	 *  <tr>
	 *  <td>h</td>
	 *  <td>Hour of the day in a 12-hour format [1 - 12]. This pattern must be one
	 *    or two letters.
	 *    <p>Examples:</p>
	 *    <ul>
	 *    <li> h = 1</li>
	 *    <li> h = 12</li>
	 *    <li> hh = 01</li>
	 *    </ul>
	 *  </td>
	 *  </tr>
	 *  <tr>
	 *  <td>H</td>
	 *  <td>Hour of the day in a 24-hour format [0 - 23]. This pattern must be one
	 *    or two letters.
	 *    <p>Examples:</p>
	 *    <ul>
	 *    <li> H = 0</li>
	 *    <li> H = 23</li>
	 *    <li> HH = 00</li>
	 *    </ul>
	 *  </td>
	 *  </tr>
	 *  <tr>
	 *  <td>K</td>
	 *  <td>Hour in the day in a 12-hour format [0 - 11]. This pattern must be one
	 *    or two letters.  This pattern is not supported on all operating systems. 
	 *    <p>Examples (for operating systems that support this pattern):</p>
	 *    <ul>
	 *    <li> K = 0</li>
	 *    <li> K = 11</li>
	 *    <li> KK = 00</li>
	 *    </ul>
	 *  </td>
	 *  </tr>
	 *  <tr>
	 *  <td>k</td>
	 *  <td>Hour of the day in a 24-hour format [1 - 24]. This pattern must be 
	 *    one or two letters.  This pattern is not supported on all operating 
	 *    systems. 
	 *    <p>Examples (for operating systems that support this pattern):</p>
	 *    <ul>
	 *    <li> k = 1</li>
	 *    <li> k = 24</li>
	 *    <li> kk = 01</li>
	 *    </ul>
	 *  </td>
	 *  </tr>
	 *  <tr>
	 *  <td>m</td>
	 *  <td>Minute of the hour [0 - 59]. This pattern must be one or two letters.
	 *    <p>Examples:</p>
	 *    <ul>
	 *    <li> m = 2</li>
	 *    <li> m = 59</li>
	 *    <li> mm = 02</li>
	 *    </ul>
	 *  </td>
	 *  </tr>
	 *  <tr>
	 *  <td>s</td>
	 *  <td>Seconds in the minute [0 - 59]. This pattern must be one or two 
	 *    letters.
	 *    <p>Examples:</p>
	 *    <ul>
	 *    <li> s = 2</li>
	 *    <li> s = 59</li>
	 *    <li> ss = 02</li>
	 *    </ul>
	 *  </td>
	 *  </tr>
	 *  <tr>
	 *  <td>S</td>
	 *  <td>Milliseconds. This pattern must be one to five letters. The value is 
	 *    rounded according to the number of letters used. When five characters 
	 *    are used (SSSSS) it denotes fractional milliseconds.
	 *    <p>Examples:</p>
	 *    <ul>
	 *    <li> S = 2</li>
	 *    <li> SS = 24</li>
	 *    <li> SSS = 235</li>
	 *    <li> SSSS = 2350</li>
	 *    <li> SSSSS = 23500</li>
	 *    </ul>
	 *  </td>
	 *  </tr>
	 *  <tr>
	 *  <td>z</td>
	 *  <td>Time Zone. Represents the time zone as a string that respects standard
	 *    or daylight time, without referring to a specific location. This pattern 
	 *    is not supported on all operating systems. On operating systems that do 
	 *    not support time zone patterns, the letters of the input pattern are 
	 *    replaced by an empty string.  On operating systems that do support this 
	 *    pattern, not all locales have a defined string. Those locales fall back
	 *    to a localized GMT format such as GMT-08:00 or GW-08:00
	 *    <p>There must be one to four letters in this time zone pattern, 
	 *    interpreted as follows:</p>
	 *    <ul>
	 *    <li> If the number of pattern letters is one to three, the format is 
	 *    interpreted as abbreviated form. </li>
	 *    <li> If the number of pattern letters is four, the format is 
	 *    interpreted as the full name. </li>
	 *    </ul>
	 *    <p>Examples for operating systems that support this format:</p>
	 *    <ul>
	 *    <li> z, zz, zzz = PDT</li>
	 *    <li> z, zz, zzz = PST</li>
	 *    <li> z, zz, zzz = GMT-0800</li>
	 *    <li> zzzz = Pacific Daylight Time</li>
	 *    <li> zzzz = Pacific Standard Time</li>
	 *    </ul>
	 *  </td>
	 *  </tr>
	 *  <tr>
	 *  <td>Z</td>
	 *  <td>Time Zone. Represents the time zone as an offset from GMT.  This 
	 *    pattern is not supported on all operating systems. On operating systems 
	 *    that do not support time zone patterns, the letters of the input pattern
	 *    are replaced by an empty string.
	 *    <p>There must be one to four letters in this time zone pattern, 
	 *    interpreted as follows:</p>
	 *    <ul>
	 *    <li> If the number of pattern letters is one to three, the format uses 
	 *    the RFC 822 format. </li>
	 *    <li> If the number of pattern letters is four, the format uses the 
	 *    localized GMT format.  This falls back to the non-localized GMT format 
	 *    for locales that do not have a localized GMT format. </li>
	 *    </ul>
	 *    <p>Examples for operating systems that support this format:</p>
	 *    <ul>
	 *    <li> Z, ZZ, ZZZ = -0800</li>
	 *    <li> ZZZZ = GMT-08:00, GW-08:00</li>
	 *    </ul>
	 *  </td>
	 *  </tr>
	 *  <tr>
	 *  <td>v</td>
	 *  <td>Time Zone. A string reflecting the generic time zone that does not 
	 *    refer to a specific location or distinguish between daylight savings 
	 *    time or standard time. This pattern is not supported on all operating 
	 *    systems. On operating systems that do not support time zone patterns the
	 *    letters of the input pattern are replaced by an empty string. On 
	 *    operating systems that support this pattern, fallback strings are 
	 *    provided if a localized name is not available.
	 *    <p>There must be one or four letters in this time zone pattern, 
	 *    interpreted as follows:</p>
	 *    <ul>
	 *    <li> If the number of pattern letters is one, the format uses the 
	 *    abbreviated form. </li>
	 *    <li> If the number of pattern letters is four, the format uses the full 
	 *    form. </li>
	 *    </ul>
	 *    <p>Examples for operating systems that support this format:</p>
	 *    <ul>
	 *    <li> v = PT</li>
	 *    <li> vvvv = Pacific Time</li>
	 *    </ul>
	 *  </td>
	 *  </tr>
	 *  <tr>
	 *  <td>'Other text'</td>
	 *  <td>Text and punctuation may be included in the pattern string. However 
	 *    the characters from a to z and A to Z, are reserved as syntax characters
	 *    and must be enclosed in single quotes to be included in the formatted 
	 *    string.  To include a single quote in the result string, two single 
	 *    quotes must be used in the pattern string. The two single quotes may 
	 *    appear inside or outside a quoted portion of the pattern string.  An 
	 *    unmatched pair of single quotes is terminated at the end of the string.
	 *    <p>Examples:</p>
	 *    <ul>
	 *    <li> EEEE, MMM. d, yyyy 'at' h 'o''clock' a= Tuesday, Sept. 8, 2005 at 
	 *    1 o'clock PM</li>
	 *    <li> yyyy年M月d日 =  2005年9月8日</li><li> mm''ss'' =  43'01'</li>
	 *    </ul>
	 *  </td>
	 *  </tr>
	 *  </tbody>
	 *  </table>
	 *
	 *  <p>When this method is called and it completes successfully, the 
	 *  <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one 
	 *  of the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @param pattern 
	 *
	 *  @throws TypeError if the pattern parameter is null.
	 *
	 *  @see DateTimeFormatter
	 *  @see #setDateTimeStyles()
	 *  @see #setDateTimePattern()
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
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
 	 	
	/**
	 *  Sets the date and time styles for this instance of the DateTimeFormatter. 
	 *  Date and time styles are used to set date and time formatting patterns to 
	 *  predefined, locale-dependent patterns from the operating system.  This 
	 *  method replaces the styles that were set using the 
	 *  <code>DateTimeFormatter()</code> constructor or using the 
	 *  <code>setDateTimePattern()</code> method. The date and time pattern is also
	 *  updated based on the styles that are set.
	 *
	 *  <p>When this method is called and it completes successfully, the 
	 *  <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one 
	 *  of the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @param dateStyle Specifies the style to use when formatting dates.  The 
	 *          value corresponds to one of the values enumerated by the 
	 *          DateTimeStyle class:
	 *          <ul>
	 *            <li><code>DateTimeStyle.LONG</code> </li>
	 *            <li><code>DateTimeStyle.MEDIUM</code></li>
	 *            <li><code>DateTimeStyle.SHORT</code> </li>
	 *            <li><code>DateTimeStyle.NONE</code> </li>
	 *          </ul> 
	 *  @param timeStyle Specifies the style to use when formatting times.  The 
	 *          value corresponds to one of the values enumerated by the 
	 *          DateTimeStyle class:
	 *          <ul>
	 *            <li><code>DateTimeStyle.LONG</code> </li>
	 *            <li><code>DateTimeStyle.MEDIUM</code></li>
	 *            <li><code>DateTimeStyle.SHORT</code> </li>
	 *            <li><code>DateTimeStyle.NONE</code> </li>
	 *          </ul> 
	 *
	 *  @throws ArgumentError if the <code>dateStyle</code> or 
	 *          <code>timeStyle</code> parameter is not a valid DateTimeStyle 
	 *          constant.		  
	 *  @throws TypeError if the <code>dateStyle</code> or <code>timeStyle</code>
	 *          parameter is null.
	 *
	 *  @see #DateTimeFormatter()
	 *  @see #setDateTimeStyles()
	 *  @see #setDateTimePattern()
	 *  @see #lastOperationStatus
	 *  @see DateTimeStyle
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
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
