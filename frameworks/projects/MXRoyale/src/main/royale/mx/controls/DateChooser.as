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

package mx.controls
{
	
	import mx.core.UIComponent;
	import mx.core.mx_internal;
//	import mx.events.CalendarLayoutChangeEvent;
	
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.ILayoutParent;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.beads.models.DateChooserModel;
	import org.apache.royale.utils.loadBeadFromValuesManager;

/*
import mx.events.DateChooserEvent;
import mx.events.FlexEvent;
import mx.graphics.RectangularDropShadow;
import mx.managers.IFocusManagerComponent;
import mx.styles.StyleManager;
import mx.styles.StyleProxy;
import mx.utils.GraphicsUtil;
*/
use namespace mx_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when a date is selected or changed.
 *
 *  @eventType mx.events.CalendarLayoutChangeEvent.CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="change", type="org.apache.royale.events.Event")]

/**
 *  Dispatched when the month changes due to user interaction.
 *
 *  @eventType mx.events.DateChooserEvent.SCROLL
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Event(name="scroll", type="mx.events.DateChooserEvent")]


/**
 *  The DateChooser control displays the name of a month, the year,
 *  and a grid of the days of the month, with columns labeled
 *  for the day of the week.
 *  The user can select a date, a range of dates, or multiple dates.
 *  The control contains forward and back arrow buttons
 *  for changing the month and year.
 *  You can let users select multiple dates, disable the selection
 *  of certain dates, and limit the display to a range of dates.
 *
 *  <p>The DateChooser control has the following default characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>A size large enough to hold the calendar, and wide enough to display the day names</td>
 *        </tr>
 *        <tr>
 *           <td>Minimum size</td>
 *           <td>0 pixels</td>
 *        </tr>
 *        <tr>
 *           <td>Maximum size</td>
 *           <td>No limit</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:DateChooser&gt;</code> tag inherits all of the tag attributes
 *  of its superclass, and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:DateChooser
 *    <strong>Properties</strong>
 *    allowDisjointSelection="true|false"
 *    allowMultipleSelection="false|true"
 *    dayNames="["S", "M", "T", "W", "T", "F", "S"]"
 *    disabledDays="<i>No default</i>"
 *    disabledRanges="<i>No default</i>"
 *    displayedMonth="<i>Current month</i>"
 *    displayedYear="<i>Current year</i>"
 *    firstDayOfWeek="0"
 *    maxYear="2100"
 *    minYear="1900"
 *    monthNames="["January", "February", "March", "April", "May",
 *      "June", "July", "August", "September", "October", "November",
 *      "December"]"
 *    monthSymbol=""
 *    selectableRange="<i>No default</i>"
 *    selectedDate="<i>No default</i>"
 *    selectedRanges="<i>No default</i>"
 *    showToday="true|false"
 *    yearNavigationEnabled="false|true"
 *    yearSymbol=""
 * 
 *    <strong>Styles</strong>
 *    backgroundColor="0xFFFFFF"
 *    backgroundAlpha="1.0"
 *    borderColor="0xAAB3B3"
 *    borderThickness="1"
 *    color="0x0B333C"
 *    cornerRadius="4"
 *    disabledColor="0xAAB3B3"
 *    disabledIconColor="0x999999"
 *    fillAlphas="[0.6, 0.4]"
 *    fillColors="[0xFFFFFF, 0xCCCCCC]"
 *    focusAlpha="0.5"
 *    focusRoundedCorners"tl tr bl br"
 *    fontAntiAliasType="advanced"
 *    fontFamily="Verdana"
 *    fontGridFitType="pixel"
 *    fontSharpness="0"
 *    fontSize="10"
 *    fontStyle="normal|italic"
 *    fontThickness="0"
 *    fontWeight="normal|bold"
 *    headerColors="[0xE1E5EB, 0xF4F5F7]"
 *    headerStyleName="headerDateText"
 *    highlightAlphas="[0.3, 0.0]"
 *    horizontalGap="8"
 *    iconColor="0x111111"
 *    leading="2"
 *    nextMonthDisabledSkin="DateChooserMonthArrowSkin"
 *    nextMonthDownSkin="DateChooserMonthArrowSkin"
 *    nextMonthOverSkin="DateChooserMonthArrowSkin"
 *    nextMonthSkin = "DateChooserMonthArrowSkin" 
 *    nextMonthUpSkin="DateChooserMonthArrowSkin"
 *    nextYearDisabledSkin="DateChooserYearArrowSkin"
 *    nextYearDownSkin="DateChooserYearArrowSkin"
 *    nextYearOverSkin="DateChooserYearArrowSkin"
 *    nextYearSkin = "DateChooserYearArrowSkin"
 *    nextYearUpSkin="DateChooserYearArrowSkin"
 *    prevMonthDisabledSkin="DateChooserMonthArrowSkin"
 *    prevMonthDownSkin="DateChooserMonthArrowSkin"
 *    prevMonthOverSkin="DateChooserMonthArrowSkin"
 *    prevMonthSkin = "DateChooserMonthArrowSkin"
 *    prevMonthUpSkin="DateChooserMonthArrowSkin"
 *    prevYearDisabledSkin="DateChooserYearArrowSkin"
 *    prevYearDownSkin="DateChooserYearArrowSkin"
 *    prevYearOverSkin="DateChooserYearArrowSkin"
 *    prevYearSkin = "DateChooserYearArrowSkin"
 *    prevYearUpSkin="DateChooserYearArrowSkin"
 *    rollOverColor="0xEEFEE6"
 *    rollOverIndicatorSkin="DateChooserIndicator"
 *    selectionColor="0xB7F39B"
 *    selectionIndicatorSkin="DateChooserIndicator"
 *    textAlign="left|right|center"
 *    textDecoration="none|underline"
 *    textIndent="0"
 *    todayColor="0x818181"
 *    todayIndicatorSkin="DateChooserIndicator"
 *    todayStyleName="todayStyle"
 *    verticalGap="6"
 *    weekDayStyleName="weekDayStyle"
 * 
 *    <strong>Events</strong>
 *    change="<i>No default</i>"
 *    scroll="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *
 *  @see mx.controls.DateField
 *
 *  @includeExample examples/DateChooserExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class DateChooser extends UIComponent implements ILayoutParent, ILayoutView//implements IFocusManagerComponent, IFontContextComponent
{

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
    public function DateChooser()
    {
        super();
		typeNames = "DateChooser";
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------


    //----------------------------------
    //  enabled
    //----------------------------------


    /**
     *  @private
     */
    override public function get enabled():Boolean
    {
		trace("get enabled not implemented");
        return true;
    }

    /**
     *  @private
     */
    override public function set enabled(value:Boolean):void
    {
		trace("set enabled not implemented");
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  dayNames
    //----------------------------------

    
    [Bindable("dayNamesChanged")]
    [Inspectable(arrayType="String", defaultValue="null")]

    /**
     *  The weekday names for DateChooser control.
     *  Changing this property changes the day labels
     *  of the DateChooser control.
     *  Sunday is the first day (at index 0).
     *  The rest of the week names follow in the normal order.
     *
     *  @default [ "S", "M", "T", "W", "T", "F", "S" ].
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get dayNames():Array
    {
        return DateChooserModel(model).dayNames;
    }

    /**
     *  @private
     */
    public function set dayNames(value:Array):void
    {
		DateChooserModel(model).dayNames = value;
//        dayNamesOverride = value;
//
//        _dayNames = value != null ?
//                    value :
//                    resourceManager.getStringArray(
//                        "controls", "dayNamesShortest");
//        
//        // _dayNames will be null if there are no resources.
//        _dayNames = _dayNames ? _dayNames.slice(0) : null;
//
//        dayNamesChanged = true;
//
//        invalidateProperties();
    }

    //----------------------------------
    //  disabledDays
    //----------------------------------

    [Bindable("disabledDaysChanged")]
    [Inspectable(arrayType="Date")]

    /**
     *  The days to disable in a week.
     *  All the dates in a month, for the specified day, are disabled.
     *  This property changes the appearance of the DateChooser control.
     *  The elements of this array can have values from 0 (Sunday) to
     *  6 (Saturday).
     *  For example, a value of <code>[ 0, 6 ]</code>
     *  disables Sunday and Saturday.
     *
     *  @default []
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get disabledDays():Array
    {
		trace("get disabledDays not implemented.");
        return null;
    }

    /**
     *  @private
     */
    public function set disabledDays(value:Array):void
    {
		trace("set disabledDays not implemented");
//        _disabledDays = value;
//        disabledDaysChanged = true;
//
//        invalidateProperties();
    }

    //----------------------------------
    //  disabledRanges
    //----------------------------------



    [Bindable("disabledRangesChanged")]
    [Inspectable(arrayType="Object")]

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
     *  in the Array. Time values are zeroed out from the Date 
     *  object if they are present.</p>
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
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get disabledRanges():Array
    {
		trace("get disabledRanged not implemented");
        return null;
    }

    /**
     *  @private
     */
    public function set disabledRanges(value:Array):void
    {
		trace("set disabledRanges not implemented");
//        _disabledRanges = scrubTimeValues(value);
//        disabledRangesChanged = true;
//
//        invalidateProperties();
    }

    //----------------------------------
    //  displayedMonth
    //----------------------------------

    [Bindable("scroll")]
    [Bindable("viewChanged")]
    [Inspectable(category="General")]

    /**
     *  Used together with the <code>displayedYear</code> property,
     *  the <code>displayedMonth</code> property specifies the month
     *  displayed in the DateChooser control.
     *  Month numbers are zero-based, so January is 0 and December is 11.
     *  Setting this property changes the appearance of the DateChooser control.
     *
     *  <p>The default value is the current month.</p>
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get displayedMonth():int
    {
		return DateChooserModel(model).displayedMonth;
//        if (dateGrid && _displayedMonth != dateGrid.displayedMonth)
//            return dateGrid.displayedMonth;
//        else
//            return _displayedMonth;
    }

    /**
     *  @private
     */
    public function set displayedMonth(value:int):void
    {
		DateChooserModel(model).displayedMonth = value;
//        if (isNaN(value) || displayedMonth == value)
//            return;
//        
//        _displayedMonth = value;
//        displayedMonthChanged = true;
//        
//        invalidateProperties();
//        
//        if (dateGrid)
//            dateGrid.displayedMonth = value; // if it's already this value shouldn't do anything
    }

    //----------------------------------
    //  displayedYear
    //----------------------------------


//    [Bindable("scroll")]
//    [Bindable("viewChanged")]
    [Inspectable(category="General")]

    /**
     *  Used together with the <code>displayedMonth</code> property,
     *  the <code>displayedYear</code> property specifies the year
     *  displayed in the DateChooser control.
     *  Setting this property changes the appearance of the DateChooser control.
     *
     *  <p>The default value is the current year.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get displayedYear():int
    {
		return DateChooserModel(model).displayedYear;
//        if (dateGrid)
//            return dateGrid.displayedYear;
//        else
//            return _displayedYear;
    }

    /**
     *  @private
     */
    public function set displayedYear(value:int):void
    {
		DateChooserModel(model).displayedYear = value;
//        if (isNaN(value) || displayedYear == value)
//            return;
//        
//        _displayedYear = value;
//        displayedYearChanged = true;
//        
//        invalidateProperties();
//        
//        if (dateGrid)
//            dateGrid.displayedYear = value;// if it's already this value shouldn't do anything
    }

    //----------------------------------
    //  firstDayOfWeek
    //----------------------------------

    
    [Bindable("firstDayOfWeekChanged")]
    [Inspectable(defaultValue="null")]

    /**
     *  Number representing the day of the week to display in the
     *  first column of the DateChooser control.
     *  The value must be in the range 0 to 6, where 0 corresponds to Sunday,
     *  the first element of the <code>dayNames</code> Array.
     *
     *  <p>Setting this property changes the order of the day columns.
     *  For example, setting it to 1 makes Monday the first column
     *  in the control.</p>
     *
     *  @default 0 (Sunday)
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get firstDayOfWeek():Object
    {
        return DateChooserModel(model).firstDayOfWeek;
    }

    /**
     *  @private
     */
    public function set firstDayOfWeek(value:Object):void
    {
		DateChooserModel(model).firstDayOfWeek = Number(value);
//        firstDayOfWeekOverride = value;
//        
//        _firstDayOfWeek = value != null ?
//                          int(value) :
//                          resourceManager.getInt(
//                              "controls", "firstDayOfWeek");
//        
//        
//        firstDayOfWeekChanged = true;
//
//        invalidateProperties();
    }

    //----------------------------------
    //  fontContext
    //----------------------------------
    
    
    //----------------------------------
    //  maxYear
    //----------------------------------

    /**
     *  @private
     *  Storage for the maxYear property.
     */
    private var _maxYear:int = 2100;

    /**
     *  The last year selectable in the control.
     *
     *  @default 2100
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get maxYear():int
    {
        return _maxYear;
    }

    /**
     *  @private
     */
    public function set maxYear(value:int):void
    {
        if (_maxYear == value)
            return;

        _maxYear = value;
    }

    //----------------------------------
    //  minYear
    //----------------------------------

    /**
     *  @private
     *  Storage for the minYear property.
     */
    private var _minYear:int = 1900;

    /**
     *  The first year selectable in the control.
     *
     *  @default 1900
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get minYear():int
    {
        return _minYear;
    }

    /**
     *  @private
     */
    public function set minYear(value:int):void
    {
        if (_minYear == value)
            return;

        _minYear = value;
    }

    //----------------------------------
    //  monthNames
    //----------------------------------

    
    [Bindable("monthNamesChanged")]
    [Inspectable(arrayType="String", defaultValue="null")]

    /**
     *  Names of the months displayed at the top of the DateChooser control.
     *  The <code>monthSymbol</code> property is appended to the end of 
     *  the value specified by the <code>monthNames</code> property, 
     *  which is useful in languages such as Japanese.
     *
     *  @default [ "January", "February", "March", "April", "May", "June", 
     *  "July", "August", "September", "October", "November", "December" ]
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get monthNames():Array
    {
        return DateChooserModel(model).monthNames;
    }

    /**
     *  @private
     */
    public function set monthNames(value:Array):void
    {
		DateChooserModel(model).monthNames = value;
//        monthNamesOverride = value;
//
//        _monthNames = value != null ?
//                      value :
//                      resourceManager.getStringArray(
//                          "SharedResources", "monthNames");
//                          
//        // _monthNames will be null if there are no resources.
//        _monthNames = _monthNames ? monthNames.slice(0) : null;
//
//        monthNamesChanged = true;
//
//        invalidateProperties();
//        invalidateSize();
    }

    
    
    //----------------------------------
    //  selectableRange
    //----------------------------------

    /**
     *  @private
     *  Storage for the selectableRange property.
     */
    private var _selectableRange:Object;

    /**
     *  @private
     */
    private var selectableRangeChanged:Boolean = false;

    [Bindable("selectableRangeChanged")]

    /**
     *  Range of dates between which dates are selectable.
     *  For example, a date between 04-12-2006 and 04-12-2007
     *  is selectable, but dates out of this range are disabled.
     *
     *  <p>This property accepts an Object as a parameter.
     *  The Object contains two properties, <code>rangeStart</code>
     *  and <code>rangeEnd</code>, of type Date.
     *  If you specify only <code>rangeStart</code>,
     *  all the dates on and after the specified date are enabled.
     *  If you only specify <code>rangeEnd</code>,
     *  all the dates on and before the specified date are enabled.
     *  To enable only a single day in a DateChooser control,
     *  you can pass a Date object directly. Time values are 
     *  zeroed out from the Date object if they are present.</p>
     *
     *  <p>The following example enables only the range
     *  January 1, 2006 through June 30, 2006. Months before January
     *  and after June do not appear in the DateChooser.</p>
     *
     *  <p><code>selectableRange="{{rangeStart : new Date(2006,0,1),
     *  rangeEnd : new Date(2006,5,30)}}"</code></p>
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectableRange():Object
    {
        return _selectableRange;
    }

    /**
     *  @private
     */
    public function set selectableRange(value:Object):void
    {
        _selectableRange = scrubTimeValue(value);
        selectableRangeChanged = true;

        invalidateProperties();
    }

    //----------------------------------
    //  selectedDate
    //----------------------------------

    /**
     *  @private
     *  Storage for the selectedDate property.
     */
    private var _selectedDate:Date;

    /**
     *  @private
     */
    private var selectedDateChanged:Boolean = false;

    [Bindable("change")]
    [Bindable("valueCommit")]
    [Inspectable(category="General")]

    /**
     *  Date selected in the DateChooser control.
     *  If the incoming Date object has any time values, 
     *  they are zeroed out.
     *
     *  <p>Holding down the Control key when selecting the 
     *  currently selected date in the control deselects it, 
     *  sets the <code>selectedDate</code> property to <code>null</code>, 
     *  and then dispatches the <code>change</code> event.</p>
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectedDate():Date
    {
		return DateChooserModel(model).selectedDate;
        //return _selectedDate;
    }

    /**
     *  @private
     */
    public function set selectedDate(value:Date):void
    {
		DateChooserModel(model).selectedDate = value;
//        _selectedDate = scrubTimeValue(value) as Date;
//        selectedDateChanged = true;
//
//        invalidateProperties();
    }

    //----------------------------------
    //  selectedRanges
    //----------------------------------

    [Bindable("change")]
    [Bindable("valueCommit")]
    [Inspectable(arrayType="Date")]

    /**
     *  Selected date ranges.
     *
     *  <p>This property accepts an Array of objects as a parameter.
     *  Each object in this array has two date Objects,
     *  <code>rangeStart</code> and <code>rangeEnd</code>.
     *  The range of dates between each set of <code>rangeStart</code>
     *  and <code>rangeEnd</code> (inclusive) are selected.
     *  To select a single day, set both <code>rangeStart</code> and <code>rangeEnd</code>
     *  to the same date. Time values are zeroed out from the Date 
     *  object if they are present.</p>
     * 
     *  <p>The following example, selects the following dates: January 11
     *  2006, the range January 23 - February 10 2006. </p>
     *
     *  <p><code>selectedRanges="{[ {rangeStart: new Date(2006,0,11),
     *  rangeEnd: new Date(2006,0,11)}, {rangeStart:new Date(2006,0,23),
     *  rangeEnd: new Date(2006,1,10)} ]}"</code></p>
     *
     *  @default []
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectedRanges():Array
    {
		trace("get selectedRanges not implemented.");
		return null;
//        _selectedRanges = dateGrid.selectedRanges;
//        return _selectedRanges;
    }

    /**
     *  @private
     */
    public function set selectedRanges(value:Array):void
    {
		trace("set selectedRanges not implemented.");
//        _selectedRanges = scrubTimeValues(value);
//        selectedRangesChanged = true;
//
//        invalidateProperties();
    }

    //----------------------------------
    //  showToday
    //----------------------------------

    /**
     *  @private
     *  Storage for the showToday property.
     */
    private var _showToday:Boolean = true;

    /**
     *  @private
     */
    private var showTodayChanged:Boolean = false;

    [Bindable("showTodayChanged")]
    [Inspectable(category="General", defaultValue="true")]

    /**
     *  If <code>true</code>, specifies that today is highlighted
     *  in the DateChooser control.
     *  Setting this property changes the appearance of the DateChooser control.
     *
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get showToday():Boolean
    {
        return _showToday;
    }

    /**
     *  @private
     */
    public function set showToday(value:Boolean):void
    {
        _showToday = value;
        showTodayChanged = true;

//        invalidateProperties();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

    


    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    
    
    /**
     *  @private
     *  This method scrubs out time values from incoming date objects
     */ 
     mx_internal function scrubTimeValue(value:Object):Object
     {
        if (value is Date)
        {
            return new Date(value.getFullYear(), value.getMonth(), value.getDate());
        }
        else if (value is Object) 
        {
            var range:Object = {};
            if (value.hasOwnProperty("rangeStart") && value.rangeStart is Date)
            {
                range.rangeStart = new Date(value.rangeStart.getFullYear(), 
                                            value.rangeStart.getMonth(), 
                                            value.rangeStart.getDate());
            }
            
            if (value.hasOwnProperty("rangeEnd") && value.rangeEnd is Date)
            {
                range.rangeEnd = new Date(value.rangeEnd.getFullYear(), 
                                          value.rangeEnd.getMonth(), 
                                          value.rangeEnd.getDate());
            }
            return range;
        }
        return null;
     }
     
     /**
     *  @private
     *  This method scrubs out time values from incoming date objects
     */ 
     mx_internal function scrubTimeValues(values:Array):Array
     {
         var dates:Array = [];
         for (var i:int = 0; i < values.length; i++)
         {
            dates[i] = scrubTimeValue(values[i]);
         }
         return dates;
     }

     //----------------------------------
     //  yearNavigationEnabled
     //----------------------------------
     
     /**
      *  @private
      *  Storage for the yearNavigationEnabled property.
      */
     private var _yearNavigationEnabled:Boolean = false;
     
     /**
      *  @private
      */
     //private var yearNavigationEnabledChanged:Boolean = false;
     
     [Bindable("yearNavigationEnabledChanged")]
     [Inspectable(defaultValue="false")]
     
     /**
      *  Enables year navigation. When <code>true</code>
      *  an up and down button appear to the right
      *  of the displayed year. You can use these buttons
      *  to change the current year.
      *  These button appear to the left of the year in locales where year comes 
      *  before the month in the date format.
      *
      *  @default false
      *  
      *  @langversion 3.0
      *  @playerversion Flash 9
      *  @playerversion AIR 1.1
      *  @productversion Flex 3
      */
     public function get yearNavigationEnabled():Boolean
     {
         return _yearNavigationEnabled;
     }
     
     /**
      *  @private
      */
     public function set yearNavigationEnabled(value:Boolean):void
     {
         _yearNavigationEnabled = value;
    //     yearNavigationEnabledChanged = true;
         
     //    invalidateProperties();
     }
     
    //--------------------------------------------------------------------------
    //
    //  Overridden event handlers: UIComponent
    //
    //--------------------------------------------------------------------------

    

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    
    override public function addedToParent():void
    {
        super.addedToParent();
        // Load the layout bead if it hasn't already been loaded.
        loadBeadFromValuesManager(IBeadLayout, "iBeadLayout", this);
        
        dispatchEvent(new Event("initComplete"));
    }
    
    /**
     * Returns the ILayoutHost which is its view. From ILayoutParent.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     *  @royaleignorecoercion org.apache.royale.core.ILayoutHost
     */
    public function getLayoutHost():ILayoutHost
    {
        return view as ILayoutHost;
    }
}

}
