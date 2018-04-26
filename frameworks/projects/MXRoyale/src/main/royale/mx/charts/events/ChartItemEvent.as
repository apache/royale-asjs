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

/* import flash.events.Event;
import flash.events.MouseEvent;
import flash.display.InteractiveObject;
import flash.geom.Point; */
import mx.charts.HitData;
import mx.charts.chartClasses.ChartBase;
import org.apache.royale.events.MouseEvent;
import org.apache.royale.events.Event;
import org.apache.royale.events.IRoyaleEvent;
import org.apache.royale.geom.Point;
/**
 * The ChartItemEvent class represents events that are specific
 * to the chart components, such as when a chart item is clicked.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class ChartItemEvent extends  org.apache.royale.events.MouseEvent
{
  //  include "../../core/Version.as";

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
	 *  @productversion Royale 0.9.3
	 */
	public static const ITEM_CLICK:String = "itemClick";
	
	
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
	 *  @productversion Royale 0.9.3
	 */
	public function ChartItemEvent(type:String, hitSet:Array=null,
								   triggerEvent:MouseEvent=null, target:ChartBase=null)
	{	
		
		
		super(type, bubbles, cancelable,
			  0,0, relatedObject,
			  ctrlKey, altKey, shiftKey, buttonDown, delta);		
		
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
	 *  @productversion Royale 0.9.3
	 */
	public function get hitData():HitData
	{
	return null;
	}

    
		
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
		return new ChartItemEvent(type, null, this,ChartBase(this.target));
	}
}

}
