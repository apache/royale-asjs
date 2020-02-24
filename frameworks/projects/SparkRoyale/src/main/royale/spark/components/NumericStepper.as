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

package spark.components
{

/* import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent; */

//import mx.core.IIMESupport;
import mx.core.mx_internal;
import mx.events.FlexEvent;
import mx.managers.IFocusManagerComponent;

//import spark.formatters.NumberFormatter;
import spark.components.supportClasses.Range; 
use namespace mx_internal;

//--------------------------------------
//  Styles
//--------------------------------------
/* 
include "../styles/metadata/BasicInheritingTextStyles.as"
include "../styles/metadata/AdvancedInheritingTextStyles.as"
include "../styles/metadata/SelectionFormatTextStyles.as"
 */
/**
 *  The alpha of the border for this component.
 *
 *  @default 0.5
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="borderAlpha", type="Number", inherit="no", theme="spark")]

/**
 *  The color of the border for this component.
 *
 *  @default 0x000000
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="borderColor", type="uint", format="Color", inherit="no", theme="spark")]

/**
 *  Controls the visibility of the border for this component.
 *
 *  @default true
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="borderVisible", type="Boolean", inherit="no", theme="spark")]

/**
 *  The alpha of the content background for this component.
 *
 *  @default 1
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="contentBackgroundAlpha", type="Number", inherit="yes", theme="spark")]

/**
 *  @copy spark.components.supportClasses.GroupBase#style:contentBackgroundColor
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="contentBackgroundColor", type="uint", format="Color", inherit="yes", theme="spark")]

//--------------------------------------
//  Other metadata
//--------------------------------------

//[AccessibilityClass(implementation="spark.accessibility.NumericStepperAccImpl")]

[DefaultTriggerEvent("change")]

//[IconFile("NumericStepper.png")]

/**
 * Because this component does not define a skin for the mobile theme, Adobe
 * recommends that you not use it in a mobile application. Alternatively, you
 * can define your own mobile skin for the component. For more information,
 * see <a href="http://help.adobe.com/en_US/flex/mobileapps/WS19f279b149e7481c698e85712b3011fe73-8000.html">Basics of mobile skinning</a>.
 */
//[DiscouragedForProfile("mobileDevice")]

/**
 *  The NumericStepper control lets you select
 *  a number from an ordered set.
 *  The NumericStepper provides the same functionality as
 *  the Spinner component, but adds a TextInput control
 *  so that you can directly edit the value of the component,
 *  rather than modifying it by using the control's arrow buttons.
 *
 *  <p>The NumericStepper control consists of a single-line
 *  input text field and a pair of arrow buttons
 *  for stepping through the possible values.
 *  The Up Arrow and Down Arrow keys and the mouse wheel also cycle through 
 *  the values. 
 *  An input value is committed when
 *  the user presses the Enter key, removes focus from the
 *  component, or steps the NumericStepper by pressing an arrow button
 *  or by calling the <code>changeValueByStep()</code> method.</p>
 *
 *  <p>To use this component in a list-based component, such as a List or DataGrid, 
 *  create an item renderer.
 *  For information about creating an item renderer, see 
 *  <a href="http://help.adobe.com/en_US/flex/using/WS4bebcd66a74275c3-fc6548e124e49b51c4-8000.html">
 *  Custom Spark item renderers</a>. </p>
 *
 *  <p>The NumericStepper control has the following default characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>53 pixels wide by 23 pixels high</td>
 *        </tr>
 *        <tr>
 *           <td>Minimum size</td>
 *           <td>40 pixels wide and 40 pixels high</td>
 *        </tr>
 *        <tr>
 *           <td>Maximum size</td>
 *           <td>10000 pixels wide and 10000 pixels high</td>
 *        </tr>
 *        <tr>
 *           <td>Default skin classes</td>
 *           <td>spark.skins.spark.NumericStepperSkin
 *              <p>spark.skins.spark.NumericStepperTextInputSkin</p></td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;s:NumericStepper&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:NumericStepper
 *
 *    <strong>Properties</strong>
 *    imeMode="null"
 *    maxChars="0"
 *    maximum="10"
 *    valueFormatFunction=""
 *    valueParseFunction=""
 *
 *    <strong>Styles</strong>
 *
*    alignmentBaseline="USE_DOMINANT_BASELINE"
*    baselineShift="0.0"
*    blockProgression="TB"
*    borderAlpha="0.5"
*    borderColor="0x000000"
*    borderVisible="true"
*    breakOpportunity="AUTO"
*    cffHinting="HORIZONTAL_STEM"
*    color="0"
*    contentBackgroundAlpha="1.0"
*    contentBackgroundColor="0xFFFFFF"
*    clearFloats="none"
*    digitCase="DEFAULT"
*    digitWidth="DEFAULT"
*    direction="LTR"
*    dominantBaseline="AUTO"
*    firstBaselineOffset="AUTO"
*    focusedTextSelectionColor=""
*    fontFamily="Arial"
*    fontLookup="DEVICE"
*    fontSize="12"
*    fontStyle="NORMAL"
*    fontWeight="NORMAL"
*    inactiveTextSelection=""
*    justificationRule="AUTO"
*    justificationStyle="AUTO"
*    kerning="AUTO"
*    leadingModel="AUTO"
*    ligatureLevel="COMMON"
*    lineHeight="120%"
*    lineThrough="false"
*    listAutoPadding="40"
*    listStylePosition="outside"
*    listStyleType="disc"
*    locale="en"
*    paragraphEndIndent="0"
*    paragraphSpaceAfter="0"
*    paragraphSpaceBefore="0"
*    paragraphStartIndent="0"
*    renderingMode="CFF"
*    tabStops="null"
*    textAlign="START"
*    textAlignLast="START"
*    textAlpha="1"
*    textDecoration="NONE"
*    textIndent="0"
*    textJustify="INTER_WORD"
*    textRotation="AUTO"
*    trackingLeft="0"
*    trackingRight="0"
*    typographicCase="DEFAULT"
*    unfocusedTextSelectionColor=""
*    whiteSpaceCollapse="COLLAPSE"
*    wordSpacing="100%,50%,150%"
*  /&gt;
*  </pre>
*
 *  @see spark.components.Spinner
 *  @see spark.skins.spark.NumericStepperSkin
 *  @see spark.skins.spark.NumericStepperTextInputSkin
 * 
 *  @includeExample examples/NumericStepperExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class NumericStepper extends Range
{
/* extends Spinner 
    implements IFocusManagerComponent, IIMESupport */
   // include "../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Class mixins
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Placeholder for mixin by SpinnerAccImpl.
     */
    //mx_internal static var createAccessibilityImplementation:Function;
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */  
    public function NumericStepper()
    {
        super();
        maximum = 10;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Skin parts
    //
    //--------------------------------------------------------------------------

    //[SkinPart(required="true")]
    
    /**
     *  A skin part that defines a TextInput control 
     *  which allows a user to edit the value of
     *  the NumericStepper component. 
     *  The value is rounded and committed
     *  when the user presses enter, focuses out of
     *  the NumericStepper, or steps the NumericStepper.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    //public var textDisplay:TextInput;

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    //private var dataFormatter:NumberFormatter;
    
    //--------------------------------------------------------------------------
    //
    //  Overridden properties: UIComponent
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  baselinePosition
    //----------------------------------

    /**
     *  @private
     */
    /* override public function get baselinePosition():Number
    {
        return getBaselinePositionForPart(textDisplay);
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Properties: Range
    //
    //--------------------------------------------------------------------------
    
    //---------------------------------
    // maximum
    //---------------------------------   
    
    /**
     *  @private
     */
    /* private var maxChanged:Boolean = false;
    
    [Inspectable(category="General", defaultValue="10.0")]
     */
    /**
     *  Number which represents the maximum value possible for 
     *  <code>value</code>. If the values for either 
     *  <code>minimum</code> or <code>value</code> are greater
     *  than <code>maximum</code>, they will be changed to 
     *  reflect the new <code>maximum</code>
     *
     *  @default 10
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    override public function set maximum(value:Number):void
    {
    //    maxChanged = true;
        super.maximum = value;
    }
    
    //---------------------------------
    // stepSize
    //---------------------------------   
    
    /**
     *  @private
     */
    /* private var stepSizeChanged:Boolean = false;
    
    [Inspectable(category="General", defaultValue="1.0", minValue="0.0")]
     */
    /**
     *  @private
     */
    override public function set stepSize(value:Number):void
    {
     //   stepSizeChanged = true;
        super.stepSize = value;       
    }   
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  enableIME
    //----------------------------------

    /**
     *  A flag that indicates whether the IME should
     *  be enabled when the component receives focus.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    /* public function get enableIME():Boolean
    {
        if (textDisplay && textDisplay.textDisplay)
            return textDisplay.textDisplay.editable;
        // most numeric steppers will be editable
        return true;
    } */

    //----------------------------------
    //  maxChars
    //----------------------------------

    /**
     *  @private
     *  Storage for the maxChars property.
     */
    private var _maxChars:int = 0;

    /**
     *  @private
     */
    /* private var maxCharsChanged:Boolean = false;
    
    [Inspectable(category="General", defaultValue="0")]
	*/
    /**
     *  The maximum number of characters that can be entered in the field.
     *  A value of 0 means that any number of characters can be entered.
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get maxChars():int
    {
        return _maxChars;
    }

    /**
     *  @private
     */
    public function set maxChars(value:int):void
    {
        if (value == _maxChars)
            return;
            
        _maxChars = value;
     //   maxCharsChanged = true;
        
     //   invalidateProperties();
    }
    
    //--------------------------------- 
    // valueFormatFunction
    //---------------------------------

    /**
     *  @private
     */
    private var _valueFormatFunction:Function;
    
    /**
     *  @private
     */
    private var valueFormatFunctionChanged:Boolean;
    
    /**
     *  Callback function that formats the value displayed
     *  in the skin's <code>textDisplay</code> property.
     *  The function takes a single Number as an argument
     *  and returns a formatted String.
     *
     *  <p>The function has the following signature:</p>
     *  <pre>
     *  funcName(value:Number):String
     *  </pre>
     
     *  @default undefined   
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get valueFormatFunction():Function
    {
        return _valueFormatFunction;
    }
    
    /**
     *  @private
     */
    public function set valueFormatFunction(value:Function):void
    {
        _valueFormatFunction = value;
        valueFormatFunctionChanged = true;
        invalidateProperties();
    }

    //--------------------------------- 
    // valueParseFunction
    //---------------------------------

    /**
     *  @private
     */
    //private var _valueParseFunction:Function;
    
    /**
     *  @private
     */
    //private var valueParseFunctionChanged:Boolean;
    
    /**
     *  Callback function that extracts the numeric 
     *  value from the displayed value in the 
     *  skin's <code>textDisplay</code> field.  
     * 
     *  The function takes a single String as an argument
     *  and returns a Number.
     *
     *  <p>The function has the following signature:</p>
     *  <pre>
     *  funcName(value:String):Number
     *  </pre>
     
     *  @default undefined   
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    /* public function get valueParseFunction():Function
    {
        return _valueParseFunction;
    } */
    
    /**
     *  @private
     */
    /* public function set valueParseFunction(value:Function):void
    {
        _valueParseFunction = value;
        valueParseFunctionChanged = true;
        invalidateProperties();
    } */

    //----------------------------------
    //  imeMode
    //----------------------------------

    /**
     *  @private
     */
    //private var _imeMode:String = null;

    /**
     *  @private
     */
    //private var imeModeChanged:Boolean = false;
    
    /**
     *  Specifies the IME (Input Method Editor) mode.
     *  The IME enables users to enter text in Chinese, Japanese, and Korean.
     *  Flex sets the specified IME mode when the control gets the focus
     *  and sets it back to previous value when the control loses the focus.
     *
     * <p>The flash.system.IMEConversionMode class defines constants for the
     *  valid values for this property.
     *  You can also specify <code>null</code> to specify no IME.</p>
     *
     *  @see flash.system.IMEConversionMode
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    /* public function get imeMode():String
    {
        return _imeMode;
    } */

    /**
     *  @private
     */
    /* public function set imeMode(value:String):void
    {
        _imeMode = value;
        imeModeChanged = true;
        invalidateProperties();
    } */

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

     /**
     *  @private
     */
    /* override protected function initializeAccessibility():void
    {
        if (NumericStepper.createAccessibilityImplementation != null)
            NumericStepper.createAccessibilityImplementation(this);
    } */

    /**
     *  @private
     */
    /* override protected function commitProperties():void
    {   
        super.commitProperties();
        
        if (maxChanged || stepSizeChanged || valueFormatFunctionChanged)
        {
            textDisplay.widthInChars = calculateWidestValue();
            maxChanged = false;
            stepSizeChanged = false;
            
            if (valueFormatFunctionChanged)
            {
                applyDisplayFormatFunction();
               
                valueFormatFunctionChanged = false;
            }
        }
        
        if (valueParseFunctionChanged)
        {
            commitTextInput(false);
            valueParseFunctionChanged = false;
        }
            
        if (maxCharsChanged)
        {
            textDisplay.maxChars = _maxChars;
            maxCharsChanged = false;
        }
        
        if (imeModeChanged)
        {
            textDisplay.imeMode = _imeMode;
            imeModeChanged = false;
        }
    }  */
    
    /**
     *  @private
     */
    /* override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName, instance);
        
        if (instance == textDisplay)
        {
            textDisplay.addEventListener(FlexEvent.ENTER,
                                       textDisplay_enterHandler);
            textDisplay.addEventListener(FocusEvent.FOCUS_OUT, 
                                       textDisplay_focusOutHandler); 
            textDisplay.focusEnabled = false;
            textDisplay.maxChars = _maxChars;
            // Restrict to digits, minus sign, decimal point, and comma
            textDisplay.restrict = "0-9\\-\\.\\,";
			if (dataFormatter != null)
          		textDisplay.text = dataFormatter.format(value);
			else
				textDisplay.text = value.toString();
            // Set the the textDisplay to be wide enough to display
            // widest possible value. 
            textDisplay.widthInChars = calculateWidestValue(); 
        }
    }
     */
    /**
     *  @private
     */
    /* override protected function partRemoved(partName:String, instance:Object):void
    {
        super.partRemoved(partName, instance);
        
        if (instance == textDisplay)
        {
            textDisplay.removeEventListener(FlexEvent.ENTER, 
                                          textDisplay_enterHandler);
        }
    } */

    /**
     *  @private
     */
    /* override public function setFocus():void
    {
        if (stage)
        {
            stage.focus = textDisplay.textDisplay as InteractiveObject;
            
            // Since the API ignores the visual editable and selectable 
            // properties make sure the selection should be set first.
            if (textDisplay.textDisplay && 
               (textDisplay.textDisplay.editable || textDisplay.textDisplay.selectable))
            {
                textDisplay.textDisplay.selectAll();
            }
        }
    } */
    
    /**
     *  @private
     */
    /* override protected function isOurFocus(target:DisplayObject):Boolean
    {
        return target == textDisplay.textDisplay;
    } */

    /**
     *  @private
     */
    /* override protected function setValue(newValue:Number):void
    {
        super.setValue(newValue);
        
        applyDisplayFormatFunction();
    } */
    
    /**
     *  @private
     *  Calls commitTextInput() before stepping.
     */
    /* override public function changeValueByStep(increase:Boolean = true):void
    {
        commitTextInput();
        
        super.changeValueByStep(increase);
    } */
    
    //--------------------------------------------------------------------------
    // 
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Commits the current text of <code>textDisplay</code> 
     *  to the <code>value</code> property. 
     *  This method uses the <code>nearestValidValue()</code> method 
     *  to round the input value to the closest valid value.
     *  Valid values are defined by the sum of the minimum
     *  with integer multiples of the snapInterval. It is also
     *  constrained by and includes the <code>maximum</code> property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    /* private function commitTextInput(dispatchChange:Boolean = false):void
    {
        var inputValue:Number;
        var prevValue:Number = value;
        
        if (valueParseFunction != null)
        {
            inputValue = valueParseFunction(textDisplay.text);
        }
        else 
        {
            if (dataFormatter == null)
            {
                dataFormatter = new NumberFormatter();
				dataFormatter.fractionalDigits = Math.max(0, (stepSize - Math.floor(stepSize)).toString().length - 2);
				dataFormatter.useGrouping = false;
                addStyleClient(dataFormatter);
            }

            inputValue = dataFormatter.parseNumber(textDisplay.text);
        }
                
        if ((textDisplay.text && textDisplay.text.length != value.toString().length) || 
            textDisplay.text == "" ||
            (isNaN(inputValue) && !isNaN(value)) ||
            (!isNaN(inputValue) && isNaN(value)) ||
            (inputValue != value && (Math.abs(inputValue - value) >= 0.000001)))
        {
            var newValue:Number = !isNaN(inputValue) ? nearestValidValue(inputValue, snapInterval) : NaN;
            setValue(newValue);

            // Dispatch valueCommit if the display needs to change.
            if (!valuesEqual(value, prevValue) || !valuesEqual(inputValue, prevValue))
                dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
        }
        
        if (dispatchChange)
        {
            if (!valuesEqual(value, prevValue))
                dispatchEvent(new Event(Event.CHANGE));
        }
    } */
      
    /**
     *  @private
     *  Helper method that returns true if num1 equal to  num2.
     */
    /* private function valuesEqual(num1:Number, num2:Number):Boolean
    {
        return ((!isNaN(num1) && !isNaN(num2) && num1 == num2) || (isNaN(num1) && isNaN(num2)));
    } */
    
    /**
     *  @private
     *  Helper method that returns a number corresponding
     *  to the length of the maximum value displayable in 
     *  the textDisplay.  
     */
    /* private function calculateWidestValue():Number
    {
        var widestNumber:Number = minimum.toString().length >
                              maximum.toString().length ?
                              minimum :
                              maximum;
        widestNumber += stepSize;
        
        if (valueFormatFunction != null)
            return valueFormatFunction(widestNumber).length;
        else 
           return widestNumber.toString().length;
    } */
    
    /**
     *  @private
     *  Helper method that applies the valueFormatFunction  
     */
    /* private function applyDisplayFormatFunction():void
    {
        if (valueFormatFunction != null)
            textDisplay.text = valueFormatFunction(value);
        else if (dataFormatter != null)
            textDisplay.text = dataFormatter.format(value);
		else
			textDisplay.text = value.toString();
    } */
    
    //--------------------------------------------------------------------------
    // 
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */  
    /* override protected function focusInHandler(event:FocusEvent):void
    {
        super.focusInHandler(event);

        addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true);
    } */
    
    /**
     *  @private
     */  
    /* override protected function focusOutHandler(event:FocusEvent):void
    {
        super.focusOutHandler(event);

        removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true);
    } */
   
        
    /**
     *  @private
     *  When the enter key is pressed, NumericStepper commits the
     *  text currently displayed.
     */
    /* private function textDisplay_enterHandler(event:Event):void
    {
        commitTextInput(true);
    } */
    
    /**
     *  @private
     *  When the enter key is pressed, NumericStepper commits the
     *  text currently displayed.
     */
    /* private function textDisplay_focusOutHandler(event:Event):void
    {
        commitTextInput(true);
    } */
}

}
