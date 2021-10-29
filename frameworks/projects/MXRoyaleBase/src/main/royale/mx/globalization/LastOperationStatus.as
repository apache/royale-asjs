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

import mx.core.mx_internal;
use namespace mx_internal;


/**
 *  The LastOperationStatus class enumerates constant values that represent the
 *  status of the most recent globalization service operation.
 *
 *  These values can be retrieved through the read-only property 
 *  <code>lastOperationStatus</code> available in most globalization classes.
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.1
 *  @playerversion AIR 2.0
 *  @productversion Royale 0.9.8
 */
public final class LastOperationStatus
{
    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------

    /**
     *  Indicates that the last operation succeeded without any errors.
     *
     *  This status can be returned by all constructors, non-static methods,
     *  static methods and read/write properties.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.0
     *  @productversion Royale 0.9.8
     */
    public static const NO_ERROR:String
                            = "noError";

    /**
     *  Indicates that a fallback value was set during the most recent
     *  operation.
     *
     *  This status can be returned by constructors and methods such as
     *  <code>DateTimeFormatter.setDateTimeStyles()</code>, and when retrieving
     *  properties such as <code>CurrencyFormatter.groupingPattern</code>.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.0
     *  @productversion Royale 0.9.8
     */
    public static const USING_FALLBACK_WARNING:String
            = "usingFallbackWarning";

    /**
     *  Indicates that an operating system default value was used during the
     *  most recent operation.
     *
     *  Class constructors can return this status.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.0
     *  @productversion Royale 0.9.8
     */
    public static const USING_DEFAULT_WARNING:String
                = "usingDefaultWarning";

    /**
     *  Indicates that the parsing of a number failed.
     *
     *  This status can be returned by parsing methods of the formatter classes,
     *  such as <code>CurrencyFormatter.parse()</code> and
     *  <code>NumberFormatter.parseNumber()</code>.
     *  For example, if the value "12abc34" is passed as the parameter to the
     *  <code>CurrencyFormatter.parse()</code> method, the method returns "NaN"
     *  and sets the <code>lastOperationStatus</code> value to
     *  <code>LastOperationStatus.PARSE_ERROR</code>.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.0
     *  @productversion Royale 0.9.8
     */
    public static const PARSE_ERROR:String
                        = "parseError";

    /**
     *  Indicates that the requested operation or option is not supported.
     *
     *  This status can be returned by methods such as
     *  <code>DateTimeFormatter.setDateTimePattern()</code> and when retrieving
     *  properties suce as <code>Collator.ignoreCase</code>.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.0
     *  @productversion Royale 0.9.8
     */
    public static const UNSUPPORTED_ERROR:String
                    = "unsupportedError";

    /**
     *  Indicates that the return error code is not known.
     *
     *  Any non-static method or read/write properties can return this error
     *  when the operation is not successful and the return error code is not
     *  known.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.0
     *  @productversion Royale 0.9.8
     */

    public static const ERROR_CODE_UNKNOWN:String
                = "errorCodeUnknown";

    /**
     *  Indicates that the pattern for formatting a number, date, or time is
     *  invalid.
     *
     *  This status is set when the user's operating system does not support the
     *  given pattern.
     *
     *  <p>For example, the following code shows the value of the
     *  <code>lastOperationStatus</code> property after an invalid "xx" pattern
     *  is used for date formatting:</p>
     *
     *  <listing version="3.0">
     *  var df:DateTimeFormatter = new DateTimeFormatter();
     *  df.setStyle("locale","en_US");
     *  df.setDateTimePattern("xx");
     *  trace(df.lastOperationStatus); // "patternSyntaxError"
     *  </listing>
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.0
     *  @productversion Royale 0.9.8
     */
    public static const PATTERN_SYNTAX_ERROR:String
                = "patternSyntaxError";

    /**
     *  Indicates that memory allocation has failed.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.0
     *  @productversion Royale 0.9.8
     */
    public static const MEMORY_ALLOCATION_ERROR:String
            = "memoryAllocationError";

    /**
     *  Indicates that an argument passed to a method was illegal.
     *
     *  <p>For example, the following code shows that an invalid argument error
     *  status is set when <code>CurrencyFormatter.grouping</code> property is
     *  set to the invalid value "3;".</p>
     *
     *  <listing version="3.0">
     *  var cf:CurrencyFormatter = new CurrencyFormatter();
     *  cf.setStyle("locale","en_US");
     *  cf.groupingPattern = "3;";
     *  trace(cf.lastOperationStatus); // "illegalArgumentError"
     *  </listing>
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.0
     *  @productversion Royale 0.9.8
     */
    public static const ILLEGAL_ARGUMENT_ERROR:String
            = "illegalArgumentError";

    /**
     *  Indicates that given buffer is not enough to hold the result.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.0
     *  @productversion Royale 0.9.8
     */

    public static const BUFFER_OVERFLOW_ERROR:String
                = "bufferOverflowError";

    /**
     *  Indicates that a given attribute value is out of the expected range.
     *
     *  <p>The following example shows that setting the
     *  <code>NumberFormatter.negativeNumberFormat</code> property to an
     *  out-of-range value results in an invalid attribute value status.</p>
     *
     *  <listing version="3.0">
     *  var nf:NumberFormatter = new NumberFormatter();
     *  nf.setStyle("locale","en_US");
     *  nf.negativeNumberFormat = 9;
     *  nf.lastOperationStatus; // "invalidAttrValue"
     *  </listing>
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.0
     *  @productversion Royale 0.9.8
     */
    public static const INVALID_ATTR_VALUE:String
                = "invalidAttrValue";

    /**
     *  Indicates that an operation resulted a value that exceeds a specified
     *  numeric type.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.0
     *  @productversion Royale 0.9.8
     */
    public static const NUMBER_OVERFLOW_ERROR:String
                = "numberOverflowError";

    /**
     *  Indicates that invalid Unicode value was found.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.0
     *  @productversion Royale 0.9.8
     */
    public static const INVALID_CHAR_FOUND:String
                = "invalidCharFound";

    /**
     *  Indicates that a truncated Unicode character value was found.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.0
     *  @productversion Royale 0.9.8
     */
    public static const TRUNCATED_CHAR_FOUND:String
                = "truncatedCharFound";

    /**
     *  Indicates that an iterator went out of range or an invalid parameter was
     *  specified for month, day, or time.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.0
     *  @productversion Royale 0.9.8
     */
    public static const INDEX_OUT_OF_BOUNDS_ERROR:String
            = "indexOutOfBoundsError";

    /**
     *  Indicates that an underlying platform API failed for an operation.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.0
     *  @productversion Royale 0.9.8
     */
    public static const PLATFORM_API_FAILED:String
                = "platformAPIFailed";

    /**
     *  Indicates that an unexpected token was detected in a Locale ID string.
     *
     *  <p>For example, the following code shows the value of the
     *  <code>lastOperationStatus</code> property after an incomplete string is
     *  used when requesting a locale ID.
     *  As a result the <code>lastOperationStatus</code> property is set to the
     *  value <code>UNEXPECTED_TOKEN</code> after a call to the
     *  <code>LocaleID.getKeysAndValues()</code> method.</p>
     *
     *  <listing version="3.0">
     *  var locale:flash.globalization.LocaleID = new flash.globalization.LocaleID("en-US&#64;Collation");
     *  var kav:Object = locale.getKeysAndValues();
     *  trace(locale.lastOperationStatus); // "unexpectedToken"
     *  </listing>
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.0
     *  @productversion Royale 0.9.8
     */
    public static const UNEXPECTED_TOKEN:String
                    = "unexpectedToken";
    //--------------------------------------------------------------------------
    //  Additional constants besides constants from
    //  flash.globalization.LastOperationError
    //--------------------------------------------------------------------------

    /**
     *  Indicates that <code>Locale</code> is not defined.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.0
     *  @productversion Royale 0.9.8
     */
    public static const LOCALE_UNDEFINED_ERROR:String = "localeUndefinedError";

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Check if given <code>lastOperationStatus</code> is a error (not a warning).
     *
     *  A fatal error means errors other than no-error and warnings.
     */
    mx_internal static function isError(lastOperationStatus:String):Boolean
    {
        switch (lastOperationStatus)
        {
            case NO_ERROR:
            case USING_FALLBACK_WARNING:
            case USING_DEFAULT_WARNING:
                return false;
        }
        return true;
    }
}
}
