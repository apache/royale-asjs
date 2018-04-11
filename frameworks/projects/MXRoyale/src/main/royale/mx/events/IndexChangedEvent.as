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

/**
 *  The IndexChangedEvent class represents events that are dispatched when 
 *  an index changes.
 *  This event can indicate that the index value of a child of a container changed,
 *  the displayed child of a navigator container such as an Accordion or 
 *  ViewStack changed, or the order of column headers in a DataGrid 
 *  control changed.
 *
 *  @see mx.core.Container
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class IndexChangedEvent extends Event
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  The IndexChangedEvent.CHANGE constant defines the value of the 
     *  <code>type</code> property of the event object for a <code>change</code> event,
     *  which indicates that an index has changed, such as when and Accordion control
     *  changes the displayed panel or a ViewStack changes views. 
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
     *     <tr><td><code>inputType</code></td><td>Indicates whether this event 
     *         was caused by a mouse or keyboard interaction.</td></tr>
     *     <tr><td><code>newIndex</code></td><td>The zero-based index 
     *       after the change.</td></tr>
     *     <tr><td><code>oldIndex</code></td><td>The zero-based index 
     *       before the change.</td></tr>
     *     <tr><td><code>relatedObject</code></td><td>Contains a reference
     *       to the child object that corresponds to the new index.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>TriggerEvent</code></td><td>The event that 
     *        triggered this event.</td></tr>
     *     <tr><td><code>Type</code></td><td>IndexChangedEvent.CHANGE</td></tr>
     *  </table>
     *   
     *  @eventType change
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const CHANGE:String = "change";

    /**
     *  The IndexChangedEvent.CHILD_INDEX_CHANGE constant defines the value of the 
     *  <code>type</code> property of the event object for a childIndexChange event,
     *  which indicates that a component's index among a container's children 
     *  has changed.
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
     *     <tr><td><code>inputType</code></td><td>Indicates whether this event 
     *         was caused by a mouse or keyboard interaction.</td></tr>
     *     <tr><td><code>newIndex</code></td><td>The zero-based index of the 
     *       child after the change.</td></tr>
     *     <tr><td><code>oldIndex</code></td><td>The zero-based index of the 
     *       child before the change.</td></tr>
     *     <tr><td><code>relatedObject</code></td><td>Contains a reference
     *       to the child object whose index changed.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>TriggerEvent</code></td><td>null</td></tr>
     *     <tr><td><code>Type</code></td><td>IndexChangedEvent.CHILD_INDEX_CHANGE</td></tr>
     *  </table>
     *   
     *  @eventType childIndexChange
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const CHILD_INDEX_CHANGE:String = "childIndexChange";

    /**
     *  The IndexChangedEvent.HEADER_SHIFT constant defines the value of the 
     *  <code>type</code> property of the event object for a <code>headerShift</code> event,
     *  which indicates that a header has changed its index, as when a user drags
     *  a DataGrid column to a new position.
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
     *     <tr><td><code>inputType</code></td><td>Indicates whether this event 
     *         was caused by a mouse or keyboard interaction.</td></tr>
     *     <tr><td><code>newIndex</code></td><td>The zero-based index of the 
     *       header after the change.</td></tr>
     *     <tr><td><code>oldIndex</code></td><td>The zero-based index of the 
     *       header before the change.</td></tr>
     *     <tr><td><code>relatedObject</code></td><td>null</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>TriggerEvent</code></td><td>The event that 
     *        triggered this event.</td></tr>
     *     <tr><td><code>Type</code></td><td>IndexChangedEvent.HEADER_SHIFT</td></tr>
     *  </table>
     *   
     *  @eventType headerShift
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const HEADER_SHIFT:String = "headerShift";
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *  Normally called by a Flex control and not used in application code.
     *
     *  @param type The event type; indicates the action that caused the event.
     *
     *  @param bubbles Specifies whether the event can bubble
     *  up the display list hierarchy.
     *
     *  @param cancelable Specifies whether the behavior
     *  associated with the event can be prevented.
     *
     *  @param relatedObject The child object associated with the index change.
     *
     *  @param oldIndex The zero-based index before the change.
     *
     *  @param newIndex The zero-based index after the change.
     *
     *  @param triggerEvent The event that triggered this event.
     *  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function IndexChangedEvent(type:String, bubbles:Boolean = false,
                                      cancelable:Boolean = false,
                                      relatedObject:Object = null,
                                      oldIndex:Number = -1,
                                      newIndex:Number = -1,
                                      triggerEvent:Event = null)
    {
        super(type, bubbles, cancelable);

        this.relatedObject = relatedObject;
        this.oldIndex = oldIndex;
        this.newIndex = newIndex;
        this.triggerEvent = triggerEvent;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  newIndex
    //----------------------------------

    /**
     *  The zero-based index after the change. For <code>change</code> events
     *  it is the index of the current child. For <code>childIndexChange</code>
     *  events, it is the new index of the child. For <code>headerShift</code>
     *  events, it is the new index of the header.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var _newIndex:Number;
	
	public function get newIndex():Number
	{
		return _newIndex;
	}
	public function set newIndex(value:Number):void
	{
		_newIndex = value;
	}

    //----------------------------------
    //  oldIndex
    //----------------------------------

    /**
     *  The zero-based index before the change.  
     *  For <code>change</code> events it is the index of the previous child.
     *  For <code>childIndexChange</code> events, it is the previous index 
     *  of the child.
     *  For <code>headerShift</code> events, it is the previous index of 
     *  the header.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var _oldIndex:Number;
	
	public function get oldIndex():Number
	{
		return _oldIndex;
	}
	public function set oldIndex(value:Number):void
	{
		_oldIndex = value;
	}

    //----------------------------------
    //  relatedObject
    //----------------------------------

    /**
     *  The child object whose index changed, or the object associated with
     *  the new index. This property is not set for header changes. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var _relatedObject:Object;
	
	public function get relatedObject():Object
	{
		return _relatedObject;
	}
	public function set relatedObject(value:Object):void
	{
		_relatedObject = value;
	}

    //----------------------------------
    //  triggerEvent
    //----------------------------------

    /**
     *  The event that triggered this event. 
     *  Indicates whether this event was caused by a mouse or keyboard interaction.
     *  The value is <code>null</code> when a container dispatches a 
     *  <code>childIndexChanged</code> event.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var _triggerEvent:Event;
	
	public function get triggerEvent():Event
	{
		return _triggerEvent;
	}
	public function set triggerEvent(value:Event):void
	{
		_triggerEvent = value;
	}

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
        return new IndexChangedEvent(type, bubbles, cancelable,
                                     relatedObject, oldIndex, 
                                     newIndex, triggerEvent);
    }
}

}
