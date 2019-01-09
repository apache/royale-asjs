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

package mx.charts.chartClasses
{

import org.apache.royale.geom.Rectangle;

/**
 *  RenderData structures are used by chart elements to store
 *  all of the relevant values and data needed to fully render the chart.
 *  Storing these values in a separate structure lets chart elements
 *  decouple their rendering from their assigned properties
 *  and data as necessary.
 *  This ability is used by the chart effects: effects such as
 *  SeriesInterpolate substitute temporary values calculated from 
 *  previous and future renderData structures. Effects such as SeriesSlide
 *  and SeriesZoom substitute temporary RenderData structures
 *  with values calculated to render the effect correctly.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 * 
 *  @royalesuppresspublicvarwarning
 */
public class RenderData
{
//    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     *
     *  @param cache The list of ChartItems representing the items
     *  in the series's <code>dataProvider</code>.
     *
     *  @param filteredCache The list of ChartItems representing the items
     *  in the series's <code>dataProvider</code> that remain after filtering.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function RenderData(cache:Array /* of ChartItem */ = null, filteredCache:Array /* of ChartItem */ = null)
    {
        super();
        
        this.cache = cache;
        this.filteredCache = filteredCache;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  bounds
    //----------------------------------
    
    [Inspectable(environment="none")]

    /**
     *  The bounds of all of the items a series displays on screen,
     *  relative to the series's coordinate system.
     *  This value is used by the various effects during rendering.
     *  A series fills in this value when the effect
     *  calls the <code>getElementBounds()</code> method.
     *  A series does not need to fill in this field
     *  unless specifically requested.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var bounds:Rectangle;
    
    //----------------------------------
    //  cache
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The list of ChartItems representing the items
     *  in the series's <code>dataProvider</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var cache:Array /* of ChartItem */;
    
    //----------------------------------
    //  elementBounds
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  An Array of rectangles describing the bounds of the series's
     *  ChartItems, relative to the series's coordinate system.
     *  Effects use this Array
     *  to generate the effect rendering.
     *  An effect calls the <code>getElementBounds()</code> method, which 
     *  causes the series to fill in this value.
     *  A series does not need to fill in this field
     *  unless specifically requested.  
     *  Effects modify this Array to relect current positions
     *  of the items during the effect duration.
     *  If this value is filled in on the series's <code>renderData</code>,
     *  the series renders itself based on these rectangles
     *  rather than from the series's data.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var elementBounds:Array /* of Rectangle */;

    //----------------------------------
    //  filteredCache
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The list of ChartItems representing the items
     *  in the series's <code>dataProvider</code> that remain after filtering.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var filteredCache:Array /* of ChartItem */;

    //----------------------------------
    //  length
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The number of items represented in this render data. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get length():uint
    {
        return cache ? cache.length : 0;
    }

    //----------------------------------
    //  visibleRegion
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The rectangle describing the possible coordinate range
     *  that a series can display on screen.
     *  This value is used by the various effects during rendering.
     *  An effect calls the <code>getElementBounds()</code> method 
     *  to fill in this value.
     *  A series does not need to fill in this field
     *  unless specifically requested.
     *  If left <code>null</code>, effects assume the visible region of an element
     *  is the bounding box of the element itself (0, 0, width, height),
     *  expressed relative to the element.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var visibleRegion:Rectangle;
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Creates a copy of the render data. In the new copy, properties that point to other objects continue to
     *  point to the same objects as the original.
     *  
     *  <p>If you subclass this class, you must override this method.</p>
     *  
     *  @return The new copy of the RenderData object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function clone():RenderData
    {
        return null;
    }
}

}
