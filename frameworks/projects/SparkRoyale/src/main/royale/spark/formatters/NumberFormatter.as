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

package spark.formatters
{
// was flash.globalization
import mx.globalization.NationalDigitsType;
import mx.globalization.NumberFormatter;
import mx.globalization.NumberParseResult;

import mx.core.mx_internal;
import mx.formatters.IFormatter;

import spark.formatters.supportClasses.NumberFormatterBase;
import mx.globalization.LastOperationStatus;
import mx.resources.ResourceManager;
import mx.resources.IResourceManager;

use namespace mx_internal;

import mx.messaging.errors.ArgumentError;


//[ResourceBundle("core")]

/**
 *  The NumberFormatter class provides locale-sensitive formatting
 *  and parsing of numeric values. It can format <code>int</code>,
 *  <code>uint</code>, and <code>Number</code> objects.
 *
 *  <p>This class is a wrapper class around the 
 *  flash.globalization.NumberFormatter class. 
 *  Therefore, the locale-specific formatting
 *  is provided by the flash.globalization.NumberFormatter.
 *  However, this NumberFormatter class can be used in MXML declarations,
 *  uses the locale style for the requested Locale ID name, and has
 *  methods and properties that are bindable.  
 *  </p>
 *
 *  <p>The flash.globalization.NumberFormatter class use the
 *  underlying operating system for the formatting functionality and
 *  to supply the locale-specific data. On some operating systems, the
 *  flash.globalization classes are unsupported, on these systems this wrapper
 *  class provides fallback functionality.</p>
 *
 *  @mxml <p>The <code>&lt;s:NumberFormatter&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:NumberFormatter 
 *    <strong>Properties</strong>
 *    negativeNumberFormat="<i>locale and OS dependent</i>"
 *  /&gt;
 *  </pre>
 *
 *  @includeExample examples/NumberFormatterExample1.mxml
 *  @includeExample examples/NumberFormatterExample2.mxml
 *
 *  @see flash.globalization.NumberFormatter
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10.1
 *  @playerversion AIR 2.5
 *  @productversion Royale 0.9.8
 */
public class NumberFormatter extends NumberFormatterBase implements IFormatter
{
//    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------

    private static const NEGATIVE_NUMBER_FORMAT:String = "negativeNumberFormat";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructs a new NumberFormatter object to format numbers according
     *  to the conventions of a given locale.
     *  <p>
     *  The locale for this class is supplied by the locale style.
     *  The locale style can be set in several ways:
     *  </p>
     *  <ul>
     *  <li>
     *  By using the class in an MXML declaration and inheriting the
     *  locale from the document that contains the declaration.
     *  Example: <pre>
     *  &lt;fx:Declarations&gt; <br>
     *         &lt;s:NumberFormatter id="nf" /&gt;<br>
     *  &lt;/fx:Declarations&gt;</pre>
     *  </li>
     *  <li>
     *  By using an MXML declaration and specifying the locale value in
     *  the list of assignments.
     *  Example:<pre>
     *  &lt;fx:Declarations&gt;<br>
     *      &lt;s:NumberFormatter id="nf_French_France" locale="fr_FR" /&gt;<br>
     *  &lt;/fx:Declarations&gt;</pre>
     *  </li>
     *  <li>
     *  Calling the setStyle method. For example:<pre>
     *  <code>nf.setStyle("locale", "fr-FR")</code></pre>
     *  </li>
     *  <li> 
     *  Inheriting the style from a <code>UIComponent</code> by calling 
     *  the UIComponent's <code>addStyleClient()</code> method.
     *  </li>
     *  </ul>
     *  <p>
     *  If the <code>locale</code> style is not set by one of the above 
     *  techniques, the instance of this class will be added as a 
     *  <code>StyleClient</code> to the <code>topLevelApplication</code> and 
     *  will therefore inherit the <code>locale</code> style from the 
     *  <code>topLevelApplication</code> object when the <code>locale</code> 
     *  dependent property getter or <code>locale</code> dependent method is 
     *  called.
     *  </p>   
     *  <p>Most of the properties of 
     *  this class are automatically set based on the locale style. If the
     *  locale style is changed, any properties that have not been explicitly
     *  set will also be updated based on the new locale. Note that the 
     *  actual locale that is used is specified by the actualLocaleIDName
     *  property.</p>
     * 
     *  @see #actualLocaleIDName
     *  @see #lastOperationsStatus
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function NumberFormatter()
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
     */
    private var resourceManager:IResourceManager =
        ResourceManager.getInstance();
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  actualLocaleIDName
    //----------------------------------

    [Bindable("change")]

    /**
     *  @inheritDoc
     *
     *  @see flash.globalization.NumberFormatter.actualLocaleIDName
     *  @see #NumberFormatter()
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    override public function get actualLocaleIDName():String
    {
        if (g11nWorkingInstance)
        {
            return (g11nWorkingInstance
                as mx.globalization.NumberFormatter).actualLocaleIDName;
        }

        if ((localeStyle === undefined) || (localeStyle === null))
        {
            fallbackLastOperationStatus
                                = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
        }

        fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;

        return "en-US";
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  negativeNumberFormat
    //----------------------------------

    [Bindable("change")]
    [Inspectable(category="General", enumeration="0,1,2,3,4")]

    /**
     *  A numeric value that indicates a formatting pattern for negative
     *  numbers.
     *  This pattern defines the location of the negative symbol
     *  or parentheses in relation to the numeric portion of the
     *  formatted number.
     *
     *  <p>The following table summarizes the possible formats for
     *  negative numbers. When a negative number is formatted,
     *  the minus sign in the format is replaced with the value of
     *  the <code>negativeSymbol</code> property and the 'n' character is
     *  replaced with the formatted numeric value.</p>
     *
     *    <table class="innertable" border="0">
     *        <tr>
     *            <td>Negative number format type</td>
     *            <td>Format</td>
     *        </tr>
     *        <tr>
     *            <td>0</td>
     *            <td>(n)</td>
     *        </tr>
     *        <tr>
     *            <td>1</td>
     *            <td>-n</td>
     *        </tr>
     *        <tr>
     *            <td>2</td>
     *            <td>- n</td>
     *        </tr>
     *        <tr>
     *            <td>3</td>
     *            <td>n-</td>
     *        </tr>
     *        <tr>
     *            <td>4</td>
     *            <td>n -</td>
     *        </tr>
     *    </table>
     *
     *
     *  <p>The default value is dependent on the locale and operating system.</p>
     *
     *  @throws ArgumentError if the assigned value is not a number
     *  between 0 and 4.
     *
     *  @see #negativeSymbol
     *  @see #format()
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function get negativeNumberFormat():uint
    {
        return getBasicProperty(properties, NEGATIVE_NUMBER_FORMAT);
    }

    public function set negativeNumberFormat(value:uint):void
    {
        if (!g11nWorkingInstance)
        {
            if (4 < value)
            {
                const message:String = 
                    resourceManager.getString("core","badIndex",
                        [ negativeNumberFormat ]);
                throw new ArgumentError(message);
            }
        }

        setBasicProperty(properties, NEGATIVE_NUMBER_FORMAT, value);
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override mx_internal function createWorkingInstance():void
    {
        if ((localeStyle === undefined) || (localeStyle === null))
        {
            fallbackLastOperationStatus
                                = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            g11nWorkingInstance = null;
            properties = null;
            return;
        }

        if (enforceFallback)
        {
            fallbackInstantiate();
            g11nWorkingInstance = null;
            return;
        }

        g11nWorkingInstance
                    = new mx.globalization.NumberFormatter(localeStyle);
        if (g11nWorkingInstance &&
            (g11nWorkingInstance.lastOperationStatus
                                    != LastOperationStatus.UNSUPPORTED_ERROR))
        {
            properties = g11nWorkingInstance
            propagateBasicProperties(g11nWorkingInstance);
            return;
        }

        fallbackInstantiate();
        g11nWorkingInstance = null;

        if (fallbackLastOperationStatus == LastOperationStatus.NO_ERROR)
        {
            fallbackLastOperationStatus
                                = LastOperationStatus.USING_FALLBACK_WARNING;
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    [Bindable("change")]

    /**
     *  Formats a number.
     *
     * <p>This function formats the number based on the property values
     *  of the formatter.
     *  If the properties are not modified after the <code>locale</code> style is set,  
     *  the numbers are formatted according to the locale-specific conventions
     *  provided by the operating system for the locale identified
     *  by the <code>actualLocaleIDName</code> property.
     *  To customize the format, the properties
     *  can be altered to control specific aspects of formatting a number.</p>
     *
     *  <p>Very large numbers and very small magnitude numbers can be
     *  formatted with this function. However, the
     *  number of significant digits is limited to the precision provided
     *  by the <code>Number</code> object. Scientific notation is not
     *  supported.</p>
     * 
     *  <p>If there is an error when formatting, due to an illegal input value 
     *  or other error, by default the <code>format()</code> method  
     *  returns <code>null</code>. 
     *  However if the <code>errorText</code> property
     *  is non-null, then the value of the <code>errorText</code> property  
     *  is returned. The <code>lastOperationStatus</code> property will be
     *  set to indicate the error that occurred.</p>
     *
     *  @param value An object containing a number value to format. If the 
     *  object is not a <code>Number</code> then it is converted
     *  to a number using the <code>Number()</code> conversion function.
     *     
     *  @return A formatted number string.
     *
     *  @see #NumberFormatter
     *  @see spark.formatters.supportClasses.NumberFormatterBase#errorText
     *  @see #lastOperationStatus
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function format(value:Object):String
    {
        if (value == null)
            return null;

        const number:Number = Number(value);

        if (isNaN(number))
        {
            if (g11nWorkingInstance)
            {
                // Have g11nFormatter.lastOperationStatus property hold
                // ILLEGAL_ARGUMENT_ERROR value.
                (g11nWorkingInstance as
                    mx.globalization.NumberFormatter).fractionalDigits = -1;
            }
            else
            {
                fallbackLastOperationStatus
                = LastOperationStatus.ILLEGAL_ARGUMENT_ERROR;
            }
            return errorText;
        }

        if (g11nWorkingInstance)
        {
            const g11nFormatter:mx.globalization.NumberFormatter
                = (g11nWorkingInstance as mx.globalization.NumberFormatter);

            const retVal:String = g11nFormatter.formatNumber(number);

            return errorText && LastOperationStatus.isError(
                        g11nFormatter.lastOperationStatus) ? errorText : retVal;
        }

        if ((localeStyle === undefined) || (localeStyle === null))
        {
            fallbackLastOperationStatus
                                = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return errorText;
        }

        fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;

        return number.toFixed(properties.fractionalDigits);
    }

    [Bindable("change")]

    /**
     *  Parses a string and returns a <code>NumberParseResult</code> object
     *  containing the parsed elements.
     *
     *  <p>The <code>NumberParseResult</code> object contains
     *  the value of the first number found in the input string, the
     *  starting index for the number within the string, and the index
     *  of the first character after the number in the string.</p>
     *
     *  <p>If the string does not contain a number, the value property of
     *  the NumberParseResult is set to <code>NaN</code> and the
     *  <code>startIndex</code> and <code>endIndex</code> properties are
     *  set to the hexadecimal value <code>0x7fffffff</code>.
     *  </p>
     *
     *  <p>This function uses the value of the <code>decimalSeparator</code>
     *  property to determine the portion of the number
     *  that contains fractional
     *  digits, and the <code>groupingSeparator</code> property to determine
     *  which characters are allowed within the digits of a number,
     *  and the <code>negativeNumberFormat</code> property to control
     *  how negative values are represented. </p>
     *
     *  <p>The following table identifies the result of strings parsed
     *  for the various <code>NegativeNumberFormat</code> values:</p>
     *    <table class="innertable" border="0">
     *        <tr>
     *            <td>NegativeNumberFormat</td>
     *            <td>Input String</td>
     *            <td>Result</td>
     *         </tr>
     *        <tr>
     *            <td>(n)</td>
     *            <td>"(123)" or "( 123 )"</td>
     *            <td>"-123"</td>
     *        </tr>
     *        <tr>
     *            <td>-n</td>
     *            <td>"-123" or "- 123"</td>
     *            <td>"-123"</td>
     *        </tr>
     *        <tr>
     *            <td>- n</td>
     *            <td>"-123" or "- 123"</td>
     *            <td>"-123"</td>
     *        </tr>
     *        <tr>
     *            <td>n-</td>
     *            <td>"123-" or "123 -"</td>
     *            <td>"-123"</td>
     *        </tr>
     *        <tr>
     *            <td>n -</td>
     *            <td>"123-" or "123 -"</td>
     *            <td>"-123"</td>
     *        </tr>
     *    </table>
     *
     *  <p>A single white space is allowed between the number and the
     *  minus sign or parenthesis. A white space
     *  character is a character that has a Space Separator (Zs) property
     *  in the Unicode Character Database.
     *  For more information, 
     *  see <a href="http://www.unicode.org/ucd/">http://www.unicode.org/ucd/</a>).</p>
     *
     *  <p>Other properties are ignored when determining a valid number.
     *  Specifically the value of the
     *  <code>digitsType</code> property is ignored and the digits can be
     *  from any of
     *  the digit sets that are enumerated in the 
     *  <code>NationalDigitsType</code> class.
     *  The values of the <code>groupingPattern</code>
     *  and <code>useGrouping</code> properties do not influence the
     *  parsing of the number.
     *  </p>
     *
     *  <p>If numbers are preceded or followed in the string by a
     *  plus sign '+', the plus sign is treated as
     *  a character that is not part of the number.
     *  </p>
     *
     *  <p>This function does not parse strings containing numbers
     *  in scientific notation (e.g. 1.23e40).</p>
     *
     *
     *  @example The following code parses a number from a string and
     *  retrieves the prefix and suffix:
     *  <listing version="3.0" >
     *  var nf:NumberFormatter = new NumberFormatter();
     *  nf.setStyle("locale","fr-FR");
     *  var str:String = "1,56 m&#232;tre"
     *  var result:NumberParseResult = nf.parse(str);
     *  trace(result.value) // 1.56
     *  trace(str.substr(0,result.startIndex));                // ""
     *  trace(str.substr(result.startIndex, result.endIndex)); // "1,56"
     *  trace(str.substr(result.endIndex));                 // " m&#232;tre"
     *  </listing>
     *
     *  @param inputString The input string to parse.
     *
     *  @return A <code>NumberParseResult</code> object containing the numeric
     *  value and the indices for the start and end of the portion of the string
     *  that contains the number.
     *
     *  @throws TypeError if the <code>inputString</code> parameter is null.
     *
     *  @see flash.globalization.NumberParseResult
     *  @see #parseNumber()
     *  @see flash.globalization.NationalDigitsType
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function parse(inputString:String):NumberParseResult
    {
        if (g11nWorkingInstance)
        {
            return (g11nWorkingInstance
                as mx.globalization.NumberFormatter).parse(inputString);
        }

        if ((localeStyle === undefined) || (localeStyle === null))
        {
            fallbackLastOperationStatus
                                = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
        }

        fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;

        return fallbackParse(inputString);
    }

    [Bindable("change")]

    /**
     *  Parses a string that contains only digits and optional whitespace
     *  characters and returns a Number. If the string does not begin
     *  with a number or contains characters other than whitespace that
     *  are not part of the number, then this method returns
     *  <code>NaN</code>. White space before or after
     *  the numeric digits is ignored. 
     *
     *  <p>If the numeric digit is preceded or followed by a
     *  plus sign '+' it is treated as a non-whitespace character.
     *  The return value is <code>NaN</code>.
     *  </p>
     *
     *  <p>See the description of the parse function for more information
     *  about number parsing and what constitutes a valid number.
     *  </p>
     *
     *  @throws TypeError if the <code>parseString</code> is <code>null</code>
     *
     *  @param inputString The input string to parse.
     *
     *  @return A <code>Number</code> object containing the numeric value.
     *
     *  @see #parse()
     *  @see flash.globalization.NationalDigitsType
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function parseNumber(parseString:String):Number
    {
        if (g11nWorkingInstance)
        {
            return (g11nWorkingInstance
               as mx.globalization.NumberFormatter).parseNumber(parseString);
        }

        if ((localeStyle === undefined) || (localeStyle === null))
        {
            fallbackLastOperationStatus
                                = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
        }

        const number:Number = fallbackParseNumber(parseString);

        fallbackLastOperationStatus = isNaN(number) ?
                LastOperationStatus.PARSE_ERROR : LastOperationStatus.NO_ERROR;

        return number;
    }

    /**
     *  Lists all of the locale ID names supported by this class. This is a list of locales supported by 
     *  the operating system, not a list of locales that the ResourceManager has resources for.
     *
     *  @return A vector of strings containing all of the locale ID names
     *         supported by this class and operating system.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    static public function getAvailableLocaleIDNames():Vector.<String>
    {
        const locales:Vector.<String>
            = mx.globalization.NumberFormatter.getAvailableLocaleIDNames();

        return locales ? locales : new Vector.<String>["en-US"];
    }

    //--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------

    private function fallbackParse(parseString:String):NumberParseResult
    {
        return parseToNumberParseResult(parseString);
    }

    private function fallbackParseNumber(value:String):Number
    {
        const res:NumberParseResult = parseToNumberParseResult(value);

        if (!res.startIndex && (res.endIndex == value.length))
            return res.value;

        return NaN;
    }

    private function fallbackInstantiate():void
    {
        properties =
            {
                fractionalDigits: 0,
                useGrouping: false,
                groupingPattern: "3",
                digitsType: NationalDigitsType.EUROPEAN,
                decimalSeparator: ".",
                groupingSeparator: ",",
                negativeSymbol: "-",
                negativeNumberFormat: 0,
                leadingZero: true,
                trailingZeros: false
            };

        propagateBasicProperties(properties);

        fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
    }
}
}
