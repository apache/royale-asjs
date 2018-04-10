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

//import flash.events.Event;
import org.apache.royale.events.Event;

/**
 *  Represents events that are dispatched by the ScrollBar class.
 *
 *  @see mx.core.UIComponent
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 *  @royalesuppresspublicvarwarning
 */
public class ScrollEvent extends Event
{
	//--------------------------------------------------------------------------
	//
	// Class constants
	//
	//--------------------------------------------------------------------------

	/**
	 *  The <code>ScrollEvent.SCROLL</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a scroll event.
	 *
     *	<p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
 	 *       <tr><td><code>delta</code></td><td>Contains the change
     *         in scroll position, expressed in pixels. A positive value indicates the 
     * 		   scroll was down or to the right. A negative value indicates the scroll 
     * 		   was up or to the left.</td></tr>
	 *       <tr><td><code>direction</code></td><td>Contains the
     *         scroll direction, either <code>ScrollEventDirection.HORIZONTAL</code> or
     *         <code>ScrollEventDirection.VERTICAL</code>.</td></tr>
 	 *       <tr><td><code>position</code></td><td>Contains the
     *         new scroll position.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
	 *  </table>
     *     
	 *  @eventType scroll
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
	public static const SCROLL:String = "scroll";

	//--------------------------------------------------------------------------
	//
	// Constructor
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
         *  @param cancelable Specifies whether the behavior associated with the event
         *  can be prevented.
	 *
	 *  @param detail Provides the specifics of the type of scroll activity.
	 *  Constants for the possible values are provided
	 *  in the ScrollEventDetail class.
	 *
	 *  @param position The new scroll position.
	 *
	 *  @param direction The scroll direction, 
	 *  either <code>ScrollEventDirection.HORIZONTAL</code> or
         *  <code>ScrollEventDirection.VERTICAL</code>.
	 *
	 *  @param delta The change in scroll position, expressed in pixels.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
	public function ScrollEvent(type:String, bubbles:Boolean = false,
								cancelable:Boolean = false,
								detail:String = null, position:Number = NaN,
                                direction:String = null, delta:Number = NaN)
	{
		super(type, bubbles, cancelable);

		this.detail = detail;
        this.position = position;
        this.direction = direction;
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
	 *  The change in the scroll position value that resulted from 
	 *  the scroll. The value is expressed in pixels. A positive value indicates the 
     *  scroll was down or to the right. A negative value indicates the scroll  
     * 	was up or to the left.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
	public var delta:Number;

	//----------------------------------
	//  detail
	//----------------------------------

	/**
	 *  Provides the details of the scroll activity.
	 *  Constants for the possible values are provided
	 *  in the ScrollEventDetail class.
	 *
	 *  @see mx.events.ScrollEventDetail
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
	public var detail:String;

	//----------------------------------
	//  direction
	//----------------------------------

	/**
	 *  The direction of motion.
	 *  The possible values are <code>ScrollEventDirection.VERTICAL</code>
	 *  or <code>ScrollEventDirection.HORIZONTAL</code>.
	 *
	 *  @see mx.events.ScrollEventDirection
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
	public var direction:String;

 	//----------------------------------
	//  position
	//----------------------------------

    /**
	 *  The new scroll position.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public var position:Number;

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
		return new ScrollEvent(type, bubbles, cancelable, 
                               detail, position, direction, delta);
	}
}

}
