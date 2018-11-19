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

import mx.core.IUIComponent;
import org.apache.royale.geom.Rectangle;

/**
 *  The IAxis class is an abstract interface for defining label,
 *  tick mark, and data positioning properties for a chart axis.
 *
 *  <p>Classes implement this interface to provide
 *  range definition functionality.</p>
 *
 *  @see mx.charts.CategoryAxis
 *  @see mx.charts.LinearAxis
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IAxisRenderer extends IUIComponent
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  axis
    //----------------------------------

    /**
     *  The axis object associated with this renderer.
     *  This property is managed by the enclosing chart,
     *  and should not be explicitly set.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */ 
    function get axis():IAxis;
    
    /**
     *  @private
     */
    function set axis(value:IAxis):void;
    
    //----------------------------------
    //  gutters
    //----------------------------------

    /**
     *  The distance between the axisRenderer
     *  and the sides of the surrounding chart. 
     *  This property is assigned automatically by the chart,
     *  and should not be assigned directly.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get gutters():Rectangle;
    
    /**
     *  @private
     */
    function set gutters(value:Rectangle):void;
    
    //----------------------------------
    //  heightLimit
    //----------------------------------

    /**
     *  The maximum amount of space, in pixels,
     *  that an axis renderer will take from a chart.
     *  Axis Renderers by default will take up as much space in the chart
     *  as necessary to render all of their labels at full size.
     *  If heightLimit is set, an AxisRenderer will resort to reducing
     *  the labels in size in order to guarantee the total size of the axis
     *  is less than heightLimit.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function set heightLimit(value:Number):void;

    /**
     *  @private
     */
    function get heightLimit():Number;

    //----------------------------------
    //  horizontal
    //----------------------------------

    /**
     *  <code>true</code> if the axis renderer
     *  is being used as a horizontal axis.
     *  This property is managed by the enclosing CartesianChart,
     *  and should not be set directly.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get horizontal():Boolean;
    
    /**
     *  @private
     */
    function set horizontal(value:Boolean):void

    //----------------------------------
    //  minorTicks
    //----------------------------------

    /**
     *  Contains an array that specifies where Flex
     *  draws the minor tick marks along the axis.
     *  Each array element contains a value between 0 and 1. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get minorTicks():Array /* of Number */;

    //----------------------------------
    //  otherAxes
    //----------------------------------

    /**
     *  An Array of axes.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function set otherAxes(value:Array /* of AxisRenderer */):void

    //----------------------------------
    //  placement
    //----------------------------------

    /**
     *  The side of the chart the axisRenderer will appear on.
     *  Legal values are <code>"left"</code> and <code>"right"</code>
     *  for vertical axis renderers and <code>"top"</code>
     *  and <code>"bottom"</code> for horizontal axis renderers.
     *  By default, primary axes are placed on the left and top,
     *  and secondary axes are placed on the right and bottom.
     *  CartesianCharts automatically guarantee that secondary axes
     *  are placed opposite primary axes; if you explicitly place
     *  a primary vertical axis on the right, for example,
     *  the secondary vertical axis is swapped to the left.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get placement():String;
    
    /**
     *  @private
     */
    function set placement(value:String):void;

    //----------------------------------
    //  ticks
    //----------------------------------

    /**
     *  Contains an array that specifies where Flex
     *  draws the tick marks along the axis.
     *  Each array element contains a value between 0 and 1. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get ticks():Array /* of Number */;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Adjusts its layout to accomodate the gutters passed in.
     *  This method is called by the enclosing chart to determine
     *  the size of the gutters and the corresponding data area.
     *  This method provides the AxisRenderer with an opportunity
     *  to calculate layout based on the new gutters,
     *  and to adjust them if necessary.
     *  If a given gutter is adjustable, an axis renderer
     *  can optionally adjust the gutters inward (make the gutter larger)
     *  but not outward (make the gutter smaller).
     *
     *  @param workingGutters Defines the gutters to adjust.
     *
     *  @param adjustable Consists of four Boolean properties
     *  (left=true/false, top=true/false, right=true/false,
     *  and bottom=true/false) that indicate whether the axis renderer
     *  can optionally adjust each of the gutters further.
     *  
     *  @return A rectangle that defines the dimensions of the gutters, including the 
     *  adjustments.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function adjustGutters(workingGutters:Rectangle,
                           adjustable:Object):Rectangle;

    /**
     *  Called by the enclosing chart to indicate that the current state
     *  of the chart has changed.
     *  Implementing elements should respond to this method
     *  in order to synchronize changes to the data displayed by the element.
     * 
     *  @param oldState An integer representing the previous state.
     *
     *  @param v An integer representing the new state.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function chartStateChanged(oldState:uint,v:uint):void;
}

}
