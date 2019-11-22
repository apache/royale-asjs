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

/* import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TextEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Keyboard; */

//import mx.controls.dataGridClasses.DataGridListData;
import mx.controls.beads.DateFieldView;
import mx.controls.listClasses.BaseListData;
import mx.core.ClassFactory;
import mx.core.IDataRenderer;
import mx.core.IFactory;
import mx.core.mx_internal;
import mx.events.CalendarLayoutChangeEvent;
import mx.events.FlexEvent;
import mx.events.SandboxMouseEvent;
import mx.managers.IFocusManagerComponent;
import mx.managers.ISystemManager;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleProxy;
import mx.utils.ObjectUtil;

use namespace mx_internal;

import org.apache.royale.core.IDateChooserModel;
import org.apache.royale.core.IUIBase;
import mx.controls.TextInput;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when a date is selected or changed,
 *  and the DateChooser control closes.
 *
 *  @eventType mx.events.CalendarLayoutChangeEvent.CHANGE
 *  @helpid 3613
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="change", type="mx.events.CalendarLayoutChangeEvent")]

/**
 *  Dispatched when a date is selected or the user clicks
 *  outside the drop-down list.
 *
 *  @eventType mx.events.DropdownEvent.CLOSE
 *  @helpid 3615
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Event(name="close", type="mx.events.DropdownEvent")]

/**
 *  Dispatched when the <code>data</code> property changes.
 *
 *  <p>When you use a component as an item renderer,
 *  the <code>data</code> property contains the data to display.
 *  You can listen for this event and update the component
 *  when the <code>data</code> property changes.</p>
 * 
 *  @eventType mx.events.FlexEvent.DATA_CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Event(name="dataChange", type="mx.events.FlexEvent")]

/**
 *  Dispatched when a user selects the field to open the drop-down list.
 *
 *  @eventType mx.events.DropdownEvent.OPEN
 *  @helpid 3614
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Event(name="open", type="mx.events.DropdownEvent")]

/**
 *  Dispatched when the month changes due to user interaction.
 *
 *  @eventType mx.events.DateChooserEvent.SCROLL
 *  @helpid 3616
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Event(name="scroll", type="mx.events.DateChooserEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

/* include "../styles/metadata/FocusStyles.as"
include "../styles/metadata/IconColorStyles.as"
include "../styles/metadata/LeadingStyle.as"
include "../styles/metadata/PaddingStyles.as"
include "../styles/metadata/TextStyles.as" */

/**
 *  Color of the border.
 *  The following controls support this style: Button, CheckBox,
 *  ComboBox, MenuBar,
 *  NumericStepper, ProgressBar, RadioButton, ScrollBar, Slider, and any
 *  components that support the <code>borderStyle</code> style.
 *  The default value depends on the component class;
 *  if not overridden for the class, the default value is <code>0xB7BABC</code>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="borderColor", type="uint", format="Color", inherit="no", theme="halo")]

/**
 *  The bounding box thickness of the DateChooser control.
 *  The default value is 1.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="borderThickness", type="Number", format="Length", inherit="no", theme="halo")]

/**
 *  Name of the CSS Style declaration to use for the styles for the
 *  DateChooser control's drop-down list.
 *  By default, the DateChooser control uses the DateField control's
 *  inheritable styles. 
 *  
 *  <p>You can use this class selector to set the values of all the style properties 
 *  of the DateChooser class, including <code>cornerRadius</code>,
 *  <code>fillAlphas</code>, <code>fillColors</code>, <code>headerColors</code>, <code>headerStyleName</code>, 
 *  <code>highlightAlphas</code>, <code>todayStyleName</code>, and <code>weekdayStyleName</code>.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="dateChooserStyleName", type="String", inherit="no")]

/**
 *  Color of the highlight area of the date when the user holds the
 *  mouse pointer over a date in the DateChooser control.
 * 
 *  The default value for the Halo theme is <code>0xB2E1FF</code>.
 *  The default value for the Spark theme is <code>0xCEDBEF</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="rollOverColor", type="uint", format="Color", inherit="yes")]

/**
 *  Color of the highlight area of the currently selected date
 *  in the DateChooser control.
 * 
 *  The default value for the Halo theme is <code>0x7FCEFF</code>.
 *  The default value for the Spark theme is <code>0xA8C6EE</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="selectionColor", type="uint", format="Color", inherit="yes")]

/**
 *  Name of the class to use as the default skin for the background and border. 
 *  For the DateField class, there is no default value.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="skin", type="Class", inherit="no", states=" up, over, down, disabled")]


/**
 *  Color of the highlight of today's date in the DateChooser control.
 *  The default value is <code>0x2B333</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="todayColor", type="uint", format="Color", inherit="yes")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------
/* 
[Exclude(name="selectedIndex", kind="property")]
[Exclude(name="selectedItem", kind="property")]
[Exclude(name="borderThickness", kind="style")]
[Exclude(name="editableUpSkin", kind="style")]
[Exclude(name="editableOverSkin", kind="style")]
[Exclude(name="editableDownSkin", kind="style")]
[Exclude(name="editableDisabledSkin", kind="style")] */

//--------------------------------------
//  Other metadata
//--------------------------------------

[AccessibilityClass(implementation="mx.accessibility.DateFieldAccImpl")]

[DefaultBindingProperty(source="selectedDate", destination="selectedDate")]

[DefaultTriggerEvent("change")]

//[IconFile("DateField.png")]

[RequiresDataBinding(true)]

//[ResourceBundle("controls")]
//[ResourceBundle("SharedResources")]

/**
 *  The DateField control is a text field that shows the date
 *  with a calendar icon on its right side.
 *  When the user clicks anywhere inside the bounding box
 *  of the control, a DateChooser control pops up
 *  and shows the dates in the month of the current date.
 *  If no date is selected, the text field is blank
 *  and the month of the current date is displayed
 *  in the DateChooser control.
 *
 *  <p>When the DateChooser control is open, the user can scroll
 *  through months and years, and select a date.
 *  When a date is selected, the DateChooser control closes,
 *  and the text field shows the selected date.</p>
 *
 *  <p>The user can also type the date in the text field if the <code>editable</code>
 *  property of the DateField control is set to <code>true</code>.</p>
 *
 *  <p>The DateField has the same default characteristics (shown below) as the DateChooser for its expanded date chooser.</p>
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
*  <p>The DateField has the following default characteristics for the collapsed control:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>A size large enough to hold the formatted date and the calendar icon</td>
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
 *  <p>The <code>&lt;mx:DateField&gt</code> tag inherits all of the tag attributes
 *  of its superclass, and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:DateField
 *    <strong>Properties</strong>
 *    dayNames="["S", "M", "T", "W", "T", "F", "S"]"
 *    disabledDays="<i>No default</i>"
 *    disabledRanges="<i>No default</i>"
 *    displayedMonth="<i>Current month</i>"
 *    displayedYear="<i>Current year</i>"
 *    dropdownFactory="<i>ClassFactory that creates an mx.controls.DateChooser</i>"
 *    firstDayOfWeek="0"
 *    formatString="MM/DD/YYYY"
 *    labelFunction="<i>Internal formatter</i>"
 *    maxYear="2100"
 *    minYear="1900"
 *    monthNames="["January", "February", "March", "April", "May",
 *    "June", "July", "August", "September", "October", "November",
 *    "December"]"
 *    monthSymbol=""
 *    parseFunction="<i>Internal parser</i>"
 *    selectableRange="<i>No default</i>"
 *    selectedDate="<i>No default</i>"
 *    showToday="true|false"
 *    yearNavigationEnabled="false|true"
 *    yearSymbol=""
 *  
 *   <strong>Styles</strong>
 *    borderColor="0xAAB3B3"
 *    borderThickness="1"
 *    color="0x0xB333C"
 *    dateChooserStyleName="dateFieldPopup"
 *    disabledColor="0xAAB3B3"
 *    disabledIconColor="0x999999"
 *    focusAlpha="0.5"
 *    focusRoundedCorners="tl tr bl br"
 *    fontAntiAliasType="advanced"
 *    fontFamily="Verdana"
 *    fontGridFitType="pixel"
 *    fontSharpness="0"
 *    fontSize="10"
 *    fontStyle="normal|italic"
 *    fontThickness="0"
 *    fontWeight="normal|bold"
 *    iconColor="0x111111"
 *    leading="2"
 *    paddingLeft="0"
 *    paddingRight="0"
 *    rollOverColor="0xE3FFD6"
 *    selectionColor="0xB7F39B"
 *    textAlign="left|right|center"
 *    textDecoration="none|underline"
 *    textIndent="0"
 *    todayColor="0x2B333C"
 * 
 *    <strong>Events</strong>
 *    change="<i>No default</i>"
 *    close="<i>No default</i>"
 *    dataChange="<i>No default</i>"
 *    open="<i>No default</i>"
 *    scroll="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *
 *  @see mx.controls.DateChooser
 *  @includeExample examples/DateFieldExample.mxml
 *
 *  @helpid 3617
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class DateField extends ComboBase 
                      
{
 /* implements IDataRenderer,IFocusManagerComponent, IDropInListItemRenderer, IListItemRenderer */
   // include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class mixins
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Placeholder for mixin by DateFieldAccImpl.
     */
   // mx_internal static var createAccessibilityImplementation:Function;

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

	/**
	 * Return the short three letter name of a month.
	 * In most cases it's the first 3 letters.  
	 * 
	 * TODO move short names to resource bundles.
	 */
	/*  protected static function shortMonthName(monthName:String, locale:Locale, monthNames:Array):String
	 {
		if (locale && locale.language == "fr") {
			if (monthName == monthNames[5]) {
				return "JUN";
			}
			else if (monthName == monthNames[6]) {
				return "JUL";	
			}
		}
		
		return monthName.substr(0,3);
	 } */
	 
    /**
     *  Parses a String object that contains a date, and returns a Date
     *  object corresponding to the String.
     *  The <code>inputFormat</code> argument contains the pattern
     *  in which the <code>valueString</code> String is formatted.
     *  It can contain <code>"M"</code>, <code>"MM"</code>, 
	 *  <code>"MMM"</code> (3 letter month names), <code>"MMMM"</code> (month names),
	 *  <code>"D"</code>,  <code>"DD"</code>, <code>"YY"</code>, <code>"YYYY"</code>
     *  and delimiter and punctuation characters.
	 * 
	 *  <p>Only upper case characters are supported.</p>
     *
     *  <p>The function does not check for the validity of the Date object.
     *  If the value of the date, month, or year is NaN, this method returns null.</p>
     * 
     *  <p>For example:
     *  <pre>var dob:Date = DateField.stringToDate("06/30/2005", "MM/DD/YYYY");</pre>        
     *  </p>
     *
     *  @param valueString Date value to format.
     *
     *  @param inputFormat String defining the date format.
     *
     *  @return The formatted date as a Date object.
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function stringToDate(valueString:String, inputFormat:String):Date
    {
        /* var maskChar:String
		var dateChar:String;
		var dateString:String;
		var monthString:String;
		var yearString:String;
		var dateParts:Array = [];
		var maskParts:Array = [];
        var part:int = 0;
		var length:int;
		var position:int = 0;
		
		if (valueString == null || inputFormat == null)
			return null;
		
		var monthNames:Array = ResourceManager.getInstance().getStringArray("SharedResources", "monthNames");	
		var noMonths:int = monthNames.length;
		var locales:Array = ResourceManager.getInstance().localeChain;
		var locale:Locale = new Locale(locales[0]);
		
		for (var i:int = 0; i < noMonths; i++) {
			valueString = valueString.replace(monthNames[i], (i+1).toString());
			valueString = valueString.replace(shortMonthName(monthNames[i], locale, monthNames), (i+1).toString());
		}
		
		length = valueString.length;
		
		dateParts[part] = "";
        for (i = 0; i < length; i++)
        {
			dateChar = valueString.charAt(i);
 
			if (isNaN(Number(dateChar)) || dateChar == " ")
			{
				part++;
				dateParts[part] = dateChar;
				part++;
				dateParts[part] = "";
			}
			else
			{
				dateParts[part] += dateChar;	
			}
		}
		
		length = inputFormat.length;
		part = -1;
		var lastChar:String;
		
		for (i = 0; i < length; i++)
		{
			maskChar = inputFormat.charAt(i);
			
			if (maskChar == "Y" || maskChar == "M" || maskChar == "D")
			{
				if (maskChar != lastChar)
				{
					part++;
					maskParts[part] = "";
				}
				maskParts[part] += maskChar;
			}
			else
			{
				part++;
				maskParts[part] = maskChar;
			}
			
			lastChar = maskChar;
		}
			
		length = maskParts.length;

		if (dateParts.length != length)
		{
			if (valueString.length != inputFormat.length) {
				return null;
			}
			
			for (i = 0; i < length; i++) {
				dateParts[i] = valueString.substr(position, maskParts[i].length);
				position += maskParts[i].length;
			}
			
		}
		
		if (dateParts.length != length)
		{
			return null;
		}

		for (i = 0; i < length; i++) {
			maskChar = maskParts[i].charAt(0);
			
			if (maskChar == "D") {
				dateString = dateParts[i];
			}
			else if (maskChar == "M") {
				monthString = dateParts[i];
			}
			else if (maskChar == "Y") {
				yearString = dateParts[i];
			}
		}
		
		if (dateString == null || monthString == null || yearString == null)
			return null;
		
		var dayNum:Number = Number(dateString);
        var monthNum:Number = Number(monthString);
        var yearNum:Number = Number(yearString);

        if (isNaN(yearNum) || isNaN(monthNum) || isNaN(dayNum))
            return null;

        if (yearString.length == 2)
            yearNum += 2000;

        var newDate:Date = new Date(yearNum, monthNum - 1, dayNum);

        if (dayNum != newDate.getDate() || (monthNum - 1) != newDate.getMonth())
            return null;

        return newDate; */ 
		var newDate:Date =new Date();
		return newDate;
    }

    /**
     *  Formats a Date into a String according to the <code>outputFormat</code> argument.
     *  The <code>outputFormat</code> argument contains a pattern in which
     *  the <code>value</code> String is formatted.
     *  It can contain <code>"M"</code>, <code>"MM"</code>,
	 *  <code>"MMM"</code> (3 letter month names), <code>"MMMM"</code> (month names),
	 *  <code>"D"</code>, <code>"DD"</code>, <code>"YY"</code>, <code>"YYYY"</code>
     *  and delimiter and punctuation characters.
	 * 
	 *  <p>Only upper case characters are supported.</p>
     *
     *  @param value Date value to format.
     *
     *  @param outputFormat String defining the date format.
     *
     *  @return The formatted date as a String.
     *
     *  @example <pre>var todaysDate:String = DateField.dateToString(new Date(), "MM/DD/YYYY");</pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function dateToString(value:Date, outputFormat:String):String
    {
		/* var maskChar:String;
		var maskParts:Array = [];
		var part:int = -1;
		var length:int;
		var lastChar:String;
		
		if (!value || isNaN(value.getTime()) || !outputFormat)
			return "";
		
		length = outputFormat.length;
		
		for (var i:int = 0; i < length; i++)
		{
			maskChar = outputFormat.charAt(i);
			
			if (maskChar == "Y" || maskChar == "M" || maskChar == "D")
			{
				if (maskChar != lastChar)
				{
					part++;
					maskParts[part] = "";
				}
				maskParts[part] += maskChar;
			}
			else
			{
				part++;
				maskParts[part] = maskChar;
			}
			
			lastChar = maskChar;
		}
		
        var date:String = String(value.getDate());
        var month:String = String(value.getMonth() + 1);
        var year:String = String(value.getFullYear());

		var mask:String;
		var fullMask:String;
		var maskLength:int
		var output:String = "";
		
		//TODO Support changing locale at runtime
		var monthNames:Array =
			ResourceManager.getInstance().getStringArray(
				"SharedResources", "monthNames");
		
        length = maskParts.length;
        for (i = 0; i < length; i++)
        {
			fullMask = maskParts[i];
            mask = fullMask.charAt(0);
			maskLength = maskParts[i].length;
			
			if (mask == "D")
			{
				if (maskLength > 1 && date.length == 1)
					date = "0" + date;
				
				output += date;
			}
			else if (fullMask == "MMM")
			{
				var locales:Array = ResourceManager.getInstance().localeChain;
				var locale:Locale = new Locale(locales[0]);
				output += shortMonthName(monthNames[value.getMonth()], locale, monthNames);
			}
			else if (fullMask == "MMMM")
			{	
				output += monthNames[value.getMonth()];
			}
			else if (mask == "M")
			{
				if (maskLength > 1 && month.length == 1)
					month = "0" + month;
				
				output += month;
			}
			else if (mask == "Y")
			{
				if (maskLength == 2)
					output += year.substr(2,2);
				else
					output += year;
			}
            else
            {
                output += mask;
            }
        }

        return output; */
		return "";
    }

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
    public function DateField()
    {	
        super();
     //   addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
   // private var creatingDropdown:Boolean = false;

    /**
     *  @private
     */
   // mx_internal var showingDropdown:Boolean = false;

    /**
     *  @private
     */
   // private var inKeyDown:Boolean = false;

    /**
     *  @private
     */
   // private var isPressed:Boolean;

    /**
     *  @private
     */
  //  private var openPos:Number = 0;

    /**
     *  @private
     */
   // private var lastSelectedDate:Date;

    /**
     *  @private
     */
  //  private var updateDateFiller:Boolean = false;

    /**
     *  @private
     */
  //  private var addedToPopupManager:Boolean = false;

    /**
     *  @private
     */
  //  private var isMouseOver:Boolean = false;

    /**
     *  @private
     */ 
  //  private var yearChangedWithKeys:Boolean = false;
    
    /**
     *  @private
     *  Flag that will block default data/listData behavior
     */
  //  private var selectedDateSet:Boolean;

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
     *  Storage for the enabled property.
     */
    private var _enabled:Boolean = true;

    /**
     *  @private
     */
    private var enabledChanged:Boolean = false;

    [Bindable("enabledChanged")]
    [Inspectable(category="General", enumeration="true,false", defaultValue="true")]

    /**
     *  @private
     */
    override public function get enabled():Boolean
    {
        return _enabled;
    }

    /**
     *  @private
     */
    override public function set enabled(value:Boolean):void
    {
        if (value == _enabled)
            return;

        _enabled = value;
        super.enabled = value;
        enabledChanged = true;

       // invalidateProperties();
    }

    override protected function set textInput(value:Object):void
    {
        (view as DateFieldView).textInputField = value;
    }

    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  data
    //----------------------------------

    /**
     *  @private
     *  Storage for the data property
     */
  /*   private var _data:Object;

    [Bindable("dataChange")]
    [Inspectable(environment="none")] */

    /**
     *  The <code>data</code> property lets you pass a value
     *  to the component when you use it in an item renderer or item editor.
     *  You typically use data binding to bind a field of the <code>data</code>
     *  property to a property of this component.
     *
     *  <p>When you use the control as a drop-in item renderer or drop-in
     *  item editor, Flex automatically writes the current value of the item
     *  to the <code>selectedDate</code> property of this control.</p>
     *
     *  @default null
     *  @see mx.core.IDataRenderer
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    /* public function get data():Object
    {
        return _data;
    } */

    /**
     *  @private
     */
    /* public function set data(value:Object):void
    {
        var newDate:Date;

        _data = value;

        if (_listData && _listData is DataGridListData)
            newDate = _data[DataGridListData(_listData).dataField];
        else if (_listData is ListData && ListData(_listData).labelField in _data)
            newDate = _data[ListData(_listData).labelField];
        else if (_data is String)
			if (_parseFunction != null)
           	    newDate = _parseFunction(data as String, formatString);
			else
				newDate = new Date(Date.parse(data as String));
        else
            newDate = _data as Date;

        if (!selectedDateSet)
        {
            selectedDate = newDate;
            selectedDateSet = false;
        }

        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
    } */

    //----------------------------------
    //  dayNames
    //----------------------------------

    /**
     *  @private
     *  Storage for the dayNames property.
     */
   // private var _dayNames:Array;

    /**
     *  @private
     */
  //  private var dayNamesChanged:Boolean = false;

    /**
     *  @private
     */
  /*   private var dayNamesOverride:Array;
    
    [Bindable("dayNamesChanged")]
    [Inspectable(arrayType="String", defaultValue="null")] */

    /**
     *  Weekday names for DateChooser control.
     *  Setting this property changes the day labels
     *  of the DateChooser control.
     *  Sunday is the first day (at index 0).
     *  The rest of the week names follow in the normal order.
     *  
     *  @default [ "S", "M", "T", "W", "T", "F", "S" ]
     *  @helpid 3626
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
   /*  public function get dayNames():Array
    {
        return _dayNames;
    } */

    /**
     *  @private
     */
    /* public function set dayNames(value:Array):void
    {
        dayNamesOverride = value;

        _dayNames = value != null ?
                    value :
                    resourceManager.getStringArray(
                        "controls", "dayNamesShortest");
                        
        // _dayNames will be null if there are no resources.
        _dayNames = _dayNames ? _dayNames.slice(0) : null;

        dayNamesChanged = true;

        invalidateProperties();
    } */

    //----------------------------------
    //  disabledDays
    //----------------------------------

    /**
     *  @private
     *  Storage for the disabledDays property.
     */
   // private var _disabledDays:Array = [];

    /**
     *  @private
     */
    /* private var disabledDaysChanged:Boolean = false;

    [Bindable("disabledDaysChanged")]
    [Inspectable(arrayType="int")] */

    /**
     *  Days to disable in a week.
     *  All the dates in a month, for the specified day, are disabled.
     *  This property immediately changes the user interface
     *  of the DateChooser control.
     *  The elements of this Array can have values from 0 (Sunday)
     *  to 6 (Saturday).
     *  For example, a value of <code>[0, 6]</code> disables
     *  Sunday and Saturday.
     *
     *  @default []
     *  @helpid 3627
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    /* public function get disabledDays():Array
    {
        return _disabledDays;
    } */

    /**
     *  @private
     */
    /* public function set disabledDays(value:Array):void
    {
        _disabledDays = value;
        disabledDaysChanged = true;
        updateDateFiller = true;

        invalidateProperties();
    } */

    //----------------------------------
    //  disabledRanges
    //----------------------------------

    /**
     *  @private
     *  Storage for the disabledRanges property.
     */
   private var _disabledRanges:Array = [];

    /**
     *  @private
     */
    /* private var disabledRangesChanged:Boolean = false;

    [Bindable("disabledRangesChanged")]
    [Inspectable(arrayType="Object")] */

    /**
     *  Disables single and multiple days.
     *
     *  <p>This property accepts an Array of objects as a parameter.
     *  Each object in this Array is a Date object that specifies a
     *  single day to disable; or an object containing one or both
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
     *  To disable a single day, use a single Date object that specifies a date
     *  in the Array. Time values are zeroed out from the Date object if
     *  they are present.</p>
     *
     *  <p>The following example, disables the following dates: January 11
     *  2006, the range January 23 - February 10 2006, and March 1 2006
     *  and all following dates.</p>
     *
     *  <pre>disabledRanges="{[new Date(2006,0,11), {rangeStart:
     *  new Date(2006,0,23), rangeEnd: new Date(2006,1,10)},
     *  {rangeStart: new Date(2006,2,1)}]}"</pre>
     *
     *  <p>Setting this property immediately changes the appearance of the
     *  DateChooser control, if the disabled dates are included in the
     *  <code>displayedMonth</code> and <code>displayedYear</code>
     *  properties.</p>
     *
     *  @default []
     *  @helpid 3629
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get disabledRanges():Array
    {
        return _disabledRanges;
    }

    /**
     *  @private
     */
    public function set disabledRanges(value:Array):void
    {
        _disabledRanges = /*scrubTimeValues(*/value/*)*/;
    //    disabledRangesChanged = true;
    //    updateDateFiller = true;

    //    invalidateProperties();
    }

    //----------------------------------
    //  displayedMonth
    //----------------------------------

    /**
     *  @private
     *  Storage for the displayedMonth property.
     */
    //private var _displayedMonth:int = (new Date()).getMonth();

    /**
     *  @private
     */
   /*  private var displayedMonthChanged:Boolean = false;

    [Bindable("displayedMonthChanged")]
    [Inspectable(category="General")] */

    /**
     *  Used with the <code>displayedYear</code> property,
     *  the <code>displayedMonth</code> property
     *  specifies the month displayed in the DateChooser control.
     *  Month numbers are zero-based, so January is 0 and December is 11.
     *  Setting this property immediately changes the appearance
     *  of the DateChooser control.
     *  The default value is the month number of today's date.
     *
     *  <p>The default value is the current month.</p>
     *
     *  @helpid 3624
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    /* public function get displayedMonth():int
    {
        if (dropdown && dropdown.displayedMonth != _displayedMonth)
            return dropdown.displayedMonth;
        else
            return _displayedMonth;
    } */

    /**
     *  @private
     */
    /* public function set displayedMonth(value:int):void
    {
        _displayedMonth = value;
        displayedMonthChanged = true;

        invalidateProperties();
    } */

    //----------------------------------
    //  displayedYear
    //----------------------------------

    /**
     *  @private
     *  Storage for the displayedYear property.
     */
    private var _displayedYear:int = (new Date()).getFullYear();

    /**
     *  @private
     */
     private var displayedYearChanged:Boolean = false;

    [Bindable("displayedYearChanged")]
    [Inspectable(category="General")]
 
    /**
     *  Used with the <code>displayedMonth</code> property,
     *  the <code>displayedYear</code> property determines
     *  which year is displayed in the DateChooser control.
     *  Setting this property immediately changes the appearance
     *  of the DateChooser control.
     *  
     *  <p>The default value is the current year.</p>
     *
     *  @helpid 3625
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
   /*  public function get displayedYear():int
    {
        if (dropdown && dropdown.displayedYear != _displayedYear)
            return dropdown.displayedYear;
        else
            return _displayedYear;
    } */

    /**
     *  @private
     */
   /*  public function set displayedYear(value:int):void
    {
        _displayedYear = value;
        displayedYearChanged = true;

        invalidateProperties();
    } */

    //----------------------------------
    //  dropdown
    //----------------------------------

    /**
     *  Contains a reference to the DateChooser control
     *  contained by the DateField control.  The class used 
     *  can be set with <code>dropdownFactory</code> as long as 
     *  it extends <code>DateChooser</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get dropdown():DateChooser
    {
        return (view as DateFieldView).popUp as DateChooser;
    }

    //----------------------------------
    //  dropdownFactory
    //----------------------------------

    /**
     *  @private
     *  Storage for the dropdownFactory property.
     */
  /*   private var _dropdownFactory:IFactory = new ClassFactory(DateChooser);

    [Bindable("dropdownFactoryChanged")] */

    /**
     *  The IFactory that creates a DateChooser-derived instance to use
     *  as the date-chooser
     *  The default value is an IFactory for DateChooser
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
   /*  public function get dropdownFactory():IFactory
    {
        return _dropdownFactory;
    } */

    /**
     *  @private
     */
   /*  public function set dropdownFactory(value:IFactory):void
    {
        _dropdownFactory = value;

        dispatchEvent(new Event("dropdownFactoryChanged"));
    } */

    //----------------------------------
    //  firstDayOfWeek
    //----------------------------------

    /**
     *  @private
     *  Storage for the firstDayOfWeek property.
     */
   // private var _firstDayOfWeek:Object

    /**
     *  @private
     */
   /*  private var firstDayOfWeekChanged:Boolean = false;

    [Bindable("firstDayOfWeekChanged")]
    [Inspectable(defaultValue="0")] */

    /**
     *  @private
     */
    //private var firstDayOfWeekOverride:Object;
    
    /**
     *  Day of the week (0-6, where 0 is the first element
     *  of the dayNames Array) to display in the first column
     *  of the  DateChooser control.
     *  Setting this property changes the order of the day columns.
     *
     *  @default 0 (Sunday)
     *  @helpid 3623
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
   /*  public function get firstDayOfWeek():Object
    {
        return _firstDayOfWeek;
    } */

    /**
     *  @private
     */
    /* public function set firstDayOfWeek(value:Object):void
    {
        firstDayOfWeekOverride = value;

        _firstDayOfWeek = value != null ?
                          int(value) :
                          resourceManager.getInt(
                              "controls", "firstDayOfWeek");

        firstDayOfWeekChanged = true;

        invalidateProperties();
    } */

    //----------------------------------
    //  formatString
    //----------------------------------

    /**
     *  @private
     *  Storage for the formatString property.
     */
    private var _formatString:String = null;

    [Bindable("formatStringChanged")]
    [Inspectable(defaultValue="null")]

    /**
     *  @private
     */
    private var formatStringOverride:String;
    
    /**
     *  The format of the displayed date in the text field.
     *  This property can contain any combination of <code>"M"</code>,
	 *  <code>"MM"</code>, <code>"MMM"</code> (3 letter month names),
	 *  <code>"MMMM"</code> (month names), <code>"D"</code>, <code>"DD"</code>,
	 *  <code>"YY"</code>, <code>"YYYY"</code>,
     *  delimiter, and punctuation characters.
	 *  
	 *  <p>Only upper case characters are supported.</p>
     * 
     *  @default "MM/DD/YYYY"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get formatString():String
    {
        return _formatString;
    }

    /**
     *  @private
     */
    public function set formatString(value:String):void
    {
        formatStringOverride = value;

        _formatString = value /* != null ?
                        value :
                        resourceManager.getString(
                            "SharedResources", "dateFormat")*/;

        /*
        updateDateFiller = true;

        invalidateProperties();
        invalidateSize();
        
        dispatchEvent(new Event("formatStringChanged")); */
    }

    //----------------------------------
    //  labelFunction
    //----------------------------------

    /**
     *  @private
     *  Storage for the labelFunction property.
     */
    private var _labelFunction:Function;

    [Bindable("labelFunctionChanged")]
    [Inspectable(category="Data")]

    /**
     *  Function used to format the date displayed
     *  in the text field of the DateField control.
     *  If no function is specified, the default format is used.
     *  
     *  <p>The function takes a Date object as an argument,
     *  and returns a String in the format to be displayed, 
     *  as the following example shows:</p>
     *  <pre>
     *  public function formatDate(currentDate:Date):String {
     *      ...
     *      return dateString;
     *  }</pre>
     *
     *  <p>If you allow the user to enter a date in the text field
     *  of the DateField control, and you define a formatting function using 
     *  the <code>labelFunction</code> property, you should specify a 
     *  function to the <code>parseFunction</code> property that converts 
     *  the input text string to a Date object for use by the DateField control, 
     *  or set the <code>parseFunction</code> property to null.</p>
     *
     *  @default null
     *  @see mx.controls.DateField#parseFunction
     *  @helpid 3618
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get labelFunction():Function
    {
        return _labelFunction;
    }

    /**
     *  @private
     */
    public function set labelFunction(value:Function):void
    {
        _labelFunction = value;
       /* updateDateFiller = true;

         invalidateProperties();

        dispatchEvent(new Event("labelFunctionChanged")); */
    }

    //----------------------------------
    //  listData
    //----------------------------------

    /**
     *  @private
     *  Storage for the listData property
     */
  /*   private var _listData:BaseListData;

    [Bindable("dataChange")]
    [Inspectable(environment="none")] */

    /**
     *  When a component is used as a drop-in item renderer or drop-in
     *  item editor, Flex initializes the <code>listData</code> property
     *  of the component with the appropriate data from the List control.
     *  The component can then use the <code>listData</code> property
     *  to initialize the <code>data</code> property of the drop-in
     *  item renderer or drop-in item editor.
     *
     *  <p>You do not set this property in MXML or ActionScript;
     *  Flex sets it when the component is used as a drop-in item renderer
     *  or drop-in item editor.</p>
     *
     *  @default null
     *  @see mx.controls.listClasses.IDropInListItemRenderer
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    /* public function get listData():BaseListData
    {
        return _listData;
    } */

    /**
     *  @private
     */
    /* public function set listData(value:BaseListData):void
    {
        _listData = value;
    } */

    //----------------------------------
    //  maxYear
    //----------------------------------

    /**
     *  @private
     *  Storage for the maxYear property.
     */
    private var _maxYear:int = 2100;

    /**
     *  @private
     */
    private var maxYearChanged:Boolean = false;

    /**
     *  The last year selectable in the control.
     *  @default 2100
     *
     *  @helpid
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
     public function get maxYear():int
    {
        if (dropdown)
            return dropdown.maxYear;
        else
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
        maxYearChanged = true;

        invalidateProperties();
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
     *  @private
     */
    private var minYearChanged:Boolean = false;

    /**
     *  The first year selectable in the control.
     *  @default 1900
     *
     *  @helpid
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
     public function get minYear():int
    {
        if (dropdown)
            return dropdown.minYear;
        else
            return _minYear;
    } 

    /**
     *  @private
     */
     public function set minYear(value:int):void
    {
        if (_displayedYear == value)
            return;

        _minYear = value;
        minYearChanged = true;

        invalidateProperties();
    } 

    //----------------------------------
    //  monthNames
    //----------------------------------

    /**
     *  @private
     *  Storage for the monthNames property.
     */
    //private var _monthNames:Array;

    /**
     *  @private
     */
   // private var monthNamesChanged:Boolean = false;

    /**
     *  @private
     */
   /*  private var monthNamesOverride:Array;
    
    [Bindable("monthNamesChanged")]
    [Inspectable(category="Other", arrayType="String", defaultValue="null")]
 */
    /**
     *  Names of the months displayed at the top of the control.
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
    /* public function get monthNames():Array
    {
        return _monthNames;
    } */

    /**
     *  @private
     */
    /* public function set monthNames(value:Array):void
    {
        monthNamesOverride = value;

        _monthNames = value != null ?
                      value :
                      resourceManager.getStringArray(
                          "SharedResources", "monthNames");
                         
        // _monthNames will be null if there are no resources.
        _monthNames = _monthNames ? _monthNames.slice(0) : null;

        monthNamesChanged = true;

        invalidateProperties();
    } */

    //----------------------------------
    //  monthSymbol
    //----------------------------------

    /**
     *  @private
     *  Storage for the monthSymbol property.
     */
    //private var _monthSymbol:String;

    /**
     *  @private
     */
    //private var monthSymbolChanged:Boolean = false;

    /**
     *  @private
     */
    /* private var monthSymbolOverride:String;
    
    [Bindable("monthSymbolChanged")]
    [Inspectable(defaultValue="")] */

    /**
     *  This property is appended to the end of the value specified 
     *  by the <code>monthNames</code> property to define the names 
     *  of the months displayed at the top of the control.
     *  Some languages, such as Japanese, use an extra 
     *  symbol after the month name. 
     *
     *  @default ""
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    /* public function get monthSymbol():String
    {
        return _monthSymbol;
    }
 */
    /**
     *  @private
     */
    /* public function set monthSymbol(value:String):void
    {
        monthSymbolOverride = value;

        _monthSymbol = value != null ?
                       value :
                       resourceManager.getString(
                           "SharedResources", "monthSymbol");

        monthSymbolChanged = true;

        invalidateProperties();
    } */
      
    //----------------------------------
    //  parseFunction
    //----------------------------------

    /**
     *  @private
     *  Storage for the parseFunction property.
     */
   /*  private var _parseFunction:Function = DateField.stringToDate;

    [Bindable("parseFunctionChanged")] */

    /**
     *  Function used to parse the date entered as text
     *  in the text field area of the DateField control and return a 
     *  Date object to the control.
     *  If no function is specified, Flex uses
     *  the default function.
     *  If you set the <code>parseFunction</code> property, it should 
     *  typically perform the reverse of the function specified to 
     *  the <code>labelFunction</code> property.
     *  
     *  <p>The function takes two arguments 
     *  and returns a Date object to the DateField control, 
     *  as the following example shows:</p>
     *  <pre>
     *  public function parseDate(valueString:String, inputFormat:String):Date {
     *      ...
     *      return newDate
     *  }</pre>
     * 
     *  <p>Where the <code>valueString</code> argument contains the text 
     *  string entered by the user in the text field, and the <code>inputFormat</code> 
     *  argument contains the format of the string. For example, if you 
     *  only allow the user to enter a text sting using two characters for 
     *  month, day, and year, then pass "MM/DD/YY" to 
     *  the <code>inputFormat</code> argument.</p>
     *
     *  @see mx.controls.DateField#labelFunction
     * 
     *  @helpid
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
   /*  public function get parseFunction():Function
    {
        return _parseFunction;
    } */

    /**
     *  @private
     */
    /* public function set parseFunction(value:Function):void
    {
        _parseFunction = value;

        dispatchEvent(new Event("parseFunctionChanged"));
    } */

    //----------------------------------
    //  selectableRange
    //----------------------------------

    /**
     *  @private
     *  Storage for the selectableRange property.
     */
   // private var _selectableRange:Object = null;

    /**
     *  @private
     */
   /*  private var selectableRangeChanged:Boolean = false;

    [Bindable("selectableRangeChanged")]
    [Inspectable(arrayType="Date")] */

    /**
     *  Range of dates between which dates are selectable.
     *  For example, a date between 04-12-2006 and 04-12-2007
     *  is selectable, but dates out of this range are disabled.
     *
     *  <p>This property accepts an Object as a parameter.
     *  The Object contains two properties, <code>rangeStart</code>
     *  and <code>rangeEnd</code>, of type Date.
     *  If you specify only <code>rangeStart</code>,
     *  all the dates after the specified date are enabled.
     *  If you only specify <code>rangeEnd</code>,
     *  all the dates before the specified date are enabled.
     *  To enable only a single day in a DateChooser control,
     *  you can pass a Date object directly. Time values are 
     *  zeroed out from the Date object if they are present.</p>
     *
     *  <p>The following example enables only the range
     *  January 1, 2006 through June 30, 2006. Months before January
     *  and after June do not appear in the DateChooser.</p>
     *
     *  <pre>selectableRange="{{rangeStart : new Date(2006,0,1),
     *  rangeEnd : new Date(2006,5,30)}}"</pre>
     *
     *  @default null
     *  @helpid 3628
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    /* public function get selectableRange():Object
    {
        return _selectableRange;
    }
 */
    /**
     *  @private
     */
    /* public function set selectableRange(value:Object):void
    {
        _selectableRange = scrubTimeValue(value);
        selectableRangeChanged = true;
        updateDateFiller = true;

        invalidateProperties();
    } */

    //----------------------------------
    //  selectedDate
    //----------------------------------

    [Bindable("change")]
    [Bindable("valueCommit")]
    [Bindable("selectedDateChanged")]
    [Inspectable(category="General")]

    /**
     *  Date as selected in the DateChooser control.
     *  Accepts a Date object as a parameter. If the incoming Date 
     *  object has any time values, they are zeroed out.
     *
     *  <p>Holding down the Control key when selecting the currently selected date deselects it, 
     *  sets the <code>selectedDate</code> property to <code>null</code>, 
     *  and then dispatches the <code>change</code> event.</p>
     *
     *  @default null
     *  @helpid 3630
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectedDate():Date
    {
        return (model as IDateChooserModel).selectedDate;
    }

    /**
     *  @private
     */
    public function set selectedDate(value:Date):void
    {
        (model as IDateChooserModel).selectedDate = value;
       /*  if (ObjectUtil.dateCompare(_selectedDate, value) == 0) 
            return;

        selectedDateSet = true;
        checkYearSetSelectedDate(scrubTimeValue(value) as Date);
        updateDateFiller = true;
        selectedDateChanged = true;

        invalidateProperties();

        // Trigger bindings to 'selectedData'.
        dispatchEvent(new Event("selectedDateChanged"));
       
        dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));  */   
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
     *  Setting this property immediately changes the appearance
     *  of the DateChooser control.
     *
     *  @default true
     *  @helpid 3622
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

        //invalidateProperties();
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
    private var yearNavigationEnabledChanged:Boolean = false;

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
        yearNavigationEnabledChanged = true;

      // invalidateProperties();
    }

    //----------------------------------
    //  yearSymbol
    //----------------------------------

    /**
     *  @private
     *  Storage for the yearSymbol property.
     */
   // private var _yearSymbol:String;

    /**
     *  @private
     */
    //private var yearSymbolChanged:Boolean = false;

    /**
     *  @private
     */
   /*  private var yearSymbolOverride:String;
    
    [Bindable("yearSymbolChanged")]
    [Inspectable(defaultValue="")]
 */
    /**
     *  This property is appended to the end of the year 
     *  displayed at the top of the control.
     *  Some languages, such as Japanese, 
     *  add a symbol after the year. 
     *
     *  @default ""
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    /* public function get yearSymbol():String
    {
        return _yearSymbol;
    } */

    /**
     *  @private
     */
    /* public function set yearSymbol(value:String):void
    {
        yearSymbolOverride = value;

        _yearSymbol = value != null ?
                      value :
                      resourceManager.getString(
                          "controls", "yearSymbol");

        yearSymbolChanged = true;

        invalidateProperties();
    } */
  
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    /* override protected function initializeAccessibility():void
    {
        if (DateField.createAccessibilityImplementation != null)
            DateField.createAccessibilityImplementation(this);
    } */

    /**
     *  @private
     *  Create subobjects in the component.
     */
    override protected function createChildren():void
    {
        super.createChildren();

        /* createDropdown();

        downArrowButton.setStyle("paddingLeft", 0);
        downArrowButton.setStyle("paddingRight", 0);
        textInput.editable = false;
        textInput.mouseChildren = true;
        textInput.mouseEnabled = true;
        textInput.addEventListener(TextEvent.TEXT_INPUT, textInput_textInputHandler);
		
        // hide the border, we use the text input's border
        if (border)
            border.visible = false; */

    }

    /**
     *  @private
     */
    /* override protected function commitProperties():void
    {
        if (enabledChanged)
        {
            enabledChanged = false;
            dispatchEvent(new Event("enabledChanged"));
        }

        if (dayNamesChanged)
        {
            dayNamesChanged = false;
            // _dayNames will be null if there are no resources.
            dropdown.dayNames = _dayNames ? _dayNames.slice(0) : null;
            dispatchEvent(new Event("dayNamesChanged"));
        }

        if (disabledDaysChanged)
        {
            disabledDaysChanged = false;
            dropdown.disabledDays = _disabledDays.slice(0);
            dispatchEvent(new Event("disabledDaysChanged"));
        }

        if (disabledRangesChanged)
        {
            disabledRangesChanged = false;
            dropdown.disabledRanges = _disabledRanges.slice(0);
            dispatchEvent(new Event("disabledRangesChanged"));
        }

        if (displayedMonthChanged)
        {
            displayedMonthChanged = false;
            dropdown.displayedMonth = _displayedMonth;
            dispatchEvent(new Event("displayedMonthChanged"));
        }

        if (displayedYearChanged)
        {
            displayedYearChanged = false;
            dropdown.displayedYear = _displayedYear;
            dispatchEvent(new Event("displayedYearChanged"));
        }

        if (firstDayOfWeekChanged)
        {
            firstDayOfWeekChanged = false;
            dropdown.firstDayOfWeek = _firstDayOfWeek;
            dispatchEvent(new Event("firstDayOfWeekChanged"));
        }

        if (minYearChanged)
        {
            minYearChanged = false;
            dropdown.minYear = _minYear;
        }

        if (maxYearChanged)
        {
            maxYearChanged = false;
            dropdown.maxYear = _maxYear;
        }

        if (monthNamesChanged)
        {
            monthNamesChanged = false;
            // _monthNames will be null if there are no resources.
            dropdown.monthNames = _monthNames ? _monthNames.slice(0) : null;
            dispatchEvent(new Event("monthNamesChanged"));
        }

        if (selectableRangeChanged)
        {
            selectableRangeChanged = false;
            dropdown.selectableRange = _selectableRange is Array ? _selectableRange.slice(0) : _selectableRange;
            dispatchEvent(new Event("selectableRangeChanged"));
        }

        if (selectedDateChanged)
        {
            selectedDateChanged = false;
            dropdown.selectedDate = _selectedDate;
        }

        if (showTodayChanged)
        {
            showTodayChanged = false;
            dropdown.showToday = _showToday;
            dispatchEvent(new Event("showTodayChanged"));
        }

        if (updateDateFiller)
        {
            updateDateFiller = false;
            dateFiller(_selectedDate);
        }

        if (yearNavigationEnabledChanged)
        {
            yearNavigationEnabledChanged = false;
            dropdown.yearNavigationEnabled = _yearNavigationEnabled;
            dispatchEvent(new Event("yearNavigationEnabledChanged"));
        }

        if (yearSymbolChanged)
        {
            yearSymbolChanged = false;
            dropdown.yearSymbol = _yearSymbol;
            dispatchEvent(new Event("yearSymbolChanged"));
        }
        
        if (monthSymbolChanged)
        {
            monthSymbolChanged = false;
            dropdown.monthSymbol = _monthSymbol;
            dispatchEvent(new Event("monthSymbolChanged"));
        }

        super.commitProperties();
    } */

    override public function get measuredHeight():Number
    {
        _measuredHeight = Math.max(((view as DateFieldView).textInputField as TextInput).height,
            ((view as DateFieldView).popupButton as IUIBase).height);
        return _measuredHeight;
    }
    
    override public function get measuredWidth():Number
    {
        _measuredWidth = ((view as DateFieldView).textInputField as TextInput).width +
            ((view as DateFieldView).popupButton as IUIBase).width;        
        return _measuredWidth;
    }
    
    /* override protected function measure():void
    {
        // skip base class, we do our own calculation here
        // super.measure();

        var buttonWidth:Number = downArrowButton.getExplicitOrMeasuredWidth();
        var buttonHeight:Number = downArrowButton.getExplicitOrMeasuredHeight();

        var bigDate:Date;
        var txt:String;
		var textWidth:Number;
		var maxWidth:Number = 0;
		
		// Width may vary based on date format
		for (var month:int = 0; month < 12; month++) {
			bigDate = new Date(2000, month, 28); // day 28 exist in all months
			txt = (_labelFunction != null) ? _labelFunction(bigDate) : dateToString(bigDate, formatString);
			textWidth = measureText(txt).width;
			if (textWidth > maxWidth) {
				maxWidth = textWidth;
			}
		}

        measuredMinWidth = measuredWidth = maxWidth + 8 + buttonWidth +
			+ getStyle("paddingLeft") + getStyle("paddingRight")
			+ textInput.getStyle("paddingLeft") + textInput.getStyle("paddingRight");
        measuredMinHeight = measuredHeight = textInput.getExplicitOrMeasuredHeight();
    } */

    /**
     *  @private
     */
    /* override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        var w:Number = unscaledWidth;
        var h:Number = unscaledHeight;

        var arrowWidth:Number = downArrowButton.getExplicitOrMeasuredWidth();
        var arrowHeight:Number = downArrowButton.getExplicitOrMeasuredHeight();

        downArrowButton.setActualSize(arrowWidth, arrowHeight);
        downArrowButton.move(w - arrowWidth, Math.round((h - arrowHeight) / 2));

        textInput.setActualSize(w - arrowWidth - 2, h);
    } */

    /**
     *  @private
     */
    /* override public function styleChanged(styleProp:String):void
    {
        super.styleChanged(styleProp);
   
        if (dropdown)
            dropdown.styleChanged(styleProp);
   
        if (styleProp == null ||
            styleProp == "styleName" ||
            styleProp == "dateChooserStyleName")
        {
            if (dropdown)
            {
                var dateChooserStyleName:String = getStyle(
                            "dateChooserStyleName");
   
                if (dateChooserStyleName)
                {
                    var styleDecl:CSSStyleDeclaration =
                    styleManager.getMergedStyleDeclaration("." + dateChooserStyleName);
                
                    if (styleDecl)
                    {
                        _dropdown.styleDeclaration = styleDecl;
                        _dropdown.regenerateStyleCache(true);
                    }
                }
            } 
        }
    } */

    /**
     *  @private
     */
    /* override public function notifyStyleChangeInChildren(
                                styleProp:String, recursive:Boolean):void
    {
        super.notifyStyleChangeInChildren(styleProp, recursive);

        if (dropdown)
            dropdown.notifyStyleChangeInChildren(styleProp, recursive);
    } */

    /**
     *  @private
     */
    /* override public function regenerateStyleCache(recursive:Boolean):void
    {
        super.regenerateStyleCache(recursive);

        if (dropdown)
            dropdown.regenerateStyleCache(recursive);
    } */

    /**
     *  @private
     */
    /* override protected function resourcesChanged():void
    {
        super.resourcesChanged();

        dayNames = dayNamesOverride;
        firstDayOfWeek = firstDayOfWeekOverride;
        formatString = formatStringOverride;
        monthNames = monthNamesOverride;
        monthSymbol = monthSymbolOverride;
        yearSymbol = yearSymbolOverride;
    } */

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Opens the DateChooser control.
     *
     *  @helpid 3620
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    /* public function open():void
    {
        displayDropdown(true);
    } */

    /**
     *  Closes the DateChooser control.
     *
     *  @helpid 3621
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    /* public function close():void
    {
        displayDropdown(false);
    } */
	
	/* private function checkYearSetSelectedDate(value:Date):void {
		if (value != null)
		{
			var year:int = value.getFullYear();
			
			if (year >= _minYear && year <= _maxYear)
				_selectedDate = value;	
		}
		else
		{
			_selectedDate = null;
		}
	} */

    /**
     *  @private
     */
   /*  private function displayDropdown(show:Boolean, triggerEvent:Event = null):void
    {
        if (!_enabled)
            return;

        if (show == showingDropdown)
            return;

        if (!addedToPopupManager)
        {
            addedToPopupManager = true;
            PopUpManager.addPopUp(_dropdown, this, false);
        }
        else
		{
            PopUpManager.bringToFront(_dropdown);
		}

        // Subclasses may extend to do pre-processing
        // before the dropdown is displayed
        // or override to implement special display behavior.
        //var point = {};
        // point x will exactly appear on the icon.
        // Leaving 1 pixel for the border to appear.
        var xPos:Number = (layoutDirection == LayoutDirection.RTL ? 
                          dropdown.getExplicitOrMeasuredWidth() : 0) 
                          + unscaledWidth - downArrowButton.width; 
        
        var point:Point = new Point(xPos, 0);
        point = localToGlobal(point);
        if (show)
        {
            if (_parseFunction != null)
                checkYearSetSelectedDate(_parseFunction(text, formatString));
            lastSelectedDate = _selectedDate;
            selectedDate_changeHandler(triggerEvent);

            var dd:DateChooser = dropdown;

            if (_dropdown.selectedDate)
            {
                _dropdown.displayedMonth = _dropdown.selectedDate.getMonth();
                _dropdown.displayedYear = _dropdown.selectedDate.getFullYear();
            }
            dd.visible = show;
            dd.scaleX = scaleX;
            dd.scaleY = scaleY;

            var xVal:Number = point.x;
            var yVal:Number = point.y;

            //handling of dropdown position
            // A. Bottom Left Placment
            // B. Bottom Right Placement
            // C. Top Right Placement
            var sm:ISystemManager = systemManager.topLevelSystemManager;
            var screen:Rectangle = sm.getVisibleApplicationRect(null, true);

            if (screen.right > dd.getExplicitOrMeasuredWidth() + point.x &&
                screen.bottom < dd.getExplicitOrMeasuredHeight() + point.y)
            {
                xVal = point.x
                yVal = point.y - dd.getExplicitOrMeasuredHeight();
                openPos = 1;
            }
            else if (screen.right < dd.getExplicitOrMeasuredWidth() + point.x &&
                     screen.bottom < dd.getExplicitOrMeasuredHeight() + point.y)
            {
                xVal = point.x - dd.getExplicitOrMeasuredWidth() + downArrowButton.width;
                yVal = point.y - dd.getExplicitOrMeasuredHeight();
                openPos = 2;
            }
            else if (screen.right < dd.getExplicitOrMeasuredWidth() + point.x &&
                     screen.bottom > dd.getExplicitOrMeasuredHeight() + point.y)
            {
                xVal = point.x - dd.getExplicitOrMeasuredWidth() + downArrowButton.width;
                yVal = point.y + unscaledHeight;
                openPos = 3;
            }
			else
			{
                // Why do we need to disable downArrowButton when its hidden?
                //downArrowButton.enabled = false;
                openPos = 0;
			}

            xVal = Math.max(screen.left, xVal);
            
            point.x = xVal;
            point.y = yVal;
            point = dd.parent.globalToLocal(point);
            UIComponentGlobals.layoutManager.validateClient(dd, true);
            dd.move(point.x, point.y);
            Object(dd).setActualSize(dd.getExplicitOrMeasuredWidth(),dd.getExplicitOrMeasuredHeight());

        }
        else
        {
            _dropdown.visible = false;
        }

        showingDropdown = show;

        var event:DropdownEvent =
            new DropdownEvent(show ? DropdownEvent.OPEN : DropdownEvent.CLOSE);
        event.triggerEvent = triggerEvent;
        dispatchEvent(event);
    }
 */
    /**
     *  @private
     */
    /* private function createDropdown():void
    {
        if (creatingDropdown)
            return;

        creatingDropdown = true;

        _dropdown = dropdownFactory.newInstance();
        _dropdown.focusEnabled = false;
        _dropdown.owner = this;
        _dropdown.moduleFactory = moduleFactory;
        var todaysDate:Date = new Date();
        _dropdown.displayedMonth = todaysDate.getMonth();
        _dropdown.displayedYear = todaysDate.getFullYear();

        _dropdown.styleName = new StyleProxy(this, {}); 
        
        var dateChooserStyleName:Object = getStyle("dateChooserStyleName");
        if (dateChooserStyleName)
        {
            var styleDecl:CSSStyleDeclaration =
            styleManager.getMergedStyleDeclaration("." + dateChooserStyleName);

            if (styleDecl)
                _dropdown.styleDeclaration = styleDecl;
        }

        _dropdown.visible = false;

        _dropdown.addEventListener(CalendarLayoutChangeEvent.CHANGE,
                                   dropdown_changeHandler);
        _dropdown.addEventListener(DateChooserEvent.SCROLL,
                                   dropdown_scrollHandler);
        _dropdown.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,
                                   dropdown_mouseDownOutsideHandler);
        _dropdown.addEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE,
                                   dropdown_mouseDownOutsideHandler);
        _dropdown.addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,
                                   dropdown_mouseDownOutsideHandler);
        _dropdown.addEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE,
                                   dropdown_mouseDownOutsideHandler);
        
        creatingDropdown = false;
    } */

    /**
     *  @private
     *  This is the default date format that is displayed
     *  if labelFunction is not defined.
     */
    /* private function dateFiller(value:Date):void
    {
        if (_labelFunction != null)
            textInput.text = labelFunction(value);
        else
            textInput.text = dateToString(value, formatString);
    } */
    
    /**
     *  @private
     *  This method scrubs out time values from incoming date objects
     */ 
    /*  private function scrubTimeValue(value:Object):Object
     {
        if (value is Date)
        {
            return new Date(value.getFullYear(), value.getMonth(), value.getDate());
        }
        else if (value is Object) 
        {
            var range:Object = {};
            if (value.rangeStart)
            {
                range.rangeStart = new Date(value.rangeStart.getFullYear(), 
                                            value.rangeStart.getMonth(), 
                                            value.rangeStart.getDate());
            }
            
            if (value.rangeEnd)
            {
                range.rangeEnd = new Date(value.rangeEnd.getFullYear(), 
                                          value.rangeEnd.getMonth(), 
                                          value.rangeEnd.getDate());
            }
            return range;
        }
        return null;
     } */
     
     /**
     *  @private
     *  This method scrubs out time values from incoming date objects
     */ 
     /* private function scrubTimeValues(values:Array):Array
     {
         var dates:Array = [];
         for (var i:int = 0; i < values.length; i++)
         {
            dates[i] = scrubTimeValue(values[i]);
         }
         return dates;
     } */
      
    //--------------------------------------------------------------------------
    //
    //  Overridden event handlers: UIComponent
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
   /*  override protected function focusOutHandler(event:FocusEvent):void
    {
        if (showingDropdown && event != null &&
            this.contains(DisplayObject(event.target)))
            displayDropdown(false);

        super.focusOutHandler(event);

        if (_parseFunction != null)
            checkYearSetSelectedDate(_parseFunction(text, formatString));
        
        selectedDate_changeHandler(event);
    } */

    /**
     *  @private
     */
    /* override protected function keyDownHandler(event:KeyboardEvent):void
    {
        if (event.ctrlKey && event.keyCode == Keyboard.DOWN)
        {
            displayDropdown(true, event);
            event.stopPropagation();
        }
        else if (event.ctrlKey && event.keyCode == Keyboard.UP)
        {
            if (showingDropdown)
                selectedDate = lastSelectedDate;
            displayDropdown(false, event);
            event.stopPropagation();
        }
        else if (event.keyCode == Keyboard.ESCAPE)
        {
            if (showingDropdown) {
                selectedDate = lastSelectedDate;
            	displayDropdown(false, event);
				if (!editable)
           			event.stopPropagation();
			}
        }
        else if (event.keyCode == Keyboard.ENTER)
        {
            if (showingDropdown)
            {
               checkYearSetSelectedDate(_dropdown.selectedDate);
                displayDropdown(false, event);
                event.stopPropagation();
            }
            else if (editable)
            {
                if (_parseFunction != null)
                  checkYearSetSelectedDate(_parseFunction(text, formatString));
            }
            selectedDate_changeHandler(event);
        }
        else if (event.keyCode == Keyboard.UP ||
                 event.keyCode == Keyboard.DOWN ||
                 event.keyCode == Keyboard.LEFT ||
                 event.keyCode == Keyboard.RIGHT ||
                 event.keyCode == Keyboard.PAGE_UP ||
                 event.keyCode == Keyboard.PAGE_DOWN ||
                 event.keyCode == 189 || // - or _ key used to step down year
                 event.keyCode == 187 || // + or = key used to step up year
                 event.keyCode == Keyboard.HOME ||
                 event.keyCode == Keyboard.END)
        {
            if (showingDropdown)
            {
                if (yearNavigationEnabled &&
                    (event.keyCode == 189 || event.keyCode == 187)) 
                    yearChangedWithKeys = true;
                inKeyDown = true;
                // Redispatch the event to the DateChooser
                // and let its keyDownHandler() handle it.
                dropdown.dispatchEvent(event);
                inKeyDown = false;              
                // Prevent keys from moving scrollBars.
                event.stopPropagation();
            }
        }
    } */

    //--------------------------------------------------------------------------
    //
    //  Overridden event handlers: ComboBase
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    /* override protected function downArrowButton_buttonDownHandler(
                                    event:FlexEvent):void
    {
        // The down arrow should always toggle the visibility of the dropdown.
        callLater(displayDropdown, [ !showingDropdown, event ]);

        // We hide the down arrow with the dropdown so the down arrow
        // never gets a release, so it is in the wrong state.
        // Force the state to be released:
        downArrowButton.phase = "up";
    }
     */
    /**
     *  @private
     */
    /* override protected function textInput_changeHandler(event:Event):void
    {
        super.textInput_changeHandler(event);
        
        var inputDate:Date = _parseFunction(text, formatString);
        if (inputDate)
           checkYearSetSelectedDate(inputDate);
    } */

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
   /*  private function removedFromStageHandler(event:Event):void
    {
        // Ensure we've unregistered ourselves from PopupManager, else
        // we'll be leaked.
        addedToPopupManager = false;
        PopUpManager.removePopUp(_dropdown);
    } */

    /**
     *  @private
     */
    /* private function dropdown_changeHandler(
                        event:CalendarLayoutChangeEvent):void
    {
        // If this was generated by the dropdown as a result of a keystroke,
        // it is likely a Page-Up or Page-Down, or Arrow-Up or Arrow-Down.
        // If the selection changes due to a keystroke,
        // we leave the dropdown displayed.
        // If it changes as a result of a mouse selection,
        // we close the dropdown.
        if (!inKeyDown)
            displayDropdown(false);

        // Nothing to do if the dates are the same.
        if (ObjectUtil.dateCompare(_selectedDate, dropdown.selectedDate) == 0)
            return;

        checkYearSetSelectedDate(dropdown.selectedDate);

        if (_selectedDate)
            dateFiller(_selectedDate);
        else
            textInput.text = "";
        
        var e:CalendarLayoutChangeEvent = new 
            CalendarLayoutChangeEvent(CalendarLayoutChangeEvent.CHANGE);        
        e.newDate = event.newDate;
        e.triggerEvent = event.triggerEvent;
        dispatchEvent(e);                   
    } */

    /**
     *  @private
     */
    /* private function dropdown_scrollHandler(event:DateChooserEvent):void
    {
        dispatchEvent(event);
    } */

    /**
     *  @private
     */
    /* private function dropdown_mouseDownOutsideHandler(event:Event):void
    {
        if (event is MouseEvent)
        {
            var mouseEvent:MouseEvent = MouseEvent(event);

            if (! hitTestPoint(mouseEvent.stageX, mouseEvent.stageY, true))
                displayDropdown(false, event);
        }
        else if (event is SandboxMouseEvent) 
		{
            displayDropdown(false, event);
		}
            
    } */

    /**
     *  @private
     *  Handling change in selectedDate due to user interaction.
     */
    /* private function selectedDate_changeHandler(triggerEvent:Event):void
    {
        if (!dropdown.selectedDate && !_selectedDate)
            return;

        if (_selectedDate)
            dateFiller(_selectedDate);

        if (dropdown.selectedDate && _selectedDate &&
            dropdown.selectedDate.getFullYear() == _selectedDate.getFullYear() &&
            dropdown.selectedDate.getMonth() == _selectedDate.getMonth() &&
            dropdown.selectedDate.getDate() == _selectedDate.getDate())
            return;

        dropdown.selectedDate = _selectedDate;

        var changeEvent:CalendarLayoutChangeEvent =
            new CalendarLayoutChangeEvent(CalendarLayoutChangeEvent.CHANGE);
        changeEvent.newDate = _selectedDate;
        changeEvent.triggerEvent = triggerEvent;
        dispatchEvent(changeEvent);
    } */

    /**
     *  @private
     */ 
    /* private function textInput_textInputHandler(event:TextEvent):void
    {
            if (yearChangedWithKeys)
            {
                event.preventDefault();
                yearChangedWithKeys = false;
            }
    } */

    /**
     *  @private
     */
    /* mx_internal function isShowingDropdown():Boolean
    {
        return showingDropdown;
    } */

    /**
     *  @private
     */
    override public function get text():String
    {
        var s:String = ((view as DateFieldView).textInputField as TextInput).text;
        return s == null ? "" : s;
    }
   
    override public function setFocus():void
    {
        return (view as DateFieldView).setFocus();
        
    }
}

}
