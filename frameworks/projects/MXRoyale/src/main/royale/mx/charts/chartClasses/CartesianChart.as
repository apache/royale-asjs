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
COMPILE::JS
{
    import goog.DEBUG;
}

import org.apache.royale.events.Event;
import mx.events.KeyboardEvent;
import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;
import mx.core.Keyboard;

import mx.charts.AxisRenderer;
import mx.charts.ChartItem;
import mx.charts.GridLines;
import mx.charts.LinearAxis;
import mx.charts.events.ChartItemEvent;
import mx.charts.styles.HaloDefaults;
import mx.collections.ArrayCollection;
import mx.collections.ICollectionView;
import mx.collections.IList;
import mx.collections.ListCollectionView;
import mx.collections.XMLListCollection;
import mx.core.IFlexModuleFactory;
import mx.core.IUIComponent;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.graphics.SolidColor;
import mx.graphics.SolidColorStroke;
import mx.styles.CSSStyleDeclaration;

use namespace mx_internal;

//--------------------------------------
//  Styles
//--------------------------------------
include "../styles/metadata/TextStyles.as"

/**
 *  The name of the CSS class selector to use
 *  when formatting titles on the axes.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="axisTitleStyleName", type="String", inherit="yes")]

/**
 *  The class selector that defines the style properties
 *  for the default grid lines.
 *  If you explicitly set the <code>backgroundElements</code> property
 *  on your chart, this value is ignored.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="gridLinesStyleName", type="String", inherit="no")]

/**
 *  The size of the region, in pixels, between the bottom
 *  of the chart data area and the bottom of the chart control.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="gutterBottom", type="Number", format="Length", inherit="no")]

/**
 *  The size of the region, in pixels, between the left
 *  of the chart data area and the left of the chart control.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="gutterLeft", type="Number", format="Length", inherit="no")]

/**
 *  The size of the region, in pixels, between the right
 *  side of the chart data area and the outside of the chart control.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="gutterRight", type="Number", format="Length", inherit="no")]

/**
 *  The size of the region, in pixels, between the top
 *  of the chart data area and the top of the chart control.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="gutterTop", type="Number", format="Length", inherit="no")]

/**
 *  An array of class selectors that define the style properties
 *  for horizontal axes.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="horizontalAxisStyleNames", type="Array", arrayType="String", inherit="no")]

/**
 *  An array of class selectors that define the style properties
 *  for vertical axes.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="verticalAxisStyleNames", type="Array", arrayType="String", inherit="no")]

/**
 *  The CartesianChart class is a base class for the common chart types.
 *  CartesianChart defines the basic layout behavior of the standard
 *  rectangular, two-dimensional charts.
 *
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:CartesianChart&gt;</code> tag inherits all the
 *  properties of its parent classes and adds the following properties:</p>
 *  
 *  <pre>
 *  &lt;mx:CartesianChart
 *    <strong>Properties</strong>
 *    computedGutters="<i>No default</i>"
 *    dataRegion="<i>Rectangle; no default</i>"
 *    horizontalAxis="<i>Axis; no default</i>"
 *    horizontalAxisRatio=".33"
 *    horizontalAxisRenderers="<i>Array; no default</i>"
 *    selectedChartItems="<i>Array; no default</i>"
 *    verticalAxis="<i>Axis; no default</i>"
 *    verticalAxisRatio=".33"
 *    verticalAxisRenderers="<i>Array; no default</i>"
 *   
 *    <strong>Styles</strong>  
 *    axisTitleStyleName="<i>Style; no default</i>"
 *    gridLinesStyleName="<i>Style; no default</i>"
 *    gutterBottom="<i>No default</i>"
 *    gutterLeft="<i>No default</i>"
 *    gutterRight="<i>No default</i>"
 *    gutterTop="<i>No default</i>"
 *    horizontalAxisStyleNames=<i>Array; no default</i>"
 *    verticalAxisStyleNames = <i>Array; no default</i>"
 *  /&gt;
 *  </pre>
 *  
 *  @see mx.charts.CategoryAxis
 *  @see mx.charts.LinearAxis
 *  @see mx.charts.chartClasses.ChartBase
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class CartesianChart extends ChartBase
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
    public function CartesianChart()
    {
        super();
    
        horizontalAxis = new LinearAxis();
        verticalAxis = new LinearAxis();
        
        _transforms = [new CartesianTransform()];
        
        var gridLines:GridLines = new GridLines();
        backgroundElements = [ gridLines ];
        _defaultGridLines = gridLines;
        addEventListener("axisPlacementChange",axisPlacementChangeHandler);
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
    private var _transformBounds:Rectangle = new Rectangle();
    
    /**
     *  @private
     */
    private var _computedGutters:Rectangle = new Rectangle();

    /**
     *  @private
     */
    private var _bAxisLayoutDirty:Boolean = true;
    
    /**
     *  @private
     */
    private var _bgridLinesStyleNameDirty:Boolean = true;
    
    /**
     *  @private
     */
    private var _defaultGridLines:GridLines;
    
    /**
     *  @private
     */
    private var _bAxisStylesDirty:Boolean = true;
    
    /**
     *  @private
     */
    private var _bAxesRenderersDirty:Boolean = false;

    /**
     *  @private
     */
    private var _bDualMode:Boolean = false;
    
    /**
     *  @private
     */
    private var _labelElements2:Array /* of DisplayObject */;
    
    /**
     *  @private
     */
    private var _allSeries:Array /* of Series */ = [];
    
    /**
     *  @private
     */
    private var _leftRenderers:Array /* of AxisRenderer */ = [];
    
    /**
     *  @private
     */
    private var _rightRenderers:Array /* of AxisRenderer */ = [];
    
    /**
     *  @private
     */
    private var _topRenderers:Array /* of AxisRenderer */ = [];
    
    /**
     *  @private
     */
    private var _bottomRenderers:Array /*of AxisRenderer */ = [];

    //--------------------------------------------------------------------------
    //
    //  Overridden properties: ChartBase
    //
    //--------------------------------------------------------------------------

    
    //----------------------------------
    //  backgroundElements
    //----------------------------------

    /**
     *  @private
     */
    override public function set backgroundElements(value:Array /* of ChartElement */):void
    {
        super.backgroundElements = value;
        
        _defaultGridLines = null;
    }

    //----------------------------------
    //  chartState
    //----------------------------------

    /**
     *  @private
     */
    override protected function setChartState(value:uint):void
    {
        if (chartState == value)
            return;

        var oldState:uint = chartState;

        super.setChartState(value);

        if (_horizontalAxisRenderer)
            _horizontalAxisRenderer.chartStateChanged(oldState, value);
        if (_verticalAxisRenderer)
            _verticalAxisRenderer.chartStateChanged(oldState, value);

        var n:uint = _horizontalAxisRenderers.length;
        
        
        for (var i:uint = 0; i < n; i++)
        {
            _horizontalAxisRenderers[i].chartStateChanged(oldState, value);
        }
        
        n = _verticalAxisRenderers.length;
        for (i = 0; i < n; i++)
        {
            _verticalAxisRenderers[i].chartStateChanged(oldState, value);
        }

    }
    
    //----------------------------------
    //  dataRegion
    //----------------------------------

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function get dataRegion():Rectangle
    {
        return _transformBounds;
    }
    
    //----------------------------------
    //  selectedChartItems
    //----------------------------------
    
    /**
     *  An Array of the selected ChartItem objects in the chart. This includes selected ChartItem
     *  objects in all of the chart's series.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function get selectedChartItems():Array /* of ChartItem */
    {
        var arr:Array /* of ChartItem */ = [];
        var n:int = _allSeries.length;
        for (var i:int = 0; i < n; i++)
        {
            var m:int = _allSeries[i].selectedItems.length;
            for (var j:int = 0; j < m; j++)
            {
                arr.push(_allSeries[i].selectedItems[j])
            }
        }   
        return arr; 
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  computedGutters
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The current computed size of the gutters of the CartesianChart.
     *  The gutters represent the area between the padding
     *  and the data area of the chart, where the titles and axes render.
     *  By default, the gutters are computed dynamically.
     *  You can set explicit values through the gutter styles.
     *  The gutters are computed to match any changes to the chart
     *  when it is validated by the LayoutManager.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get computedGutters():Rectangle
    {
        return _computedGutters;
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
        _bAxesRenderersDirty = true;

        invalidateData();
        invalidateProperties();
    }

    //----------------------------------
    //  horizontalAxisRatio
    //----------------------------------

    private var _horizontalAxisRatio:Number = 0.33;
    
    [Inspectable(category="Data")]
    
    /**
     *  Determines the height limit of the horiztonal axis.
     *  The limit is the width of the axis times this ratio.
     *
     *  @default 0.33.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get horizontalAxisRatio():Number
    {
        return _horizontalAxisRatio;
    }
    public function set horizontalAxisRatio(value:Number):void
    {
        _horizontalAxisRatio = value
    }
    
    //----------------------------------
    //  horizontalAxisRenderer
    //----------------------------------

    /**
     *  @private
     *  Storage for the horizontalAxisRenderer property.
     */
    private var _horizontalAxisRenderer:IAxisRenderer;
    
    [Inspectable(category="Data")]
    /**
     *  @private
     *  Specifies how data appears along the x-axis of a chart.
     *  Use the AxisRenderer class to define the properties
     *  for horizontalAxisRenderer as a child tag in MXML
     *  or create an AxisRenderer object in ActionScript.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    mx_internal function get horizontalAxisRenderer():IAxisRenderer
    {
        return _horizontalAxisRenderer;
    }

    /**
     *  @private
     */
    mx_internal function set horizontalAxisRenderer(value:IAxisRenderer):void
    {
        if (_horizontalAxisRenderer)
        {
            if (UIComponent(_horizontalAxisRenderer).parent == this)
                removeChild(UIComponent(_horizontalAxisRenderer));
            _horizontalAxisRenderer.otherAxes = (null);
        }

        _horizontalAxisRenderer = value;
        
        if (_horizontalAxisRenderer.axis)
            horizontalAxis = _horizontalAxisRenderer.axis;
            
        _horizontalAxisRenderer.horizontal = true;
        _bAxesRenderersDirty = true;
        _bAxisStylesDirty=true;

        invalidateChildOrder();
        invalidateProperties();
    }
    
    //----------------------------------
    //  horizontalAxisRenderers
    //----------------------------------

    /**
     *  @private
     *  Storage for the horizontalAxisRenderers property.
     */
    private var _horizontalAxisRenderers:Array /* of AxisRenderer */ = [];
    
    [Inspectable(category="Data", arrayType="mx.charts.chartClasses.IAxisRenderer")]
    
    /**
     *  Specifies how data appears along the x-axis of a chart.
     *  Use the AxisRenderer class to define the properties
     *  for horizontalAxisRenderer as a child tag in MXML
     *  or create an AxisRenderer object in ActionScript.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get horizontalAxisRenderers():Array /* of AxisRenderer */
    {
        return _horizontalAxisRenderers;
    }

    /**
     *  @private
     */
    public function set horizontalAxisRenderers(value:Array /* of AxisRenderer */):void
    {
        if (_horizontalAxisRenderers)
        {
            var n:int = _horizontalAxisRenderers.length;
            for (var i:int = 0; i < n; i++)
            {
                if (UIComponent(_horizontalAxisRenderers[i]).parent == this)
                    removeChild(UIComponent(_horizontalAxisRenderers[i]));
                _horizontalAxisRenderers[i].otherAxes = (null);
            }
        }

        _horizontalAxisRenderers = value;
        
        n = value.length;
        for (i = 0; i < n; i++)
        {
            _horizontalAxisRenderers[i].horizontal = true;
        }
        
        invalidateProperties();

        _bAxesRenderersDirty = true;
        _bAxisStylesDirty=true;

        invalidateChildOrder();
        invalidateProperties();
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
     *  to set the properties of the horizontal axis as a child tag in MXML
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
        _bAxesRenderersDirty = true;

        invalidateData();
        invalidateChildOrder();
        invalidateProperties();
    }

    //----------------------------------
    //  verticalAxisRatio
    //----------------------------------
    
    private var _verticalAxisRatio:Number = 0.33;
    
    [Inspectable(category="Data")]
    
    /**
     *  Determines the width limit of the vertical axis.
     *  The limit is the width of the axis times this ratio.
     *
     *  @default 0.33.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get verticalAxisRatio():Number
    {
        return _verticalAxisRatio;
    }
    public function set verticalAxisRatio(value:Number):void
    {
        _verticalAxisRatio = value;
    }

    //----------------------------------
    //  verticalAxisRenderer
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the verticalAxisRenderer property.
     */
    private var _verticalAxisRenderer:IAxisRenderer;
    
    [Inspectable(category="Data")]
    
    /**
     *  Specifies how data appears along the y-axis of a chart.
     *  Use the AxisRenderer class to set the properties
     *  for verticalAxisRenderer as a child tag in MXM
     *  or create an AxisRenderer object in ActionScript.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    mx_internal function get verticalAxisRenderer():IAxisRenderer
    {
        return _verticalAxisRenderer;
    }

    /**
     *  @private
     */
    mx_internal function set verticalAxisRenderer(value:IAxisRenderer):void
    {
        if (_verticalAxisRenderer)
            if (UIComponent(_verticalAxisRenderer).parent == this)
                removeChild(UIComponent(_verticalAxisRenderer));

        _verticalAxisRenderer = value;
        
        if (_verticalAxisRenderer.axis)
            verticalAxis = _verticalAxisRenderer.axis;

        _verticalAxisRenderer.horizontal = false;
        _bAxisStylesDirty=true;
        _bAxesRenderersDirty = true;
        
        invalidateChildOrder();
        invalidateProperties();
    }

    //----------------------------------
    //  verticalAxisRenderers
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the verticalAxisRenderers property.
     */
    private var _verticalAxisRenderers:Array /* of AxisRenderer */ = [];
    
    [Inspectable(category="Data", arrayType="mx.charts.chartClasses.IAxisRenderer")]

    /**
     *  Specifies how data appears along the y-axis of a chart.
     *  Use the AxisRenderer class to set the properties
     *  for verticalAxisRenderer as a child tag in MXML
     *  or create an AxisRenderer object in ActionScript.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get verticalAxisRenderers():Array /* of AxisRenderer */
    {
        return _verticalAxisRenderers;
    }

    /**
     *  @private
     */
    public function set verticalAxisRenderers(value:Array /* of AxisRenderer */):void
    {
        if (_verticalAxisRenderers)
        {
            var n:int = _verticalAxisRenderers.length;
            for (var i:int = 0; i < n; i++)
            {   
                if (UIComponent(_verticalAxisRenderers[i]).parent == this)
                    removeChild(UIComponent(_verticalAxisRenderers[i]));
            }
        }

        _verticalAxisRenderers = value;

        n = value.length;
        for (i = 0; i < n; i++)
        {
            _verticalAxisRenderers[i].horizontal = false;
        }
        
        invalidateProperties();
        
        _bAxisStylesDirty=true;
        _bAxesRenderersDirty = true;
        
        invalidateProperties();
    }
    
	/**
     *  @private
     */
    private function initStyles():Boolean
    {
        HaloDefaults.init(styleManager);
		
		var cartesianChartStyle:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, "mx.charts.chartClasses.CartesianChart");
		if (cartesianChartStyle)
		{
		cartesianChartStyle.setStyle("chartSeriesStyles", HaloDefaults.chartBaseChartSeriesStyles);
		cartesianChartStyle.setStyle("fill", new SolidColor(0xFFFFFF, 0));
		cartesianChartStyle.setStyle("calloutStroke", new SolidColorStroke(0x888888,2));
		cartesianChartStyle.setStyle("horizontalAxisStyleNames", ["blockCategoryAxis"]);
		cartesianChartStyle.setStyle("verticalAxisStyleNames", ["blockNumericAxis"]);
		}
		
        return true;
    }

    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

    
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
        //styleManager.registerInheritingStyle("axisTitleStyleName");
    }
	
	 
    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        if (_horizontalAxisRenderers.length == 0 && !_horizontalAxisRenderer)
            horizontalAxisRenderer = new AxisRenderer();
        if (_verticalAxisRenderers.length == 0 && !_verticalAxisRenderer)
            verticalAxisRenderer = new AxisRenderer();
            
        if (_bAxesRenderersDirty)
        {
            var addIndex:int = dataTipLayerIndex - 1;
            
            if (_horizontalAxisRenderer)
            {
                COMPILE::JS
                {
                    if (goog.DEBUG)
                        if (id)
                            UIComponent(_horizontalAxisRenderer).id = id + "_horizontalAxisRenderer";
                }
                addChild(UIComponent(_horizontalAxisRenderer));
                COMPILE::JS
                {
                    UIComponent(_horizontalAxisRenderer).element.style.position = "absolute";                        
                }
            }
            
            if (_verticalAxisRenderer)
            {
                COMPILE::JS
                {
                    if (goog.DEBUG)
                        if (id)
                            UIComponent(_verticalAxisRenderer).id = id + "_verticalAxisRenderer";
                }
                addChild(UIComponent(_verticalAxisRenderer));
                COMPILE::JS
                {
                    UIComponent(_verticalAxisRenderer).element.style.position = "absolute";
                }
            }

            invalidateDisplayList();

            if (_transforms)
            {
                CartesianTransform(_transforms[0]).setAxis(
                    CartesianTransform.HORIZONTAL_AXIS, _horizontalAxis);
                
                CartesianTransform(_transforms[0]).setAxis(
                    CartesianTransform.VERTICAL_AXIS, _verticalAxis);
            }

            if (_horizontalAxisRenderer)
                _horizontalAxisRenderer.axis = _horizontalAxis;
            if (_verticalAxisRenderer)
                _verticalAxisRenderer.axis = _verticalAxis;
                
            updateMultipleAxesRenderers();
            
            // now if the series is using the same axis as charts, its datatransform needs to have 
            // these new axes
            var n:int = series.length;
            
            for (var i:int = 0; i < n; i++) 
            {
                var g:Series;
                g = series[i];
                if (!g)
                    continue;
                    
                g.invalidateProperties();           
            }
        
            n = annotationElements.length;
            for (i = 0; i < n; i++)
            {
                var h:Object;
                h = annotationElements[i];
                if (!h)
                    continue;
                if (h is IDataCanvas)
                    h.invalidateProperties();
            }
            
            n = backgroundElements.length;
            for (i = 0; i < n; i++)
            {
                h = backgroundElements[i];
                if (!h)
                    continue;
                if (h is IDataCanvas)
                    h.invalidateProperties();
            }
            _bAxesRenderersDirty = false;
        }

        if (_bAxisStylesDirty)
        {
            if (_horizontalAxisRenderer && _horizontalAxisRenderer is DualStyleObject)
            {
                DualStyleObject(_horizontalAxisRenderer).internalStyleName =
                    getStyle("horizontalAxisStyleNames")[0];
            }

            if (_verticalAxisRenderer && _verticalAxisRenderer is DualStyleObject)
            {
                DualStyleObject(_verticalAxisRenderer).internalStyleName =
                    getStyle("verticalAxisStyleNames")[0];                  
            }

            updateMultipleAxesStyles();
            
            _bAxisStylesDirty = false;
        }

        if (_bgridLinesStyleNameDirty)
        {
            if (_defaultGridLines)
            {
                _defaultGridLines.internalStyleName =
                    getStyle("gridLinesStyleName");
            }
            _bgridLinesStyleNameDirty = false;
        }

        super.commitProperties();
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

        updateAxisLayout(unscaledWidth, unscaledHeight);
        
        advanceEffectState();
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
        if (_defaultGridLines && styleProp == "gridLinesStyleName")
        {
            _bgridLinesStyleNameDirty = true;
            _defaultGridLines.internalStyleName =
                    getStyle("gridLinesStyleName");
            invalidateDisplayList();
        }

        if (styleProp == null || styleProp.indexOf("gutter") == 0)
        {
            _bAxisLayoutDirty = true;
            invalidateDisplayList();
        }
        
        if (styleProp == null ||
            _horizontalAxisRenderers.length > 0 &&
            styleProp == "horizontalAxisStyleNames")
        {
            _bAxisStylesDirty = true;
            invalidateDisplayList();
        }

        if (styleProp == null ||
            _verticalAxisRenderers.length > 0 &&
            styleProp == "verticalAxisStyleNames")
        {
            _bAxisStylesDirty = true;
            invalidateDisplayList();
        }

        super.styleChanged(styleProp);
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: ChartBase
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
    override mx_internal function updateData():void
    {
        if (dataProvider != null)
            applyDataProvider(ICollectionView(dataProvider),_transforms[0]);
            
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override mx_internal function updateSeries():void
    {
        var displayedSeries:Array /* of Series */ = applySeriesSet(series,_transforms[0]);

        var i:int;
        var len:int = displayedSeries ? displayedSeries.length : 0;
        var c:UIComponent;
        var g:IChartElement;
        var labelLayer:UIComponent;

        removeElements(_backgroundElementHolder, true);
        removeElements(_seriesFilterer, false);
        removeElements(_annotationElementHolder, true);

        addElements(backgroundElements, _transforms[0], _backgroundElementHolder);
        allElements = backgroundElements.concat();
        
        addElements(displayedSeries,_transforms[0], _seriesFilterer);
        allElements = allElements.concat(displayedSeries);
        
        labelElements = [];
        
        var n:int = displayedSeries.length;
        for (i = 0; i < n; i++) 
        {
            g = displayedSeries[i] as IChartElement;
            if (!g)
                continue;
                
			Series(g).dataTransform = new CartesianTransform();
			
            Series(g).invalidateProperties();
            
            labelLayer = UIComponent(g.labelContainer);
            if (labelLayer) 
                labelElements.push(labelLayer);             
        }
        
        addElements(labelElements,_transforms[0],_annotationElementHolder);
        allElements = allElements.concat(labelElements);

        addElements(annotationElements,_transforms[0],_annotationElementHolder);
        allElements = allElements.concat(annotationElements);

        _transforms[0].elements = annotationElements.concat(displayedSeries).
                                        concat(backgroundElements);
        
        _allSeries = findSeriesObjects(series);
        invalidateData();
        invalidateSeriesStyles();
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override mx_internal function updateAxisOrder(nextIndex:int):int
    {
        if (_horizontalAxisRenderer)
            setChildIndex(UIComponent(_horizontalAxisRenderer), nextIndex++);
        
        if (_verticalAxisRenderer)
            setChildIndex(UIComponent(_verticalAxisRenderer), nextIndex++);

        var n: int = _horizontalAxisRenderers.length;
        for (var i:int = 0; i < n; i++)
        {
            setChildIndex(UIComponent(_horizontalAxisRenderers[i]), nextIndex++);
        }  
        
        n =   _verticalAxisRenderers.length;
        for (i = 0; i < n; i++)
        {
            setChildIndex(UIComponent(_verticalAxisRenderers[i]), nextIndex++);
        }    
        return nextIndex;
    }

    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function getLastItem(direction:String):ChartItem
    {
        var item:ChartItem = null
        
        if (_caretItem)
            item = Series(_caretItem.element).items[Series(_caretItem.element).items.length - 1];
        else
            item = getPreviousSeriesItem(_allSeries);
            
        return item;
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function getFirstItem(direction:String):ChartItem
    {
        var item:ChartItem = null;
        
        if (_caretItem)
            item = Series(_caretItem.element).items[0];
        else
            item = getNextSeriesItem(_allSeries);
        
        return item;
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function getNextItem(direction:String):ChartItem
    {
        if (direction == ChartBase.HORIZONTAL)   
            return getNextSeriesItem(_allSeries);
        else if (direction == ChartBase.VERTICAL)
            return getNextSeries(_allSeries);
        
        return null;
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function getPreviousItem(direction:String):ChartItem
    {                       
        if (direction == ChartBase.HORIZONTAL)   
            return getPreviousSeriesItem(_allSeries);
        else if (direction == ChartBase.VERTICAL)
            return getPreviousSeries(_allSeries);

        return null;
    }
    
    
    override mx_internal function getSeriesTransformState(seriesObject:Object):Boolean
    {
        var bState:Boolean;
        if (seriesObject is StackedSeries)
        {
            var n:int = (seriesObject as StackedSeries).series.length;
            for (var i:int = 0; i < n; i++)
            {
                bState = getSeriesTransformState((seriesObject as StackedSeries).series[i]);                
                if (bState)
                    return true;
            }
            return false;
        }
        else
        {
            return (seriesObject as Series).getTransformState();
        }
    }
    
    /**
     *  @private
     */
    override mx_internal function updateKeyboardCache():void
    {
        // Check whether all the series' transformations have been done, otherwise Series' renderdata would not be valid and hence the display too.
        // This is done as setting up KeyboardCache can take sometime, if done on first access.
        
        var n:int = _transforms.length;   
        var i:int;  
        var j:int; 
        var m:int;     
        for (i = 0; i < n; i++)
        {
            m = _transforms[i].elements.length;
            for (j = 0; j < m; j++)
            {
                if (_transforms[i].elements[j] is Series && getSeriesTransformState(_transforms[i].elements[j]) == true)
                    return;
            }
        }
        
        // Restore selection
        
        var arrObjects:Array /* of Object */ = [];
        var arrSelect:Array /* of ChartItem */ = [];
        var arrItems:Array /* of ChartItem */;
        var index:int;
        var bExistingSelection:Boolean = false;
        var nCount:int = 0;
        n  = _allSeries.length;
        for (i = 0; i < n; i++)
        {
            arrItems = _allSeries[i].items;
            if (arrItems && _allSeries[i].selectedItems.length > 0)
            {
                bExistingSelection = true;
                m = arrItems.length;
                for (j = 0; j < m; j++)
                {
                    arrObjects.push(arrItems[j].item);
                }
                nCount += _allSeries[i].selectedItems.length; 
                m = _allSeries[i].selectedItems.length;          
                for (j = 0; j < m; j++)
                {
                    index = arrObjects.indexOf(_allSeries[i].selectedItems[j].item);
                    if (index != -1)
                        arrSelect.push(_allSeries[i].items[index]);
                }
                arrObjects = [];
                _allSeries[i].emptySelectedItems();
            }
        }
        
        if (bExistingSelection)
        {
            selectSpecificChartItems(arrSelect);
            if (nCount != arrSelect.length)
                dispatchEvent(new ChartItemEvent(ChartItemEvent.CHANGE,null,null,this));
        }
    }
        
    /**
     *  @private
     */
    override protected function keyDownHandler(event:KeyboardEvent):void
    {
        if (selectionMode == "none")
            return;
            
        var item:ChartItem = null;
        var bSpace:Boolean = false;
        
        switch (event.keyCode)
        {
            case Keyboard.UP:
            {
                item = getNextItem(ChartBase.VERTICAL);
                break;
            }    
            case Keyboard.DOWN:
            {
                item = getPreviousItem(ChartBase.VERTICAL);                     
                break;
            }
            case Keyboard.LEFT:
            {
                item = getPreviousItem(ChartBase.HORIZONTAL);                       
                break;
            }    
            case Keyboard.RIGHT:
            {
                item = getNextItem(ChartBase.HORIZONTAL);                       
                break;
            }
            case Keyboard.END:
            case Keyboard.PAGE_DOWN:
            {
                item = getLastItem(ChartBase.HORIZONTAL);
                break;
            }    
            case Keyboard.HOME:
            case Keyboard.PAGE_UP:
            {
                item = getFirstItem(ChartBase.HORIZONTAL);
                break;
            }
            case Keyboard.SPACE:
            {
                handleSpace(event);
                event.stopPropagation();
                return;
            }               
            default:
            {
                break;
            }
        }
        
        if (item)
        {
            event.stopImmediatePropagation();
            handleNavigation(item,event);
        }
    }
    
    /**
     *  @private
     */
    override protected function measure():void
    {
        super.measure();
        
        if (_horizontalAxisRenderer)
            measuredMinHeight = _horizontalAxisRenderer.minHeight + 40;
        
        if (_verticalAxisRenderer)
            measuredMinWidth = _verticalAxisRenderer.minWidth + 40;
        
        var n:int = _horizontalAxisRenderers.length;
        for (var i:int = 0; i < n; i++)
        {
            measuredMinHeight += (_horizontalAxisRenderers[i].minHeight + 40);
        }    
        
        n = _verticalAxisRenderers.length;
        for (i = 0; i < n; i++)
        {
            measuredMinWidth += (_verticalAxisRenderers[i].minWidth + 40);
        }
    }
    
            
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    protected function updateAxisLayout(unscaledWidth:Number,
                                      unscaledHeight:Number):void
    {
        var paddingLeft:Number = getStyle("paddingLeft");
        var paddingRight:Number = getStyle("paddingRight");
        var paddingTop:Number = getStyle("paddingTop");
        var paddingBottom:Number = getStyle("paddingBottom");

        var gutterLeft:Object = getStyle("gutterLeft");
        var gutterRight:Object = getStyle("gutterRight");
        var gutterTop:Object = getStyle("gutterTop");
        var gutterBottom:Object = getStyle("gutterBottom");
        var i:int = 0;
        var n:int = 0;
        var hLen:uint = _horizontalAxisRenderers.length;
        var vLen:uint = _verticalAxisRenderers.length;
        var leftLen:uint = _leftRenderers.length;
        var rightLen:uint = _rightRenderers.length;
        var bottomLen:uint = _bottomRenderers.length;
        var topLen:uint = _topRenderers.length;
        
        var adjustable:Object = {};
        var offset:Object = {left:0, top:0, right: 0, bottom: 0};
        
        if (!isNaN(horizontalAxisRatio))
        {
            if (_horizontalAxisRenderer)
                _horizontalAxisRenderer.heightLimit =
                    horizontalAxisRatio * unscaledHeight;
                
            for (i = 0; i < hLen; i++)
            {
                _horizontalAxisRenderers[i].heightLimit = horizontalAxisRatio * unscaledHeight;
            }
        }

        if (!isNaN(verticalAxisRatio))
        {
            if (_verticalAxisRenderer)
                _verticalAxisRenderer.heightLimit =
                    verticalAxisRatio * unscaledWidth;
                
            for (i = 0; i < vLen; i++)
            {
                _verticalAxisRenderers[i].heightLimit = verticalAxisRatio * unscaledWidth;
            }
        }
        
        if (_horizontalAxisRenderer)
        {
            _horizontalAxisRenderer.setActualSize(
                unscaledWidth - paddingLeft - paddingRight,
                unscaledHeight - paddingTop - paddingBottom);
        
            _horizontalAxisRenderer.move(paddingLeft, paddingTop);
        }
        
        for (i = 0; i < hLen; i++)
        {
            _horizontalAxisRenderers[i].setActualSize(
                unscaledWidth - paddingLeft - paddingRight,
                unscaledHeight - paddingTop - paddingBottom);
                
            _horizontalAxisRenderers[i].move(paddingLeft, paddingTop);
        }
        
        if (_verticalAxisRenderer)
        {       
            _verticalAxisRenderer.setActualSize(
                unscaledWidth - paddingLeft - paddingRight,
                unscaledHeight - paddingTop - paddingBottom);
    
            _verticalAxisRenderer.move(paddingLeft, paddingTop);
        }
        
        for (i = 0; i < vLen; i++)
        {
            _verticalAxisRenderers[i].setActualSize(
                unscaledWidth - paddingLeft - paddingRight,
                unscaledHeight - paddingTop - paddingBottom);
                
            _verticalAxisRenderers[i].move(paddingLeft, paddingTop);
        }
        
        // Fallback to the previous algorithm
        if (vLen == 0 && hLen == 0)
        {
            if (_horizontalAxisRenderer.placement == "")
                _horizontalAxisRenderer.placement = "bottom";
                
            if (_verticalAxisRenderer.placement == "")
                _verticalAxisRenderer.placement = "left";
    
            _computedGutters = new Rectangle();
            if (gutterLeft != null)
            {
                _computedGutters.left = Number(gutterLeft);
                adjustable.left = false;
            }
            if (gutterRight != null)
            {
                _computedGutters.right = Number(gutterRight);
                adjustable.right = false;
            }
            if (gutterTop != null)
            {
                _computedGutters.top = Number(gutterTop);
                adjustable.top = false;
            }
            if (gutterBottom != null)
            {
                _computedGutters.bottom = Number(gutterBottom);
                adjustable.bottom = false;
            }
    
            var otherAxes:Array /* of AxisRenderer */ = [];
            otherAxes.push(_verticalAxisRenderer);
                  
            _horizontalAxisRenderer.otherAxes = otherAxes;
                
            _computedGutters = _verticalAxisRenderer.adjustGutters(
                                    _computedGutters, adjustable);
    
            _computedGutters = _horizontalAxisRenderer.adjustGutters(
                                        _computedGutters, adjustable);
    
            _verticalAxisRenderer.gutters = _computedGutters;
            
        }
        else // the new algo for calculating the gutters
        {                       
            _computedGutters = new Rectangle();     
            if (gutterLeft != null)
            {
                offset.left = Number(gutterLeft) / leftLen;
                adjustable.left = false;
            }
            if (gutterRight != null)
            {
                offset.right = Number(gutterRight) / rightLen;
                adjustable.right = false;
            }
            if (gutterTop != null)
            {
                offset.top = Number(gutterTop) / topLen;
                adjustable.top = false;
            }
            if (gutterBottom != null)
            {
                offset.bottom = Number(gutterBottom) / bottomLen;
                adjustable.bottom = false;
            }               
    
            var prevLeftOffset:Number = 0;
            var prevRightOffset:Number = 0;
            var prevBottomOffset:Number = 0;
            var prevTopOffset:Number = 0;
            var maxTopGutter:Number = 0;
            var maxBottomGutter:Number = 0;
                                
            // Calculate the left gutters
                
            for (i = 0; i < leftLen; i++)
            {
                if (offset.left == 0)
                    _computedGutters.left = 0;
                else
                    _computedGutters.left = offset.left * (i + 1); 
                _computedGutters = _leftRenderers[i].adjustGutters(_computedGutters, adjustable);
                
                var rect:Rectangle = _computedGutters.clone();
                if (rect.top > maxTopGutter)
                    maxTopGutter = rect.top;
                if (rect.bottom > maxBottomGutter)
                    maxBottomGutter = rect.bottom;
                    
                if (offset.left == 0)
                    rect.left += prevLeftOffset;
                
                if (rect.left > unscaledWidth)
                    rect.left = unscaledWidth;
                        
                _leftRenderers[i].gutters = rect;
                
                if (offset.left == 0)
                    prevLeftOffset += _computedGutters.left;       
            }
            if (prevLeftOffset > unscaledWidth)
                prevLeftOffset = unscaledWidth;
                
            if (offset.left == 0)
                _computedGutters.left = prevLeftOffset;         
            else
                _computedGutters.left = Number(gutterLeft);
            // Calculate the right gutters
            
            for (i = 0; i < rightLen; i++)
            {
                if (offset.right == 0)
                    _computedGutters.right = 0;
                else
                    _computedGutters.right = offset.right * (i + 1);
                _computedGutters = _rightRenderers[i].adjustGutters(_computedGutters, adjustable);
                
                rect = _computedGutters.clone();
                
                if (rect.top > maxTopGutter)
                    maxTopGutter = rect.top;
                if (rect.bottom > maxBottomGutter)
                    maxBottomGutter = rect.bottom;    
                                   
                if (offset.right == 0)
                    rect.right += prevRightOffset;
                                  
                if (rect.right > unscaledWidth)
                    rect.right = unscaledWidth;
                    
                _rightRenderers[i].gutters = rect;
                
                if (offset.right == 0)
                    prevRightOffset += _computedGutters.right;
            }
            if (prevRightOffset > unscaledWidth)
                prevRightOffset = unscaledWidth;
    
            // Have the extreme left and right offsets for computedGutters for computation of top and bottom.
                
            if (offset.right == 0)
                _computedGutters.right = prevRightOffset;
            else
                _computedGutters.right = Number(gutterRight);
    
            // Add only the last renderers as the other axes to the horizontalAxis renderers
            
            var other:Array /* of AxisRenderer */ = [];
            if (leftLen > 0)
                other.push(_leftRenderers[leftLen - 1]);
            if (rightLen > 0)
                other.push(_rightRenderers[rightLen - 1]);
            
            // Calculate the bottom gutters
                
            for (i = 0; i < bottomLen; i++)
            {                       
                if (offset.bottom == 0)
                    _computedGutters.bottom = 0;
                else
                    _computedGutters.bottom = offset.bottom * (i + 1);  
                    
                _bottomRenderers[i].otherAxes = other;
                _computedGutters = _bottomRenderers[i].adjustGutters(_computedGutters, adjustable);
                
                rect = _computedGutters.clone();
                
                if (offset.bottom == 0)
                    rect.bottom += prevBottomOffset;                   
                if (rect.bottom > unscaledHeight)
                    rect.bottom = unscaledHeight;
                
                _bottomRenderers[i].gutters = rect;
                
                if (offset.bottom == 0)
                    prevBottomOffset += _computedGutters.bottom;
            }
            
            if (prevBottomOffset > unscaledHeight)
                prevBottomOffset = unscaledHeight;
                    
            // Calculate the top gutters
            
            for (i = 0; i < topLen; i++)
            {
                if (offset.top == 0)
                    _computedGutters.top = 0;
                else
                    _computedGutters.top = offset.top * (i + 1);
                
                _topRenderers[i].otherAxes = other;
                _computedGutters = _topRenderers[i].adjustGutters(_computedGutters, adjustable);
                
                rect = _computedGutters.clone();
                
                if (offset.top == 0)
                    rect.top += prevTopOffset;

                
                if (rect.top > unscaledHeight)
                    rect.top = unscaledHeight;
                    
                _topRenderers[i].gutters = rect;
                
                if (offset.top == 0)
                    prevTopOffset += _computedGutters.top;
            }
            
            if (prevTopOffset > unscaledHeight)
                prevTopOffset = unscaledHeight;
    
            if (offset.bottom == 0)
                _computedGutters.bottom = prevBottomOffset;
            else
                _computedGutters.bottom = Number(gutterBottom);
                
            if (offset.top == 0)
                _computedGutters.top = prevTopOffset;
            else
                _computedGutters.top = Number(gutterTop);
                
            if (topLen == 0)
                _computedGutters.top += maxTopGutter;
            if (bottomLen == 0)
                _computedGutters.bottom += maxBottomGutter;
            
            // Just assign the top and bottom gutters to the left and right renderers now, no need to adjust again.
            
            for (i = 0; i < leftLen; i++)
            {
                rect = _leftRenderers[i].gutters;
                rect.top = _computedGutters.top;
                rect.bottom = _computedGutters.bottom;
                _leftRenderers[i].gutters = rect;
            }
                                                
            for (i = 0; i < rightLen; i++)
            {
                rect = _rightRenderers[i].gutters;
                rect.top = _computedGutters.top;
                rect.bottom = _computedGutters.bottom;
                _rightRenderers[i].gutters = rect;
            }
        }
        
        // Calculate the transformBounds

        _transformBounds = new Rectangle(
            _computedGutters.left + paddingLeft,
            _computedGutters.top + paddingTop,
            unscaledWidth - _computedGutters.right - paddingRight -
            (_computedGutters.left + paddingLeft),
            unscaledHeight - _computedGutters.bottom - paddingBottom -
            (_computedGutters.top + paddingTop));
        
        if (_transforms)
        {
            n = _transforms.length;
            for (i = 0; i < n; i++)
            {
                _transforms[i].pixelWidth = _transformBounds.width;
                _transforms[i].pixelHeight = _transformBounds.height;
            }
        }
        
        n = allElements.length;
        for (i = 0; i < n; i++)
        {
            var c:UIComponent = allElements[i];
            if (c is IUIComponent)
            {
                (c as IUIComponent).setActualSize(_transformBounds.width,
                                                 _transformBounds.height);
            }
            else
            {
                c.width = _transformBounds.width;
                c.height = _transformBounds.height;
            }
            
            if (c is Series && Series(c).dataTransform)
            {
                CartesianTransform(Series(c).dataTransform).pixelWidth = _transformBounds.width;
                CartesianTransform(Series(c).dataTransform).pixelHeight = _transformBounds.height;
            }
            
            if (c is IDataCanvas && (c as Object).dataTransform)
            {
                CartesianTransform((c as Object).dataTransform).pixelWidth = _transformBounds.width;
                CartesianTransform((c as Object).dataTransform).pixelHeight = _transformBounds.height;
            }
        }
        
        if (_seriesHolder.mask)
        {
            _seriesHolder.mask.width = _transformBounds.width;
            _seriesHolder.mask.height = _transformBounds.height;
        }
        
        if (_backgroundElementHolder.mask)
        {
            _backgroundElementHolder.mask.width = _transformBounds.width;
            _backgroundElementHolder.mask.height = _transformBounds.height;
        }
        
        if (_annotationElementHolder.mask)
        {
            _annotationElementHolder.mask.width = _transformBounds.width;
            _annotationElementHolder.mask.height = _transformBounds.height;
        }
        
        _seriesHolder.x = _transformBounds.left
        _seriesHolder.y = _transformBounds.top;

        _backgroundElementHolder.move(_transformBounds.left,
                                      _transformBounds.top);

        _annotationElementHolder.move(_transformBounds.left,
                                      _transformBounds.top);

        _bAxisLayoutDirty = false;
    }
    
    /**
     *  @private
     */
     
    private function findSeriesObjects(s:Array /* of Series */):Array /* of Series */
    {
        var arrSeries:Array /* of Series */ = [];
        
        var n:int = s.length;
        for (var i:int = 0; i < n; i++)
        {
            if (s[i] is StackedSeries)
                arrSeries = arrSeries.concat(findSeriesObjects(s[i].series))
            else
                arrSeries.push(s[i]);
        }    
        return arrSeries;
    }
    
        mx_internal function adjustAxesPlacements():void
    {
        var emptyhorizontalRenderers:Array /* of AxisRenderer */ = [];
        var emptyverticalRenderers:Array /* of AxisRenderer */ = [];
        
        _leftRenderers = [];
        _rightRenderers = [];
        _bottomRenderers = [];
        _topRenderers = [];
        
        var hLen:uint = _horizontalAxisRenderers.length;
        var vLen:uint = _verticalAxisRenderers.length;
        var leftLen:uint;
        var rightLen:uint;
        var topLen:uint;
        var bottomLen:uint;
        var emptyhLen:uint;
        var emptyvLen:uint;
        
        for (var i:int = 0; i < hLen; i++)
        {
            if (_horizontalAxisRenderers[i].placement == "bottom")
                _bottomRenderers.push(_horizontalAxisRenderers[i]);
            else if (_horizontalAxisRenderers[i].placement == "top")
                    _topRenderers.push(_horizontalAxisRenderers[i]);
                 else
                    emptyhorizontalRenderers.push(_horizontalAxisRenderers[i]);
        }
        
        for (i =0; i< vLen; i++)
        {
            if (_verticalAxisRenderers[i].placement == "left")
                _leftRenderers.push(_verticalAxisRenderers[i]);
            else if (_verticalAxisRenderers[i].placement == "right")
                    _rightRenderers.push(_verticalAxisRenderers[i]);
                 else
                    emptyverticalRenderers.push(_verticalAxisRenderers[i]);                 
        }
        
        if (_horizontalAxisRenderer)
        {
            if (_horizontalAxisRenderer.placement == "bottom")
                _bottomRenderers.push(_horizontalAxisRenderer);
            else if (_horizontalAxisRenderer.placement == "top")
                    _topRenderers.push(_horizontalAxisRenderer);
                else
                    emptyhorizontalRenderers.push(_horizontalAxisRenderer); 
        }
        
        if (_verticalAxisRenderer)
        {
            if (_verticalAxisRenderer.placement == "left")
                _leftRenderers.push(_verticalAxisRenderer);
            else if (_verticalAxisRenderer.placement == "right")
                    _rightRenderers.push(_verticalAxisRenderer);
                 else
                    emptyverticalRenderers.push(_verticalAxisRenderer);
        }
        
        // Adjust the placements
        
        leftLen = _leftRenderers.length;
        rightLen = _rightRenderers.length;
        topLen = _topRenderers.length;
        bottomLen = _bottomRenderers.length;
        emptyhLen = emptyhorizontalRenderers.length;
        emptyvLen = emptyverticalRenderers.length;
        var nCount:uint = 0;
        
        // Adjust vertical placements
        if (leftLen > rightLen)
            for (nCount = 0; nCount < leftLen - rightLen && nCount < emptyvLen; nCount++)
            {
                _rightRenderers.push(emptyverticalRenderers[nCount]);
                emptyverticalRenderers[nCount].placement = "right";
            }
        else if (leftLen < rightLen)
            for (nCount = 0; nCount < rightLen - leftLen && nCount < emptyvLen; nCount++)
            {
                _leftRenderers.push(emptyverticalRenderers[nCount]);
                emptyverticalRenderers[nCount].placement = "left";
            }
        
        // Adjust remaining vertical placements     
        for (i = nCount;i < emptyvLen; i++)
        {
            if (i%2 == 0)
            {
                _leftRenderers.push(emptyverticalRenderers[i]);
                emptyverticalRenderers[i].placement = "left";
            }
            else
            {
                _rightRenderers.push(emptyverticalRenderers[i]);
                emptyverticalRenderers[i].placement = "right";
            }
        }
        
        // Adjust horizontal placements
        if (bottomLen > topLen)
            for (nCount = 0; nCount < bottomLen - topLen && nCount < emptyhLen; nCount++)
            {
                _topRenderers.push(emptyhorizontalRenderers[nCount]);
                emptyhorizontalRenderers[nCount].placement = "top";
            }
        else if (topLen < bottomLen)
            for (nCount = 0; nCount < topLen - bottomLen && nCount < emptyhLen; nCount++)
            {
                _bottomRenderers.push(emptyhorizontalRenderers[nCount]);
                emptyhorizontalRenderers[nCount].placement = "bottom";
            }
                
        // Adjust remaining horizontal placements
        for (i = nCount; i < emptyhLen; i++)
        {
            if (i%2 == 0)
            {
                _bottomRenderers.push(emptyhorizontalRenderers[i]);
                emptyhorizontalRenderers[i].placement = "bottom";
            }
            else
            {
                _topRenderers.push(emptyhorizontalRenderers[i]);
                emptyhorizontalRenderers[i].placement = "top";
            }
        }
    }
    
    private function updateMultipleAxesStyles():void
    {
        var hsNames:Array /* of String */ = getStyle("horizontalAxisStyleNames");
        var vsNames:Array /* of String */ = getStyle("verticalAxisStyleNames");
        
        var n:uint = _horizontalAxisRenderers.length;
        
        var hslen:uint = hsNames.length;
        var vslen:uint = vsNames.length;
        
        for (var i:int = 0; i < n; i ++)
        {
            if (_horizontalAxisRenderers[i] is DualStyleObject)
            {
                DualStyleObject(_horizontalAxisRenderers[i]).internalStyleName =
                    hsNames[i % hslen];
            }
        }
        
        n = _verticalAxisRenderers.length;
        for (i = 0; i < n; i++)
        {
            if (_verticalAxisRenderers[i] is DualStyleObject)
            {
                DualStyleObject(_verticalAxisRenderers[i]).internalStyleName =
                    vsNames[i % vslen];
            }
        }
    }
    
    private function updateMultipleAxesRenderers():void
    {
        var n:uint = _horizontalAxisRenderers.length;                    
        for (var i:int = 0; i < n; i++)
        {
            COMPILE::JS
            {
                if (goog.DEBUG)
                    if (id)
                        UIComponent(_horizontalAxisRenderers[i]).id = id + "_horizontalAxisRenderers" + i.toString();
            }
            addChild(UIComponent(_horizontalAxisRenderers[i]));
            COMPILE::JS
            {
                UIComponent(_horizontalAxisRenderers[i]).element.style.position = "absolute";
            }
       }
        
        n = _verticalAxisRenderers.length;
        for (i = 0; i < n; i++)
        {
            COMPILE::JS
            {
                if (goog.DEBUG)
                    if (id)
                        UIComponent(_verticalAxisRenderers[i]).id = id + "_verticalAxisRenderer" + i.toString();
            }
            addChild(UIComponent(_verticalAxisRenderers[i]));
            COMPILE::JS
            {
                UIComponent(_verticalAxisRenderer[i]).element.style.position = "absolute";
            }
        }
        adjustAxesPlacements();
                                
        invalidateDisplayList();
    }
    
    /**
     * @private
     */
    private function axisPlacementChangeHandler(event:Event):void
    {
        adjustAxesPlacements();
        invalidateDisplayList();
    }
    
    mx_internal function measureLabels():Object
    {
        return null;
    }
    
    mx_internal function getLeftMostRenderer():IAxisRenderer
    {
        var n:int = _leftRenderers.length;
        if (n > 0)
            return _leftRenderers[n - 1];
        return null;
    }
    
    mx_internal function getRightMostRenderer():IAxisRenderer
    {
        var n:int = _rightRenderers.length;
        if (n > 0)
            return _rightRenderers[n - 1];
        return null;
    }
    
    mx_internal function getTopMostRenderer():IAxisRenderer
    {
        var n:int = _topRenderers.length;
        if (n > 0)
            return _topRenderers[n - 1];
        return null;
    }
    
    mx_internal function getBottomMostRenderer():IAxisRenderer
    {
        var n:int = _bottomRenderers.length;
        if (n > 0)
            return _bottomRenderers[n - 1];
        return null;
    }
}
}
