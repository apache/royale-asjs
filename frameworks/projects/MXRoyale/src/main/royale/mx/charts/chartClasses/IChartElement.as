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

import mx.core.UIComponent;
import org.apache.royale.geom.Rectangle;
import mx.core.IFlexDisplayObject;

/**
 *  IChartElement defines the base set of properties and methods
 *  required by a UIComponent to be representable in the data space of a chart.
 *  Any component assigned to the series, backgroundElements,
 *  or annotationElements Arrays of a chart must implement this interface.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IChartElement extends IFlexDisplayObject
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  chartDataProvider
    //----------------------------------

    /**
     *  The data provider assigned to the enclosing chart.
     *  Element types can choose to inherit the data provider
     *  from the enclosing chart if necessary, or allow developers
     *  to assign data providers specifically to the element.
     *  Not all elements are necessarily driven by a data provider.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function set chartDataProvider(value:Object):void;
    
    //----------------------------------
    //  dataTransform
    //----------------------------------

    /**
     *  The DataTransform object that the element uses
     *  to map between data and screen coordinates.
     *  This property is assigned by the enclosing chart.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function set dataTransform(value:DataTransform):void;

    //----------------------------------
    //  labelContainer
    //----------------------------------

    /**
     *  The DisplayObject that displays labels rendered by this element.
     *  In most cases, labels displayed in the data area of a chart
     *  are rendered on top of all elements
     *  rather than interleaved with the  data.
     *  If an implementing Element has labels to display,
     *  it can place them in a Sprite object
     *  and return it as the value of the <code>labelContainer</code> property.
     *  Enclosing charts will render labelContainers
     *  from  all enclosed elements and place them
     *  in the data area above all other elements.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get labelContainer():UIComponent;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Called by the governing DataTransform to obtain a description
     *  of the data represented by this IChartElement.
     *  Implementors fill out and return an Array of
     *  mx.charts.chartClasses.DataDescription objects
     *  to guarantee that their data is correctly accounted for
     *  by any axes that are autogenerating values
     *  from the displayed data (such as minimum, maximum,
     *  interval, and unitSize).
     *  Most element types return an Array
     *  containing a single DataDescription.
     *  Aggregate elements, such as BarSet and ColumnSet,
     *  might return multiple DataDescription instances
     *  that describe the data displayed by their subelements.
     *  When called, the implementor describes the data
     *  along the axis indicated by the <code>dimension</code> argument.
     *  This function might be called for each axis
     *  supported by the containing chart.
     * 
     *  @param dimension Determines the axis to get data descriptions of.
     *
     *  @param requiredFields A bitfield that indicates which values
     *  of the DataDescription object the particular axis cares about.
     *  Implementors can optimize by only calculating the necessary fields.
     *  
     *  @return An Array containing the DataDescription instances that describe
     *  the data that is displayed.
     *  
     *  @see mx.charts.chartClasses.DataDescription
     *  @see mx.charts.chartClasses.DataTransform
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function describeData(dimension:String, requiredFields:uint):Array /* of DataDescription */;
    
    /**
     *  Returns a HitData object describing the nearest data point
     *  to the coordinates passed to the method.
     *  The <code>x</code> and <code>y</code> arguments
     *  should be values in the Element's coordinate system.
     *  This method aheres to the limits specified by the
     *  <code>sensitivity2</code> parameter
     *  when looking for nearby data points.
     *
     *  @param x The x coordinate relative to the ChartBase object.
     *
     *  @param y The y coordinate relative to the ChartBase object.
     *  
     *  @param sensitivity2 The maximum distance from the data point that the
     *  x/y coordinate location can be.
     *
     *  @return A HitData object describing the nearest data point
     *  within <code>sensitivity2</code> pixels.
     *
     *  @see mx.charts.HitData
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function findDataPoints(x:Number, y:Number,sensitivity2:Number):Array /* of HitData */;

    /**
     *  Indicates to the element that the data mapping
     *  of the associated axes has changed.
     *  Implementors should dispose of cached data
     *  and re-render appropriately.
     *  This function is called automatically
     *  by the associated DataTransform when necessary.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function mappingChanged():void;

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

    /**
     *  Called by the enclosing chart to collect any transitions
     *  a particular element might play when the chart changes state.
     *  The chart collects transitions from all elements
     *  and ensures that they play in parallel.
     *  It waits until all transitions have completed
     *  before advancing to another state.
     *  Implementors should append any necessary transitions
     *  to the transitions Array parameter.
     * 
     *  @param chartState The state at which the chart plays
     *  the new transitions.
     *
     *  @param transitions An Array of transition to add
     *  to the chart's list of transitions to play.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function collectTransitions(chartState:Number,transitions:Array /* of IEffectInstance */):void;

    /**
     *  Called by the chart to allow associated elements
     *  to claim style selectors from its chartSeriesStyles Array.
     *  Each chart has an associated set of selectors that are 
     *  implicitly assigned to contained elements that require them.
     *  Implementing this function gives an element a chance to 'claim'
     *  elements out of that set, as necessary.
     *  An element that requires <i>N</i> style selectors claims the values
     *  from <code>styles[firstAvailable]</code> to
     *  <code>styles[firstAvailable + <i>N</i> - 1]</code>.
     *
     *  @param styles An Array of styles to claim.
     *
     *  @param firstAvailable The first style selector in the Array to claim.
     *  
     *  @return The new value for <code>firstAvailable</code>
     *  after claiming any styles (for example,
     *  <code>firstAvailable</code> + <i>N</i>).
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function claimStyles(styles:Array /* of Object */,firstAvailable:uint):uint;
}

}
