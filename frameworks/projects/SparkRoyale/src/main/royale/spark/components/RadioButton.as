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
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;
 */
import mx.core.IFlexDisplayObject;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.FlexEvent;
import mx.managers.IFocusManager;

import spark.components.supportClasses.ToggleButtonBase;

import org.apache.royale.events.Event;

COMPILE::JS
{
    import window.Text;
    import org.apache.royale.core.WrappedHTMLElement;
    import org.apache.royale.html.supportClasses.RadioButtonIcon;
    import org.apache.royale.html.util.addElementToWrapper;
}

//import mx.managers.IFocusManagerGroup;

use namespace mx_internal;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  Orientation of the icon in relation to the label.
 *  Valid MXML values are <code>right</code>, <code>left</code>,
 *  <code>bottom</code>, and <code>top</code>.
 *
 *  <p>In ActionScript, you can use the following constants
 *  to set this property:
 *  <code>IconPlacement.RIGHT</code>,
 *  <code>IconPlacement.LEFT</code>,
 *  <code>IconPlacement.BOTTOM</code>, and
 *  <code>IconPlacement.TOP</code>.</p>
 *
 *  @default IconPlacement.LEFT
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="iconPlacement", type="String", enumeration="top,bottom,right,left", inherit="no", theme="mobile")]

/**
 *  @copy spark.components.supportClasses.GroupBase#style:symbolColor
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */ 
//[Style(name="symbolColor", type="uint", format="Color", inherit="yes", theme="spark, mobile")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------

[Exclude(name="cornerRadius", kind="style")]
[Exclude(name="icon", kind="style")]
[Exclude(name="textAlign", kind="style")]

//--------------------------------------
//  Other metadata
//--------------------------------------

//[AccessibilityClass(implementation="spark.accessibility.RadioButtonAccImpl")]

//[IconFile("RadioButton.png")]

/**
 *  The RadioButton component allows the user make a single choice
 *  within a set of mutually exclusive choices.
 *  A RadioButtonGroup is composed of two or more RadioButton components
 *  with the same <code>groupName</code> property.
 *  While grouping RadioButton instances in a RadioButtonGroup is optional,
 *  a group lets you do things like set a single event handler on a group of 
 *  RadioButtons, rather than on each individual RadioButton.
 *
 *  <p>The RadioButton group can refer to the a group created by the
 *  <code>&lt;s:RadioButtonGroup&gt;</code> tag.
 *  The user selects only one member of the group at a time.
 *  Selecting an unselected group member deselects the currently selected
 *  RadioButton component within that group.</p>
 *
 *  <p>To use this component in a list-based component, such as a List or DataGrid, 
 *  create an item renderer.
 *  For information about creating an item renderer, see 
 *  <a href="http://help.adobe.com/en_US/flex/using/WS4bebcd66a74275c3-fc6548e124e49b51c4-8000.html">
 *  Custom Spark item renderers</a>. </p>
 *
 *  <p>The RadioButton component has the following default characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>Wide enough to display the text label of the component</td>
 *        </tr>
 *        <tr>
 *           <td>Minimum size</td>
 *           <td>18 pixels wide and 18 pixels high</td>
 *        </tr>
 *        <tr>
 *           <td>Maximum size</td>
 *           <td>10000 pixels wide and 10000 pixels high</td>
 *        </tr>
 *        <tr>
 *           <td>Default skin class</td>
 *           <td>spark.skins.spark.RadioButtonSkin</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;s:RadioButton&gt;</code> tag inherits all of the tag
 *  attributes of its superclass, and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:RadioButton
 *    <strong>Properties</strong>
 *    enabled=""
 *    group="<i>the automatically created default RadioButtonGroup</i>"
 *    groupName="radioGroup"
 *    value="null"
 *  /&gt;
 *  </pre>
 *
 *  @see spark.components.RadioButtonGroup
 *  @see spark.skins.spark.RadioButtonSkin
 *  @includeExample examples/RadioButtonExample.mxml
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
public class RadioButton extends ToggleButtonBase 
{ // implements IFocusManagerGroup
  //  include "../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Class mixins
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Placeholder for mixin by RadioButtonAccImpl.
     */
    //mx_internal static var createAccessibilityImplementation:Function;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function RadioButton()
    {
        super();

        // Button variables.
        
        // Start out in the default group.  The button is always in a group,
        // either explicitly or implicitly.
        groupName = "radioGroup";
    }
    
    /**
     * @private
     * 
     *  @royalesuppresspublicvarwarning
     */
    COMPILE::JS
    public static var radioCounter:int = 0;
    
    COMPILE::JS
    private var labelFor:HTMLLabelElement;
    COMPILE::JS
    private var textNode:window.Text;
    COMPILE::JS
    private var rbicon:RadioButtonIcon;
    
    /**
     * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
     * @royaleignorecoercion HTMLInputElement
     * @royaleignorecoercion HTMLLabelElement
     * @royaleignorecoercion Text
     */
    COMPILE::JS
    override protected function createElement():WrappedHTMLElement
    {
        rbicon = new RadioButtonIcon()
        rbicon.id = '_radio_' + RadioButton.radioCounter++;
        rbicon.element.addEventListener("click", rbClickHandler);
        
        textNode = document.createTextNode('') as window.Text;
        
        labelFor = addElementToWrapper(this,'label') as HTMLLabelElement;
        labelFor.appendChild(rbicon.element);
        labelFor.appendChild(textNode);
        
        (textNode as WrappedHTMLElement).royale_wrapper = this;
        (rbicon.element as WrappedHTMLElement).royale_wrapper = this;
        
        typeNames = 'RadioButton';
        
        return element;
    }
    
    /**
     * @royaleignorecoercion HTMLInputElement
     */
    COMPILE::JS
    private function rbClickHandler(event:Event):void
    {
        selected = (rbicon.element as HTMLInputElement).checked;
        if (group)
            group.setSelection(this);
    }
    
    COMPILE::JS
    override public function set id(value:String):void
    {
        super.id = value;
        labelFor.id = value;
        rbicon.element.id = value;
    }
    
    COMPILE::JS
    override public function get label():String
    {
        return textNode.nodeValue as String;
    }
    
    COMPILE::JS
    override public function set label(value:String):void
    {
        textNode.nodeValue = value;
    }
    
    /**
     * @royaleignorecoercion HTMLInputElement
     */
    override public function set selected(value:Boolean):void
    {
        super.selected = value;
        COMPILE::JS
            {
                (rbicon.element as HTMLInputElement).checked = value;
            }
        dispatchEvent(new Event("selectedChanged"));
    }    

    COMPILE::JS
    override public function get measuredWidth():Number
    {
        var mw:Number = super.measuredWidth;
        return mw + 1; // factor in gap between icon and label?
    }
         
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Default inital index value
     */
    mx_internal var indexNumber:int = 0;
    
    /**
     *  @private
     *  The RadioButtonGroup that this radio button is in.  The group property
     *  should not be used to keep track of the radio button group for this radio
     *  button.  During state transitions, the radio button may come
     *  and go from the group and the group property is not reset.  The group
     *  property, if initially set, is needed when the radio button is readded
     *  to the group.
     */
    mx_internal var radioButtonGroup:RadioButtonGroup = null;
     
    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  enabled
    //----------------------------------

    /**
     *  The RadioButton component is enabled if the 
     *  RadioButtonGroup is enabled and the RadioButton itself is enabled.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    override public function get enabled():Boolean
    {
        // Is the radio button itself enabled?
        if (!super.enabled)
            return false;
            
        // The button is enabled so it's enabled if it's not in a group
        // or the group is enabled.
        /* return !radioButtonGroup || 
               radioButtonGroup.enabled; */
		   return false;
    }
    
    //----------------------------------
    //  suggestedFocusSkinExclusions
    //----------------------------------
    /** 
     * @private 
     */     
    //private static const focusExclusions:Array = ["labelDisplay"];
    
    /**
     *  @private
     */
    /* override public function get suggestedFocusSkinExclusions():Array
    {
        return focusExclusions;
    } */

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  autoGroupIndex
    //----------------------------------

    /**
     *  @private
     *  automaticRadioButtonGroups is shared with halo radio button groups.
     *  Spark radio button groups are prefixed with _fx to differentiate the
     *  Halo groups which are stored in the same table.
     */
    private function get autoGroupIndex():String
    {
        return "_spark_" + groupName;
    }

    //----------------------------------
    //  group
    //----------------------------------

    /**
     *  @private
     *  Storage for the group property.
     */
    private var _group:RadioButtonGroup;

    /**
     *  The RadioButtonGroup component to which this RadioButton belongs.
     *  When creating RadioButtons to put in a RadioButtonGroup, you
     *  should use either the <code>group</code> property 
     *  or the <code>groupName</code> property for all of 
     *  the buttons.
     *  
     *  @default the automatically created default RadioButtonGroup
     *  @see #groupName
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get group():RadioButtonGroup
    {
        // Debugger asks too soon.
        if (!mxmlDocument)
            return _group;

        if (!_group)
        {
            // If using the default groupName, the button isn't added to the 
            // group until it is first accessed.
            if (groupName && groupName != "")
            {
                var g:RadioButtonGroup;
                try
                {
                    g = RadioButtonGroup(mxmlDocument[groupName]);
                }
                catch(e:Error)
                {
                    // Special automaticRadioButtonGroup slot to hold generated
                    // radio button groups.  Shared with halo so prefix
                    // groupName to differentiate.
                    if (mxmlDocument.automaticRadioButtonGroups &&
                        mxmlDocument.automaticRadioButtonGroups[autoGroupIndex])
                    {
                        g = RadioButtonGroup(
                            mxmlDocument.automaticRadioButtonGroups[autoGroupIndex]);
                    }
                }
                if (!g)
                {
                    g = new RadioButtonGroup(IFlexDisplayObject(mxmlDocument));
                    
                    if (!mxmlDocument.automaticRadioButtonGroups)
                        mxmlDocument.automaticRadioButtonGroups = [];
                    mxmlDocument.automaticRadioButtonGroups[autoGroupIndex] = g;                        
                }
                else if (!(g is RadioButtonGroup))
                {
                    return null;
                }

                _group = g;
            }
        }

        return _group;
    }

    /**
     *  @private
     */
    public function set group(value:RadioButtonGroup):void
    {
        if (_group == value)
            return;

        // If the button was in another group, remove it.
        //removeFromGroup();    

        _group = value;  

        // If the group is set then the groupName is the generated name of
        // the rbg.  If it's set to null, then set the groupName back to the
        // default group so this button will move back to that group.
       // _groupName = value ? group.name : "radioGroup";    
        
        // Make sure this gets added to it's RadioButtonGroup
        //groupChanged = true;
        
        //invalidateProperties();
        //invalidateDisplayList();
    }

    //----------------------------------
    //  groupName
    //----------------------------------

    /**
     *  @private
     *  Storage for groupName property.
     */
    private var _groupName:String;
    
    /**
     *  @private
     */
    private var groupChanged:Boolean = false;

    [Inspectable(category="General", defaultValue="radioGroup")]

    /**
     *  Specifies the name of the group to which this RadioButton component belongs, or 
     *  specifies the value of the <code>id</code> property of a RadioButtonGroup component
     *  if this RadioButton is part of a group defined by a RadioButtonGroup component.
     *  All radio buttons with the same <code>groupName</code> property will be in the same tab group.
     * 
     *  <p>When creating
     *  radio buttons to put in a RadioButtonGroup, it is advisable to
     *  use either the <code>group</code> property 
     *  or the <code>groupName</code> property for all of the buttons.</p>
     *
     *  @default "radioGroup"
     *  @see #group
     *  @see mx.manager.IFocusManagerGroup#groupName
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get groupName():String
    {
        return _groupName;
    }
    
    /**
     *  @private
     *  @royaleignorecoercion HTMLInputElement
     */
    public function set groupName(value:String):void
    {
        // A groupName must be non-empty string.
        if (!value || value == "")
            return;

        // If the button was in another group, remove it, before changing the
        // groupName.
        //removeFromGroup();            
   
        _groupName = value;
        
        // Make sure get group recalculates the group.
        _group = null;
        
        COMPILE::JS
        {
            (rbicon.element as HTMLInputElement).name = value;        
        }

        // Make sure this gets added to it's RadioButtonGroup
        //groupChanged = true;
        
        //invalidateProperties();
        //invalidateDisplayList();
    }

    //----------------------------------
    //  selected
    //----------------------------------
    
    /**
     *  @private
    override public function set selected(value:Boolean):void
    {
        super.selected = value;
        invalidateDisplayList();
    }
     */

    //----------------------------------
    //  value
    //----------------------------------

    /**
     *  @private
     *  Storage for value property.
     */
    private var _value:Object;

    [Bindable("change")]
    [Bindable("valueChanged")]
    [Inspectable(category="General", defaultValue="")]

    /**
     *  Optional user-defined value
     *  that is associated with a RadioButton component.
     * 
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get value():Object
    {
        return _value;
    }

    /**
     *  @private
     */
    public function set value(value:Object):void
    {
        if (_value == value)
            return;
            
        _value = value;

        if (selected && group)
            group.dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent, ButtonBase
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    /* override protected function initializeAccessibility():void
    {
        if (RadioButton.createAccessibilityImplementation != null)
            RadioButton.createAccessibilityImplementation(this);
    } */

    /**
     *  @private
     *  Update properties before measurement/layout.
     */
    /*override protected function commitProperties():void
    {
        if (groupChanged)
        {
            addToGroup();
            groupChanged = false;
        }

        // Do this after radio button is added to the group so when the
        // skin state is set, enabled and selected will return the correct values,
        // and the correct skin will be used.
        super.commitProperties();
    }*/

    /**
     *  @private
     */
    /* override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        // If this rb is selected and in a group, make sure it is the group
        // selection.  If it is not selected and it's in a group, make sure it
        // is not the group selection.
        if (group)
        {
            if (selected)
                _group.selection = this;
            else if (group.selection == this)
                _group.selection = null;   
        }
    } */
    
    /**
     *  @private
     *  Set radio button to selected and dispatch that there has been a change.
     */ 
    /* override protected function buttonReleased():void
    {
        if (!enabled || selected)
            return; // prevent a selected button from dispatching "click"
        
        if (!radioButtonGroup)
            addToGroup();
        
        // Must call super.buttonReleased() before setting
        // the group's selection.
        super.buttonReleased();
        
        group.setSelection(this);
        
        // Dispatch an itemClick event from the RadioButtonGroup.
        var itemClickEvent:ItemClickEvent =
            new ItemClickEvent(ItemClickEvent.ITEM_CLICK);
        itemClickEvent.label = label;
        itemClickEvent.index = indexNumber;
        itemClickEvent.relatedObject = this;
        itemClickEvent.item = value;
        group.dispatchEvent(itemClickEvent);
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Create radio button group if it does not exist
     *  and add the instance to the group. 
     */
    private function addToGroup():RadioButtonGroup
    {        
        var g:RadioButtonGroup = group; // Trigger getting the group
        if (g)
            g.addInstance(this);
              
        return g;
    }

    /**
     *  @private
     */
    /* private function removeFromGroup():void
    {        
        // If the radio button was in a group, remove it.
        this.dispatchEvent(new Event(Event.REMOVED));
          
        // It's possible that the radio button was in the auto group.  If so,
        // delete the group if there are no other radio buttons still in it.
        // The radio button also could have been in an explicit RadioButtonGroup
        // specified via group or in a RadioButtonGroup that was in the document,
        // specified by groupName.
        try
        {
            if (document.automaticRadioButtonGroups[autoGroupIndex].numRadioButtons == 0)
            {
                delete document.automaticRadioButtonGroups[autoGroupIndex];
            }
        }
        catch(e:Error)
        {
        }
    } */

    /**
     *  @private
     *  Set previous radio button in the group.
     */
    /* private function setPrev(moveSelection:Boolean = true):void
    {
        var g:RadioButtonGroup = group;

        var fm:IFocusManager = focusManager;
        if (fm)
            fm.showFocusIndicator = true;

        for (var i:int = 1; i <= indexNumber; i++)
        {
            var radioButton:RadioButton = 
                    g.getRadioButtonAt(indexNumber - i);
            if (radioButton && isRadioButtonEnabled(radioButton))
            {
                if (moveSelection)
                    g.setSelection(radioButton);
                radioButton.setFocus();
                return;
            }
        }

        if (moveSelection && g.getRadioButtonAt(indexNumber) != g.selection)
            g.setSelection(this);
        
        this.drawFocus(true);   
    } */

    /**
     *  @private
     *  Set the next radio button in the group.
     */
    /* private function setNext(moveSelection:Boolean = true):void
    {
        var g:RadioButtonGroup = group;

        var fm:IFocusManager = focusManager;
        if (fm)
            fm.showFocusIndicator = true;

        for (var i:int = indexNumber + 1; i < g.numRadioButtons; i++)
        {
            var radioButton:RadioButton = g.getRadioButtonAt(i);
            if (radioButton && isRadioButtonEnabled(radioButton))
            {
                if (moveSelection)
                    g.setSelection(radioButton);
                radioButton.setFocus();
                return;
            }
        }

        if (moveSelection && g.getRadioButtonAt(indexNumber) != g.selection)
            g.setSelection(this);
        this.drawFocus(true);   
    } */

    /**
     *  @private
     *  When using keyboard navigation, need to make sure we don't move to
     *  a radio button that's not enabled because it's in a different
     *  container that isn't enabled.
     */
    /* private function isRadioButtonEnabled(rb:RadioButton):Boolean
    {
        if (!rb.enabled)
            return false;
            
        var sbRoot:DisplayObject = rb.systemManager.getSandboxRoot(); 
              
        // If it's in another UIComponent like a container, is that enabled?
        var p:DisplayObject = rb.parent;
        while (p && p != sbRoot)
        {
            if (p is UIComponent && !UIComponent(p).enabled)
                return false;
            
            p = p.parent;
        }
        
        return true;                   
    } */
    
    /**
     *  @private
     */
    /* private function setThis():void
    {
        if (!radioButtonGroup)
            addToGroup();

        var g:RadioButtonGroup = group;

        if (g.selection != this)
            g.setSelection(this);
    } */

    //--------------------------------------------------------------------------
    //
    //  Overridden event handlers: UIComponent
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Support the use of keyboard within the group.
     */
    /* override protected function keyDownHandler(event:KeyboardEvent):void
    {
        // Have to make sure we don't move to a radio button that's not enabled
        // because it's in a different container that is not enabled.
        if (event.isDefaultPrevented())
            return;
            
        // If rtl layout, need to swap LEFT and RIGHT so correct action
        // is done.
        var keyCode:uint = mapKeycodeForLayoutDirection(event);
                
        switch (keyCode)
        {
            case Keyboard.DOWN:
            {
                setNext(!event.ctrlKey);
                event.preventDefault();
                break;
            }

            case Keyboard.UP:
            {
                setPrev(!event.ctrlKey);
                event.preventDefault();
                break;
            }

            case Keyboard.LEFT:
            {
                setPrev(!event.ctrlKey);
                event.preventDefault();
                break;
            }

            case Keyboard.RIGHT:
            {
                setNext(!event.ctrlKey);
                event.preventDefault();
                break;
            }
                
            case Keyboard.SPACE:
            {
                setThis();
                //fall through, no break
            }

            default:
            {
                super.keyDownHandler(event);
                break;
            }
        }
    } */
    
    /**
     * The method called when added to a parent. The DateField class uses
     * this opportunity to install additional beads.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    override public function addedToParent():void
    {
        super.addedToParent();
        addToGroup();
        if (selected)
            group.setSelection(this, false);
    }
}

}
