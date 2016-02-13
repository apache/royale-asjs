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
import org.apache.flex.events.Event;

[ExcludeClass]

/**
 *  @private
 *  The FlexChangeEvent class represents the event object passed to
 *  an event listener for Flex events that have data associated with
 *  some change in Flex. The <code>data</code> property provides 
 *  additional information about the event.
 *  
 */
public class FlexChangeEvent extends Event
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  The <code>FlexChangeEvent.ADD_CHILD_BRIDGE</code> constant defines the value of the
     *  <code>type</code> property of the event object for an <code>addChildBridge</code> event.
     *
     *  This event is dispatch by a SystemManager after a child SWFBridge has been added. This 
     *  event's <code>data</code> property is a reference to the added SWFBridge.
     * 
     *  added to the SystemManager.
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
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType addChildBridge
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const ADD_CHILD_BRIDGE:String = "addChildBridge";

    /**
     *  The <code>FlexChangeEvent.REMOVE_CHILD_BRIDGE</code> constant defines the value of the
     *  <code>type</code> property of the event object for an <code>removeChildBridge</code> event.
     *
     *  This event is dispatch by a SystemManager just before a child SWFBridge is removed. This 
     *  event's <code>data</code> property is a reference to the removed SWFBridge.
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
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType removeChildBridge
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const REMOVE_CHILD_BRIDGE:String = "removeChildBridge";

    /**
     *  @private
     * 
     *  Dispatched by a StyleManager when a style property is changed.
     * 
     *  The data parameter is an object that describes what changed:
     *  
     *  "property" - This property describes what kind of style manager
     *  property changed. 
     *  If the "property" property is "inheritingStyles" then the 
     *  StyleManager's inheritingStyles property was updated. 
     *  
     */
    public static const STYLE_MANAGER_CHANGE:String = "styleManagerChange";
    
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
     *  @param data Data related to the event.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */ 
    public function FlexChangeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object = null)
    {
        super(type, bubbles, cancelable);
        
        this.data = data;
    }
        
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  data
    //----------------------------------

    /**
     *  Data related to the event. For more information on this object, see each event type.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var data:Object;
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: Event
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override public function cloneEvent():Event
    {
        return new FlexChangeEvent(type, bubbles, cancelable, data);
    }

}
}