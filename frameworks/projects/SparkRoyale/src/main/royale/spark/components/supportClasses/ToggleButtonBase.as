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

package spark.components.supportClasses
{

/* import flash.events.Event;
import flash.events.MouseEvent; */
import org.apache.royale.events.Event;
import org.apache.royale.events.MouseEvent; 
import mx.core.mx_internal;
import mx.events.FlexEvent;

use namespace mx_internal;

/**
 *  Dispatched when the <code>selected</code> property 
 *  changes for the ToggleButtonBase control. 
 * 
 *  This event is dispatched only when the 
 *  user interacts with the control by using the mouse.
 *
 *  @eventType flash.events.Event.CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Event(name="change", type="flash.events.Event")]

/**
 *  Up State of the Button when it's selected
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[SkinState("upAndSelected")]

/**
 *  Over State of the Button when it's selected
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[SkinState("overAndSelected")]

/**
 *  Down State of the Button when it's selected
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[SkinState("downAndSelected")]

/**
 *  Disabled State of the Button when it's selected
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[SkinState("disabledAndSelected")]

//--------------------------------------
//  Other metadata
//--------------------------------------

//[AccessibilityClass(implementation="spark.accessibility.ToggleButtonAccImpl")]

/**
 *  The ToggleButtonBase component is the base class for the Spark button components
 *  that support the <code>selected</code> property.
 *  ToggleButton, CheckBox and RadioButton are subclasses of ToggleButtonBase.
 *
 *  @mxml
 *
 *  <p>The <code>&lt;s:ToggleButtonBase&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:ToggleButtonBase
 *    <strong>Properties</strong>
 *    selected="false"
 * 
 *    <strong>events</strong>
 *    change="<i>No default</i>"
 *  /&gt;
 *  </pre> 
 *
 *  @see spark.components.ToggleButton
 *  @see spark.components.CheckBox
 *  @see spark.components.RadioButton
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
public class ToggleButtonBase extends ButtonBase
{
    //include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class mixins
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Placeholder for mixin by ToggleButtonAccImpl.
     */
   // mx_internal static var createAccessibilityImplementation:Function;
    
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
    public function ToggleButtonBase()
    {
        super();
		
		// ToggleButtons don't use minimumDownStateTime.  If they are quick-tapped
		// with a touchDelay, they don't fake it and go in to the down state for a bit.
		// They go immediately to the selected state.
		//disableMinimumDownStateTime = true;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  selected
    //----------------------------------

    /**
     *  @private
     *  Storage for the selected property 
     */
    private var _selected:Boolean;

    [Bindable]
    [Inspectable(category="General", defaultValue="false")]
    
    /**
     *  Contains <code>true</code> if the button is in the down state, 
     *  and <code>false</code> if it is in the up state.
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */    
    public function get selected():Boolean
    {
        return _selected;
    }
    
    /**
     *  @private
     */    
    public function set selected(value:Boolean):void
    {
        if (value == _selected)
            return;

        _selected = value;            
        dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
        invalidateSkinState();
    }

    //--------------------------------------------------------------------------
    //
    //  States
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */ 
    /* override protected function getCurrentSkinState():String
    {
        if (!selected)
            return super.getCurrentSkinState();
        else
            return super.getCurrentSkinState() + "AndSelected";
    } */
    
    /**
     *  @private
     */ 
    /* override protected function buttonReleased():void
    {
        super.buttonReleased();
        
        selected = !selected;
        
        dispatchEvent(new Event(Event.CHANGE));
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
        if (ToggleButtonBase.createAccessibilityImplementation != null)
            ToggleButtonBase.createAccessibilityImplementation(this);
    } */
}

}
