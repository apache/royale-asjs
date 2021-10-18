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
/* import mx.events.Event;*/
import org.apache.royale.events.Event;
import org.apache.royale.events.IEventDispatcher;
import org.apache.royale.events.IRoyaleEvent;
import org.apache.royale.events.MouseEvent;

/**
 *  Represents event objects that are dispatched when a Flex component moves.
 *
 *  @see mx.core.UIComponent
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 *  @royalesuppresspublicvarwarning
 */
public class MouseEvent extends org.apache.royale.events.MouseEvent
{
   /*  include "../core/Version.as"; */
	public static const MOUSE_DOWN:String = org.apache.royale.events.MouseEvent.MOUSE_DOWN;
	public static const MOUSE_MOVE:String = org.apache.royale.events.MouseEvent.MOUSE_MOVE;
	public static const MOUSE_UP:String = org.apache.royale.events.MouseEvent.MOUSE_UP;
	public static const MOUSE_OUT:String = org.apache.royale.events.MouseEvent.MOUSE_OUT;
	public static const MOUSE_OVER:String = org.apache.royale.events.MouseEvent.MOUSE_OVER;
	public static const ROLL_OVER:String = org.apache.royale.events.MouseEvent.ROLL_OVER;
	public static const ROLL_OUT:String = org.apache.royale.events.MouseEvent.ROLL_OUT;
	public static const CLICK:String = org.apache.royale.events.MouseEvent.CLICK;
	public static const DOUBLE_CLICK:String = org.apache.royale.events.MouseEvent.DOUBLE_CLICK;
	public static const CONTEXT_MENU:String = org.apache.royale.events.MouseEvent.CONTEXT_MENU;
	public static const MOUSE_WHEEL:String = org.apache.royale.events.MouseEvent.MOUSE_WHEEL;
	
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------

	COMPILE::SWF
    {
		override public function get stageX():Number
		{
			return super.stageX;
		}
		
		override public function get stageY():Number
		{
			return super.stageY;
		}
		override public function updateAfterEvent():void
		{
			super.updateAfterEvent();
		}
	}
	
	COMPILE::JS
    {
		public function get stageX():Number
		{
			return screenX;
		}
		
		public function get stageY():Number
		{
			return screenY;
		}
		public function updateAfterEvent():void
		{
		}
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
	 *  @param bubbles Specifies whether the event can bubble
	 *  up the display list hierarchy.
	 *
	 *  @param cancelable Specifies whether the behavior
	 *  associated with the event can be prevented.
	 *
	 *  @param localX The x coordinate of the mouse relative to the target, in pixels.
	 *
	 *  @param localY The y coordinate of the mouse relative to the target, in pixels.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
    COMPILE::SWF
	public function MouseEvent(type:String, bubbles:Boolean = false,
							  cancelable:Boolean = false,
                              localX:Number = NaN, localY:Number = NaN,
                              relatedObject:Object = null,
                              ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false,
                              buttonDown:Boolean = false, delta:int = 0,
                              commandKey:Boolean = false, controlKey:Boolean = false,
                              clickCount:int = 0, targetBeforeBubbling:IEventDispatcher = null)
	{
		super(type, bubbles, cancelable, localX, localY, relatedObject,
                ctrlKey, altKey, shiftKey, buttonDown, delta, commandKey, controlKey,
                clickCount, targetBeforeBubbling);
	}
	
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
     *  @param localX The x coordinate of the mouse relative to the target, in pixels.
     *
     *  @param localY The y coordinate of the mouse relative to the target, in pixels.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    COMPILE::JS
    public function MouseEvent(type:String, bubbles:Boolean = false,
                               cancelable:Boolean = false,
                               localX:Number = NaN, localY:Number = NaN)
    {
        super(type, bubbles, cancelable);
        this.localX = localX;
        this.localY = localY;        
    }

	

	
}

}
