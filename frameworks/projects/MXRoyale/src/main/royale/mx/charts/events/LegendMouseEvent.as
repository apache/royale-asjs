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

package mx.charts.events
{

import org.apache.royale.events.Event;
import org.apache.royale.events.IRoyaleEvent;
import org.apache.royale.events.MouseEvent;
import mx.charts.LegendItem;

/**
 *   The LegendMouseEvent class represents event objects that are specific to the chart legend components.
 *   such as when a legend item is clicked on.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 * 
 *  @royalesuppresspublicvarwarning
 */
public class LegendMouseEvent extends MouseEvent
{
//    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

	/**
	 *  Event type constant; indicates that the user clicked the mouse button
	 *  over a legend item.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const ITEM_MOUSE_DOWN:String = "itemMouseDown";
	
	/**
	 *  Event type constant; indicates that the user released the mouse button
	 *  while over  a legend item.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const ITEM_MOUSE_UP:String = "itemMouseUp";
	
	/**
	 *  Event type constant; indicates that the user rolled the mouse pointer
	 *  away from a legend item.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const ITEM_MOUSE_OUT:String = "itemMouseOut";
	
	/**
	 *  Event type constant; indicates that the user rolled the mouse pointer
	 *  over  a legend item.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const ITEM_MOUSE_OVER:String = "itemMouseOver";
	
	/**
	 *  Event type constant; indicates that the user clicked the mouse button
	 *  over a legend item.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const ITEM_CLICK:String = "itemClick";

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	private static function convertType(baseType:String):String
	{
		switch (baseType)
		{
			case MouseEvent.CLICK:
			{
				return ITEM_CLICK;
			}
				
			case MouseEvent.MOUSE_DOWN:
			{
				return ITEM_MOUSE_DOWN;
			}
				
			case MouseEvent.MOUSE_UP:
			{
				return ITEM_MOUSE_UP;
			}
				
			case MouseEvent.MOUSE_OVER:
			{
				return ITEM_MOUSE_OVER;
			}
				
			case MouseEvent.MOUSE_OUT:
			{
				return ITEM_MOUSE_OUT;
			}
		}
		
		return baseType;
	}

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *	@param type The type of Mouse event. If a mouse event type is given it 
	 *  would be converted into a LegendMouseEvent type.
	 *
	 *  @param triggerEvent The MouseEvent that triggered this LegentMouseEvent.
	 *
	 *  @param item The item in the Legend on which this event was triggered.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function LegendMouseEvent(type:String, triggerEvent:MouseEvent=null, 
												item:LegendItem=null)
	{	
		var eventType:String = convertType(type);
		var bubbles:Boolean = true;
		var cancelable:Boolean = false;
		var localX:int = 0;
		var localY:int = 0;
		var relatedObject:Object = null;
		var ctrlKey:Boolean = false;
		var shiftKey:Boolean = false;
		var altKey:Boolean = false;
		var buttonDown:Boolean = false;
		var delta:int = 0;
			
		if (triggerEvent)
		{
        	bubbles = triggerEvent.bubbles;
			cancelable = triggerEvent.cancelable;
			localX = triggerEvent.localX;
			localY = triggerEvent.localY;
			relatedObject = triggerEvent.relatedObject;
			ctrlKey = triggerEvent.ctrlKey;
			altKey = triggerEvent.altKey;
			shiftKey = triggerEvent.shiftKey;
			buttonDown = triggerEvent.buttonDown;
			delta = triggerEvent.delta;
		}

		super(eventType, bubbles, cancelable, 
				localX, localY, relatedObject, 
				ctrlKey, altKey, shiftKey, 
				buttonDown, delta);

		this.item = item;
	}
	
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
	//  item
    //----------------------------------

	[Inspectable(environment="none")]

	/**
	 *  The item in the Legend on which this event was triggered.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var item:LegendItem;

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: event
    //
    //--------------------------------------------------------------------------

	/**
	 *	@private
	 */
	override public function cloneEvent():IRoyaleEvent
	{
		return new LegendMouseEvent(type, this, item);
	}
}

}
