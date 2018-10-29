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
import mx.core.IFlexDisplayObject;
import org.apache.royale.geom.Point;

/**
 *  IChartElement2 defines the base set of properties and methods
 *  required by a UIComponent to be representable in the data space of a chart.
 *  Any component assigned to the series, backgroundElements,
 *  or annotationElements Arrays of a chart must implement this interface.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IChartElement2 extends IChartElement
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Converts a tuple of data values to an x-y coordinate on screen.
     *  Call this function to transform data on to the screen
     *  using the same transform that the individual elements go through.
     *  For example, to create a custom highlight for a data region of a chart,
     *  you might use this function to determine the on-screen coordinates
     *  of the range of interest.
     *  
     *  <p>For Cartesian chartelements, you typically pass two values.
     *  The first value maps to the horizontal axis,
     *  and the second value maps to the vertical axis.</p>
     *  
     *  <p>For polar charts, the first value maps to the angular axis,
     *  and the second maps to the radial axis.</p>
     *  
     *  @param dataValues The data values to convert to coordinates.
     *  
     *  @return Coordinates that are relative to the chart.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function dataToLocal(... dataValues):Point;
    
    /**
     *  Converts a coordinate on screen to a tuple of data values.
     *  Call this function to determine what data values
     *  a particular point on-screen represents.
     *  <p>Individual chart types determine how this transformation occurs.
     *  The point should be relative to the chart's coordinate space.</p>
     *  
     *  @param pt The Point to convert.
     *  
     *  @return The tuple of data values.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function localToData(pt:Point):Array /* of Object */;
    
    /**
     *  Returns an array of HitData of the items of all the underlying 
     *  objects that implement <code>IChartElement2</code> whose dataTips 
     *  are to be shown when <code>showAllDataTips</code> is set 
     *  to <code>true</code> on chart.
     * 
     *  @return The HitData objects describing the data points
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getAllDataPoints():Array /* of HitData */;
    
}

}
