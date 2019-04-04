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

import mx.charts.ChartItem;
import mx.charts.effects.effectClasses.SeriesEffectInstance;
import mx.core.mx_internal;
import mx.effects.Effect;
//import mx.effects.EffectManager;
import mx.effects.IEffectInstance;
import mx.events.DragEvent;
import mx.events.FlexEvent;

use namespace mx_internal;

//--------------------------------------
//  Effects
//--------------------------------------

/**
 *  Defines the effect that Flex uses as it hides the current data from view.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Effect(name="hideDataEffect", event="hideData")]

/**
 *  Defines the effect that Flex uses as it moves the current data
 *  into its final position on the screen.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Effect(name="showDataEffect", event="showData")]


/**
 *  The Series class is the base class for the classes
 *  that let you specify a data series for a chart control. 
 *  You use the subclasses of the Series class
 *  with the associated chart control. 
 *  You can use a Series class to specify the fill pattern and stroke
 *  characteristics for the chart elements that are associated with the data series. 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class Series extends ChartElement
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
    public function Series()
    {
        super();
        //super.showInAutomationHierarchy = false;
        this.addEventListener(DragEvent.DRAG_START, dragStartHandler);
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    protected var allSeriesTransform:Boolean = true;

    /**
     *  @private
     */
    private var _previousTransitionData:Object;

    /**
     *  @private
     */
    private var _bDataDirty:Boolean = true;

    /**
     *  @private
     */
    private var _bMappingDirty:Boolean = true;

    /**
     *  @private
     */
    private var _bFilterDirty:Boolean = true;

    /**
     *  @private
     */
    private var _bTransformDirty:Boolean = true;

    /**
     *  @private
     */
    private var _bHideTransitionDirty:Boolean = false;
    
    /**
     *  @private
     */
    private var _selectionDirty:Boolean = false;
    
    /**
     *  @private
     */
    private var _selectionDirtyArray:Array /* of ChartItem */ = [];
    
    /**
     *  @private
     */
    private var _selectionIndicesDirty:Boolean = false;
    
    /**
     *  @private
     */
    private var _selectionIndicesDirtyArray:Array /* of int */ = [];
    
    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  dataTransform
    //----------------------------------

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function set dataTransform(value:DataTransform):void
    {
        if (dataTransform)
        {
            dataTransform.removeEventListener(FlexEvent.TRANSFORM_CHANGE,
                                      transformChangeHandler);
        }

        if (value)
        {
            super.dataTransform = value;
            value.addEventListener(FlexEvent.TRANSFORM_CHANGE,
                                   transformChangeHandler/*, false, 0, true*/);
        }
        else
        {
            var p:String;
            for (p in dataTransform.axes)
            {
                dataTransform.getAxis(p).unregisterDataTransform(dataTransform);
            }           
        }
    }

    //----------------------------------
    //  showInAutomationHierarchy
    //----------------------------------

    /**
     *  @private
    override public function set showInAutomationHierarchy(value:Boolean):void
    {
        //do not allow value changes
    }
     */
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    // dataFunction
    //----------------------------------
    
    [Bindable]
    [Inspectable(category="General")]
    
    /**
     *  @private
     *  Storage for dataFunction property
     */    
    private var _dataFunction:Function;    
    
    /**
     * Specifies a method that returns the value that should be used for 
     * positioning the current chart item in the series.
     * If this property is set, the return value of the custom data function takes precedence over the
     * other related properties, such as <code>xField</code> and <code>yField</code>
     * for AreaSeries, BarSeries, BubbleSeries, ColumnSeries, LineSeries, and PlotSeries.
     * For BubbleSeries, the return value takes precedence over the <code>radiusField</code> property.
     * For PieSeries, the return value takes precedence over the <code>field</code> property.     
     * 
     * <p>The custom <code>dataFunction</code> for a series has the following signature:
     *  
     * <pre>
     * <i>function_name</i> (series:Series, item:Object, fieldName:String):Object { ... }
     * </pre>
     * 
     * <code>series</code> is the current series that uses this <code>dataFunction</code>.
     * <code>item</code> is the item in the data provider.
     * <code>fieldName</code> is the field in current chart item that is to be populated.     
     * This function returns an object.
     * </p>
     * 
     * <p>You typically use the <code>dataFunction</code> property to access fields in a data provider that are not
     * scalar values, but are instead nested in the data provider. For example, the following data
     * requires a data function to access the fields for a chart's data provider:</p>
     *  
     *  <pre>
     *  {month: "Aug", close: {High:45.87,Low:12.2}, open:25.19}
     *  </pre>
     *  
     * <p>The following example returns a value from this data provider:</p>
     *   
     * <pre>
     * public function myDataFunction(series:Series, item:Object, fieldName:String):Object {
     *      if (fieldName == 'yValue')
     *          return(item.close.High);
     *      else if (fieldName == "xValue")
     *          return(item.month);
     *      else
     *          return null;
     * }     
     * </pre>
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get dataFunction():Function
    {
        return _dataFunction;   
    }
    
    /**
     *  @private
     */
    public function set dataFunction(value:Function):void
    {
        _dataFunction = value;
        dataChanged();
    }

    //---------------------------------
    // dataTipItems
    //---------------------------------
    
    [Bindable]
    [Inspectable(category="General")]
    
    /**
     *  @private
     */
    private var _dataTipItems:Array /* of ChartItem */;
    
    /**
     *  Array of chart items for which data tips are to be shown
     *  non-interactively on the chart.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
     public function get dataTipItems():Array /* of ChartItem */
     {
        return _dataTipItems;
     }
     
     /**
      *  @private
      */
     public function set dataTipItems(value:Array /* of ChartItem */):void
     {
        _dataTipItems = value;
        invalidateProperties();
     }
    
    //----------------------------------
    //  displayName
    //----------------------------------

    /**
     *  @private
     *  Storage for the displayName property.
     */
    private var _displayName:String;

    [Inspectable(category="Display")]

    /**
     *  The name of the series, for display to the user.
     *  This property is used to represent the series in user-visible labels,
     *  such as data tips.
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

        var c:ChartBase = chart;
        if (c)
            c.legendDataChanged();
    }
    
    //----------------------------------
    //  filterDataValues
    //----------------------------------

    /**
     *  @private
     *  Storage for the filterDataValues property.
     */
    private var _filterDataValues:String = "outsideRange";
    private var _userfilterDataValues:String = "";

    [Inspectable(category="General", enumeration="none,nulls,outsideRange", defaultValue="outsideRange")]

    /**
     *  If <code>filterFuction</code> is set, <code>filterDataValues</code> and
     *  <code>filterData</code> are ignored.
     * 
     *  If <code>filterDataValues</code> property is set to <code>none</code>, 
     *  series will not filter its data before displaying.
     * 
     *  If <code>filterDataValues</code> is set to <code>nulls</code>, series 
     *  filters data like <code>null</code>, <code>undefined</code>, or <code>NaN</code>
     *  before displaying.
     * 
     *  If this property is set to <code>outsideRange</code>, series 
     *  filters its data like <code>null</code>, <code>undefined</code>, or <code>NaN</code> 
     *  and also the values that are outside the range of the chart axes.
     *
     *  If you know that all of the data in the series is valid,
     *  you can set this to <code>none</code> to improve performance.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 4
     */
    public function get filterDataValues():String
    {
        return _filterDataValues;
    }
    
    /**
     *  @private
     */
    public function set filterDataValues(value:String):void
    {
        _filterDataValues = value;
        _userfilterDataValues = value;
        invalidateFilter();
    }
    
    //----------------------------------
    //  filterData
    //----------------------------------

    /**
     *  @private
     *  Storage for the filterData property.
     */
    private var _filterData:Boolean = true;

    [Inspectable(category="General", defaultValue="true")]

    /**
     *  If <code>filterFuction</code> or <code>filterDataValues</code> is set,  
     *  <code>filterData</code> is ignored.
     *  
     *  <code>true</code> if the series filters its data
     *  before displaying.
     *  If a series renders data that contains missing values
     *  (such as <code>null</code>, <code>undefined</code>, or <code>NaN</code>),
     *  or renders values that are outside the range of the chart axes,
     *  this property should be set to <code>true</code> (the default).
     *  If you know that all of the data in the series is valid,
     *  you can set this to <code>false</code> to improve performance.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get filterData():Boolean
    {
        return _filterData;
    }
    
    /**
     *  @private
     */
    public function set filterData(value:Boolean):void
    {
        _filterData = value;
        
        //if user has not specified filterDataValues, we consider filterData.
        //Else filterDataValues should be given preference
        
        if(_userfilterDataValues == "") 
        {
            if(value)
                _filterDataValues = "outsideRange";
            else
                _filterDataValues = "none";
            invalidateFilter();
        }
    }
    
    
    //----------------------------------
    //  filterFunction
    //----------------------------------

    /**
     *  @private
     *  Storage for the filterFunction property.
     */
    private var _filterFunction:Function = defaultFilterFunction;

    [Inspectable(category="General")]

    /**
     * Specifies a method that returns the array of chart items in the series
     * that are to be displayed.
     * 
     * If this property is set, the return value of the custom filter function takes 
     * precedence over the <code>filterDataValues</code> and <code>filterData</code> properties.
     * But if it returns null, then <code>filterDataValues</code> and <code>filterData</code> will be 
     * prefered in that order.  
     * 
     * <p>The custom <code>filterFunction</code> has the following signature:
     *  
     * <pre>
     * <i>function_name</i> (cache:Array):Array { ... }
     * </pre>
     * 
     * <code>cache</code> is a reference to the array of chart items that are to be filtered.
     * This function returns an array of chart items that are to be displayed. 
     * </p>
     *  
     * @example
     * <pre>
     * public function myFilterFunction(cache:Array):Array {
     *      var filteredCache:Array=[];
     *      var n:int = cache.length;  
     *      for(var i:int = 0; i &lt; n; i++)
     *      {
     *          var item:ColumnSeriesItem = ColumnSeriesItem(cache[i]);
     *          if(item.yNumber &gt; 0 &#38;&#38; item.yNumber &lt; 700)
     *          {
     *              filteredCache.push(item);
     *          }
     *      }
     *      return filteredCache;
     * }
     * </pre>
     *
     * <p>
     *  If you specify a custom filter function for your chart series and you
     *  want to filter null values or values outside the range of axes, you must manually 
     *  filter them using the custom filter function. <code>filterDataValues</code> or
     *  <code> filterData</code> cannot be used.
     *  </p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 4
     */
    public function get filterFunction():Function
    {
        return _filterFunction;
    }
    
    /**
     *  @private
     */
    public function set filterFunction(value:Function):void
    {
        if(value != null)
            _filterFunction = value;
        else
            _filterFunction = defaultFilterFunction;

        invalidateFilter();
    }
    
    //----------------------------------
    //  interactive
    //----------------------------------

    /**
     *  @private
     *  Storage for the interactive property.
     */
    private var _interactive:Boolean=true;

    [Inspectable(category="General", defaultValue="true")]

    /**
     *  Determines whether data tips appear when users interact
     *  with chart data on the screen.
     *  Set to <code>false</code> to prevent the series
     *  from showing data tips or generating hit data.
     *
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get interactive():Boolean
    {
        return _interactive;
    }

    /**
     *  @private
     */
    public function set interactive(value:Boolean):void
    {
        _interactive = value;

        invalidateDisplayList();
    }

    //----------------------------------
    //  legendData
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  An Array of LegendData instances that describe the items
     *  that should show up in a legend representing this series.
     *  Derived series classes override this getter and return legend data that is
     *  specific to their styles and data representation method.
     *  Although most series types return only a single LegendData instance,
     *  some series types, such as PieSeries and  StackedSeries,
     *  return multiple instances representing individual items
     *  in the Array, or multiple ways of rendering data.   
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get legendData():Array /* of LegendData */
    {
        return null;
    }
    
    //----------------------------------
    //  renderData
    //----------------------------------

    /**
     *  Stores the information necessary to render this series.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function get renderData():Object
    {
        return null;
    }

    //----------------------------------
    //  selectable
    //----------------------------------

    /**
     *  @private
     *  Storage for the selectable property.
     */
    private var _selectable:Boolean=true;

    [Inspectable(category="General")]

    /**
     *  Specifies whether a series is selectable or not.
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectable():Boolean
    {
        return _selectable;
    }

    /**
     *  @private
     */     
    public function set selectable(value:Boolean):void
    {
        if (_selectable != value)
        {
            _selectable = value;

            invalidateProperties();
        }
    }

    //----------------------------------
    //  selectedIndex
    //----------------------------------
    
    [Inspectable(category="General")]

    /**
     *  Index of the selected item in the data provider of the series. If multiple items are selected, 
     *  then this property refers to the most recently selected item. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectedIndex():int
    {
        var len:int;
        
        len = _selectedItems.length;
        if (len > 0)
            return _selectedItems[len - 1].index;
        return -1;

    }

    /**
     *  @private
     */
    public function set selectedIndex(value:int):void
    {
        if (_selectedItems.length == 1 && _selectedItems[0].index == value)
            return;
    
        if (items)
        {
            var item:ChartItem = null;
            
            item = findChartItemFor(value);
            if (!item)
                return;
    
            _selectionDirtyArray = [];
            _selectionDirtyArray.push(item);
            
            _selectionDirty = true;
            invalidateProperties();
        }
        else
        {
            _selectionIndicesDirty = true;
            _selectionIndicesDirtyArray.push(value);
            invalidateProperties();
        }
    }

    //----------------------------------
    //  selectedIndices
    //----------------------------------

    [Inspectable(category="General")]

    /**
     *  An Array of indexes of the selected items in the data provider of the series.
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */     
    public function get selectedIndices():Array /* of int */
    {
        var arrItems:Array /* of int */ = [];
        var n:int = _selectedItems.length;
        for (var i:int = 0; i < n; i++)
        {
            arrItems.push(_selectedItems[i].index);
        }   
        return arrItems;
    }

    /**
     *  @private
     */
    public function set selectedIndices(value:Array /* of int */):void
    {           
        if (_selectedItems.length == 0 && value.length == 0)
            return;
        
        if (items)
        {
            var item:ChartItem = null;
            
            _selectionDirtyArray = [];
            var n:int  = value.length;            
            for (var i:int = 0; i < n; i++)
            {
                item = findChartItemFor(value[i]);
                if (item)
                    _selectionDirtyArray.push(item);
            }
            
            _selectionDirty = true;
            invalidateProperties();
        }
        else
        {
            _selectionIndicesDirty = true;
            _selectionIndicesDirtyArray = value;
            invalidateProperties();
        }
    }

    //----------------------------------
    //  selectedItem
    //----------------------------------

    [Inspectable(category="General")]

    /**
     *  The chart item that is selected in the series. If multiple items are selected, 
     *  then this property refers to the most recently selected item. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectedItem():ChartItem
    {
        var len:int;
        
        len = _selectedItems.length;
        if (len > 0)
            return _selectedItems[len - 1];
        return null;
    }

   /**
     *  @private
     */
    public function set selectedItem(value:ChartItem):void
    {   
        if (_selectedItems.length == 1 && _selectedItems[0] == value)
            return;
            
        _selectionDirtyArray = [];      
        _selectionDirtyArray.push(value);
            
        _selectionDirty = true;
        invalidateProperties();
    }

    //----------------------------------
    //  selectedItems
    //----------------------------------

    /**
     *  @private
     *  Storage for the selectedItems property.
     */
    private var _selectedItems:Array /* of ChartItem */ = [];

    [Inspectable(category="General")]

    /**
     *  An Array of chart items that are selected in the series.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */     
    public function get selectedItems():Array /* of ChartItem */
    {
        return _selectedItems;
    }

    /**
     *  @private
     */
    public function set selectedItems(value:Array /* of ChartItem */):void
    {   
        if (_selectedItems.length == 0 && value.length == 0)
            return;
                    
        _selectionDirtyArray = value;
        _selectionDirty = true; 
        invalidateProperties();
    }
    
    //----------------------------------
    //  transitionRenderData
    //----------------------------------

    /** 
     *  @private
     *  Storage for the _transitionRenderData property.
     */
    private var _transitionRenderData:Object;

    /**
     *  A render data structure passed in by a running transtion.
     *  When a series effect is set to play on a series, it first captures
     *  the current state of the series by asking for its render data.
     *  The transition modifies the render data to create the desired effect
     *  and passes the structure back to the series for display.
     *  If the <code>transitionRenderData</code> property is a value other than <code>null</code>,
     *  a series uses its contents to update its display.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get transitionRenderData():Object
    {
        return _transitionRenderData;
    }

    /** 
     *  @private
     */
    public function set transitionRenderData(value:Object):void
    {
        _transitionRenderData = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

    /**
     *  Calls the <code>legendDataChanged()</code> method.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function stylesInitialized():void
    {
        legendDataChanged();
    }

    /**
     *  @private
     */
    override public function invalidateSize():void
    {
        invalidateTransform();

        super.invalidateSize();     
    }   

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        if (_bHideTransitionDirty)
            _bHideTransitionDirty = false;

        var s:ChartBase = chart;
        if (s)
            var cs:uint = s.chartState;

        validateData();
        validateTransform();
        validateSelection();
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function setActualSize(w:Number, h:Number):void
    {
        invalidateTransform();

        super.setActualSize(w, h);
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function commitProperties():void
    {
        super.commitProperties();
        if (_dataTipItems && chart)
        {
            chart.dataTipItemsSet = true;
            invalidateDisplayList();
        }   
        if (_selectionDirty)
        {
            _selectionDirty = false;
            if (_selectable && chart)
                chart.seriesSelectionChanged(this,_selectionDirtyArray);    
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
    override public function mappingChanged():void
    {
        invalidateMapping();
    }
    
    /**
     *  @private
     */
    override public function chartStateChanged(oldState:uint, v:uint):void
    {
        invalidateDisplayList();

        if (v == ChartState.PREPARING_TO_SHOW_DATA || v == ChartState.NONE)
            transitionRenderData = null;
        
        super.chartStateChanged(oldState,v);
    }

    /**
     *  @private
     */
    override public function collectTransitions(chartState:Number,
                                                transitions:Array /* of IEffectInstance */):void
    {
        var transition:Effect = null;
        var instance:IEffectInstance;

        /*
        if (chartState == ChartState.PREPARING_TO_HIDE_DATA)
        {
            transition = EffectManager.
                mx_internal::createEffectForType(this,"hideData") as Effect;
            
            if (transition)
            {
                instance = transition.createInstance(this);
                if (instance is SeriesEffectInstance)
                    (instance as SeriesEffectInstance).type = "hide";
            }
        }

        else if (chartState == ChartState.PREPARING_TO_SHOW_DATA)
        {
            // Our show effect needs fully calculated and updated caches,
            // so we need to make sure this gets called here.
            validateProperties(); 
            
            transition = EffectManager.
                mx_internal::createEffectForType(this,"showData") as Effect;
            
            if (transition)
            {
                instance = transition.createInstance(this);
                if (instance is SeriesEffectInstance)
                    (instance as SeriesEffectInstance).type = "show";
            }
        }
        */
        
        if (instance)
            transitions.push(instance);

        super.collectTransitions(chartState,transitions);
    }

    /**
     *  @copy mx.charts.chartClasses.IChartElement#claimStyles()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function claimStyles(styles:Array /* of Object */,
                                         firstAvailable:uint):uint
    {
        internalStyleName = styles[firstAvailable];
        return (firstAvailable + 1) % styles.length;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
        /**
     *  Gets all the items that are there in the series after filtering.
     *  <p>Individual series determine the list of items that are to be returned.</p>
     *  
     *  @return An Array of ChartItems.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */

    public function get items():Array /* of ChartItem */
    {
        return [];
    }
    
     /**
     *  Gets all the items that are in a rectangular region for the series.
     *  Call this function to determine what items are in
     *  a particular rectangular region in that series.
     *  <p>Individual series determine whether their chart item is under the region.
     *  The point should be in the global coordinate space.</p>
     *  
     *  @param value A Rectangle object that defines the region.
     *  
     *  @return An Array of ChartItem objects that are within the specified rectangular region.
     * 
     *  @see flash.geom.Rectangle
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getItemsInRegion(r:Rectangle):Array /* of ChartItem */
    {
        return [];
    }

    /**
     *  @private
     */        
    mx_internal function addItemtoSelection(item:ChartItem):void
    {
        _selectedItems.push(item);      
        item.currentState = ChartItem.SELECTED;
    }
    
    /**
     *  @private 
     */
     
    mx_internal function removeItemfromSelection(item:ChartItem, state:String = ChartItem.DISABLED):void
    {
        var index:int;
        
        index = _selectedItems.indexOf(item);
        _selectedItems.splice(index,1);
        item.currentState = state;
    }
    
    /**
     *  @private
     */
     
    mx_internal function setItemsState(state:String):void
    {
        var items:Array /* of ChartItem */;
        items = (renderData)? renderData.filteredCache : [];
        if (items) 
        {
            var n:int  = items.length;
            for (var i:int = 0; i < n; i++)
            {
                items[i].currentState = state;
            }   
        }   
    }
    
    /**
     *  @private
     */
     
    mx_internal function clearSeriesItemsState(clear:Boolean, state:String = ChartItem.NONE):void
    {
        if (clear)
            _selectedItems = [];
        setItemsState(state);
    }
    
    /**
     *  @private
     */
    mx_internal function getTransformState():Boolean
    {
        return _bTransformDirty;    
    }
    
    /**
     *  @private
     */
    mx_internal function emptySelectedItems():void
    {
        _selectedItems = [];
    }

    /**
     *  @private
     */    
    private function validateSelection():void
    {
        if (_selectionIndicesDirty)
        {
            _selectionIndicesDirty = false;
            selectedIndices = _selectionIndicesDirtyArray;
            _selectionIndicesDirtyArray = [];
        }
        else if (_selectionDirty == true)
        {
            _selectionDirty = false;
            if (chart)
                chart.updateKeyboardCache();
        }
    }
    
     /**
     *  @private
     */    
    mx_internal function getChartSelectedStatus():Boolean
    {
        if (chart)
            return chart.selectedChartItems.length > 0;
        return false;
    }

    /**
     *  Caches the values stored in the <code>measureName</code> property
     *  from the original dataProvider items in the chart item's
     *  <code>fieldName</code> property.  
     *  If the the value of the <code>measureName</code> property is <code>null</code>
     *  or the empty string, this method assumes the original data provider items
     *  are raw values and caches them instead. 
     * 
     *  @param measureName Name of the property of chart item whose value should be set 
     *  by a value from the dataProvider based on the <code>fieldName</code> property.
     *  For example, <code>measureName</code> can be the xValue, yValue, xNumber, yNumber, etc,
     *  provided they are properties of the chart item.
     *  
     *  @param cache An array of chart items.
     *  
     *  @param fieldName The label (in the data provider's item) whose value should be 
     *  used to set the chart item's <code>measureName</code> property. For example,
     *  if the data provider has an item like <code>{Country:"US", medals:10}</code>, 
     *  then the value of <code>fieldName</code> can be "Country" or "medals".
     *  
     *  @return <code>false</code> if the value of the <code>measureName</code> property 
     *  is the empty string or null; otherwise <code>true</code>.     
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function cacheDefaultValues(measureName:String, cache:Array /* of ChartItem */,
                                          fieldName:String): Boolean
    {
        var n:int = cache.length;
        var i:int;
        var c:Object;
        
        if (_dataFunction != null)
        {
            for (i = 0; i < n; i++)
            {
                c = cache[i];
                c[fieldName] = dataFunction(this,c.item,fieldName);
            }
            return true;    
        }
        
        else if (measureName == "" || measureName == null)
        {
            for (i = 0; i < n; i++)
            {
                c = cache[i];
                c[fieldName] = c.item;
            }
            return false;
        }
        else
        {
            for (i = 0; i < n; i++)
            {
                c = cache[i];
                if (c.item == null)
                    continue;
                c[fieldName] = c.item[measureName];
            }
            return true;
        }
    }

    /**
     *  Caches the values stored in the <code>measureName</code> property
     *  from the original dataProvider items in the chart item's
     *  <code>fieldName</code> property.  
     *  
     *  @param measureName Name of the property of chart item whose value should be set 
     *  by a value from the dataProvider based on the <code>fieldName</code> property.
     *  For example, <code>measureName</code> can be the xValue, yValue, xNumber, yNumber, etc,
     *  provided they are properties of the chart item.
     *  
     *  @param cache An array of chart items.
     *  
     *  @param fieldName The label (in the data provider's item) whose value should be 
     *  used to set the chart item's <code>measureName</code> property. For example,
     *  if the data provider has an item like <code>{Country:"US", medals:10}</code>, 
     *  then the value of <code>fieldName</code> can be "Country" or "medals".
     *  
     *  @return <code>false</code> if the value of the <code>measureName</code> property 
     *  is the empty string or null; otherwise <code>true</code>.     
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    protected function cacheNamedValues(measureName:String, cache:Array /* of ChartItem */,
                                        fieldName:String):Boolean
    {
        var n:int = cache.length;
        var c:Object;
        if (_dataFunction != null)
        {
            for (var i:int = 0; i < n; i++)
            {
                c = cache[i];
                c[fieldName] = dataFunction(this,c.item,fieldName);
            }
            return true;    
        }
        
        if (measureName == "")
            return false;
        
        for (i = 0; i < n; i++)
        {
            c = cache[i];
            if (c.item == null)
                continue;
            c[fieldName] = c.item[measureName];
        }
        
        return true;
    }

    /**
     *  Caches the values stored in the <code>measureName</code> property
     *  from the original dataProvider items in the chart item's
     *  <code>fieldName</code> property.  
     *  If the <code>measureName</code> property is <code>null</code>
     *  or the empty string, this method stores the index of the items
     *  in the <code>fieldName</code> property instead.
     *  
     *  @param measureName Name of the property of chart item whose value should be set 
     *  by a value from the dataProvider based on the <code>fieldName</code> property.
     *  For example, <code>measureName</code> can be the xValue, yValue, xNumber, yNumber, etc,
     *  provided they are properties of the chart item.
     *  
     *  @param cache An array of chart items.
     *  
     *  @param fieldName The label (in the data provider's item) whose value should be 
     *  used to set the chart item's <code>measureName</code> property. For example,
     *  if the data provider has an item like <code>{Country:"US", medals:10}</code>, 
     *  then the value of <code>fieldName</code> can be "Country" or "medals".
     *  
     *  @return <code>false</code> if the value of the <code>measureName</code> property 
     *  is the empty string or null; otherwise <code>true</code>.     
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function cacheIndexValues(measureName:String, cache:Array /* of ChartItem */,
                                        fieldName:String):Boolean
    {
        var n:int = cache.length;
        var i:int;
        var c:Object;
        if (_dataFunction != null)
        {
            for (i = 0; i < n; i++)
            {
                c = cache[i];
                c[fieldName] = dataFunction(this,c.item,fieldName);
            }
            return true;    
        }

        if (measureName == "")
        {
            for (i = 0; i < n; i++)
            {
                c = cache[i];
                c[fieldName] = c.index;
            }
            return false;
        }
        else
        {
            for (i = 0; i < n; i++)
            {
                c = cache[i];
                if (c.item == null)
                    continue;
                c[fieldName] = c.item[measureName];
            }
            return true;
        }

    }
    
    /**
     *  Extracts the minimum value, maximum value, and, optionally,
     *  the minimum interval from an Array of ChartItem objects.
     *  Derived classes can call this method from their 
     *  implementations of the <code>describeData()</code> method to fill in the details
     *  of the DataDescription structure.
     * 
     *  @param cache An array of chart items.
     *  
     *  @param measureName Name of the property of chart item whose value should be set 
     *  by a value from the dataProvider based on the <code>fieldName</code> property.
     *  For example, <code>measureName</code> can be the xValue, yValue, xNumber, yNumber, etc,
     *  provided they are properties of the chart item.
     *  
     *  @param desc DataDescription object of the series. This property holds bounded values such
     *  as <code>min</code>, <code>max</code>, and <code>minInterval</code> of the series.
     *  
     *  @param calculateInterval Determines whether to extract the <code>minInterval</code> for the 
     *  DataDescription <code>desc</code> by using the ChartItem objects in the <code>cache</code> property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function extractMinMax(cache:Array /* of ChartItem */, measureName:String,
                                     desc:DataDescription,
                                     calculateInterval:Boolean = false):void
    {
        var n:int = cache.length;
        var i:int;
        var v:Number;
        var prevValidValue:Number;
        var minInterval:Number = Number.POSITIVE_INFINITY;
        
        if (isNaN(desc.min))
        {           
            for (i = 0; i < n; i++)
            {
                v = cache[i][measureName];
                if (isNaN(v) == false)
                    break;
            }

            if (isNaN(v))
                return;
            
            desc.min = desc.max = v;
            prevValidValue = v;
        }

        for (i++; i < n; i++)
        {
            v = cache[i][measureName];
            if (isNaN(v))
                continue;
            
            if (v < desc.min)
                desc.min = v;
            if (v > desc.max)
                desc.max = v;   
            
            if (calculateInterval && (v - prevValidValue < minInterval))
                minInterval = Math.abs(v - prevValidValue);
            
            prevValidValue = v;
        }

        if (calculateInterval &&
            minInterval < Number.POSITIVE_INFINITY &&
            (minInterval < desc.minInterval || isNaN(desc.minInterval)))
        {
            desc.minInterval = minInterval;
        }
    }

    /**
     *  Extracts the minimum value, maximum value, and, optionally,
     *  the minimum interval from an Array of ChartItem objects.
     *  Derived classes can call this method from their
     *  implementations of the <code>describeData()</code> method to fill in the details
     *  of the DataDescription structure.
     *  
     *  @param cache An array of chart items.
     *  
     *  @param measureName Name of the property of chart item whose value should be set 
     *  by a value from the dataProvider based on the <code>fieldName</code> property.
     *  For example, <code>measureName</code> can be the xValue, yValue, xNumber, yNumber, etc,
     *  provided they are properties of the chart item.
     *  
     *  @param desc DataDescription object of the series. This property holds bounded values such
     *  as <code>min</code>, <code>max</code>, and <code>minInterval</code> of the series.    
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function extractMinInterval(cache:Array /* of ChartItem */, measureName:String,
                                          desc:DataDescription):void
    {
        var n:int = cache.length;
        var i:int;
        var v:Number;
        var prevValidValue:Number;
        var minInterval:Number = Number.POSITIVE_INFINITY;
        
        for (i = 0; i < n; i++)
        {
            v = cache[i][measureName];
            if (isNaN(v) == false)
                break;
        }

        if (isNaN(v))
            return;

        prevValidValue = v;

        for (i++; i < n; i++)
        {
            v = cache[i][measureName];
            if (isNaN(v))
                continue;
            
            if (v - prevValidValue < minInterval)
                minInterval = Math.abs(v - prevValidValue);
            
            prevValidValue = v;
        }

        if (minInterval < Number.POSITIVE_INFINITY &&
            (minInterval < desc.minInterval || isNaN(desc.minInterval)))
        {
            desc.minInterval = minInterval;
        }
    }

    /**
     *  Removes any item from the provided cache whose <code>field</code>
     *  property is <code>NaN</code>.
     *  Derived classes can call this method from their implementation of the <code>updateFilter()</code>
     *  method to remove any ChartItem objects that were filtered out by the axes.
     *  
     *  @param cache An array of chart items.
     *  
     *  @param field The field property to remove an item from.
     *  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function stripNaNs(cache:Array /* of ChartItem */, field:String):void
    {
        if (filterDataValues == "none")
            return;
            
        var len:int = cache.length;
        var start:int = -1;
        var end:int = -1;
        var i:int;
        var n:int  = cache.length;
        if (field == "")
        {
            for (i= n - 1; i >= 0; i--)
            {
                if (isNaN(cache[i]))
                {
                    if (start < 0)
                    {
                        start = end = i;
                    }
                    else if (end - 1 == i)
                    {
                        end = i;
                    }
                    else
                    {
                        cache.splice(end, start - end + 1);
                        start = end = i;
                    }
                }
            }
        }
        else
        {
            for (i = n - 1; i >= 0; i--)
            {
                if (isNaN(cache[i][field]))
                {
                    if (start < 0)
                    {
                        start = end = i;
                    }
                    else if (end - 1 == i)
                    {
                        end = i;
                    }
                    else
                    {
                        cache.splice(end, start - end + 1);
                        start = end = i;
                    }
                }
            }
        }

        if (start >= 0)
            cache.splice(end, start - end + 1);
    }
    
    /**
     *  Informs the series that the underlying data
     *  in the data provider has changed.
     *  This function triggers calls to the <code>updateData()</code>,
     *  <code>updateMapping()</code>, <code>updateFilter()</code>,
     *  and <code>updateTransform()</code> methods on the next call
     *  to the <code>commitProperties()</code> method.
     *  If any data effects are assigned to any elements of the chart,
     *  this method also triggers the show and hide effects.
     *  
     *  @param invalid If <code>true</code>, this method triggers calls
     *  to the update methods.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function invalidateData(invalid:Boolean = true):void
    {
        if (invalid)
        {
            _bDataDirty = true;
            _bMappingDirty = true;
            _bFilterDirty = true;
            _bTransformDirty=true;
            
            invalidateProperties();
            invalidateDisplayList();
        }
        else
        {
            _bDataDirty = false;
        }
    }

    /**
     *  Informs the series that the mapping of the data into numeric values
     *  has changed and must be recalculated.
     *  Calling this function triggers calls to the <code>updateMapping()</code>,
     *  <code>updateFilter()</code>, and <code>updateTransform()</code> methods
     *  on the next call to the <code>commitProperties()</code> method.
     *  If any data effects are assigned to any elements of the chart,
     *  this method also triggers the show and hide effects.
     *  
     *  @param invalid If <code>true</code>, this method triggers calls
     *  to the update methods.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function invalidateMapping(invalid:Boolean = true):void
    {
        if (invalid)
        {
            _bDataDirty = true; // for transitions to work, we need a new cache
            _bMappingDirty = true;
            _bFilterDirty = true;
            _bTransformDirty = true;
            
            invalidateTransitions();
            invalidateDisplayList();
        }
        else
        {
            _bMappingDirty = true;
        }
    }

    /**
     *  Informs the series that the filter of the data against the axes
     *  has changed and must be recalculated.
     *  Calling this method triggers calls to the <code>updateFilter()</code>
     *  and <code>updateTransform()</code> methods on the next call
     *  to the <code>commitProperties()</code> method.
     *  If any data effects are assigned to any elements of the chart,
     *  this method also triggers the show and hide effects.
     *       
     *  @param invalid If <code>true</code>, this method triggers calls
     *  to the update methods.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function invalidateFilter(invalid:Boolean = true):void
    {
        if (invalid)
        {
            _bFilterDirty = true;
            _bTransformDirty = true;
            
            invalidateTransitions();
            invalidateDisplayList();
        }
        else
        {
            _bFilterDirty = false;
        }
    }

    /**
     *  Informs the series that the transform of the data to screen coordinates
     *  has changed and must be recalculated.
     *  Calling this function triggers a call to the
     *  <code>updateTransform()</code> method on the next call
     *  to the <code>commitProperties()</code> method.
     *  
     *  @param invalid If <code>true</code>, this method triggers calls
     *  to the update methods.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function invalidateTransform(invalid:Boolean = true):void
    {
        if (invalid)        
        {
            _bTransformDirty = true;
        
            invalidateDisplayList();
        }
        else
        {
            _bTransformDirty = false;
        }
    }

    /**
     *  Informs the series that a significant change has occured
     *  in the display of data.
     *  This triggers any ShowData and HideData effects.  
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    protected function invalidateTransitions():void
    {
        if (_bHideTransitionDirty == false)
        {
            _previousTransitionData = renderData;
                        
            var s:ChartBase = chart;
            if (s)
                s.hideData();

            _bHideTransitionDirty = true;
        }       
    }
    
    /**
     *  Called when the underlying data that the series represents
     *  has changed and needs to be reloaded from the data provider.
     *  If you implement custom series types, you should override this method
     *  and load all data necessary to render the series
     *  out of the backing data provider.
     *  You must also be sure to call the <code>super.updateData()</code> method
     *  in your subclass.
     *  You do not generally call this method directly.
     *  Instead, to guarantee that your data has been updated
     *  at a given point, call the <code>validateData()</code> method
     *  of the Series class.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function updateData():void
    {
        _bDataDirty = false;
    }
    
    /**
     *  Called when the underlying data the series represents
     *  needs to be mapped to numeric representations.
     *  This can happen either because the underlying data has changed
     *  or because the axes used to render the series have changed
     *  in some relevant way.
     *  If you implement a custom series, you should override this method
     *  and convert the data represented into numeric values by
     *  using the <code>mapCache()</code> method of the axes
     *  that are managed by its associated data transform.
     *  You must also be sure to call the <code>super.updateMapping()</code> method
     *  in your subclass.
     *  You should not generally call this method directly.
     *  Instead, to guarantee that your data has been mapped
     *  at a given point, call the <code>validateData()</code> method
     *  of the Series class.
     *  You can generally assume that your <code>updateData()</code> method
     *  has been called prior to this method, if necessary.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function updateMapping():void
    {
        _bMappingDirty = false;
    }
    
    /**
     *  Called when the underlying data the series represents
     *  needs to be filtered against the ranges represented by the axes
     *  of the associated data transform.
     *  This can happen either because the underlying data has changed
     *  or because the range of the associated axes has changed.
     *  If you implement a custom series type, you should override this method
     *  and filter out any outlying data using the <code>filterCache()</code>
     *  method of the axes managed by its associated data transform.  
     *  The <code>filterCache()</code> method converts any values
     *  that are out of range to <code>NaN</code>.
     *  You must be sure to call the <code>super.updateFilter()</code> method
     *  in your subclass.
     *  You should not generally call this method directly.
     *  Instead, if you need to guarantee that your data has been filtered
     *  at a given point, call the <code>validateTransform()</code> method
     *  of the Series class.
     *  You can generally assume that your <code>updateData()</code>
     *  and <code>updateMapping()</code> methods have been called
     *  prior to this method, if necessary.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function updateFilter():void
    {
        _bFilterDirty = false;
    }
    
    /**
     *  Called when the underlying data the series represents
     *  needs to be transformed from data to screen values
     *  by the axes of the associated data transform. 
     *  This can happen either because the underlying data has changed,
     *  because the range of the associated axes has changed,
     *  or because the size of the area on screen has changed.
     *  If you implement a custom series type, you should override this method
     *  and transform the data using the <code>transformCache()</code> method
     *  of the associated data transform.  
     *  You must be sure to call the <code>super.updateTransform()</code> method
     *  in your subclass.
     *  You should not generally call this method directly.
     *  Instead, if you need to guarantee that your data has been filtered
     *  at a given point, call the <code>valiateTransform()</code> method
     *  of the Series class.
     *  You can generally assume that your <code>updateData()</code>,
     *  <code>updateMapping()</code>, and <code>updateFilter()</code> methods
     *  have been called prior to this method, if necessary.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function updateTransform():void
    {
        _bTransformDirty = false;     
    }
        
    /**
     *  Calls the <code>updateFilter()</code> and
     *  <code>updateTransform()</code> methods of the series, if necessary.
     *  This method is called automatically by the series
     *  during the <code>commitProperties()</code> method, as necessary,
     *  but a derived series might call it explicitly
     *  if the generated values are needed at an explicit time.
     *  Filtering and transforming of data relies on specific values
     *  being calculated by the axes, which can in turn
     *  depend on the data that is displayed in the chart.
     *  Calling this function at the wrong time might result
     *  in extra work being done, if those values are updated.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function validateTransform():void
    {
        if (dataTransform)
        {
            if (_bFilterDirty)
            {
                _selectionDirty = true;
                updateFilter();
            }

            if (_bTransformDirty)
            {
                _selectionDirty = true;
                updateTransform();
            }
        }
    }

    /**
     *  Calls the <code>updateData()</code> and
     *  <code>updateMapping()</code> methods of the series, if necessary.
     *  This method is called automatically by the series
     *  from the <code>commitProperties()</code> method, as necessary,
     *  but a derived series might call it explicitly
     *  if the generated values are needed at an explicit time.
     *  Loading and mapping data against the axes is designed
     *  to be acceptable by the axes at any time.
     *  It is safe this method explicitly at any point.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function validateData():void
    {
        if (dataTransform)
        {
            if (_bDataDirty)
            {
                _selectionDirty = true; 
                updateData();
            }

            if (_bMappingDirty)
            {
                _selectionDirty = true;
                updateMapping();
            }
        }
    }

    /**
     *  Captures the before and after states of the series for animation. This method
     *  is typically called by the effects classes.
     * 
     *  <p>If you implement a custom series type, you generally do not override this method.
     *  Instead, you should override the <code>renderData()</code> accessor.</p>
     *
     *  @param type Specifies whether the effect is requesting
     *  a description of the data being hidden, or the new data being shown.
     *  
     *  @return A copy of the data needed to represent the data of the series.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getRenderDataForTransition(type:String):Object
    {
        if (type == "hide")
        {
            return _previousTransitionData;
        }
        else
        {
            validateData();
            validateTransform();
            return renderData;
        }
    }

    /**
     *  Fills in the <code>elementBounds</code>, <code>bounds</code>,
     *  and <code>visibleBounds</code> properties of a renderData
     *  structure that is generated by this series.
     *  Effect classes call this method to fill in these fields
     *  for use in implementing various effect types.
     *  Derived classes should implement this method
     *  to generate the bounds of the items of the series only when requested.
     *  
     *  @param renderData The structure that is generated by this series.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getElementBounds(renderData:Object):void
    {
    }

    /**
     *  Called by the SeriesInterpolate effect to end an interpolation effect.
     *  The effect uses this method to complete the interpolation
     *  and clean up any temporary state associated with the effect.
     *  
     *  @param interpolationData An object that defines the source data (for the <code>show</code> effect)
     *  that represents the "before" state of the series, and the destination data 
     *  (for the <code>hide</code> effect) that represents the "after" state of the series.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function endInterpolation(interpolationData:Object):void
    {
        transitionRenderData = null;
    }
    
    /**
     *  Called by the SeriesInterpolate effect to initiate an interpolation effect.
     *  The effect passes in the source and destination data
     *  for the series to interpolate between.
     *  The effect passes the return value of this method
     *  repeatedly to the <code>interpolate()</code> method of the series 
     *  to advance the animation for the duration of the effect. 
     *  The series calculates the data it needs to 
     *  perform the interpolation and returns it in this method.
     * 
     *  @param sourceRenderData The source data for the series to interpolate between.
     * 
     *  @param destRenderData The destination data for the series to interpolate between.
     * 
     *  @return The data the series needs to perform the interpolation.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function beginInterpolation(sourceRenderData:Object,
                                       destRenderData:Object):Object
    {
        return null;
    }

    /**
     *  Helper method to implement the interpolation effect.
     *  A custom series can call this method from its
     *  <code>beginInterpolation()</code> method to initialize
     *  a data structure to interpolate  an arbitrary set
     *  of numeric properties over the life of the effect.
     *  You can pass that data structure to the
     *  <code>applyInterpolation()</code> utility method to actually modify
     *  the values when the <code>interpolate()</code> method is called.
     *
     *  @param srcCache An Array of objects whose fields
     *  contain the beginning values for the interpolation.
     *
     *  @param dstCache An Array of objects whose fields
     *  contain the ending values for the interpolation.
     *
     *  @param iProps A hash table whose keys identify the names
     *  of the properties from the cache to be interpolated.
     *
     *  @param cacheType The class to instantiate that holds the delta values
     *  computed for the interpolation.
     *  Typically this is <code>null</code>,
     *  in which case a generic Object is used.
     *
     *  @param customData An object containing series-specific data.
     *  When the initialization process encounters a missing value,
     *  it calls the <code>getMissingInterpolationValues()</code>
     *  method of the series to fill in the missing value.
     *  This custom data is passed to that method,
     *  and can be used to pass through arbitrary parameters.
     *
     *  @return A data structure that can be passed
     *  to the <code>applyInterpolation()</code> method.
     * 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function initializeInterpolationData(
                            srcCache:Array /* of ChartItem */, 
                            dstCache:Array /* of ChartItem */,
                            iProps:Object, cacheType:Class = null,
                            customData:Object = null):Object
    {
        var interpolationCache:Array /* of ChartItem */ = [];
        var deltaCache:Array /* of ChartItem */ = [];
        var n:int = Math.max(srcCache.length, dstCache.length);

        var interpolationSource:Array /* of ChartItem */ = [];
        
        if (!cacheType)
            cacheType = Object;
            
        for (var i:int = 0; i < n; i++)
        {
            var src:ChartItem = srcCache[i];
            var dst:ChartItem = dstCache[i];

            var iobj:ChartItem = dst == null ? src.clone() : dst.clone();
            var iSrc:ChartItem = src == null ? dst.clone() : src.clone();
            
            var delta:ChartItem = new cacheType();
            var populated:Boolean = false;
            var missingSrcValues:Object = {};
            var missingDestValues:Object = {};
            var bNeedMissingValues:Boolean = false;
            var srcValue:Number;
            var dstValue:Number;
            
            for (var p:String in iProps)
            {
                if (src)
                    srcValue = src[p];
                else
                    srcValue = NaN;
                
                if (dst)
                    dstValue = dst[p];
                else
                    dstValue = NaN;

                if (isNaN(srcValue) || isNaN(dstValue))
                {
                    bNeedMissingValues = true;
                    missingSrcValues[p] = srcValue;
                    missingDestValues[p] = dstValue;                    
                }
                else
                {
                    iSrc[p] = srcValue;
                    iobj[p] = srcValue;
                    delta[p] = dstValue - srcValue;             
                }
            }

            if (bNeedMissingValues)
            {
                getMissingInterpolationValues(missingSrcValues, srcCache,
                                              missingDestValues, dstCache,
                                              i, customData);

                for (p in missingSrcValues)
                {
                    srcValue = missingSrcValues[p];
                    iSrc[p] = srcValue;
                    iobj[p] = srcValue;
                    delta[p] = missingDestValues[p] - srcValue;             
                }
            }

            interpolationSource[i] = iSrc;
            interpolationCache[i] = iobj;
            deltaCache[i] = delta;          
        }
                        
        var interpolationData:Object =
        {
            cache: interpolationCache,
            interpolationSource: interpolationSource,
            deltaCache: deltaCache,
            properties: iProps
        }
            
        return interpolationData;
    }

    /**
     *  Fills in missing values in an interpolation structure.
     *  When a series calls the <code>initializeInterpolationData()</code> method,
     *  it passes in Arrays of source and destination values
     *  for the interpolation.
     *  If either of those two Arrays is incomplete, the series must
     *  provide "appropriate" placeholder values for the interpolation.
     *  How those placeholder values are determined
     *  is specific to the series type.
     *  Series extenders should override this method
     *  to provide those placeholder values.
     *
     *  @param sourceProps An object containing the source values
     *  being interpolated for a particular item.
     *  When this method exits, all properties in this object
     *  should have values other than <code>NaN</code>.
     *
     *  @param srcCache The Array of source chart items that are being interpolated.
     *
     *  @param destProps An object containing the destination values
     *  that are being interpolated for a particular item.
     *  When this method exits, all properties in this Object
     *  should have values other than <code>NaN</code>.
     *
     *  @param destCache The Array of destination chart items that are being interpolated.
     *
     *  @param index The index of the item that is being populated in the cache.  
     *
     *  @param customData The data that was passed by the series
     *  into the <code>initializeInterpolationData()</code> method.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function getMissingInterpolationValues(
                            sourceProps:Object, srcCache:Array /* of ChartItem */,
                            destProps:Object, destCache:Array /* of ChartItem */,
                            index:Number, customData:Object):void
    {
    }

    /**
     *  Called by the SeriesInterpolate effect to advance an interpolation.
     *  The effect calls this once per frame until the interpolation
     *  is complete.
     *  The series is responsible for using the parameters
     *  to render the interpolated values.
     *  By default, the series assumes that <code>interpolationData</code>
     *  is a data structure returned by the
     *  <code>initializeInterpolationData()</code> method, and passes it
     *  through to the <code>applyInterpolation()</code> method.
     *
     *  @param interpolationValues An Array of Numbers, each ranging
     *  from 0 to 1, where the <i>n</i>th number indicates the percentage
     *  of the way in which the <i>n</i>th value in the data series should be
     *  interpolated between the start and end values.
     *
     *  @param interpolationData The data returned from the
     *  <code>beginInterpolation()</code> method.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function interpolate(interpolationValues:Array /* of Number */,
                                interpolationData:Object):void
    {
        applyInterpolation(interpolationData, interpolationValues);
    }

    /**
     *  @private
     */
    private function applyInterpolation(interpolationData:Object,
                                        interpolationValues:Array /* of Number */):void
    {       
        var n:int = interpolationValues.length;
        var srcCache:Array /* of ChartItem */ = interpolationData.interpolationSource;
        var deltaCache:Array /* of ChartItem */ = interpolationData.deltaCache;
        var interpolationCache:Array /* of ChartItem */ = interpolationData.cache;
        var iProps:Object = interpolationData.properties;

        n = interpolationCache.length;
        for (var i:int = 0; i < n; i++)
        {
            var interpValue:Number = interpolationValues[i];
            var src:Object = srcCache[i];
            var delta:Object = deltaCache[i];           
            var interp:Object  = interpolationCache[i];
            for (var p:String in iProps)
            {
                interp[p] = src[p] + delta[p] * interpValue;    
            }
        }
    }
    
    /**
     *  Updates the Legend items when the series display name changes
     *  by dispatching a new LegendDataChanged event.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function legendDataChanged():void
    {
        var c:ChartBase = chart;
        if (c)
            c.legendDataChanged();
    }

   /**
     *  Gets a ChartItem from the series'
     *  data provider. Returns null if the specified value is outside
     *  of the bounds of the series' data provider.
     * 
     *  @param value The index of the ChartItem in the series' data provider.
     *  
     *  @return The ChartItem for the specified index.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private function findChartItemFor(value:int):ChartItem
    {
        var items:Array /* of ChartItem */;
        var item:ChartItem = null;
        
        items = (renderData)? renderData.filteredCache : [];
        var n:int = items.length;
        for (var i:int = 0; i < n; i++)
        {
            if (items[i].index == value)
            {
                item = items[i];
                break;
            }
        }
        return item;
    }
    
    /**
     *  This is used if you do not set a custom function as the filterFunction for the series.
     *  Individual series should overwrite this.
     * 
     *  @param cache An array of objects.
     * 
     *  @return An array of objects.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 4
     */ 
    protected function defaultFilterFunction(cache:Array /*of Object*/):Array /*of Object*/
    {
        return [];
    }
    
    /**
     *  You typically retrieve the Axis instance directly through a named property
     *  (such as for a Cartesian-based series <code>horizontalAxis</code>, <code>verticalAxis</code>,
     *  or <code>radiusAxis</code>).
     *  
     *  <p>This is a low-level accessor.</p>
     *  
     *  @param dimension The dimension that you want the axis for.
     *  
     *  @return The Axis instance for a particular dimension of the chart.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getAxis(dimension:String):IAxis
    {
        return dataTransform.getAxis(dimension);
    }

    /**
     *  Assigns an Axis instance to a particular dimension of the chart.
     *  You typically set the Axis instance directly through a named property
     *  (such as for a Cartesian-based series <code>horizontalAxis</code>, <code>verticalAxis</code>,
     *  or <code>radiusAxis</code>).
     *  
     *  <p>This is a low-level accessor.</p>
     *  
     *  @param dimension The dimension of the chart that you want to assign the Axis to.
     *  
     *  @param value The Axis to assign to the chart's dimension.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function setAxis(dimension:String, value:IAxis):void
    {
        dataTransform.setAxis(dimension, value);
    }

    
    //--------------------------------------------------------------------------
    //
    //  Overridden event handlers: ChartElement
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function dataChanged():void
    {
        invalidateData();

        super.dataChanged();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private function transformChangeHandler(event:FlexEvent):void
    {
        invalidateTransform();
    }
    
    /**
     *  The default handler for the <code>dragStart</code> event.
     *
     *  @param event The DragEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 4
     */
    protected function dragStartHandler(event:DragEvent):void
    {
        if(chart)
            chart.dragStartHandler(event);                   
    }
}

}
