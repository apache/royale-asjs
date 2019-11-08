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

package mx.events
{

import org.apache.royale.events.Event;
import org.apache.royale.events.IRoyaleEvent;
// import flash.events.Event;

/**
 *  Represents events that are specific to the ColorPicker control,
 *  such as when the user rolls the mouse over or out of a swatch in
 *  the swatch panel.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.7
 */
public class ColorPickerEvent extends Event
{
    //include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
	 *  The <code>ColorPickerEvent.CHANGE</code> constant defines the value of the
	 *  <code>type</code> property of the event that is dispatched when the user 
	 *  selects a color from the ColorPicker control.
	 *
     *	<p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>color</code></td><td>The RGB color that was selected.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>.</td></tr>
     *     <tr><td><code>index</code></td>
	 *         <td>The zero-based index in the Color's data provider that corresponds 
	 *             to the color that was selected.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
	 *  </table>
	 *
     *  @eventType change
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.7
	 *  @royalesuppresspublicvarwarning
	*/
    public static const CHANGE:String = "change";

    /**
	 *  The <code>ColorPickerEvent.ENTER</code> constant defines the value of the
	 *  <code>type</code> property of the event that is dispatched when the user 
	 *  presses the Enter key after typing in the color selector box.
	 *
     *	<p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>color</code></td><td>The RGB color that was entered.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>.</td></tr>
     *     <tr><td><code>index</code></td>
	 *         <td>Always -1.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
	 *  </table>
	 *
     *  @eventType enter
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.7
     *  @royalesuppresspublicvarwarning
	*/
    public static const ENTER:String = "enter";

    /**
 	 *  The <code>ColorPickerEvent.ITEM_ROLL_OUT</code> constant defines the value of the
	 *  <code>type</code> property of the event that is dispatched when the user 
	 *  rolls the mouse out of a swatch in the swatch panel.
	 *
     *	<p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>color</code></td><td>The RGB color of the color 
	 *                   that was rolled over.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>.</td></tr>
     *     <tr><td><code>index</code></td>
	 *         <td>The zero-based index in the Color's data provider that corresponds 
	 *             to the color that was rolled over.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
	 *  </table>
	 *
     *  @eventType itemRollOut
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.7
     *  @royalesuppresspublicvarwarning
	*/
    public static const ITEM_ROLL_OUT:String = "itemRollOut";

    /**
 	 *  The <code>ColorPickerEvent.ITEM_ROLL_OVER</code> constant defines the value of the
	 *  <code>type</code> property of the event that is dispatched when the user 
	 *  rolls the mouse over of a swatch in the swatch panel.
	 *
     *	<p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>color</code></td><td>The RGB color of the color 
	 *                   that the user rolled out of.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>.</td></tr>
     *     <tr><td><code>index</code></td>
	 *         <td>The zero-based index in the Color's data provider that corresponds 
	 *             to the color that the user rolled out of.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
	 *  </table>
	 *
     *  @eventType itemRollOver
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.7
     *  @royalesuppresspublicvarwarning
	*/
    public static const ITEM_ROLL_OVER:String = "itemRollOver";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
	 *  Constructor.
	 *
	 *  @param type The event type; indicates the action that caused the event.
	 *
	 *  @param bubbles Specifies whether the event can bubble up the display list hierarchy.
	 *
	 *  @param cancelable Specifies whether the behavior associated with the event can be prevented.
	 *
	 *  @param index The zero-based index in the Color's data provider
	 *  that corresponds to the color that was rolled over, rolled out of,
	 *  or selected.
	 *
	 *  @param color The RGB color that was rolled over, rolled out of,
	 *  selected, or entered.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.7
     */
    public function ColorPickerEvent(
						type:String, bubbles:Boolean = false,
                        cancelable:Boolean = false, index:int = -1,
						color:uint = 0xFFFFFFFF /* StyleManager.NOT_A_COLOR */)
    {
        super(type, bubbles, cancelable);

		this.index = index;
		this.color = color;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

	//----------------------------------
	//  color
	//----------------------------------

    /**
	 *  The RGB color that was rolled over, rolled out of, selected, or
	 *  entered.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.7
     *  @royalesuppresspublicvarwarning
	*/
    public var color:uint;

	//----------------------------------
	//  index
	//----------------------------------

    /**
	 *  The zero-based index in the Color's data provider that corresponds
	 *  to the color that was rolled over, rolled out of, or selected.
	 *  If the event type is <code>ColorPickerEvent.ENTER</code>,
	 *  will have default value -1; it is not set in this case because
	 *  the user can enter an RGB string that doesn't match any color
	 *  in the data provider.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.7
     *  @royalesuppresspublicvarwarning
	*/
    public var index:int;

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: Event
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
	override public function cloneEvent():IRoyaleEvent
	{
	        return new ColorPickerEvent(type, bubbles, cancelable, index, color);

	}
   
}

}
