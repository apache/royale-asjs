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
import org.apache.royale.core.IDocument;
import org.apache.royale.events.Event;
import org.apache.royale.events.EventDispatcher;
/*
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.EventDispatcher;

import mx.core.FlexGlobals;
import mx.core.IFlexDisplayObject;
import mx.core.IMXMLObject;
import mx.core.IRawChildrenContainer;
*/
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.FlexEvent;
import mx.events.ItemClickEvent;
use namespace mx_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the value of the selected RadioButton control in
 *  this group changes.
 *
 *  @eventType flash.events.Event.CHANGE
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="change", type="org.apache.royale.events.Event")]

/**
 *  Dispatched when a user selects a RadioButton control in the group.
 *  You can also set a handler for individual RadioButton controls.
 *
 *  @eventType mx.events.ItemClickEvent.ITEM_CLICK
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="itemClick", type="mx.events.ItemClickEvent")]

/**
 *  The RadioButtonGroup control defines a group of RadioButton controls
 *  that act as a single mutually exclusive control; therefore,
 *  a user can select only one RadioButton control at a time. While grouping
 *  RadioButton instances
 *  in a RadioButtonGroup is optional, a group lets you do things
 *  like set a single event handler on a group of buttons, rather than
 *  on each individual button.
 *
 *  <p>The <code>id</code> property is required when you use the
 *  <code>&lt;mx:RadioButtonGroup&gt;</code> tag to define the name
 *  of the group.</p>
 *
 *  <p>Notice that the RadioButtonGroup control is a subclass of EventDispatcher, not UIComponent,
 *  and implements the IMXMLObject interface.
 *  All other Flex visual components are subclasses of UIComponent, which implements
 *  the IUIComponent interface.
 *  The RadioButtonGroup control has support built into the Flex compiler
 *  that allows you to use the RadioButtonGroup control as a child of a Flex container,
 *  even though it does not implement IUIComponent.
 *  All other container children must implement the IUIComponent interface.</p>
 *
 *  <p>Therefore, if you try to define a visual component as a subclass of
 *  EventDispatcher that implements the IMXMLObject interface,
 *  you will not be able to use it as the child of a container.</p>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:RadioButtonGroup&gt;</code> tag inherits all of the
 *  tag attributes of its superclass, and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:RadioButtonGroup
 *    <strong>Properties</strong>
 *    enabled="true|false"
 *    id="<i>No default</i>"
 *    labelPlacement="right|left|top|bottom"
 *
 *    <strong>Events</strong>
 *    change="<i>No default</i>"
 *    itemClick="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *
 *  @includeExample examples/RadioButtonGroupExample.mxml
 *
 *  @see mx.controls.RadioButton
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class RadioButtonGroup extends EventDispatcher
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param document In simple cases where a class extends EventDispatcher,
     *  the <code>document</code> parameter should not be used.
     *
     *  @see flash.events.EventDispatcher
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function RadioButtonGroup(document:IDocument = null)
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
     *  The document containing a reference to this RadioButtonGroup.
     */
    private var document:IDocument;

    /**
     *  @private
     *  An Array of the RadioButtons that belong to this group.
     */
    private var radioButtons:Array /* of RadioButton */ = [];

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  enabled
    //----------------------------------

    [Bindable("enabledChanged")]
    [Inspectable(category="General", defaultValue="true")]

    /**
     *  Determines whether selection is allowed.
     *
     *  @default true
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get enabled():Boolean
    {
//         var s:Number = 0;
//
//         var n:int = numRadioButtons;
//         for (var i:int = 0; i < n; i++)
//         {
//             s = s + getRadioButtonAt(i).enabled;
//         }
//
//         if (s == 0)
//             return false;
//
//         if (s == n)
//             return true;

        return false;
    }

    /**
     *  @private
     */
    public function set enabled(value:Boolean):void
    {
//         var n:int = numRadioButtons;
//         for (var i:int = 0; i < n; i++)
//         {
//             getRadioButtonAt(i).enabled = value;
//         }
//
//         dispatchEvent(new Event("enabledChanged"));
    }

    //----------------------------------
    //  labelPlacement
    //----------------------------------

    /**
     *  @private
     *  Storage for the labelPlacement property.
     */
    private var _labelPlacement:String = "right";

    [Bindable("labelPlacementChanged")]
    [Inspectable(category="General", enumeration="left,right,top,bottom", defaultValue="right")]

    /**
     *  Position of the RadioButton label relative to the RadioButton icon
     *  for each control in the group.
     *  You can override this setting for the individual controls.
     *
     *  <p>Valid values in MXML are <code>"right"</code>, <code>"left"</code>,
     *  <code>"bottom"</code>, and <code>"top"</code>. </p>
     *
     *  <p>In ActionScript, you use the following constants to set this property:
     *  <code>ButtonLabelPlacement.RIGHT</code>, <code>ButtonLabelPlacement.LEFT</code>,
     *  <code>ButtonLabelPlacement.BOTTOM</code>, and <code>ButtonLabelPlacement.TOP</code>.</p>
     *
     *  @default "right"
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get labelPlacement():String
    {
        return _labelPlacement;
    }

    /**
     *  @private
     */
    public function set labelPlacement(value:String):void
    {
        _labelPlacement = value;

//         var n:int = numRadioButtons;
//         for (var i:int = 0; i < n; i++)
//         {
//             getRadioButtonAt(i).labelPlacement = value;
//         }
    }

    //----------------------------------
    //  numRadioButtons
    //----------------------------------

    [Bindable("numRadioButtonsChanged")]

    /**
     *  The number of RadioButtons that belong to this RadioButtonGroup.
     *
     *  @default "undefined"
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get numRadioButtons():int
    {
        return radioButtons.length;
    }

    //----------------------------------
    //  selectedValue
    //----------------------------------

    /**
     *  @private
     *  Storage for the selectedValue property.
     */
    private var _selectedValue:Object;

    [Bindable("change")]
    [Bindable("valueCommit")]
    [Inspectable(category="General")]

    /**
     *  The value of the <code>value</code> property of the selected
     *  RadioButton control in the group, if this has been set
     *  to be something other than <code>null</code> (the default value).
     *  Otherwise, <code>selectedValue</code> is the value of the
     *  <code>label</code> property of the selected RadioButton.
     *  If no RadioButton is selected, this property is <code>null</code>.
     *
     *  <p>If you set <code>selectedValue</code>, Flex selects the
     *  RadioButton control whose <code>value</code> or
     *  <code>label</code> property matches this value.</p>
     *
     *  @default null
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectedValue():Object
    {
         if (selection)
         {
             return selection.value != null ?
                    selection.value :
                    selection.label;
         }

        return null;
    }

    /**
     *  @private.
     */
    public function set selectedValue(value:Object):void
    {
		 if (_selectedValue == value) return;
		
         _selectedValue = value;

         // Clear the exisiting selecton if there is one.
         if (value == null)
         {
             setSelection(null, false);
             return;
         }

         // Find the radio button value specified.
         var n:int = numRadioButtons;
         for (var i:int = 0; i < n; i++)
         {
             var radioButton:RadioButton = getRadioButtonAt(i);
             if (radioButton.value == value ||
                 value != "" && radioButton.label == value)
             {
                 changeSelection(i, false);
                 break;
             }
         }

//         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
    }

    //----------------------------------
    //  selection
    //----------------------------------

    /**
     *  @private
     *  Reference to the selected radio button.
     */
    private var _selection:RadioButton;

    [Bindable("change")]
    [Bindable("valueCommit")]
    [Inspectable(category="General")]

    /**
     *  Contains a reference to the currently selected
     *  RadioButton control in the group.
     *  You can access the property in ActionScript only;
     *  it is not settable in MXML.
     *  Setting this property to <code>null</code> deselects the currently selected RadioButton control.
     *
     *  @default null
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selection():RadioButton
    {
        return _selection;
    }

    /**
     *  @private
     */
    public function set selection(value:RadioButton):void
    {
        // Going through the selection setter should never fire a change event.
        setSelection(value, false);
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------


    /**
     *  Returns the RadioButton control at the specified index.
     *
     *  @param index The index of the RadioButton control in the
     *  RadioButtonGroup control, where the index of the first control is 0.
     *
     *  @return The specified RadioButton control.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getRadioButtonAt(index:int):RadioButton
    {
        return RadioButton(radioButtons[index]);
    }

    /**
     *  @private
     *  Add a radio button to the group.
     */
    mx_internal function addInstance(instance:RadioButton):void
    {
         //instance.addEventListener(Event.REMOVED, radioButton_removedHandler);
         radioButtons.push(instance);

         // Apply group indices in "tab order" or "breadth-first" order.
         // TODO (aharui) later: radioButtons.sort(readOrderCompare);
         //for (var i:int = 0; i < radioButtons.length; i++)
         //    RadioButton(radioButtons[i]).indexNumber = i;

         if (_selectedValue != null)
             selectedValue = _selectedValue;

        // If this radio button is selected, then it becomes the selection
        // for the group.
        if (instance.selected == true)
            selection = instance;

// 		dispatchEvent(new Event("numRadioButtonsChanged"));
    }

    /**
     *  @private
     *  Remove a radio button from the group.
     */
//    protected function removeInstance(instance:RadioButton):void
//    {
//         if (instance)
//         {
//
//             var foundInstance:Boolean = false;
//             for (var i:int = 0; i < numRadioButtons; i++)
//             {
//                 var rb:RadioButton = getRadioButtonAt(i);
//
//                 if (foundInstance)
//                 {
//                     // Decrement the indexNumber for each button after the removed button.
//                     rb.indexNumber--;
//                 }
//                 else if (rb == instance)
//                 {
//                 	rb.group = null;
//
//                     if (instance == _selection)
//                     {
//                         _selection = null;
//                     }
//                     // Remove the radio button from the internal array
//                     radioButtons.splice(i,1);
//                     foundInstance = true;
//                     // redo the same index because we removed the previous item at this index
//                     i--;
//                 }
//             }
//
//             if (foundInstance)
// 				dispatchEvent(new Event("numRadioButtonsChanged"));
//         }
//    }

    /**
     *  @private
     *  Return the value or the label value
     *  of the selected radio button.
     */
//    private function getValue():String
//    {
//         if (selection)
//         {
//             return selection.value &&
//                    selection.value is String &&
//                    String(selection.value).length != 0 ?
//                    String(selection.value) :
//                    selection.label;
//         }
//         else
//         {
//             return null;
//         }
//		return null;
//    }

    private var inSetSelection:Boolean;
    
    /**
     *  @private
     */
    public function setSelection(value:RadioButton, fireChange:Boolean = true):void
    {
         if (inSetSelection) return;
        
         if (value == null)
         {
             if (selection != null)
             {
                 _selection.selected = false;
                 _selection = null;
                 if (fireChange)
                     dispatchEvent(new Event(Event.CHANGE));
             }
         }
         else
         {
             var n:int = numRadioButtons;
             for (var i:int = 0; i < n; i++)
             {
                 if (value == getRadioButtonAt(i))
                 {
                     inSetSelection = true;
                     changeSelection(i, fireChange);
                     inSetSelection = false;
                     break;
                 }
             }
         }

//         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
    }

    /**
     *  @private
     */
    private function changeSelection(index:int, fireChange:Boolean = true):void
    {
         if (getRadioButtonAt(index))
         {
             // Unselect the currently selected radio
             if (selection)
                 selection.selected = false;

             // Change the focus to the new radio.
             // Set the state of the new radio to true.
             // Fire a click event for the new radio.
             // Fire a click event for the radio group.
             _selection = getRadioButtonAt(index);
             _selection.selected = true;
             if (fireChange)
                 dispatchEvent(new Event(Event.CHANGE));
         }
    }

    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------
     /**
     *  @private
     */
//    private function radioButton_removedHandler(event:Event):void
//    {
//         var rb:RadioButton = event.target as RadioButton;
//         if (rb)
//         {
//         	rb.removeEventListener(Event.REMOVED, radioButton_removedHandler);
//             removeInstance(RadioButton(event.target));
//         }
//    }
}

}
