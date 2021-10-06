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
 *  Enumerates constants that determine a locale-specific date and time 
 *  formatting pattern. These constants are used when constructing a 
 *  DateTimeFormatter object or when calling the 
 *  <code>DateTimeFormatter.setDateTimeStyles()</code> method.
 *
 *  <p>The <code>CUSTOM</code> constant cannot be used in the 
 *  DateTimeFormatter constructor or the 
 *  <code>DateFormatter.setDateTimeStyles()</code> method.  This constant is 
 *  instead set as the <code>timeStyle</code> and <code>dateStyle</code> 
 *  property as a side effect of calling the 
 *  <code>DateTimeFormatter.setDateTimePattern()</code> method.</p>
 *
 *  @see DateTimeFormatter
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.1
 *  @playerversion AIR 2.0
 *  @productversion Royale 0.9.8
 */
public class DateTimeStyle
{
	/**
	 *  Specifies that a custom pattern string is used to specify the date or time
	 *  style.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public static const CUSTOM:String = "custom";

	/**
	 *  Specifies the long style of a date or time.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public static const LONG:String = "long";

	/**
	 *  Specifies the medium style of a date or time.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public static const MEDIUM:String = "medium";

	/**
	 *  Specifies that the date or time should not be included in the formatted 
	 *  string.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public static const NONE:String = "none";

	/**
	 *  Specifies the short style of a date or time.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public static const SHORT:String = "short";
}

}
