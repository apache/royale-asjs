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
/*	
import flash.display.DisplayObject;
import flash.events.Event;
import flash.geom.Point;
*/
	
import org.apache.royale.events.Event;
import org.apache.royale.geom.Point;

/**
 *  TouchInteractionEvents are used to coordinate touch intraction and response 
 *  among different components.  
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
public class TouchInteractionEvent extends Event
{
    
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    /**
     *  The <code>TouchInteractionEvent.TOUCH_INTERACTION_STARTING</code> constant defines the value of the
     *  <code>type</code> property of the event object for a <code>touchInteractionStarting</code> event.
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>true</td></tr>
     *     <tr><td><code>cancelable</code></td><td>true</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>reason</code></td><td>The reason for the touch interaction event.  See 
     *       <code>mx.events.TouchInteractionReason</code>.</td></tr>
     *     <tr><td><code>relatedObject</code></td><td>The object associated with this touch interaction event.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType touchInteractionStarting
     *  @see mx.events.TouchInteractionReason
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public static const TOUCH_INTERACTION_STARTING:String = "touchInteractionStarting";
    
    /**
     *  The <code>TouchInteractionEvent.TOUCH_INTERACTION_START</code> constant defines the value of the
     *  <code>type</code> property of the event object for a <code>touchInteractionStart</code> event.
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>true</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>reason</code></td><td>The reason for the touch interaction event.  See 
     *       <code>mx.events.TouchInteractionReason</code>.</td></tr>
     *     <tr><td><code>relatedObject</code></td><td>The object associated with this touch interaction event.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType touchInteractionStart
     *  @see mx.events.TouchInteractionReason
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public static const TOUCH_INTERACTION_START:String = "touchInteractionStart";
    
    /**
     *  The <code>TouchInteractionEvent.TOUCH_INTERACTION_END</code> constant defines the value of the
     *  <code>type</code> property of the event object for a <code>touchInteractionEnd</code> event.
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
     *     <tr><td><code>reason</code></td><td>The reason for the touch interaction event.  See 
     *       <code>mx.events.TouchInteractionReason</code>.</td></tr>
     *     <tr><td><code>relatedObject</code></td><td>The object associated with this touch interaction event.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType touchInteractionEnd
     *  @see mx.events.TouchInteractionReason
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public static const TOUCH_INTERACTION_END:String = "touchInteractionEnd";
    
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
     *  @param bubbles Specifies whether the event can bubble
     *  up the display list hierarchy.
     *
     *  @param cancelable Specifies whether the behavior
     *  associated with the event can be prevented.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function TouchInteractionEvent(type:String, bubbles:Boolean = false,
                                        cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  reason
    //----------------------------------
    
    /**
     *  The reason for this gesture capture event.
     * 
     *  @see mx.events.TouchInteractionReason
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public var reason:String;
    
    //----------------------------------
    //  relatedObject
    //----------------------------------
    
    /**
     *  The object attempting to capture this touch interaction.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public var relatedObject:Object;
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    /*override public function clone():Event
    {
        var clonedEvent:TouchInteractionEvent = new TouchInteractionEvent(type, bubbles, cancelable);
        
        clonedEvent.reason = reason;
        clonedEvent.relatedObject = relatedObject;
        
        return clonedEvent;
    }*/
}
}