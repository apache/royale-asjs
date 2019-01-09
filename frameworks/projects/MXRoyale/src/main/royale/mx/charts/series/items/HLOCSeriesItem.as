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

import mx.charts.ChartItem;
import mx.charts.chartClasses.HLOCSeriesBase;
import mx.graphics.IFill;

/**
 *  Represents the information required to render an item as part of a HLOCSeries.  The HLOCSeries class passes these items to its itemRenderer when rendering.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 * 
 *  @royalesuppresspublicvarwarning
 */
public class HLOCSeriesItem extends ChartItem
{
//    include "../../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *  @param  element The owning series.
     *  @param  data    The item from the dataProvider that this ChartItem represents.
     *  @param  index   The index of the item from the series's dataProvider.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function HLOCSeriesItem(element:HLOCSeriesBase = null,
                                   data:Object = null, index:uint = 0)
    {
        super(element, data, index);
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  close
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The close value of this item converted into screen coordinates.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var close:Number;
    
    //----------------------------------
    //  closeFilter
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The close value of this item, filtered against the vertical axis of the containing chart. This value is <code>NaN</code> if the value lies outside the axis's range.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var closeFilter:Number;

    //----------------------------------
    //  closeNumber
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The close value of this item, converted to a number by the vertical axis of the containing chart.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var closeNumber:Number;

    //----------------------------------
    //  closeValue
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The close value of this item.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var closeValue:Object;

    //---------------------------------
    //  fill
    //---------------------------------
    [Inspectable(environment="none")]
    
    /**
     * Holds fill color of the item.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var fill:IFill;
    
    //----------------------------------
    //  high
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The high value of this item converted into screen coordinates.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var high:Number;
    
    //----------------------------------
    //  highFilter
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The high value of this item, filtered against the vertical axis of the containing chart. This value is <code>NaN</code> if the value lies outside the axis's range.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var highFilter:Number;

    //----------------------------------
    //  highNumber
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The high value of this item, converted to a number by the vertical axis of the containing chart.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var highNumber:Number;

    //----------------------------------
    //  highValue
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The high value of this item.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var highValue:Object;

    //----------------------------------
    //  low
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The low value of this item converted into screen coordinates.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var low:Number;

    //----------------------------------
    //  lowFilter
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The low value of this item, filtered against the vertical axis of the containing chart. This value is <code>NaN</code> if the value lies outside the axis's range.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var lowFilter:Number;

    //----------------------------------
    //  lowNumber
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The low value of this item, converted to a number by the vertical axis of the containing chart.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var lowNumber:Number;

    //----------------------------------
    //  lowValue
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The low value of this item.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var lowValue:Object;

    //----------------------------------
    //  open
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The open value of this item converted into screen coordinates.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var open:Number;

    //----------------------------------
    //  openFilter
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The open value of this item, filtered against the vertical axis of the containing chart. This value is <code>NaN</code> if the value lies outside the axis's range.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var openFilter:Number;

    //----------------------------------
    //  openNumber
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The open value of this item, converted to a number by the vertical axis of the containing chart.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var openNumber:Number;

    //----------------------------------
    //  openValue
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The open value of this item.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var openValue:Object;

    //----------------------------------
    //  x
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The x value of this item converted into screen coordinates.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var x:Number;
    
    //----------------------------------
    //  xFilter
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The x value of this item, filtered against the horizontal axis of the containing chart. This value is <code>NaN</code> if the value lies outside the axis's range.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var xFilter:Number;

    //----------------------------------
    //  xNumber
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The x value of this item, converted to a number by the horizontal axis of the containing chart.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var xNumber:Number;

    //----------------------------------
    //  xValue
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The x value of this item.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var xValue:Object;

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Returns a copy of this ChartItem.
     */
    override public function clone():ChartItem
    {       
        var result:HLOCSeriesItem = new HLOCSeriesItem(HLOCSeriesBase(element),item,index);
        result.itemRenderer = itemRenderer;
        return result;
    }
    
}

}