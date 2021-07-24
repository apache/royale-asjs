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


/**
 *  The NumberFormatter class provides locale-sensitive formatting and parsing 
 *  of numeric values. It can format <code>int</code>, <code>uint</code>, and 
 *  <code>Number</code> objects.
 *
 *  <p>The NumberFormatter class uses the data and functionality provided by 
 *  the operating system and is designed to format numbers according to the 
 *  conventions of a specific locale, based on the user's preferences and 
 *  features supported by the user's operating system.  The position of the 
 *  negative symbol, the decimal separator, the grouping separator, the 
 *  grouping pattern, and other elements within the number format can vary 
 *  depending on the locale.</p>
 *
 *  <p>If the operating system supports the requested locale, the number 
 *  formatting properties are set according to the conventions and defaults of
 *  the requested locale.  If the requested locale is not available, then the 
 *  properties are set according to a fallback or default system locale, which 
 *  can be retrieved using the <code>actualLocaleIDName</code> property.</p>
 *
 *  <p>Due to the use of the user's settings, the use of formatting patterns
 *  provided by the operating system, and the use of a fallback locale when a 
 *  requested locale is not supported, different users can see different 
 *  formatting results, even when using the same locale ID.</p>
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.1
 *  @playerversion AIR 2.0
 *  @productversion Royale 0.9.8
 */
public class NumberFormatter
{
	/**
	 *  The name of the actual locale ID used by this NumberFormatter object.
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
	 *  setting in the OS.  Passing an explicit value as the 
	 *  <code>requestedLocaleIDName</code> parameter does not necessarily give the 
	 *  same result as using the <code>LocaleID.DEFAULT</code> even if the two 
	 *  locale ID names are the same.  The user could have customized the locale 
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
	 *  @see #NumberFormatter()
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public var actualLocaleIDName:String;

	/**
	 *  The status of previous operation that this NumberFormatter object 
	 *  performed.  The <code>lastOperationStatus</code> property is set whenever 
	 *  the constructor or a method of this class is called, or another property is
	 *  set. For the possible values see the description for each method.
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
	 *  this NumberFormatter object.
	 *
	 *  <p>If the <code>LocaleID.DEFAULT</code> value was used then the name 
	 *  returned is "i-default".  The actual locale used can differ from the 
	 *  requested locale when a fallback locale is applied.  The name of the actual
	 *  locale can be retrieved using the <code>actualLocaleIDName</code> 
	 *  property.</p>
	 *
	 *  @see LocaleID
	 *  @see #actualLocaleIDName
	 *  @see #NumberFormatter()
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public var requestedLocaleIDName:String;

	/**
	 *  The decimal separator character used for formatting or parsing numbers that
	 *  have a decimal part.
	 *
	 *  <p>This property is initially set based on the locale that is selected when 
	 *  the formatter object is constructed.</p>
	 *
	 *  <p>When this property is assigned a value and there are no errors or 
	 *  warnings, the <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one of
	 *  the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @default dependent on the locale and operating system
	 *
	 *  @throws TypeError if this property is assigned a null value.
	 *
	 *  @see #formatInt()
	 *  @see #formatNumber()
	 *  @see #formatUInt()
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *	 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public var decimalSeparator:String;

	/**
	 *  Defines the set of digit characters to be used when formatting numbers. 
	 *
	 *  <p>Different languages and regions use different sets of characters to 
	 *  represent the digits 0 through 9.  This property defines the set of digits
	 *  to be used.</p>
	 *
	 *  <p>The value of this property represents the Unicode value for the zero 
	 *  digit of a decimal digit set.  The valid values for this property are 
	 *  defined in the NationalDigitsType class.</p>
	 *
	 *  <p>When this property is assigned a value and there are no errors or 
	 *  warnings, the <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one of
	 *  the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @default <code>dependent on the locale and operating system</code>
	 *
	 *  @throws TypeError if this property is assigned a null value.
	 *
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *  @see NationalDigitsType
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public var digitsType:uint;

	/**
	 *  The maximum number of digits that can appear after the decimal separator.
	 *
	 *  <p>Numbers are rounded to the number of digits specified by this property.
	 *  <b>The rounding scheme varies depending on the user's operating 
	 *  system.</b></p>
	 *
	 *  <p>When the <code>trailingZeros</code> property is set to 
	 *  <code>true</code>, the fractional portion of the number (after the 
	 *  decimal point) is padded with trailing zeros until its length matches the 
	 *  value of this <code>fractionalDigits</code> property.</p>
	 *
	 *  <p>When this property is assigned a value and there are no errors or 
	 *  warnings, the <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one of
	 *  the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @default <code>0</code>
	 *
	 *  @see #trailingZeros
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public var fractionalDigits:int;

	/**
	 *  Describes the placement of grouping separators within the formatted number
	 *  string.
	 *
	 *  <p>When the <code>useGrouping</code> property is set to true, the 
	 *  <code>groupingPattern</code> property is used to define the placement and 
	 *  pattern used for the grouping separator.</p>
	 *
	 *  <p>The grouping pattern is defined as a string containing numbers 
	 *  separated by semicolons and optionally may end with an asterisk. For 
	 *  example: <code>"3;2;&#42;"</code>. Each number in the string represents the 
	 *  number of digits in a group. The grouping separator is placed before each 
	 *  group of digits. An asterisk at the end of the string indicates that groups
	 *  with that number of digits should be repeated for the rest of the formatted
	 *  string.  If there is no asterisk then there are no additional groups or 
	 *  separators for the rest of the formatted string. </p>
	 *
	 *  <p>The first number in the string corresponds to the first group of digits 
	 *  to the left of the decimal separator.  Subsequent numbers define the number
	 *  of digits in subsequent groups to the left. Thus the string "3;2;&#42;" 
	 *  indicates that a grouping separator is placed after the first group of 3 
	 *  digits, followed by groups of 2 digits.  For example: 
	 *  <code>98,76,54,321</code></p>
	 *
	 *  <p>The following table shows examples of formatting the number 
	 *  123456789.12 with various grouping patterns.  The grouping separator is a 
	 *  comma and the decimal separator is a period.</p>
	 *
	 *  <table class="innertable">
	 *  <tbody>
	 *  <tr>
	 *  <td>Grouping Pattern</td>
	 *  <td>Sample Format</td>
	 *  </tr>
	 *  <tr>
	 *  <td><code>3;&#42;</code></td>
	 *  <td>123,456,789.12</td>
	 *  </tr>
	 *  <tr>
	 *  <td><code>3;2;&#42;</code></td>
	 *  <td>12,34,56,789.12</td>
	 *  </tr>
	 *  <tr>
	 *  <td><code>3</code></td>
	 *  <td>123456,789.12</td>
	 *  </tr>
	 *  </tbody>
	 *  </table>
	 *
	 *  <p>Only a limited number of grouping sizes can be defined. On some 
	 *  operating systems, grouping patterns can only contain two numbers plus an 
	 *  asterisk. Other operating systems can support up to four numbers and an 
	 *  asterisk.  For patterns without an asterisk, some operating systems only 
	 *  support one number while others support up to three numbers.  If the 
	 *  maximum number of grouping pattern elements is exceeded, then additional 
	 *  elements are ignored and the <code>lastOperationStatus</code> property is 
	 *  set as described below.</p>
	 *
	 *  <p>When this property is assigned a value and there are no errors or 
	 *  warnings, the <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one of
	 *  the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @throws TypeError if this property is assigned a null value.
	 *
	 *  @see #groupingSeparator
	 *  @see #useGrouping
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public var groupingPattern:String;

	/**
	 *  The character or string used for the grouping separator.
	 *
	 *  <p>The value of this property is used as the grouping separator when 
	 *  formatting numbers with the <code>useGrouping</code> property set to 
	 *  <code>true</code>. This property is initially set based on the locale 
	 *  that is selected when the formatter object is constructed.</p>
	 *
	 *  <p>When this property is assigned a value and there are no errors or 
	 *  warnings, the <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one of
	 *  the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @default <code>dependent on the locale and operating system</code>
	 *
	 *  @throws TypeError if this property is assigned a null value.
	 *
	 *  @see #formatInt()
	 *  @see #formatNumber()
	 *  @see #formatUInt()
	 *  @see #useGrouping
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public var groupingSeparator:String;

	/**
	 *  Specifies whether a leading zero is included in a formatted number when 
	 *  there are no integer digits to the left of the decimal separator.
	 *
	 *  <p>When this property is set to <code>true</code> a leading zero is 
	 *  included to the left of the decimal separator when formatting numeric 
	 *  values between -1.0 and 1.0.  When this property is set to 
	 *  <code>false</code> a leading zero is not included.</p>
	 *
	 *  <p>For example if the number is 0.321 and this property is set 
	 *  <code>true</code>, then the leading zero is included in the formatted 
	 *  string. If the property is set to <code>false</code>, the leading zero 
	 *  is not included. In that case the string would just include the decimal 
	 *  separator followed by the decimal digits, like <code>.321</code>. </p>
	 *
	 *  <p>The following table shows examples of how numbers are formatted based on
	 *  the values of this property and the related <code>fractionalDigits</code> 
	 *  and <code>trailingZeros</code> properties.</p>
	 *
	 *  <table class="innertable">
	 *  <tbody>
	 *  <tr>
	 *  <td>trailingZeros</td>
	 *  <td><b>leadingZero</b></td>
	 *  <td>fractionalDigits</td>
	 *  <td>0.12</td>
	 *  <td>0</td>
	 *  </tr>
	 *  <tr>
	 *  <td>true</td>
	 *  <td>true</td>
	 *  <td>3</td>
	 *  <td>0.120</td>
	 *  <td>0.000</td>
	 *  </tr>
	 *  <tr>
	 *  <td>false</td>
	 *  <td>true</td>
	 *  <td>3</td>
	 *  <td>0.12</td>
	 *  <td>0</td>
	 *  </tr>
	 *  <tr>
	 *  <td>true</td>
	 *  <td>false</td>
	 *  <td>3</td>
	 *  <td>.120</td>
	 *  <td>.000</td>
	 *  </tr>
	 *  <tr>
	 *  <td>false</td>
	 *  <td>false</td>
	 *  <td>3</td>
	 *  <td>.12</td>
	 *  <td>0</td>
	 *  </tr>
	 *  </tbody>
	 *  </table>
	 *
	 *  <p>When this property is assigned a value and there are no errors or 
	 *  warnings, the <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one of
	 *  the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @default <code>dependent on the locale and operating system</code>
	 *
	 *  @throws TypeError if this property is assigned a null value.
	 *
	 *  @see #formatInt()
	 *  @see #formatNumber()
	 *  @see #formatUInt()
	 *  @see #trailingZeros
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public var leadingZero:Boolean;

	/**
	 *  A numeric value that indicates a formatting pattern for negative numbers.
	 *  This pattern defines the location of the negative symbol or parentheses 
	 *  in relation to the numeric portion of the formatted number.
	 *
	 *  <p> The following table summarizes the possible formats for negative 
	 *  numbers. When a negative number is formatted, the minus sign in the format
	 *  is replaced with the value of the <code>negativeSymbol</code> property and
	 *  the 'n' character is replaced with the formatted numeric value.</p>
	 *
	 *  <table class="innertable">
	 *  <tbody>
	 *  <tr>
	 *  <td>Negative number format type</td>
	 *  <td>Format</td>
	 *  </tr>
	 *  <tr>
	 *  <td>0</td>
	 *  <td>(n)</td>
	 *  </tr>
	 *  <tr>
	 *  <td>1</td>
	 *  <td>-n</td>
	 *  </tr>
	 *  <tr>
	 *  <td>2</td>
	 *  <td>- n</td>
	 *  </tr>
	 *  <tr>
	 *  <td>3</td>
	 *  <td>n-</td>
	 *  </tr>
	 *  <tr>
	 *  <td>4</td>
	 *  <td>n -</td>
	 *  </tr>
	 *  </tbody>
	 *  </table>
	 *
	 *  <p>When this property is assigned a value and there are no errors or 
	 *  warnings, the <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one of
	 *  the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @default <code>dependent on the locale and operating system</code>
	 *
	 *  @throws ArgumentError if the assigned value is not a number between 0 and 4.
	 *
	 *  @see #negativeSymbol
	 *  @see #formatInt()
	 *  @see #formatNumber()
	 *  @see #formatUInt()
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public var negativeNumberFormat:uint;

	/**
	 *  The negative symbol to be used when formatting negative values.
	 *
	 *  <p>This symbol is used with the negative number format when formatting a 
	 *  number that is less than zero. It is not used in negative number formats 
	 *  that do not include a negative sign (e.g. when negative numbers are 
	 *  enclosed in parentheses). </p>
	 *
	 *  <p> This property is set to a default value for the actual locale selected
	 *  when this formatter is constructed. It can be set with a value to override
	 *  the default setting.</p>
	 *
	 *  <p>When this property is assigned a value and there are no errors or 
	 *  warnings, the <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one of
	 *  the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @throws MemoryError if the system cannot allocate enough internal memory.
	 *
	 *  @see #negativeNumberFormat
	 *  @see #formatInt()
	 *  @see #formatNumber()
	 *  @see #formatUInt()
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public var negativeSymbol:String;

	/**
	 *  Specifies whether trailing zeros are included in a formatted number. 
	 *
	 *  <p>When this property is set to <code>true</code>, trailing zeros are 
	 *  included in the fractional part of the formatted number up to the limit 
	 *  specified by the <code>fractionalDigits</code> property.  When this 
	 *  property is set to <code>false</code> then no trailing zeros are shown.</p>
	 *
	 *  <p>For example if the numeric value is 123.4, and this property is set 
	 *  true, and the <code>fractionalDigits</code> property is set to 3, the 
	 *  formatted string would show trailing zeros, like <code>123.400</code> .  
	 *  If this property is <code>false</code>, trailing zeros are not included, 
	 *  and the string shows just the decimal separator followed by the non-zero 
	 *  decimal digits, like <code>123.4</code> .</p>
	 *
	 *  <p>The following table shows examples of how numeric values are formatted 
	 *  based on the values of this property and the related 
	 *  <code>fractionalDigits</code> and <code>leadingZero</code> properties.</p>
	 *
	 *  <table class="innertable">
	 *  <tbody>
	 *  <tr>
	 *  <td><b>trailingZeros</b></td>
	 *  <td>leadingZero</td>
	 *  <td>fractionalDigits</td>
	 *  <td>0.12</td>
	 *  <td>0</td>
	 *  </tr>
	 *  <tr>
	 *  <td>true</td>
	 *  <td>true</td>
	 *  <td>3</td>
	 *  <td>0.120</td>
	 *  <td>0.000</td>
	 *  </tr>
	 *  <tr>
	 *  <td>false</td>
	 *  <td>true</td>
	 *  <td>3</td>
	 *  <td>0.12</td>
	 *  <td>0</td>
	 *  </tr>
	 *  <tr>
	 *  <td>true</td>
	 *  <td>false</td>
	 *  <td>3</td>
	 *  <td>.120</td>
	 *  <td>.000</td>
	 *  </tr>
	 *  <tr>
	 *  <td>false</td>
	 *  <td>false</td>
	 *  <td>3</td>
	 *  <td>.12</td>
	 *  <td>0</td>
	 *  </tr>
	 *  </tbody>
	 *  </table>
	 *
	 *  <p>When this property is assigned a value and there are no errors or 
	 *  warnings, the <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one of
	 *  the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @default <code>dependent on the locale and operating system</code>
	 *
	 *  @throws TypeError if this property is assigned a null value.
	 *
	 *  @see #leadingZero
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public var trailingZeros:Boolean;

	/**
	 *  Enables the use of the grouping separator when formatting numbers.
	 *
	 *  <p>When the <code>useGrouping</code> property is set to <code>true</code>, 
	 *  digits are grouped and delimited by the grouping separator character.  For 
	 *  example: <code>123,456,789.22</code></p>
	 *
	 *  <p>When the <code>useGrouping</code> property is set to <code>false</code>,
	 *  digits are not grouped or separated.  For example: 
	 *  <code>123456789.22</code></p>
	 *
	 *  <p>The symbol to be used as a grouping separator is defined by the 
	 *  <code>groupingSeparator</code> property. The number of digits between 
	 *  grouping separators is defined by the <code>groupingPattern</code> 
	 *  property.</p>
	 *
	 *  <p>When this property is assigned a value and there are no errors or 
	 *  warnings, the <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one of
	 *  the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @see #groupingPattern
	 *  @see #groupingSeparator
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public var useGrouping:Boolean;


	/**
	 *  Constructs a new NumberFormatter object to format numbers according to the
	 *  conventions of a given locale.
	 *
	 *  <p>This constructor determines if the current operating system supports the
	 *  requested locale ID name.  If it is not supported then a fallback locale is
	 *  used instead.  If a fallback locale is used then the the 
	 *  <code>lastOperationStatus</code> property indicates the type of fallback, 
	 *  and the <code>actualLocaleIDName</code> property contains the name of the 
	 *  fallback locale ID. </p>
	 *
	 *  <p>To format based on the user's current operating system preferences, pass
	 *  the value <code>LocaleID.DEFAULT</code> in the 
	 *  <code>requestedLocaleIDName</code> parameter to the constructor.</p>
	 *
	 *  <p>When the constructor completes successfully, the 
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
	 *  <p>If this class is not supported on the current operating system, then 
	 *  the <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.UNSUPPORTED_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one of
	 *  the constants defined in the LastOperationStatus class.</p>
	 *
	 *  <p><b>For details on the warnings listed above and other possible values of
	 *  the <code>lastOperationStatus</code> property see the descriptions in the 
	 *  <code>LastOperationStatus</code> class.</b></p>
	 *
	 *  @param requestedLocaleIDName The preferred locale ID name to use when 
	 *          determining number formats.
	 *
	 *  @throws TypeError if the <code>requestedLocaleIDName</code> is 
	 *          <code>null</code>
	 *
	 *  @see LocaleID
	 *  @see #requestedLocaleIDName
	 *  @see #actualLocaleIDName
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
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
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one of
	 *  the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @return A vector of strings containing all of the locale ID names supported
	 *          by this class.
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
	 *  Formats an int value.
	 *
	 *  This function is equivalent to the <code>formatNumber()</code> method 
	 *  except that it takes an <code>int</code> value.  If the value passed in is
	 *  too large or small, such as a value greater than 1.72e308 or less than 
	 *  1.72e-308, then this function returns 0.
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
	 *  @param value An int value to format.
	 *
	 *  @return A formatted number string.
	 *
	 *  @throws MemoryError for any internal memory allocation problems.
	 *
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public function formatInt(value:int):String
	{
		var s:String;

		// TODO
		s = fmt.format(value);

		lastOperationStatus = LastOperationStatus.NO_ERROR;
		return s;
	}

	/**
	 *  Formats a Number value.
	 *
	 *  <p>This function formats the number based on the property values of the 
	 *  formatter. If the properties are not modified after the the numberFormatter
	 *  object is created, the numbers are formatted according to the locale 
	 *  specific conventions provided by the operating system for the locale 
	 *  identified by actualLocaleIDName.  To customize the format, the properties 
	 *  can be altered to control specific aspects of formatting a number.</p>
	 *
	 *  <p> Very large numbers and very small magnitude numbers can be formatted 
	 *  with this function. However, the number of significant digits is limited to
	 *  the precision provided by the Number object. Scientific notation is not 
	 *  supported.</p>
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
	 *  @param value A Number value to format.
	 *
	 *  @return A formatted number string.
	 *
	 *  @throws MemoryError if there are any internal memory allocation problems.
	 *
	 *  @see lastOperationStatus
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public function formatNumber(value:Number):String
	{
		var s:String;

		// TODO
		s = fmt.format(value);

		lastOperationStatus = LastOperationStatus.NO_ERROR;
		return s;
	}

	/**
	 *  Formats a uint value.
	 *
	 *  This function is equivalent to the <code>formatNumber()</code> method 
	 *  except that it takes a <code>uint</code>.  If the value passed in is too 
	 *  large, such as a value greater than 1.72e308, then this function returns 0.
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
	 *  @param value A uint value.
	 *
	 *  @return A formatted number string.
	 *
	 *  @throws MemoryError if there are any internal memory allocation problems.
	 *
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public function formatUint(value:uint):String
	{
		var s:String;

		// TODO
		s = fmt.format(value);

		lastOperationStatus = LastOperationStatus.NO_ERROR;
		return s;
	}

	/**
	 *  Parses a string and returns a NumberParseResult object containing the 
	 *  parsed elements. 
	 *
	 *  <p>The NumberParseResult object contains the value of the first number 
	 *  found in the input string, the starting index for the number within the 
	 *  string, and the index of the first character after the number in the 
	 *  string.</p>
	 *
	 *  <p> If the string does not contain a number, the value property of the 
	 *  NumberParseResult is set to <code>NaN</code> and the 
	 *  <code>startIndex</code> and <code>endIndex</code> properties are set to the
	 *  hexadecimal value <code>0x7fffffff</code>.</p>
	 *
	 *  <p>This function uses the value of the <code>decimalSeparator</code> 
	 *  property to determine the portion of the number that contains fractional
	 *  digits, and the <code>groupingSeparator</code> property to determine which 
	 *  characters are allowed within the digits of a number, and the 
	 *  <code>negativeNumberFormat</code> property to control how negative values 
	 *  are represented. </p>
	 *
	 *  <p>The following table identifies the result of strings parsed for the 
	 *  various NegativeNumberFormat values:</p>
	 *
	 *  <table class="innertable">
	 *  <tbody>
	 *  <tr>
	 *  <td>NegativeNumberFormat</td>
	 *  <td>Input String</td>
	 *  <td>Result</td>
	 *  </tr>
	 *  <tr>
	 *  <td>(n)</td>
	 *  <td>"(123)" or "( 123 )"</td>
	 *  <td>"-123"</td>
	 *  </tr>
	 *  <tr>
	 *  <td>-n</td>
	 *  <td>"-123" or "- 123"</td>
	 *  <td>"-123"</td>
	 *  </tr>
	 *  <tr>
	 *  <td>- n</td>
	 *  <td>"-123" or "- 123"</td>
	 *  <td>"-123"</td>
	 *  </tr>
	 *  <tr>
	 *  <td>n-</td>
	 *  <td>"123-" or "123 -"</td>
	 *  <td>"-123"</td>
	 *  </tr>
	 *  <tr>
	 *  <td>n -</td>
	 *  <td>"123-" or "123 -"</td>
	 *  <td>"-123"</td>
	 *  </tr>
	 *  </tbody>
	 *  </table>
	 *
	 *  <p>A single white space is allowed between the number and the minus sign or
	 *  parenthesis.</p>
	 *
	 *  <p>Other properties are ignored when determining a valid number. 
	 *  Specifically the value of the <code>digitsType</code> property is ignored 
	 *  and the digits can be from any of the digit sets that are enumerated in 
	 *  the NationalDigitsType class. The values of the 
	 *  <code>groupingPattern</code> and <code>useGrouping</code> properties do 
	 *  not influence the parsing of the number.</p>
	 *
	 *  <p> If numbers are preceded or followed in the string by a plus sign '+', 
	 *  the plus sign is treated as a character that is not part of the number.</p>
	 *
	 *  <p> This function does not parse strings containing numbers in scientific 
	 *  notation (e.g. 1.23e40).</p>
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
	 *  @param parseString
	 *
	 *  @return 
	 *
	 *  @throws TypeError if the parseString is <code>null</code>
	 *
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *  @see NumberParseResult
	 *  @see #parseNumber()
	 *  @see #parseFloat()
	 *  @see NationalDigitsType
	 *
	 *  @example The following code parses a number from a string and retrieves the
	 *          prefix and suffix: 
	 *          <listing version="3.0">
	 *
	 *          var nf:NumberFormatter = new NumberFormatter("fr-FR"); 
	 *          var str:String = "1,56 mètre"
	 *          var result:NumberParseResult = nf.parse(str);
	 *          trace(result.value) // 1.56
	 *          trace(str.substr(0,result.startIndex));                // ""
	 *          trace(str.substr(result.startIndex, result.endIndex)); // "1,56"
	 *          trace(str.substr(result.endIndex));                    // " mètre"
	 *          </listing>
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public function parse(parseString:String):NumberParseResult
	{
		// TODO
		return new NumberParseResult(parseNumber(parseString));
	}

	/**
	 *  Parses a string that contains only digits and optional whitespace 
	 *  characters and returns a Number. 
	 *
	 *  If the string does not begin with a number or contains characters other 
	 *  than whitespace that are not part of the number, then this method returns 
	 *  <code>NaN</code>. White space before or after the numeric digits is 
	 *  ignored. A white space character is a character that has a Space Separator 
	 *  (Zs) property in the Unicode Character Database 
	 *  (see http://www.unicode.org/ucd/). 
	 *
	 *  <p> If the numeric digit is preceded or followed by a plus sign '+' it is 
	 *  treated as a non-whitespace character.  The return value is 
	 *  <code>NaN</code>.</p>
	 *
	 *  <p> See the description of the parse function for more information about 
	 *  number parsing and what constitutes a valid number.</p>
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
	 *  @param parseString
	 *
	 *  @return
	 *
	 *  @throws TypeError if the parseString is <code>null</code>
	 *
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *  @see #parse()
	 *  @see #parseFloat()
	 *  @see NationalDigitsType
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
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
