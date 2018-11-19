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

import org.apache.royale.events.IEventDispatcher;
import mx.charts.AxisLabel;

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
public interface IAxis extends IEventDispatcher
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  baseline
    //----------------------------------

    /**
     *  The baseline position for the axis.
     *  Some series, such as ColumnSeries or AreaSeries, use this value to
     *  define the base of a filled region when no minimum value is specified.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get baseline():Number;
    
    //----------------------------------
    //  chartDataProvider
    //----------------------------------

    /**
     *  The data provider assigned to the enclosing chart.
     *  Axis types that are data provider-based can choose to inherit
     *  the data provider associated with the enclosing chart.
     *  If an axis is shared among multiple charts,
     *  the value of this property is <code>undefined</code>
     *  (most likely it will be the last data provider assigned
     *  to one of the associated charts).
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function set chartDataProvider(value:Object):void;
    
    //----------------------------------
    //  name
    //----------------------------------

    /** 
     *  The name of the axis.
     *  If set, Flex uses this name to format DataTip controls.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get displayName():String;

    //----------------------------------
    //  title
    //----------------------------------

    /**
     *  The text for the title displayed along the axis.  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get title():String;

    //----------------------------------
    //  unitSize
    //----------------------------------

    /**
     *  The size of one unit of data as represented by this axis.
     *  This value is used by various series types to help in rendering.
     *  The ColumnSeries class, for example, uses this value
     *  to determine how wide columns should be rendered.
     *  Different axis types return different values,
     *  sometimes dependent on the data being represented.
     *  The DateTimeAxis class, for example, might return the number
     *  of milliseconds in a day, or a year, depending on the data
     *  that is rendered in the chart.
     *  Because this value is dependant on collecting the represented data,
     *  custom series cannot assume this value is accurate in their
     *  <code>updateData()</code> or <code>updateMapping()</code> methods. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get unitSize():Number
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Data conversion
    //
    //--------------------------------------------------------------------------

    /**
     *  Converts a set of values of arbitrary type
     *  to a set of numbers that can be transformed into screen coordinates.
     *
     *  @param cache An Array of objects where converted values
     *  are read from and stored.
     *
     *  @param field The field of the objects in the cache Array
     *  containing the pre-converted values.
     *
     *  @param convertedField The field of the objects in the cache Array
     *  where converted values should be stored.
     *
     *  @param indexValues This parameter is <code>true</code> if the values being mapped
     *  are index values, and <code>false</code> if they are natural data values.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function mapCache(cache:Array /* of Object */, field:String, convertedField:String,
                      indexValues:Boolean = false):void
    
    /**
     *  Filters a set of values of arbitrary type
     *  to a set of numbers that can be mapped.
     *
     *  @param cache An Array of objects where converted values
     *  are read from and stored.
     *
     *  @param field The field of the objects in the cache Array
     *  containing the pre-filtered values.
     *
     *  @param convertedField The field of the objects in the cache Array
     *  where filtered values should be stored.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function filterCache(cache:Array /* of Object */, field:String,
                         filteredString:String):void;
    
    /**
     *  Maps a set of values from data space to screen space.
     *
     *  @param cache An Array of objects where mapped values
     *  are read from and stored.
     *
     *  @param field The field of the objects in the cache Array
     *  containing the pre-mapped values.
     *
     *  @param convertedField The field of the objects in the cache Array
     *  where mapped values should be stored.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function transformCache(cache:Array /* of Object */, field:String,
                            convertedField:String):void;

    //--------------------------------------------------------------------------
    //
    //  Methods: Data inversion
    //
    //--------------------------------------------------------------------------

    /**
     *  Maps a position along the axis back to a numeric data value.
     *
     *  @param value The bound of the axis.
     *  This parameter should be between 0 and 1,
     *  with 0 representing the minimum bound of the axis, and 1 the maximum.
     * 
     *  @return An object containing the transformed value.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function invertTransform(value:Number):Object;

    /**
     *  Formats values for display in DataTips.
     *  Returns a user-readable string.
     *
     *  @param value The value to convert to a String. 
     *  
     *  @return The text of the DataTip.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function formatForScreen(value:Object):String   

    //--------------------------------------------------------------------------
    //
    //  Methods: Label management
    //
    //--------------------------------------------------------------------------
        
    /**
     *  Determines the range to estimate what the axis labels should be. 
     *  The axis almost immediately calls the <code>getLabels()</code> method
     *  to get the real values.
     *  The axis uses the estimated values to adjust chart margins,
     *  so any difference between the estimated labels and  actual labels
     *  (returned from the <code>getLabels()</code> method) results in scaling
     *  the labels to fit.
     *
     *  <p>An axis need only return the minimum and maximum labels
     *  when returning an estimate.
     *  If the label set is fairly static, without depending on the size
     *  of the axis being rendered on screen, an axis can return the entire
     *  label set from this function, and mark the estimate as accurate.</p>
     *  
     *  @return An Array of AxisLabel objects.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getLabelEstimate():AxisLabelSet;

    /** 
     *  Determines how the axis handles overlapping labels. 
     *  Typically, numeric ranges return <code>true</code>,
     *  while discrete value-based ranges do not.
     *  You can can override this property by setting it directly on the axis.
     *
     *  @return <code>true</code> if labels can be dropped without loss of data;
     *  otherwise, <code>false</code>. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function preferDropLabels():Boolean;
    
    /**
     *  Gets the labels text that is rendered.
     *  When Flex calls this method, 
     *  the axis has already determined the minimum length of the label.
     *  
     *  @param minimumAxisLength The minimum length of the axis, in pixels.
     *  The axis can be longer than this value, but not shorter.
     *  
     *  @return An array of AxisLabel objects.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getLabels(minimumAxisLength:Number):AxisLabelSet;

    /**
     *  Invoked when an AxisRenderer is unable to cleanly render
     *  the labels without overlap, and would like the Axis object
     *  to reduce the set of labels.
     *  The method is passed the two labels that are overlapping.
     *
     *  @param intervalStart The start of the interval where labels overlap.
     *
     *  @param intervalEnd The end of the interval where labels overlap.
     *
     *  @return A new label set that resolves the overlap by reducing
     *  the number of labels.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function reduceLabels(intervalStart:AxisLabel,
                          intervalEnd:AxisLabel):AxisLabelSet;

    //--------------------------------------------------------------------------
    //
    //  Methods: Notification
    //
    //--------------------------------------------------------------------------

    /**
     *  Each DataTransform that makes use of an axis
     *  registers itself with that axis.
     *  The axis is responsible for informing the transform
     *  when its relevant values have changed.
     *  It should also request values from the transform
     *  when it wants to autogenerate minimum and maximum values.
     *
     *  @param transform The DataTransform to register.
     *
     *  @param dimensionName The name of the dimension.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function registerDataTransform(transform:DataTransform,
                                   dimensionName:String):void;
    
    /**
     *  Each DataTransform that makes use of an axis
     *  registers itself with that axis.
     *  The axis is responsible for informing the transform
     *  when its relevant values have changed.
     *  It should also request values from the transform
     *  when it wants to autogenerate minimum and maximum values.
     *
     *  @param transform The DataTransform to unregister.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function unregisterDataTransform(transform:DataTransform):void;

    /** 
     *  Triggers events that inform the range object
     *  when the chart data has changed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function dataChanged():void;

    /**
     *  Updates the chart.
     *  This can be called multiple times per frame. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function update():void;
}

}
