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

package spark.events
{
    
import org.apache.royale.events.Event;
import org.apache.royale.geom.Rectangle;

/**
 *  The TitleWindowBoundsEvent class represents event objects 
 *  that are dispatched when bounds of a
 *  Spark TitleWindow changes, either by moving or resizing.
 *
 *  @see spark.components.TitleWindow
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class TitleWindowBoundsEvent extends Event
{
    //include "../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    /**
     *  The <code>TitleWindowBoundsEvent.WINDOW_MOVE_START</code> constant defines the value of the
     *  <code>type</code> property of the event object for a <code>windowMoveStart</code> event.
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>true</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>beforeBounds</code></td><td>The starting bounds of the object.</td></tr>
     *     <tr><td><code>afterBounds</code></td><td>null</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType windowMoveStart
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const WINDOW_MOVE_START:String = "windowMoveStart";
    
    /**
     *  The <code>TitleWindowBoundsEvent.WINDOW_MOVING</code> constant defines the value of the
     *  <code>type</code> property of the event object for a <code>windowMoving</code> event.
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>true</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>beforeBounds</code></td><td>The current bounds of the object.</td></tr>
     *     <tr><td><code>afterBounds</code></td><td>The future bounds of the object
     *       if the object moves to the current cursor position.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType windowMoving
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const WINDOW_MOVING:String = "windowMoving";

    /**
     *  The <code>TitleWindowBoundsEvent.WINDOW_MOVE</code> constant defines the value of the
     *  <code>type</code> property of the event object for a <code>windowMove</code> event.
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
     *     <tr><td><code>beforeBounds</code></td><td>The previous bounds of the object.</td></tr>
     *     <tr><td><code>afterBounds</code></td><td>The current bounds of the object.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType windowMove
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const WINDOW_MOVE:String = "windowMove";  

    /**
     *  The <code>TitleWindowBoundsEvent.WINDOW_MOVE_END</code> constant defines the value of the
     *  <code>type</code> property of the event object for a <code>windowMoveEnd</code> event.
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
     *     <tr><td><code>beforeBounds</code></td><td>The starting bounds of the object.</td></tr>
     *     <tr><td><code>afterBounds</code></td><td>The final bounds of the object.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType windowMoveEnd
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const WINDOW_MOVE_END:String = "windowMoveEnd";   
    
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
     *  @param beforeBounds The bounds of the window before the action. If
     *      this event is cancelable, <code>beforeBounds</code> is the current bounds of
     *      the window. Otherwise, it is the bounds before a change occurred.
     *
     *  @param afterBounds The bounds of the window after the action. If
     *      this event is cancelable, <code>afterBounds</code> is the future bounds of
     *      the window. Otherwise, it is the current bounds.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function TitleWindowBoundsEvent(type:String, bubbles:Boolean = false,
                                           cancelable:Boolean = false,
                                           beforeBounds:Rectangle = null, afterBounds:Rectangle = null)
    {
        super(type, bubbles, cancelable);
        
        this.beforeBounds = beforeBounds;
        this.afterBounds = afterBounds;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  beforeBounds
    //----------------------------------
    
    /**
     *  The bounds of the object before the action. If this event
     *  is cancelable, <code>beforeBounds</code> is the current bounds of
     *  the window. Otherwise, it is the bounds before a change occurred.
     *
     *  <p>The following list shows how this property is set for the different 
     *  event types:</p>
     *
     *  <ul>
     *    <li><code>WINDOW_MOVE</code> - The previous bounds of the window.</li>
     *    <li><code>WINDOW_MOVE_END</code> - The starting bounds of the window, before the drag.</li>
     *    <li><code>WINDOW_MOVE_START   </code> - The starting bounds of the window.</li>
     *    <li><code>WINDOW_MOVING</code> - The current bounds of the window.</li>
     *  </ul>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var beforeBounds:Rectangle;
    
    //----------------------------------
    //  afterBounds
    //----------------------------------
    
    /**
     *  The bounds of the object after the action. If this event
     *  is cancelable, <code>afterBounds</code> is the future bounds of
     *  the window. Otherwise, it is the current bounds.
     *
     *  <p>The following list shows how this property is set for the different 
     *  event types:</p>
     *
     *  <ul>
     *    <li><code>WINDOW_MOVE</code> - The current bounds of the window.</li>
     *    <li><code>WINDOW_MOVE_END</code> - The final bounds of the window, before the drag.</li>
     *    <li><code>WINDOW_MOVE_START   </code> - null.</li>
     *    <li><code>WINDOW_MOVING</code> - The future bounds of the window 
     *      if the window moves to the current cursor position.</li>
     *  </ul>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var afterBounds:Rectangle;
    
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
        return new TitleWindowBoundsEvent(type, bubbles, cancelable, beforeBounds, afterBounds);
    }
}

}
