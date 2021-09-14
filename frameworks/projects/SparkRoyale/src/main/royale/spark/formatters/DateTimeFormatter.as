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

// these were flash.globalization
import mx.globalization.DateTimeFormatter;
import mx.globalization.DateTimeNameStyle;
import mx.globalization.DateTimeStyle;

import mx.core.mx_internal;
import mx.formatters.IFormatter;

import mx.globalization.LastOperationStatus;
import mx.globalization.supportClasses.GlobalizationBase;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;

use namespace mx_internal;

import mx.messaging.errors.ArgumentError;

//[ResourceBundle("core")]

/**
 *  The DateTimeFormatter class provides locale-sensitve
 *  formatting for a <code>Date</code> object.
 *
 *  <p>This class is a wrapper class around the
 *  flash.globalization.DateTimeFormatter class.
 *  Therefore, the locale-specific formatting functionality and the month
 *  names, day names and the first day of the week are provided by the
 *  flash.globalization.DateTimeFormatter.
 *  However, this DateTimeFormatter class can be used in MXML declarations,
 *  uses the locale style for the requested Locale ID name, and has methods
 *  and properties that are bindable.</p>
 *
 *  <p>The flash.globalization.DateTimeFormatter class uses the
 *  underlying operating system for the formatting functionality and to
 *  supply the locale-specific data.
 *  On some operating systems, the flash.globalization classes
 *  are unsupported, on these systems, this wrapper class provides 
 *  fallback functionality.</p>
 *
 *  @mxml <p>The <code>&lt;s:DateTimeFormatter&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:DateTimeFormatter
 *    <strong>Properties</strong>
 *    dateStyle="long"
 *    dateTimePattern="EEEE, MMMM dd, yyyy h:mm:ss a"
 *    errorText="null"
 *    timeStyle="long"
 *    useUTC="false"
 *  /&gt;
 *  </pre>
 *
 *  @includeExample examples/DateTimeFormatterExample.mxml
 *
 *  @see flash.globalization.DateTimeFormatter
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.1
 *  @playerversion AIR 2.5
 *  @productversion Royale 0.9.8
 */
public class DateTimeFormatter extends GlobalizationBase implements IFormatter
{
    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private static const DATE_STYLE:String = "dateStyle";
    private static const TIME_STYLE:String = "timeStyle";
    private static const DATE_TIME_PATTERN:String = "dateTimePattern";
    // Note: new Date(undefined) creates a Date object with NaN value for each
    // of the elements.
    private static const UNDEFINED_DATE:Date = new Date(undefined);

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructs a new <code>DateTimeFormatter</code> object to format
     *  dates and times according to the conventions of the specified locale
     *  and the provided date and time formatting styles.
     *
     *  <p>The locale for this class is supplied by the locale style. The
     *  locale style can be set in several ways:
     *  </p>
     *  <ul>
     *  <li>
     *  By using the class in an MXML declaration and inheriting the
     *  locale from the document that contains the declaration.
     *  </li>
     *  Example:<pre>
     *  &lt;fx:Declarations&gt; 
     *         &lt;s:DateTimeFormatter id="df" /&gt;
     *  &lt;/fx:Declarations&gt;</pre>
     *  <li>
     *  By using an MXML declaration and specifying the locale value
     *  in the list of assignments.
     *  </li>
     *  Example:<pre>
     *  &lt;fx:Declarations&gt; 
     *      &lt;s:DateTimeFormatter id="df_Japanese" locale="ja-JP" /&gt;
     *  &lt;/fx:Declarations&gt;</pre>
     *  <li>
     *  Calling the setStyle method. For example: <pre>
     *  df.setStyle("locale", "ja-JP")</pre>
     *  </li>
     *  <li> 
     *  Inheriting the style from a <code>UIComponent</code> by calling the
     *  UIComponent's <code>addStyleClient()</code> method.
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
     * 
     *  <p>Most of the properties of 
     *  this class are automatically set based on the locale style. If the
     *  locale style is changed, any properties that have not been explicitly
     *  set will also be updated based on the new locale. Note that the 
     *  actual locale that is used is specified by the actualLocaleIDName
     *  property.</p>
     *  
     *  
     *  @see #actualLocaleIDName
     *  @see #lastOperationsStatus
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function DateTimeFormatter()
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
    
    /**
     *  @private
     */
    private var timeStyleOverride:String = DateTimeStyle.LONG;

    /**
     *  @private
     */
    private var dateStyleOverride:String = DateTimeStyle.LONG;

    /**
     *  @private
     */
    private var dateTimePatternOverride:String = null;

    /**
     *  @private
     */
    private var fallbackFormatter:FallbackDateTimeFormatter = null;

    /**
     *  @private
     */
    private var _g11nWorkingInstance:mx.globalization.DateTimeFormatter
        = null;
    
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
    private function get g11nWorkingInstance ():
        mx.globalization.DateTimeFormatter
    {
        if (!_g11nWorkingInstance)
             ensureStyleSource();

        return _g11nWorkingInstance;
    }
    
    private function set g11nWorkingInstance 
        (flashFormatter:mx.globalization.DateTimeFormatter): void 
    {
        _g11nWorkingInstance = flashFormatter;
    }
        
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
     *  @see flash.globalization.DateTimeFormatter.actualLocaleIDName
     *  @see #DateTimeFormatter()
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    override public function get actualLocaleIDName():String
    {
        if (g11nWorkingInstance)
            return g11nWorkingInstance.actualLocaleIDName;

        if ((localeStyle === undefined) || (localeStyle === null))
        {
            fallbackLastOperationStatus
                                = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
        }

        fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;

        return "en-US";
    }

    //----------------------------------
    //  lastOperationStatus
    //----------------------------------

    [Bindable("change")]

    /**
     *  @inheritDoc
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
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
    //  dateStyle
    //----------------------------------

    [Bindable("change")]
    [Inspectable(category="General", enumeration="long,medium,short,none",
                                                        defaultValue="long")]

    /**
     *  The date style for this instance of the DateTimeFormatter.
     *
     *  The date style is used to retrieve a predefined time and locale
     *  specific formatting pattern from the operating system.
     *  When formatting a date, the <code>locale</code> style, the
     *  <code>timeStyle</code> and the <code>dateStyle</code> properties
     *  determine the format of the date.
     *
     *  The date style value can be set in the following two ways:
     *  assigning a value to either the <code>dateStyle</code> property or
     *  the <code>dateTimePattern</code> property. 
     *
     *  <p>The possible for this property are defined by 
     *  the flash.globalization.DateTimeStyle class. 
     *  Possible values for the <code>dateStyle</code> property are:</p>
     *
     *  <ul>
     *  <li><code>DateTimeStyle.LONG</code> </li>
     *  <li><code>DateTimeStyle.MEDIUM</code> </li>
     *  <li><code>DateTimeStyle.SHORT </code></li>
     *  <li><code>DateTimeStyle.NONE </code></li>
     *  <li><code>DateTimeStyle.CUSTOM </code></li>
     *  </ul>
     * 
     * <p>If the <code>dateTimePattern</code>
     *  property is assigned a value, as a side effect, the <code>dateStyle</code> property 
     *  is set to <code>DateTimeStyle.CUSTOM </code></p>
     *
     *  @default <code>DateTimeStyle.LONG</code>
     *
     *  @throws ArgumentError if the assigned value is not a valid
     *          <code>DateTimeStyle</code> constant or is
     *          <code>DateTimeStyle.CUSTOM</code>.
     *  @throws TypeError if the <code>dateStyle</code> or
     *          is set to <code>null</code>.
     *
     *  @see #dateStyle
     *  @see #dateTimePattern
     *  @see #lastOperationStatus
     *  @see flash.globalization.DateTimeStyle
     *  @see #DateTimeFormatter()
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function get dateStyle():String
    {
        
        if (g11nWorkingInstance)
            return g11nWorkingInstance.getDateStyle();


        if ((localeStyle === undefined) || (localeStyle === null))
        {
            fallbackLastOperationStatus
                                = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
        }

        return fallbackFormatter.dateStyle;
    }

    public function set dateStyle(value:String):void
    {
        if (dateStyleOverride && (dateStyleOverride == value))
            return;
        dateStyleOverride = value;

        if (g11nWorkingInstance)
        {
            g11nWorkingInstance.setDateTimeStyles(value, timeStyleOverride);
            dateTimePatternOverride = null;
        }
        else
        {
            if (!FallbackDateTimeFormatter.validDateTimeStyle(value))
            {
                const message:String = 
                 resourceManager.getString("core","badParameter",[ dateStyle ]);
                throw new ArgumentError(message);
            }
               

            if (fallbackFormatter)
                fallbackFormatter.dateStyle = value;
            fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
        }

        update();
    }

    //----------------------------------
    //  dateTimePattern
    //----------------------------------

    [Bindable("change")]

    /**
     *  The pattern string used by the DateTimeFormatter object to format
     *  dates and times.
     *
     *  <p>This pattern can be set in one of two ways:</p>
     *
     *  <ol>
     *     <li>By setting the <code>dateStyle</code> and <code>timeStyle</code>
     *     properties. </li>
     *     <li>By setting the <code>dateTimePattern</code> property.</li>
     *  </ol>
     *
     *  <p>If this property is assigned a value directly, as a side effect,
     *  the current time and date styles are overridden and
     *  set to the value <code>DateTimeStyle.CUSTOM</code>.</p>
     *
     *  <p>For a description of the pattern syntax, please see the
     *  <a href="..\..\flash\globalization\DateTimeFormatter.html#setDateTimePattern()">
     *  <code>flash.globalization.DateTimeFormatter.setDateTimePattern()
     *  </code></a> method.</p>
     *
     *  @default "EEEE, MMMM dd, yyyy h:mm:ss a"
     *
     *  @see #dateStyle
     *  @see #timeStyle
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function get dateTimePattern():String
    {
        if (g11nWorkingInstance)
            return g11nWorkingInstance.getDateTimePattern();

        if ((localeStyle === undefined) || (localeStyle === null))
        {
            fallbackLastOperationStatus
                                = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
        }

        return fallbackFormatter.dateTimePattern;
    }

    public function set dateTimePattern(value:String):void
    {
        if (dateTimePatternOverride && (dateTimePatternOverride == value))
            return;
        dateTimePatternOverride = value;
        
        if (g11nWorkingInstance)
            g11nWorkingInstance.setDateTimePattern(value);
        else
        {
            if (!value)
            {
                const message:String = 
                    resourceManager.getString("core","nullParameter",
                        [ dateTimePattern ]);
                throw new TypeError(message);
            }

            if (fallbackFormatter)
                fallbackFormatter.dateTimePattern = value;
            fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
        }

        update();
    }

    //----------------------------------
    //  errorText
    //----------------------------------

    private var _errorText:String;

    [Bindable("change")]

    /**
     *  String returned by the <code>format()</code> method
     *  when an error occurs.
     *
     *  <p>If <code>errorText</code> is non-null and an error occurs
     *  while formatting a date, the format method
     *  will return the string assigned to this property.</p>
     *
     *  For example:
     *  <listing version="3.0" >
     *  var dtf:DateTimeFormatter = new DateTimeFormatter();
     *  dtf.setStyle("locale", "en-US");
     *  dtf.errorText = "----"
     *  trace(dtf.format("abc"));  // ----
     *  </listing>
     *
     *  @default null
     *
     *  @see mx.globalization.LastOperationStatus
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
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
    //  timeStyle
    //----------------------------------

    [Bindable("change")]
    [Inspectable(category="General", enumeration="long,medium,short,none",
                                                        defaultValue="long")]

    /**
     *  The time style for this instance of the DateTimeFormatter.
     *
     *  The time style is used to retrieve a predefined time and locale
     *  specific formatting pattern from the operating system.
     *  When formatting a date, the <code>locale</code> style, the
     *  <code>timeStyle</code> and the <code>dateStyle</code> properties
     *  determine the format of the date.
     *
     *  The time style value can be set in the following two ways:
     *  assigning a value to either the <code>timeStyle</code> property or
     *  the <code>dateTimePattern</code> property.
     *
     *  <p>The value of the property are defined by the 
     *  flash.globalization.DateTimeStyle class. 
     *  Possible values for the <code>timeStyle</code> property are:</p>
     *
     *  <ul>
     *  <li><code>DateTimeStyle.LONG</code></li>
     *  <li><code>DateTimeStyle.MEDIUM</code></li>
     *  <li><code>DateTimeStyle.SHORT</code></li>
     *  <li><code>DateTimeStyle.NONE</code></li>
     *  <li><code>DateTimeStyle.CUSTOM</code></li>
     *  </ul>
     * 
     * <p>If the <code>dateTimePattern</code>
     *  property is assigned a value, as a side effect, the dateStyle property 
     *  is set to <code>DateTimeStyle.CUSTOM </code></p>
     *
     *  @default <code>DateTimeStyle.LONG</code>
     *
     *  @throws ArgumentError if the assigned value is not a valid 
     *          <code>DateTimeStyle</code>
     *          constant or is <code>DateTimeStyle.CUSTOM </code>.
     *
     *  @throws TypeError if the <code>dateStyle</code> or
     *          <code>timeStyle</code> parameter is null.
     *
     *  @see #dateStyle
     *  @see #dateTimePattern
     *  @see flash.globalization.DateTimeStyle
     *  @see #DateTimeFormatter()
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function get timeStyle():String
    {
         if (g11nWorkingInstance)
            return g11nWorkingInstance.getTimeStyle();

        if ((localeStyle === undefined) || (localeStyle === null))
        {
            fallbackLastOperationStatus
                                = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
        }

        return fallbackFormatter.timeStyle;
    }

    public function set timeStyle(value:String):void
    {
        if (timeStyleOverride && (timeStyleOverride == value))
            return;
        timeStyleOverride = value;

        if (g11nWorkingInstance)
        {
            g11nWorkingInstance.setDateTimeStyles(dateStyleOverride, value);
            dateTimePatternOverride = null;
        }
        else
        {
            if (!FallbackDateTimeFormatter.validDateTimeStyle(value))
            {
                const message:String = 
                    resourceManager.getString("core","badParameter",
                        [ timeStyle ]);
                throw new ArgumentError(message);
            }

            if (fallbackFormatter)
                fallbackFormatter.timeStyle = value;
            fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
        }

        update();
    }

    //----------------------------------
    //  useUTC
    //----------------------------------

    /**
     *  @private
     *  Flag to indicate if UTC is used.
     *
     *  true: format in UTC. false: format in non-UTC
     */
    private var _useUTC:Boolean = false;

    [Bindable("change")]

    /**
     *  A boolean flag to control whether the local or the UTC date and time
     *  values are used when the formatting a date.
     *
     *  If <code>useUTC</code> is set to <code>true</code> then the UTC values 
     *  are used. If the value is set to <code>false</code>, then the 
     *  date time values of the operating system's current time zone is used.
     *
     *  @default false
     * 
     *  @see #format()
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function get useUTC():Boolean
    {
        return _useUTC;
    }

    public function set useUTC(value:Boolean):void
    {
        _useUTC = value;

        update();
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

        g11nWorkingInstance = new mx.globalization.DateTimeFormatter(
            localeStyle, dateStyleOverride, timeStyleOverride);
        if (g11nWorkingInstance
            && (g11nWorkingInstance.lastOperationStatus
                                != LastOperationStatus.UNSUPPORTED_ERROR))
        {
            if (dateTimePatternOverride)
                g11nWorkingInstance.setDateTimePattern(dateTimePatternOverride);
            properties = g11nWorkingInstance;
            propagateBasicProperties(g11nWorkingInstance);
            return;
        }

        fallbackInstantiate();
        g11nWorkingInstance = null;

        if (fallbackFormatter.fallbackLastOperationStatus
                                            == LastOperationStatus.NO_ERROR)
        {
            fallbackFormatter.fallbackLastOperationStatus
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
     * Formats a display string for an object that specifies a date in either 
     * the user's local time or UTC time.
     * 
     *
     *  <p>A <code>Date</code> object has two sets of date and time values,
     *  those in the user's local time (<code>date, day, fullYear, hours, 
     *  minutes, month,</code> and <code>seconds</code>) and those in UTC 
     *  time (<code>dateUTC, dayUTC,
     *  fullYearUTC, hoursUTC, minutesUTC, monthUTC,</code> and 
     *  <code>secondsUTC</code>).
     *  The boolean property <code>useUTC</code> controls which set of
     *  date and time components are used when formatting the date.
     *  The formatting will be done using the conventions of the locale as
     *  set by the <code>locale</code> style property and the
     *  <code>dateStyle</code> and <code>timeStyle</code> properties, or the
     *  <code>dateTimePattern</code>, specified for this
     *  <code>DateTimeFormatter</code> instance.
     *  </p>
     * 
     *  <p>If there is an error when formatting, due to an illegal input value 
     *  or other error, by default the <code>format()</code> method will 
     *  return <code>null</code>. However if the <code>errorText</code> property
     *  is non-null, then the value of the <code>errorText</code> property will
     *  be returned. The <code>lastOperationStatus</code> property will be
     *  set to indicate the error that occurred.</p>
     * 
     *  @param value A <code>Date</code> value to be formatted. If the 
     *  object is not a <code>Date</code> then it will be converted
     *  to a date using the <code>Date()</code> constructor.
     * 
     *  @return A formatted string representing the date or time value.
     *
     *  @see #dateStyle
     *  @see #timeStyle
     *  @see Date
     *  @see #dateTimePattern
     *  @see DateTimeFormatter
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

        const dateTime:Date = (value is Date) ?
                                            (value as Date) : new Date(value);

        if (dateTime == UNDEFINED_DATE)
        {
            if (g11nWorkingInstance)
            {
                // Have g11nFormatter.lastOperationStatus property hold
                // ILLEGAL_ARGUMENT_ERROR value.
                g11nWorkingInstance.setDateTimeStyles(null, null);
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
            const retVal:String = _useUTC ?
                g11nWorkingInstance.formatUTC(dateTime) :
                g11nWorkingInstance.format(dateTime);

            return errorText && LastOperationStatus.isError(
                g11nWorkingInstance.lastOperationStatus) ? errorText : retVal;
        }

        if ((localeStyle === undefined) || (localeStyle === null))
        {
            fallbackLastOperationStatus
                                = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return errorText;
        }

        fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;

        return _useUTC ?
            fallbackFormatter.formatUTC(dateTime) :
            fallbackFormatter.format(dateTime);
    }

    [Bindable("change")]

    /**
     *  Retrieves a list of localized strings containing the month names for
     *  the current calendar system.
     *
     *  The first element in the list is the name for the first month of the
     *  year.
     *
     *  @param nameStyle Indicates the style of name string to be used.
     *          Valid values are:
     *          <ul>
     *              <li><code>DateTimeNameStyle.FULL</code></li>
     *              <li><code>DateTimeNameStyle.LONG_ABBREVIATION</code>
     *                  </li>
     *              <li><code>DateTimeNameStyle.SHORT_ABBREVIATION</code>
     *                  </li>
     *          </ul>
     *  @param context A code indicating the context in which the formatted
     *          string will be used.
     *          This context will only make a difference for certain
     *          locales.
     *          Valid values are:
     *          <ul>
     *              <li><code>DateTimeNameContext.FORMAT</code></li>
     *              <li><code>DateTimeNameContext.STANDALONE</code></li>
     *          </ul>
     *
     *  @return A vector of localized strings containing the month names for
     *          the current locale (specified by the locale style), 
     *          name style and context.
     *          The first element in the vector, at index 0, is the name for
     *          the first month of the year; the next element is the name
     *          for the second month of the year; and so forth.
     *  @throws TypeError if the <code>nameStyle</code> or
     *          <code>context</code> parameter is null.
     *
     *  @see flash.globalization.DateTimeNameContext
     *  @see flash.globalization.DateTimeNameStyle
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function getMonthNames(nameStyle:String = "full",
                            context:String = "standalone"):Vector.<String>
    {
        if (g11nWorkingInstance)
            return g11nWorkingInstance.getMonthNames(nameStyle, context);

        if ((localeStyle === undefined) || (localeStyle === null))
        {
            fallbackLastOperationStatus
                                = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
        }

        fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;

        return fallbackFormatter.getMonthNames(nameStyle, context);
    }

    [Bindable("change")]

    /**
     *  Retrieves a list of localized strings containing the names of
     *  weekdays for the current calendar system.
     *
     *  The first element in the list represents the name for Sunday.
     *
     *  @param nameStyle Indicates the style of name string to be used.
     *          Valid values are:
     *          <ul>
     *              <li><code>DateTimeNameStyle.FULL</code></li>
     *              <li><code>DateTimeNameStyle.LONG_ABBREVIATION</code>
     *                  </li>
     *              <li><code>DateTimeNameStyle.SHORT_ABBREVIATION</code>
     *                  </li>
     *          </ul>
     *  @param context A code indicating the context in which the formatted
     *          string will be used.
     *          This context only applies for certain locales where the name
     *          of a month changes depending on the context.
     *          For example, in Greek the month names are different if they
     *          are displayed alone versus displayed along with a day.
     *          Valid values are:
     *          <ul>
     *              <li><code>DateTimeNameContext.FORMAT</code></li>
     *              <li><code>DateTimeNameContext.STANDALONE</code></li>
     *          </ul>
     *
     *  @return A vector of localized strings containing the month names for
     *          the current locale (specified by the locale style), 
     *          name style and context.
     *          The first element in the vector, at index 0, is the name for
     *          Sunday; the next element is the name for Monday; and so
     *          forth.
     *  @throws TypeError if the <code>nameStyle</code> or
     *          <code>context</code> parameter is null.
     *
     *  @see flash.globalization.DateTimeNameContext
     *  @see flash.globalization.DateTimeNameStyle
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function getWeekdayNames(nameStyle:String = "full",
                            context:String = "standalone"):Vector.<String>
    {
        if (g11nWorkingInstance)
            return g11nWorkingInstance.getWeekdayNames(nameStyle, context);

        if ((localeStyle === undefined) || (localeStyle === null))
        {
            fallbackLastOperationStatus
                                = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
        }

        fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;

        return fallbackFormatter.getWeekdayNames(nameStyle, context);
    }

    [Bindable("change")]

    /**
     *  Returns an integer corresponding to the first day of the week for
     *  this locale and calendar system.
     *
     *  A value of 0 corresponds to Sunday, 1 corresponds to Monday and so
     *  on, with 6 corresponding to Saturday.
     *
     *  @return An integer corresponding to the first day of the week for
     *  this locale and calendar system.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function getFirstWeekday():int
    {
        if (g11nWorkingInstance)
            return g11nWorkingInstance.getFirstWeekday();

        if ((localeStyle === undefined) || (localeStyle === null))
        {
            fallbackLastOperationStatus
                                = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
        }

        fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;

        return 0;
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
    public static function getAvailableLocaleIDNames():Vector.<String>
    {
        const locales:Vector.<String>
            = mx.globalization.DateTimeFormatter.getAvailableLocaleIDNames();

        return locales ? locales : new Vector.<String>["en-US"];
    }

    //--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Imaginary constructor of FallbackCollator.
     */
    private function fallbackInstantiate():void
    {
        fallbackFormatter = new FallbackDateTimeFormatter();

        if (dateStyleOverride)
            fallbackFormatter.dateStyle = dateStyleOverride;

        if (timeStyleOverride)
            fallbackFormatter.timeStyle = timeStyleOverride;

        if (dateTimePatternOverride)
            fallbackFormatter.dateTimePattern = dateTimePatternOverride;

        fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
    }
}
}

import mx.globalization.DateTimeNameStyle;
import mx.globalization.DateTimeStyle;

import mx.globalization.LastOperationStatus;

/**
 *  @private
 *  FallbackDateTimeFormatter.
 */
final class FallbackDateTimeFormatter
{
    //----------------------------------
    // Class constants
    //----------------------------------

    private static const SHORT_DATE_PATTERN:String = "m/d/yyyy";
    private static const MEDIUM_DATE_PATTERN:String = "dddd, mmmm d, yyyy";
    private static const LONG_DATE_PATTERN:String = "dddd, mmmm d, yyyy";
    private static const NONE_DATE_PATTERN:String = "";

    private static const SHORT_TIME_PATTERN:String = "hh:mm a";
    private static const MEDIUM_TIME_PATTERN:String = "hh:mm:ss a";
    private static const LONG_TIME_PATTERN:String = "hh:mm:ss a";
    private static const NONE_TIME_PATTERN:String = "";

    private static const WEEKDAY_LABELS:Vector.<String> = new <String>
        ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
                                                                    "Saturday"];
    private static const WEEKDAY_LABELS_LONG_ABB:Vector.<String> = new <String>
        ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    private static const WEEKDAY_LABELS_SHORT_ABB:Vector.<String> = new <String>
        ["S", "M", "T", "W", "T", "F", "S"];

    private static const MONTH_LABELS:Vector.<String> = new <String>
        ["January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December"];

    private static const MONTH_LABELS_LONG_ABB:Vector.<String> = new <String>
        ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    private static const MONTH_LABELS_SHORT_ABB:Vector.<String> = new <String>
        ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    //----------------------------------
    // Constructor
    //----------------------------------

    public function FallbackDateTimeFormatter()
    {
        super();
    }

    //----------------------------------
    // Variables
    //----------------------------------

    private var utc:Boolean;

    private var dateString:String;

    private var timeString:String;
    private var localTime:String;

    private var thisDate:Date;


    //----------------------------------
    // Properties
    //----------------------------------

    // lastOperationStatus for the imaginal fallback class
    public var fallbackLastOperationStatus:String;

    private var _timeStyle:String;

    public function set timeStyle(value:String):void
    {
        if (value)
            _timeStyle = value;
    }

    public function get timeStyle():String
    {
        return _timeStyle;
    }

    private var _dateStyle:String;

    public function set dateStyle(value:String):void
    {
        if (value)
            _dateStyle = value;
    }

    public function get dateStyle():String
    {
        return _dateStyle;
    }

    private var _dateTimePatternString:String;

    public function get dateTimePattern():String
    {
        switch (dateStyle)
        {
            case DateTimeStyle.SHORT:
                dateString = SHORT_DATE_PATTERN;
                break;
            case DateTimeStyle.MEDIUM:
                dateString = LONG_DATE_PATTERN;
                break;
            case DateTimeStyle.NONE:
                dateString = NONE_DATE_PATTERN;
                break;
            default:
                dateString = LONG_DATE_PATTERN;
        }

        switch (timeStyle)
        {
            case DateTimeStyle.SHORT:
                timeString = SHORT_TIME_PATTERN;
                break;
            case DateTimeStyle.MEDIUM:
                timeString = LONG_TIME_PATTERN;
                break;
            case DateTimeStyle.NONE:
                timeString = NONE_TIME_PATTERN;
                break;
            default:
                timeString =LONG_TIME_PATTERN;
        }

        return (dateString + returnSpace() + timeString);
    }

    public function set dateTimePattern(value:String):void
    {
        _dateTimePatternString = value;
        fallbackLastOperationStatus = LastOperationStatus.UNSUPPORTED_ERROR;
    }

    //----------------------------------
    // Methods
    //----------------------------------

    public function format(dateTime:Date):String
    {
        thisDate = dateTime;
        utc = false;
        return (returnDate(dateTime) + returnSpace() + returnTime(dateTime));
    }

    public function formatUTC(dateTime:Date):String
    {
        thisDate = dateTime;
        utc = true;
        return (returnDate(dateTime) + returnSpace() + returnTime(dateTime));
    }

    public function getMonthNames(nameStyle:String = "full",
                            context:String = "standalone"):Vector.<String>
    {
        switch (nameStyle)
        {
            case DateTimeNameStyle.SHORT_ABBREVIATION:
                return MONTH_LABELS_SHORT_ABB;
            case DateTimeNameStyle.LONG_ABBREVIATION:
                return MONTH_LABELS_LONG_ABB;
        }
        return MONTH_LABELS;
    }

    public function getWeekdayNames(nameStyle:String = "full",
                            context:String = "standalone"):Vector.<String>
    {
        switch (nameStyle)
        {
            case DateTimeNameStyle.SHORT_ABBREVIATION:
                return WEEKDAY_LABELS_SHORT_ABB;
            case DateTimeNameStyle.LONG_ABBREVIATION:
                return WEEKDAY_LABELS_LONG_ABB;
        }
        return WEEKDAY_LABELS;
    }

    public static function validDateTimeStyle(value:String):Boolean
    {
        return value && ((value == DateTimeStyle.LONG)
                        || (value == DateTimeStyle.MEDIUM)
                        || (value == DateTimeStyle.SHORT)
                        || (value == DateTimeStyle.NONE));
    }

    //----------------------------------
    // Private Methods
    //----------------------------------

    private function returnSpace():String
    {
        const fullYearIsNaN:Boolean = thisDate && isNaN(thisDate.fullYear);
        const oneOfStyleIsNone:Boolean = (dateStyle == DateTimeStyle.NONE)
                                        || (timeStyle == DateTimeStyle.NONE);

        return (fullYearIsNaN || oneOfStyleIsNone) ? "" : " ";
    }

    private function returnDate(dateTime:Date):String
    {
        if (isNaN(dateTime.fullYear))
            return "";

        switch (dateStyle)
        {
            case DateTimeStyle.SHORT:
                return shortDate(dateTime);
            case DateTimeStyle.MEDIUM:
                return longDate(dateTime);
            case DateTimeStyle.NONE:
                return "";
        }

        return longDate(dateTime);
    }

    private function returnTime(dateTime:Date):String
    {
        if (isNaN(dateTime.hours))
            return "";

        switch (timeStyle)
        {
            case DateTimeStyle.SHORT:
                return shortTime(dateTime);
            case DateTimeStyle.MEDIUM:
                return longTime(dateTime);
            case DateTimeStyle.NONE:
                return "";
        }

        return longTime(dateTime);
    }

    private function shortDate(dateTime:Date):String
    {
        if (utc)
        {
            return (dateTime.getUTCMonth() + 1) + "/"
                + dateTime.getUTCDate() + "/"
                + dateTime.getUTCFullYear();
        }

        return (dateTime.getMonth() + 1) + "/"
                + dateTime.getDate() + "/"
                + dateTime.getFullYear();
    }

    private function longDate(dateTime:Date):String
    {
        if (utc)
        {
            return (WEEKDAY_LABELS[dateTime.getUTCDay()] + ","+" "
                + MONTH_LABELS[dateTime.getUTCMonth()])+" "
                + dateTime.getUTCDate() + ","+" "
                + dateTime.getUTCFullYear();
        }

        return (WEEKDAY_LABELS[dateTime.getDay()] + ","+" "
            + MONTH_LABELS[dateTime.getMonth()])+" "
            + dateTime.getDate() + ","+" "
            + dateTime.getFullYear();
    }

    private function shortTime(dateTime:Date):String
    {
        localTime = utc ?
            getUSClockTime(dateTime.getUTCHours(), dateTime.getUTCMinutes()) :
            getUSClockTime(dateTime.getHours(), dateTime.getMinutes());

        return localTime + " " + formatAMPM(dateTime);
    }

    private function longTime(dateTime:Date):String
    {
        var seconds:Number;

        if (utc)
        {
            localTime = getUSClockTime(
                            dateTime.getUTCHours(), dateTime.getUTCMinutes());
            seconds = dateTime.getUTCSeconds();
        }
        else
        {
            localTime = getUSClockTime(
                                dateTime.getHours(), dateTime.getMinutes());
            seconds = dateTime.getSeconds();
        }

        return localTime + ":" + doubleDigitFormat(seconds) + " "
                                                        + formatAMPM(dateTime);
    }

    private function getUSClockTime(hrs:uint, mins:uint):String
    {
        const minLabel:String = doubleDigitFormat(mins);

        hrs %= 12;
        hrs = hrs ? hrs : 12;

        return hrs + ":" + minLabel;
    }

    private function doubleDigitFormat(num:uint):String
    {
        return ((num < 10) ? "0" : "") + String(num);
    }

    private function formatAMPM(dateTime:Date):String
    {
        const hours:Number = utc ? dateTime.getUTCHours() : dateTime.getHours();

        return (hours < 12) ? "AM" : "PM";
    }
}
