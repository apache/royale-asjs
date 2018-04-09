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
 *  This is an event sent between applications in different security sandboxes to notify listeners
 *  about mouse activity in another security sandbox.
 *
 *  For security reasons, some fields of a MouseEvent are not sent
 *  in a SandboxMouseEvent.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class SandboxMouseEvent extends Event
{
	include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
		
	/**
	 *  Mouse was clicked somewhere outside your sandbox.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
    public static const CLICK_SOMEWHERE:String = "clickSomewhere";

	/**
	 *  Mouse was double-clicked somewhere outside your sandbox.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
    public static const DOUBLE_CLICK_SOMEWHERE:String = "doubleClickSomewhere";

	/**
	 *  Mouse button was pressed down somewhere outside your sandbox.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
    public static const MOUSE_DOWN_SOMEWHERE:String = "mouseDownSomewhere";

	/**
	 *  Mouse was moved somewhere outside your sandbox.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
    public static const MOUSE_MOVE_SOMEWHERE:String = "mouseMoveSomewhere";

	/**
	 *  Mouse button was released somewhere outside your sandbox.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
    public static const MOUSE_UP_SOMEWHERE:String = "mouseUpSomewhere";

	/**
	 *  Mouse wheel was spun somewhere outside your sandbox.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
    public static const MOUSE_WHEEL_SOMEWHERE:String = "mouseWheelSomewhere";

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Marshal a SWFBridgeRequest from a remote ApplicationDomain into the current
     *  ApplicationDomain.
     * 
     *  @param event A SWFBridgeRequest that might have been created in a different ApplicationDomain.
     * 
     *  @return A SandboxMouseEvent created in the caller's ApplicationDomain.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function marshal(event:Event):SandboxMouseEvent
	{
		var eventObj:Object = event;

		return new SandboxMouseEvent(eventObj.type, eventObj.bubbles,
                                     eventObj.cancelable,
							         eventObj.ctrlKey, eventObj.altKey, 
							         eventObj.shiftKey, eventObj.buttonDown); 
	}

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
	 *  @param ctrlKey Indicates whether the <code>Ctrl</code> key was pressed.
	 *
	 *  @param altKey Indicates whether the <code>Alt</code> key was pressed.
	 *
	 *  @param shiftKey Indicates whether the <code>Shift</code> key was pressed.	 
	 *  
	 *  @param buttonDown Indicates whether the primary mouse button is pressed (true) or not (false).
	 *  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function SandboxMouseEvent(type:String, bubbles:Boolean = false,
                                      cancelable:Boolean = false,
									  ctrlKey:Boolean = false,
                                      altKey:Boolean = false,
                                      shiftKey:Boolean = false,
									  buttonDown:Boolean = false)
	{
		super(type, bubbles, cancelable);

		this.ctrlKey = ctrlKey;
		this.altKey = altKey;
		this.shiftKey = shiftKey;
		this.buttonDown = buttonDown;
	}

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  altKey
    //----------------------------------

	/**
	 *  Indicates whether the <code>Alt</code> key was pressed.
	 *  
	 *  @see flash.events.MouseEvent#altkey
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var altKey:Boolean;

    //----------------------------------
    //  buttonDown
    //----------------------------------

	/**
	 *  Indicates whether the primary mouse button is pressed (true) or not (false).
	 *  
	 *  @see flash.events.MouseEvent#buttonDown
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var buttonDown:Boolean;

    //----------------------------------
    //  ctrlKey
    //----------------------------------

	/**
	 *  Indicates whether the <code>Ctrl</code> key was pressed.
	 *  
	 *  @see flash.events.MouseEvent#ctrlKey
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var ctrlKey:Boolean;

    //----------------------------------
    //  shiftKey
    //----------------------------------

	/**
	 *  Indicates whether the <code>Shift</code> key was pressed.
	 *  
	 *  @see flash.events.MouseEvent#shiftKey
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var shiftKey:Boolean;

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
		return new SandboxMouseEvent(type, bubbles, cancelable,
                                     ctrlKey, altKey, shiftKey, buttonDown);
	}
}

}
