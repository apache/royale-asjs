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

package mx.charts
{


import org.apache.royale.events.Event;
import org.apache.royale.events.EventDispatcher;
import org.apache.royale.events.IEventDispatcher;
import mx.core.IFlexDisplayObject;
import mx.core.IInvalidating;
/* import mx.core.IProgrammaticSkin;
 */
 import mx.core.IUIComponent;

/**
 *  A ChartItem represents a single item in a ChartSeries.
 *  In most standard series, there is one ChartItem created
 *  for each item in the series' dataProvider collection.
 *  ChartItems are passed to the instances of a series' itemRenderer
 *  for rendering.  
 *  Most Series types extend ChartItem to contain additional information
 *  specific to the chart type.  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 *  @royalesuppresspublicvarwarning
 */
public class ChartItem extends EventDispatcher
{
/*     include "../core/Version.as";
 */
   
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param element The series or element to which the ChartItem belongs.
     *
     *  @param item The item from the series' data provider
     *  that the ChartItem represents.
     *
     *  @param index The index of the data from the series' data provider
     *  that the ChartItem represents.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function ChartItem(element:Object = null,
                              item:Object = null, index:uint = 0)
    {
        super();

     //   this.element = element;
        this.item = item;
        this.index = index;
     //   this._currentState = ChartItem.NONE;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

  
    //----------------------------------
    //  index
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The index of the data from the series' data provider
     *  that the ChartItem represents.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public var index:int;
    
    //----------------------------------
    //  item
    //----------------------------------
    
    [Inspectable(environment="none")]

    /**
     *  The item from the series' data provider that the ChartItem represents.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public var item:Object;

   

   
}
    
}
