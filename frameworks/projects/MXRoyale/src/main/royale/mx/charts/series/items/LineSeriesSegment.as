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

package mx.charts.series.items
{

import mx.charts.series.LineSeries;

/**
 *  Represents the information required
 *  to render a segment in a LineSeries.
 *  The LineSeries class passes a LineSeriesSegment
 *  to its lineRenderer when rendering.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 * 
 *  @royalesuppresspublicvarwarning
 */
public class LineSeriesSegment
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
     *  @param element The owning series.
     *
     *  @param index The index of the segment in the Array of segments
     *  representing the line series.
     *
     *  @param items The Array of LineSeriesItems
     *  representing the full line series.
     *
     *  @param start The index in the items Array
     *  of the first item in this segment.
     *
     *  @param end The index in the items Array
     *  of the last item in this segment, inclusive.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function LineSeriesSegment(element:LineSeries, index:uint,
                                      items:Array /* of LineSeriesItem */, start:uint, end:uint)
    {
        super();

        this.element = element;
        this.items = items;
        this.index = index;
        this.start = start;
        this.end = end;
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
     *  The series or element that owns this segment.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var element:LineSeries;

    //----------------------------------
    //  end
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The index into the items array of the last item
     *  in this segment, inclusive.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var end:uint;

    //----------------------------------
    //  index
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The index of this segment in the array of segments
     *  representing the line series.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var index:uint;

    //----------------------------------
    //  items
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The array of chartItems representing the full line series
     *  that owns this segment.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var items:Array /* of LineSeriesItem */;

    //----------------------------------
    //  start
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The index into the items array of the first item in this segment.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var start:uint;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Returns a copy of this segment.
     *  
     *  @return A copy of this segment.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function clone():LineSeriesSegment
    {
        return new LineSeriesSegment(element, index, items, start, end);        
    }
}

}
