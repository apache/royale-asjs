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

import flash.events.Event;

/**
 *  Represents events that are dispatched when a divider has been pressed,
 *  dragged or released.
 * 
 *  These events are dispatched by the DividedBox control and its children.
 *
 *  @see mx.containers.DividedBox
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class DividerEvent extends Event
{
    include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------

	/**
	 *  The <code>DividerEvent.DIVIDER_DRAG</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>dividerDrag</code> event.
	 *
	 *  <p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
	 *     <tr><td><code>delta</code></td><td>Contains the number of pixels
     *      that the divider has been dragged. Positive numbers represent a drag toward the 
	 *      right or bottom, negative numbers toward the left or top.</td></tr>
     *     <tr><td><code>dividerIndex</code></td><td>Contains the zero-based index
     *      of the divider being dragged. The leftmost or topmost divider has a 
	 *     <code>dividerIndex</code> of 0.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
	 *  </table>
     *
     *  @eventType dividerDrag
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const DIVIDER_DRAG:String = "dividerDrag";

	/**
	 *  The <code>DividerEvent.DIVIDER_PRESS</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>dividerPress</code> event.
	 *
	 *  <p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
	 *     <tr><td><code>delta</code></td><td>Contains the number of pixels
     *      that the divider has been dragged. Positive numbers represent a drag toward the 
	 *      right or bottom, negative numbers toward the left or top.</td></tr>
     *     <tr><td><code>dividerIndex</code></td><td>Contains the zero-based index
     *      of the divider being dragged. The leftmost or topmost divider has a 
     *     <code>dividerIndex</code> of 0.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
	 *  </table>
     *
     *  @eventType dividerPress
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const DIVIDER_PRESS:String = "dividerPress";

	/**
	 *  The <code>DividerEvent.DIVIDER_RELEASE</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>dividerRelease</code> event.
	 *
	 *  <p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
	 *     <tr><td><code>delta</code></td><td>Contains the number of pixels
     *      that the divider has been dragged. Positive numbers represent a drag toward the 
	 *      right or bottom, negative numbers toward the left or top.</td></tr>
     *     <tr><td><code>dividerIndex</code></td><td>Contains the zero-based index
     *      of the divider being dragged. The leftmost or topmost divider has a 
     *     <code>dividerIndex</code> of 0.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
	 *  </table>
     *
     *  @eventType dividerRelease
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const DIVIDER_RELEASE:String = "dividerRelease";

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
	 *  @param dividerIndex Index of the divider that generated the event.
	 *
	 *  @param delta The number of pixels by which the divider has been dragged.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function DividerEvent(type:String, bubbles:Boolean = false,
								 cancelable:Boolean = false,
								 dividerIndex:int = -1, delta:Number = NaN)
	{
		super(type, bubbles, cancelable);

		this.dividerIndex = dividerIndex;
		this.delta = delta;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  delta
	//----------------------------------

	/**
	 *  The number of pixels that the divider has been dragged.
	 *  Positive numbers represent a drag toward the right or bottom,
	 *  negative numbers toward the left or top.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var delta:Number;

	//----------------------------------
	//  dividerIndex
	//----------------------------------

	/**
	 *  The zero-based index of the divider being pressed or dragged.
	 *  The leftmost or topmost divider has a <code>dividerIndex</code>
	 *  of 0.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var dividerIndex:int;

	//--------------------------------------------------------------------------
	//
	//  Overridden methods: Event
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	override public function clone():Event
	{
		return new DividerEvent(type, bubbles, cancelable, dividerIndex, delta);
	}
}

}
