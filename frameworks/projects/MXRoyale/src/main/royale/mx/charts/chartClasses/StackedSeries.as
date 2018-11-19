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

import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;

import mx.charts.ChartItem;
import mx.charts.HitData;
import mx.core.IUIComponent;
import mx.core.UIComponent;
import mx.core.mx_internal;

use namespace mx_internal;

/**
 *  Stacked Series serves as the common base class
 *  for all of the stacking set series (BarSet, ColumnSet, and AreaSet).
 *  A StackedSeries accepts an Array of sub-series elements and does
 *  the appropriate calculations to stack them vertically so that each series
 *  renders the sum of the previous series's data plus its own value.
 *  This class is not intended for direct use.  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class StackedSeries extends Series
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
    public function StackedSeries()
    {
        super();

        dataTransform = new CartesianTransform();
        
        invalidateProperties();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var _seriesDirty:Boolean = true;

    /**
     *  The summed totals of the stacked positive values.
     *  This property contains a Dictionary whose keys are the values
     *  represented by the child series along the primary axis
     *  (for example, x axis values for a ColumnSeries, y axis values for a BarSeries),
     *  and whose values are the summed total of all the positive child series values
     *  at that key.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var posTotalsByPrimaryAxis:Object;
    
    /**
     *  The summed totals of the stacked negative values.
     *  This property contains a Dictionary whose keys are the values
     *  represented by the child series along the primary axis
     *  (for example, x axis values for a ColumnSeries, y axis values for a BarSeries),
     *  and whose values are the summed total of all the negative child series values
     *  at that key.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var negTotalsByPrimaryAxis:Object;

    /**
     *  The maximum sum represented by this stacked series.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var stackedMaximum:Number;
    
    /**
     *  The minimum sum represented by this stacked series.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var stackedMinimum:Number;
    
    /**
     *  @private
     */
    private var stackingDirty:Boolean = true;
    
    /**
     *  @private
     */ 
    private var _bAxesDirty:Boolean = false;
    
    
    //--------------------------------------------------------------------------
    //
    //  Overridden properties: ChartElement
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  workingDataProvider
    //----------------------------------

    /**
     *  @private
     */
    override protected function processNewDataProvider(value:Object):void
    {
        super.processNewDataProvider(value);

        var n:int = _series.length;
        for (var i:int = 0; i < n; i++)
        {
            IChartElement(_series[i]).chartDataProvider = dataProvider;         
        }
    }

    //--------------------------------------------------------
    //
    // Properties
    //
    //--------------------------------------------------------
    
    //----------------------------------
    //  allowNegativeForStacked
    //----------------------------------

    /**
     *  @private
     *  Storage for the allowNegativeForStacked property.
     */
    private var _allowNegativeForStacked:Boolean = false;  
    
    [Inspectable]

    /**
     *  Setting this property to true will stack positive
     *  and negative values separately
     * 
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get allowNegativeForStacked():Boolean
    {
        return _allowNegativeForStacked;
    }

    /**
     *  @private
     */
    public function set allowNegativeForStacked(value:Boolean):void
    {
        invalidateStacking();
        invalidateSeries();
        
        _allowNegativeForStacked = value;
    }
    
    //----------------------------------
    //  horizontalAxis
    //----------------------------------

    /**
     *  @private
     *  Storage for the horizontalAxis property.
     */
    private var _horizontalAxis:IAxis;
    
    [Inspectable(category="Data")]

    /**
     *  Defines the labels, tick marks, and data position
     *  for items on the x-axis.
     *  Use either the LinearAxis class or the CategoryAxis class
     *  to set the properties of the horizontalAxis as a child tag in MXML
     *  or create a LinearAxis or CategoryAxis object in ActionScript.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get horizontalAxis():IAxis
    {
        return _horizontalAxis;
    }
    
    /**
     *  @private
     */
    public function set horizontalAxis(value:IAxis):void
    {
        _horizontalAxis = value;
        _bAxesDirty = true;

        invalidateData();
        invalidateProperties();
    }    
    
    //----------------------------------
    //  series
    //----------------------------------

    /**
     *  @private
     *  Storage for the series property.
     */
    private var _series:Array = [];
    
    [Inspectable]

    /**
     *  An array of sub-series managed by this stacking set.
     *  These series are rendered according to the stacking behavior
     *  of this stacking set as defined by the value
     *  of the <code>type</code> property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get series():Array
    {
        return _series;
    }

    /**
     *  @private
     */
    public function set series(value:Array):void
    {
        _series = value == null ? [] : value;

        invalidateSeries();

        var s:ChartBase = chart;
        if (s)
            s.invalidateSeriesStyles();
    }

    //----------------------------------
    //  type
    //----------------------------------

    /**
     *  @private
     *  Storage for the type property.
     */
    private var _type:String;   
    
    [Inspectable]

    /**
     *  The grouping behavior of this series.
     *  All stacking series support <code>"overlaid"</code>,
     *  <code>"stacked"</code>, and <code>"100%"</code>.
     *  When the <code>type</code> property is <code>"overlaid"</code>,
     *  all sub-series are rendererd normally, with no special behavior applied.
     *  When the <code>type</code> property is <code>"stacked"</code>,
     *  each sub-series is rendered as the sum of its data
     *  plus the values of all previous series.
     *  When the <code>type</code> property is <code>"100%"</code>,
     *  each sub-series is rendered as its portion of the total sum
     *  of all series.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get type():String
    {
        return _type;
    }

    /**
     *  @private
     */
    public function set type(value:String):void
    {
        invalidateStacking();
        invalidateSeries();
        
        _type = value;
    }

    //----------------------------------
    //  verticalAxis
    //----------------------------------

    /**
     *  @private
     *  Storage for the verticalAxis property.
     */
    private var _verticalAxis:IAxis;

    [Inspectable(category="Data")]

    /**
     *  Defines the labels, tick marks, and data position
     *  for items on the y-axis.
     *  Use either the LinearAxis class or the CategoryAxis class
     *  to set the properties of the horizontalAxis as a child tag in MXML
     *  or create a LinearAxis or CategoryAxis object in ActionScript.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get verticalAxis():IAxis
    {
        return _verticalAxis;
    }
    
    /**
     *  @private
     */
    public function set verticalAxis(value:IAxis):void
    {
        _verticalAxis = value;
        _bAxesDirty = true;

        invalidateData();
        //invalidateChildOrder();
        invalidateProperties();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();

        updateStacking();

        if (_seriesDirty)
        {
            _seriesDirty = false;
            buildSubSeries();
        }
        
        if (_bAxesDirty)
        {
            if (dataTransform)
            {
                if (_horizontalAxis)
                {
                    _horizontalAxis.chartDataProvider = dataProvider;
                    CartesianTransform(dataTransform).setAxis(
                        CartesianTransform.HORIZONTAL_AXIS,_horizontalAxis);
                }
                
                if (_verticalAxis)
                {
                    _verticalAxis.chartDataProvider = dataProvider;
                    CartesianTransform(dataTransform).setAxis(
                        CartesianTransform.VERTICAL_AXIS, _verticalAxis);
                }
            }
            _bAxesDirty = false; 
        }
        
        var parentChart:Object = chart;
        if (parentChart && parentChart is CartesianChart)
        {
            var c:CartesianChart = CartesianChart(parentChart);
            if (!_horizontalAxis)
            {
                if (dataTransform.axes[CartesianTransform.HORIZONTAL_AXIS] != c.horizontalAxis)
                        CartesianTransform(dataTransform).setAxis(
                            CartesianTransform.HORIZONTAL_AXIS,c.horizontalAxis);
            }
                            
            if (!_verticalAxis)
            {
                if (dataTransform.axes[CartesianTransform.VERTICAL_AXIS] != c.verticalAxis)
                        CartesianTransform(dataTransform).setAxis(
                            CartesianTransform.VERTICAL_AXIS, c.verticalAxis);
            }
        }
        dataTransform.elements = [this];
    }
    
    /**
     *  @private
     */
    override public function dataToLocal(... dataValues):Point
    {
        var data:Object = {};
        var da:Array = [ data ];
        var n:int = dataValues.length;
        
        if (n > 0)
        {
            data["d0"] = dataValues[0];
            dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).
                mapCache(da, "d0", "v0");
        }
        
        if (n > 1)
        {
            data["d1"] = dataValues[1];
            dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).
                mapCache(da, "d1", "v1");           
        }

        dataTransform.transformCache(da,"v0","s0","v1","s1");
        
        return new Point(data.s0 + this.x,
                         data.s1 + this.y);
    }

    /**
     *  @private
     */
    override public function localToData(v:Point):Array
    {
        var values:Array = dataTransform.invertTransform(
                                            v.x - this.x,
                                            v.y - this.y);
        return values;
    }   

    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        var n:int = numChildren;
        for (var i:int = 0; i < n; i++)
        {
            IUIComponent(getChildAt(i)).setActualSize(unscaledWidth,
                                                     unscaledHeight);
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: ChartElement
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override public function describeData(dimension:String,
                                          requiredFields:uint):Array
    {
        updateStacking();
        validateData();
        
        var desc:DataDescription;
        var result:Array = [];
        var n:int;
        var i:int;
        
        if (type == "100%")
        {
            if (dimension == CartesianTransform.VERTICAL_AXIS)
            {
                desc = new DataDescription();
                desc.min = 0;
                desc.max = 100;
                result = [ desc ];
            }
            else
            {
                n = series.length;
                for (i = 0; i < n; i++)
                {
                    result = result.concat(
                        series[i].describeData(dimension, requiredFields));
                }
            }
        }

        else if (type == "stacked")
        {
            if (dimension == CartesianTransform.VERTICAL_AXIS)
            {
                var vCache:Array = [{ value: stackedMinimum}, { value: stackedMaximum }];
                dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).
                    mapCache(vCache, "value", "number");
                desc = new DataDescription();
                desc.min = vCache[0].number;
                desc.max = vCache[1].number;            
                result = [ desc ];
            }
            else
            {
                n = series.length;
                for (i = 0; i < n; i++)
                {
                    result = result.concat(
                        series[i].describeData(dimension, requiredFields));
                }
            }
        }

        else
        {
            n = series.length;
            for (i = 0; i < n; i++)
            {
                result = result.concat(
                    series[i].describeData(dimension, requiredFields));
            }
        }

        return result;      
    }

    /**
     *  @private
     */
    override public function findDataPoints(x:Number, y:Number,
                                            sensitivity:Number):Array
    {
        var hds:Array = super.findDataPoints(x, y, sensitivity);
        
        var n:int = hds.length;
        if (n > 0 && (_type == "stacked" || _type == "100%"))
        {
            for (var i:int = 0; i < n; i++)
            {
                hds[i].dataTipFunction = formatDataTip; 
            }
        }

        return hds;
    }
    /**
     *  @private
     */
    override public function getAllDataPoints():Array
    {
        var hds:Array = super.getAllDataPoints();
        
        var n:int = hds.length;
        if (n > 0 && (_type == "stacked" || _type == "100%"))
        {
            for (var i:int = 0; i < n; i++)
            {
                hds[i].dataTipFunction = formatDataTip; 
            }
        }

        return hds;
    }

    /**
     *  @private
     */
    override public function chartStateChanged(oldState:uint, v:uint):void
    {
        updateData();

        super.chartStateChanged(oldState,v);
    }
    
    /**
     *  @private
     */
    override public function mappingChanged():void
    {
        var n:int = numChildren;
        for (var i:int = 0; i < n; i++)
        {
            var c:IChartElement = getChildAt(i) as IChartElement;
            if (c)
                c.mappingChanged();
        }

        super.mappingChanged();
    }

    /**
     *  @private
     */
    override public function claimStyles(styles:Array,
                                         firstAvailable:uint):uint
    {
        var n:int = _series.length;
        for (var i:int = 0; i < n; i++)
        {
            var c:IChartElement = _series[i];
            firstAvailable = c.claimStyles(styles, firstAvailable);
        }

        return firstAvailable;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: Series
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    override mx_internal function clearSeriesItemsState(clear:Boolean, state:String = ChartItem.NONE):void
    {
        super.clearSeriesItemsState(clear,state);
        var s:Series;
        var j:int;
        for (j = 0; j < series.length; j++)
        {
            s = series[j];
            s.clearSeriesItemsState(clear,state);
        }
    } 

    /**
     *  @private
     */
    override public function get legendData():Array
    {
        var keyItems:Array = [];
        
        var n:int = _series.length;
        for (var i:int = 0; i < n; i++)
        {
            var ld:Object = _series[i].legendData;
            if (ld)
                keyItems = keyItems.concat(ld);
        }
        
        return keyItems;
    }
    
    /**
     *  @private
     */
    override public function getItemsInRegion(r:Rectangle):Array
    {
        var j:int;
        var arrItems:Array;
        var arrAllItems:Array = [];
        var s:Series;
                
        for (j = 0; j < series.length; j++)
        {
            s = series[j];
            arrItems = s.getItemsInRegion(r);
            arrAllItems = arrAllItems.concat(arrItems);
        }
        return arrAllItems;
    }
        
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Call this method to trigger a call to the <code>buildSubSeries()</code>
     *  method on the next call to the <code>commitProperties()</code> method.  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function invalidateSeries():void
    {
        if (_seriesDirty == false)
        {
            _seriesDirty = true;

            invalidateProperties();
        }
    }
    
    /**
     *  Call this method to trigger a regeneration of the stacked values
     *  on the next call to the <code>commitProperties()</code> method.  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function invalidateStacking():void
    {
        if (stackingDirty == false)
        {
            stackingDirty = true;

            invalidateProperties();                 
        }
    }

    /** 
     *  Applies any customization to a sub-series
     *  when building the stacking behavior.
     *  By default, this method assigns the inherited data providers
     *  to the sub-series.
     *  Derived classes can override this method
     *  to apply further customization.
     *  
     *  @param g The chart element to customize.
     *  
     *  @param i The sub-series' position in the series array.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function customizeSeries(g:IChartElement, i:uint):void
    {
        g.chartDataProvider = dataProvider;         
    }

    /**
     *  Processes the Array of sub-series for display, when necessary.
     *  This method ensures that all sub-series are added as children of this
     *  stacking set, and applies any per-series customization that is necessary
     *  (for example, assigning inherited data providers or clustering properties).
     *  <p>This method is also responsible for informing the chart that series
     *  have changed and, as a result, implicit series styles must be reassigned.
     *  This method is called automatically by the stacking set, when necessary.
     *  Instead of calling this method directly,
     *  you should consider calling the <code>invalidateSeries()</code> method.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */     
    protected function buildSubSeries():void
    {
        while (numChildren > 0)
        {
            removeChildAt(0);
        }

        for (var i:int = _series.length - 1; i >= 0; i--)
        {
            var g:IChartElement = IChartElement(_series[i]);
            customizeSeries(g, i);
            addChild(g as UIComponent);
        }

        var s:ChartBase = chart;
        if (s)  
            s.invalidateSeriesStyles();
    }

    /**
     *  Iterates over the individual sub-series to build the stacked values.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function updateStacking():void
    {
        if (stackingDirty == false)
            return;
        
        var stacker:StackedSeries = null;
        
        if (!_series)
            return;

        if (_type == "stacked" || _type == "100%")
            stacker = this;

        var n:int = _series.length;
        for (var i:int = 0; i < n; i++) 
        {
            if (_series[i] is IStackable)
                _series[i].stacker = stacker;   
        }

        if (_type == "stacked" || _type == "100%")
            stack();
            
        stackingDirty = false;
    }

    /**
     *  Updates the series data, and uses the values of the series data
     *  it is stacking on top of so it can stack correctly.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function stack():void
    {
        var n:int = _series.length;
        var i:int;
        var series:IStackable2;
        var obj:Object;

        posTotalsByPrimaryAxis = {}; //new Dictionary(false);
        negTotalsByPrimaryAxis = {}; //new Dictionary(false);
        stackedMaximum = 0;
        
        var previousSeries:IStackable2 = null;
        for (i = 0; i < n; i++)
        {
            series = _series[i];
            if (_type == "stacked" && _allowNegativeForStacked)
            {
                obj = series.stackAll(posTotalsByPrimaryAxis,negTotalsByPrimaryAxis, previousSeries);
                stackedMaximum = Math.max(stackedMaximum, obj.maxValue);
                stackedMinimum = isNaN(stackedMinimum) ? obj.minValue : Math.min(stackedMinimum, obj.minValue);
            }
            else
            {
                stackedMaximum = Math.max(stackedMaximum,series.stack(posTotalsByPrimaryAxis,previousSeries));
                if (_type == "100%")
                    stackedMinimum = 0;
                else
                {
                    var cachedDataDescriptions:Array = Series(series).describeData(CartesianTransform.VERTICAL_AXIS,
                                            DataDescription.REQUIRED_MIN_MAX | DataDescription.REQUIRED_BOUNDED_VALUES);
                    if (cachedDataDescriptions.length)
                        stackedMinimum = isNaN(stackedMinimum) ? cachedDataDescriptions[0].min : 
                                                        Math.min(stackedMinimum, cachedDataDescriptions[0].min);
                } 
            }   
            previousSeries = series;
        }

        var totals:Object = _type == "100%" ? posTotalsByPrimaryAxis : null;
        
        for (i = 0; i < n; i++)
        {
            series = _series[i];
            series.stackTotals = totals;
        }
    }

    /**
     *  Provides custom text for DataTip objects.
     *  Stacking sets override the DataTip text of their contained sub-series
     *  to display additional information related to the stacking behavior.
     *  Derived classes must override this method to define custom DataTip text.
     *  
     *  @param hitData The hitData object in the stack.
     *  
     *  @return The custom text for the DataTip. The default is the empty string. You must 
     *  override this method to provide a custom DataTip.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function formatDataTip(hitData:HitData):String
    {
        return "";
    }
}

}
