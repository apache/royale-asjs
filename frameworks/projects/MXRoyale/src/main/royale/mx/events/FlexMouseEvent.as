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

COMPILE::SWF{
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.InteractiveObject;
}

COMPILE::JS{
	import org.apache.royale.events.Event;
	import org.apache.royale.events.MouseEvent;
}
import mx.core.UIComponent;

/**
 *  The FlexMouseEvent class represents the event object passed to
 *  the event listener for Flex-specific mouse activity.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
COMPILE::SWF {
public class FlexMouseEvent extends flash.events.MouseEvent
{
    //include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------

	/**
	 *  The <code>FlexMouseEvent.MOUSE_DOWN_OUTSIDE</code> constant defines the value of the
	 *  <code>type</code> property of the event object for a <code>mouseDownOutside</code>
	 *  event.
	 *
     *	<p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>altKey</code></td>
	 *         <td>Indicates whether the Alt key is down
	 * 	          (<code>true</code>) or not (<code>false</code>).</td></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>buttonDown</code></td>
	 *         <td>Indicates whether the main mouse button is down
	 * 	          (<code>true</code>) or not (<code>false</code>).</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>ctrlKey</code></td>
	 *         <td>Indicates whether the Control key is down
	 * 	          (<code>true</code>) or not (<code>false</code>).</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. 
 	 *       For PopUpManager events, the object is the pop-up window.</td></tr>
     *     <tr><td><code>delta</code></td>
	 *         <td>Indicates how many lines should be scrolled for each notch the user 
	 *             scrolls the mouse wheel. 
	 *             For PopUpManager events this value is 0.</td></tr>
     *     <tr><td><code>localX</code></td>
	 *         <td>The horizontal position at which the event occurred. 
	 *             For PopUpManager events, the value is relative to the pop-up control.</td></tr>
     *     <tr><td><code>localY</code></td>
	 *         <td>The vertical position at which the event occurred. 
	 *             For PopUpManager events, the value is relative to the pop-up control.</td></tr>
     *     <tr><td><code>relatedObject</code></td>
	 *         <td>A reference to a display list object that is related to the event.
	 *             For PopUpManager events, the object is the container over which
	 *             the mouse pointer is located.</td></tr>
     *     <tr><td><code>shiftKey</code></td>
	 *         <td>Indicates whether the Shift key is down
	 * 	          (<code>true</code>) or not (<code>false</code>).</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.
	 *       For PopUpManager events, the object is the pop-up window.</td></tr>
	 *  </table>
	 *
     *  @eventType mouseDownOutside
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const MOUSE_DOWN_OUTSIDE:String = "mouseDownOutside";

    /**
     *  The <code>FlexMouseEvent.MOUSE_WHEEL_CHANGING</code> constant defines the value of the
     *  <code>type</code> property of the event object for a <code>mouseWheelChanging</code>
     *  event.
     *
     *	<p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>altKey</code></td>
     *         <td>Indicates whether the Alt key is down
     * 	          (<code>true</code>) or not (<code>false</code>).</td></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>buttonDown</code></td>
     *         <td>Indicates whether the main mouse button is down
     * 	          (<code>true</code>) or not (<code>false</code>).</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>ctrlKey</code></td>
     *         <td>Indicates whether the Control key is down
     * 	          (<code>true</code>) or not (<code>false</code>).</td></tr>
     *     <tr><td><code>currentTarget</code></td>
     *         <td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. 
     *       </td></tr>
     *     <tr><td><code>delta</code></td>
     *         <td>Indicates how many lines should be scrolled for each notch the user 
     *             scrolls the mouse wheel. 
     *             </td></tr>
     *     <tr><td><code>localX</code></td>
     *         <td>The horizontal position at which the event occurred. 
     *             </td></tr>
     *     <tr><td><code>localY</code></td>
     *         <td>The vertical position at which the event occurred. 
     *             </td></tr>
     *     <tr><td><code>relatedObject</code></td>
     *         <td>A reference to a display list object that is related to the event.
	 *             For this event, the object is the component which is 
	 *             the target of the mouseWheel event.</td></tr>
     *     <tr><td><code>shiftKey</code></td>
     *         <td>Indicates whether the Shift key is down
     * 	          (<code>true</code>) or not (<code>false</code>).</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.
     *       </td></tr>
     *  </table>
     *
     *  @eventType mouseWheelChanging
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public static const MOUSE_WHEEL_CHANGING:String = "mouseWheelChanging";
    
	/**
	 *  The <code>FlexMouseEvent.MOUSE_WHEEL_OUTSIDE</code> constant defines the value of the
	 *  <code>type</code> property of the event object for a <code>mouseWheelOutside</code>
	 *  event.
	 *
     *	<p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>altKey</code></td>
	 *         <td>Indicates whether the Alt key is down
	 * 	          (<code>true</code>) or not (<code>false</code>).</td></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>buttonDown</code></td>
	 *         <td>Indicates whether the main mouse button is down
	 * 	          (<code>true</code>) or not (<code>false</code>).</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>ctrlKey</code></td>
	 *         <td>Indicates whether the Control key is down
	 * 	          (<code>true</code>) or not (<code>false</code>).</td></tr>
     *     <tr><td><code>currentTarget</code></td>
	 *         <td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. 
 	 *       For PopUpManager events, the object is the pop-up window.</td></tr>
     *     <tr><td><code>delta</code></td>
	 *         <td>Indicates how many lines should be scrolled for each notch the user 
	 *             scrolls the mouse wheel. 
	 *             For PopUpManager events this value is 0.</td></tr>
     *     <tr><td><code>localX</code></td>
	 *         <td>The horizontal position at which the event occurred. 
	 *             For PopUpManager events, the value is relative to the pop-up control.</td></tr>
     *     <tr><td><code>localY</code></td>
	 *         <td>The vertical position at which the event occurred. 
	 *             For PopUpManager events, the value is relative to the pop-up control.</td></tr>
     *     <tr><td><code>relatedObject</code></td>
	 *         <td>A reference to a display list object that is related to the event.
	 *             For PopUpManager events, the object is the container over which
	 *             the mouse pointer is located.</td></tr>
     *     <tr><td><code>shiftKey</code></td>
	 *         <td>Indicates whether the Shift key is down
	 * 	          (<code>true</code>) or not (<code>false</code>).</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.
	 *       For PopUpManager events, the object is the pop-up window.</td></tr>
	 *  </table>
	 *
     *  @eventType mouseWheelOutside
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const MOUSE_WHEEL_OUTSIDE:String = "mouseWheelOutside";

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
	 *  @param bubbles Specifies whether the event can bubble up
	 *  the display list hierarchy.
	 *
	 *  @param cancelable Specifies whether the behavior
	 *  associated with the event can be prevented.
	 * 
     *  @param localX The horizontal position at which the event occurred.
	 * 
     *  @param localY The vertical position at which the event occurred.
	 * 
     *  @param relatedObject The display list object that is related to the event.
	 * 
	 *  @param ctrlKey Whether the Control key is down.
	 * 
	 *  @param altKey Whether the Alt key is down.
	 * 
	 *  @param shiftKey Whether the Shift key is down.
	 * 
	 *  @param buttonDown Whether the Control key is down.
	 * 
	 *  @param delta How many lines should be scrolled for each notch the 
	 *  user scrolls the mouse wheel.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function FlexMouseEvent(type:String, bubbles:Boolean = false,
								   cancelable:Boolean = false,
								   localX:Number = 0,  localY:Number = 0, 
								   relatedObject:UIComponent = null, 
								   ctrlKey:Boolean = false, 
								   altKey:Boolean = false, 
								   shiftKey:Boolean = false, 
								   buttonDown:Boolean = false, 
								   delta:int = 0)
	{
		super(type, bubbles, cancelable, localX, localY, relatedObject,
			  ctrlKey, altKey, shiftKey, buttonDown, delta);
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods: Event
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	override public function clone():flash.events.MouseEvent
	{
		return new FlexMouseEvent(type, bubbles, cancelable);
		// , localX, localY,
								  // relatedObject, ctrlKey, altKey, shiftKey,
								  // buttonDown, delta
	}
	
	
}

}

COMPILE::JS {
public class FlexMouseEvent extends org.apache.royale.events.MouseEvent
{
    //include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------

	/**
	 *  The <code>FlexMouseEvent.MOUSE_DOWN_OUTSIDE</code> constant defines the value of the
	 *  <code>type</code> property of the event object for a <code>mouseDownOutside</code>
	 *  event.
	 *
     *	<p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>altKey</code></td>
	 *         <td>Indicates whether the Alt key is down
	 * 	          (<code>true</code>) or not (<code>false</code>).</td></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>buttonDown</code></td>
	 *         <td>Indicates whether the main mouse button is down
	 * 	          (<code>true</code>) or not (<code>false</code>).</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>ctrlKey</code></td>
	 *         <td>Indicates whether the Control key is down
	 * 	          (<code>true</code>) or not (<code>false</code>).</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. 
 	 *       For PopUpManager events, the object is the pop-up window.</td></tr>
     *     <tr><td><code>delta</code></td>
	 *         <td>Indicates how many lines should be scrolled for each notch the user 
	 *             scrolls the mouse wheel. 
	 *             For PopUpManager events this value is 0.</td></tr>
     *     <tr><td><code>localX</code></td>
	 *         <td>The horizontal position at which the event occurred. 
	 *             For PopUpManager events, the value is relative to the pop-up control.</td></tr>
     *     <tr><td><code>localY</code></td>
	 *         <td>The vertical position at which the event occurred. 
	 *             For PopUpManager events, the value is relative to the pop-up control.</td></tr>
     *     <tr><td><code>relatedObject</code></td>
	 *         <td>A reference to a display list object that is related to the event.
	 *             For PopUpManager events, the object is the container over which
	 *             the mouse pointer is located.</td></tr>
     *     <tr><td><code>shiftKey</code></td>
	 *         <td>Indicates whether the Shift key is down
	 * 	          (<code>true</code>) or not (<code>false</code>).</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.
	 *       For PopUpManager events, the object is the pop-up window.</td></tr>
	 *  </table>
	 *
     *  @eventType mouseDownOutside
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const MOUSE_DOWN_OUTSIDE:String = "mouseDownOutside";

    /**
     *  The <code>FlexMouseEvent.MOUSE_WHEEL_CHANGING</code> constant defines the value of the
     *  <code>type</code> property of the event object for a <code>mouseWheelChanging</code>
     *  event.
     *
     *	<p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>altKey</code></td>
     *         <td>Indicates whether the Alt key is down
     * 	          (<code>true</code>) or not (<code>false</code>).</td></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>buttonDown</code></td>
     *         <td>Indicates whether the main mouse button is down
     * 	          (<code>true</code>) or not (<code>false</code>).</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>ctrlKey</code></td>
     *         <td>Indicates whether the Control key is down
     * 	          (<code>true</code>) or not (<code>false</code>).</td></tr>
     *     <tr><td><code>currentTarget</code></td>
     *         <td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. 
     *       </td></tr>
     *     <tr><td><code>delta</code></td>
     *         <td>Indicates how many lines should be scrolled for each notch the user 
     *             scrolls the mouse wheel. 
     *             </td></tr>
     *     <tr><td><code>localX</code></td>
     *         <td>The horizontal position at which the event occurred. 
     *             </td></tr>
     *     <tr><td><code>localY</code></td>
     *         <td>The vertical position at which the event occurred. 
     *             </td></tr>
     *     <tr><td><code>relatedObject</code></td>
     *         <td>A reference to a display list object that is related to the event.
	 *             For this event, the object is the component which is 
	 *             the target of the mouseWheel event.</td></tr>
     *     <tr><td><code>shiftKey</code></td>
     *         <td>Indicates whether the Shift key is down
     * 	          (<code>true</code>) or not (<code>false</code>).</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.
     *       </td></tr>
     *  </table>
     *
     *  @eventType mouseWheelChanging
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public static const MOUSE_WHEEL_CHANGING:String = "mouseWheelChanging";
    
	/**
	 *  The <code>FlexMouseEvent.MOUSE_WHEEL_OUTSIDE</code> constant defines the value of the
	 *  <code>type</code> property of the event object for a <code>mouseWheelOutside</code>
	 *  event.
	 *
     *	<p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>altKey</code></td>
	 *         <td>Indicates whether the Alt key is down
	 * 	          (<code>true</code>) or not (<code>false</code>).</td></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>buttonDown</code></td>
	 *         <td>Indicates whether the main mouse button is down
	 * 	          (<code>true</code>) or not (<code>false</code>).</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>ctrlKey</code></td>
	 *         <td>Indicates whether the Control key is down
	 * 	          (<code>true</code>) or not (<code>false</code>).</td></tr>
     *     <tr><td><code>currentTarget</code></td>
	 *         <td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. 
 	 *       For PopUpManager events, the object is the pop-up window.</td></tr>
     *     <tr><td><code>delta</code></td>
	 *         <td>Indicates how many lines should be scrolled for each notch the user 
	 *             scrolls the mouse wheel. 
	 *             For PopUpManager events this value is 0.</td></tr>
     *     <tr><td><code>localX</code></td>
	 *         <td>The horizontal position at which the event occurred. 
	 *             For PopUpManager events, the value is relative to the pop-up control.</td></tr>
     *     <tr><td><code>localY</code></td>
	 *         <td>The vertical position at which the event occurred. 
	 *             For PopUpManager events, the value is relative to the pop-up control.</td></tr>
     *     <tr><td><code>relatedObject</code></td>
	 *         <td>A reference to a display list object that is related to the event.
	 *             For PopUpManager events, the object is the container over which
	 *             the mouse pointer is located.</td></tr>
     *     <tr><td><code>shiftKey</code></td>
	 *         <td>Indicates whether the Shift key is down
	 * 	          (<code>true</code>) or not (<code>false</code>).</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.
	 *       For PopUpManager events, the object is the pop-up window.</td></tr>
	 *  </table>
	 *
     *  @eventType mouseWheelOutside
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const MOUSE_WHEEL_OUTSIDE:String = "mouseWheelOutside";

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
	 *  @param bubbles Specifies whether the event can bubble up
	 *  the display list hierarchy.
	 *
	 *  @param cancelable Specifies whether the behavior
	 *  associated with the event can be prevented.
	 * 
     *  @param localX The horizontal position at which the event occurred.
	 * 
     *  @param localY The vertical position at which the event occurred.
	 * 
     *  @param relatedObject The display list object that is related to the event.
	 * 
	 *  @param ctrlKey Whether the Control key is down.
	 * 
	 *  @param altKey Whether the Alt key is down.
	 * 
	 *  @param shiftKey Whether the Shift key is down.
	 * 
	 *  @param buttonDown Whether the Control key is down.
	 * 
	 *  @param delta How many lines should be scrolled for each notch the 
	 *  user scrolls the mouse wheel.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function FlexMouseEvent(type:String, bubbles:Boolean = false,
								   cancelable:Boolean = false,
								   localX:Number = 0,  localY:Number = 0, 
								   relatedObject:Object = null, 
								   ctrlKey:Boolean = false, 
								   altKey:Boolean = false, 
								   shiftKey:Boolean = false, 
								   buttonDown:Boolean = false, 
								   delta:int = 0)
	{
		super(type, bubbles, cancelable);
		// , localX, localY, relatedObject,
			  // ctrlKey, altKey, shiftKey, buttonDown, delta
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods: Event
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	public function clone():Event
	{
		return new FlexMouseEvent(type, bubbles, cancelable, localX, localY,
								  relatedObject, ctrlKey, altKey, shiftKey,
								  buttonDown, delta);
	}
	
	
}
}
}
