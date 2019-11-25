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
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.EventDispatcher;

import mx.core.FlexGlobals;
import mx.core.IVisualElement;
import mx.core.IVisualElementContainer;
import mx.core.UIComponent;
import mx.utils.NameUtil;
 import mx.events.ItemClickEvent;
 import mx.core.IMXMLObject;


 */
 import org.apache.royale.events.Event;
import org.apache.royale.events.EventDispatcher;
 import mx.events.FlexEvent;
 import mx.core.IFlexDisplayObject;

 import mx.core.mx_internal;

use namespace mx_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the value of the selected RadioButton component in
 *  this group changes.
 *
 *  @eventType flash.events.Event.CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
[Event(name="change", type="org.apache.royale.events.Event")]

/**
 *  Dispatched when a user selects a RadioButton component in the group.
 *  You can also set a handler for individual RadioButton components.
 *
 *  This event is dispatched only when the 
 *  user interacts with the radio buttons by using the mouse.
 *
 *  @eventType mx.events.ItemClickEvent.ITEM_CLICK
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
[Event(name="itemClick", type="mx.events.ItemClickEvent")]

//--------------------------------------
//  Validation events
//--------------------------------------

/**
 *  Dispatched when values are changed programmatically
 *  or by user interaction.
 *
 *  <p>Because a programmatic change triggers this event, make sure
 *  that any <code>valueCommit</code> event handler does not change
 *  a value that causes another <code>valueCommit</code> event.
 *  For example, do not change the<code>selectedValue</code>
 *  property or <code>selection</code> property in a <code>valueCommit</code> 
 *  event handler. </p>
 *
 *  @eventType mx.events.FlexEvent.VALUE_COMMIT
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
 [Event(name="valueCommit", type="mx.events.FlexEvent")]

//--------------------------------------
//  Other metadata
//--------------------------------------

//[IconFile("RadioButtonGroup.png")]
[DefaultTriggerEvent("change")]

/**
 *  The RadioButtonGroup component defines a group of RadioButton components
 *  that act as a single mutually exclusive component; therefore,
 *  a user can select only one RadioButton component at a time.
 *  The <code>id</code> property is required when you use the
 *  <code>&lt;s:RadioButtonGroup&gt;</code> tag to define the group name.  Any
 *  <code>&lt;s:RadioButton&gt;</code> component added to this group will 
 *  have this group name.
 *
 *  <p>Notice that the RadioButtonGroup component is a subclass of EventDispatcher,
 *  not UIComponent, and implements the IMXMLObject interface.
 *  All other Flex visual components implement the IVisualElement interface.
 *  The RadioButtonGroup component declaration must
 *  be contained within the <code>&lt;Declarations&gt;</code> tag since it is
 *  not assignable to IVisualElement.</p> 
 *
 *  <p>To use this component in a list-based component, such as a List or DataGrid, 
 *  create an item renderer.
 *  For information about creating an item renderer, see 
 *  <a href="http://help.adobe.com/en_US/flex/using/WS4bebcd66a74275c3-fc6548e124e49b51c4-8000.html">
 *  Custom Spark item renderers</a>. </p>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;s:RadioButtonGroup&gt;</code> tag inherits all of the
 *  tag attributes of its superclass, and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:RadioButtonGroup
 *    <strong>Properties</strong>
 *    enabled="true"
 *    selectedValue="null"
 *    selection="null"
 *
 *    <strong>Events</strong>
 *    change="<i>No default</i>"
 *    itemClick="<i>No default</i>"
 *    valueCommit="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *
 *  @see spark.components.RadioButton
 *  @includeExample examples/RadioButtonGroupExample.mxml
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
public class RadioButtonGroup extends EventDispatcher 
{ //implements IMXMLObject
   // include "../core/Version.as";

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
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function RadioButtonGroup(document:IFlexDisplayObject = null)
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
     *  Since there is no id, generate one, if needed.
     */
    //private var _name:String;

    /**
     *  @private
     *  The document containing a reference to this RadioButtonGroup.
     */
    //private var document:IFlexDisplayObject;

    /**
     *  @private
     *  An Array of the RadioButtons that belong to this group.
     */
    private var radioButtons:Array /* of RadioButton */ = [];

    /**
     *  @private
     *  Whether the group is enabled.  This can be different than the individual
     *  radio buttons in the group.
     */
    private var _enabled:Boolean = true;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  enabled
    //----------------------------------

    //[Inspectable(category="General", defaultValue="true")]

    /**
     *  Determines whether selection is allowed.  Note that the value returned
     *  only reflects the value that was explicitly set on the 
     *  <code>RadioButtonGroup</code> and does not reflect any values explicitly
     *  set on the individual RadioButtons. 
     *
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
     public function get enabled():Boolean
    {
        return _enabled;
    } 

    /**
     *  @private
     */
    public function set enabled(value:Boolean):void
    {
        if (_enabled == value)
            return;

        _enabled = value;

        // The group state changed.  Invalidate all the radio buttons.  The
        // radio button skin most likely will change.
       // for (var i:int = 0; i < numRadioButtons; i++)
         //   getRadioButtonAt(i).invalidateSkinState();
    } 

    //----------------------------------
    //  numRadioButtons
    //----------------------------------

    //[Bindable("numRadioButtonsChanged")]

    /**
     *  The number of RadioButtons that belong to this RadioButtonGroup.
     *
     *  @default "0"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
     public function get numRadioButtons():int
    {
        return radioButtons.length;
    } 


    //----------------------------------
    //  selectedIndex
    //----------------------------------

    /**
    *  @private
    */
    private var _selectedIndex:int = -1;

    //[Bindable("change")]
    //[Bindable("valueCommit")]
    //[Inspectable(category="General")]

    /**
    *  The index of the selected RadioButton component in the group.
    *  If a RadioButton is not selected, this property is <code>-1</code>.
    *
    *  @default -1
    *
    *  @langversion 3.0
    *  @playerversion Flash 11.1
    *  @playerversion AIR 3.4
    *  @productversion Royale 0.9.4
    */
    public function get selectedIndex():int
    {
        return _selectedIndex;
    }

    /**
    *  @private.
    */
    public function set selectedIndex(newValue:int):void
    {
        if (newValue == _selectedIndex)
        {
            return;
        }

        if (newValue == -1)
        {
            setSelection(null, false);
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));

            return;
        }

        changeSelection(newValue, false)

        dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
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
    //[Bindable("valueCommit")]
    [Inspectable(category="General")]

    /**
     *  The <code>value</code> property of the selected
     *  RadioButton component in the group, if it has been set,
     *  otherwise, the <code>label</code> property of the selected RadioButton.
     *  If no RadioButton is selected, this property is <code>null</code>.
     *
     *  <p>If you set <code>selectedValue</code>, Flex selects the
     *  first RadioButton component whose <code>value</code> or
     *  <code>label</code> property matches this value.</p>
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
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
        // The rbg might set the selectedValue before the radio buttons are
        // initialized and inserted in the group.  This will hold the selected 
        // value until it can be put in the group.
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
                radioButton.label == value)
            {
                changeSelection(i, false);
                _selectedValue = null;
                
                dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));

                break;
            }
        }
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
     *  RadioButton component in the group.
     *  You can access this property in ActionScript only;
     *  it is not settable in MXML.
     *  Setting this property to <code>null</code> deselects the currently
     *  selected RadioButton component.  A change event is not dispatched.
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
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
        if ( _selection == value)
            return;
        
        // Going through the selection setter should never fire a change event.
        setSelection(value, false);
    } 

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Implementation of the <code>IMXMLObject.initialized()</code> method
     *  to support deferred instantiation.
     *
     *  @param document The MXML document that created this object.
     *
     *  @param id The identifier used by document to refer to this object.
     *  If the object is a deep property on document, <code>id</code> is null.
     *
     *  @see mx.core.IMXMLObject
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function initialized(document:Object, id:String):void
    {
        _name = id;
        
        this.document = document ?
                        IFlexDisplayObject(document) :
                        IFlexDisplayObject(FlexGlobals.topLevelApplication);
    } */

    /**
     *  Returns the RadioButton component at the specified index.
     *
     *  @param index The 0-based index of the RadioButton in the
     *  RadioButtonGroup.
     *
     *  @return The specified RadioButton component if index is between
     *  0 and <code>numRadioButtons</code> - 1.  Returns
     *  <code>null</code> if the index is invalid.
     * 
     *  @see numRadioButtons
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
     public function getRadioButtonAt(index:int):RadioButton
    {
        if (index >= 0 && index < numRadioButtons)
            return radioButtons[index];
            
        return null;
    } 

    /**
     *  @private
     *  String to uniquely identify this radio button group.
     */
    /* mx_internal function get name():String
    {
        if (_name == null)               
            _name = NameUtil.createUniqueName(this);

        return _name;
    } */

    /**
     *  @private
     *  Add a radio button to the group.  This can be called by
     *  RadioButton or via the addedHandler when applying a state.
     */
    mx_internal function addInstance(instance:RadioButton):void
    {
        // During a state transition, called when rb is removed from 
        // display list.
        //instance.addEventListener(Event.REMOVED, radioButton_removedHandler);
        
        radioButtons.push(instance);

		// Apply group indices in "tab order" or "breadth-first" order.
        //radioButtons.sort(readOrderCompare);
        for (var i:int = 0; i < radioButtons.length; i++)
            radioButtons[i].indexNumber = i;
        
        // There is a pending selectedValue.  See if we can set it now.
        if (_selectedValue != null)
            selectedValue = _selectedValue;
                
        // If this radio button is selected, then it becomes the selection
        // for the group.
        if (instance.selected == true)
            selection = instance;

        instance.radioButtonGroup = this;
        instance.invalidateSkinState();
        
        dispatchEvent(new Event("numRadioButtonsChanged"));
    }

    /**
     *  @private
     *  Remove a radio button from the group.  This can be called by
     *  RadioButton or via the removedHandler when removing a state.
     */
    private function removeInstance(instance:RadioButton):void
    {
        if (instance)
        {
            var foundInstance:Boolean = false;
            for (var i:int = 0; i < numRadioButtons; i++)
            {
                var rb:RadioButton = getRadioButtonAt(i);

                if (foundInstance)
                {
                    // Decrement the indexNumber for each button after the removed button.
                    rb.indexNumber = rb.indexNumber - 1;
                }
                else if (rb == instance)
                {
                    // During a state transition, called when rb is added back 
                    // to display list.
                    //instance.addEventListener(Event.ADDED, radioButton_addedHandler);
        
                    // Don't set the group to null.  If this is being removed
                    // because the state changed, the group will be needed
                    // if the radio button is readded later because of another
                    // state transition.
                    //rb.group = null;

                    // If the rb is selected, leave the button itself selected
                    // but clear the selection for the group.
                    if (instance == _selection)
                        _selection = null;

                    instance.radioButtonGroup = null;
                    instance.invalidateSkinState();

                    // Remove the radio button from the internal array.
                    radioButtons.splice(i,1);
                    foundInstance = true;

                    // redo the same index because we removed the previous item at this index
                    i--;
                }
            }

            if (foundInstance)
                dispatchEvent(new Event("numRadioButtonsChanged"));
        }
    }

    /**
     *  @private
     */
    mx_internal function setSelection(value:RadioButton, fireChange:Boolean = true):void
    {
        if (_selection == value)
            return;
            
        if (value == null)
        {
            if (selection != null)
            {
                _selection.selected = false;
                _selection = null;
                _selectedIndex = -1;
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
                    changeSelection(i, fireChange);
                    break;
                }
            }
        }

        dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
    }
    
    /**
     *  @private
     */
    private function changeSelection(index:int, fireChange:Boolean = true):void
    {
        var rb:RadioButton = getRadioButtonAt(index);
        if (rb && rb != _selection)
        {
            // Unselect the currently selected radio
            if (_selection)
                _selection.selected = false;

            // Change the focus to the new radio.
            // Set the state of the new radio to true.
            // Fire a click event for the new radio.
            // Fire a click event for the radio group.
            _selection = rb;
            _selection.selected = true;
            _selectedIndex = index;
            if (fireChange)
                dispatchEvent(new Event(Event.CHANGE));
        }
    }

    /**
     *  @private
     *  Sandbox root of RadioButton "a" in readOrderCompare().
     */
    //private var aSbRoot:DisplayObject;
    
    /**
     *  @private
     *  Sandbox root of RadioButton "b" in readOrderCompare().
     */
    //private var bSbRoot:DisplayObject;

    /**
     *  @private
	 *  Comparison function used to sort items as they are added to the radioButtons array.
	 *  Compares by tabIndex or if neither item defines a tabIndex, by "breadthOrder."
	 * 
     *  Returns -1 if a is before b in sort order, 0 if a and b have same
     *  sort order and 1 if a after b in sort order.
     */
    /* private function readOrderCompare(a:DisplayObject, b:DisplayObject):Number
    {
        var aParent:DisplayObjectContainer = a.parent;
        var bParent:DisplayObjectContainer = b.parent;
        
        if (!aParent || !bParent)
            return 0;
   
        // Only set when a is the radio button.  The sandbox root should be the
        // same for the parents.
        if (a is RadioButton)
            aSbRoot = RadioButton(a).systemManager.getSandboxRoot();
            
        // Only set when b is the radio button.  The sandbox root should be the
        // same for the parents.
        if (b is RadioButton)
            bSbRoot = RadioButton(b).systemManager.getSandboxRoot();
        
        // If reached the sandbox root of either then done.
        if (aParent == aSbRoot || bParent == bSbRoot)
            return 0;    
		
		// first check to see if we can compare by tabIndex
		var aTabIndex:int = (a is InteractiveObject) ? InteractiveObject(a).tabIndex : -1;
		var bTabIndex:int = (b is InteractiveObject) ? InteractiveObject(b).tabIndex : -1;
		
		// if one of the items being compared has a defined tabIndex, compare by tabIndex
		if(aTabIndex > -1 || bTabIndex > -1)
		{
			if (aTabIndex > bTabIndex)
				return (bTabIndex == -1) ? -1 : 1; // items with assigned tabIndex come before those without
			if (aTabIndex < bTabIndex)
				return (aTabIndex == -1) ? 1 : -1; // items without assigned tabIndex come after those without
			if (a == b)
				return 0;
		}

		// if neither item has a defined tabIndex, compare by "breadthOrder"
        var aNestLevel:int = (a is UIComponent) ? UIComponent(a).nestLevel : -1;
        var bNestLevel:int = (b is UIComponent) ? UIComponent(b).nestLevel : -1;

        var aIndex:int = 0;
        var bIndex:int = 0;
        
        if (aParent == bParent)
        {
            if (aParent is IVisualElementContainer && a is IVisualElement)
                aIndex = IVisualElementContainer(aParent).getElementIndex(IVisualElement(a));
            else
                aIndex = DisplayObjectContainer(aParent).getChildIndex(a);
                
            if (bParent is IVisualElementContainer && b is IVisualElement)
                bIndex = IVisualElementContainer(bParent).getElementIndex(IVisualElement(b));
            else
                bIndex = DisplayObjectContainer(bParent).getChildIndex(b);
        }
        
        if (aNestLevel > bNestLevel || aIndex > bIndex)
            return 1;
        else if (aNestLevel < bNestLevel ||  bIndex > aIndex)
            return -1;
        else if (a == b)
            return 0;
        else // Nest levels are identical, compare ancestors.
            return readOrderCompare(aParent, bParent);
    } */

    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------
     /**
     *  @private
     *  Called during a state transition when rb is added back to display list.
     */
    /* private function radioButton_addedHandler(event:Event):void
    {
        var rb:RadioButton = event.target as RadioButton;
        if (rb)
        {
            //trace("radioButton_addedHandler", rb.id);
            rb.removeEventListener(Event.ADDED, radioButton_addedHandler);
            addInstance(rb);
        }
    } */

     /**
     *  @private
     */
    /* private function radioButton_removedHandler(event:Event):void
    {
        var rb:RadioButton = event.target as RadioButton;
        if (rb)
        {
            //trace("radioButton_removedHandler", rb.id);
            rb.removeEventListener(Event.REMOVED, radioButton_removedHandler);
            removeInstance(rb);
        }
    } */
}

}
