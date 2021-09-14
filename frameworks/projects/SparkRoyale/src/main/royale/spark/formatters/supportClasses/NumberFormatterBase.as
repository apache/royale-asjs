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

package spark.formatters.supportClasses
{

// was flash.globalization
import mx.globalization.NumberFormatter;
import mx.globalization.CurrencyParseResult;
import mx.globalization.NumberParseResult;

import mx.utils.StringUtil;
import mx.core.mx_internal;

import mx.globalization.LastOperationStatus;
import mx.globalization.supportClasses.GlobalizationBase;

use namespace mx_internal;

/**
 *  The NumberFormatterBase class is a base class for the
 *  NumberFormatter and CurrencyFormatter classes.
 *
 *  @mxml <p>The <code>&lt;s:NumberFormatterBase&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:NumberFormatterBase 
 *    <strong>Properties</strong>
 *    decimalSeparator="<i>locale and OS dependent</i>"
 *    digitsType="<i>locale and OS dependent</i>"
 *    errorText="null"
 *    fractionalDigits="<i>locale and OS dependent</i>"
 *    groupingPattern="<i>locale and OS dependent</i>"
 *    groupingSeparator="<i>locale and OS dependent</i>"
 *    leadingZero="<i>locale and OS dependent</i>"
 *    negativeSymbol="<i>locale and OS dependent</i>"
 *    trailingZeros="<i>locale and OS dependent</i>"
 *    useGrouping="<i>locale and OS dependent</i>"
 *  /&gt;
 *  </pre>
 * 
 *  @see spark.formatters.CurrencyFormatter
 *  @see spark.formatters.NumberFormatter
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Royale 0.9.8
 */

public class NumberFormatterBase extends GlobalizationBase
{
//    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------

    private static const DECIMAL_SEPARATOR:String = "decimalSeparator";
    private static const DIGITS_TYPE:String = "digitsType";
    private static const FRACTIONAL_DIGITS:String = "fractionalDigits";
    private static const GROUPING_PATTERN:String = "groupingPattern";
    private static const GROUPING_SEPARATOR:String = "groupingSeparator";
    private static const LEADING_ZERO:String = "leadingZero";
    private static const NEGATIVE_SYMBOL:String = "negativeSymbol";
    private static const TRAILING_ZEROS:String = "trailingZeros";
    private static const USE_GROUPING:String = "useGrouping";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
     *  Constructor.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function NumberFormatterBase()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Underlying working instance of flash.globalizaiton.NumberFormatter or
     *  CurrencyFormatter class.
     *
     *  Because it can be either type and they don't have common base except
     *  Object, it is defined as Object.
     */
    private var _g11nWorkingInstance:Object = null;

    /**
     *  @private
     *  If the g11nWorkingInstance has not been defined. Call
     *  ensureStyleSource to ensure that there is a styleParent. If there is
     *  not a style parent, then this instance will be added as a style client
     *  to the topLevelApplication. As a side effect of this, the styleChanged
     *  method will be called and if there is a locale style defined for the
     *  topLevelApplication, the createWorkingInstance method will be
     *  executed creating a g11nWorkingInstance.
     */
    mx_internal function get g11nWorkingInstance ():Object
    {
        if (!_g11nWorkingInstance)
            ensureStyleSource();
        
        return _g11nWorkingInstance;
    }
    
    mx_internal function set g11nWorkingInstance 
        (flashFormatter:Object): void 
    {
        _g11nWorkingInstance = flashFormatter;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  lastOperationStatus
    //----------------------------------

    [Bindable("change")]

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    override public function get lastOperationStatus():String
    {
        return g11nWorkingInstance ?
                    g11nWorkingInstance.lastOperationStatus :
                    fallbackLastOperationStatus;
    }

    //----------------------------------
    //  useFallback
    //----------------------------------

    [Bindable("change")]

    /**
     *  @private
     */
    override mx_internal function get useFallback():Boolean
    {
        return g11nWorkingInstance == null;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  decimalSeparator
    //----------------------------------

    [Bindable("change")]

    /**
     *  The decimal separator character used for formatting or parsing
     *  numbers that have a decimal part.
     *
     *  <p>The default value is dependent on the locale and operating system.</p>

     *  @throws TypeError if this property is assigned a null value.
     *
     *  @see spark.formatters.CurrencyFormatter#format()
     *  @see spark.formatters.NumberFormatter#format()
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function get decimalSeparator():String
    {
        return getBasicProperty(properties, DECIMAL_SEPARATOR);
    }

    public function set decimalSeparator(value:String):void
    {
        setBasicProperty(properties, DECIMAL_SEPARATOR, value);
    }

    //----------------------------------
    //  digitsType
    //----------------------------------

    [Bindable("change")]

    /**
     *  Defines the set of digit characters to be used when
     *  formatting numbers.
     *
     *  <p>Different languages and regions use different sets of
     *  characters to represent the
     *  digits 0 through 9.  
     *  This property defines the set of digits to be used.</p>
     *
     *  <p>The value of this property represents the Unicode value for
     *  the zero digit of a decimal digit set.
     *  The valid values for this property are defined in the
     *  <code>NationalDigitsType</code> class.</p>
     *
     *  <p>The default value is dependent on the locale and operating system.</p>
     *
     *  @see flash.globalization.NationalDigitsType
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function get digitsType():uint
    {
        return getBasicProperty(properties, DIGITS_TYPE);
    }

    public function set digitsType(value:uint):void
    {
        setBasicProperty(properties, DIGITS_TYPE, value);
    }

    //----------------------------------
    //  errorText
    //----------------------------------

    private var _errorText:String;

    [Bindable("change")]

    /**
     *  Replacement string returned by the <code>format()</code> method
     *  when an error occurs.
     *
     *  <p>If <code>errorText</code> is non-null and an error occurs
     *  while formatting a number or currency amount, the format method
     *  will return the string assigned to this property.</p>
     *
     *  For example:
     *  <listing version="3.0" >
     *  var nf:NumberFormatter = new NumberFormatter();
     *  nf.setStyle("locale", "en-US");
     *  nf.errorText = "###"
     *  trace(nf.format("abc"));  // ###
     *  </listing>
     *
     *  @default null
     *
     *  @see mx.globalization.LastOperationStatus
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function get errorText():String
    {
        return _errorText;
    }

    public function set errorText(value:String):void
    {
        if (_errorText == value)
            return;

        _errorText = value;

        update();
    }

    //----------------------------------
    //  fractionalDigits
    //----------------------------------

    [Bindable("change")]
    [Inspectable(category="General", minValue="0")]

    /**
     *  The maximum number of digits that can appear after the decimal
     *  separator.
     *
     *  <p>Numbers are rounded to the number of digits specified by this
     *  property. The rounding scheme
     *  varies depending on the application user's operating system.</p>
     *
     *  <p>When the <code>trailingZeros</code> property is set to
     *  <code>true</code>, the fractional portion of the
     *  number (after the decimal separator) is padded with trailing zeros
     *  until its length matches the value of this
     *  <code>fractionalDigits</code> property.</p>
     *
     *  <p>The default value is dependent on the locale and operating system.</p>
     *
     *  @see #trailingZeros
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function get fractionalDigits():int
    {
        return getBasicProperty(properties, FRACTIONAL_DIGITS);
    }

    public function set fractionalDigits(value:int):void
    {
        setBasicProperty(properties, FRACTIONAL_DIGITS, value);
    }

    //----------------------------------
    //  groupingPattern
    //----------------------------------

    [Bindable("change")]

    /**
     *  Describes the placement of grouping separators within the
     *  formatted number string.
     *
     *  <p>When the <code>useGrouping</code> property is set to true,
     *  the <code>groupingPattern</code> property is used
     *  to define the placement and pattern used for the grouping
     *  separator.</p>
     *
     *  <p>The grouping pattern is defined as a string containing
     *  numbers separated by semicolons and optionally may end
     *  with an asterisk. For example: <code>"3;2;&#42;"</code>.
     *  Each number in the string represents the number of digits
     *  in a group. The grouping separator is placed before each
     *  group of digits. An asterisk at the end of the string
     *  indicates that groups with that number of digits should be
     *  repeated for the rest of the formatted string.
     *  If there is no asterisk then there are no additional groups
     *  or separators for the rest of the formatted string. </p>
     *
     *  <p>The first number in the string corresponds to the first
     *  group of digits to the left of the decimal separator.
     *  Subsequent numbers define the number of digits in subsequent
     *  groups to the left. Thus the string <code>"3;2;&#42;"</code>
     *  indicates that a grouping separator is placed after the first
     *  group of 3 digits, followed by groups of 2 digits.
     *  For example: <code>98,76,54,321</code></p>
     *
     *  <p>The following table shows examples of formatting the
     *  number 123456789.12 with various grouping patterns.
     *  The grouping separator is a comma and the decimal separator
     *  is a period.
     *  </p>
     *    <table class="innertable" border="0">
     *          <tr>
     *                <td>Grouping Pattern</td>
     *                <td>Sample Format</td>
     *          </tr>
     *          <tr>
     *                <td><code>3;&#42;</code></td>
     *                <td>123,456,789.12</td>
     *          </tr>
     *          <tr>
     *                <td><code>3;2;&#42;</code></td>
     *                <td>12,34,56,789.12</td>
     *          </tr>
     *          <tr>
     *                <td><code>3</code></td>
     *                <td>123456,789.12</td>
     *          </tr>
     *    </table>
     *
     *  <p>Only a limited number of grouping sizes can be defined.
     *  On some operating systems, grouping patterns can only contain
     *  two numbers plus an asterisk. Other operating systems can
     *  support up to four numbers and an asterisk.
     *  For patterns without an asterisk, some operating systems
     *  only support one number while others support up to three numbers.
     *  If the maximum number of grouping pattern elements is exceeded,
     *  then additional elements
     *  are ignored and the <code>lastOperationStatus</code> property
     *  is set to indicate that a fall back value is
     *  being used.
     *  </p>
     *
     *  <p>The default value is dependent on the locale and operating system.</p>
     *
     *  @throws TypeError if this property is assigned a null value.
     *
     *  @see #groupingSeparator
     *  @see #useGrouping
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function get groupingPattern():String
    {
        return getBasicProperty(properties, GROUPING_PATTERN);
    }

    public function set groupingPattern(value:String):void
    {
        setBasicProperty(properties, GROUPING_PATTERN, value);
    }

    //----------------------------------
    //  groupingSeparator
    //----------------------------------

    [Bindable("change")]

    /**
     *  The character or string used for the grouping separator.
     *
     *  <p>The value of this property is used as the grouping
     *  separator when formatting numbers with the
     *  <code>useGrouping</code> property set to <code>true</code>. This
     *  property is initially set based on the locale that is selected
     *  when the formatter object is constructed.</p>
     *
     *  <p>The default value is dependent on the locale and operating system.</p>
     *
     *  @throws TypeError if this property is assigned a null value.
     *
     *  @see spark.formatters.CurrencyFormatter#format()
     *  @see spark.formatters.NumberFormatter#format()
     *  @see #useGrouping
     *  @see #groupingPattern
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function get groupingSeparator():String
    {
        return getBasicProperty(properties, GROUPING_SEPARATOR);
    }

    public function set groupingSeparator(value:String):void
    {
        setBasicProperty(properties, GROUPING_SEPARATOR, value);
    }

    //----------------------------------
    //  leadingZero
    //----------------------------------

    [Bindable("change")]

    /**
     *  Specifies whether a leading zero is included in a formatted
     *  number when there are no integer digits to the left of the decimal
     *  separator.
     *
     *  <p>When this property is set to <code>true</code> a leading
     *  zero is included to the left of the decimal separator
     *  when formatting numeric values between -1.0 and 1.0.
     *  When this property is set to <code>false</code>, a leading zero
     *  is not included.</p>
     *
     *  <p>For example, if the number is 0.321 and this property is
     *  set <code>true</code>, then the leading
     *  zero is included in the formatted string. If the property is
     *  set to <code>false</code>, the leading zero
     *  is not included. In that case the string would just include the
     *  decimal separator followed by the decimal digits,
     *  such as <code>.321</code>.</p>
     *
     *  <p>The following table shows examples of how numbers are formatted
     *  based on the values of this property and
     *  the related <code>fractionalDigits</code> and
     *  <code>trailingZeros</code> properties.
     *  </p>
     *
     *     <table class="innertable" border="0">
     *         <tr>
     *             <td>trailingZeros</td>
     *             <td><strong>leadingZero</strong></td>
     *             <td>fractionalDigits</td>
     *             <td>0.12</td>
     *             <td>0</td>
     *          </tr>
     *         <tr>
     *             <td>true</td>
     *             <td>true</td>
     *             <td>3</td>
     *             <td>0.120</td>
     *             <td>0.000</td>
     *         </tr>
     *         <tr>
     *             <td>false</td>
     *             <td>true</td>
     *             <td>3</td>
     *             <td>0.12</td>
     *             <td>0</td>
     *         </tr>
     *         <tr>
     *             <td>true</td>
     *             <td>false</td>
     *             <td>3</td>
     *             <td>.120</td>
     *             <td>.000</td>
     *         </tr>
     *         <tr>
     *             <td>false</td>
     *             <td>false</td>
     *             <td>3</td>
     *             <td>.12</td>
     *             <td>0</td>
     *         </tr>
     *  </table>
     *
     *
     *  <p>The default value is dependent on the locale and operating system.</p>
     *
     *  @throws TypeError if this property is assigned a null value.
     *
     *  @see spark.formatters.CurrencyFormatter#format()
     *  @see spark.formatters.NumberFormatter#format()
     *
     *  @see #trailingZeros
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function get leadingZero():Boolean
    {
        return getBasicProperty(properties, LEADING_ZERO);
    }

    public function set leadingZero(value:Boolean):void
    {
        setBasicProperty(properties, LEADING_ZERO, value);
    }

    //----------------------------------
    //  negativeSymbol
    //----------------------------------

    [Bindable("change")]

    /**
     *  The negative symbol to be used when formatting negative values.
     *
     *  <p>This symbol is used with the negative number
     *  format when formatting a number that is less than zero.
     *  It is not used in negative number formats that do not include
     *  a negative sign (e.g. when negative numbers are enclosed in
     *  parentheses). </p>
     *
     *  <p>This property is set to a default value for the actual
     *  locale selected when this formatter is constructed.
     *  It can be set with a value to override the default setting.</p>
     *
     *  <p>The default value is dependent on the locale and operating system.</p>
     * 
     *  @see #negativeNumberFormat
     *  @see #format()
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function get negativeSymbol():String
    {
        return getBasicProperty(properties, NEGATIVE_SYMBOL);
    }

    public function set negativeSymbol(value:String):void
    {
        setBasicProperty(properties, NEGATIVE_SYMBOL, value);
    }

    //----------------------------------
    //  trailingZeros
    //----------------------------------

    [Bindable("change")]

    /**
     *  Specifies whether trailing zeros are included in a formatted number.
     *
     *  <p>When this property is set to <code>true</code>, trailing
     *  zeros are included in the fractional part
     *  of the formatted number up to the limit specified by the
     *  <code>fractionalDigits</code> property.
     *  When this property is set to <code>false</code> then no
     *  trailing zeros are shown.</p>
     *
     *  <p>For example, if the numeric value is 123.4, and this property
     *  is set true, and the <code>fractionalDigits</code> property
     *  is set to 3, the formatted string would show trailing zeros,
     *  such as <code>123.400</code> .
     *  If this property is <code>false</code>, trailing zeros are not
     *  included, and the string shows just the decimal
     *  separator followed by the non-zero decimal digits, such as
     *  <code>123.4</code>.</p>
     *
     *  <p>The following table shows examples of how numeric values are
     *  formatted based on the values of this property and
     *  the related <code>fractionalDigits</code> and
     *  <code>leadingZero</code> properties.
     *  </p>
     *
     *     <table class="innertable" border="0">
     *         <tr>
     *             <td><strong>trailingZeros</strong></td>
     *             <td>leadingZero</td>
     *             <td>fractionalDigits</td>
     *             <td>0.12</td>
     *             <td>0</td>
     *          </tr>
     *         <tr>
     *             <td>true</td>
     *             <td>true</td>
     *             <td>3</td>
     *             <td>0.120</td>
     *             <td>0.000</td>
     *         </tr>
     *         <tr>
     *             <td>false</td>
     *             <td>true</td>
     *             <td>3</td>
     *             <td>0.12</td>
     *             <td>0</td>
     *         </tr>
     *         <tr>
     *             <td>true</td>
     *             <td>false</td>
     *             <td>3</td>
     *             <td>.120</td>
     *             <td>.000</td>
     *         </tr>
     *         <tr>
     *             <td>false</td>
     *             <td>false</td>
     *             <td>3</td>
     *             <td>.12</td>
     *             <td>0</td>
     *         </tr>
     *  </table>
     *
     *  <p>The default value is dependent on the locale and operating system.</p>
     *
     *  @throws TypeError if this property is assigned a null value.
     * 
     *  @see #leadingZero
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function get trailingZeros():Boolean
    {
        return getBasicProperty(properties, TRAILING_ZEROS);
    }

    public function set trailingZeros(value:Boolean):void
    {
        setBasicProperty(properties, TRAILING_ZEROS, value);
    }

    //----------------------------------
    //  useGrouping
    //----------------------------------

    [Bindable("change")]

    /**
     *  Enables the use of the grouping separator when formatting numbers.
     *
     *  <p>When the <code>useGrouping</code> property is set to
     *  <code>true</code>, digits are grouped and
     *  delimited by the grouping separator character.
     *  For example: <code>123,456,789.22</code></p>
     *
     *  <p>When the <code>useGrouping</code> property is set to
     *  <code>false</code>, digits are not grouped or separated.
     *  For example: <code>123456789.22</code></p>

     *  <p>The symbol to be used as a grouping separator is defined
     *  by the <code>groupingSeparator</code> property. The number of digits
     *  between grouping separators is defined by the
     *  <code>groupingPattern</code> property.</p>
     *
     *  <p>The default value is dependent on the locale and operating system.</p>
     *  
     *  @see #groupingPattern
     *  @see #groupingSeparator
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function get useGrouping():Boolean
    {
        return getBasicProperty(properties, USE_GROUPING);
    }

    public function set useGrouping(value:Boolean):void
    {
        setBasicProperty(properties, USE_GROUPING, value);
    }

    //--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  A simple number parsing function...
     *  @param inputString        An input string to parse.
     *  @param decimalSymbol        A customizable decimal symbol.
     *  @param grouppingSymbol    A customizable groupping symbol.
     *  @return    A Number result. <p>If input string is not a valid number
     *              formatting string, NaN may be returned.</p>
     */
    private static function internalParseNumber(inputString:String,
                    decimalSymbol:String=".", grouppingSymbol:String=","):Number
    {
        // It is better to have static const here, but Flex doesn't allow static
        // declaration in function.
        const numberPattern:RegExp
                    = /^((\d+,?)*\d+)?\.?\d*$|^[-+]?\d+\.?\d*[eE]{1}[-+]?\d+$/;
        const negativePattern:RegExp
            = /^-[ ]?([0-9\.,]+)$|^([0-9\.,]+)[ ]?-$|^\([ ]?([0-9\.,]+)[ ]?\)$/;
        var neg:int = 1;

        // Replace decimal symbol with "."(en_US decimal symbol).
        inputString = inputString.split(decimalSymbol).join(".");
        // Replace groupping symbol with ","(en_US groupping symbol).
        inputString = inputString.split(grouppingSymbol).join(",");
        // Using flex mx.utils.StringUtil trim function to remove front and back
        // space.
        inputString = StringUtil.trim(inputString);
        // Test the input string with negative number pattern, if it matches,
        // then set negative flag to -1.
        if (inputString && negativePattern.test(inputString))
        {
            var result:Array = inputString.match(negativePattern);
            for (var i:int = 1; i < result.length; i++)
            {
                if (result[i] != undefined)
                    break;
            }
            inputString = result[i];
            neg = -1;
        }
        // Test the filtered string with positive number pattern, if it doesn't
        // match, then it is not a valid number.
        if (!inputString || !numberPattern.test(inputString))
            return NaN;
        // Removing groupping symbol from candidate string.
        inputString = inputString.split(",").join("");
        // Using AS2 Number parsing function to convert the simple string to
        // Number.
        return Number(inputString) * neg;
    }

    /**
     *  @private
     *  Number parser for fallback mechanism.
     *
     *  All positive and negative number formats supported by
     *  flash.globalization.NumberFormatter are supported simultaneously.
     *  In other words, this function is always tolerant on the input format.
     */
    mx_internal function parseToNumberParseResult(inputString:String)
                                                            :NumberParseResult
    {
        for (var i:int = 0; i < inputString.length; ++i)
        {
            for (var j:int = inputString.length; j > i; j--)
            {
                const num:Number = internalParseNumber(
                                inputString.substring(i, j), decimalSeparator,
                                groupingSeparator);
                if (!isNaN(num))
                    return new NumberParseResult(num,i,j);
            }
        }
        return new NumberParseResult(NaN);
    }

    /**
     *  @private
     *  Currency parser for fallback mechanism.
     *
     *  All positive and negative currency formats supported by
     *  flash.globalization.CurrencyFormatter are supported simultaneously.
     *  In other words, this function is always tolerant on the input format.
     */
    mx_internal function parseToCurrencyParseResult(inputString:String)
                                                            :CurrencyParseResult
    {
        const negativePattern:RegExp = /^-[ ]?(.+)$|^(.+)[ ]?-$|^\((.+)\)$/;
        var neg:int = 1;

        // Using flex mx.utils.StringUtil trim function to remove front and back
        // space.
        inputString = StringUtil.trim(inputString);
        // Test the input string with negative currency pattern, if it matches,
        // then set negative flag to -1.
        if (negativePattern.test(inputString))
        {
            var result:Array = inputString.match(negativePattern);
            for (var i:int = 1; i < result.length; i++)
            {
                if (result[i] != undefined)
                    break;
            }
            inputString = result[i];
            neg = -1;
        }
        const numres:NumberParseResult = parseToNumberParseResult(inputString);
        const prefix:String
                = StringUtil.trim(inputString.substring(0, numres.startIndex));
        const suffix:String
                    = StringUtil.trim(inputString.substring(numres.endIndex));
        if (isNaN(numres.value) || ((numres.value < 0) && (neg == -1))
                                || ((prefix.length > 0) && (suffix.length > 0)))
        {
            return new CurrencyParseResult(NaN);
        }
        const cur:String = (prefix.length > 0) ? prefix : suffix;
        return new CurrencyParseResult( numres.value * neg, cur);
    }
}
}
