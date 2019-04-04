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

import org.apache.royale.events.Event;
import org.apache.royale.events.EventDispatcher;

import mx.charts.ChartItem;
import mx.core.mx_internal;

use namespace mx_internal;

/**
 *  The AxisBase class serves as a base class
 *  for the various axis types supported in Flex. 
 *
 *  @mxml
 *  
 *  <p>Flex components inherit the following properties
 *  from the AxisBase class:</p>
 * 
 *  <pre>
 *  &lt;mx:<i>tagname</i>
 *    displayName="<i>No default</i>"
 *    title="<i>No default</i>"
 *  &gt;
 *  </pre>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class AxisBase extends EventDispatcher
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
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function AxisBase()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    protected var _transforms:Array /* of Object */ = [];
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  chartDataProvider
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  @copy mx.charts.chartClasses.IAxis#chartDataProvider
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function set chartDataProvider(value:Object):void
    {
    }

    //----------------------------------
    //  displayName
    //----------------------------------

    /**
     *  @private
     *  Storage for the name property.
     */
    private var _displayName:String = "";

    [Inspectable(category="Display")]

    /**
     *  @copy mx.charts.chartClasses.IAxis#displayName
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get displayName():String
    {
        return _displayName;
    }
    
    /**
     *  @private
     */
    public function set displayName(value:String):void
    {
        _displayName = value;
    }
    
    //----------------------------------
    //  title
    //----------------------------------

    /**
     *  @private
     *  Storage for the title property.
     */
    private var _title:String = "";

    [Inspectable(category="General")]
    
    /**
     *  @copy mx.charts.chartClasses.IAxis#title
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get title():String
    {
        return _title;
    }
    
    /**
     *  @private
     */
    public function set title(value:String):void
    {
        dispatchEvent(new Event("titleChange"));

        _title = value;
    }

    //----------------------------------
    //  unitSize
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  @copy mx.charts.chartClasses.IAxis#unitSize
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get unitSize():Number
    {
        return 1;
    }
    
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
     *  @param requiredFields A bitfield that indicates which values
     *  of the DataDescription object the particular axis cares about.
     *  Implementors can optimize by only calculating the necessary fields.
     *
     *  @return An Array of BoundedValue objects containing the DataDescription instances that describe
     *  the data that is displayed.
     *
     *  @see mx.charts.chartClasses.BoundedValue
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function describeData(requiredFields:uint):Array /* of BoundedValue */
    {
        var result:Array /* of BoundedValue */ = [];
        var n:int  = _transforms.length;
        
        for (var i:int = 0; i < n; i++)
        {
            result = result.concat(
                _transforms[i].transform.describeData(
                    _transforms[i].dimension, requiredFields));
        }
        
        return result;
    }

    /**
     *  @copy mx.charts.chartClasses.IAxis#registerDataTransform()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function registerDataTransform(transform:DataTransform,
                                          dimensionName:String):void
    {
        _transforms.push({ transform:transform, dimension: dimensionName });
        
        dataChanged();
    }
    
    /**
     *  @copy mx.charts.chartClasses.IAxis#unregisterDataTransform()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function unregisterDataTransform(transform:DataTransform):void
    {
        var n:int = _transforms.length;
        for (var i:int = 0; i < n; i++)
        {
            if (_transforms[i].transform == transform)
            {
                _transforms.splice(i, 1);
                break;
            }
        }

        dataChanged();
    }
    
    /**
     *  @copy mx.charts.chartClasses.IAxis#dataChanged()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function dataChanged():void
    {
    }
    
    mx_internal function highlightElements(highlight:Boolean):void
    {
        var elements:Array /* of ChartElement */ = [];
        
        var n:int = _transforms.length;
        for (var i:int = 0; i < n; i++)
        {
            elements = elements.concat(_transforms[i].transform.elements);
        }
            
        if (highlight)
        {
            n = elements.length;
            for (i = 0; i < n; i++)
            {
                if (elements[i] is Series)
                    Series(elements[i]).setItemsState(ChartItem.ROLLOVER);
            }
        }
        else // reset the selection - to give the same visual behavior.
        {
            n = elements.length;
            for (i = 0; i < n; i++)
            {
                if (elements[i] is Series)
                {
                    if (elements[i].getChartSelectedStatus() == false)
                        elements[i].setItemsState(ChartItem.NONE)
                    else if (elements[i].selectedItems.length == 0)
                        elements[i].setItemsState(ChartItem.DISABLED);
                    else 
                        Series(elements[i]).selectedItems = elements[i].selectedItems;
                }
            }
        }
    }
}

}
