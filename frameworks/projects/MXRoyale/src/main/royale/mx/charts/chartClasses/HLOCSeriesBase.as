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

import mx.display.Graphics;
import org.apache.royale.geom.Rectangle;
import mx.charts.DateTimeAxis;
import mx.charts.HitData;
import mx.charts.series.items.HLOCSeriesItem;
import mx.charts.series.renderData.HLOCSeriesRenderData;
import mx.collections.CursorBookmark;
import mx.core.IDataRenderer;
import mx.core.IFactory;
import mx.core.IFlexDisplayObject;
import mx.core.mx_internal;
import mx.graphics.IStroke;
import mx.styles.ISimpleStyleClient;
import mx.resources.IResourceManager;
import mx.charts.series.CandlestickSeries;
import org.apache.royale.geom.Point;
import mx.charts.chartClasses.IAxis;

use namespace mx_internal;

//--------------------------------------
//  Styles
//--------------------------------------

include "../styles/metadata/ItemRendererStyles.as"

//[ResourceBundle("charts")]
    
/**
 *  HLOCSeriesBase is the base class for the two financial series types,
 *  HLOCSeries and CandlestickSeries.
 *  Most of the behavior related to charting open, close, high and low values
 *  resides in this class.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class HLOCSeriesBase extends Series implements IColumn
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
    public function HLOCSeriesBase()
    {
        super();

        _instanceCache = new InstanceCache(null, this);
        _instanceCache.properties = { styleName: this };
        
        dataTransform = new CartesianTransform();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private var _instanceCache:InstanceCache;
    
    /**
     *  @private
     */
    mx_internal var _renderData:HLOCSeriesRenderData;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  closeField
    //----------------------------------

    /**
     *  @private
     *  Storage for the closeField property.
     */
    private var _closeField:String = "";
    
    [Inspectable(category="General")]

    /**
     *  Specifies the field of the data provider that determines
     *  the y-axis location of the closing value of the element.
     *
     *  @default ""
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get closeField():String
    {
        return _closeField;
    }
    
    /**
     *  @private
     */
    public function set closeField(value:String):void
    {
        _closeField = value;

        dataChanged();
    }

    //----------------------------------
    //  columnWidthRatio
    //----------------------------------

    /**
     *  @private
     *  Storage for the columnWidthRatio property.
     */
    private var _columnWidthRatio:Number = 0.65;
    
    [Inspectable(category="General", defaultValue="0.65")]

    /**
     *  Specifies the width of elements relative to the category width.
     *  A value of <code>1</code> uses the entire space, while a value
     *  of <code>0.6</code> uses 60% of the element's available space. 
     *  You typically do not set this property directly. 
     *  The actual element width used is the smaller of the
     *  <code>columnWidthRatio</code> and <code>maxColumnWidth</code>
     *  properties.
     *
     *  @default 0.65.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get columnWidthRatio():Number
    {
        return _columnWidthRatio;
    }       
    
    /**
     *  @private
     */
    public function set columnWidthRatio(value:Number):void
    {
        _columnWidthRatio = value;
        
        invalidateTransform();
    }
    
    //----------------------------------
    //  highField
    //----------------------------------

    /**
     *  @private
     *  Storage for the highField property.
     */
    private var _highField:String = "";
    
    [Inspectable(category="General")]

    /**
     *  Specifies the field of the data provider that determines
     *  the y-axis location of the high value of the element. 
     *
     *  @default ""
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get highField():String
    {
        return _highField;
    }
    
    /**
     *  @private
     */
    public function set highField(value:String):void
    {
        _highField = value;

        dataChanged();
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
    //  items
    //----------------------------------

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function get items():Array /* of HLOCSeriesItem */
    {
        return _renderData ? _renderData.filteredCache : null;
    }

    //----------------------------------
    //  itemType
    //----------------------------------

    /**
     *  The subtype of ChartItem used by this series
     *  to represent individual items.
     *  Subclasses can override and return a more specialized class
     *  if they need to store additional information in the items.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function get itemType():Class
    {
        return HLOCSeriesItem;
    }
    
    //----------------------------------
    //  lowField
    //----------------------------------

    /**
     *  @private
     *  Storage for the lowField property.
     */
    private var _lowField:String = "";
    
    [Inspectable(category="General")]

    /**
     *  Specifies the field of the data provider that determines
     *  the y-axis location of the low value of the element.
     *
     *  @default ""
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get lowField():String
    {
        return _lowField;
    }
    
    /**
     *  @private
     */
    public function set lowField(value:String):void
    {
        _lowField = value;

        dataChanged();
    }

    //----------------------------------
    //  maxColumnWidth
    //----------------------------------

    /**
     *  @private
     *  Storage for the maxColumnWidth property.
     */
    private var _maxColumnWidth:Number;
    
    [Inspectable(category="General")]

    /**
     *  Specifies the width of the elements, in pixels.
     *  The actual element width used is the smaller of this style
     *  and the <code>columnWidthRatio</code> property.
     *  You typically do not set this value directly;
     *  it is assigned by the enclosing chart. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get maxColumnWidth():Number
    {
        return _maxColumnWidth;
    }
    
    /**
     *  @private
     */
    public function set maxColumnWidth(value:Number):void
    {
        _maxColumnWidth = value;
        
        invalidateTransform();
    }

    //----------------------------------
    //  offset
    //----------------------------------

    /**
     *  @private
     *  Storage for the offset property.
     */
    private var _offset:Number = 0;

    [Inspectable(category="General", defaultValue="0")]

    /**
     *  Specifies how far to offset the center of the elements
     *  from the center of the available space,
     *  relative to the category width. 
     *  At the value of default <code>0</code>,
     *  the elements are centered on the space.
     *  Set to <code>-50</code> to center the element
     *  at the beginning of the available space.
     *  You typically do not set this property directly.
     *  The enclosing chart control manages this value based on 
     *  the value of its <code>columnWidthRatio</code> property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get offset():Number
    {
        return _offset;
    }
    
    /**
     *  @private
     */
    public function set offset(value:Number):void
    {
        _offset = value;
        
        invalidateTransform();
    }

    //----------------------------------
    //  openField
    //----------------------------------

    /**
     *  @private
     *  Storage for the openField property.
     */
    mx_internal var _openField:String = "";
    
    [Inspectable(category="General")]

    /**
     *  Specifies the field of the data provider that determines
     *  the y-axis location of the opening value of the element.
     *
     *  @default ""
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get openField():String
    {
        return _openField;
    }
    
    /**
     *  @private
     */
    public function set openField(value:String):void
    {
        _openField = value;

        dataChanged();
    }

    //----------------------------------
    //  renderDataType
    //----------------------------------

    /**
     *  The subtype of ChartRenderData used by this series
     *  to store all data necessary to render.
     *  Subclasses can override and return a more specialized class
     *  if they need to store additional information for rendering.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function get renderDataType():Class
    {
        return HLOCSeriesRenderData;
    }
    
        private var _bAxesDirty:Boolean = false;
    
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
    
    //----------------------------------
    //  xField
    //----------------------------------

    /**
     *  @private
     *  Storage for the xField property.
     */
    private var _xField:String = "";

    [Inspectable(category="General")]

    /**
     *  Specifies the field of the data provider that determines
     *  the x-axis location of the element. 
     *  If set to the empty string (<code>""</code>),
     *  Flex renders the columns in the order they appear in the dataProvider.
     *
     *  @default ""
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get xField():String
    {
        return _xField;
    }
    
    /**
     *  @private
     */
    public function set xField(value:String):void
    {
        _xField = value;

        dataChanged();
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: Series
    //
    //--------------------------------------------------------------------------
                
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function updateData():void
    {
        var renderDataType:Class = this.renderDataType;
        _renderData = new renderDataType();

        _renderData.cache = [];
        var i:int = 0;
        var itemClass:Class = itemType;

        if (cursor)
        {
            cursor.seek(CursorBookmark.FIRST);
            while (!cursor.afterLast)
            {
                _renderData.cache[i] = new itemClass(this, cursor.current, i);
                i++;
                cursor.moveNext();
            }
        }

        cacheIndexValues(_xField, _renderData.cache, "xValue");

        cacheDefaultValues(_highField, _renderData.cache, "highValue");

        cacheNamedValues(_lowField, _renderData.cache, 
        "lowValue");
        if (_openField != "")
            cacheNamedValues(_openField, _renderData.cache, "openValue");
        
        cacheNamedValues(_closeField, _renderData.cache, "closeValue"); 
		if(dataTransform && dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS) is NumericAxis &&
			!(dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS) is DateTimeAxis) && 
        	(dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS) as NumericAxis).direction == "inverted")  
        	_renderData.cache = reverseYValues(_renderData.cache);
        if(dataTransform && dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS) is NumericAxis &&
        	!(dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS) is DateTimeAxis) &&
        	(dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS) as NumericAxis).direction == "inverted")  
        	_renderData.cache = reverseXValues(_renderData.cache);
        super.updateData();
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function updateMapping():void
    {
        dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).
            mapCache(_renderData.cache, "xValue", "xNumber", _xField == "");
        
        var yAxis:IAxis = dataTransform.getAxis(
                            CartesianTransform.VERTICAL_AXIS);
        
        yAxis.mapCache(_renderData.cache, "lowValue", "lowNumber");

        yAxis.mapCache(_renderData.cache, "highValue", "highNumber");
        
        if (_openField != "")
            yAxis.mapCache(_renderData.cache, "openValue", "openNumber");
        
        yAxis.mapCache(_renderData.cache, "closeValue", "closeNumber");

        super.updateMapping();      
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function updateFilter():void
    {
        _renderData.filteredCache = filterFunction(_renderData.cache);
        super.updateFilter();
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function updateTransform():void
    {
        dataTransform.transformCache(_renderData.filteredCache,
                                     "xNumber", "x", "highNumber", "high");
        
        dataTransform.transformCache(_renderData.filteredCache,
                                     null, null, "highNumber", "high");
        
        dataTransform.transformCache(_renderData.filteredCache,
                                     null, null, "lowNumber", "low");
        
        if (_openField != "")
        {
            dataTransform.transformCache(_renderData.filteredCache,
                                         null, null, "openNumber", "open");
        }
        
        dataTransform.transformCache(_renderData.filteredCache,
                                     null, null, "closeNumber", "close");

        var unitSize:Number = dataTransform.getAxis(
                                CartesianTransform.HORIZONTAL_AXIS).unitSize
        
        var params:Array /* of Object */ =
        [
            { xNumber: 0 },
            { xNumber: _columnWidthRatio * unitSize / 2 },
            { xNumber: _offset * unitSize }
        ];

        dataTransform.transformCache(params, "xNumber", "x", null, null);

        _renderData.renderedHalfWidth = params[1].x -  params[0].x;
        
        if (_offset == 0)
            _renderData.renderedXOffset = 0;
        else
            _renderData.renderedXOffset = params[2].x -  params[0].x;
        
        if (!isNaN(_maxColumnWidth) &&
            _maxColumnWidth < _renderData.renderedHalfWidth)
        {
            _renderData.renderedXOffset *= _maxColumnWidth /
                                           _renderData.renderedHalfWidth;

            _renderData.renderedHalfWidth = _maxColumnWidth;
        }

        super.updateTransform();
        allSeriesTransform = true;
            
        if (chart && chart is CartesianChart)
        {   
            var cChart:CartesianChart = CartesianChart(chart);  
            var n:int = cChart.series.length;
           
            
            for (var i:int = 0; i < n; i++)
            {
                if (cChart.getSeriesTransformState(cChart.series[i]))
                    allSeriesTransform = false;
            }
        
         	if (allSeriesTransform)
                cChart.measureLabels();
        }   
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
        
        var c:CartesianChart = CartesianChart(chart);
        if (c)
        {
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

        if (!dataTransform)
            return;
            
        var g:Graphics = graphics;
        g.clear();

        if (!isNaN(_maxColumnWidth) &&
            (_maxColumnWidth <= 0 || _columnWidthRatio <= 0))
        {
            return;
        }

        var renderData:HLOCSeriesRenderData =
            transitionRenderData == null ?
            _renderData :
            HLOCSeriesRenderData(transitionRenderData);

        var renderCache:Array /* of HLOCSeriesItem */ = renderData.filteredCache;

        var i:int;
        var sampleCount:int = renderCache.length; 
        var rc:Rectangle;
        var instances:Array /* of IFlexDisplayObject */;
        var inst:IFlexDisplayObject;
        var v:HLOCSeriesItem;
        
        _instanceCache.factory = getStyle("itemRenderer");
        _instanceCache.count = sampleCount;         
        instances = _instanceCache.instances;
        
        var bSetData:Boolean = sampleCount > 0 &&
                               (instances[0] is IDataRenderer);

        if (transitionRenderData &&
            transitionRenderData.elementBounds)
        {
            var elementBounds:Array /* of Rectangle */ = transitionRenderData.elementBounds;

            for (i = 0; i < sampleCount; i++)
            {
                inst = instances[i];
                
                v = renderCache[i];
                v.itemRenderer = inst;
                if (this is CandlestickSeries)
                {
                    v.fill = CandlestickSeries(this).fillFunction(v,i);
                    if (!(v.fill))
                        v.fill = CandlestickSeries(this).defaultFillFunction(v,i);
                    if ((v.itemRenderer as Object).hasOwnProperty('invalidateDisplayList'))
                        (v.itemRenderer as Object).invalidateDisplayList();
                }
                if (bSetData)
                    (inst as IDataRenderer).data = v;
                
                rc = elementBounds[i];
                inst.move(rc.left, rc.top);
                inst.setActualSize(rc.width, rc.height);
            }
        }
        else
        {
            var ro:Number = renderData.renderedHalfWidth +
                            renderData.renderedXOffset;

            var lo:Number = -renderData.renderedHalfWidth +
                            renderData.renderedXOffset;

            rc = new Rectangle();
            var considerOpen:Boolean = _openField != "";
            
            for (i = 0; i < sampleCount; i++)
            {
                v = renderCache[i];

                rc.left = v.x + lo;
                rc.right = v.x + ro;
                rc.top = Math.min(v.high,Math.min(v.low,v.close));
                if (considerOpen)
                    rc.top = Math.min(rc.top,v.open);
                rc.bottom = Math.max(v.high,Math.max(v.low,v.close));
                if (considerOpen)
                    rc.bottom = Math.max(rc.bottom,v.close);

                inst = instances[i];
                v.itemRenderer = inst;
                if (this is CandlestickSeries)
                {
                    v.fill = CandlestickSeries(this).fillFunction(v,i);
                    if (!(v.fill))
                        v.fill = CandlestickSeries(this).defaultFillFunction(v,i);
                    if ((v.itemRenderer as Object).hasOwnProperty('invalidateDisplayList'))
                        (v.itemRenderer as Object).invalidateDisplayList();
                }
                if (bSetData)
                    (inst as IDataRenderer).data = v
                inst.move(rc.left,rc.top);
                inst.setActualSize(rc.width,rc.height);
            }
            if (chart && allSeriesTransform && chart.chartState == 0)
                chart.updateAllDataTips();
        }
        
    }

    /**
     *  @private
     */
    override public function dataToLocal(... dataValues):Point
    {
        var data:Object = {};
        var da:Array /* of Object */ = [ data ];
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
    override public function localToData(v:Point):Array /* of Object */
    {
        var values:Array /* of Object */ = dataTransform.invertTransform(
                                            v.x - this.x,
                                            v.y - this.y);
        return values;
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
     
    override public function getItemsInRegion(r:Rectangle):Array /* of HLOCSeriesItem */
    {
        if (interactive == false || !_renderData)
            return [];
        
        var arrItems:Array /* of HLOCSeriesItem */ = []; 
        var rc:Rectangle = new Rectangle();
        var localRectangle:Rectangle = new Rectangle();
        var n:uint = _renderData.filteredCache.length;
        var considerOpen:Boolean = _openField != "";
        
        localRectangle.topLeft = globalToLocal(r.topLeft);
        localRectangle.bottomRight = globalToLocal(r.bottomRight);
        
        for (var i:int=0; i < n; i++)
        {
            var v:HLOCSeriesItem = _renderData.filteredCache[i];

            var ro:Number = renderData.renderedHalfWidth + renderData.renderedXOffset;
            var lo:Number = -renderData.renderedHalfWidth + renderData.renderedXOffset;

            rc.left = v.x + lo;
            rc.right = v.x + ro;
            rc.top = Math.min(v.high,Math.min(v.low,v.close));
            if (considerOpen)
                rc.top = Math.min(rc.top,v.open);
            rc.bottom = Math.max(v.high,Math.max(v.low,v.close));
            if (considerOpen)
                rc.bottom = Math.max(rc.bottom,v.close);
            
            // Handle cases when width and height are -ve.
            if (rc.right < rc.left || rc.bottom < rc.top)
            {
                var rcTemp:Rectangle = new Rectangle(rc.x,rc.y,rc.width,rc.height);
                if (rc.right < rc.left)
                {
                    rcTemp.left = rc.right;
                    rcTemp.right = rc.left;
                }
                if (rc.bottom < rc.top)
                {
                    rcTemp.top = rc.bottom;
                    rcTemp.bottom = rc.top;
                }
                rc = rcTemp;
            }   
            if (rc.intersects(localRectangle))
                arrItems.push(v);
        }
        return arrItems;
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function describeData(dimension:String,
                                          requiredFields:uint):Array /* of DataDescription */
    {
        validateData();

        if (_renderData.cache.length == 0)
            return [];

        var description:DataDescription = new DataDescription();
        description.boundedValues = null;

        if (dimension == CartesianTransform.VERTICAL_AXIS)
        {
            extractMinMax(_renderData.cache, "highNumber", description);
            extractMinMax(_renderData.cache, "lowNumber", description);
        }
        else if (dimension == CartesianTransform.HORIZONTAL_AXIS)
        {
            if (_xField != "")
            {
                if ((requiredFields &
                     DataDescription.REQUIRED_MIN_INTERVAL) != 0)
                {
                    // If we need to know the min interval,
                    // then we rely on the cache being in order.
                    // So we need to sort it if it hasn't already been sorted.
                    var sortedCache:Array /* of HLOCSeriesItem */ = _renderData.cache.concat();
                    sortedCache.sortOn("xNumber", Array.NUMERIC);       
                    extractMinMax(sortedCache, "xNumber", description,
                                  (requiredFields &
                                   DataDescription.REQUIRED_MIN_INTERVAL) != 0);
                }
                else
                {
                    extractMinMax(_renderData.cache, "xNumber", description,
                                  (requiredFields &
                                   DataDescription.REQUIRED_MIN_INTERVAL) != 0);
                }
            }
            else 
            {
                description.min = _renderData.cache[0].xNumber;
                description.max =
                    _renderData.cache[_renderData.cache.length - 1].xNumber;
                if ((requiredFields &
                     DataDescription.REQUIRED_MIN_INTERVAL) != 0)
                {
                    extractMinInterval(_renderData.cache, "xNumber",
                                       description);
                }
            }

            description.padding = 0.5;
        }
        else
        {
            return [];
        }
            
        return [ description ];
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function get legendData():Array /* of LegendData */
    {
        var ld:LegendData = new LegendData();
        var marker:IFlexDisplayObject;
        
        ld.element = this;
        
        var markerClass:IFactory = getStyle("legendMarkerRenderer");
        if (!markerClass)
            markerClass = getStyle("itemRenderer");
        
        if (markerClass) 
        {
            marker = markerClass.newInstance();
            if (marker as ISimpleStyleClient)
                (marker as ISimpleStyleClient).styleName = this;
        }

        ld.marker = marker;
        ld.label = displayName;

        return [ ld ];
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function styleChanged(styleProp:String):void
    {
        super.styleChanged(styleProp);
        
        var styles:String = "stroke fill";
        if (styleProp == null ||
            styleProp == "" ||
            styles.indexOf(styleProp) != -1)
        {
            invalidateDisplayList();
            legendDataChanged();
        }
        if (styleProp == "itemRenderer")
        {
            _instanceCache.remove = true;
            _instanceCache.discard = true;
            _instanceCache.count = 0;
            _instanceCache.discard = false;
        	_instanceCache.remove = false;
        }
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function get renderData():Object
    {
        if (!_renderData)
        {
            var renderDataType:Class = this.renderDataType;
            var rv:HLOCSeriesRenderData = new renderDataType();
            
            rv.cache = rv.filteredCache = [];
            rv.renderedHalfWidth = 0;
            rv.renderedXOffset = 0;
            
            return rv;
        }

        return _renderData;
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function beginInterpolation(sourceRenderData:Object,
                                                destRenderData:Object):Object
    {
        var interpFields:Object =
            { x: true, high: true, low: true, close: true };
        
        if (_openField != "")
            interpFields.open = true;
        
        var idata:Object = initializeInterpolationData(
            sourceRenderData.cache, destRenderData.cache,
            interpFields, itemType,
            { sourceRenderData: sourceRenderData,
              destRenderData: destRenderData });

        var interpolationRenderData:HLOCSeriesRenderData =
            HLOCSeriesRenderData(destRenderData.clone());

        interpolationRenderData.cache = idata.cache;    
        interpolationRenderData.filteredCache = idata.cache;    

        transitionRenderData = interpolationRenderData;
        
        return idata;
    }
    
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function getMissingInterpolationValues(
                                    sourceProps:Object, srcCache:Array /* of HLOCSeriesItem */,
                                    destProps:Object, destCache:Array /* of HLOCSeriesItem */,
                                    index:Number, customData:Object):void
    {
        for (var p:String in sourceProps)
        {
            var src:Number = sourceProps[p];
            var dst:Number = destProps[p];

            if (p == "high" || p == "low" ||
                p == "open" || p == "close")
            {
                if (isNaN(src))
                    src = unscaledHeight;
                if (isNaN(dst))
                    dst = unscaledHeight;
            }
            else if (p == "x")
            {
                if (isNaN(src))
                    src = dst;
                if (isNaN(dst))
                    dst = src;
            }

            sourceProps[p] = src;
            destProps[p] = dst;
        }       
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function getElementBounds(renderData:Object):void
    {
        var cache :Array /* of HLOCSeriesItem */ = renderData.filteredCache;
        var rb :Array /* of Rectangle */ = [];
        var sampleCount:int = cache.length;     

        if (sampleCount)
        {
            var ro:Number = renderData.renderedHalfWidth +
                            renderData.renderedXOffset;

            var lo:Number = -renderData.renderedHalfWidth +
                            renderData.renderedXOffset;
    
            var v:HLOCSeriesItem = cache[0];
            var maxBounds:Rectangle = new Rectangle(v.x, v.low, 0, 0);
            
            for (var i:int = 0; i < sampleCount; i++)
            {
                v = cache[i];
                
                var top:Number = Math.min(v.high, v.low);
                
                var b:Rectangle = new Rectangle(
                    v.x + lo, top, ro - lo, Math.max(v.high, v.low) - top);
                
                maxBounds.left = Math.min(maxBounds.left, b.left);
                maxBounds.top = Math.min(maxBounds.top, b.top);
                maxBounds.right = Math.max(maxBounds.right, b.right);
                maxBounds.bottom = Math.max(maxBounds.bottom, b.bottom);
                
                rb[i] = b;
            }
        }
        else
        {
            maxBounds = new Rectangle();            
        }
        
        renderData.elementBounds = rb;
        renderData.bounds =  maxBounds;
    }    
    
    /**
     * @private
     */ 
    override protected function defaultFilterFunction(cache:Array /*of HLOCSeriesItem */ ):Array /*of HLOCSeriesItem*/
    {
    	var filteredCache:Array /*of HLOCSeriesItem*/ = [];
    	if (filterDataValues == "outsideRange")
        {
            filteredCache = cache.concat();

            dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).
                filterCache(filteredCache, "xNumber", "xFilter");
            
            var yAxis:IAxis = dataTransform.getAxis(
                                CartesianTransform.VERTICAL_AXIS);
            
            yAxis.filterCache(filteredCache,
                              "lowNumber", "lowFilter");
            
            yAxis.filterCache(filteredCache,
                              "highNumber", "highFilter");
            
            if (_openField != "")
            {
                yAxis.filterCache(filteredCache,
                                  "openNumber", "openFilter");
            }
            
            yAxis.filterCache(filteredCache,
                              "closeNumber", "closeFilter");

            stripNaNs(filteredCache, "xFilter");

            stripNaNs(filteredCache, "lowFilter");

            stripNaNs(filteredCache, "highFilter");
            
            if (_openField != "")
                stripNaNs(filteredCache, "openFilter");
            
            stripNaNs(filteredCache, "closeFilter");
        }
        else if (filterDataValues == "nulls")
        {
        	filteredCache = cache.concat();
        	
        	stripNaNs(filteredCache, "xNumber");

            stripNaNs(filteredCache, "lowNumber");

            stripNaNs(filteredCache, "highNumber");
            
            if (_openField != "")
                stripNaNs(filteredCache, "openNumber");
            
            stripNaNs(filteredCache, "closeNumber");
        }
        else if (filterDataValues == "none")
        {
            filteredCache = cache;
        }
        return filteredCache;        
    }
    
    //-------------------------------------------------------------------------------
    //
    // Methods
    //
    //-------------------------------------------------------------------------------
    /** 
     *  Generates a text description of a ChartItem
     *  suitable for display as a DataTip.
     *  
     *  @param hd The HitData for the ChartItem.
     *  
     *  @return The item's DataTip.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function formatDataTip(hd:HitData):String
    {
        var openString:String = resourceManager.getString("charts", "open"); 
        var closeString:String = resourceManager.getString("charts", "close"); 
        var highString:String = resourceManager.getString("charts", "high"); 
        var lowString:String = resourceManager.getString("charts", "low"); 

        var dt:String = "";
        var n:String = displayName;
        if (n != null && n.length>0)
            dt += "<B>" + n + "</B><BR/>";
        
        var xName:String = dataTransform.getAxis(
            CartesianTransform.HORIZONTAL_AXIS).displayName;
        
        if (xName != "")
            dt += "<I>" + xName + ":</I> ";
        
        dt += dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).
              formatForScreen(HLOCSeriesItem(hd.chartItem).xValue) + "\n";

        var yName:String = dataTransform.getAxis(
            CartesianTransform.VERTICAL_AXIS).displayName;

        if (_openField != "")
        {
            if (yName != "")
                dt += "<I>" + yName + " (" + openString + "):</I> ";
            else
                dt += "<I>" + openString + ":</I> ";
            
            dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).
                  formatForScreen(HLOCSeriesItem(hd.chartItem).openValue) + "\n";
        }
        
        if (yName != "")
            dt += "<I>" + yName + " (" + closeString + "):</I> ";
        else
            dt += "<I>" + closeString + ":</I> ";
        
        dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).
              formatForScreen(HLOCSeriesItem(hd.chartItem).closeValue) + "\n";

        if (yName != "")
            dt += "<I>" + yName + " (" + highString + "):</I> ";
        else
            dt += "<I>" + highString + ":</I> ";
        
        dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).
              formatForScreen(HLOCSeriesItem(hd.chartItem).highValue) + "\n";

        if (yName != "")
            dt += "<I>" + yName + " (" + lowString + "):</I> ";
        else
            dt += "<I>" + lowString + ":</I> ";
        
        dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).
              formatForScreen(HLOCSeriesItem(hd.chartItem).lowValue) + "\n";
        
        return dt;
    }
    
    private function reverseYValues(cache:Array):Array
    {
    	var i:int = 0;
        var n:int = cache.length;
        for(i = 0; i < n ; i++)
        {
        	cache[i]["highValue"] = -(cache[i]["highValue"]);
        	cache[i]["lowValue"] = -(cache[i]["lowValue"]);
        	if(_openField != "")
        		cache[i]["openValue"] = -(cache[i]["openValue"]);
        	cache[i]["closeValue"] = -(cache[i]["closeValue"]);
        }  
    	return cache;
    }
    
     private function reverseXValues(cache:Array):Array
    {
    	var i:int = 0;
        var n:int = cache.length;
        for(i = 0; i < n ; i++)
        {
        	cache[i]["xValue"] = -(cache[i]["xValue"]);
        }  
    	return cache;
    }
}

}
