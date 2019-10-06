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

package mx.charts
{

import org.apache.royale.events.Event;
import org.apache.royale.events.EventDispatcher;
import mx.charts.chartClasses.IChartElement;
import mx.core.IFlexDisplayObject;
import mx.core.IInvalidating;
import mx.core.IProgrammaticSkin;
import mx.core.IUIComponent;

/**
 *  A ChartItem represents a single item in a ChartSeries.
 *  In most standard series, there is one ChartItem created
 *  for each item in the series' dataProvider collection.
 *  ChartItems are passed to the instances of a series' itemRenderer
 *  for rendering.  
 *  Most Series types extend ChartItem to contain additional information
 *  specific to the chart type.  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 * 
 *  @royalesuppresspublicvarwarning
 */
public class ChartItem extends EventDispatcher
{
//    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Value that indicates the ChartItem has focus but does not appear to be selected.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const FOCUSED:String = "focused";
    /**
     *  Value that indicates the ChartItem appears selected but does not have focus.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const SELECTED:String = "selected";
    /**
     *  Value that indicates the ChartItem appears to have focus and appears to be selected.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const FOCUSEDSELECTED:String = "focusedSelected";
    /**
     *  Value that indicates the ChartItem appears as if the mouse was over it.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const ROLLOVER:String = "rollOver";
    /**
     *  Value that indicates the ChartItem appears disabled and cannot be selected.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const DISABLED:String = "disabled";
    /**
     *  Value that indicates the ChartItem does not appear to be selected, does not have focus, and is not being rolled over.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const NONE:String = "none";
        
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param element The series or element to which the ChartItem belongs.
     *
     *  @param item The item from the series' data provider
     *  that the ChartItem represents.
     *
     *  @param index The index of the data from the series' data provider
     *  that the ChartItem represents.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function ChartItem(element:IChartElement = null,
                              item:Object = null, index:uint = 0)
    {
        super();

        this.element = element;
        this.item = item;
        this.index = index;
        this._currentState = ChartItem.NONE;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  currentstate
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the currentState property.
     */
    private var _currentState:String = "";
    
    [Inspectable(environment="none")]
    
   /**
     *  Defines the appearance of the ChartItem.
     *  The <code>currentState</code> property can be set to <code>none</code>, <code>rollOver</code>, 
     *  <code>selected</code>, <code>disabled</code>, <code>focusSelected</code>, and <code>focused</code>.
     * 
     *  <P>Setting the state of the item does not add it to the selectedItems Array. It only changes 
     *  the appearance of the chart item. Setting the value of this property also does not trigger a 
     *  <code>change</code> event.</P>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get currentState():String
    {
        return _currentState;
    }

    /**
     *  @private
     */     
    public function set currentState(value:String):void
    {
        if (_currentState != value)
        {
            _currentState = value;
            
            if (itemRenderer && (itemRenderer is IProgrammaticSkin || itemRenderer is IUIComponent))
                (itemRenderer as Object).invalidateDisplayList();   
        }
    }
    
    //----------------------------------
    //  element
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The series or element that owns the ChartItem.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var element:IChartElement;
    
    //----------------------------------
    //  index
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The index of the data from the series' data provider
     *  that the ChartItem represents.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var index:int;
    
    //----------------------------------
    //  item
    //----------------------------------
    
    [Inspectable(environment="none")]

    /**
     *  The item from the series' data provider that the ChartItem represents.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var item:Object;

    //----------------------------------
    //  itemRenderer
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The instance of the chart's itemRenderer
     *  that represents this ChartItem.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var itemRenderer:IFlexDisplayObject;
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Returns a copy of this ChartItem.
     * 
     *  @return A copy of this ChartItem.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function clone():ChartItem
    {       
        var result:ChartItem = new ChartItem(element, item, index);
        result.itemRenderer = itemRenderer;
        return result;
    }
}
    
}
