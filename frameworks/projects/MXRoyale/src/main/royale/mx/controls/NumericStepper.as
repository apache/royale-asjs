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
	
import org.apache.royale.core.IRangeModel;
import org.apache.royale.events.Event;

/*
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TextEvent;
import flash.text.TextField;
import flash.text.TextLineMetrics;
import flash.ui.Keyboard;
*/
import mx.controls.listClasses.BaseListData;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.IListItemRenderer;
/*
import mx.core.FlexVersion;
*/
import mx.core.IDataRenderer;
/*
import mx.core.IFlexDisplayObject;
import mx.core.IIMESupport;
import mx.core.ITextInput;
*/
import mx.core.UIComponent;
/*
import mx.core.UITextField;
import mx.core.mx_internal;
*/
import mx.events.FlexEvent;
import mx.events.NumericStepperEvent;
import mx.managers.IFocusManagerComponent;
/*
import mx.managers.IFocusManager;
import mx.styles.StyleProxy;

use namespace mx_internal;
*/
import mx.controls.beads.NumericStepperView;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the value of the NumericStepper control changes
 *  as a result of user interaction.
 *
 *  @eventType mx.events.NumericStepperEvent.CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="change", type="mx.events.NumericStepperEvent")]

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
[Event(name="dataChange", type="mx.events.FlexEvent")]

/**
 *  The NumericStepper control lets the user select
 *  a number from an ordered set.
 *  The NumericStepper control consists of a single-line
 *  input text field and a pair of arrow buttons
 *  for stepping through the possible values.
 *  The Up Arrow and Down Arrow keys also cycle through the values.
 *
 *  <p>The NumericStepper control has the following default characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>Wide enough to display the maximum number of digits used by the control</td>
 *        </tr>
 *        <tr>
 *           <td>Minimum size</td>
 *           <td>Based on the size of the text.</td>
 *        </tr>
 *        <tr>
 *           <td>Maximum size</td>
 *           <td>Undefined</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *
 *  The <code>&lt;mx:NumericStepper&gt;</code> tag inherits all of the tag
 *  attributes of its superclass, and adds the following tag attributes:
 *
 *  <pre>
 *  &lt;mx:NumericStepper
 *    <strong>Properties</strong>
 *    imeMode="null"
 *    maxChars="10"
 *    maximum="10"
 *    minimum="0"
 *    stepSize="1"
 *    value="0"
 *  
 *    <strong>Styles</strong>
 *    backgroundAlpha="1.0"
 *    backgroundColor="undefined"
 *    backgroundImage="undefined"
 *    backgroundSize="auto"
 *    borderColor="0xAAB3B3"
 *    borderSides="left top right bottom"
 *    borderSkin="HaloBorder"
 *    borderStyle="inset"
 *    borderThickness="1"
 *    color="0x0B333C"
 *    cornerRadius="0"
 *    disabledColor="0xAAB3B3"
 *    disabledIconColor="0x999999"
 *    downArrowDisabledSkin="NumericStepperDownSkin"
 *    downArrowDownSkin="NumericStepperDownSkin"
 *    downArrowOverSkin="NumericStepperDownSkin"
 *    downArrowUpSkin="NumericStepperDownSkin"
 *    dropShadowEnabled="false"
 *    dropShadowColor="0x000000"
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
 *    highlightAlphas="[0.3,0.0]"
 *    iconColor="0x111111"
 *    leading="2"
 *    paddingLeft="0"
 *    paddingRight="0"
 *    shadowDirection="center"
 *    shadowDistance="2"
 *    textAlign="left|center|right"
 *    textDecoration="none|underline"
 *    textIndent="0"
 *    upArrowDisabledSkin="NumericStepperUpSkin"
 *    upArrowDownSkin="NumericStepperUpSkin"
 *    upArrowOverSkin="NumericStepperUpSkin"
 *    upArrowUpSkin="NumericStepperUpSkin"
 *  
 *    <strong>Events</strong>
 *    change="<i>No default</i>"
 *    dataChange="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *
 *  @includeExample examples/NumericStepperExample.mxml
 *
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class NumericStepper extends UIComponent
                            implements IDataRenderer, IDropInListItemRenderer,
                            IFocusManagerComponent, /*IIMESupport,*/
                            IListItemRenderer
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
    public function NumericStepper()
    {
        super();
		typeNames = "NumericStepper";
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Flag that will block default data/listData behavior
     */
    private var valueSet:Boolean;

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------


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
     *  Storage for the data property.
     */
    private var _data:Object;

    [Bindable("dataChange")]
    [Inspectable(environment="none")]

    /**
     *  The <code>data</code> property lets you pass a value to the component
     *  when you use it in an item renderer or item editor.
     *  You typically use data binding to bind a field of the <code>data</code>
     *  property to a property of this component.
     *
     *  <p>When you use the control as a drop-in item renderer or drop-in
     *  item editor, Flex automatically writes the current value of the item
     *  to the <code>value</code> property of this control.</p>
     *
     *  @default null
     *  @see mx.core.IDataRenderer
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get data():Object
    {
        if (!_listData)
            data = this.value;

        return _data;
    }

    /**
     *  @private
     */
    public function set data(value:Object):void
    {
        _data = value;

        if (!valueSet)
        {
            this.value = _listData ? parseFloat(_listData.label) : Number(_data);
            valueSet = false;
        }

        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
    }

    //----------------------------------
    //  listData
    //----------------------------------

    /**
     *  @private
     *  Storage for the listData property.
     */
    private var _listData:Object;

    [Bindable("dataChange")]
    [Inspectable(environment="none")]

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
    public function get listData():Object
    {
        return _listData;
    }

    /**
     *  @private
     */
    public function set listData(value:Object):void
    {
        _listData = value;
    }

    //----------------------------------
    //  maxChars
    //----------------------------------

    /**
     *  @private
     *  Storage for the maxChars property.
     */
    private var _maxChars:int = 0;

    [Bindable("maxCharsChanged")]

    /**
     *  The maximum number of characters that can be entered in the field.
     *  A value of 0 means that any number of characters can be entered.
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get maxChars():int
    {
        return _maxChars;
    }

    public function set maxChars(value:int):void
    {
        if (value == _maxChars)
            return;
            
        _maxChars = value;

        dispatchEvent(new Event("maxCharsChanged"));
    }

    //----------------------------------
    //  maximum
    //----------------------------------

    /**
     *  @private
     *  Storage for maximum property.
     */
    [Bindable("maximumChanged")]
    [Inspectable(category="General", defaultValue="10")]

    /**
     *  Maximum value of the NumericStepper.
     *  The maximum can be any number, including a fractional value.
     *
     *  @default 10
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get maximum():Number
    {
        return IRangeModel(model).maximum;
    }

    public function set maximum(value:Number):void
    {
		IRangeModel(model).maximum = value;
    }

    //----------------------------------
    //  minimum
    //----------------------------------

    /**
     *  @private
     *  Storage for minimum property.
     */
    [Bindable("minimumChanged")]
    [Inspectable(category="General", defaultValue="0")]

    /**
     *  Minimum value of the NumericStepper.
     *  The minimum can be any number, including a fractional value.
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get minimum():Number
    {
        return IRangeModel(model).minimum;
    }

    public function set minimum(value:Number):void
    {
        IRangeModel(model).minimum = value;       
    }

    //----------------------------------
    //  stepSize
    //----------------------------------

    /**
     *  @private
     *  Storage for the stepSize property.
     */
    [Bindable("stepSizeChanged")]
    [Inspectable(category="General", defaultValue="1")]

    /**
     *  Non-zero unit of change between values.
     *  The <code>value</code> property must be a multiple of this number.
     *
     *  @default 1
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get stepSize():Number
    {
        return IRangeModel(model).stepSize;
    }

    /**
     *  @private
     */
    public function set stepSize(value:Number):void
    {
        IRangeModel(model).stepSize = value;
    }

    //----------------------------------
    //  value
    //----------------------------------

    [Bindable("change")]
    [Bindable("valueCommit")]
    [Inspectable(category="General", defaultValue="0")]

    /**
     *  Current value displayed in the text area of the NumericStepper control.
     *  If a user enters number that is not a multiple of the
     *  <code>stepSize</code> property or is not in the range
     *  between the <code>maximum</code> and <code>minimum</code> properties,
     *  this property is set to the closest valid value.
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get value():Number
    {
        return IRangeModel(model).value;
    }

    /**
     *  @private
     */
    public function set value(value:Number):void
    {
        IRangeModel(model).value = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Verify that the value is within range.
     */
    private function checkRange(v:Number):Boolean
    {
        return v >= minimum && v <= maximum;
    }

    /**
     *  @private
     */
//    private function checkValidValue(value:Number):Number
//    {
//        if (isNaN(value))
//            return this.value;
//
//        var closest:Number = stepSize * Math.round(value / stepSize);
//
//        // The following logic has been implemented to fix bug 135045.
//        // It assumes that the above line of code which rounds off the
//        // value is not removed ! (That is, the precision of the value is
//        // never expected to be greater than the step size.
//        // ex : value = 1.11111 stepSize = 0.01)
//
//        // Use precision of the step to round of the value.
//        // When the stepSize is very small the system tends to put it in
//        // exponential format.(ex : 1E-7) The following string split logic
//        // cannot work with exponential notation. Hence we add 1 to the stepSize
//        // to make it get represented in the decimal format.
//        // We are only interested in the number of digits towards the right
//        // of the decimal place so it doesnot affect anything else.
//        var parts:Array = (new String(1 + stepSize)).split(".");
//
//        // we need to do the round of (to remove the floating point error)
//        // if the stepSize had a fractional value
//        if (parts.length == 2)
//        {
//            var scale:Number = Math.pow(10, parts[1].length);
//            closest = Math.round(closest * scale) / scale;
//        }
//
//        if (closest > maximum)
//            return maximum;
//        else if (closest < minimum)
//            return minimum;
//        else
//            return closest;
//    }

    /**
     *  @private
     */
//    private function setValue(value:Number,
//                              sendEvent:Boolean = true,
//                              trigger:Event = null):void
//    {
//
//        var v:Number = checkValidValue(value);
//        if (v == lastValue)
//            return;
//
//        lastValue = _value = v;
//		
//		var numStr:String =  v.toString();
//		if (numStr.indexOf("e") >= 0) {
//			var parts:Array = (new String(1 + stepSize)).split(".");
//			
//			if (parts.length == 2)
//				numStr = v.toFixed(parts[1].length).toString();
//		}
//		
//        inputField.text = numStr;
//		lastField = numStr;
//
//        if (sendEvent)
//        {
//            var event:NumericStepperEvent =
//                new NumericStepperEvent(NumericStepperEvent.CHANGE);
//            event.value = _value;
//            event.triggerEvent = trigger;
//
//            dispatchEvent(event);
//        }
//
//        dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
//    }

    /**
     *  @private
     *  Checks the value in the text field. If it is valid value
     *  and different from the current value, it is taken as new value.
     */
//    private function takeValueFromTextField(trigger:Event = null):void
//    {
//        var inputValue:Number = Number(inputField.text);
//		
//        if ((inputValue != lastValue &&
//            (Math.abs(inputValue - lastValue) >= 0.000001 || isNaN(inputValue)))
//            || inputField.text == ""
//			|| (inputField.text && inputField.text.length != lastField.length))
//        {
//            var newValue:Number = checkValidValue(Number(inputField.text));
//            inputField.text = newValue.toString();
//            setValue(newValue, trigger != null, trigger);
//        }
//    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

	private var oldBorderColor:String;
	
	override public function set errorString(value:String):void
	{
		super.errorString = value;
		COMPILE::JS
		{
			if (value)
			{
				oldBorderColor = (view as NumericStepperView).getInput().element.style.borderColor;
				(view as NumericStepperView).getInput().element.style.borderColor = "#f00";
			}
			else
			{
				(view as NumericStepperView).getInput().element.style.borderColor = oldBorderColor;
			}
		}
	}
	
	override public function addedToParent():void
	{
		super.addedToParent();
		_measuredHeight = 21;
		_measuredWidth = 55; // FF is 55, Chrome 54
	}
}

}
