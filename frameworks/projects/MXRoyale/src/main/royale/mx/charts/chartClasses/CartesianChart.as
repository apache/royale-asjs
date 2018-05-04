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
	COMPILE::JS {
		import goog.DEBUG;
	}
	import org.apache.royale.events.Event;
	import mx.core.IFlexDisplayObject;
	import org.apache.royale.geom.Point;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.events.KeyboardEvent;
	import mx.charts.ChartItem;
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
/*
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Keyboard;
import flash.utils.Dictionary;

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
*/
//--------------------------------------
//  Styles
//--------------------------------------
//include "../styles/metadata/TextStyles.as"

/**
 *  The name of the CSS class selector to use
 *  when formatting titles on the axes.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="axisTitleStyleName", type="String", inherit="yes")]

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
//[Style(name="gridLinesStyleName", type="String", inherit="no")]

/**
 *  The size of the region, in pixels, between the bottom
 *  of the chart data area and the bottom of the chart control.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="gutterBottom", type="Number", format="Length", inherit="no")]

/**
 *  The size of the region, in pixels, between the left
 *  of the chart data area and the left of the chart control.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="gutterLeft", type="Number", format="Length", inherit="no")]

/**
 *  The size of the region, in pixels, between the right
 *  side of the chart data area and the outside of the chart control.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="gutterRight", type="Number", format="Length", inherit="no")]

/**
 *  The size of the region, in pixels, between the top
 *  of the chart data area and the top of the chart control.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="gutterTop", type="Number", format="Length", inherit="no")]

/**
 *  An array of class selectors that define the style properties
 *  for horizontal axes.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="horizontalAxisStyleNames", type="Array", arrayType="String", inherit="no")]

/**
 *  An array of class selectors that define the style properties
 *  for vertical axes.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="verticalAxisStyleNames", type="Array", arrayType="String", inherit="no")]

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
    //include "../../core/Version.as";

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
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    //private static var _moduleFactoryInitialized:Dictionary = new Dictionary(true);
    
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
    //private var _defaultGridLines:GridLines;
    
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
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  horizontalAxis
    //----------------------------------

    /**
     *  @private
     *  Storage for the horizontalAxis property.
     */
    private var _horizontalAxis:IAxis;
    
    //[Inspectable(category="Data")]

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

        //invalidateData();
        //invalidateProperties();
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
                //if (DisplayObject(_horizontalAxisRenderers[i]).parent == this)
                //    removeChild(DisplayObject(_horizontalAxisRenderers[i]));
                _horizontalAxisRenderers[i].otherAxes = (null);
            }
        }

        _horizontalAxisRenderers = value;
        
        n = value.length;
        for (i = 0; i < n; i++)
        {
            _horizontalAxisRenderers[i].horizontal = true;
        }
        
        //invalidateProperties();

        _bAxesRenderersDirty = true;
        _bAxisStylesDirty=true;

        //invalidateChildOrder();
        //invalidateProperties();
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
                //if (DisplayObject(_verticalAxisRenderers[i]).parent == this)
                //    removeChild(DisplayObject(_verticalAxisRenderers[i]));
            }
        }

        _verticalAxisRenderers = value;

        n = value.length;
        for (i = 0; i < n; i++)
        {
            _verticalAxisRenderers[i].horizontal = false;
        }
        
        //invalidateProperties();
        
        _bAxisStylesDirty=true;
        _bAxesRenderersDirty = true;
        
        //invalidateProperties();
    }    
}
}
