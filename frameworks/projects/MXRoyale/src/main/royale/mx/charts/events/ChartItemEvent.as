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
import mx.charts.HitData;
import mx.charts.chartClasses.ChartBase;
import org.apache.royale.geom.Point;

/**
 * The ChartItemEvent class represents events that are specific
 * to the chart components, such as when a chart item is clicked.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 * 
 *  @royalesuppresspublicvarwarning
 */
public class ChartItemEvent extends MouseEvent
{
//    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

	/**
	 *  Event type constant; indicates that the user clicked the mouse button
	 *  over a chart item representing data in the chart.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const ITEM_CLICK:String = "itemClick";
	
	/**
	 *  Event type constant; indicates that the user double-clicked
	 *  the mouse button over a chart item representing data in the chart.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const ITEM_DOUBLE_CLICK:String = "itemDoubleClick";
	
	/**
	 *  Event type constant; indicates that the user pressed the mouse button
	 *  over a chart item representing data in the chart.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const ITEM_MOUSE_DOWN:String = "itemMouseDown";
	
	/**
	 *  Event type constant; indicates that the user moved the mouse pointer
	 *  while hovering over a chart item representing data in the chart.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const ITEM_MOUSE_MOVE:String = "itemMouseMove";
	
	/**
	 *  Event type constant; indicates that the user rolled the mouse pointer
	 *  away from a chart item representing data in the chart.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const ITEM_ROLL_OUT:String = "itemRollOut";
	
	/**
	 *  Event type constant; indicates that the user rolled the mouse pointer
	 *  over  a chart item representing data in the chart.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const ITEM_ROLL_OVER:String = "itemRollOver";
	
	/**
	 *  Event type constant; indicates that the user released the mouse button
	 *  while over  a chart item representing data in the chart.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const ITEM_MOUSE_UP:String = "itemMouseUp";

	/**
	 *  Event type constant; indicates that the selection in the chart has 
	 *  changed.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	
	public static const CHANGE:String = "change"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

	/**
	 *	Constructor.
	 *
	 *	@param type The type of the event.
	 *
	 *	@param hitSet An array of HitData structures describing
	 *  the ChartItems that triggered the event.
	 *
	 *	@param triggerEvent The MouseEvent that triggered this ChartItemEvent.
	 *
	 *	@param target The chart on which the event was triggered.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function ChartItemEvent(type:String, hitSet:Array /* of HitData */=null,
								   triggerEvent:MouseEvent=null, target:ChartBase=null)
	{	
		var relPt:Point;
		if (triggerEvent && triggerEvent.target)
		{
			relPt = target.globalToLocal(triggerEvent.target.localToGlobal(
				new Point(triggerEvent.localX, triggerEvent.localY)));
		}
		else
		{
		    if (target)
				relPt = new Point(target.mouseX,target.mouseY);
			else
				relPt = new Point(0,0);
		}
		
		var bubbles:Boolean = true;
		var cancelable:Boolean = false;
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
			relatedObject = triggerEvent.relatedObject;
			ctrlKey = triggerEvent.ctrlKey;
			altKey = triggerEvent.altKey;
			shiftKey = triggerEvent.shiftKey;
			buttonDown = triggerEvent.buttonDown;
			delta = triggerEvent.delta;
		}
		
			
		super(type, bubbles, cancelable,
			  relPt.x, relPt.y, relatedObject,
			  ctrlKey, altKey, shiftKey, buttonDown, delta);		

		this.hitSet = hitSet;		
	}

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
	//  hitData
    //----------------------------------

	[Inspectable(environment="none")]

	/** 
	 *  The first item in the hitSet array.
	 *  This is a convenience function for developers who don't care
	 *  about events corresponding to multiple items.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get hitData():HitData
	{
		return (hitSet && hitSet.length > 0)? hitSet[0]:null;
	}

    //----------------------------------
	//  hitSet
    //----------------------------------

	[Inspectable(environment="none")]

	/**
	 *  A set of HitData structures describing the chart items
	 *  that triggered the event.
	 *  This array is in depth order; the first item in the array
	 *  is the top-most item, and the last is the deepest.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var hitSet:Array /* of HitData */;
		
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: Event
    //
    //--------------------------------------------------------------------------

	/** 
	 *	@private
	 */
	override public function cloneEvent():IRoyaleEvent
	{
		return new ChartItemEvent(type, hitSet, this,ChartBase(this.target));
	}
}

}
