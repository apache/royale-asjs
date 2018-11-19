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

import mx.core.UIComponent;
//import flash.filters.DropShadowFilter;
import org.apache.royale.reflection.getDefinitionByName;

import mx.charts.chartClasses.CartesianChart;
import mx.charts.chartClasses.CartesianTransform;
import mx.charts.chartClasses.DataTip;
import mx.charts.chartClasses.DataTransform;
import mx.charts.chartClasses.IChartElement;
import mx.charts.chartClasses.NumericAxis;
import mx.charts.chartClasses.Series;
import mx.charts.series.BarSeries;
import mx.charts.series.BarSet;
import mx.charts.series.items.BarSeriesItem;
import mx.charts.styles.HaloDefaults;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.graphics.SolidColor;
import mx.graphics.SolidColorStroke;
import mx.graphics.Stroke;
import mx.styles.CSSStyleDeclaration;

use namespace mx_internal;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  Specifies how wide to draw the bars relative to the category width,
 *  as a percentage in the range of 0 to 1. 
 *  A value of 1 uses the entire space, while a value of 0.6
 *  uses 60% of the bar's available space.  
 *  The actual bar width used is the smaller of the
 *  <code>barWidthRatio</code> property and the
 *  <code>maxbarWidth</code> property
 *  Clustered bars divide this space proportionally
 *  among the bars in each cluster.
 *  The default value is 0.65.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="barWidthRatio", type="Number", inherit="no")]

/**
 *  Specifies how wide to draw the bars, in pixels.
 *  The actual bar width used is the smaller of this property
 *  and the <code>barWidthRatio</code> property.
 *  Clustered bars divide this space proportionally
 *  among the bars in each cluster. 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="maxBarWidth", type="Number", format="Length", inherit="no")]

/**
 *  The class that is used by this component to render labels.
 *
 *  <p>It can be set to either the mx.controls.Label class
 *  or the spark.components.Label class.</p>
 *
 *  @default spark.components.Label
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.0
 *  @productversion Flex 4
 */
[Style(name="labelClass", type="Class", inherit="no")]

//--------------------------------------
//  Other metadata
//--------------------------------------

[DefaultBindingProperty(destination="dataProvider")]

[DefaultTriggerEvent("itemClick")]

//[IconFile("BarChart.png")]

/**
 *  The BarChart control represents data as a series of horizontal bars
 *  whose length is determined by values in the data.
 *  A BarChart control can represent different chart variations,
 *  including simple bars, clustered bars, stacked, 100% stacked, and high/low.
 *  
 *  <p>The BarChart control expects its <code>series</code> property
 *  to contain an array of BarSeries objects.</p>
 *  
 *  <p>Stacked and 100% bar charts override the <code>minField</code>
 *  property of their BarSeries objects.</p>
 *
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:BarChart&gt;</code> tag inherits all the properties
 *  of its parent classes, and adds the following properties:</p>
 *  
 *  <pre>
 *  &lt;mx:BarChart
 *    <strong>Properties</strong>
 *    type="clustered|overlaid|stacked|100%"
 *    
 *    <strong>Styles</strong>
 *    barWidthRatio=".65"
 *    maxBarWidth="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *  
 *  @includeExample examples/Column_BarChartExample.mxml
 *  
 *  @see mx.charts.series.BarSeries
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class BarChart extends CartesianChart
{
//    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class initialization
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private static var INVALIDATING_STYLES:Object =
    {
        barWidthRatio: 1,
        maxBarWidth: 1
    }
    
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
    public function BarChart()
    {
        super();

        LinearAxis(verticalAxis).autoAdjust = false;

        dataTipMode = "single";

        seriesFilters = [ /*new DropShadowFilter(2, 45, 0.2 * 0xFFFFFF)*/];
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
//    private static var _moduleFactoryInitialized:Dictionary = new Dictionary(true);
    
    /**
     *  @private
     */
    private var _perSeriesBarWidthRatio:Number;
    
    /**
     *  @private
     */
    private var _perSeriesMaxBarWidth:Number;
    
    /**
     *  @private
     */
    private var _rightOffset:Number;
    
    /**
     *  @private
     */
    private var _wasStacked:Boolean = false;
    
    /**
     * @private
     */
    mx_internal var allLabelsMeasured:Boolean = false;
    
    /**
     * @private
     */
    private var _allItems:Array /* of ChartItem */ = [];
    
    /**
     * @private
     */
    private var _barSeriesLen:Number;
    
    /**
     * @private
     */
    private var _needLabels:Boolean = false;
    
    /**
     * @private
     */
    private var _tempField:Object; 
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  type
    //----------------------------------

    /**
     *  @private
     *  Storage for the type property.
     */
    private var _type:String = "clustered";

    [Inspectable(category="General", enumeration="stacked,100%,clustered,overlaid", defaultValue="clustered")]

    /**
     *  The type of bar chart to render. Possible values are:    
     *  <ul>
     *    <li><code>"clustered"</code>:
     *    Bars are grouped by category.
     *    This is the default value.</li>
     *  
     *    <li><code>"overlaid"</code>:
     *    Multiple bars are rendered on top of each other by category,
     *    with the last series specified on top.</li>
     *  
     *    <li><code>"stacked"</code>:
     *    Bars are stacked end to end and grouped by category.
     *    Each bar represents the cumulative value of the values beneath it.</li>
     *  
     *    <li><code>"100%"</code>:
     *    Bars are stacked end to end, adding up to 100%.
     *    Each bar represents the percent that it contributes
     *    to the sum of the values for that category.</li>
     *  </ul>
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
        _type = value;

        invalidateSeries();
        invalidateData();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private function initStyles():Boolean
    {
        HaloDefaults.init(styleManager);
		var barChartStyle:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, "mx.charts.BarChart");
		if (barChartStyle)
		{
			barChartStyle.setStyle("chartSeriesStyles", HaloDefaults.chartBaseChartSeriesStyles);
			barChartStyle.setStyle("fill", new SolidColor(0xFFFFFF, 0));
			barChartStyle.setStyle("calloutStroke", new SolidColorStroke(0x888888,2));
			barChartStyle.setStyle("horizontalAxisStyleNames", ["blockNumericAxis"]);
			barChartStyle.setStyle("verticalAxisStyleNames", ["blockCategoryAxis"]);
		}
		
        return true;
    }

    
    /**
     *   A module factory is used as context for using embedded fonts and for finding the style manager that controls the styles for this component.
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
        
        // our style settings
        initStyles();
    }
    
    /**
     * @private
     */
    override protected function createChildren():void
    {
        super.createChildren();
        var labelClass:Class = getLabelClass();
        _tempField = new labelClass();
        _tempField.visible = false;
        _tempField.text="W...";
        _tempField.toolTip = "";
        addChild(_tempField as UIComponent);
        _tempField.validateNow();
    }
    
    private function getLabelClass():Class
    {
        var labelClass:Class = getStyle("labelClass");
        if(labelClass == null)
        {
            try{
                labelClass = Class(getDefinitionByName("spark.components::Label"));
            }
            catch(e:Error)
            {
                labelClass = Class(getDefinitionByName("mx.controls::Label"));
            }
        }
        return labelClass;
    }


    /**
     *  @private
     */
    override public function styleChanged(styleProp:String):void
    {
        if (styleProp == null || INVALIDATING_STYLES[styleProp] != undefined)
            invalidateSeries();

        super.styleChanged(styleProp);
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: ChartBase
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    override protected function customizeSeries(seriesGlyph:Series, i:uint):void
    {
        if ((seriesGlyph is BarSeries) || (seriesGlyph is BarSet))
        {
            var series:Object = seriesGlyph;

            if (!isNaN(_perSeriesBarWidthRatio))
                series.barWidthRatio = _perSeriesBarWidthRatio;
    
            if (!isNaN(_perSeriesMaxBarWidth))
                series.maxBarWidth = _perSeriesMaxBarWidth;
                
            if (_type == "overlaid")        
                series.offset = 0;
            else
                series.offset = _rightOffset - i * _perSeriesBarWidthRatio;
            
            if (series is BarSeries)
            {
                series.stacker = null;
                series.stackTotals = null;
            }
        }
    }
    
    /**
     *  @private
     */
    override protected function applySeriesSet(seriesSet:Array /* of Series */,
                                               transform:DataTransform):Array /* of Series */
    {
        
        var barWidthRatio:Number = getStyle("barWidthRatio");
        var maxBarWidth:Number = getStyle("maxBarWidth");
        var g:IChartElement;
        var n:int = seriesSet.length;

        switch (_type)
        {
            case "stacked":
            case "100%":
            {
                _wasStacked = true;

                for (var i:int = 0; i < n; i++)
                {
                    seriesSet[i].offset = 0;
                }

                var newSeriesGlyph:BarSet = new BarSet();
                newSeriesGlyph.series = seriesSet;
                for (i = 0; i < n; i++)
                {
                    g = seriesSet[i] as IChartElement;
                    if (!g)
                        continue;
                    if (g.labelContainer)           
                        newSeriesGlyph.labelContainer.addChild(seriesSet[i].labelContainer);
                }

                if (!isNaN(barWidthRatio))
                    newSeriesGlyph.barWidthRatio = barWidthRatio;

                if (!isNaN(maxBarWidth))
                    newSeriesGlyph.maxBarWidth = maxBarWidth;

                newSeriesGlyph.type = _type;

                invalidateData();
                return [ newSeriesGlyph ];
            }
                            
            case "clustered":
            default:
            {
                
                var barSeriesCount:int = 0;
                for each(var series:Series in seriesSet) {
                    if(series is BarSet || series is BarSeries)
                        barSeriesCount++;
                }
                
                _perSeriesBarWidthRatio = barWidthRatio / barSeriesCount;
                _perSeriesMaxBarWidth = maxBarWidth / barSeriesCount;
                _rightOffset = barWidthRatio / 2 - _perSeriesBarWidthRatio / 2;
                n = seriesSet.length;
                var count:int = 0;
                for (i = 0; i < n; i++)
                {
                    var newSeries:IChartElement = seriesSet[i];
                    if (newSeries is BarSeries || newSeries is BarSet)
                    {
                        customizeSeries(Series(seriesSet[i]), count);
                        count++;
                    }
                }
                
                return seriesSet;
            }

            case "overlaid":
            {
                _perSeriesBarWidthRatio = barWidthRatio;
                _perSeriesMaxBarWidth = maxBarWidth;

                _rightOffset = 0;
                super.applySeriesSet(seriesSet, transform);
                break;
            }
        }

        return seriesSet;
    }
                
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: CartesianChart
    //
    //--------------------------------------------------------------------------
    
    /**
     * Determines positions and dimensions of labels for all series in the chart
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override mx_internal function measureLabels():Object
    {
        getSeriesLabelPosSet();
        if (!_needLabels)
            return null;
        var n:int = series.length;
        var allSeriesTransform:Boolean = true;
        
        if (type == "stacked" || type == "overlaid" || type == "100%")
            allLabelsMeasured = false;
        
        _allItems = [];
        _barSeriesLen = 0;
        for (var i:int = 0; i < n; i++)
        {
            findChartItems(series[i]);          
        }
        _allItems.sort(sortOnY);    //sort all items with respect to thier position along Y-axis
        var itemsLen:Number = _allItems.length;
        for (i = itemsLen - 1; i >= 0; i--)
        {
            var v:BarSeriesItem = _allItems[i];
            var barSeries:BarSeries = BarSeries(BarSeriesItem(_allItems[i]).element);
            var labelPosition:String = barSeries.labelPos;      
        
            if (labelPosition == "inside" || labelPosition == "outside")
            {
                
                var base:Number = barSeries.seriesRenderData.renderedBase;
                var size:Number = barSeries.getStyle('fontSize');
                if (barSeries.labelFunction != null)
                    barSeries.measuringField.text = v.labelText = barSeries.labelFunction(v, barSeries);
                else if (barSeries.labelField != null)
                    barSeries.measuringField.text = v.labelText = v.item[barSeries.labelField];
                else if (barSeries.dataFunction != null)
                    barSeries.measuringField.text = v.labelText = barSeries.dataFunction(barSeries, v.item, 'xNumber');
                else
                    barSeries.measuringField.text = v.labelText = v.item[barSeries.xField];     
            
                //barSeries.measuringField.validateNow();
                
                var labelRotation:Number = barSeries.labelAngle;
                var labelSizeLimit:Number = barSeries.maxLabelSize;
                if (labelPosition == "outside" && (type == "stacked" || type == "overlaid" || type == "100%"))
                {
                    labelPosition = "inside";
                    barSeries.labelPos = 'inside';
                        //today, labelPosition = inside is only supported for stacked, 100% and overlaid
                }       
                            
            
                if (labelPosition == 'outside')
                {
                    v.labelHeight = 2 * barSeries.seriesRenderData.renderedHalfWidth;
                    /*
                    if (!(isNaN(labelRotation)) && labelRotation != 0 && barSeries.measuringField.embedFonts)
                    {
                        var r:Number = -labelRotation / Math.PI * 180;
                                //for future enhancement
                                //check for type of chart if we need to support labelPosition = outside for all types of charts
                        if (type == "clustered")
                        {
                            if (i > n - 1)
                                v.labelWidth = Math.abs((_allItems[i - i%n - 1].y + BarSeries(_allItems[i - i%n - 1].element).seriesRenderData.renderedYOffset
                                               + BarSeries(_allItems[i - i%n - 1].element).seriesRenderData.renderedHalfWidth -
                                               (v.y + barSeries.seriesRenderData.renderedYOffset - 
                                               barSeries.seriesRenderData.renderedHalfWidth))/ Math.cos(r));
                            else
                                v.labelWidth = Math.abs((_allItems[0].y + BarSeries(_allItems[0].element).seriesRenderData.renderedYOffset
                                               - BarSeries(_allItems[0].element).seriesRenderData.renderedHalfWidth - 
                                               (v.y + barSeries.seriesRenderData.renderedYOffset - 
                                               barSeries.seriesRenderData.renderedHalfWidth))/ Math.cos(r));
                        }
                        else
                        {
                            if (i > n - 1)
                                v.labelWidth = Math.abs((_allItems[i - n].y + BarSeries(_allItems[i - n].element).seriesRenderData.renderedYOffset
                                               + BarSeries(_allItems[i - n].element).seriesRenderData.renderedHalfWidth - 
                                               (v.y + barSeries.seriesRenderData.renderedYOffset - 
                                               barSeries.seriesRenderData.renderedHalfWidth))/ Math.cos(r));
                            else
                                v.labelWidth = Math.abs((_allItems[0].y + BarSeries(_allItems[0].element).seriesRenderData.renderedYOffset
                                               - BarSeries(_allItems[0].element).seriesRenderData.renderedHalfWidth - 
                                               (v.y + barSeries.seriesRenderData.renderedYOffset - 
                                               barSeries.seriesRenderData.renderedHalfWidth))/ Math.cos(r));
                        }
                        v.labelY=v.y + barSeries.seriesRenderData.renderedYOffset + barSeries.seriesRenderData.renderedHalfWidth;
                    }
                    else
                    {*/
                        if (v.x > (isNaN(v.min) ? base : v.min))
                        {
                            v.labelWidth = barSeries.dataToLocal(NumericAxis(barSeries.dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS)).computedMaximum,0).x - barSeries.dataToLocal(v.xNumber,0).x;
                            v.labelX = v.x;
                            if (v.labelWidth == 0)
                            {
                                v.labelWidth = Math.abs(v.x -(isNaN(v.min) ? base : v.min));
                                v.labelX = isNaN(v.min) ? base : v.min;
                            }
                        }
                        else
                        {
                            v.labelWidth = barSeries.dataToLocal(v.xNumber,0).x - barSeries.dataToLocal(NumericAxis(barSeries.dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS)).computedMinimum,0).x;
                            v.labelX = v.x - v.labelWidth;
                            if (v.labelWidth == 0)
                            {
                                v.labelWidth = Math.abs(v.x -(isNaN(v.min) ? base : v.min));
                                v.labelX = v.x;
                            }
                        }
                        v.labelY=v.y + barSeries.seriesRenderData.renderedYOffset - barSeries.seriesRenderData.renderedHalfWidth;
                    /*}*/
                    var labelScale:Number = 1;
                    if (barSeries.measuringField.textWidth > v.labelWidth || barSeries.measuringField.textHeight > v.labelHeight)
                    {
                        labelScale = v.labelWidth / barSeries.measuringField.textWidth;
                        labelScale = Math.min(labelScale, v.labelHeight / barSeries.measuringField.textHeight);
                        if (size * labelScale > labelSizeLimit)
                            barSeries.seriesRenderData.labelScale = Math.min(labelScale,barSeries.seriesRenderData.labelScale);
                        else
                        {
                            _tempField.setStyle('fontSize',size);
                            _tempField.validateNow();
                            if (_tempField.measuredWidth > v.labelWidth || _tempField.measuredHeight > v.labelHeight)
                            {
                                labelScale = v.labelWidth / _tempField.measuredWidth;                       
                                labelScale = Math.min(labelScale, v.labelHeight / _tempField.measuredHeight);
                                if (size * labelScale > labelSizeLimit)
                                    barSeries.seriesRenderData.labelScale = Math.min(labelScale,barSeries.seriesRenderData.labelScale); 
                                else
                                {
                                    v.labelText = "";
                                    v.labelWidth = 1;
                                }
                            }
                        }
                    }
                            
                    /*
                    if (!isNaN(labelRotation) && labelRotation!=0 && barSeries.measuringField.embedFonts)
                    {
                        v.labelHeight = barSeries.measuringField.textHeight + 2;
                        if (v.x > (isNaN(v.min) ? base : v.min))
                            v.labelX = v.x + v.labelHeight;
                        else
                            v.labelX = v.x - 2 * v.labelHeight;
                        v.labelY = v.labelY - v.labelHeight;
                        v.labelWidth = v.labelWidth - v.labelHeight;
                    }*/
                }
                else if (labelPosition == "inside")
                {
                    v.labelWidth = Math.abs(v.x -(isNaN(v.min) ? base : v.min));
                    v.labelHeight = 2 * barSeries.seriesRenderData.renderedHalfWidth;
                    v.labelY=v.y + barSeries.seriesRenderData.renderedYOffset - barSeries.seriesRenderData.renderedHalfWidth;
            
                    if (v.x > (isNaN(v.min) ? base : v.min))
                        v.labelX = isNaN(v.min) ? base : v.min;
                    else
                        v.labelX = v.x;
                    labelScale = 1;
                    if (barSeries.measuringField.textWidth > v.labelWidth || (barSeries.measuringField.textHeight) > v.labelHeight)
                    {
                        labelScale = v.labelWidth / barSeries.measuringField.textWidth;
                        labelScale = Math.min(labelScale, v.labelHeight / barSeries.measuringField.textHeight);
                        if (size * labelScale > labelSizeLimit)
                            barSeries.seriesRenderData.labelScale = Math.min(labelScale,barSeries.seriesRenderData.labelScale);
                        else
                        {
                            _tempField.setStyle('fontSize',size);
                            _tempField.validateNow();
                            if (_tempField.measuredWidth > v.labelWidth || _tempField.measuredHeight + 2 > v.labelHeight)
                            {
                                labelScale = v.labelWidth / _tempField.measuredWidth;                       
                                labelScale = Math.min(labelScale, v.labelHeight / _tempField.measuredHeight);
                                if (size * labelScale > labelSizeLimit)
                                    barSeries.seriesRenderData.labelScale = Math.min(labelScale,barSeries.seriesRenderData.labelScale); 
                                else
                                {
                                    v.labelText = "";
                                    v.labelWidth = 1;
                                }
                            }
                        }
                    }
                    var prevItemsCount:int =_barSeriesLen - 1 - (i % _barSeriesLen);
                    for (var j:int = 1; j <= prevItemsCount; j++)
                            //test for overlaps with previous labels
                    {
                        var tempItem:BarSeriesItem = _allItems[i + j];
                        if (v.labelY == tempItem.labelY)
                        {
                            if (((v.labelX >= tempItem.labelX) && (v.labelX < (tempItem.labelX + tempItem.labelWidth))) ||
                                    ((v.labelX <= tempItem.labelX) && ((v.labelX + v.labelWidth) > tempItem.labelX)))
                            {
                                v.labelText = "";
                                v.labelWidth = 1;
                            }
                        }
                    }                       
                }
            }
            else
            {
                barSeries.seriesRenderData.labelData = null;
                barSeries.labelCache.count = 0;
            }
        }
        allLabelsMeasured = true;
        for (i = 0; i < n; i++)
        {
            invalidateDisplay(series[i]);
        }
        return null;
    }
    
    //------------------------------------------------------------------------------------
    //
    // Methods
    //
    //------------------------------------------------------------------------------------
    
    mx_internal function getSeriesLabelPos(series:Series):void
    {
        if (series is BarSeries)
        {
            var barSeries:BarSeries = BarSeries(series);
            var position:String = barSeries.labelPos;
            if (position == "inside" || position == "outside" || position == "none")
                _needLabels = true; 
        }
        else if (series is BarSet)
        {
            var setSeries:Array /* of Series */ = BarSet(series).series;
            var n:int = setSeries.length;
            for (var i:int = 0; i < n; i++)
            {
                getSeriesLabelPos(setSeries[i]);
            }
        }   
    }
    
    mx_internal function getSeriesLabelPosSet():void
    {
        var n:int = series.length;
        _needLabels = false;
        for (var i:int = 0; i < n; i++)
        {
            if (_needLabels)
                return;
            getSeriesLabelPos(series[i]);
        }
    }
     
    /**
     * @private
     */
     private function sortOnY(a:BarSeriesItem,b:BarSeriesItem):int
     {
        var offset1:Number = BarSeries(a.element).seriesRenderData.renderedYOffset;
        var offset2:Number = BarSeries(b.element).seriesRenderData.renderedYOffset;
        if (a.y + offset1 > b.y + offset2)
            return 1;
        else if (a.y + offset1 < b.y + offset2)
            return -1;
        else
        {
            if (a.xNumber > b.xNumber)
                return 1;
            else if (a.xNumber < b.xNumber)
                return -1;
            else
                return 0;
        }           
     }
     
    /**
     * @private
     */
     private function findChartItems(series:Series):void
     {
        var n:int;
        var i:int;
        if (series is BarSeries)
        {
            _barSeriesLen = _barSeriesLen + 1;
            var barSeries:BarSeries = BarSeries(series);
            var seriesItems:Array /* of BarSeriesItem */ = barSeries.seriesRenderData.filteredCache;
            n = seriesItems.length;
            barSeries.labelCache.count = n;
            barSeries.seriesRenderData.labelScale = 1;
            
            for (i = 0; i < n; i++)
            {
                _allItems.push(BarSeriesItem(seriesItems[i]));
            }           
        }
        else if (series is BarSet)
        {
            var setSeries:Array /* of Series */ = BarSet(series).series;
            n = setSeries.length;
            for (i = 0; i < n; i++)
            {
                findChartItems(setSeries[i]);
            }
        }
     }
    /**
     * @private
     */
     private function invalidateDisplay(series:Series):void
     {
        if (series is BarSeries)
            BarSeries(series).updateLabels();
        else if (series is BarSet)
        {
            var setSeries:Array /* of Series */ = BarSet(series).series;
            var n:int = setSeries.length;
            for (var i:int = 0; i < n; i++)
            {
                invalidateDisplay(setSeries[i]);
            }
        }
     }
    
}

}
