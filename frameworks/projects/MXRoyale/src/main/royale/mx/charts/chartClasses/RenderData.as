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

/* import flash.geom.Rectangle;
 */
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
 *  @productversion Royale 0.9.3
 *  @royalesuppresspublicvarwarning
 */
public class RenderData
{
/*     include "../../core/Version.as";
 */
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
     *  @productversion Royale 0.9.3
	 */
    public function RenderData(cache:Array /* of ChartItem */ = null, filteredCache:Array /* of ChartItem */ = null)
    {
        super();
        
       /*  this.cache = cache;
        this.filteredCache = filteredCache; */
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

   
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
     *  @productversion Royale 0.9.3
     */
    public var elementBounds:Array /* of Rectangle */;

    //----------------------------------
    //  filteredCache
    //----------------------------------

 /*    [Inspectable(environment="none")] */

    /**
     *  The list of ChartItems representing the items
     *  in the series's <code>dataProvider</code> that remain after filtering.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public var filteredCache:Array /* of ChartItem */;

   
   
}

}
