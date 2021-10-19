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
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

import flashx.textLayout.operations.CompositeOperation;
import flashx.textLayout.operations.CutOperation;
import flashx.textLayout.operations.DeleteTextOperation;
import flashx.textLayout.operations.FlowOperation;

import mx.core.IIMESupport;
import mx.core.mx_internal;
import mx.events.FlexEvent;

import spark.components.supportClasses.ListBase;
import spark.events.DropDownEvent;
import spark.events.TextOperationEvent;
import spark.utils.LabelUtil;
 
use namespace mx_internal;
 */
import spark.components.supportClasses.DropDownListBase;
import mx.collections.IList;

/**
 *  Bottom inset, in pixels, for the text in the 
 *  prompt area of the control.  
 * 
 *  @default 3
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="paddingBottom", type="Number", format="Length", inherit="no")]

/**
 *  Left inset, in pixels, for the text in the 
 *  prompt area of the control.  
 * 
 *  @default 3
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="paddingLeft", type="Number", format="Length", inherit="no")]

/**
 *  Right inset, in pixels, for the text in the 
 *  prompt area of the control.  
 * 
 *  @default 3
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="paddingRight", type="Number", format="Length", inherit="no")]

/**
 *  Top inset, in pixels, for the text in the 
 *  prompt area of the control.  
 * 
 *  @default 5
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="paddingTop", type="Number", format="Length", inherit="no")]

//--------------------------------------
//  Other metadata
//--------------------------------------

//[AccessibilityClass(implementation="spark.accessibility.ComboBoxAccImpl")]

//[IconFile("ComboBox.png")]

/**
 * Because this component does not define a skin for the mobile theme, Adobe
 * recommends that you not use it in a mobile application. Alternatively, you
 * can define your own mobile skin for the component. For more information,
 * see <a href="http://help.adobe.com/en_US/flex/mobileapps/WS19f279b149e7481c698e85712b3011fe73-8000.html">Basics of mobile skinning</a>.
 */
//[DiscouragedForProfile("mobileDevice")]

/**
 *  The ComboBox control is a child class of the DropDownListBase control. 
 *  Like the DropDownListBase control, when the user selects an item from 
 *  the drop-down list in the ComboBox control, the data item appears 
 *  in the prompt area of the control. 
 *
 *  <p>One difference between the controls is that the prompt area of 
 *  the ComboBox control is implemented by using the TextInput control, 
 *  instead of the Label control for the DropDownList control. 
 *  Therefore, a user can edit the prompt area of the control to enter 
 *  a value that is not one of the predefined options.</p>
 *
 *  <p>For example, the DropDownList control only lets the user select 
 *  from a list of predefined items in the control. 
 *  The ComboBox control lets the user either select a predefined item, 
 *  or enter a new item into the prompt area. 
 *  When the user enters a new item, the <code>selectedIndex</code> property 
 *  is set to -3.
 *  Your application can recognize that a new item has been entered and, 
 *  optionally, add it to the list of items in the control.</p>
 *
 *  <p>The ComboBox control also searches the item list as the user 
 *  enters characters into the prompt area. As the user enters characters, 
 *  the drop-down area of the control opens. 
 *  It then scrolls to and highlights the closest match in the item list.</p>
 *
 *  <p>To use this component in a list-based component, such as a List or DataGrid, 
 *  create an item renderer.
 *  For information about creating an item renderer, see 
 *  <a href="http://help.adobe.com/en_US/flex/using/WS4bebcd66a74275c3-fc6548e124e49b51c4-8000.html">
 *  Custom Spark item renderers</a>. </p>
 *
 *  <p><b>Note: </b>The Spark list-based controls (the Spark ListBase class and its subclasses
 *  such as ButtonBar, ComboBox, DropDownList, List, and TabBar) do not support the BasicLayout class
 *  as the value of the <code>layout</code> property. 
 *  Do not use BasicLayout with the Spark list-based controls.</p>
 * 
 *  <p>The ComboBox control has the following default characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>146 pixels wide by 23 pixels high</td>
 *        </tr>
 *        <tr>
 *           <td>Minimum size</td>
 *           <td>20 pixels wide by 23 pixels high</td>
 *        </tr>
 *        <tr>
 *           <td>Maximum size</td>
 *           <td>10000 pixels wide and 10000 pixels high</td>
 *        </tr>
 *        <tr>
 *           <td>Default skin class</td>
 *           <td>spark.skins.spark.ComboBoxSkin
 *               <p>spark.skins.spark.ComboBoxTextInputSkin</p></td>
 *        </tr>
 *     </table>
 *
 *  @mxml <p>The <code>&lt;s:ComboBox&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:ComboBox
 *    <strong>Properties</strong>
 *    itemMatchingFunction="null"
 *    labelToItemFunction="null"
 *    maxChars="0"
 *    openOnInput="true"
 *    prompt="null"
 *    restrict=""
 *
 *    <strong>Styles</strong>
 *    paddingBottom="3"
 *    paddingLeft="3"
 *    paddingRight="3"
 *    paddingTop="5"
 *  /&gt;
 *  </pre>
 *
 *  @see spark.skins.spark.ComboBoxSkin
 *  @see spark.skins.spark.ComboBoxTextInputSkin
 *  @includeExample examples/ComboBoxExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
public class ComboBox extends DropDownListBase 
{ //implements IIMESupport
    //--------------------------------------------------------------------------
    //
    //  Skin Parts
    //
    //--------------------------------------------------------------------------    
    /**
     *  Optional skin part that holds the input text or the selectedItem text. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    [SkinPart(required="false")]
    public var textInput:TextInput;
    
    //--------------------------------------------------------------------------
    //
    //  Class mixins
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Placeholder for mixin by ComboBoxAccImpl.
     */
   // mx_internal static var createAccessibilityImplementation:Function;
    
    /**
     *  Constructor. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function ComboBox()
    {
        super();
        
        //addEventListener(KeyboardEvent.KEY_DOWN, capture_keyDownHandler, true);
        //allowCustomSelectedItem = true;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Static Variables
    //
    //--------------------------------------------------------------------------
    /**
     *  Static constant representing the value of the <code>selectedIndex</code> property
     *  when the user enters a value into the prompt area, and the value is committed. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
  // public static const CUSTOM_SELECTED_ITEM:int = ListBase.CUSTOM_SELECTED_ITEM;
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /* private var isTextInputInFocus:Boolean;
    
    private var actualProposedSelectedIndex:Number = NO_SELECTION;  
    
    private var userTypedIntoText:Boolean;
    
    private var previousTextInputText:String = ""; */
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //  itemMatchingFunction
    //--------------------------------------------------------------------------
    
    /**
     *  Specifies a callback function used to search the item list as the user 
     *  enters characters into the prompt area. 
     *  As the user enters characters, the drop-down area of the control opens. 
     *  It then and scrolls to and highlights the closest match in the item list.
     * 
     *  <p>The function referenced by this property takes an input string and returns
     *  the index of the items in the data provider that match the input. 
     *  The items are returned as a Vector.&lt;int&gt; of indices in the data provider. </p>
     * 
     *  <p>The callback function must have the following signature: </p>
     * 
     *  <pre>
     *    function myMatchingFunction(comboBox:ComboBox, inputText:String):Vector.&lt;int&gt;</pre>
     * 
     *  <p>If the value of this property is null, the ComboBox finds matches 
     *  using the default algorithm.  
     *  By default, if an input string of length n is equivalent to the first n characters 
     *  of an item (ignoring case), then it is a match to that item. For example, 'aRiz' 
     *  is a match to "Arizona" while 'riz' is not.</p>
     *
     *  <p>To disable search, create a callback function that returns an empty Vector.&lt;int&gt;.</p>
     * 
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */ 
   // public var itemMatchingFunction:Function = null;     
    
	
	//----------------------------------
	//  dataProvider
	//----------------------------------
	
	[Inspectable(category="Data")]
	
	/**
	 *  @private
	 *  Update the label if the dataProvider has changed
	 */
	override public function set dataProvider(value:IList):void
	{   
		if (dataProvider === value)
			return;
		
		if (dataProvider != null)
			selectedItem = null;
		super.dataProvider = value;
	}

    //--------------------------------------------------------------------------
    //  labelToItemFunction
    //--------------------------------------------------------------------------
    
   /*  private var _labelToItemFunction:Function;
    private var labelToItemFunctionChanged:Boolean = false; */
    
    /**
     *  Specifies a callback function to convert a new value entered 
     *  into the prompt area to the same data type as the data items in the data provider.
     *  The function referenced by this properly is called when the text in the prompt area 
     *  is committed, and is not found in the data provider. 
     * 
     *  <p>The callback function must have the following signature: </p>
     * 
     *  <pre>
     *    function myLabelToItem(value:String):Object</pre>
     * 
     *  <p>Where <code>value</code> is the String entered in the prompt area.
     *  The function returns an Object that is the same type as the items 
     *  in the data provider.</p>
     * 
     *  <p>The default callback function returns <code>value</code>. </p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */ 
    /* public function set labelToItemFunction(value:Function):void
    {
        if (value == _labelToItemFunction)
            return;
        
        _labelToItemFunction = value;
        labelToItemFunctionChanged = true;
        invalidateProperties();
    } */
    
    /**
     *  @private 
     */
    /* public function get labelToItemFunction():Function
    {
        return _labelToItemFunction;
    } */
    
    //--------------------------------------------------------------------------
    //  maxChars
    //--------------------------------------------------------------------------
   /*  
    private var _maxChars:int = 0;
    private var maxCharsChanged:Boolean = false;
    
    [Inspectable(category="General", defaultValue="0")] */
    
    /**
     *  The maximum number of characters that the prompt area can contain, as entered by a user. 
     *  A value of 0 corresponds to no limit.
     * 
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */ 
   /*  public function set maxChars(value:int):void
    {
        if (value == _maxChars)
            return;
        
        _maxChars = value;
        maxCharsChanged = true;
        invalidateProperties();
    } */
    
    /**
     *  @private 
     */
    /* public function get maxChars():int
    {
        return _maxChars;
    } */
    
    //--------------------------------------------------------------------------
    //  openOnInput
    //--------------------------------------------------------------------------
    
    /**
     *  If <code>true</code>, the drop-down list opens when the user edits the prompt area.
     * 
     *  @default true 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */ 
    //public var openOnInput:Boolean = true;
    
    //----------------------------------
    //  prompt
    //----------------------------------
    
   /*  private var _prompt:String;
    private var promptChanged:Boolean;
    
    [Inspectable(category="General")] */
    
    /**
     *  Text to be displayed if/when the input text is null.
     * 
     *  <p>Prompt text appears when the control is first created. Prompt text disappears 
     *  when the control gets focus, when the input text is non-null, or when an item in the list is selected. 
     *  Prompt text reappears when the control loses focus, but only if no text was entered 
     *  (if the value of the text field is null or the empty string).</p>
     *  
     *  <p>You can change the style of the prompt text with CSS. If the control has prompt text 
     *  and is not disabled, the style is defined by the <code>normalWithPrompt</code> pseudo selector. 
     *  If the control is disabled, then the styles defined by the <code>disabledWithPrompt</code> pseudo selector are used.</p>
     *  
     *  <p>The following example CSS changes the color of the prompt text in TextInput controls. The ComboBox control uses
     *  a TextInput control as a subcomponent for the prompt text and input, so its prompt text changes when you use this CSS:
     *  <pre>
     *  &#64;namespace s "library://ns.adobe.com/flex/spark";
     *  s|TextInput:normalWithPrompt {
     *      color: #CCCCFF;
     *  }
     *  </pre>
     *  </p>
     *
     *  @default null
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.0
     *  @productversion Royale 0.9.4
     */
   /*  public function get prompt():String
    {
        return _prompt;
    } */
    
    /**
     *  @private
     */
    /* public function set prompt(value:String):void
    {
        _prompt = value;
        promptChanged = true;
        invalidateProperties();
    } */

    //--------------------------------------------------------------------------
    //  restrict
    //--------------------------------------------------------------------------
    
   /*  private var _restrict:String;
    private var restrictChanged:Boolean;
    
    [Inspectable(category="General", defaultValue="")] */
    
    /**
     *  Specifies the set of characters that a user can enter into the prompt area.
     *  By default, the user can enter any characters, corresponding to a value of
     *  an empty string.
     * 
     *  @default ""
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */ 
   /*  public function set restrict(value:String):void
    {
        if (value == _restrict)
            return;
        
        _restrict = value;
        restrictChanged = true;
        invalidateProperties();
    } */
    
    /**
     *  @private 
     */
   /*  public function get restrict():String
    {
        return _restrict;
    } */
 
    //--------------------------------------------------------------------------
    //
    //  Overridden Properties
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //  baselinePosition
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
  /*   override public function get baselinePosition():Number
    {
        return getBaselinePositionForPart(textInput);
    } */
    
    //--------------------------------------------------------------------------
    //  selectedIndex
    //--------------------------------------------------------------------------
    
    //[Inspectable(category="General", defaultValue="-1")]
    
    /**
     *  @private 
     */
    /* override public function set selectedIndex(value:int):void
    {
        super.selectedIndex = value;
        actualProposedSelectedIndex = value;
    } */
    
    //--------------------------------------------------------------------------
    //  selectedItem
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    override public function set selectedItem(value:*):void
    {
        // If selectedItem set to null or undefined make sure the label display gets cleared.
        // The code at the bottom of commitProperties checks for this case.
       // if (value == null)
           // selectedIndex = NO_SELECTION;
        
        super.selectedItem = value;
    }

    //--------------------------------------------------------------------------
    //  typicalItem
    //--------------------------------------------------------------------------
    
   /*  private var typicalItemChanged:Boolean = false;
    
    [Inspectable(category="Data")] */
    
    /**
     *  @private
     */
    /* override public function set typicalItem(value:Object):void
    {   
        if (value == typicalItem)
            return;
     
        super.typicalItem = value;
        
        typicalItemChanged = true;
        invalidateProperties();
    } */
    
    //--------------------------------------------------------------------------
    //  userProposedSelectedIndex
    //--------------------------------------------------------------------------
    
    /**
     *  @private 
     */
   /*  override mx_internal function set userProposedSelectedIndex(value:Number):void
    {
        super.userProposedSelectedIndex = value;
        actualProposedSelectedIndex = value;
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private 
     */ 
   /*  private function processInputField():void
    {
        var matchingItems:Vector.<int>;
        
        // If the textInput has been changed, then use the input string as the selectedItem
        actualProposedSelectedIndex = CUSTOM_SELECTED_ITEM; 
        
        // Even if there is no data provider, we still want to allow custom items. 
        if (!dataProvider || dataProvider.length <= 0)
            return;
        
        if (textInput.text != "")
        {
            if (itemMatchingFunction != null)
                matchingItems = itemMatchingFunction(this, textInput.text);
            else
                matchingItems = findMatchingItems(textInput.text);
            
            if (matchingItems.length > 0)
            {
                super.changeHighlightedSelection(matchingItems[0], true);
                
                var typedLength:int = textInput.text.length;
                var item:Object = dataProvider ? dataProvider.getItemAt(matchingItems[0]) : undefined;
                if (item)
                {
                    // If we found a match, then replace the textInput text with the match and 
                    // select the non-typed characters
                    var itemString:String = itemToLabel(item);
                    textInput.selectAll();
                    textInput.insertText(itemString);
                    textInput.selectRange(typedLength, itemString.length);
                }
            }
            else
            {
                super.changeHighlightedSelection(CUSTOM_SELECTED_ITEM);
            }
        }
        else
        {
            // If the input string is empty, then don't select anything
            super.changeHighlightedSelection(NO_SELECTION);  
        }
    } */
    
    /**
     *  @private 
     */ 
    // Returns an array of possible values
    /* private function findMatchingItems(input:String):Vector.<int>
    {
        // For now, just select the first match
        var startIndex:int;
        var stopIndex:int;
        var retVal:int;  
        var retVector:Vector.<int> = new Vector.<int>;
                
        retVal = findStringLoop(input, 0, dataProvider.length); 
        
        if (retVal != -1)
            retVector.push(retVal);
        return retVector;
    } */
    
    /**
     *  @private 
     */ 
    /* private function getCustomSelectedItem():*
    {
        // Grab the text from the textInput and process it through labelToItemFunction
        var input:String = textInput.text;
        if (input == "")
            return undefined;
        else if (labelToItemFunction != null)
            return _labelToItemFunction(input);
        else
            return input;
    } */
    
    /**
     *  @private 
     *  Helper function to apply the textInput text to selectedItem
     */ 
    /* mx_internal function applySelection():void
    {
        if (actualProposedSelectedIndex == CUSTOM_SELECTED_ITEM)
        {
            var itemFromInput:* = getCustomSelectedItem();
            if (itemFromInput != undefined)
                setSelectedItem(itemFromInput, true);
            else
                setSelectedIndex(NO_SELECTION, true);
        }
        else
        {
            setSelectedIndex(actualProposedSelectedIndex, true);
        }

        if (textInput)
            textInput.selectRange(-1, -1);
        
        userTypedIntoText = false;
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
   /*  override protected function initializeAccessibility():void
    {
        if (ComboBox.createAccessibilityImplementation != null)
            ComboBox.createAccessibilityImplementation(this);
    } */
    
    /**
     *  @private 
     */
    /* override protected function commitProperties():void
    {        
        // Keep track of whether selectedIndex was programmatically changed
        var selectedIndexChanged:Boolean = _proposedSelectedIndex != NO_PROPOSED_SELECTION;
        
        // If selectedIndex was set to CUSTOM_SELECTED_ITEM, and no selectedItem was specified,
        // then don't change the selectedIndex
        if (_proposedSelectedIndex == CUSTOM_SELECTED_ITEM && 
            _pendingSelectedItem == undefined)
        {
            _proposedSelectedIndex = NO_PROPOSED_SELECTION;
        }
        
        super.commitProperties();
        
        if (textInput)
        {
            if (maxCharsChanged)
            {
                textInput.maxChars = _maxChars;
                maxCharsChanged = false;
            }
            
            if (promptChanged)
            {
                textInput.prompt = _prompt;
                promptChanged = false;
            }
            
            if (restrictChanged)
            {
                textInput.restrict = _restrict;
                restrictChanged = false;
            }
            
            if (typicalItemChanged)
            {
                if (typicalItem != null)
                {
                    var itemString:String = LabelUtil.itemToLabel(typicalItem, labelField, labelFunction);
                    textInput.typicalText = itemString;
                }
                else
                {
                    // Just set it back to the default value
                    textInput.widthInChars = 10; 
                }
                
                typicalItemChanged = false;
            }
        
			// Clear the TextInput because we were programmatically set to NO_SELECTION
			// We call this after super.commitProperties because commitSelection might have
			// changed the value to NO_SELECTION
			if (selectedIndexChanged && selectedIndex == NO_SELECTION)
				textInput.text = "";
		}
        
    }  */   
    
    /**
     *  @private 
     */ 
    /* override mx_internal function updateLabelDisplay(displayItem:* = undefined):void
    {
        super.updateLabelDisplay();
        
        if (textInput)
        {
            if (displayItem == undefined)
                displayItem = selectedItem;
            if (displayItem != null && displayItem != undefined)
            {
                textInput.text = LabelUtil.itemToLabel(displayItem, labelField, labelFunction);
            }
        }
    } */
    
    /**
     *  @private 
     */     
    /* override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName, instance);
        
        if (instance == textInput)
        {
            updateLabelDisplay();
            textInput.addEventListener(TextOperationEvent.CHANGE, textInput_changeHandler);
            textInput.addEventListener(TextOperationEvent.CHANGING, textInput_changingHandler);
            textInput.addEventListener(FocusEvent.FOCUS_IN, textInput_focusInHandler, true);
            textInput.addEventListener(FocusEvent.FOCUS_OUT, textInput_focusOutHandler, true);
            textInput.maxChars = maxChars;
            textInput.restrict = restrict;
            textInput.focusEnabled = false;
            
            if (textInput.textDisplay is RichEditableText)
                RichEditableText(textInput.textDisplay).batchTextInput = false;
        }
    } */
    
    /**
     *  @private 
     */     
    /* override protected function partRemoved(partName:String, instance:Object):void
    {
        super.partRemoved(partName, instance);
        
        if (instance == textInput)
        {
            textInput.removeEventListener(TextOperationEvent.CHANGE, textInput_changeHandler);
            textInput.removeEventListener(TextOperationEvent.CHANGING, textInput_changingHandler);
            textInput.removeEventListener(FocusEvent.FOCUS_IN, textInput_focusInHandler, true);
            textInput.removeEventListener(FocusEvent.FOCUS_OUT, textInput_focusOutHandler, true);
        }
    } */
	
	/**
	 *  @private
	 */
	override public function set enabled(value:Boolean):void
	{
		if (enabled == value)
			return;
		
		super.enabled = value;
	}
    
    /**
     *  @private 
     */ 
    /* override mx_internal function changeHighlightedSelection(newIndex:int, scrollToTop:Boolean = false):void
    {
        super.changeHighlightedSelection(newIndex, scrollToTop);
        
        if (newIndex >= 0 && newIndex < dataProvider.length)
        {
            var item:Object = dataProvider ? dataProvider.getItemAt(newIndex) : undefined;
            if (item && textInput)
            {
                var itemString:String = itemToLabel(item); 
                textInput.selectAll();
                textInput.insertText(itemString);
                textInput.selectAll();
             
                userTypedIntoText = false;
            }
        }
    } */
    
    /**
     *  @private 
     */ 
    /* override mx_internal function findKey(eventCode:int):Boolean
    {
        return false;
    } */
    
    /**
     *  @copy spark.components.supportClasses.ListBase#setSelectedIndex()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 11.1
     *  @playerversion AIR 3.4
     *  @productversion Royale 0.9.4
     */
    /* override public function setSelectedIndex(value:int, dispatchChangeEvent:Boolean = false, changeCaret:Boolean = true):void
    {
        // It is possible that the label display changed but the selection didn't.  If this is
        // the case, the label has to be updated since the setSelectedIndex code will short-circuit
        // and not commit the selection.
        // An example is if the label is deleted and then the first item is chosen from the
        // dropdown, the selectedIndex is still 0.
        if (userTypedIntoText && value == selectedIndex)
            updateLabelDisplay();
        
        super.setSelectedIndex(value, dispatchChangeEvent, changeCaret);
    } */
    
    // If the TextInput is in focus, listen for keyDown events in the capture phase so that 
    // we can process the navigation keys (UP/DOWN, PGUP/PGDN, HOME/END). If the ComboBox is in 
    // focus, just handle keyDown events in the bubble phase
    
    /**
     *  @private 
     */ 
    /* override protected function keyDownHandler(event:KeyboardEvent) : void
    {        
        if (!isTextInputInFocus)
            keyDownHandlerHelper(event);
    } */
    
    /**
     *  @private 
     */ 
    /* protected function capture_keyDownHandler(event:KeyboardEvent):void
    {        
        if (isTextInputInFocus)
            keyDownHandlerHelper(event);
    }
     */
    /**
     *  @private 
     */ 
    /* mx_internal function keyDownHandlerHelper(event:KeyboardEvent):void
    {
        super.keyDownHandler(event);
        
        if (event.keyCode == Keyboard.ENTER && !isDropDownOpen) 
        {
            // commit the current text
            applySelection();
        }
        else if (event.keyCode == Keyboard.ESCAPE)
        {
            // Restore the previous selectedItem
            if (textInput)
            {
                if (selectedItem != null)
                    textInput.text = itemToLabel(selectedItem);
                else
                textInput.text = "";
            }
            changeHighlightedSelection(selectedIndex);
        }
    } */
    
    /**
     *  @private
     */
    /* override public function setFocus():void
    {
        if (stage && textInput)
        {            
            stage.focus = textInput.textDisplay as InteractiveObject;            
        }
    } */
    
    /**
     *  @private
     */
    /* override protected function isOurFocus(target:DisplayObject):Boolean
    {
        if (!textInput)
            return false;
        
        return target == textInput.textDisplay;
    } */
    
    /**
     *  @private
     */
    /* override protected function focusInHandler(event:FocusEvent):void
    {
        super.focusInHandler(event);
        
        // Since the API ignores the visual editable and selectable 
        // properties make sure the selection should be set first.
        if (textInput && 
            (textInput.editable || textInput.selectable))
        {
            // Workaround RET handling the mouse and performing its own selection logic
            callLater(textInput.selectAll);
        }
        
        userTypedIntoText = false;
    } */
    
    /**
     *  @private
     */
    /* override protected function focusOutHandler(event:FocusEvent):void
    {
        // always commit the selection if we focus out        
        if (!isDropDownOpen)
        {
            if (textInput && 
                ((selectedItem == null && textInput.text != "") ||
                 textInput.text != itemToLabel(selectedItem)))
                applySelection();
        }
            
        dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
        
        super.focusOutHandler(event);
    } */
    
    /**
     *  @private
     */
    /* override mx_internal function dropDownController_openHandler(event:DropDownEvent):void
    {
        super.dropDownController_openHandler(event);
        
        // If the user typed in text, start off by not showing any selection
        // If this does match, then processInputField will highlight the match
        userProposedSelectedIndex = userTypedIntoText ? NO_SELECTION : selectedIndex;  
    } */
    
    /**
     *  @private 
     */ 
    /* override protected function dropDownController_closeHandler(event:DropDownEvent):void
    {        
        super.dropDownController_closeHandler(event);      
        
        // Commit the textInput text as the selection
        if (!event.isDefaultPrevented())
        {
            applySelection();
        }
    } */
    
    /**
     *  @private 
     */
    /* override protected function itemRemoved(index:int):void
    {
        if (index == selectedIndex)
            updateLabelDisplay("");
        
        super.itemRemoved(index);       
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private 
     */ 
    /* private function textInput_focusInHandler(event:FocusEvent):void
    {
        isTextInputInFocus = true;
    } */
    
    /**
     *  @private 
     */ 
    /* private function textInput_focusOutHandler(event:FocusEvent):void
    {
        isTextInputInFocus = false;
    } */
    
    /**
     *  @private 
     */ 
    /* private function textInput_changingHandler(event:TextOperationEvent):void
    {
        previousTextInputText = textInput.text;
    } */
    
    /**
     *  @private 
     */ 
    /* protected function textInput_changeHandler(event:TextOperationEvent):void
    {  
        userTypedIntoText = true;
        
        var operation:FlowOperation = event.operation;
        
        // TLF is batching some operations so it can undo them.  If it is a composite operation
        // look at the last one to figure out if it was a delete.
        var deleteText:Boolean = (operation is DeleteTextOperation || operation is CutOperation);
        if (operation is CompositeOperation)
        {
            const operations:Array = CompositeOperation(operation).operations;
            if (operations.length && operations[operations.length-1] is DeleteTextOperation)
                deleteText = true;
        }
        
        // If deleting text do not want to do item completion or it isn't possible to delete
        // individual characters.  If the combo is open, leave it open, even if all the text
        // is deleted.
        if (deleteText)
        {
            // To commit the selection correctly on close, applySelection needs this set. 
            actualProposedSelectedIndex = CUSTOM_SELECTED_ITEM; 
            
            // Update the selected item in the list.
            super.changeHighlightedSelection(CUSTOM_SELECTED_ITEM);
        }        
        else if (previousTextInputText != textInput.text)
        {
            if (openOnInput)
            {
                if (!isDropDownOpen)
                {
                    // Open the dropDown if it isn't already open
                    openDropDown();
                    addEventListener(DropDownEvent.OPEN, editingOpenHandler);
                    return;
                }   
            }
            
            processInputField();
        }  
    }
     */
    /**
     *  @private 
     */ 
    /* private function editingOpenHandler(event:DropDownEvent):void
    {
        removeEventListener(DropDownEvent.OPEN, editingOpenHandler);
        processInputField();
    } */

    //----------------------------------
    //  enableIME
    //----------------------------------

    /**
     *  @copy spark.components.TextInput#enableIME
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get enableIME():Boolean
    {
        if (textInput)
        {
            return textInput.enableIME;
        }
                  
        return false;
    } */

    //----------------------------------
    //  imeMode
    //----------------------------------

    /**
     *  @copy spark.components.TextInput#imeMode
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get imeMode():String
    {
        if (textInput)
        {
            return textInput.imeMode;
        }
        return null;
    } */

    /**
     *  @public
     */
    /* public function set imeMode(value:String):void
    {
        if (textInput)
        {
            textInput.imeMode = value;
            invalidateProperties();                    
        }
    } */
        
}
}