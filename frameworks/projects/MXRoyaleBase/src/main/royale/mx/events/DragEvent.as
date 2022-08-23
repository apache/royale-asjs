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

/* import flash.events.Event;
import flash.events.MouseEvent; */
import mx.events.MouseEvent; 
import mx.core.DragSource;
import mx.core.IUIComponent;

/**
 *  The DragEvent class represents event objects that are dispatched as part of a drag-and-drop
 *  operation.
 *
 *  @see mx.managers.DragManager
 *  @see mx.core.DragSource
 *  @see mx.core.UIComponent
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 * 
 *  @royalesuppresspublicvarwarning
 */
public class DragEvent extends MouseEvent
{
    //include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------

	/**
	 *  The <code>DragEvent.DRAG_COMPLETE</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>dragComplete</code> event.
     *
	 *  <p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>action</code></td><td>The action that caused the event: 
     *       <code>DragManager.COPY</code>, <code>DragManager.LINK</code>, 
     *       <code>DragManager.MOVE</code>, or <code>DragManager.NONE</code>.</td></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dragInitiator</code></td><td>The component that initiated the drag.</td></tr>
     *     <tr><td><code>dragSource</code></td><td>The DragSource object containing the 
     *       data being dragged.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
	 *  </table>
	 *
     *  @eventType dragComplete
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const DRAG_COMPLETE:String = "dragComplete";

	/**
	 *  The <code>DragEvent.DRAG_DROP</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>dragDrop</code> event.
     *
	 *  <p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>action</code></td><td>The action that caused the event: 
     *       <code>DragManager.COPY</code>, <code>DragManager.LINK</code>, 
     *       <code>DragManager.MOVE</code>, or <code>DragManager.NONE</code>.</td></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dragInitiator</code></td><td>The component that initiated the drag.</td></tr>
     *     <tr><td><code>dragSource</code></td><td>The DragSource object containing the 
     *       data being dragged.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
	 *  </table>
	 *
     *  @eventType dragDrop
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const DRAG_DROP:String = "dragDrop";

	/**
	 *  The <code>DragEvent.DRAG_ENTER</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>dragEnter</code> event.
     *
	 *  <p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>action</code></td><td>The action that caused the event, which is always
     *       <code>DragManager.MOVE</code>.</td></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dragInitiator</code></td><td>The component that initiated the drag.</td></tr>
     *     <tr><td><code>dragSource</code></td><td>The DragSource object containing the 
     *       data being dragged.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
	 *  </table>
	 *
     *  @eventType dragEnter
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const DRAG_ENTER:String = "dragEnter";

	/**
	 *  The <code>DragEvent.DRAG_EXIT</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>dragExit</code> event.
     *
	 *  <p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>action</code></td><td>The action that caused the event: 
     *       <code>DragManager.COPY</code>, <code>DragManager.LINK</code>, 
     *       <code>DragManager.MOVE</code>, or <code>DragManager.NONE</code>.</td></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dragInitiator</code></td><td>The component that initiated the drag.</td></tr>
     *     <tr><td><code>dragSource</code></td><td>The DragSource object containing the 
     *       data being dragged.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
	 *  </table>
	 *
     *  @eventType dragExit
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const DRAG_EXIT:String = "dragExit";

	/**
	 *  The <code>DragEvent.DRAG_OVER</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>dragOver</code> event.
     *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>action</code></td><td>The action that caused the event: 
     *       <code>DragManager.COPY</code>, <code>DragManager.LINK</code>, 
     *       <code>DragManager.MOVE</code>, or <code>DragManager.NONE</code>.</td></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dragInitiator</code></td><td>The component that initiated the drag.</td></tr>
     *     <tr><td><code>dragSource</code></td><td>The DragSource object containing the 
     *       data being dragged.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
	 *  </table>
	 *
     *  @eventType dragOver
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const DRAG_OVER:String = "dragOver";

	/**
	 *  The DragEvent.DRAG_START constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>dragStart</code> event.
     *
	 *  <p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>action</code></td><td>The action that caused the event: 
     *       <code>DragManager.COPY</code>, <code>DragManager.LINK</code>, 
     *       <code>DragManager.MOVE</code>, or <code>DragManager.NONE</code>.</td></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dragInitiator</code></td><td>The component that initiated the drag.</td></tr>
     *     <tr><td><code>dragSource</code></td><td>The DragSource object containing the 
     *       data being dragged.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
	 *  </table>
	 *
     *  @eventType dragStart
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const DRAG_START:String = "dragStart";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *  Normally called by the Flex control and not used in application code.
	 *
	 *  @param type The event type; indicates the action that caused the event.
	 *
	 *  @param bubbles Specifies whether the event can bubble up the display list hierarchy.
	 *
	 *  @param cancelable Specifies whether the behavior associated with the event can be prevented.
	 *
	 *  @param dragInitiator IUIComponent that specifies the component initiating
	 *  the drag.
	 *
	 *  @param dragSource A DragSource object containing the data being dragged.
	 *
	 *  @param action The specified drop action, such as <code>DragManager.MOVE</code>.
	 *
	 *  @param ctrlKey Indicates whether the <code>Ctrl</code> key was pressed.
	 *
	 *  @param altKey Indicates whether the <code>Alt</code> key was pressed.
	 *
	 *  @param shiftKey Indicates whether the <code>Shift</code> key was pressed.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function DragEvent(type:String, bubbles:Boolean = false,
							  cancelable:Boolean = true,
							  dragInitiator:IUIComponent = null,
							  dragSource:DragSource = null,
							  action:String = null,
							  ctrlKey:Boolean = false,
							  altKey:Boolean = false,
							  shiftKey:Boolean = false)
	{
		super(type, bubbles, cancelable);

		this.dragInitiator = dragInitiator;
		this.dragSource = dragSource;
		this.action = action;
	//	this.ctrlKey = ctrlKey;
	//	this.altKey = altKey;
	//	this.shiftKey = shiftKey;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  action
	//----------------------------------

	/**
	 *  The requested action.
	 *  One of <code>DragManager.COPY</code>, <code>DragManager.LINK</code>,
	 *  <code>DragManager.MOVE</code>, or <code>DragManager.NONE</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var action:String;
	
	//----------------------------------
	//  draggedItem
	//----------------------------------

	/**
	 *  If the <code>dragInitiator</code> property contains 
	 *  an IAutomationObject object,
	 *  this property contains the child IAutomationObject object near the mouse cursor.
	 *  If the <code>dragInitiator</code> property does not contain 
	 *  an IAutomationObject object,  this proprty is <code>null</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
//	public var draggedItem:Object;

	//----------------------------------
	//  dragInitiator
	//----------------------------------

	/**
	 *  The component that initiated the drag.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var dragInitiator:IUIComponent;

	//----------------------------------
	//  dragSource
	//----------------------------------

	/**
	 *  The DragSource object containing the data being dragged.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var dragSource:DragSource;
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods: Event
	//
	//--------------------------------------------------------------------------

	/**
 	 *  @private
	 */
	/* override public function clone():Event
	{
		var cloneEvent:DragEvent = new DragEvent(type, bubbles, cancelable, 
                                                 dragInitiator, dragSource,
												 action, ctrlKey,
												 altKey, shiftKey);

		// Set relevant MouseEvent properties.
		cloneEvent.relatedObject = this.relatedObject;
		cloneEvent.localX = this.localX;
		cloneEvent.localY = this.localY;

		return cloneEvent;
	} */
}

}
