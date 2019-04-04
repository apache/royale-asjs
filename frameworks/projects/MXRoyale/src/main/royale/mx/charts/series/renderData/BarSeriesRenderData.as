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

/**
 *  Represents all the information needed by the BarSeries to render.  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 * 
 *  @royalesuppresspublicvarwarning
 */
public class BarSeriesRenderData extends RenderData
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
     *  @param cache The list of BarSeriesItem objects representing the items in the dataProvider
     *  @param filteredCache The list of BarSeriesItem objects representing the items in the dataProvider that remain after filtering.
     *  @param renderedBase The horizontal position of the base of the bars, in pixels.
     *  @param renderedHalfWidth Half the width of a bar, in pixels.
     *  @param renderedYOffset The offset of each bar from its y value, in pixels.
     *  @param labelScale The scale factor of the labels rendered by the bar series.
     *  @param labelData A structure of data associated with the layout of the labels rendered by the bar series.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function  BarSeriesRenderData(cache:Array /* of BarSeriesItem */ = null,
                                         filteredCache:Array /* of BarSeriesItem */ = null,
                                         renderedBase:Number = 0,
                                         renderedHalfWidth:Number = 0,
                                         renderedYOffset:Number = 0,
                                         labelScale:Number = 1,
                                         labelData:Object = null) 
    {       
        super(cache, filteredCache);

        this.renderedBase = renderedBase;
        this.renderedHalfWidth = renderedHalfWidth;
        this.renderedYOffset = renderedYOffset;
        this.labelScale = labelScale;
        this.labelData = labelData;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  labelData
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  A structure of data associated with the layout of the labels rendered by the bar series.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var labelData:Object;
    
    //----------------------------------
    //  labelScale
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The scale factor of the labels rendered by the bar series.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var labelScale:Number;
    
    //----------------------------------
    //  renderedBase
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The horizontal position of the base of the bars, in pixels.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var renderedBase:Number;

    //----------------------------------
    //  renderedHalfWidth
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  Half the width of a bar, in pixels.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var renderedHalfWidth:Number;

    //----------------------------------
    //  renderedYOffset
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The offset of each bar from its y value, in pixels.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var renderedYOffset:Number;

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
        return new BarSeriesRenderData(cache, filteredCache, renderedBase,
                                       renderedHalfWidth, renderedYOffset,
                                       labelScale,labelData);
    }
}

}
