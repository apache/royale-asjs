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

package mx.charts.series
{

import mx.charts.HitData;
import mx.charts.chartClasses.CartesianTransform;
import mx.charts.chartClasses.GraphicsUtilities;
import mx.charts.chartClasses.HLOCSeriesBase;
import mx.charts.chartClasses.NumericAxis;
import mx.charts.renderers.CandlestickItemRenderer;
import mx.charts.series.items.HLOCSeriesItem;
import mx.charts.styles.HaloDefaults;
import mx.core.ClassFactory;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.graphics.IFill;
import mx.graphics.IStroke;
import mx.graphics.SolidColor;
import mx.graphics.SolidColorStroke;
import mx.graphics.Stroke;
import mx.styles.CSSStyleDeclaration;

use namespace mx_internal;

include "../styles/metadata/FillStrokeStyles.as"

/**
 *  Sets the stroke style used to outline the box defining the open-close region of the series.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="boxStroke", type="mx.graphics.IStroke", inherit="no")]

/**
 *  Sets the declining fill for this data series, used when the closing value of an element is less than the opening value. You can specify either an object implementing the IFill interface, 
 *  or a number representing a solid color value. You can also specify a solid fill using CSS. 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="declineFill", type="mx.graphics.IFill", inherit="no")]

/**
 *  Specifies an Array of fill objects that define the fill for
 *  each item in the series. This takes precedence over the <code>fill</code> style property.
 *  If a custom method is specified by the <code>fillFunction</code> property, that takes precedence over this Array.
 *  If you do not provide enough Array elements for every item,
 *  Flex repeats the fill from the beginning of the Array.
 *  
 *  <p>To set the value of this property using CSS:
 *   <pre>
 *    CandlestickSeries {
 *      fills:#CC66FF, #9966CC, #9999CC;
 *    }
 *   </pre>
 *  </p>
 *  
 *  <p>To set the value of this property using MXML:
 *   <pre>
 *    &lt;mx:CandlestickSeries ... &gt;
 *     &lt;mx:fills&gt;
 *      &lt;mx:SolidColor color="0xCC66FF"/&gt;
 *      &lt;mx:SolidColor color="0x9966CC"/&gt;
 *      &lt;mx:SolidColor color="0x9999CC"/&gt;
 *     &lt;/mx:fills&gt;
 *    &lt;/mx:CandlestickSeries&gt;
 *   </pre>
 *  </p>
 *  
 *  <p>
 *  If you specify the <code>fills</code> property and you
 *  want to have a Legend control, you must manually create a Legend control and 
 *  add LegendItems to it.
 *  </p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="fills", type="Array", arrayType="mx.graphics.IFill", inherit="no")]

/**
 *  Represents financial data as a series of candlesticks representing the high, low, opening, and closing values of a data series.
 *  The top and bottom of the vertical line in each candlestick represent the high and low values for the datapoint, while the top and bottom of the filled box represent
 *  the opening and closing values. Each candlestick is filled differently depending on whether the closing value for the datapoint is higher or lower than the opening value.
 *
 *  @mxml
 *  <p>
 *  The <code>&lt;mx:CandlestickSeries&gt;</code> tag inherits all the properties of its parent classes, and 
 *  the following properties:
 *  </p>
 *  <pre>
 *  &lt;mx:CandlestickSeries
 *    <strong>Properties</strong>
 *    fillFunction="<i>Internal fill function</i>"
 * 
 *    <strong>Styles</strong>
 *    boxStroke="<i>IStroke; no default</i>"
 *    declineFill="<i>IFill; no default</i>"
 *    fill="<i>IFill; no default</i>"
 *    fills="<i>IFill; no default</i>"
 *    stroke="<i>IStroke; no default</i>"  
 *  /&gt;
 *  </pre>
 *  
 *  @see mx.charts.CandlestickChart
 *  
 *  @includeExample ../examples/CandlestickChartExample.mxml
 *  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class CandlestickSeries extends HLOCSeriesBase
{
//    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class initialization
    //
    //--------------------------------------------------------------------------


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
    public function CandlestickSeries()
    {
        super();

        // our style settings
        initStyles();
    }
    //--------------------------------------------------------------------------
    //
    // Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
//    private static var _moduleFactoryInitialized:Dictionary = new Dictionary(true); 

    /**
     * @private
     */
    private var _localFills:Array /* of IFill */;

        
    /**
     * @private
     */
    private var _fillCount:int;

    //---------------------------------------------------------------------------
    //
    // Properties
    //
    //---------------------------------------------------------------------------
    
    
    //-----------------------------------
    // fillFunction
    //-----------------------------------
    [Bindable]
    [Inspectable(category="General")]
    
    /**
     * @private
     * Storage for fillFunction property
     */
    private var _fillFunction:Function=defaultFillFunction;
    
    /**
     * Specifies a method that returns the fill for the current chart item in the series.
     * If this property is set, the return value of the custom fill function takes precedence over the 
     * <code>fill</code> and <code>fills</code> style properties.
     * But if it returns null, then <code>fills</code> and <code>fill</code> will be 
     * prefered in that order.  
     * 
     * <p>The custom <code>fillFunction</code> has the following signature:
     *  
     * <pre>
     * <i>function_name</i> (item:ChartItem, index:Number):IFill { ... }
     * </pre>
     * 
     * <code>item</code> is a reference to the chart item that is being rendered.
     * <code>index</code> is the index of the chart item in the renderData's cache. This is different
     * from the index of the chart's data provider because it is sorted based on the x, y, and z values.
     * This function returns an object that implements the <code>IFill</code> interface.
     * </p>
     *  
     * <p>An example usage of a customized <code>fillFunction</code> is to return a fill
     * based on some threshold.</p>
     *   
     * @example
     * <pre>
     * public function myFillFunction(item:ChartItem, index:Number):IFill {
     *      var curItem:HLOCSeriesItem = HLOCSeriesItem(item);
     *      if (curItem.closeNumber > 10)
     *          return(new SolidColor(0x123456, .75));
     *      else
     *          return(new SolidColor(0x563412, .75));
     * }
     * </pre>
     *   
     * <p>
     *  If you specify a custom fill function for your chart series and you
     *  want to have a Legend control, you must manually create a Legend control and 
     *  add LegendItems to it.
     *  </p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get fillFunction():Function
    {
        return _fillFunction;
    }
    
    /**
     * @private
     */
    public function set fillFunction(value:Function):void
    {
        if (value==_fillFunction)
            return;
            
        if (value != null)
            _fillFunction = value;
        
        else
            _fillFunction = defaultFillFunction;
        
        invalidateDisplayList();
        legendDataChanged();        
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------   
    
    /**
     *  @private
     */
    private function initStyles():void
    {
        HaloDefaults.init(styleManager);

		var csSeriesStyle:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, "mx.charts.series.CandlestickSeries");


		if (csSeriesStyle)
		{
			csSeriesStyle.setStyle("boxStroke", new SolidColorStroke(0,0));
			csSeriesStyle.setStyle("declineFill", new SolidColor(0));
			csSeriesStyle.setStyle("itemRenderer", new ClassFactory(mx.charts.renderers.CandlestickItemRenderer));
			csSeriesStyle.setStyle("fill", new SolidColor(0xFFFFFF));
			csSeriesStyle.setStyle("fills", []);
			csSeriesStyle.setStyle("stroke", new SolidColorStroke(0,0));
		}
        else
        {
            //Fallback to set the style to this chart directly.
			setStyle("boxStroke", new SolidColorStroke(0,0));
			setStyle("declineFill", new SolidColor(0));
			setStyle("itemRenderer", new ClassFactory(mx.charts.renderers.CandlestickItemRenderer));
			setStyle("fill", new SolidColor(0xFFFFFF));
			setStyle("fills", []);
			setStyle("stroke", new SolidColorStroke(0,0));
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
    override public function set moduleFactory(factory:IFlexModuleFactory):void
    {
        super.moduleFactory = factory;
        
        /*
        if (_moduleFactoryInitialized[factory])
            return;
        
        _moduleFactoryInitialized[factory] = true;
        */
    }
    
    /**
     *  @private
     */
    override public function getAllDataPoints():Array /* of HitData */
    {
        if (!_renderData)
            return [];
        if (!(_renderData.filteredCache))
            return [];
        
        var itemArr:Array /* of CandlestickSeriesItem */ = [];
        if (chart && chart.dataTipItemsSet && dataTipItems)
            itemArr = dataTipItems;
        else if (chart && chart.showAllDataTips && _renderData.filteredCache)
            itemArr = _renderData.filteredCache;
        else
            itemArr = [];
        
        var n:uint = itemArr.length;
        var i:uint;
        var result:Array /* of HitData */ = [];
        
        for (i = 0; i < n; i++)
        {
            var v:HLOCSeriesItem = itemArr[i];
            if (_renderData.filteredCache.indexOf(v) == -1)
            {
                var itemExists:Boolean = false;
                var m:int  = _renderData.filteredCache.length;
                for (var j:int = 0; j < m; j++)
                {
                    if (v.item == _renderData.filteredCache[j].item)
                    {   
                        v = _renderData.filteredCache[j];
                        itemExists = true;
                        break;
                    }
                }
                if (!itemExists)
                    continue;
            }
            if (v)
            {
                var ypos:Number = (v.open + v.close)/2;
                var id:uint = v.index;
                var hd:HitData = new HitData(createDataID(id),Math.sqrt(0),v.x + _renderData.renderedXOffset,ypos,v);
                var f:Object = getStyle("declineFill");
            
                hd.contextColor = GraphicsUtilities.colorFromFill(HLOCSeriesItem(hd.chartItem).fill);
            
                hd.dataTipFunction = formatDataTip;
                result.push(hd);
            }
        }
        return result;
    }
    
    /* 
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
     *  @param sensitivity The maximum distance from the data point that the
     *  x/y coordinate location can be.
     *
     *  @return A HitData object describing the nearest data point
     *  within <code>sensitivity</code> pixels.
     *
     *  @see mx.charts.HitData
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function findDataPoints(x:Number,y:Number,sensitivity:Number):Array /* of HitData */
    {
        // esg, 8/7/06: if your mouse is over a series when it gets added and displayed for the first time, this can get called
        // before updateData, and before and render data is constructed. The right long term fix is to make sure a stubbed out 
        // render data is _always_ present, but that's a little disruptive right now.
        if (interactive == false || !_renderData)
            return [];
            
            
        
        var minDist:Number = _renderData.renderedHalfWidth + sensitivity;
        var minItem:HLOCSeriesItem;     

        var n:uint = _renderData.filteredCache.length;
        var i:uint;
        
        for (i = 0; i < n; i++)
        {
            var v:HLOCSeriesItem = _renderData.filteredCache[i];
            
            var dist:Number = Math.abs((v.x + _renderData.renderedXOffset) - x);
            if (dist > minDist)
                continue;
                
                

            var lowValue:Number = Math.max(v.low,Math.max(v.high,v.close));
            var highValue:Number = Math.min(v.low,Math.min(v.high,v.close));
            if (!isNaN(v.open)) 
            {
                lowValue = Math.max(lowValue,v.open);
                highValue = Math.min(highValue,v.open);
            }

            if (highValue - y > sensitivity)
                continue;

            if (y - lowValue > sensitivity)
                continue;

                
            minDist = dist;
            minItem = v;
            if (dist < _renderData.renderedHalfWidth)
            {
                // we're actually inside the column, so go no further.
                break;
            }
        }

        if (minItem)
        {
            var ypos:Number = (minItem.open + minItem.close)/2;
            var id:uint = minItem.index;
            var hd:HitData = new HitData(createDataID(id),Math.sqrt(minDist),minItem.x + _renderData.renderedXOffset,ypos,minItem);
            var f:Object = getStyle("declineFill");
            
            hd.contextColor = GraphicsUtilities.colorFromFill(HLOCSeriesItem(hd.chartItem).fill);
            
            hd.dataTipFunction = formatDataTip;
            return [hd];
        }
        return [];
    }
    
    
    /**
     *  @private
     */
    override public function stylesInitialized():void
    {
        _localFills = getStyle('fills');
        if (_localFills != null)
            _fillCount = _localFills.length;
        else
            _fillCount = 0;
        super.stylesInitialized();
    }
    
    /**
     *  @private
     */
    override public function styleChanged(styleProp : String) : void
    {
        super.styleChanged(styleProp);
        var styles:String = "fills"
        if (styles.indexOf(styleProp)!=-1)
        {
            _localFills = getStyle('fills');
            if (_localFills != null)
                _fillCount = _localFills.length;
            else
                _fillCount = 0;                
            invalidateDisplayList();
            legendDataChanged();
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    /**
     * @private
     */
    mx_internal function defaultFillFunction(element:HLOCSeriesItem,i:Number):IFill
    {
        if (_fillCount!=0)
        {
          return(GraphicsUtilities.fillFromStyle(_localFills[i % _fillCount]));
        }
        var item:HLOCSeriesItem = HLOCSeriesItem(element);
        var a:Number;
        var b:Number;
        
        if(dataTransform && dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS) is NumericAxis &&
            (dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS) as NumericAxis).direction == "inverted")
        {
            a = item.open;
            b = item.close;
        }
        else
        {
            a = item.close;
            b = item.open;
        }
        if (a > b)
            return(GraphicsUtilities.fillFromStyle(getStyle("declineFill")));
        else
            return(GraphicsUtilities.fillFromStyle(getStyle("fill")));
    }

}

}
