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

package mx.charts
{

import org.apache.royale.events.Event;

import mx.charts.chartClasses.AxisLabelSet;
import mx.charts.chartClasses.DataDescription;
import mx.charts.chartClasses.DateRangeUtilities;
import mx.charts.chartClasses.NumericAxis;
import mx.core.mx_internal;


use namespace mx_internal;

/**
 *  The DateTimeAxis class maps time values evenly
 *  between a minimum and maximum value along a chart axis.
 *  It can plot values represented either as instances of the Date class,
 *  as numeric values representing the number of milliseconds
 *  since the epoch (midnight on January 1, 1970, GMT),
 *  or as String values when you provide a custom parsing function.  
 *
 *  <p>The DateTimeAxis chooses the most reasonable units
 *  to mark the axis by examining the range between the minimum and maximum
 *  values of the axis.
 *  The Axis chooses the largest unit that generates
 *  a reasonable number of labels for the given range.
 *  You can restrict the set of units the chart considers,
 *  or specify exactly which units it should use,
 *  by setting the <code>labelUnits</code> property.</p>
 *
 *  <p>You can specifiy the minimum and maximum values explicitly,
 *  or let the axis automatically determine them by examining
 *  the values being renderered in the chart.
 *  By default, the DateTimeAxis chooses the smallest possible range
 *  to contain all the values represented in the chart.
 *  Optionally, you can request that the minimum and maximum values
 *  be rounded to whole units
 *  (milliseconds, seconds, minutes, hours, days, weeks, months, years)
 *  by setting the <code>autoAdjust</code> property to <code>true</code>.</p>
 *  
 *  <p>You can specify disabled days of a week and disabled ranges of dates
 *  in order to show only working days on the axis but not all days
 *  between minimum and maximum. It also filters data and shows only data corresponding
 *  to working days on the chart</p>
 *  @see mx.charts.chartClasses.IAxis
 * 
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:DateTimeAxis&gt;</code> tag inherits all the properties
 *  of its parent classes and adds the following properties:</p>
 *  
 *  <pre>
 *  &lt;mx:DateTimeAxis
 *    <strong>Properties</strong>
 *    alignLabelsToUnits="true|false"
 *    dataUnits="milliseconds|seconds|minutes|hours|days|weeks|months|years"
 *    disabledDays="<i>Array; No default</i>"
 *    disabledRanges="<i>Array; No default</i>"
 *    displayLocalTime="<i>false</i>"
 *    interval="<i>Number</i>"
 *    labelUnits="milliseconds|seconds|minutes|hours|days|weeks|months|years"
 *    maximum="<i>Date</i>"
 *    minimum="<i>Date</i>"
 *    minorTickInterval="<i>Number</i>"
 *    minorTickUnits="milliseconds|seconds|minutes|hours|days|weeks|months|years"
 *  /&gt;
 *  </pre>
 *
 *  @includeExample examples/DateTimeAxisExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class DateTimeAxis extends NumericAxis
{
//    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private static const MILLISECONDS_IN_MINUTE:Number = 1000 * 60;
    
    /**
     *  @private
     */
    private static const MILLISECONDS_IN_HOUR:Number = 1000 * 60 * 60;
    
    /**
     *  @private
     */
    private static const MILLISECONDS_IN_DAY:Number = 1000 * 60 * 60 * 24;
    
    /**
     *  @private
     */
    private static const MILLISECONDS_IN_WEEK:Number = 1000 * 60 * 60 * 24 * 7;
    
    /**
     *  @private
     */
    private static const MILLISECONDS_IN_MONTH:Number = 1000 * 60 * 60 * 24 * 30;
    
    /**
     *  @private
     */
    private static const MILLISECONDS_IN_YEAR:Number = 1000 * 60 * 60 * 24 * 365;
    
    /**
     *  @private
     */
    private static const MINIMUM_LABEL_COUNT:Number = 2;
    
    /**
     *  @private
     */
    private var UNIT_PROGRESSION:Object =
    {
        milliseconds: null,
        seconds: "milliseconds",
        minutes: "seconds",
        hours: "minutes",
        days: "hours",
        weeks: "days",
        months: "weeks",
        years: "months"
    };

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function DateTimeAxis()
    {
        super();

        baseAtZero = false;
        autoAdjust = false;

        updatePropertyAccessors();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private static var tmpDate:Date = new Date();
    
    /**
     *  @private
     */
    private var millisecondsP:String;

    /**
     *  @private
     */
    private var secondsP:String;

    /**
     *  @private
     */
    private var minutesP:String;

    /**
     *  @private
     */
    private var hoursP:String;

    /**
     *  @private
     */
    private var dateP:String;

    /**
     *  @private
     */
    private var dayP:String;

    /**
     *  @private
     */
    private var monthP:String;

    /**
     *  @private
     */
    private var fullYearP:String;
    
    /**
     * @private
     */
    private var dateRangeUtilities:DateRangeUtilities = new DateRangeUtilities(); 
    //--------------------------------------------------------------------------
    //
    //  Overridden properties: NumericAxis
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  parseFunction
    //----------------------------------

    [Inspectable(category="Other")]
    
    /** 
     *  Specifies a method that customizes the value of the data points. 
     *  With this property, you specify a method that accepts a value and 
     *  returns a Date object. The Date object is then used in the DateTimeAxis 
     *  object of the chart. This lets you provide customizable date input strings 
     *  and convert them to Date objects, which Flex can then interpret for use in the DateTimeAxis.
     *  
     *  <p>Flex passes only one parameter to the parsing method. This parameter is the value of the 
     *  data point you specified for the series. Typically, it is a String that represents some form 
     *  of a date. You cannot override this parameter or add additional parameters.</p>
     *  
     *  <p>This Date object is immediately converted to a numeric value, 
     *  so custom parseFunctions can reuse the same Date object
     *  for performance reasons.
     *  By default, the DateTimeAxis uses the string parsing functionality
     *  in the ECMA standard <code>Date.parse()</code> method.</p>
     *  
     *  The following example uses a data provider that defines a data object in the format { yyyy, mm, dd }. 
     *  The method specified by the <code>parseFunction</code> uses these values to create a Date object
     *  that the axis can use.
     *  
     *  <pre>
     *  &lt;mx:Script&gt;
     *      import mx.collections.ArrayCollection;
     *      [Bindable] 
     *      public var aapl:ArrayCollection = new ArrayCollection([ 
     *          {date: "2005, 8, 1", close: 42.71},
     *          {date: "2005, 8, 2", close: 42.99},
     *          {date: "2005, 8, 3", close: 44}
     *      ]);
     *      
     *      public function myParseFunction(s:String):Date { 
     *          // Get an array of Strings from the comma-separated String passed in.
     *          var a:Array = s.split(",");
     *  
     *          // Create the new Date object. Note that the month argument is 0-based (with 0 being January).
     *          var newDate:Date = new Date(a[0],a[1]-1,a[2]);
     *          return newDate;
     *      }
     *  &lt;/mx:Script&gt;
     *  &lt;mx:LineChart id="mychart" dataProvider="{aapl}" showDataTips="true"&gt;
     *      &lt;mx:horizontalAxis&gt;
     *          &lt;mx:DateTimeAxis dataUnits="days" parseFunction="myParseFunction"/&gt;
     *      &lt;/mx:horizontalAxis&gt;
     *      &lt;mx:series&gt;
     *          &lt;mx:LineSeries yField="close" xField="date" displayName="AAPL"/&gt;
     *      &lt;/mx:series&gt;
     *  &lt;/mx:LineChart&gt;
     *  </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function set parseFunction(value:Function):void
    {
        super.parseFunction = value;
    }

    //----------------------------------
    //  requiredDescribedFields
    //----------------------------------

    /**
     *  The fields of the DescribeData structure that this axis is interested in.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function get requiredDescribedFields():uint
    {
        var fields:uint = DataDescription.REQUIRED_MIN_MAX |
               DataDescription.REQUIRED_BOUNDED_VALUES;
        
        if (_userDataUnits == null)
            fields |= DataDescription.REQUIRED_MIN_INTERVAL;
            
        return fields;
    }

    //----------------------------------
    //  unitSize
    //----------------------------------

    /**
     *  @private
     *  Storage for the unitSize property.
     */
    private var _unitSize:Number = MILLISECONDS_IN_DAY;
    
    /**
     *  The width, in pixels, of a single data unit.
     *  The type of a data unit is determined
     *  by the value of the <code>dataUnits</code> property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function get unitSize():Number
    {
        return _unitSize;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------
    // alignLabelsToUnits
    //--------------------------------------
    
    /**
     *  @private
     *  Storage for alignLabelsToUnits property
     */
    private var _alignLabelsToUnits:Boolean = true;

    /**
     *  Determines the placement of labels along the axis.
     *  <p>When <code>false</code>, the chart always puts a label at the beginning of the axis. For example, 
     *  if your labels are every month and your first datapoint is July 14th, your first label 
     *  will be on July 14th. When <code>true</code>, Flex first calculates the label units, then labels 
     *  the first whole interval of those units. For example, if your first data point was 
     *  July 14th, and your label units was months (set explicitly or dynamically calculated), 
     *  the first label will be on August 1st.</p>
     *  
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get alignLabelsToUnits():Boolean
    {
        return _alignLabelsToUnits;
    }
    
    /**
     * @private
     */ 
    public function set alignLabelsToUnits(value:Boolean):void
    {
        if (value != _alignLabelsToUnits)
        {
            _alignLabelsToUnits = value;
            invalidateCache();
            dispatchEvent(new Event("mappingChange"));
            dispatchEvent(new Event("axisChange"));                 
        }
    }
    
    //----------------------------------
    //  dataInterval
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the dataInterval property.
     */
    private var _dataInterval:Number = 1;

    /**
     *  @private
     */
    private var _userDataInterval:Number;
    
    [Inspectable]

    /**
     *  Specifies the interval between data in your chart,
     *  specified in <code>dataUnits</code>.
     *  <p>If, for example, the <code>dataUnits</code> property
     *  is set to <code>"hours"</code>,
     *  and <code>dataInterval</code> property is set to 4,
     *  the chart assumes your data occurs every four hours.
     *  This affects how some series (such as ColumnSeries
     *  and CandlestickSeries) render their data.
     *  It also affects how labels are automatically chosen.</p>
     *  
     *  @see #dataUnits
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function set dataInterval(value:Number):void
    {
        if (isNaN(value))
            value = 1;
            
        _dataInterval = _userDataInterval = value;

        if (_userDataUnits != null)
            _unitSize = toMilli(_dataInterval, _userDataUnits);
        else
            _unitSize = MILLISECONDS_IN_DAY;
            
        invalidateCache();

        dispatchEvent(new Event("mappingChange"));
        dispatchEvent(new Event("axisChange"));
    }

    //----------------------------------
    //  dataUnits
    //----------------------------------

    /**
     *  @private
     *  Storage for the dataUnits property.
     */
    private var _dataUnits:String = null;

    /**
     *  @private
     */
    private var _userDataUnits:String = null;
    
    [Inspectable(category="General", enumeration="milliseconds,seconds,minutes,hours,days,weeks,months,years", defaultValue="days")]

    /**
     *  Specifies the units that you expect the data in your chart to represent.
     *  The value can be one of the following:
     *  <ul>
     *   <li><code>milliseconds</code></li>
     *   <li><code>seconds</code></li>
     *   <li><code>minutes</code></li>
     *   <li><code>hours</code></li>
     *   <li><code>days</code></li>
     *   <li><code>weeks</code></li>
     *   <li><code>months</code></li>
     *   <li><code>years</code></li>
     *  </ul>
     *
     *  <p>This value is used in two ways. 
     *  First, when choosing appropriate label units,
     *  a DateTimeAxis does not choose any unit smaller
     *  than the units represented by the data.
     *  If the value of the <code>dataUnits</code> property
     *  is <code>days</code>, the chart would not render labels
     *  for every hour, no matter what the minmium/maximum range is.</p>
     *
     *  <p>Secondly, the value of the <code>dataUnits</code> property
     *  is used by some series to affect their rendering.
     *  Specifically, most columnar series
     *  (such as ColumnSeries, BarSeries, CandlestickSeries, and HLOCSeries)
     *  use the value of the <code>dataUnits</code> property
     *  to determine how wide to render their columns.</p>
     *
     *  <p>If, for example, your ColumnChart control's horizontal axis
     *  had its <code>labelUnits</code> property set to <code>weeks</code>
     *  and its <code>dataUnits</code> property set to <code>days</code>,
     *  the ColumnChart renders each column at 1/7th the distance
     *  between labels.</p>
     *
     *  <p>When the <code>dataUnits</code> property is set to <code>null</code>, columnar series render
     *  their columns as days, but the DateTimeAxis chooses
     *  an appropriate unit when it generates the labels.</p>
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get dataUnits():String
    {
        return _dataUnits;
    }
    
    /**
     *  @private
     */
    public function set dataUnits(value:String):void
    {
        _dataUnits = _userDataUnits = value;
        
        if (_dataUnits != null)
            _unitSize = toMilli(_dataInterval, _dataUnits);
        else
            _unitSize = MILLISECONDS_IN_DAY;
            
        invalidateCache();

        dispatchEvent(new Event("mappingChange"));
        dispatchEvent(new Event("axisChange"));
    }

    //--------------------------------------
    // disabledDays
    //--------------------------------------
    
    /**
     *  @private
     *  Storage for the disabledDays property.
     */
    private var _disabledDays:Array /* of int */;

    [Inspectable(arrayType = "int", category = "General", defaultValue = null)]

    /**
     *  The days to disable in a week.
     *  All the dates in a month, for the specified day, are disabled.
     *  The elements of this array can have values from 0 (Sunday) to
     *  6 (Saturday).
     *  For example, a value of <code>[ 0, 6 ]</code>
     *  disables Sunday and Saturday.
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    
    public function get disabledDays():Array /* of int */
    {
        return _disabledDays;           
    }
    
    /**
     * @private
     */
    public function set disabledDays(value:Array /* of int */):void
    {
        _disabledDays = value;
        invalidateCache();
        
        dispatchEvent(new Event("mappingChange"));
        dispatchEvent(new Event("axisChange"));
    }
    
    
    //----------------------------------
    //  disabledRanges
    //----------------------------------

    /**
     *  @private
     *  Storage for the disabledRanges property.
     */
    private var _disabledRanges:Array /* of Object */;
    [Inspectable(arrayType = "Object", category = "General", defaultValue = null)]

    /**
     *  Disables single and multiple days.
     *
     *  <p>This property accepts an Array of objects as a parameter.
     *  Each object in this array is a Date object, specifying a
     *  single day to disable; or an object containing either or both
     *  of the <code>rangeStart</code> and <code>rangeEnd</code> properties,
     *  each of whose values is a Date object.
     *  The value of these properties describes the boundaries
     *  of the date range.
     *  If either is omitted, the range is considered
     *  unbounded in that direction.
     *  If you specify only <code>rangeStart</code>,
     *  all the dates after the specified date are disabled,
     *  including the <code>rangeStart</code> date.
     *  If you specify only <code>rangeEnd</code>,
     *  all the dates before the specified date are disabled,
     *  including the <code>rangeEnd</code> date.
     *  To disable a single day, use a single Date object specifying a date
     *  in the Array.</p>
     *
     *  <p>The following example, disables the following dates: January 11
     *  2006, the range January 23 - February 10 2006, and March 1 2006
     *  and all following dates.</p>
     *
     *  <p><code>disabledRanges="{[ new Date(2006,0,11), {rangeStart:
     *  new Date(2006,0,23), rangeEnd: new Date(2006,1,10)},
     *  {rangeStart: new Date(2006,2,1)} ]}"</code></p>
     *
     *  @default []
     *  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get disabledRanges():Array /* of Object */
    {
        return _disabledRanges;
    }

    /**
     *  @private
     */
    public function set disabledRanges(value:Array /* of Object */):void
    {
        _disabledRanges = value;
        invalidateCache();
        
        dispatchEvent(new Event("mappingChange"));
        dispatchEvent(new Event("axisChange"));
    }
    
    //----------------------------------
    //  displayLocalTime
    //----------------------------------

    /**
     *  @private
     *  Storage for the displayLocalTime property.
     */
    private var _displayLocalTime:Boolean = false;
    
    [Inspectable(category="General")]
    
    /** 
     *  When set to <code>true</code>,
     *  a DateTimeAxis considers all date values to be in the time zone
     *  of the client machine running the application. 
     *  If <code>false</code>, all values are in Universal Time
     *  (Greenwich Mean Time).
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get displayLocalTime():Boolean
    {
        return _displayLocalTime;
    }

    /**
     *  @private
     */
    public function set displayLocalTime(value:Boolean):void
    {
        _displayLocalTime = value;  
        invalidateCache();

        dispatchEvent(new Event("mappingChange"));
        dispatchEvent(new Event("axisChange"));

        updatePropertyAccessors();
    }

    //----------------------------------
    //  interval
    //----------------------------------

    /**
     *  @private
     *  Storage for the interval property.
     */
    private var _interval:Number;
    
    [Inspectable(category="General")]
    
    /**
     *  Specifies the number of <code>labelUnits</code>
     *  between label values along the axis. 
     *  Flex calculates the interval if this property is set to <code>null</code>.
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get interval():Number
    {
        return _interval;
    }
    
    /**
     *  @private
     */
    public function set interval(value:Number):void
    {
        _interval = Math.max(1, value);
        
        invalidateCache();

        dispatchEvent(new Event("mappingChange"));
        dispatchEvent(new Event("axisChange"));
    }

    //----------------------------------
    //  labelUnits
    //----------------------------------

    /**
     *  @private
     *  Storage for the labelUnits property.
     */
    private var _labelUnits:String;
    
    /**
     *  @private
     */
    private var _userLabelUnits:String = null;

    [Inspectable(category="General", enumeration="milliseconds,seconds,minutes,hours,days,weeks,months,years")]

    /**
     *  The units that the axis uses to generate labels.
     *  By default, a DateTimeAxis considers all valid units
     *  (<code>milliseconds</code>, <code>seconds</code>, <code>minutes</code>, <code>hours</code>, <code>days</code>, 
     *  <code>weeks</code>, <code>months</code>, or <code>years</code>).
     *  
     *  <p>If the <code>labelUnits</code> property is not set,
     *  the chart does not use any unit smaller than the value
     *  of the <code>dataUnits</code> property to render labels.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get labelUnits():String
    {
        return _labelUnits;
    }

    /**
     *  @private
     */
    public function set labelUnits(value:String):void
    {
        _userLabelUnits = _labelUnits = value;
        
        invalidateCache();
        dispatchEvent(new Event("mappingChange"));
        dispatchEvent(new Event("axisChange"));
    }
    
    //----------------------------------
    //  maximum
    //----------------------------------

    [Inspectable(category="General", defaultValue="null")]
    
    /**
     *  Specifies the maximum value for an axis label.
     *  If <code>null</code>, Flex determines the minimum value
     *  from the data in the chart.
     *  
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get maximum():Date
    {
        return new Date(computedMaximum);
    }
    
    /**
     *  @private
     */
    public function set maximum(value:Date):void
    {
        if (value != null)
            assignedMaximum = value.getTime();
        else
            assignedMaximum = NaN;
        
        invalidateCache();

        dispatchEvent(new Event("mappingChange"));
        dispatchEvent(new Event("axisChange"));
    }

    //----------------------------------
    //  minimum
    //----------------------------------

    [Inspectable(category="General", defaultValue="null")]
    
    /**
     *  Specifies the minimum value for an axis label.
     *  If <code>null</code>, Flex determines the minimum value
     *  from the data in the chart. 
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get minimum():Date
    {
        return new Date(computedMinimum);
    }
    
    /**
     *  @private
     */
    public function set minimum(value:Date):void
    {
        if (value != null)
            assignedMinimum = value.getTime();
        else
            assignedMinimum = NaN;
        invalidateCache();

        dispatchEvent(new Event("mappingChange"));
        dispatchEvent(new Event("axisChange"));
    }

    //----------------------------------
    //  minorTickInterval
    //----------------------------------

    /**
     *  @private
     */
    private var _minorTickInterval:Number;

    /**
     *  @private
     */
    private var _userMinorTickInterval:Number;

    [Inspectable(category="General")]
    
    /** 
     *  Specifies the number of <code>minorTickUnits</code>
     *  between minor tick marks along the axis.
     *  If this is set to <code>NaN</code>,
     *  the DateTimeAxis calculates it automatically.
     *  
     *  <p>Normally the <code>minorTickInterval</code> property
     *  is automatically set to 1.
     *  If, however, the <code>minorTickUnits</code> property
     *  is the same units as the <code>dataUnits</code> property
     *  (either set explicitly or implicitly calculated),
     *  then the <code>minorTickInterval</code> property
     *  is the maximum of 1, or <code>dataInterval</code>.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get minorTickInterval():Number
    {
        return _userMinorTickInterval;
    }
    
    /**
     *  @private
     */
    public function set minorTickInterval(value:Number):void
    {
        _userMinorTickInterval = value;

        invalidateCache();

        dispatchEvent(new Event("mappingChange"));
        dispatchEvent(new Event("axisChange"));
    }

    //----------------------------------
    //  minorTickUnits
    //----------------------------------

    /**
     *  @private
     *  Storage for the minorTickUnits property.
     */
    private var _minorTickUnits:String;
    
    /**
     *  @private
     */
    private var _userMinorTickUnits:String = null;  

    [Inspectable(category="General", enumeration="milliseconds,seconds,minutes,hours,days,weeks,months,years")]

    /**
     *  The units that the Axis considers when generating minor tick marks.
     *  By default, a DateTimeAxis considers all valid units 
     *  (<code>milliseconds</code>, <code>seconds</code>, <code>minutes</code>, <code>hours</code>, <code>days</code>, 
     *  <code>weeks</code>, <code>months</code>, or <code>years</code>).
     *  
     *  <p>If this property is not set, the chart determines the value
     *  of the <code>minorTickUnits</code> property.
     *  If the label interval is greater than 1,
     *  the <code>minorTickUnits</code> property is set to the value
     *  of the <code>labelUnits</code> property,
     *  and the <code>minorTickInterval</code> property is set to 1.
     *  If the label interval is 1, the <code>minorTickUnits</code> property is
     *  set to the next smaller unit from the <code>labelUnits</code> property.
     *  If set, the <code>minorTickUnits</code> property can never be smaller
     *  than the value of the <code>dataUnits</code> property.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get minorTickUnits():String
    {
        return _minorTickUnits;
    }
    
    /**
     *  @private
     */
    public function set minorTickUnits(value:String):void
    {
        _minorTickUnits = _userMinorTickUnits = value;

        invalidateCache();

        dispatchEvent(new Event("mappingChange"));
        dispatchEvent(new Event("axisChange"));
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: Numeric Axis
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @copy mx.charts.chartClasses.IAxis#transformCache()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function transformCache(cache:Array /* of ChartItem */, field:String,
                                   convertedField:String):void
    {
        update();
        var alen:Number = computedMaximum - computedMinimum - dateRangeUtilities.calculateDisabledRange(computedMinimum, computedMaximum);;
        var n:int = cache.length;
        var i:int;
        
        if (disabledRanges || disabledDays)
        {   
            var diff:Number = 0;
            for (i = 0; i < n; i++)
            {           
                diff = dateRangeUtilities.calculateDisabledRange(computedMinimum,cache[i][field]);
                if(direction == "inverted")
                    cache[i][convertedField] = 1 - (cache[i][field] - diff - computedMinimum) / alen;
                else
                    cache[i][convertedField] = (cache[i][field] - diff - computedMinimum) / alen;                                                  
            }
        }
        else
        {
            var r:Number = computedMaximum - computedMinimum; 

            for (i = 0; i < n; i++)
            {
                if(direction == "inverted")
                    cache[i][convertedField] = 1 - (cache[i][field] - computedMinimum) / r;
                else
                    cache[i][convertedField] = (cache[i][field] - computedMinimum) / r;
            }
        }
        
    }

        
    /**
     *  @private
     */
    override protected function adjustMinMax(minValue:Number,
                                             maxValue:Number):void
    {
        var interval:Number = _interval;
        
        var adjustMin:Boolean = autoAdjust && isNaN(assignedMinimum);
        var adjustMax:Boolean = autoAdjust && isNaN(assignedMaximum);
        
        var delta:Number = minValue - maxValue;

        var validUnitFound:Boolean = false;
        var min:Number;
        var max:Number;

        var labelInterval:Number = isNaN(_interval) ?  1 : _interval;

        var units:String;
        var i:int;
        var n:int;
        
        // First step: Calculate our dataunits.
        // If the user has explicitly assigned one, then we just
        // go with  that and assume values are set correctly.
        // If a user specified data units isn't set, then we'll try and
        // dynamically determine one based on the spacing of the data.
        // This needs to be calculated before the label units are calculated.
        // As a rule, we don't auto-choose label units smaller
        // than the data units.

        if (_userDataUnits == null)
        {
            // We're going to start with the largest possible units
            // and work down until we find something that works.
            // Normally, the largest is years.
            // But if the user has specified a label unit,
            // we don't want our data until to be larger than that.
            // For example, if they specify months as the labels,
            // it would weird to have columns be the entire width of a year.
            units  = "years";

            // If we're autogenerating data units,
            // we'll assume the interval is 1.
            _dataInterval = 1;
            
            if (_userLabelUnits != null && _userLabelUnits != "")
                units = _userLabelUnits;

            var descriptions:Array /* of DataDescription */ = dataDescriptions;
            var minInterval:Number = Infinity;
            n = descriptions.length;
            // First, find the smallest interval.
            for (i = 0; i < n; i++)
            {
                interval = descriptions[i].minInterval;
                if (isNaN(interval))
                    continue;
                minInterval = Math.min(interval, minInterval);
            }
            
            // If there's no smallest interval, we need to choose
            // some sort of default value. We'll assume days.
            if (minInterval == Infinity || minInterval == 0)
            {
                _unitSize = MILLISECONDS_IN_DAY;
                _dataUnits = "days";
            }
            else
            {
                // Start with years, and see if that will work.
                // 'Work' means that the data size is smaller
                // than the smallest interval represented in the data.
                // If that doesn't work, keep reducing the data unit size
                // until we find one that does.
                while (units != null)
                {
                    _unitSize = toMilli(1,units);
                    if (_unitSize <= minInterval)
                        break;
                    units = UNIT_PROGRESSION[units];
                }
                
                // If we ran out of units, go with day.
                if (units == null)
                    _unitSize = MILLISECONDS_IN_DAY;
                else
                    _dataUnits = units;
            }
        }
        else
        {
            _dataUnits = _userDataUnits;
            _dataInterval = isNaN(_userDataInterval) ? 1 : _userDataInterval;
        }

        // Now we're going to start looking for the right units
        // to mark off labels for.
        // Again, we'll start with the largest possible values, and work
        // our way down until we find units that generate more than 3 labels.
        // Unless, of course, the user has specified the label units,
        // in which case we'll start with what they asked for.      
        units = "years";
        if (_userLabelUnits != null && _userLabelUnits != "")
            units = _userLabelUnits;
        var lastValidUnits:String = units;

        var minD:Date = new Date(minValue);
        var maxD:Date = new Date(maxValue);
        var minMilli:Number = minValue;
        var maxMilli:Number = maxValue;

        while (units != null)
        {
            lastValidUnits = units;
            // We never want our labels to occur more often than our data does.
            // So if our label units and our data units are the  same,
            // let's make sure that our label interval isn't more often
            // than our data interval.
            if (units == _dataUnits)
                labelInterval = Math.max(labelInterval, _dataInterval);
            
            // Now check and see if we'll have enough labels
            // with the current units.

            if (adjustMin)
            {
                minD.setTime(minValue);
                roundDateDown(minD,units);
                minMilli = minD.getTime();
            }

            if (adjustMax)
            {
                maxD.setTime(maxValue);
                roundDateUp(maxD,units);
                maxMilli = maxD.getTime();
            }

                                                
            switch (units)
            {
                case "milliseconds":
                {
                    minMilli = minValue;
                    maxMilli = maxValue;
                    break;
                }

                case "seconds":
                case "hours":
                case "days":
                case "minutes":
                case "years":                               
                {
                    min = fromMilli(minD.getTime(), units);
                    max = fromMilli(maxD.getTime(), units);

                    if (max - min >= MINIMUM_LABEL_COUNT * labelInterval)
                        validUnitFound=true;

                    break;
                }

                case "weeks":
                {
                    if (fromMilli(maxMilli - minMilli, "weeks") >=
                        MINIMUM_LABEL_COUNT * labelInterval)
                    {
                        validUnitFound = true;
                    }
                    
                    break;
                }

                case "months":
                {
                    min = minD[monthP] + minD[fullYearP] * 12;
                    max = maxD[monthP] + maxD[fullYearP] * 12;

                    if (max - min >= MINIMUM_LABEL_COUNT * labelInterval)
                        validUnitFound=true;

                    break;
                }

            }

            // Stop when we've found a unit that gives us enough labels.
            if (validUnitFound)
                break;

            // Also stop either if the user has explicitly requested
            // these label units, or if we've run out of label units.
            if (units == _userLabelUnits || UNIT_PROGRESSION[units] == null)
                break;

            if (units == _dataUnits)
            {
                // If the current label units/interval is the same as our
                // data units/interval, we'll stop... we don't want
                // wide columns and narrow labels.
                if (labelInterval <= _dataInterval)
                    break;
                else
                {
                    // But if our data units are our label units
                    // and our data interval is smaller than our data interval,
                    // we can always drop down and try again.
                    labelInterval = _dataInterval;
                }
            }
            else
            {
                // Drop down a level of specificity and try again.
                units = UNIT_PROGRESSION[units];
            }
        }
            
        _labelUnits = lastValidUnits;

        if (_userMinorTickUnits != null && _userMinorTickUnits != "")
        {
            _minorTickInterval = isNaN(_userMinorTickInterval) ?
                                 1 :
                                 _userMinorTickInterval;
            _minorTickUnits = _userMinorTickUnits;          
        }
        else if (labelInterval == 1)
        {
            _minorTickInterval = 1;
            _minorTickUnits = _labelUnits;
        }
        else
        {
            _minorTickUnits = _labelUnits;
            for (i = 2; i <= labelInterval; i++)
            {
                if ((labelInterval % i) == 0)
                {
                    _minorTickInterval = labelInterval / i;
                    break;
                }
            }
        }

        invalidateCache();
        
        if (adjustMin)
            computedMinimum = minMilli;
        if (adjustMax)
            computedMaximum = maxMilli;

        computedInterval = labelInterval;
    }
    
    /**
     *  @private
     */
    override protected function guardMinMax(min:Number, max:Number):Array /* of int */
    {
        if (isNaN(min) || !isFinite(min))
            return [ 0, 100 ];

        else if (isNaN(max) || !isFinite(max))
            return [ min, min + 1 ];

        else if (min == max)
            return [ min, min + 1];

        return null;
    }

    /**
     *  @copy mx.charts.chartClasses.IAxis#filterCache()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function filterCache(cache:Array /* of ChartItem */, field:String, filteredField:String):void
    {
        super.filterCache(cache,field,filteredField);
        var i:int;
        var n:int = cache.length;
        
        if (disabledRanges || disabledDays)
        {
            for (i = 0; i < n; i++)
            {               
                cache[i][filteredField] = dateRangeUtilities.isDisabled(cache[i][field]) ?  NaN : cache[i][field];
            }
        }
    }

    /**
     *  @private
     */
    override public function mapCache(cache:Array /* of ChartItem */, field:String,
                                      convertedField:String,
                                      indexValues:Boolean = false):void
    {        
        var n:int = cache.length;
        var i:int;
        var v:Object;
        var tmpValue:Number;
        var parseFunction:Function = this.parseFunction;
        
        if (parseFunction != null)
        {
            for (i = 0; i < n; i++)
            {
                v = cache[i];               
                var d:Date = parseFunction(v[field]);
                if (d != null)
                    v[convertedField] = d.getTime();
            }       
        }
        else
        {
            for (i = 0; i < n && cache[i][field] == null; i++)
            {
            }
            if (i == n)
                return;
                
            if (cache[i][field] is String)
            {
                for (; i < n; i++)
                {
                    v = cache[i];
                    if (!v[field])
                        continue;
                    v[convertedField] = Date.parse(v[field]);
                }
            }
            else if (cache[i][field] is XML ||
                     cache[i][field] is XMLList)
            {
                v = cache[i];
                if (isNaN(Number(v[field].toString())))
                {
                    for (; i < n; i++)
                    {
                        v = cache[i];
                        if (!v[field])
                            continue;
                        v[convertedField] = Date.parse(v[field].toString());
                    }
                }
                else
                {
                    for (; i < n; i++)
                    {
                        v = cache[i];
                        if (!v[field])
                            continue;
                        v[convertedField] = Number(v[field].toString());
                    }
                }
            }
            else if (cache[i][field] is Date)
            {
                for (; i < n; i++)
                {
                    v = cache[i];
                    if (!v[field])
                        continue;
                    v[convertedField] = v[field].getTime();
                }
            }
            else
            {
                for (; i < n; i++)
                {
                    v = cache[i];
                    if (!v[field])
                        continue;
                    v[convertedField] = v[field];
                }
            }
        }
    }

    /**
     *  @private
     */
    override public function formatForScreen(v:Object):String   
    {
        var d:Date = tmpDate;

        if (parseFunction != null)
        {
            d = parseFunction(v);
        }
        else
        {
            if (v is String)
                d.setTime(Date.parse(v));               
            else if (v is Date)
                d = (v as Date);
            else
                d.setTime(Number(v));
        }

        var f:Function  = chooseLabelFunction()
        return f(d, null, this);
    }
    
    /**
     *  @private
     */
    override protected function buildLabelCache():Boolean
    {       
        var j:int;
        dateRangeUtilities.createDisabledRangeSet(disabledDays, disabledRanges, computedMinimum, computedMaximum);
        var lfunc:Function = chooseLabelFunction();

        if (labelCache)
            return false;

        var d:Date = new Date();
        labelCache = [];
        
        var r:Number = computedMaximum - computedMinimum - dateRangeUtilities.calculateDisabledRange(computedMinimum, computedMaximum);;
        var milliInterval:Number = toMilli(computedInterval, _labelUnits);          
        var labelBase:Number = labelMinimum;
        var labelTop:Number = labelMaximum + 0.000001
        var previousValue:Date = null;
        var labelDate:Date;
        var dTime:Number;
        var diff:Number = 0;
        var tzo:Number = 0;
        var firstLabelAdded:Boolean = false;

        labelDate = new Date(labelBase);
        if (_alignLabelsToUnits)
            roundDateUp(labelDate,_labelUnits);
        labelBase = labelDate.getTime();
            
        switch (_labelUnits)
        {
            case "months":
            {
                // Start with the first label.
                // While....
                // Add N to the month.
                // Check the month; if it's not base + N, 
                // then the new month doesn't have enough days...
                // So roll back to the last day of month base + N
                // (most likely, by setting day back to 0).
                // Base each month off the original date, so an adjustment
                // for short date doesn't affect the following months

                var nextMonth:Number = labelDate[monthP];
                
                while (labelDate.getTime() <= labelTop)
                {
                    dTime = labelDate.getTime();
                    if (disabledDays || disabledRanges)
                    {
                        if (previousValue != null)
                            diff =  dateRangeUtilities.getDisabledRange(previousValue.getTime() + 1, dTime, _labelUnits);
                        else
                            diff = dateRangeUtilities.getDisabledRange(computedMinimum, dTime, _labelUnits);
                            
                        if (!(dateRangeUtilities.isDisabled(dTime)))
                        {
                            if(direction == "inverted")
                                labelCache.push(new AxisLabel(
                                    1 - (dTime - computedMinimum - diff) / r, new Date(dTime),
                                    lfunc(labelDate, previousValue, this)));
                            else
                                labelCache.push(new AxisLabel(
                                    (dTime - computedMinimum - diff) / r, new Date(dTime),
                                    lfunc(labelDate, previousValue, this)));            
                        }
                    }
                    else
                        if(direction == "inverted")
                            labelCache.push(new AxisLabel(
                                1 - (dTime - computedMinimum) / r, new Date(dTime),
                                lfunc(labelDate, previousValue, this)));
                        else
                            labelCache.push(new AxisLabel(
                                (dTime - computedMinimum) / r, new Date(dTime),
                                lfunc(labelDate, previousValue, this)));
                    
                    if (previousValue == null)
                        previousValue = new Date(dTime);
                    else
                        previousValue.setTime(dTime);

                    nextMonth += computedInterval;
                    
                    // Init labelDate to N months past labelBase.
                    labelDate.setTime(labelBase);

                    labelDate[monthP] = nextMonth;
                    if (labelDate[monthP] != (nextMonth % 12))
                    {
                        // If the month isn't what we expected it to be,
                        // it must have wrapped.
                        // Set the date to 0, which will roll it back
                        // to the last date of the previous month,
                        // which is the one we want.
                        labelDate[dateP] = 0;
                    }
                }
                break;
            }

            case "years":
            {
                // Start with the first label.
                // While....
                // Add N to the month
                // Check the month; if it's not base + N,
                // then the new month doesn't have enough days...
                // so roll back to the last day of month base + N
                // (most likely, by setting day back to 0)
                // Base each month off the original date, so an adjustment
                // for short date doesn't affect the following months.

                var nextYear:Number = labelDate[fullYearP];

                while (labelDate.getTime() <= labelTop)
                {
                    dTime = labelDate.getTime();
                    if (disabledDays|| disabledRanges)
                    {
                        if (previousValue != null)
                            diff =  dateRangeUtilities.getDisabledRange(previousValue.getTime() + 1, dTime, _labelUnits);
                        else
                            diff =  dateRangeUtilities.getDisabledRange(computedMinimum, dTime, _labelUnits);
                            
                        if (!(dateRangeUtilities.isDisabled(dTime)))
                        {
                            if(direction == "inverted")
                                labelCache.push(new AxisLabel(
                                        1 - (dTime - computedMinimum - diff) / r, new Date(dTime),
                                        lfunc(labelDate, previousValue, this)));
                            else
                                labelCache.push(new AxisLabel(
                                        (dTime - computedMinimum - diff) / r, new Date(dTime),
                                        lfunc(labelDate, previousValue, this)));
                        } 
                    }
                    else
                    {
                        if(direction == "inverted")
                            labelCache.push(new AxisLabel(
                                1 - (dTime - computedMinimum) / r, new Date(dTime),
                                lfunc(labelDate, previousValue, this)));
                        else
                            labelCache.push(new AxisLabel(
                                (dTime - computedMinimum) / r, new Date(dTime),
                                lfunc(labelDate, previousValue, this)));             
                    }
                    if (previousValue == null)
                        previousValue = new Date(dTime);
                    else
                        previousValue.setTime(dTime);

                    nextYear += computedInterval;
                    
                    // Init labelDate to N months past labelBase.
                    labelDate.setTime(labelBase);

                    labelDate[fullYearP] = nextYear;
                    if (labelDate[fullYearP] != nextYear)
                    {
                        // If the month isn't what we expected it to be,
                        // it must have wrapped.
                        // Set the date to 0, which will roll it back
                        // to the last date of the previous month,
                        // which is the one we want.
                        labelDate[dateP] = 0;
                    }
                }

                break;
            }

           default:
            {
                for (var i:Number = labelBase; i <= labelTop;)
                {                   
                    d = new Date(i);
                    if (disabledDays|| disabledRanges)
                    {                       
                        if (previousValue != null)
                            diff =  dateRangeUtilities.getDisabledRange(previousValue.getTime() + 1, i, _labelUnits);                        
                        else
                            diff =  dateRangeUtilities.getDisabledRange(computedMinimum, i, _labelUnits);
                          
                        if (!(dateRangeUtilities.isDisabled(i)))
                        { 
                             if(direction == "inverted")
                                labelCache.push(new AxisLabel(1 - (i - computedMinimum - diff)/r , d, lfunc(d, previousValue, this)));
                             else
                                labelCache.push(new AxisLabel((i - computedMinimum - diff)/r , d, lfunc(d, previousValue, this)));
                            if (!firstLabelAdded)
                                firstLabelAdded = true;
                        }
                        previousValue = d;
                       if (!firstLabelAdded)
                            i += MILLISECONDS_IN_DAY;
                        else
                        {
                            var tmp:Date = new Date(i);
                            if (_labelUnits == "weeks")
                            {
                                tmp.dateUTC = tmp.dateUTC + 7 * computedInterval;
                                i = tmp.time;
                            }
                            else if (_labelUnits == "hours")
                            {
                                tmp.hoursUTC = tmp.hoursUTC + computedInterval;
                                i = tmp.time;
                            }   
                            else if (_labelUnits == "minutes")
                            {
                                tmp.minutesUTC = tmp.minutesUTC + computedInterval;
                                i = tmp.time;
                            }
                            else if (_labelUnits == "seconds")
                            {
                                tmp.secondsUTC = tmp.secondsUTC + computedInterval;
                                i = tmp.time;
                            }
                            else if (_labelUnits == "milliseconds")
                            {
                                tmp.millisecondsUTC = tmp.millisecondsUTC + computedInterval;
                                i = tmp.time;
                            }
                            else
                            {
                                tmp.dateUTC = tmp.dateUTC + computedInterval;
                                i = tmp.time;
                            }
                        }
                    }
                    else
                    {
                        if(direction == "inverted")
                            labelCache.push(new AxisLabel(1 - (i - computedMinimum)/r , d, lfunc(d, previousValue, this)));
                        else
                            labelCache.push(new AxisLabel((i - computedMinimum)/r , d, lfunc(d, previousValue, this)));
                        previousValue = d;
                        tmp = new Date(i);
                        if (_labelUnits == "weeks")
                        {
                            tmp.dateUTC = tmp.dateUTC + 7 * computedInterval;
                            i = tmp.time;
                        }
                        else if (_labelUnits == "hours")
                            {
                                tmp.hoursUTC = tmp.hoursUTC + computedInterval;
                                i = tmp.time;
                            }   
                            else if (_labelUnits == "minutes")
                            {
                                tmp.minutesUTC = tmp.minutesUTC + computedInterval;
                                i = tmp.time;
                            }
                            else if (_labelUnits == "seconds")
                            {
                                tmp.secondsUTC = tmp.secondsUTC + computedInterval;
                                i = tmp.time;
                            }
                            else if (_labelUnits == "milliseconds")
                            {
                                tmp.millisecondsUTC = tmp.millisecondsUTC + computedInterval;
                                i = tmp.time;
                            }
                            else
                            {
                                tmp.dateUTC = tmp.dateUTC + computedInterval;
                                i = tmp.time;
                            }
                    }                     
                }

                break;
            }
        }

        return true;
    }

    /** 
     *  Invoked when an AxisRenderer is unable to cleanly render
     *  the labels without overlap, and would like the Axis object
     *  to reduce the set of labels.
     *  The method is passed the two labels that are overlapping.
     *
     *  @param intervalStart The start of the interval where labels overlap.
     *
     *  @param intervalEnd The end of the interval where labels overlap.
     *
     *  @return A new label set that resolves the overlap by reducing
     *  the number of labels.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function reduceLabels(intervalStart:AxisLabel,
                                          intervalEnd:AxisLabel):AxisLabelSet
    {
        // We need to determine how many labels to skip. 
        var intervalMultiplier:int = 0;
        
        switch (_labelUnits)
        {
            case "months":
            {
                intervalMultiplier= Math.floor(
                    ((intervalEnd.value[fullYearP] * 12 +
                      intervalEnd.value[monthP]) -
                     (intervalStart.value[fullYearP] * 12 +
                      intervalStart.value[monthP])) /
                    computedInterval) + 1;
                break;
            }

            case "years":
            {
                intervalMultiplier = Math.floor(
                    (intervalEnd.value[fullYearP] -
                     intervalStart.value[fullYearP]) /
                    computedInterval) + 1;
                break;
            }

            default:
            {
                var milliInterval:Number =
                    toMilli(computedInterval, _labelUnits);         
                intervalMultiplier = Math.floor(
                    (intervalEnd.value.getTime() -
                     intervalStart.value.getTime()) /
                    milliInterval) + 1;
                break;
            }
        }

        var labels:Array /* of AxisLabel */ = [];
        var newTicks:Array /* of Number */ = [];
        var newMinorTicks:Array /* of Number */ = [];
        
        var i:int;
        var n:int = labelCache.length;
        for (i = 0; i < n; i += intervalMultiplier)
        {
            labels.push(labelCache[i]);
            newTicks.push(labelCache[i].position);
        }       
        
        if (computedInterval == _minorTickInterval && intervalMultiplier > 1)
        
        for (i = intervalMultiplier - 1; i >= 1; i--)
        {
            if ((intervalMultiplier % i) == 0)
            {
                intervalMultiplier = i;
                break;
            }
        }
        
        n = minorTickCache.length;
        for (i = 0; i < n; i += intervalMultiplier)
        {
            newMinorTicks.push(minorTickCache[i]);
        }       
        
        var labelSet:AxisLabelSet = new AxisLabelSet();
        labelSet.labels = labels;
        labelSet.minorTicks = newMinorTicks;
        labelSet.ticks = newTicks;
        labelSet.accurate = true;

        return labelSet;
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function buildMinorTickCache():Array /* of Number */
    {
        var cache:Array /* of Number */ = [];
        var d:Date = new Date();
        var r:Number = computedMaximum - computedMinimum - dateRangeUtilities.calculateDisabledRange(computedMinimum, computedMaximum);;
        var milliInterval:Number = toMilli(_minorTickInterval,
                                           _minorTickUnits);            
        var labelBase:Number = labelMinimum;
        var labelTop:Number = labelMaximum + 0.000001
        var previousValue:Date = null;
        var labelDate:Date;
        var dTime:Number;
        var tzo:Number = 0;

        var disabled:Boolean = false;
        var diff:Number = 0;
        var j:int;
        
        labelDate = new Date(labelBase);
        if (_alignLabelsToUnits)
            roundDateUp(labelDate,_minorTickUnits);
        labelBase = labelDate.getTime();

        switch (_minorTickUnits)
        {
            case "months":
            {
                // Start with the first label
                // while....
                // Add N to the month
                // Check the month; if it's not base + N,
                // then the new month doesn't have enough days...
                // so roll back to the last day of month base + N
                // (most likely, by setting day back to 0).
                // Base each month off the original date,
                // so an adjustment for short date
                // doesn't affect the following months.

                var nextMonth:Number = labelDate[monthP];

                while (labelDate.getTime() <= labelTop)
                {
                    dTime = labelDate.getTime();
                    if (disabledDays || disabledRanges)
                    {
                        if (previousValue != null)
                            diff =  dateRangeUtilities.getDisabledRange(previousValue.getTime() + 1,dTime, _minorTickUnits);
                        else
                            diff = dateRangeUtilities.getDisabledRange(computedMinimum, dTime, _minorTickUnits);
                            
                        if (!(dateRangeUtilities.isDisabled(dTime)))
                        {
                            cache.push((dTime - computedMinimum - diff) / r);
                        }
                    }
                    else
                        cache.push((dTime - computedMinimum) / r);
                    if (previousValue == null)
                        previousValue = new Date(dTime);
                    else
                        previousValue.setTime(dTime);

                    nextMonth += _minorTickInterval;
                    // init labelDate to N months past labelBase
                    labelDate.setTime(labelBase);

                    labelDate[monthP] = nextMonth;
                    if (labelDate[monthP] != (nextMonth % 12))
                    {
                        // If the month isn't what we expected it to be,
                        // it must have wrapped.
                        // Set the date to 0, which will roll it back
                        // to the last date of the previous month
                        // (which is the one we want).
                        labelDate[dateP] = 0;

                    }
                }
                break;
            }

            case "years":
            {
                // Start with the first label
                // while....
                // Add N to the month.
                // Check the month; if it's not base + N,
                // then the new month doesn't have enough days...
                // so roll back to the last day of month base + N
                // (most likely, by setting day back to 0).
                // Base each month off the original date,
                // so an adjustment for short date
                // doesn't affect the following months

                var nextYear:Number = labelDate[fullYearP];

                while (labelDate.getTime() <= labelTop)
                {
                    dTime = labelDate.getTime();
                    if (disabledDays || disabledRanges)
                    {
                        if (previousValue != null)
                            diff =  dateRangeUtilities.getDisabledRange(previousValue.getTime() + 1, dTime, _minorTickUnits);
                        else
                            diff = dateRangeUtilities.getDisabledRange(computedMinimum, dTime, _minorTickUnits);
                            
                        if (!(dateRangeUtilities.isDisabled(dTime)))
                        {
                            cache.push((dTime - computedMinimum - diff)/r);
                        }
                    }
                    else
                        cache.push((dTime - computedMinimum)/r);
                    if (previousValue == null)
                        previousValue = new Date(dTime);
                    else
                        previousValue.setTime(dTime);

                    nextYear += _minorTickInterval;
                    // init labelDate to N months past labelBase
                    labelDate.setTime(labelBase);

                    labelDate[fullYearP] = nextYear;
                    if (labelDate[fullYearP] != nextYear)
                    {
                        // If the month isn't what we expected it to be,
                        // it must have wrapped.
                        // Set the date to 0, which will roll it back
                        // to the last date of the previous month
                        // (which is the one we want).
                        labelDate[dateP] = 0;

                    }
                }
                break;
            }

            default:
            {
                for (var i:Number = labelBase;
                     i <= labelTop;)
                {
                    d = new Date(i);
                    if (disabledDays|| disabledRanges)
                    {
                        if (previousValue != null)
                            diff =  dateRangeUtilities.getDisabledRange(previousValue.getTime() + 1, i, _minorTickUnits);
                        else
                            diff =  dateRangeUtilities.getDisabledRange(computedMinimum, i, _minorTickUnits);
                            
                        if (!(dateRangeUtilities.isDisabled(i)))
                        {
                            cache.push((i - computedMinimum - diff)/r);
                        }
                    }
                    else
                        cache.push((i - computedMinimum)/r);
                    previousValue = d;
                    var tmp:Date = new Date(i);
                    if (_minorTickUnits == "weeks")
                    {
                        tmp.dateUTC = tmp.dateUTC + 7 * _minorTickInterval;
                        i = tmp.time;
                    }
                    else if (_minorTickUnits == "hours")
                    {
                        tmp.hoursUTC = tmp.hoursUTC + _minorTickInterval;
                        i = tmp.time;
                    }   
                    else if (_minorTickUnits == "minutes")
                    {
                        tmp.minutesUTC = tmp.minutesUTC + _minorTickInterval;
                        i = tmp.time;
                    }
                    else if (_minorTickUnits == "seconds")
                    {
                        tmp.secondsUTC = tmp.secondsUTC + _minorTickInterval;
                        i = tmp.time;
                    }
                    else if (_minorTickUnits == "milliseconds")
                    {
                        tmp.millisecondsUTC = tmp.millisecondsUTC + _minorTickInterval;
                        i = tmp.time;
                    }
                    else
                    {
                        tmp.dateUTC = tmp.dateUTC + _minorTickInterval;
                        i = tmp.time;
                    } 
                }
                break;
            }
        }

        return cache;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    private function roundDateUp(d:Date,units:String):void
    {
        switch (units)
        {
            case "seconds":
                if (d[millisecondsP] > 0)
                {
                    d[secondsP] = d[secondsP] + 1;
                    d[millisecondsP] = 0;
                }
                break;
            case "minutes":
                if (d[secondsP] > 0 || d[millisecondsP] > 0)
                {
                    d[minutesP] = d[minutesP] + 1;
                    d[secondsP] = 0;
                    d[millisecondsP] = 0;
                }
                break;
            case "hours":
                if (d[minutesP] > 0 ||
                    d[secondsP] > 0 ||
                    d[millisecondsP] > 0)
                {
                    d[hoursP] = d[hoursP] + 1;
                    d[minutesP] = 0;
                    d[secondsP] = 0;
                    d[millisecondsP] = 0;
                }
                break;
            case "days":
                if (d[hoursP] > 0 ||
                    d[minutesP] > 0 ||
                    d[secondsP] > 0 ||
                    d[millisecondsP] > 0)
                {
                    d[hoursP] = 0;
                    d[minutesP] = 0;
                    d[secondsP] = 0;
                    d[millisecondsP] = 0;
                    d[dateP] = d[dateP] + 1;                                        
                }
                break;
                d[hoursP] = 0;
                d[minutesP] = 0;
                d[secondsP] = 0;
                d[millisecondsP] = 0;
                break;          
            case "weeks":
                d[hoursP] = 0;
                d[minutesP] = 0;
                d[secondsP] = 0;
                d[millisecondsP] = 0;
                if (d[dayP] != 0)
                    d[dateP] = d[dateP] + (7 - d[dayP]);
                break;          
            case "months":
                if (d[dateP] > 1 ||
                    d[hoursP] > 0 ||
                    d[minutesP] > 0 ||
                    d[secondsP] > 0 ||
                    d[millisecondsP] > 0)
                {
                    d[hoursP] = 0;
                    d[minutesP] = 0;
                    d[secondsP] = 0;
                    d[millisecondsP] = 0;
                    d[dateP] = 1;
                    d[monthP] = d[monthP] + 1;
                }
                break;
            case "years":
                if (d[monthP] > 0 ||
                    d[dateP] > 1 ||
                    d[hoursP] > 0 ||
                    d[minutesP] > 0 ||
                    d[secondsP] > 0 ||
                    d[millisecondsP] > 0)
                {
                    d[hoursP] = 0;
                    d[minutesP] = 0;
                    d[secondsP] = 0;
                    d[millisecondsP] = 0;
                    d[dateP] = 1;
                    d[monthP] = 0;
                    d[fullYearP] = d[fullYearP] + 1;
                }
                break;
        }                                                                           
    }
    private function roundDateDown(d:Date,units:String):void
    {
        switch (units)
        {
            case "seconds":
                d[secondsP] = 0;
                break;
            case "minutes":
                d[secondsP] = 0;
                d[millisecondsP] = 0;
                break;
            case "hours":
                d[minutesP] = 0;
                d[secondsP] = 0;
                d[millisecondsP] = 0;
                break;
            case "days":
                d[hoursP] = 0;
                d[minutesP] = 0;
                d[secondsP] = 0;
                d[millisecondsP] = 0;
                break;
            case "weeks":
                d[hoursP] = 0;
                d[minutesP] = 0;
                d[secondsP] = 0;
                d[millisecondsP] = 0;
                if (d[dayP] != 0)
                    d[dateP] = d[dateP] - d[dayP];
                break;
            case "months":
                d[hoursP] = 0;
                d[minutesP] = 0;
                d[secondsP] = 0;
                d[millisecondsP] = 0;
                d[dateP] = 1;
                break;
            case "years":
                d[hoursP] = 0;
                d[minutesP] = 0;
                d[secondsP] = 0;
                d[millisecondsP] = 0;
                d[dateP] = 1;
                d[monthP] = 0;
                break;  
        }
    }
    
    
    /** 
     *  The default formatting function used
     *  when the axis renders with year-based <code>labelUnits</code>.  
     *  If you write a custom DateTimeAxis class, you can override this method 
     *  to provide alternate default formatting.
     *  
     *  <p>You do not call this method directly. Instead, Flex calls this method before it
     *  renders the label to get the appropriate String to display.</p>
     *  
     *  @param d The Date object that contains the unit to format.
     *  
     *  @param previousValue The Date object that contains the data point that occurs 
     *  prior to the current data point.
     *  
     *  @param axis The DateTimeAxis on which the label is rendered.
     *  
     *  @return The formatted label.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function formatYears(d:Date, previousValue:Date,
                                   axis:DateTimeAxis):String
    {
        var fy:Number = d[fullYearP];
        return fy.toString();
    }

    /**
     *  The default formatting function used
     *  when the axis renders with month-based <code>labelUnits</code>.  
     *  If you write a custom DateTimeAxis class, you can override this method to 
     *  provide alternate default formatting.
     *  
     *  <p>You do not call this method directly. Instead, Flex calls this method before it
     *  renders the label to get the appropriate String to display.</p>
     *  
     *  @param d The Date object that contains the unit to format.
     *  
     *  @param previousValue The Date object that contains the data point that occurs 
     *  prior to the current data point.
     *  
     *  @param axis The DateTimeAxis on which the label is rendered.
     *  
     *  @return The formatted label.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function formatMonths(d:Date, previousValue:Date,
                                    axis:DateTimeAxis):String
    {
        var fy:Number = d[fullYearP];
        return (d[monthP] + 1) + "/" +
               ((fy % 100) < 10 ? "0" + fy % 100 : fy % 100);
    }

    /**
     *  The default formatting function used
     *  when the axis renders with day-based <code>labelUnits</code>.  
     *  If you write a custom DateTimeAxis class, you can override this method to provide 
     *  alternate default formatting.
     *  
     *  <p>You do not call this method directly. Instead, Flex calls this method before it
     *  renders the label to get the appropriate String to display.</p>
     *  
     *  @param d The Date object that contains the unit to format.
     *  
     *  @param previousValue The Date object that contains the data point that occurs 
     *  prior to the current data point.
     *  
     *  @param axis The DateTimeAxis on which the label is rendered.
     *  
     *  @return The formatted label.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function formatDays(d:Date, previousValue:Date,
                                  axis:DateTimeAxis):String
    {
        var fy:Number = d[fullYearP];
        return (d[monthP] + 1) + "/" +
               d[dateP] + "/" +
               ((fy % 100) < 10 ? "0" + fy % 100 : fy % 100);
    }

    /**
     *  The default formatting function used
     *  when the axis renders with minute-based <code>labelUnits</code>.  
     *  If you write a custom DateTimeAxis class, you can override this method 
     *  to provide alternate default formatting.
     *  
     *  <p>You do not call this method directly. Instead, Flex calls this method before it
     *  renders the label to get the appropriate String to display.</p>
     *  
     *  @param d The Date object that contains the unit to format.
     *  
     *  @param previousValue The Date object that contains the data point that occurs 
     *  prior to the current data point.
     *  
     *  @param axis The DateTimeAxis on which the label is rendered.
     *  
     *  @return The formatted label.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function formatMinutes(d:Date, previousValue:Date,
                                     axis:DateTimeAxis):String
    {
        return d[hoursP] + ":" +
               (d[minutesP] < 10 ? "0" + d[minutesP] : d[minutesP]);
    }

    /**
     *  The default formatting function used
     *  when the axis renders with second-based <code>labelUnits</code>.  
     *  If you write a custom DateTimeAxis class, you can override this method to 
     *  provide alternate default formatting.
     *  
     *  <p>You do not call this method directly. Instead, Flex calls this method before it
     *  renders the label to get the appropriate String to display.</p>
     *  
     *  @param d The Date object that contains the unit to format.
     *  
     *  @param previousValue The Date object that contains the data point that occurs 
     *  prior to the current data point.
     *  
     *  @param axis The DateTimeAxis on which the label is rendered.
     *  
     *  @return The formatted label.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function formatSeconds(d:Date, previousValue:Date,
                                     axis:DateTimeAxis):String
    {
        return d[hoursP]+ ":" +
               (d[minutesP] < 10 ? "0" + d[minutesP] : d[minutesP]) + ":" +
               (d[secondsP] < 10 ? "0" + d[secondsP] : d[secondsP]);
    }

    /**
     *  The default formatting function used
     *  when the axis renders with millisecond-based <code>labelUnits</code>.  
     *  If you write a custom DateTimeAxis class, you can override this method 
     *  to provide alternate default formatting.
     *  
     *  <p>You do not call this method directly. Instead, Flex calls this method before it
     *  renders the label to get the appropriate String to display.</p>
     *  
     *  @param d The Date object that contains the unit to format.
     *  
     *  @param previousValue The Date object that contains the data point that occurs 
     *  prior to the current data point.
     *  
     *  @param axis The DateTimeAxis on which the label is rendered.
     *  
     *  @return The formatted label.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function formatMilliseconds(d:Date, previousValue:Date,
                                          axis:DateTimeAxis):String
    {
        var s:String =
            d[hoursP] + ":" +
            (d[minutesP] < 10 ? "0" + d[minutesP] : d[minutesP]) + ":" +
            (d[secondsP] < 10 ? "0" + d[secondsP] : d[secondsP]);
        
        var m:String = d[millisecondsP].toString();
        if (m.length < 4)
        {
            var n:int = m.length;
            for (var i:int = n; i < 4; i++)
            {
                m = "0" + m;
            }
        }

        return s + m;
    }
    
    /**
     *  @private
     */
    private function chooseLabelFunction():Function
    {
        if (labelFunction != null)
            return labelFunction;
        
        switch (_labelUnits)
        {
            case "years":
            {
                return formatYears;
            }

            case "months":
            {
                return formatMonths;
            }

            case "days":
            case "weeks":
            {
                return formatDays;
            }

            case "hours":
            case "minutes":
            {
                return formatMinutes;
            }

            case "seconds":
            {
                return formatSeconds;
            }
                        
            case "milliseconds":
                return formatMilliseconds;
                break;          
        }
        return formatDays;
    }

    /**
     *  @private
     */
    private function toMilli(v:Number, unit:String):Number
    {
        switch (unit)
        {
            case "milliseconds":
            {
                return v;
            }

            case "seconds":
            {
                return v * 1000;
            }

            case "minutes":
            {
                return v * MILLISECONDS_IN_MINUTE;
            }

            case "hours":
            {
                return v * MILLISECONDS_IN_HOUR;
            }

            case "weeks":
            {
                return v * MILLISECONDS_IN_WEEK;
            }

            case "months":
            {
                return v * MILLISECONDS_IN_MONTH;
            }

            case "years":
            {
                return v * MILLISECONDS_IN_YEAR;
            }

            case "days":
            default:
            {
                return v * MILLISECONDS_IN_DAY;
            }
        }
    }

    /**
     *  @private
     */
    private function fromMilli(v:Number, unit:String):Number
    {
        switch (unit)
        {
            case "milliseconds":
            {
                return v;
            }

            case "seconds":
            {
                return v / 1000;
            }

            case "minutes":
            {
                return v / MILLISECONDS_IN_MINUTE;
            }

            case "hours":
            {
                return v / MILLISECONDS_IN_HOUR;
            }

            case "days":
            {
                return v / MILLISECONDS_IN_DAY;
            }

            case "weeks":
            {
                return v / MILLISECONDS_IN_WEEK;
            }

            case "months":
            {
                return v / MILLISECONDS_IN_MONTH;
            }

            case "years":
            {
                return v / MILLISECONDS_IN_YEAR;
            }
        }

        return NaN;
    }

    
    
    /**
     *  @private
     */
    private function updatePropertyAccessors():void
    {
        if (_displayLocalTime)
        {
        
            millisecondsP = "milliseconds";
            secondsP = "seconds";
            minutesP = "minutes";
            hoursP = "hours";
            dateP = "date";
            dayP = "day";
            monthP = "month";
            fullYearP = "fullYear";         
        }
        else
        {
            millisecondsP = "millisecondsUTC";
            secondsP = "secondsUTC";
            minutesP = "minutesUTC";
            hoursP = "hoursUTC";
            dateP = "dateUTC";
            dayP = "dayUTC";
            monthP = "monthUTC";
            fullYearP = "fullYearUTC";          
        }
    }
}

}