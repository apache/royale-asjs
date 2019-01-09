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

package mx.charts.series.renderData
{

import mx.charts.chartClasses.RenderData;
import mx.charts.series.AreaSeries;

/**
 *  Represents all the information needed by the AreaSeries to render.  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 * 
 *  @royalesuppresspublicvarwarning
 */
public class AreaSeriesRenderData extends RenderData
{
//    include "../../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param element The AreaSeries object that this structure is associated with.
     *  @param cache The list of AreaSeriesItem objects representing the items in the dataProvider.
     *  @param filteredCache The list of AreaSeriesItem objects representing the items in the dataProvider that remain after filtering.
     *  @param renderedBase The vertical position of the base of the area series, in pixels.
     *  @param radius The radius of the items of the AreaSeries.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function AreaSeriesRenderData(element:AreaSeries,
                                         cache:Array /* of AreaSeriesItem */ = null,
                                         filteredCache:Array /* of AreaSeriesItem */ = null,
                                         renderedBase:Number = 0,
                                         radius:Number = 0) 
    {
        super(cache,filteredCache);

        this.element = element;
        this.renderedBase = renderedBase;
        this.radius = radius;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  element
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The AreaSeries that this structure is associated with.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var element:AreaSeries;
    
    //----------------------------------
    //  radius
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The radius of the items of the AreaSeries.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var radius:Number;
    
    //----------------------------------
    //  renderedBase
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The vertical position of the base of the area series, in pixels.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var renderedBase:Number;
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override public function clone():RenderData
    {
        return new AreaSeriesRenderData(element, cache, filteredCache,
                                        renderedBase, radius);
    }
}

}
