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
 *  The DateTimeNameStyle class enumerates constants that control the length of
 *  the month names and weekday names that are used when formatting dates. Use 
 *  these constants for the <code>nameStyle</code> parameter of the 
 *  DateTimeFormatter <code>getMonthNames()</code> and 
 *  <code>getWeekDayNames()</code> methods. 
 *
 *  <p>The <code>LONG_ABBREVIATION</code> and <code>SHORT_ABBREVIATION</code> 
 *  may be the same or different depending on the operating system settings.</p>
 *
 *  @see DateTimeFormatter
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.1
 *  @playerversion AIR 2.0
 *  @productversion Royale 0.9.8
 */
public class DateTimeNameStyle
{
	/**
	 *  Specifies the full form or full name style for month names and weekday 
	 *  names.  Examples: Tuesday, November.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public static const FULL:String = "full";

	/**
	 *  Specifies the long abbreviation style for month names and weekday names.
	 *  Examples: Tues for Tuesday, Nov for November.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public static const LONG_ABBREVIATION:String = "longAbbreviation";

	/**
	 *  Specifies the short abbreviation style for month names and weekday names.
	 *  Examples: T for Tuesday, N for November.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public static const SHORT_ABBREVIATION:String = "shortAbbreviation";
}

}
