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
import org.apache.royale.geom.Point;

import mx.charts.HitData;
import mx.charts.chartClasses.ChartBase;

/**
 * The ChartEvent class represents events that are specific
 * to the chart control, such as when a chart is clicked. This event
 * is only triggered if there are no ChartItem objects underneath the mouse.
 * 
 * @see mx.charts.events.ChartItemEvent
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ChartEvent extends MouseEvent
{
//    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  Indicates that the user clicked the mouse button
     *  over a chart control but not on a chart item.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const CHART_CLICK:String = "chartClick";
    
    /**
     *  Indicates that the user double-clicked
     *  the mouse button over a chart control but not on a chart item.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const CHART_DOUBLE_CLICK:String = "chartDoubleClick";
    

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param type The type of the event.
     *
     *  @param triggerEvent The MouseEvent that triggered this ChartEvent.
     *
     *  @param target The chart on which the event was triggered.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function ChartEvent(type:String, triggerEvent:MouseEvent=null, target:ChartBase=null)
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
        return new ChartEvent(type, this, ChartBase(this.target));
    }
}

}
