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

//import flash.filters.DropShadowFilter;
import org.apache.royale.reflection.getDefinitionByName;

import mx.charts.chartClasses.CartesianChart;
import mx.charts.chartClasses.CartesianTransform;
import mx.charts.chartClasses.DataTip;
import mx.charts.chartClasses.DataTransform;
import mx.charts.chartClasses.IChartElement;
import mx.charts.chartClasses.IStackable;
import mx.charts.chartClasses.NumericAxis;
import mx.charts.chartClasses.Series;
import mx.charts.series.ColumnSeries;
import mx.charts.series.ColumnSet;
import mx.charts.series.items.ColumnSeriesItem;
import mx.charts.styles.HaloDefaults;
import mx.core.IFlexModuleFactory;
import mx.core.UIComponent;
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
 *  Specifies a ratio of wide to draw the columns relative to
 *  the category width, as a percentage in the range of 0 to 1. 
 *  A value of 1 uses the entire space, while a value of 0.6
 *  uses 60% of the column's available space.  
 *  The actual column width used is the smaller of the
 *  <code>columnWidthRatio</code> property and the
 *  <code>maxColumnWidth</code> property.
 *  Clustered columns divide this space proportionally
 *  among the columns in each cluster. 
 *  The default value is 0.65.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="columnWidthRatio", type="Number", inherit="no")]

/**
 *  Specifies how wide to draw the columns, in pixels.
 *  The actual column width used is the smaller of this property
 *  and the <code>columnWidthRatio</code> property.
 *  Clustered columns divide this space proportionally
 *  among the columns in each cluster. 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="maxColumnWidth", type="Number", format="Length", inherit="no")]

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

//[IconFile("ColumnChart.png")]

/**
 *  The ColumnChart control represents data as a series of vertical columns
 *  whose height is determined by values in the data.  
 *  You can use the ColumnChart to represent a variety of different charts
 *  including simple columns, clustered columns, stacked,
 *  100% stacked, and high/low. 
 *  
 *  <p>A ColumnChart control expects its <code>series</code> property
 *  to contain an array of ColumnSeries objects.</p>
 *
 *  <p>Stacked and 100% column charts override the <code>minField</code>
 *  property of their ColumnSeries objects.</p>
 *
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:ColumnChart&gt;</code> tag inherits all the properties
 *  of its parent classes and adds the following properties:</p>
 *  
 *  <pre>
 *  &lt;mx:ColumnChart
 *    <strong>Properties</strong>
 *    extendLabelToEnd="false|true"
 *    maxLabelWidth="<i>50</i>"
 *    showLabelVertically="false|true"
 *    type="<i>clustered|overlaid|stacked|100%</i>"
 * 
 *    <strong>Styles</strong>
 *    columnWidthRatio=".65"
 *    maxColumnWidth="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *  
 *  @includeExample examples/Column_BarChartExample.mxml
 *  
 *  @see mx.charts.series.ColumnSeries
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ColumnChart extends CartesianChart
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
        columnWidthRatio: 1,
        maxColumnWidth: 1
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
    public function ColumnChart()
    {
        super();

        LinearAxis(horizontalAxis).autoAdjust = false;
        
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
    private var _perSeriescolumnWidthRatio:Number;
    
    /**
     *  @private
     */
    private var _perSeriesMaxColumnWidth:Number;
    
    /**
     *  @private
     */
    private var _leftOffset:Number;
    
    /**
     * @private
     */
    mx_internal var allLabelsMeasured: Boolean = false;
    
    /**
     * @private
     */
    private var _allItems:Array /* of ChartItem */ = [];
    
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
    
    //---------------------------------
    // extendLabelToEnd
    //---------------------------------
    /**
     * @private
     * Storage for extendLabelToEnd property
     */
    private var _extendLabelToEnd:Boolean = false;
    
    [Inspectable(category="General")]
    
    /**
     * Determines whether or not data labels can extend to the end of the chart.
     * If you set this to true, labels can use the whole space between the item
     * and the boundary of the chart to show its label. Otherwise, data labels are
     * restricted to the area defined by their chart item.
     * 
     * @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
     public function get extendLabelToEnd():Boolean
     {
        return _extendLabelToEnd;
     }
     
    /**
     * @private
     */
     public function set extendLabelToEnd(value:Boolean):void
     {
        _extendLabelToEnd = value;
        measureLabels();
     }
    
    //---------------------------------
    // maxLabelWidth
    //---------------------------------
    
    /**
     * @private
     * Storage for maxLabelWidth property
     */
    private var _maxLabelWidth:int = 50;
    
    [Inspectable(category="General")]
    
    /**
     * Determines maximum width in pixels of label of items.
     * 
     * @default 50
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
     public function get maxLabelWidth():int
     {
        return _maxLabelWidth;
     }
     
    /**
     * @private
     */
     public function set maxLabelWidth(value:int):void
     {
        _maxLabelWidth = value;
        measureLabels();
     }
     
    //---------------------------------
    // showLabelVertically
    //---------------------------------
    /**
     * @private
     * Storage for showLabelVertically property
     */
    private var _showLabelVertically:Boolean = false;
    
    [Inspectable(category="General")]
    
    /**
     * Determines whether or not the data labels can be shown vertically.
     * If you set this to true and if embedded fonts are used, labels will be shown vertically
     * if they cannot be fit horizontally within the column width.
     * 
     * @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
     public function get showLabelVertically():Boolean
     {
        return _showLabelVertically;
     }
     
    /**
     * @private
     */
     public function set showLabelVertically(value:Boolean):void
     {
        _showLabelVertically = value;
        measureLabels();
     }
    
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
     *  The type of the column chart.
     *
     *  <p>Possible values are:</p>
     *  <ul>
     *    <li><code>"clustered"</code>:
     *    Values from different series are grouped by category.
     *    This is the default type.</li>
     *    <li><code>"overlaid"</code>:
     *    Multiple values are rendered on top of one another by category,
     *    with the last series on top. </li>
     *    <li><code>"stacked"</code>:
     *    Columns are stacked on top of each other and grouped by category. 
     *    Each column represents the cumulative value
     *    of the columns beneath it. </li>
     *    <li><code>"100%"</code>:
     *    Columns are stacked on top of each other, adding up to 100%. 
     *    Each column represents the percent that it contributes
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
        if (_type == value)
            return;
            
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
		
		var columnChartStyle:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, "mx.charts.ColumnChart");
		if (columnChartStyle)
		{
			columnChartStyle.setStyle("chartSeriesStyles", HaloDefaults.chartBaseChartSeriesStyles);
			columnChartStyle.setStyle("fill", new SolidColor(0xFFFFFF, 0));
			columnChartStyle.setStyle("calloutStroke", new SolidColorStroke(0x888888,2));
			columnChartStyle.setStyle("horizontalAxisStyleNames", ["blockCategoryAxis"]);
			columnChartStyle.setStyle("verticalAxisStyleNames", ["blockNumericAxis"]);
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
        _tempField.text = "W...";
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
        if (seriesGlyph is ColumnSeries || seriesGlyph is ColumnSet)
        {
            var series:Object = seriesGlyph;
            
            if (!isNaN(_perSeriescolumnWidthRatio))
                series.columnWidthRatio = _perSeriescolumnWidthRatio;

            if (!isNaN(_perSeriesMaxColumnWidth))
                series.maxColumnWidth = _perSeriesMaxColumnWidth;

            if (_type == "overlaid")        
                series.offset = 0;
            else
                series.offset = _leftOffset + i * _perSeriescolumnWidthRatio;
    
            if (series is IStackable)
            {
                var stackSeries:IStackable = IStackable(series);
                stackSeries.stacker = null;
                stackSeries.stackTotals = null;
            }
        }
    }
    
    /**
     *  @private
     */
    override protected function applySeriesSet(seriesSet:Array /* of Series */,
                                               transform:DataTransform):Array /* of Series */
    {
        var columnWidthRatio:Number = getStyle("columnWidthRatio");
        var maxColumnWidth:Number = getStyle("maxColumnWidth");
        var g:IChartElement;
        
        switch (_type)
        {
            case "stacked":
            case "100%":
            {
                var n:int = seriesSet.length;
                var i:int;
                for (i = 0; i < n; i++)
                {
                    seriesSet[i].offset = 0;
                }

                var newSeriesGlyph:ColumnSet = new ColumnSet();
                newSeriesGlyph.owner = this;
                newSeriesGlyph.series = seriesSet;
                for (i = 0; i < n; i++)
                {
                    g = seriesSet[i] as IChartElement;
                    newSeriesGlyph.series[i].owner = newSeriesGlyph;
                    if (!g)
                        continue;
                    if (g.labelContainer)           
                        newSeriesGlyph.labelContainer.addChild(seriesSet[i].labelContainer);
                }
                
                if (!isNaN(columnWidthRatio))
                    newSeriesGlyph.columnWidthRatio = _perSeriescolumnWidthRatio;

                if (!isNaN(maxColumnWidth))
                    newSeriesGlyph.maxColumnWidth = _perSeriesMaxColumnWidth;

                newSeriesGlyph.type = _type;

                invalidateData();
            
                return [ newSeriesGlyph ];
            }               

            case "clustered":
            default:
            {
                
                var columnSeriesCount:int = 0;
                for each(var series:Series in seriesSet) {
                    if(series is ColumnSet || series is ColumnSeries)
                        columnSeriesCount++;
                }
                
                _perSeriescolumnWidthRatio = columnWidthRatio / columnSeriesCount;
                _perSeriesMaxColumnWidth = maxColumnWidth / columnSeriesCount;
                
                _leftOffset = (1 - columnWidthRatio) / 2 +
                              _perSeriescolumnWidthRatio / 2 - 0.5;

                n = seriesSet.length;
                var count:int = 0;
                for (i = 0; i < n; i++)
                {
                    var newSeries:IChartElement = seriesSet[i];
                    if (newSeries is ColumnSeries || newSeries is ColumnSet)
                    {
                        customizeSeries(Series(seriesSet[i]), count);
                        count++;
                    }
                }
                
                return seriesSet;
            }

            case "overlaid":
            {
                _perSeriescolumnWidthRatio = columnWidthRatio;
                _perSeriesMaxColumnWidth = maxColumnWidth;

                _leftOffset = 0;
                return super.applySeriesSet(seriesSet, transform);
            }
        }
    }           
    
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
        var len:int = series.length;
        var n:int;
        var allSeriesTransform:Boolean = true;
        
        if (type == "stacked" || type == "overlaid" || type == "100%")
            allLabelsMeasured = false;
        
        _allItems = [];
        n = len;
        for (var i:int = 0; i < n; i++)
        {
            findChartItems(series[i]);           
        }
        
        _allItems.sort(sortOnX);    //sort all items with respect to their position along X-axis
        
        var itemsLen:Number = _allItems.length;
        n = itemsLen;
        for (i = 0; i < n; i++)
        {
            var v:ColumnSeriesItem = _allItems[i];
            var columnSeries:ColumnSeries = ColumnSeries(ColumnSeriesItem(_allItems[i]).element);
            var labelPosition:String = columnSeries.labelPos;
                
            if (labelPosition == "inside" || labelPosition == "outside")
            {
                var base:Number = columnSeries.seriesRenderData.renderedBase;
                var size:Number = columnSeries.getStyle('fontSize');
                if (columnSeries.labelFunction != null)
                    columnSeries.measuringField.text = v.labelText = columnSeries.labelFunction(v, columnSeries);
                else if (columnSeries.labelField != null)
                    columnSeries.measuringField.text = v.labelText = v.item[columnSeries.labelField];
                else if (columnSeries.dataFunction != null)
                    columnSeries.measuringField.text = v.labelText = columnSeries.dataFunction(columnSeries, v.item, 'yNumber');
                else
                    columnSeries.measuringField.text = v.labelText = v.item[columnSeries.yField];       
        
                //columnSeries.measuringField.validateNow();
            
                var labelRotation:Number = columnSeries.labelAngle;
                var labelSizeLimit:Number = columnSeries.maxLabelSize;
            
                if (labelPosition == "outside" && (type == "overlaid" || type == "stacked" || type == "100%"))
                {
                    columnSeries.labelPos = 'inside';
                    labelPosition = "inside";
                        // today, labelPosition = inside is only supported for 100%, stacked and overlaid charts
                }   
                           
        
                if (labelPosition == 'outside')
                {
                    if (!showLabelVertically)
                    {  
                        v.labelIsHorizontal = true;
                        if (extendLabelToEnd)
                        {
                            v.labelWidth = Math.abs((this.dataRegion.right - 
                                           (v.x + columnSeries.seriesRenderData.renderedXOffset - 
                                           columnSeries.seriesRenderData.renderedHalfWidth))/ Math.cos(0));
                        }
                        else
                        {
                            v.labelWidth = Math.min(Math.abs((this.dataRegion.right -  
                                           (v.x + columnSeries.seriesRenderData.renderedXOffset - 
                                           columnSeries.seriesRenderData.renderedHalfWidth))/ Math.cos(0)),maxLabelWidth);
                        }                           
                        v.labelHeight = columnSeries.measuringField.textHeight + 2;
                    }
                    else
                    {                   //check whether labels can be rendered horizontally
                        v.labelIsHorizontal = true;
                        v.labelWidth = 2 * columnSeries.seriesRenderData.renderedHalfWidth;
                        v.labelHeight = columnSeries.measuringField.textHeight + 2;
                        
                        /*
                        if (columnSeries.measuringField.textWidth + 5 > 2 * columnSeries.seriesRenderData.renderedHalfWidth &&
                        columnSeries.measuringField.embedFonts)
                        {
                            v.labelIsHorizontal = false;
                            v.labelHeight = 2 * columnSeries.seriesRenderData.renderedHalfWidth;
                            if (!(isNaN(labelRotation)) && labelRotation!=-90)
                            {
                                var r:Number = -labelRotation / Math.PI * 180;
                                        //for future enhancement
                                        //check for type of chart if we need to support labelPosition = outside for all types of charts
                                if (type == "clustered")
                                {
                                    if (i < itemsLen - len)
                                    {
                                        v.labelWidth = Math.abs((_allItems[i + len - i%len].x + ColumnSeries(_allItems[i + len - i%len].element).seriesRenderData.renderedXOffset
                                                       - ColumnSeries(_allItems[i + len - i%len].element).seriesRenderData.renderedHalfWidth -
                                                       (v.x + columnSeries.seriesRenderData.renderedXOffset - 
                                                       columnSeries.seriesRenderData.renderedHalfWidth))/ Math.cos(r));
                                    }
                                    else
                                        v.labelWidth = Math.abs((_allItems[itemsLen -1].x + ColumnSeries(_allItems[itemsLen - 1].element).seriesRenderData.renderedXOffset
                                                       + ColumnSeries(_allItems[itemsLen - 1].element).seriesRenderData.renderedHalfWidth - 
                                                       (v.x + columnSeries.seriesRenderData.renderedXOffset - 
                                                       columnSeries.seriesRenderData.renderedHalfWidth))/ Math.cos(r));
                                }
                            }
                            else
                            {
                                if (v.y < (isNaN(v.min) ? base : v.min))
                                {   
                                    v.labelWidth = columnSeries.dataToLocal(0,v.yNumber).y - columnSeries.dataToLocal(0,NumericAxis(columnSeries.dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS)).computedMaximum).y;
                                    v.labelY = v.y;
                                    if (v.labelY < this.dataRegion.top)
                                    {
                                        v.labelWidth = Math.abs(v.y -(isNaN(v.min) ? base : v.min));
                                        v.labelY = isNaN(v.min) ? base : v.min;
                                    }
                                }
                                else
                                {
                                    v.labelWidth = columnSeries.dataToLocal(0,NumericAxis(columnSeries.dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS)).computedMinimum).y - columnSeries.dataToLocal(0,v.yNumber).y;
                                    v.labelY = v.y + v.labelWidth;
                                    if (v.labelY > this.dataRegion.bottom)
                                    {
                                        v.labelWidth = Math.abs(v.y -(isNaN(v.min) ? base : v.min));
                                        v.labelY = v.y;
                                    }
                                }
                            }
                    
                            v.labelX = v.x - columnSeries.seriesRenderData.renderedHalfWidth + columnSeries.seriesRenderData.renderedXOffset;
                        }*/
                    }
            
                    var labelScale:Number = 1;
                    if (columnSeries.measuringField.textWidth + 5 > v.labelWidth || (columnSeries.measuringField.textHeight) > v.labelHeight)
                    {
                        labelScale = v.labelWidth / (columnSeries.measuringField.textWidth + 5);
                        labelScale = Math.min(labelScale, v.labelHeight / (columnSeries.measuringField.textHeight));
                        if (size * labelScale > labelSizeLimit)
                        {
                            columnSeries.seriesRenderData.labelScale = Math.min(labelScale,columnSeries.seriesRenderData.labelScale);
                            /* if (v.labelIsHorizontal)
                            {
                                _tempField.setStyle('fontSize',size * columnSeries.seriesRenderData.labelScale);
                                v.labelHeight = _tempField.textHeight + 2;
                            } */
                        }
                        else
                        {
                            _tempField.setStyle('fontSize',size);
                            _tempField.validateNow();
                            if (_tempField.measuredWidth > v.labelWidth || columnSeries.measuringField.textHeight > v.labelHeight)
                            {
                                labelScale = v.labelWidth / _tempField.measuredWidth;
                                labelScale = Math.min(labelScale, v.labelHeight / (columnSeries.measuringField.measuredHeight));
                                if (size * labelScale > labelSizeLimit)
                                {
                                    columnSeries.seriesRenderData.labelScale = Math.min(labelScale,columnSeries.seriesRenderData.labelScale);   
                                    /* if (v.labelIsHorizontal)
                                    {
                                        _tempField.setStyle('fontSize',size * columnSeries.seriesRenderData.labelScale);
                                        v.labelHeight = _tempField.textHeight + 2;
                                    } */
                                }
                                else
                                {
                                    v.labelText = "";
                                    v.labelWidth = 1;
                                    v.labelHeight = 0;
                                }
                            }
                            
                        }
                    }
                    /*
                    if (!isNaN(labelRotation) && labelRotation!=-90 && columnSeries.measuringField.embedFonts)
                    {
                        v.labelHeight = columnSeries.measuringField.textHeight + 2;
                        if (v.y < (isNaN(v.min) ? base : v.min))
                            v.labelY = v.y - v.labelHeight;
                        else
                            v.labelY = v.y + v.labelHeight;                         
                    }
                    */
                    if (v.labelIsHorizontal)
                    {
                        if (v.y < (isNaN(v.min) ? base : v.min))
                        {
                            v.labelY = v.y - v.labelHeight;
                            if (v.labelY < this.dataRegion.top)
                                v.labelY = v.y;
                        }
                            
                        else
                        {
                            v.labelY = v.y;
                            if (v.labelY > this.dataRegion.bottom)
                                v.labelY = v.y - v.labelHeight;
                            
                        }
                        v.labelX = v.x - columnSeries.seriesRenderData.renderedHalfWidth +columnSeries.seriesRenderData.renderedXOffset;
                    }
                    v.labelTextWidth = columnSeries.measuringField.textWidth;
                    var j:int = 0;
                    if (!extendLabelToEnd)
                    {
                        //maxLabelWidth
                        for (j = (i-1); j >= 1;)
                        {
                            if (_allItems[j].x >= v.x - maxLabelWidth)
                                j--;
                            else
                                break;
                        }
                        if (j < 0)
                            j = i;
                    }
                    
                    for (var k:int = j; k < i; k++)
                    {
                        var tempItem:ColumnSeriesItem = _allItems[k];
                                    //test for overlaps with previous labels
                        if (tempItem.labelIsHorizontal)
                        {
                            if (v.labelX + 0.0001 < Math.min(tempItem.labelX + tempItem.labelWidth , tempItem.labelX + tempItem.labelTextWidth))
                            {
                                if (v.labelIsHorizontal)
                                {
                                    if ((((v.labelY + v.labelHeight) > tempItem.labelY) && ((v.labelY + v.labelHeight) < (tempItem.labelY + tempItem.labelHeight))) || 
                                        ((v.labelY > tempItem.labelY) && (v.labelY < (tempItem.labelY + tempItem.labelHeight))) ||
                                        ((v.labelY == tempItem.labelY) && ((tempItem.labelY + tempItem.labelHeight) == (v.labelY + v.labelHeight)) && (v.labelX > tempItem.labelX) && (v.labelX < (tempItem.labelX + tempItem.labelWidth))) ||
                                        ((v.labelY <= tempItem.labelY) && ((v.labelY + v.labelHeight) > (tempItem.labelY + tempItem.labelHeight))) ||
                                        ((v.labelY < tempItem.labelY) && ((v.labelY + v.labelHeight) >= (tempItem.labelY + tempItem.labelHeight))))
                                    {
                                        if (v.y < (isNaN(v.min) ? base : v.min))
                                            v.labelY = tempItem.labelY - v.labelHeight;
                                        else
                                            v.labelY = tempItem.labelY + tempItem.labelHeight;
                                    }
                                }
                                else
                                {
                                    if (((v.labelY > tempItem.labelY) && ((v.labelY - v.labelWidth) < (tempItem.labelY))) ||
                                        (((v.labelY - v.labelWidth) >= tempItem.labelY) && (v.labelY > (tempItem.labelY - tempItem.labelHeight))))
                                    {
                                        var prevY:Number = v.labelY;
                                        if (v.y < (isNaN(v.min) ? base : v.min))
                                        {
                                            v.labelY = tempItem.labelY - tempItem.labelHeight;
                                            v.labelWidth = v.labelWidth - (prevY - v.labelY);
                                        }
                                        else
                                        {
                                            v.labelY = tempItem.labelY + tempItem.labelHeight;
                                            v.labelWidth = v.labelWidth - (v.labelY - prevY);
                                        }
                                    }
                                }
                            }
                        }
                    }   
                }
                else if (labelPosition == "inside")
                {
                    v.labelIsHorizontal = true;
                    v.labelWidth = 2 * columnSeries.seriesRenderData.renderedHalfWidth;                 
                    v.labelHeight = columnSeries.measuringField.textHeight + 2;
                    
                    /*
                    if (columnSeries.measuringField.textWidth + 5 > 2 * columnSeries.seriesRenderData.renderedHalfWidth && 
                        columnSeries.measuringField.embedFonts)
                    {
                        v.labelIsHorizontal = false;
                        v.labelWidth = Math.abs(v.y -(isNaN(v.min) ? base : v.min));
                        v.labelHeight = 2 * columnSeries.seriesRenderData.renderedHalfWidth;
                        if (v.y < (isNaN(v.min) ? base : v.min))
                            v.labelY = isNaN(v.min) ? base : v.min;
                        else
                            v.labelY = v.y;
                    
                        v.labelX = v.x - v.labelHeight/2 + columnSeries.seriesRenderData.renderedXOffset;
                    }*/
                    
                    labelScale = 1;
                    if (columnSeries.measuringField.textWidth + 5 > v.labelWidth || columnSeries.measuringField.textHeight > v.labelHeight)
                    {
                        labelScale = v.labelWidth / (columnSeries.measuringField.textWidth + 5);
                        labelScale = Math.min(labelScale, v.labelHeight / columnSeries.measuringField.textHeight);
                        if (size * labelScale > labelSizeLimit)
                        {
                            columnSeries.seriesRenderData.labelScale = Math.min(labelScale,columnSeries.seriesRenderData.labelScale);
                            /* if (v.labelIsHorizontal)
                            {
                                _tempField.setStyle('fontSize',size * columnSeries.seriesRenderData.labelScale);
                                v.labelHeight = _tempField.textHeight + 2;
                            } */
                        }
                        else
                        {
                            _tempField.setStyle('fontSize',size);
                            _tempField.validateNow();
                            if (_tempField.measuredWidth > v.labelWidth || columnSeries.measuringField.textHeight > v.labelHeight)
                            {
                                labelScale = v.labelWidth / _tempField.measuredWidth;
                                labelScale = Math.min(labelScale, v.labelHeight / (columnSeries.measuringField.textHeight));
                                if (size * labelScale > labelSizeLimit)
                                {
                                    columnSeries.seriesRenderData.labelScale = Math.min(labelScale,columnSeries.seriesRenderData.labelScale);   
                                    /* if (v.labelIsHorizontal)
                                    {
                                        _tempField.setStyle('fontSize',size * columnSeries.seriesRenderData.labelScale);
                                        v.labelHeight = _tempField.textHeight + 2;
                                    } */
                                }
                                else
                                {
                                    v.labelText = "";
                                    v.labelWidth = 1;
                                    v.labelHeight = 0;
                                }
                            }
                        }
                    }
                    if (v.labelIsHorizontal)
                    {
                        var align:String = columnSeries.getStyle('labelAlign');
                        if (align == "top")
                        {
                            if (v.y < (isNaN(v.min) ? base : v.min))
                                v.labelY = v.y;
                            else
                                v.labelY = v.y - v.labelHeight;
                        }
                        else if (align == "bottom")
                        {
                            if (v.y < (isNaN(v.min) ? base : v.min))
                                v.labelY = (isNaN(v.min) ? base : v.min) - v.labelHeight;
                            else
                                v.labelY = isNaN(v.min) ? base : v.min;
                        }
                        else
                        {
                            if (v.y < (isNaN(v.min) ? base : v.min))
                                v.labelY = v.y + Math.abs(v.y - (isNaN(v.min) ? base : v.min))/2 - v.labelHeight/2;
                            else
                                v.labelY = v.y - Math.abs(v.y - (isNaN(v.min) ? base : v.min))/2 + v.labelHeight/2;
                        }
                        v.labelX = v.x - columnSeries.seriesRenderData.renderedHalfWidth + columnSeries.seriesRenderData.renderedXOffset;
                    }   
                    v.labelTextWidth = columnSeries.measuringField.textWidth;
                    j = 0;
                    if (!extendLabelToEnd)
                    {
                        //maxLabelWidth
                        for (j = (i-1); j >= 1;)
                        {
                            if (_allItems[j].x >= v.x - maxLabelWidth)
                                j--;
                            else
                                break;
                        }
                        if (j < 0)
                            j = i;
                    }
                    
                    for (k = j; k < i; k++)
                    {
                        tempItem = _allItems[k];
                        if (tempItem.labelIsHorizontal)
                        {
                            if (v.labelX + 0.0001 < Math.min(tempItem.labelX + tempItem.labelWidth , tempItem.labelX + tempItem.labelTextWidth))
                            {
                                if (v.labelIsHorizontal)
                                {
                                    if ((((v.labelY + v.labelHeight) > tempItem.labelY) && ((v.labelY + v.labelHeight) < (tempItem.labelY + tempItem.labelHeight))) || 
                                        ((v.labelY > tempItem.labelY) && (v.labelY < (tempItem.labelY + tempItem.labelHeight))) ||
                                        ((v.labelY == tempItem.labelY) && ((tempItem.labelY + tempItem.labelHeight) == (v.labelY + v.labelHeight)) && (v.labelX > tempItem.labelX) && (v.labelX < (tempItem.labelX + tempItem.labelWidth))) ||
                                        ((v.labelY <= tempItem.labelY) && ((v.labelY + v.labelHeight) > (tempItem.labelY + tempItem.labelHeight))) ||
                                        ((v.labelY < tempItem.labelY) && ((v.labelY + v.labelHeight) >= (tempItem.labelY + tempItem.labelHeight))))
                                    {
                                        if (v.y < (isNaN(v.min) ? base : v.min))
                                            v.labelY = tempItem.labelY - v.labelHeight;
                                        else
                                            v.labelY = tempItem.labelY + tempItem.labelHeight;
                                    }
                                    else if (((v.labelY < tempItem.labelY) && ((v.labelY + v.labelHeight) > tempItem.labelY)) ||
                                        ((v.labelY > tempItem.labelY) && (v.labelY < (tempItem.labelY + tempItem.labelHeight))) ||
                                        (v.labelY == tempItem.labelY))
                                    {
                                        if (v.yNumber >= tempItem.yNumber)
                                        {
                                            tempItem.labelText = "";
                                            tempItem.labelWidth = 1;
                                        }
                                        else
                                        {
                                            v.labelText = "";
                                            v.labelWidth = 1;
                                        }
                                    }
                                }
                                else
                                {
                                    if (((v.labelY > tempItem.labelY) && ((v.labelY - Math.min(v.labelWidth,v.labelTextWidth)) < (tempItem.labelY))) ||
                                        (((v.labelY - v.labelWidth) >= tempItem.labelY) && (v.labelY > (tempItem.labelY - tempItem.labelHeight))))
                                    {
                                        prevY = v.labelY;
                                        if (v.y < (isNaN(v.min) ? base : v.min))
                                        {
                                            v.labelY = tempItem.labelY - tempItem.labelHeight;
                                            v.labelWidth = v.labelWidth - (prevY - v.labelY);
                                        }
                                        else
                                        {
                                            v.labelY = tempItem.labelY + tempItem.labelHeight;
                                            v.labelWidth = v.labelWidth - (v.labelY - prevY);
                                        }
                                    }
                                }
                            }
                        }
                        else
                        {
                            if (v.labelX == tempItem.labelX)
                            {
                                if (((v.labelY <= tempItem.labelY) && (v.labelY > (tempItem.labelY - Math.min(tempItem.labelWidth, tempItem.labelTextWidth) + 0.0001))) ||
                                    ((v.labelY >= tempItem.labelY) && ((v.labelY - Math.min(v.labelWidth, v.labelTextWidth) + 0.0001) < tempItem.labelY)))
                                {
                                    if (v.yNumber < tempItem.yNumber)
                                    {
                                        v.labelText = "";
                                        v.labelWidth = 1;
                                    }
                                    else
                                    {
                                        tempItem.labelText = "";
                                        tempItem.labelWidth = 1;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                columnSeries.seriesRenderData.labelData = null;
                columnSeries.labelCache.count = 0;
            }
        }
        allLabelsMeasured = true;
        n = len;
        for (i = 0; i < n; i++)
        {
            invalidateDisplay(series[i]);
        }
        return null;
    }
    
    
    //---------------------------------------------------------------------------------
    //
    // Methods
    //
    //---------------------------------------------------------------------------------
    mx_internal function getSeriesLabelPos(series:Series):void
    {
        if (series is ColumnSeries)
        {
            var columnSeries:ColumnSeries = ColumnSeries(series);
            var position:String = columnSeries.labelPos;
            if (position == "inside" || position == "outside" || position == "none")
                _needLabels = true; 
        }
        else if (series is ColumnSet)
        {
            var setSeries:Array /* of Series */ = ColumnSet(series).series;
            var n:int  = setSeries.length;
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
     private function sortOnX(a:ColumnSeriesItem,b:ColumnSeriesItem):int
     {
        var offset1:Number = ColumnSeries(a.element).seriesRenderData.renderedXOffset;
        var offset2:Number = ColumnSeries(b.element).seriesRenderData.renderedXOffset;
        if (a.x + offset1 > b.x + offset2)
            return 1;
        else if (a.x + offset1 < b.x + offset2)
            return -1;
        else
        {
            if (a.yNumber > b.yNumber)
                return 1;
            else if (a.yNumber < b.yNumber)
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
        if (series is ColumnSeries)
        {
            var columnSeries:ColumnSeries = ColumnSeries(series);
            var seriesItems:Array /* of ColumnSeriesItem */ = columnSeries.seriesRenderData.filteredCache;
            n = seriesItems.length;
            columnSeries.labelCache.count = n;
            columnSeries.seriesRenderData.labelData = columnSeries.labelContainer;
            columnSeries.seriesRenderData.labelScale = 1;
            for (i = 0; i < n; i++)
            {
                _allItems.push(ColumnSeriesItem(seriesItems[i]));
            }           
        }
        else if (series is ColumnSet)
        {
            var setSeries:Array /* of Series */ = ColumnSet(series).series;
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
        if (series is ColumnSeries)
            ColumnSeries(series).updateLabels();
        else if (series is ColumnSet)
        {
            var setSeries:Array /* of Series */ = ColumnSet(series).series;
            var n:int = setSeries.length;
            for (var i:int = 0; i < n; i++)
            {
                invalidateDisplay(setSeries[i]);
            }
        }
     }
}

}
