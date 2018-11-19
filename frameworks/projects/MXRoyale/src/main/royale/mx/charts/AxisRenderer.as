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

import mx.display.Graphics;
import org.apache.royale.events.Event;
import org.apache.royale.events.MouseEvent;
import org.apache.royale.geom.Matrix;
import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;
import org.apache.royale.reflection.getDefinitionByName;
import mx.text.TextFormat;
import org.apache.royale.reflection.getQualifiedClassName;

import mx.charts.chartClasses.AxisBase;
import mx.charts.chartClasses.AxisLabelSet;
import mx.charts.chartClasses.ChartBase;
import mx.charts.chartClasses.ChartLabel;
import mx.charts.chartClasses.ChartState;
import mx.charts.chartClasses.DualStyleObject;
import mx.charts.chartClasses.IAxis;
import mx.charts.chartClasses.IAxisRenderer;
import mx.charts.chartClasses.InstanceCache;
import mx.charts.styles.HaloDefaults;
import mx.core.ClassFactory;
//import mx.core.ContextualClassFactory;
import mx.core.IDataRenderer;
import mx.core.IFactory;
import mx.core.IFlexDisplayObject;
import mx.core.IFlexModuleFactory;
import mx.core.IUIComponent;
import mx.core.IUITextField;
//import mx.core.LayoutDirection;
import mx.core.UIComponent;
import mx.core.UITextField;
import mx.core.UITextFormat;
import mx.core.mx_internal;
import mx.graphics.IStroke;
import mx.graphics.SolidColorStroke;
import mx.graphics.Stroke;
import mx.managers.ILayoutManagerClient;
import mx.managers.ISystemManager;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;
import mx.styles.CSSStyleDeclaration;
import mx.styles.ISimpleStyleClient;

use namespace mx_internal;

//--------------------------------------
//  Styles
//--------------------------------------

include "styles/metadata/TextStyles.as"

/**
 *  Specifies the characteristics of the line for the axis.
 *  This style must be an instance of the Stroke class.  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="axisStroke", type="mx.graphics.IStroke", inherit="no")]

/**
 *  The name of the CSS class selector to use when formatting the axis title.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="axisTitleStyleName", type="String", inherit="yes")]

/**
 *  Specifies whether the AxisRenderer should drop labels
 *  as necessary to lay out correctly.
 *
 *  <p>Set to <code>true</code> to cause the AxisRenderer
 *  to drop overlapping labels when rendering.
 *  Labels are always rendered at regular intervals.
 *  If necessary, the AxisRenderer will render every other label,
 *  or every third label, but never drop two or more consecutive labels.</p>
 *
 *  <p>Set to <code>false</code> to cause the AxisRenderer
 *  to use other schemes (rotation, scaling) to lay out the labels.</p>
 *
 *  <p>If you do not explicitly set this style, the AxisRenderer defaults
 *  to an appropriate value based on the type of axis being rendered.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="canDropLabels", type="Boolean", inherit="no")]

/** 
 *  Specifies whether to stagger labels on two label rows.
 *  Use this setting to minimize the space required for the labels.  
 *  The default value is <code>true</code>, which staggers the labels. 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="canStagger", type="Boolean", inherit="no")]

/**
 *  Specifies the alignment of label with respect to
 *  the position of the value it points to.
 * 
 *  @default center
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="labelAlign", type="String", enumeration="left,top,right,bottom,center", inherit="no")]

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
/** 
 *  Specifies the gap between the end of the tick marks
 *  and the top of the labels, in pixels. 
 *  
 *  @default 3 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="labelGap", type="Number", format="Length", inherit="no")]

/** 
 *  Specifies the label rotation.
 *  If the labels are rendered with device fonts,
 *  the labels are always drawn horizontally.
 *  If this style is any negative value,
 *  the AxisRenderer determines an optimal angle to render
 *  the labels in the smallest area without overlapping.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="labelRotation", type="Number", inherit="no")]

/**
 *  Specifies the length of the minor tick marks on the axis, in pixels. 
 *  
 *  @default 0
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="minorTickLength", type="Number", format="Length", inherit="no")]

/**
 *  Specifies where to draw the minor tick marks. Options are:
 *  <ul>
 *    <li><code>"inside"</code> -
 *    Draw minor tick marks inside the data area.</li>
 *
 *    <li><code>"outside"</code> -
 *    Draw minor tick marks in the label area.</li>
 *
 *    <li><code>"cross"</code> -
 *    Draw minor tick marks across the axis.</li>
 *
 *    <li><code>"none"</code> -
 *    Draw no minor tick marks.</li>
 *  </ul>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="minorTickPlacement", type="String", enumeration="inside,outside,cross,none", inherit="no")]

/**
 *  Specifies the characteristics of the minor tick marks on the axis.
 *  This style must be an instance of the Stroke class.  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="minorTickStroke", type="mx.graphics.IStroke", inherit="no")]

/**
 *  Specifies whether labels should appear along the axis. 
 *  
 *  @default true 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="showLabels", type="Boolean", inherit="no")]

/**
 *  Specifies whether to display the axis. 
 *  
 *  @default true 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="showLine", type="Boolean", inherit="no")]

/**
 *  Specifies the length of the tick marks on the axis, in pixels. 
 *  
 *  @default 3  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="tickLength", type="Number", format="Length", inherit="no")]

/**
 *  Specifies where to draw the tick marks. Options are:
 *  <ul>
 *    <li><code>"inside"</code> -
 *    Draw tick marks inside the data area.</li>
 *
 *    <li><code>"outside"</code> -
 *    Draw tick marks in the label area.</li>
 *
 *    <li><code>"cross"</code> -
 *    Draw tick marks across the axis.</li>
 *
 *    <li><code>"none"</code> -
 *    Draw no tick marks.</li>
 *  </ul>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="tickPlacement", type="String", enumeration="inside,outside,cross,none", inherit="no")]

/**
 *  Specifies the characteristics of the tick marks on the axis.
 *  This style must be an instance of the Stroke class.  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="tickStroke", type="mx.graphics.IStroke", inherit="no")]

/**
 *  Specifies how vertical axis title is to be rendered.
 *  <code>flippedVertical</code> renders the title top to bottom
 *  <code>vertical</code> renders the title bottom to top
 * 
 *  @default flippedVertical
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="verticalAxisTitleAlignment", type="String", enumeration="flippedVertical,vertical", inherit="no")]

//[ResourceBundle("charts")]

/**
 *  You use the AxisRenderer class to describe
 *  the horizontal and vertical axes of a chart. 
 *  An axis is responsible for rendering
 *  the labels, tick marks, and title along its length. 
 *   
 *  <p>AxisRenderer objects inherit some of their visual properties
 *  from the enclosing chart object. 
 *  The text format of the labels and title defaults
 *  to the CSS text properties of the renderer.
 *  You can control the formatting of the axis title separately
 *  by specifying a <code>axisTitleStyleName</code>,
 *  either on the AxisRenderer or on the enclosing chart.</p> 
 *  
 *  <p>When positioning and sizing labels, the AxisRenderer
 *  takes a minimum amount of the chart's available space.
 *  If labels take too much space, then the AxisRenderer scales them.
 *  However, the AxisRenderer does not scale the labels
 *  to too small of a point size.
 *  To increase readability, the AxisRenderer chooses one
 *  of the following layout methods based on the one
 *  that requires the least scaling:</p>
 *
 *  <ul>
 *    <li>Render the labels horizontally end to end.</li> 
 *    <li>Stagger the labels horizontally in two rows.</li> 
 *    <li>Rotate the labels to fit them in the space provided.
 *    The AxisRenderer rotates the labels to the minimum angle
 *    needed to prevent them from overlapping.
 *    The maximum angle is 90 degrees.</li>
 *  </ul>
 *  
 *  <p>The AxisRenderer adjusts the boundaries of the chart's data area
 *  to ensure that it can draw the labels without pushing outside
 *  of the boundaries.</p>
 *  
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:AxisRenderer&gt;</code> tag inherits all the properties
 *  of its parent classes, and adds the following properties:</p>
 *  
 *  <pre>
 *  &lt;mx:AxisRenderer
 *    <strong>Properties</strong>
 *    axis="<i>IAxis</i>"
 *    chart="<i>ChartBase</i>"
 *    gutters="<i>Rectangle</i>"
 *    heightLimit="<i>Number</i>"
 *    labelRenderer="<i>IFactory</i>"
 *    labelFunction="<i>Function</i>"
 *    length="<i>Number</i>"
 *    otherAxes="<i>Array</i>"
 *    placement="right|left|bottom|top"
 *    ticks="<i>Array</i>"
 *    titleRenderer="<i>IFactory</i>"
 *     
 *    <strong>Styles</strong>
 *    axisStroke="<i>No default</i>"
 *    axisTitleStyleName="<i>No default</i>"
 *    canDropLabels="true|false"
 *    canStagger="true|false"
 *    labelAlign="center|left|right" (horizontal axes) or "center|top|bottom" (vertical axes)
 *    labelGap="3"
 *    labelRotation="<i>No default</i>"
 *    minorTickLength="<i>Default depends on axis</i>"
 *    minorTickPlacement="none|inside|outside|cross"
 *    minorTickStroke="<i>No default</i>"
 *    showLabels="true|false"
 *    showLine="true|false"
 *    tickLength="<i>Default depends on axis</i>"
 *    tickPlacement="inside|outside|cross|none"
 *    tickStroke="<i>No default</i>"
 *    verticalAxisTitleAlignment="flippedVertical|vertical"
 *  /&gt;
 *  </pre>
 *    
 *  @includeExample examples/HLOCChartExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class AxisRenderer extends DualStyleObject implements IAxisRenderer
{
//    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class initialization
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private static var textFieldFactory:/*Contextual*/ClassFactory;
    
    /**
     *  @private
     */
    private static var resourceManager:IResourceManager =
                                ResourceManager.getInstance();
	
	/**
	 *  @private
	 */
//	private static var _moduleFactoryInitialized:Dictionary = new Dictionary(true);
    
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
    public function AxisRenderer()
    {
        super();        
        var labelClass:Class = getLabelClass();
        textFieldFactory =  new /*Contextual*/ClassFactory(labelClass/*, moduleFactory*/);
        
        _labelCache = new InstanceCache(labelClass, this);
        
       	_labelCache.discard = true;
        _labelCache.remove = true;
        
        updateRotation();
        
        //super.showInAutomationHierarchy = false;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private var _cacheDirty:Boolean = true;
    
    /**
     *  @private
     */
    private var _labelFormatCache:TextFormat;
    
    /**
     *  @private
     */
    private var _otherAxes:Array /* of AxisRenderer */; 
    
    /**
     *  @private
     */
    private var _ticks:Array /* of Number */ = [];
    
    /**
     *  @private
     */
    private var _minorTicks:Array /* of Number */ = [];
    
    /**
     *  @private
     */
    private var _heightLimit:Number;
    
    /**
     *  @private
     */
    private var _maxLabelHeight:Number;

    /**
     *  @private
     */
    private var _maxLabelWidth:Number;

    /**
     *  @private
     */
    private var _maxRotatedLabelHeight:Number;
    
    /**
     *  @private
     */
    private var _axisLabelSet:AxisLabelSet;
    
    /**
     *  @private
     */
    private var _labels:Array /* of ARLabelData */ = [];
    
    /**
     *  @private
     */
    private var _labelPlacement:Object;

    /**
     *  @private
     */
    private var _forceLabelUpdate:Boolean = false;  
    
    /**
     *  @private
     */
    private var _labelCache:InstanceCache;  
    
    /**
     *  @private
     */
    private var _horizontal:Boolean;
    
    /**
     *  @private
     */
    private var _titleField:UIComponent;
    
    /**
     *  @private
     */
    private var _titleFieldChanged:Boolean;

    /**
     *  @private
     */
    private var _canRotate:Boolean; 
    
    /**
     *  @private
     */
    private var _inverted:Boolean = false;
    
    /**
     *  @private
     */
    private var _bGuttersAdjusted:Boolean = false;

    /**
     *  @private
     */
    private var _supressInvalidations:int = 0;
    
    /**
     *  @private
     */
    private var _measuringField:UIComponent;
    
    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

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
    //  axis
    //----------------------------------

    /**
     *  @private
     *  Storage for the axis property.
     */
    private var _axis:IAxis = null;
    
    [Inspectable(category="General")]

    /**
     *  The axis object associated with this renderer.
     *  This property is managed by the enclosing chart,
     *  and could be explicitly set if multiple axes renderers are used.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */ 
    public function get axis():IAxis
    {
        return _axis;       
    }

    /**
     *  @private
     */ 
    public function set axis(value:IAxis):void
    {
        if (_axis)
        {
            _axis.removeEventListener("axisChange", axisChangeHandler, false);
            _axis.removeEventListener("titleChange", titleChangeHandler, false);
        }

        _axis = value;

		if (_axis) {
        	value.addEventListener("axisChange", axisChangeHandler/*, false, 0, true*/);
        	value.addEventListener("titleChange", titleChangeHandler/*, false, 0, true*/);
		}
    }
    
    //----------------------------------
    //  chart
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The base chart for this AxisRenderer.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function get chart():ChartBase
    {
        var p:UIComponent = parent as UIComponent;
        while (!(p is ChartBase) && p)
        {
            p = p.parent as UIComponent;
        }           
        return p as ChartBase;
    }

    //----------------------------------
    //  gutters
    //----------------------------------

    /**
     *  @private
     *  Storage for the gutters property.
     */
    private var _gutters:Rectangle = new Rectangle();
    
    [Inspectable(category="General")]
    

    /** 
    * @inheritDoc
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public function get gutters():Rectangle
    {
        if (_horizontal == false)
        {
            return new Rectangle(_gutters.bottom, _gutters.left,
                                 -_gutters.height, _gutters.width);
        }
        else
        {
            return _gutters;
        }
    }
    
    /**
     *  @private
     */ 
    public function set gutters(value:Rectangle):void
    {
        var correctedGutters:Rectangle = value;
        
        // This check will rarely succeed, because _gutters
        // have been tweaked to represent placement.
        if (_gutters && 
            _gutters.left == correctedGutters.left && 
            _gutters.right == correctedGutters.right && 
            _gutters.top == correctedGutters.top && 
            _gutters.bottom == correctedGutters.bottom)
        {
            _gutters = correctedGutters;
            return;
        }
        else
        {
            adjustGutters(value,
                { left: false, top: false, right: false, bottom: false });
        }       
    }

    //----------------------------------
    //  heightLimit
    //----------------------------------

    [Inspectable(category="Size")]
    
    /** 
    * @inheritDoc
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public function get heightLimit():Number
    {
        return _heightLimit;
    }

    /**
     *  @private
     */ 
    public function set heightLimit(value:Number):void
    {
        _heightLimit = value;
    }

    //----------------------------------
    //  highlightElements
    //----------------------------------

    /**
     *  @private
     *  Storage for the highlightElements.
     */
    private var _highlightElements:Boolean = false;

    [Inspectable(category="General", defaltValue = "false")]
    
    /**
     *  Specifies wheter to highlight chart elements like Series on mouse rollover.
     *  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get highlightElements():Boolean
    {
        return _highlightElements;
    }
    
    /**
     *  @private
     */
    public function set highlightElements(value:Boolean):void
    {
        if (value == _highlightElements)
            return;
            
        _highlightElements = value;
        invalidateProperties();
    }
    
    //----------------------------------
    //  horizontal
    //----------------------------------

    [Inspectable(category="General")]
    
    /**
    *   @inheritDoc
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public function get horizontal():Boolean
    {
        return _horizontal;
    }
    
    /**
     *  @private
     */ 
    public function set horizontal(value:Boolean):void
    {
        _horizontal = value;

        updateRotation();
    }

    //----------------------------------
    //  labelFunction
    //----------------------------------

    /**
     *  @private
     *  Storage for the labelFunction property.
     */
    private var _labelFunction:Function = null;

    [Inspectable(category="General")]
    
    /**
     *  Called to format axis renderer values for display as labels.
     *  A <code>labelFunction</code> has the following signature:
     *  <pre>
     *  function labelFunction(<i>axisRenderer</i>:IAxisRenderer, <i>label</i>:String):String { ... }
     *  </pre>
     *  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get labelFunction():Function
    {
        return _labelFunction;
    }
    
    /**
     *  @private
     */
    public function set labelFunction(value:Function):void
    {
        _labelFunction = value;
        
        if (chart)
            chart.invalidateDisplayList();

        _forceLabelUpdate  = true;
        _cacheDirty = true;
        _axisLabelSet = null;

        invalidateDisplayList();
    }

    //----------------------------------
    //  labelRenderer
    //----------------------------------

    /**
     *  @private
     *  Storage for the labelRenderer property.
     */
    private var _labelRenderer:IFactory = null;
    
    [Inspectable(category="General")]
    
    /** 
     *  A reference to the factory used to render the axis labels. 
     *  This type must implement the IDataRenderer
     *  and IFlexDisplayObject interfaces.
     *  <p>The AxisRenderer will create one instance of this class
     *  for each label on the axis.
     *  The labelRenderer's data property is assigned an AxisLabel 
     *  object containing the value and label to be rendered.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get labelRenderer():IFactory
    {
        return _labelRenderer;
    }

    /**
     *  @private
     */ 
    public function set labelRenderer(value:IFactory):void
    {
        var oldLR:IFactory = _labelRenderer;
        _labelRenderer = value;
        if (oldLR == value)
            return;

        if (_measuringField)
        {
            removeChild(_measuringField);           
            _measuringField = null;
        }
		_labelCache.discard = true;
        _labelCache.count = 0;
		_labelCache.discard = false;
        if (!value) 
            _labelCache.factory = textFieldFactory;
        else 
            _labelCache.factory = _labelRenderer;

        if (chart)
            chart.invalidateDisplayList();

        _forceLabelUpdate  = true;
        _cacheDirty = true;

        invalidateDisplayList();
    }

    //----------------------------------
    //  length
    //----------------------------------

    [Inspectable(environment="none")]

    /** 
     *  Specifies the length of the axis, in screen coordinates.
     *  The default length depends on a number of factors, 
     *  including the size of the chart, the size of the labels,
     *  how the AxisRenderer chooses to lay out labels, 
     *  and any requirements imposed by other portions of the chart.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get length():Number
    {
        return unscaledWidth - _gutters.left - _gutters.right;
    }

    //----------------------------------
    //  minorTicks
    //----------------------------------

    /**
    *   @inheritDoc
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public function get minorTicks():Array /* of Number */
    {
        return _minorTicks;
    }

    //----------------------------------
    //  otherAxes
    //----------------------------------

    /**
    *   @inheritDoc
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public function set otherAxes(value:Array /* of AxisRenderer */):void
    {
        _otherAxes = value;
    }

    //----------------------------------
    //  placement
    //----------------------------------
    
    private var _placement:String = "";

    [Inspectable(category="General", enumeration="left,top,right,bottom")]

    /**
    *   @inheritDoc
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public function get placement():String
    {
        return _placement;
    }
    
    /**
     *  @private
     */ 
    public function set placement(value:String):void
    {
        _placement = value;
        _inverted = value == "right" || value == "top";
        
        if (chart)
        {
        	dispatchEvent(new Event("axisPlacementChange",true));
        }

        _forceLabelUpdate  = true;
        _cacheDirty = true;
        
        invalidateDisplayList();
    }
    
    //----------------------------------
    //  ticks
    //----------------------------------

    [Inspectable(environment="none")]

    /**
    *   @inheritDoc
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public function get ticks():Array /* of Number */
    {
        return _ticks;
    }

	//----------------------------------
    //  titleRenderer
    //----------------------------------

    /**
     *  @private
     *  Storage for the titleRenderer property.
     */
    private var _titleRenderer:IFactory = null;
    
    [Inspectable(category="General")]
    
    /** 
     *  A reference to the factory used to render the axis title. 
     *  This type must extend UIComponent and 
     *  implement the IDataRenderer and IFlexDisplayObject interfaces.
     *  <p>The AxisRenderer will create an instance of this class
     *  for title of the axis.
     *  The titleRenderer's data property is assigned the title
     *  to be rendered.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get titleRenderer():IFactory
    {
        return _titleRenderer;
    }

    /**
     *  @private
     */ 
    public function set titleRenderer(value:IFactory):void
    {
        var oldTR:IFactory = _titleRenderer;
        _titleRenderer = value;
        if (oldTR == value)
            return;
        if (chart)
            chart.invalidateDisplayList();
        invalidateDisplayList();
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
		var axisRenderer:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, "mx.charts.AxisRenderer");
		if (axisRenderer)
		{
			axisRenderer.setStyle("axisStroke", new SolidColorStroke(0, 0, 1));
			axisRenderer.setStyle("tickStroke", new SolidColorStroke(0, 0, 1));
			axisRenderer.setStyle("minorTickStroke", new SolidColorStroke(0, 0, 1));
		}
		
		var blockCategoryAxis:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, ".blockCategoryAxis");
		if (blockCategoryAxis)
		{
			blockCategoryAxis.setStyle("axisStroke", new SolidColorStroke(0xBBCCDD, 8, 1, false, "normal", "none"));
			blockCategoryAxis.setStyle("tickStroke", new SolidColorStroke(0xFFFFFF, 2, 1, false, "normal", "none"));
		}
		
		var blockNumericAxis:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, ".blockNumericAxis");
		if (blockNumericAxis)
		{
			blockNumericAxis.setStyle("axisStroke", new SolidColorStroke(0xBBCCDD, 8, 1, false, "normal", "none"));
			blockNumericAxis.setStyle("tickStroke", new SolidColorStroke(0xBBCCDD, 1, 1,false, "normal", "none"));
			blockNumericAxis.setStyle("minorTickStroke", new SolidColorStroke(0xFFFFFF, 1, 1, false, "normal", "none"));
		}
		
		var lineNumericAxis:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, ".linedNumericAxis");
		if (lineNumericAxis)
		{
			lineNumericAxis.setStyle("axisStroke", new SolidColorStroke(0xBBCCDD, 1, 1, false, "normal", "none"));
			lineNumericAxis.setStyle("tickStroke", new SolidColorStroke(0xBBCCDD, 1, 1,false, "normal", "none"));
			lineNumericAxis.setStyle("minorTickStroke", new SolidColorStroke(0xBBCCDD, 1, 1, false, "normal", "none"));
		}
		
		var dashedNumericAxis:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, ".dashedNumericAxis");
		if (dashedNumericAxis)
		{
			dashedNumericAxis.setStyle("tickStroke", new SolidColorStroke(0xBBCCDD, 1, 1,false, "normal", "none"));
			dashedNumericAxis.setStyle("minorTickStroke", new SolidColorStroke(0xBBCCDD, 1, 1, false, "normal", "none"));
		}
		
		var dashedCategoryAxis:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, ".dashedCategoryAxis");
		if (dashedCategoryAxis)
		{
			dashedCategoryAxis.setStyle("axisStroke", new SolidColorStroke(0xBBCCDD, 1, 1,false, "normal", "none"));
			dashedCategoryAxis.setStyle("tickStroke", new SolidColorStroke(0xFFFFFF, 2, 1, false, "normal", "none"));
		}
		
		var hangingCategoryAxis:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, ".hangingCategoryAxis");
		if (hangingCategoryAxis)
		{
			hangingCategoryAxis.setStyle("axisStroke", new SolidColorStroke(0xBBCCDD, 1, 1,false, "normal", "none"));
			hangingCategoryAxis.setStyle("tickStroke", new SolidColorStroke(0xBBCCDD, 1, 1, false, "normal", "none"));
			hangingCategoryAxis.setStyle("minorTickStroke", new SolidColorStroke(0,0,0));
		}
		return true;
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
        
		// our style settings
		initStyles();
	}
	
    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();
        
		if (!labelRenderer)
		{
			var labelClass:Class = getLabelClass();
			
			textFieldFactory = new /*Contextual*/ClassFactory(labelClass/*, moduleFactory*/);
			
			_labelCache.factory = textFieldFactory;
		}
        
        setupMouseDispatching();
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function invalidateSize():void
    {
        if (_supressInvalidations == 0)
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
    override public function invalidateDisplayList():void
    {
        if (_supressInvalidations == 0)
            super.invalidateDisplayList();
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function measure():void
    {
        var calcSize:Number = 0;
        
        // showlabels comes through CSS as a string
        var showLabelsStyle:Object = getStyle("showLabels");
        var showLabels:Boolean = showLabelsStyle != false &&
                                 showLabelsStyle != "false";
        
        var showLineStyle:Object = getStyle("showLine");        
        var showLine:Boolean = showLineStyle != false &&
                               showLineStyle != "false";
        
        var axisStroke:IStroke = getStyle("axisStroke");

        calcSize += tickSize(showLine);
        
        calcSize += getStyle("labelGap");
        
        calcSize += Number(showLine == true && axisStroke ?
                           axisStroke.weight :
                           0);

        // If we have a title, we subtract off space for it.
        var titleHeight:Number = 0;
        var titleScale:Number = 1;
        var titleSize:Point = measureTitle();

        titleHeight = titleSize.y;
        calcSize += titleHeight;

        if (_horizontal)
            measuredMinHeight = calcSize;
        else
            measuredMinWidth = calcSize;
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

        _supressInvalidations++;

        var chart:ChartBase = this.chart;

        if (_bGuttersAdjusted == true &&
            chart.chartState != ChartState.PREPARING_TO_HIDE_DATA &&
            chart.chartState != ChartState.HIDING_DATA)
        {
            updateCaches();
                
            graphics.clear();
    
            var lineVisible:Boolean = getStyle("showLine");
            
            var labelBottom:Number = drawLabels(lineVisible);
            
            drawTitle(labelBottom);     
            
            drawAxis(lineVisible);  
            
            drawTicks(lineVisible);
        }
        _supressInvalidations--;
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function move(x:Number, y:Number):void
    {
        if (_horizontal)
            super.move(x, y);
        else
            super.move(x + unscaledHeight, y);
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
        if (_horizontal)
        {
            super.setActualSize(w, h);
        }
        else
        {
            var oldX:Number = x - unscaledHeight;
            super.setActualSize(h, w);
            move(oldX + w, y);
        }
        updateDisplayList(w, h);
    }

    /**
     *  @private
     */
    override public function styleChanged(styleProp:String):void
    {

        if (styleProp == null || styleProp == "axisTitleStyleName")
        {
            _titleFieldChanged= true;
        }
        
        // This is unfortunately necessary.
        // Many style properties don't change the measured size of the axis,
        // but rather changes how the chart will affect its layout.
        // So we can't just invalidate our size...
        // that only triggers a measure().
        // Instead, we must invalidate the chart's displayList().
        if (chart)
            chart.invalidateDisplayList();
        
        _axisLabelSet = null;
        _forceLabelUpdate = true;
        _cacheDirty = true;
        
        invalidateDisplayList();
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Called by the chart to indicate
     *  when its current transition state has changed.
     *
     *  @param oldState A number representing the old state.
     *
     *  @param newState A number representing the new state.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function chartStateChanged(oldState:uint, newState:uint):void
    {
        invalidateDisplayList();
    }

    /**
    *   @inheritDoc
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public function adjustGutters(workingGutters:Rectangle,
                                  adjustable:Object):Rectangle
    {   
        _bGuttersAdjusted = true;

        var axisStroke:IStroke = getStyle("axisStroke");

        updateCaches();

        var width:Number = unscaledWidth;
        var height:Number = unscaledHeight;
        var scale:Number = 1;
        var tmpGutter:Number;
        
        if (_horizontal == false)
        {
            var rotatedGutters:Rectangle =
                new Rectangle(workingGutters.top, workingGutters.right, 0, 0);
            
            rotatedGutters.right = workingGutters.bottom;
            rotatedGutters.bottom = workingGutters.left; 
            
            _gutters = workingGutters = rotatedGutters; 
            
            adjustable = { left: adjustable.top,
                           top: adjustable.right,
                           right:adjustable.bottom,
                           bottom:adjustable.left };
        }
        else
        {
            _gutters = workingGutters = workingGutters.clone();
        }

        if (_inverted)
        {
            tmpGutter = workingGutters.top;
            workingGutters.top = workingGutters.bottom;
            workingGutters.bottom = tmpGutter;
        }

        var calcSize:Number = 0;
        
        // showLabels comes through CSS as a string
        var showLabelsStyle:Object = getStyle("showLabels");
        var showLabels:Boolean = showLabelsStyle != false &&
                                 showLabelsStyle != "false";
        
        var showLineStyle:Object = getStyle("showLine");        
        var showLine:Boolean = showLineStyle != false &&
                               showLineStyle != "false";

        calcSize += tickSize(showLine);

        calcSize += getStyle("labelGap");

        calcSize += Number(showLine == true && axisStroke ?
                           axisStroke.weight :
                           0);
        
        // If we have a title, we subtract off space for it.
        var titleHeight:Number = 0;
        var titleScale:Number = 1;

        var titleSize:Point = measureTitle();

        titleHeight = titleSize.y;
        
        // First, calculate the angle for the labels.               
        var targetHeight:Number;

        // Add in the size required by the title.
        calcSize += titleHeight * titleScale;

        if (adjustable.bottom == false)
            targetHeight = Math.max(0,workingGutters.bottom - calcSize);
        else if (!isNaN(heightLimit))
            targetHeight = Math.max(0,heightLimit - calcSize);

        // Adjust for any ticks that might be hanging over the edge.        
        var tickStroke:IStroke = getStyle("tickStroke");
        if (tickStroke)
        {
            workingGutters.left = Math.max(workingGutters.left,
                                           tickStroke.weight / 2);
            workingGutters.right = Math.max(workingGutters.right,
                                            tickStroke.weight / 2);
        }

        tickStroke = getStyle("minorTickStroke");
        if (tickStroke)
        {
            workingGutters.left = Math.max(workingGutters.left,
                                           tickStroke.weight / 2);
            workingGutters.right = Math.max(workingGutters.right,
                                            tickStroke.weight / 2);
        }

        if (showLabels)
        {
            _labelPlacement = calcRotationAndSpacing(
                width, height, targetHeight, workingGutters, adjustable);
                
            var label:ARLabelData = _labels[0];
            var n:int = _labels.length;    
                
            // Calculate the height required by those labels.           
            if (_labelPlacement.rotation == 0)
            {
                if (_labelPlacement.staggered)
                    calcSize += 2 * label.height * _labelPlacement.scale;
                else
                    calcSize += _maxLabelHeight * _labelPlacement.scale;
            }
            else
            {
                var c:Number = Math.cos(Math.abs(_labelPlacement.rotation));
                var s:Number = Math.sin(Math.abs(_labelPlacement.rotation));

                var heightContribution:Number = 1 - this.labelAlignOffset;
                var labelHeight:Number = 0;
                scale = _labelPlacement.scale;

                for (var i:int = 0; i < n; i++)
                {
                    var ldi:ARLabelData = _labels[i];
                    var rotatedHeight:Number =
                        c * ldi.height * heightContribution * scale +
                        s * ldi.width * scale;
                    labelHeight = Math.max(rotatedHeight, labelHeight);
                }

                _maxRotatedLabelHeight = labelHeight;
                calcSize += labelHeight;
            }
        }
        else
        {
            // For gridlines, we still need to measure out our labels.
            measureLabels(false, width);

            _labelPlacement = { rotation: 0, left: 0, right: 0,
                                scale: 1, staggered: false };           
        }
        
        var wmLeft:Number = Math.max(workingGutters.left,_labelPlacement.left);

        workingGutters = new Rectangle(
            wmLeft, workingGutters.top,
            Math.max(workingGutters.right, _labelPlacement.right) - wmLeft,
            Math.max(workingGutters.bottom, calcSize) - workingGutters.top);

        if (_inverted)
        {
            tmpGutter = workingGutters.top;
            workingGutters.top = workingGutters.bottom;
            workingGutters.bottom = tmpGutter;
        }

        _gutters = workingGutters;
        
        invalidateDisplayList();

        return gutters;
    }

    /**
     *  @private
     */
    private function measureTitle():Point
    {
        if (!_axis || !(_axis.title) || _axis.title.length == 0)
            return new Point(0, 0);

        renderTitle();
        
        _supressInvalidations++;

        (_titleField as IDataRenderer).data = _axis ? _axis.title : "";
                
        _titleField.validateProperties();
        _titleField.validateSize(true);
        
        _supressInvalidations--;
        
        return new Point(_titleField.measuredWidth,
                         _titleField.measuredHeight);       
        
    }

    /**
     *  @private
     */
    private function renderTitle():void
    {
        if (!_titleField || (getQualifiedClassName(_titleField) == "mx.charts.chartClasses::ChartLabel" && _titleRenderer) 
          || (!(getQualifiedClassName(_titleField) == "mx.charts.chartClasses::ChartLabel") && !_titleRenderer)){
          	if (_titleField)
           		removeChild(_titleField);
        	if (_titleRenderer)
            	_titleField = _titleRenderer.newInstance();
        	else
            	_titleField = new ChartLabel();
        
       		_titleField.visible= false;        
       		addChild(_titleField);
          }    
        _titleFieldChanged = true;
        
        if (_titleFieldChanged)
        {
            _titleFieldChanged = false;
            var styleName:Object = getStyle("axisTitleStyleName");

            if (styleName != null)
                _titleField.styleName = styleName;
            else
                _titleField.styleName = this;
        }
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
    private function calcRotationAndSpacing(width:Number, height:Number,
                                            targetHeight:Number,
                                            workingGutters:Rectangle,
                                            adjustable:Object):Object
    {
        updateCaches();

        var leftGutter:Number = workingGutters.left;
        var rightGutter:Number = workingGutters.right;
        
        
        // First, ask our range to estimate what our labels will be,
        // and do a measurement pass on them.
        var bEstimateIsAccurate:Boolean = measureLabels(true, 0);
		var n:int  = _labels.length;
        // If we have no labels, we're done.
        if (n == 0)
        {
            return { rotation: 0, left: leftGutter, right: rightGutter,
                     scale: 1, staggered: false };          
        }       
        
        // First check and see if a rotation has been specified.
        // If it has, go with what the author requested.    
        var labelRotation:Number = getStyle("labelRotation");       
        if (labelRotation > 90)
            labelRotation = 0 / 0;

        if (_horizontal == false)
        {
            if (isNaN(labelRotation))
                labelRotation = 0;
            if (labelRotation >= 0)
                labelRotation = 90 - labelRotation;
            else
                labelRotation =- (90 + labelRotation);
        }
                
        // Decide if it's OK to drop labels.
        // We look for a style, and if we can't find it,
        // we check the Axis to see what the default should be.     
        var canDropLabelsStyle:Object = getStyle("canDropLabels");
        var canDropLabels:Boolean;
        
        if (canDropLabelsStyle == null)
        {
            // Since style cache fails with unset styles, we store
            // this off so we won't hit the style code over and over.
            canDropLabels = Boolean(_axis.preferDropLabels());
        }
        else
        {
            canDropLabels = canDropLabelsStyle != false &&
                            canDropLabelsStyle != "false";
            
        }
        
        var firstLabel:ARLabelData = _labels[0];
        //Decide the last label based on the canDropLabels
        var lastLabel:ARLabelData;
        
        if (canDropLabels)
        {
        	
         	var prevLabel:ARLabelData = firstLabel;
        	var thisLabel:ARLabelData;
        	var spaceBetween:Number;
        	var requiredSpace:Number;
        	var axisLength:Number = width - leftGutter - rightGutter;
        	var scalingRequired:Boolean = true;
            var base:int;
            var dir:int;
            var maxSkipCount:int = 0;
            var bLabelsReduced:Boolean;
            var bSkipRequired:Boolean = true;
			var skipCount:int = 0;
            n = _labels.length;    
            if (_horizontal)
            {
                if (n > 0)
                    prevLabel = _labels[0];
                base = 0;
                dir = 1;                    
            }
            else
            {
                if (n > 0)
                    prevLabel = _labels[n - 1];
                base = n - 1;
                dir = -1;
            }
                            
            for (var i:int = 1; i < n; i++)
            {
                thisLabel = _labels[base + dir * i];
                spaceBetween =
                    Math.abs(thisLabel.position - prevLabel.position) *
                    axisLength;
                requiredSpace = (thisLabel.width + prevLabel.width) / 2;
                if (requiredSpace > spaceBetween)
	            {
                    skipCount++;
                }
                else
                {
                    if (skipCount > maxSkipCount)
                    {
                        maxSkipCount = skipCount;
                    }                       
                    skipCount = 0;
                    prevLabel = thisLabel;
                }
            }
    
            if (skipCount > maxSkipCount)
            {
                maxSkipCount = skipCount;
            }
			if(maxSkipCount == 0)
				lastLabel = _labels[_labels.length - 1];
			else
				lastLabel = _labels[maxSkipCount + 1] ? _labels[maxSkipCount + 1] : _labels[_labels.length - 1];
			//lastLabel = prevLabel;
        }
        	
        else
            lastLabel = _labels[_labels.length - 1];        
         
        
        
        // Layout vertical if:
        // 1. horizontal, and label is 90 and canRotate is true
        // 2. (vertical, and rotation is null, 90), or (canRotate is false)
        
        var mustLayoutVertical:Boolean =
            (_horizontal && _canRotate && labelRotation == 90) ||
            (_horizontal == false &&
             ((isNaN(labelRotation) ||
               labelRotation == 90) ||
               _canRotate == false));
    
        var canLayoutHorizontal:Boolean =
            mustLayoutVertical == false &&
            ((isNaN(labelRotation) && _horizontal == true) ||
            (labelRotation == 0) || (_canRotate == false));
        
        var horizontalScale:Number = 0;
        
        var canStaggerStyle:Object = getStyle("canStagger");
        var canStagger:Boolean =
            canStaggerStyle == null ||
            (canStaggerStyle != false &&
             canStaggerStyle != "false");

        var canLayoutStaggered:Boolean =
            mustLayoutVertical == false &&
            ((canDropLabels == false) &&
            canLayoutHorizontal &&
            (false != canStaggerStyle));
        
        var staggeredScale:Number = 0;
        
        var canLayoutAngled:Boolean =
            (mustLayoutVertical == false && 
            ((_canRotate == true) && 
             labelRotation != 0 && 
             ((canDropLabels == false) || 
              !isNaN(labelRotation))));

        var angledScale:Number = 0;
        var minimumAxisLength:Number = width - leftGutter - rightGutter;
        
        var verticalData:Object;
        var horizontalGutterData:Object;
        var angledGutterData:Object;
        var angledSpacingData:Object;
        var horizontalSpacingData:Object;
        var staggeredSpacingData:Object;
        
        if (bEstimateIsAccurate)
        {
            // First, determine the gutter adjustments for vertical labels.
            if (mustLayoutVertical)
            {
                verticalData = calcVerticalGutters(
                    width, leftGutter, rightGutter,
                    firstLabel, lastLabel, adjustable);

                return calcVerticalSpacing(
                    width, verticalData, targetHeight,
                    firstLabel, lastLabel, canDropLabels);
            }

            // Now, determine the gutter and/or dropLabel adjustments
            // for horizontal labels.
            if (canLayoutHorizontal || canLayoutStaggered)
            {
                horizontalGutterData = measureHorizontalGutters(
                    width, leftGutter, rightGutter,
                    firstLabel, lastLabel, adjustable);

                horizontalSpacingData = calcHorizontalSpacing(
                    width, horizontalGutterData, targetHeight,
                    firstLabel, lastLabel, canDropLabels,
                    adjustable, minimumAxisLength);
                
                horizontalScale = horizontalSpacingData.scale;
                
                if (horizontalScale != 1 && canLayoutStaggered)
                {
                    staggeredSpacingData = calcStaggeredSpacing(
                        width, horizontalGutterData, targetHeight,
                        firstLabel, lastLabel, canDropLabels, adjustable);

                    staggeredScale = staggeredSpacingData.scale;
                }
            }

            // Now we're going to determine the optimal angle,
            // and gutter adjustments, for angled labels.
            if (horizontalScale != 1 && staggeredScale != 1 && canLayoutAngled)
            {
                angledGutterData = measureAngledGutters(
                    width, labelRotation, targetHeight,
                    firstLabel, leftGutter, rightGutter, adjustable);

                angledSpacingData = calcAngledSpacing(angledGutterData);

                angledScale = angledSpacingData.scale;
            }

            if (horizontalScale >= staggeredScale &&
                horizontalScale >= angledScale)
            {
                if (horizontalSpacingData != null)
                    return horizontalSpacingData;
                return angledSpacingData;
            }
            else if (staggeredScale >= angledScale)
            {
                if (staggeredSpacingData != null)
                    return staggeredSpacingData;
                return angledSpacingData;
            }
            else
            {
                return angledSpacingData;
            }
        }
        else
        {
            // First, determine the gutter adjustments for vertical labels.
            if (mustLayoutVertical)
            {
                verticalData = calcVerticalGutters(
                    width, leftGutter, rightGutter,
                    firstLabel, lastLabel, adjustable);

                minimumAxisLength = Math.min(minimumAxisLength,
                                             verticalData.minimumAxisLength);
            }

            // Now, determine the gutter and/or dropLabel adjustments
            // for horizontal labels.
            if (canLayoutHorizontal || canLayoutStaggered)
            {
                horizontalGutterData = measureHorizontalGutters(
                    width, leftGutter, rightGutter,
                    firstLabel, lastLabel, adjustable);

                minimumAxisLength = Math.min(
                    minimumAxisLength, horizontalGutterData.minimumAxisLength);         
            }

            // Now we're going to determine the optimal angle,
            // and gutter adjustments, for angled labels
            if (canLayoutAngled)
            {
                angledGutterData = measureAngledGutters(
                    width, labelRotation, targetHeight,
                    firstLabel, leftGutter, rightGutter, adjustable);

                minimumAxisLength = Math.min(
                    minimumAxisLength, angledGutterData.minimumAxisLength);         
            }

            // We've effectively measured our maximum gutter reduction.
            // Now our range can adjust based on any gutters
            // in the range required by specific renderers.
            measureLabels(false, minimumAxisLength);

            // Now that we have an accurate set of labels, it's entirely possible we have no labels anymore.
            // if that's the case, bail out.
            if (_labels.length == 0)
            {
                return { rotation: 0, left: leftGutter, right: rightGutter,
                         scale: 1, staggered: false };          
            }
    
            // Now, determine either the scale factor or the drop factor
            // for vertical titles
            if (mustLayoutVertical)
            {
                return calcVerticalSpacing(
                    width, verticalData, targetHeight,
                    firstLabel, lastLabel, canDropLabels);
            }

            // Now determine the scale adjustments for horizontal labels.
            if (canLayoutHorizontal)
            {
                horizontalSpacingData = calcHorizontalSpacing(
                    width, horizontalGutterData, targetHeight,
                    firstLabel, lastLabel, canDropLabels,
                    adjustable, minimumAxisLength);

                horizontalScale = horizontalSpacingData.scale;
            }

            // And the scale adjustments for staggered labels.
            if (canLayoutStaggered)
            {
                staggeredSpacingData = calcStaggeredSpacing(
                    width, horizontalGutterData, targetHeight,
                    firstLabel, lastLabel, canDropLabels, adjustable);

                staggeredScale = staggeredSpacingData.scale;
            }

            if (canLayoutAngled)
            {
                angledSpacingData = calcAngledSpacing(angledGutterData);
                angledScale = angledSpacingData.scale;
            }

            if (horizontalScale  >= staggeredScale &&
                horizontalScale >= angledScale)
            {
                if (horizontalSpacingData != null)
                    return horizontalSpacingData;
                return angledSpacingData;
            }
            else if (staggeredScale >= angledScale)
            {
                if (staggeredSpacingData != null)
                    return staggeredSpacingData;
                return angledSpacingData;
            }
            else
            {
                return angledSpacingData;
            }
        }
    }
    
    /**
     *  @private
     */
    private function measureLabels(bEstimate:Boolean,
                                   minimumAxisLength:Number):Boolean
    {
        var newLabelData:AxisLabelSet;
        
        if (!_axis)
        	throw(new Error(resourceManager.getString("charts", "noAxisSet")));
        else if (bEstimate)
            newLabelData = _axis.getLabelEstimate();
        else
            newLabelData = _axis.getLabels(minimumAxisLength);
        
        if (newLabelData == _axisLabelSet && _forceLabelUpdate == false)
            return newLabelData.accurate;

        var bResult:Boolean = processAxisLabels(newLabelData);

        _axisLabelSet = newLabelData;

        return bResult;
    }

    /**
     *  @private
     */
    private function calcVerticalGutters(width:Number,
                                         leftGutter:Number,
                                         rightGutter:Number,
                                         firstLabel:ARLabelData,
                                         lastLabel:ARLabelData,
                                         adjustable:Object):Object
    {
        var labelAlignOffset:Number = this.labelAlignOffset;
        var axisLength:Number = width - leftGutter - rightGutter;
        
        var LS:Number = firstLabel.height * labelAlignOffset;
        var RS:Number = firstLabel.height * (1 - labelAlignOffset);
        var P1:Number = firstLabel.position;
        var P2:Number = 1 - lastLabel.position;

        var lhm:Number;
        var rhm:Number;

        var leftOverlaps:Boolean = adjustable.left != false &&
                                   LS > leftGutter + P1 * axisLength;

        var rightOverlaps:Boolean = adjustable.right != false &&
                                    RS > rightGutter + P2 * axisLength;

        if (leftOverlaps == false && rightOverlaps == false)
        {
            lhm = leftGutter;
            rhm = rightGutter;
        }
        else if (leftOverlaps == true && rightOverlaps == false)
        {
            axisLength = (width - rightGutter - LS) / (1 - P1);
            lhm = width - rightGutter - axisLength;
            rhm = rightGutter;
            rightOverlaps = RS > rhm + P2 * axisLength;             
        }
        else if (leftOverlaps == false && rightOverlaps == true)
        {
            axisLength = (width - leftGutter - RS) / (1 - P2);
            lhm = leftGutter;
            rhm = width - leftGutter - axisLength;
            leftOverlaps = LS > lhm + P1 * axisLength;
        }

        if (leftOverlaps && rightOverlaps)
        {
            axisLength = (width - LS - RS) / (1 - P1 - P2);

            lhm = LS - P1 * axisLength;
            rhm = RS - P2 * axisLength;
        }

        return { hlm:lhm, hrm:rhm, minimumAxisLength:width - lhm - rhm };
    }
    
    /**
     *  @private
     */
    private function calcVerticalSpacing(width:Number, verticalData:Object,
                                         targetHeight:Number,
                                         firstLabel:ARLabelData,
                                         lastLabel:ARLabelData,
                                         canDropLabels:Boolean):Object
    {
        // Check for max height violations.
        var scale:Number;
        var axisLength:Number = width - verticalData.hlm - verticalData.hrm;
        if (!isNaN(targetHeight))
            scale = Math.min(1, targetHeight / _maxLabelWidth);
        else
            scale = 1;
            
        var prevLabel:ARLabelData = firstLabel;
        var thisLabel:ARLabelData;
        var spaceBetween:Number;
        var requiredSpace:Number;
        var scalingRequired:Boolean = true;
        var n:int  = _labels.length;

        // If we can drop labels, do that.
        if (canDropLabels)
        {
            var base:int;
            var dir:int;
            var maxSkipCount:int = 0;
            var bLabelsReduced:Boolean;
            var bSkipRequired:Boolean = true;
            
            do
            {           
                maxSkipCount = 0;
                var skipCount:int = 0;
                
                if (_horizontal)
                {
                    if (_labels.length > 0)
                        prevLabel = _labels[0];
                    base = 0;
                    dir = 1;                    
                }
                else
                {
                    if (_labels.length > 0)
                        prevLabel = _labels[_labels.length - 1];
                    base = _labels.length - 1;
                    dir = -1;
                }

                var firstIntervalLabel:Object;
                var lastIntervalLabel:Object;
				n  = _labels.length;
                for (var i:int = 1; i < n; i++)
                {
                    thisLabel = _labels[base + dir * i];
                    spaceBetween =
                        Math.abs(thisLabel.position - prevLabel.position) *
                        axisLength;
                    requiredSpace = (thisLabel.height + prevLabel.height) / 2;
                    if (requiredSpace > spaceBetween)
                    {
                        skipCount++;
                    }
                    else
                    {
                        if (skipCount > maxSkipCount)
                        {
                            maxSkipCount = skipCount;
                            firstIntervalLabel = prevLabel;
                            lastIntervalLabel = _labels[base + dir * (i - 1)];
                        }                       
                        // If we're going vertical, we assume they are all
                        // the same height, and just count until we get
                        // an initial skip count.
                        break;
                        skipCount = 0;
                        prevLabel = thisLabel;
                    }
                }

                if (skipCount > maxSkipCount)
                {
                    maxSkipCount = skipCount;
                    firstIntervalLabel = prevLabel;
                    lastIntervalLabel = _labels[base + dir * (i  -1)];
                }                       
                
                if (maxSkipCount)
                {
                    // Here's where we increase the interval.
                    bLabelsReduced = reduceLabels(firstIntervalLabel.value,
                                                  lastIntervalLabel.value);
                }
                else
                {
                    bSkipRequired = false;
                    scalingRequired = false;
                }
            }
            while (bSkipRequired && bLabelsReduced);
        }

        if (scalingRequired)
        {
            prevLabel = _labels[0];
            // Scale down until they don't overlap.
            n  = _labels.length;
            for (i = 1; i < n; i++)
            {
                thisLabel = _labels[i];
                spaceBetween = (thisLabel.position - prevLabel.position) *
                               axisLength;
                requiredSpace = (thisLabel.height + prevLabel.height) / 2;
                scale = Math.min(scale, spaceBetween / requiredSpace);
                prevLabel = thisLabel;
            }
        }

        return { rotation: Math.PI/2, 
                 left: verticalData.hlm,
                 right: verticalData.hrm,
                 scale: Math.max(0, scale), 
                 staggered: false };            
    }

    /**
     *  @private
     */
    private function measureHorizontalGutters(width:Number,
                                              leftGutter:Number,
                                              rightGutter:Number,
                                              firstLabel:ARLabelData,
                                              lastLabel:ARLabelData,
                                              adjustable:Object):Object
    {
        // With staggered labels, it's possible to have a very long
        // 2nd or 2nd-to-last label that pushes past the borders
        // before the end labels do. We should be checking those too.

        var labelAlignOffset:Number=  this.labelAlignOffset;
        var axisLength:Number = width - leftGutter - rightGutter;

        var LS:Number = firstLabel.width * labelAlignOffset;
        var RS:Number = lastLabel.width * (1 - labelAlignOffset);
        var P1:Number = firstLabel.position;
        var P2:Number = 1 - lastLabel.position;

        var lhm:Number;
        var rhm:Number;

        // First, see if we need to push the gutters in.
        var leftOverlaps:Boolean = adjustable.left != false &&
                                   LS > leftGutter + P1 * axisLength;

        var rightOverlaps:Boolean = adjustable.right != false &&
                                    RS > rightGutter + P2 * axisLength;

        if (leftOverlaps == false && rightOverlaps == false)
        {
            lhm = leftGutter;
            rhm = rightGutter;
        }
        else if (leftOverlaps == true && rightOverlaps == false)
        {
            axisLength = (width - rightGutter - LS) / (1 - P1);
            lhm = width - rightGutter - axisLength;
            rhm = rightGutter;
            rightOverlaps = RS > rhm + P2 * axisLength;             
        }
        else if (leftOverlaps == false && rightOverlaps == true)
        {
            axisLength = (width - leftGutter - RS) / (1 - P2);
            lhm = leftGutter;
            rhm = width - leftGutter - axisLength;
            leftOverlaps = LS > lhm + P1 * axisLength;
        }
        
        if (leftOverlaps && rightOverlaps)
        {
            axisLength = (width - LS - RS) / (1 - P1 - P2);

            lhm = LS - P1 * axisLength;
            rhm = RS - P2 * axisLength;
        }

        return { horizontalleftGutter: lhm,
                 horizontalrightGutter: rhm,
                 minimumAxisLength: width - lhm - rhm };
    }
    
    /**
     *  @private
     */
    private function calcHorizontalSpacing(width:Number,
                                           horizontalGutterData:Object,
                                           targetHeight:Number,
                                           firstLabel:ARLabelData,
                                           lastLabel:ARLabelData,
                                           canDropLabels:Boolean,
                                           adjustable:Object,
                                           minimumAxisLength:Number):Object
    {
        var horizontalleftGutter:Number =
            horizontalGutterData.horizontalleftGutter;
        var horizontalrightGutter:Number =
            horizontalGutterData.horizontalrightGutter;

        var horizontalScale:Number = 1;

        // Now check to see if we need to scale
        // to make up for max height violations.
        if (!isNaN(targetHeight))
            horizontalScale = Math.min(1, targetHeight / _maxLabelHeight);          

        var thisLabel:ARLabelData;
        var prevLabel:ARLabelData = firstLabel;
        
        var n:int = _labels.length;
        
        var axisLength:Number = width - horizontalleftGutter -
                                horizontalrightGutter;

        var spaceBetween:Number;
        var requiredSpace:Number;
        var scalingRequired:Boolean = true;
        
        // If we can drop labels, do that.
        if (canDropLabels)
        {
            var base:int;
            var dir:int;
            var maxSkipCount:int = 0;
            var bLabelsReduced:Boolean;
            var bSkipRequired:Boolean = true;

            do
            {
                maxSkipCount = 0;
                var skipCount:int = 0;
                
                if (_horizontal)
                {
                    if (_labels.length > 0)
                        prevLabel = _labels[0];
                    base = 0;
                    dir = 1;                    
                }
                else
                {
                    if (_labels.length > 0)
                        prevLabel = _labels[_labels.length - 1];
                    base = _labels.length - 1;
                    dir = -1;
                }

                var firstIntervalLabel:Object;
                var lastIntervalLabel:Object;
                n  = _labels.length;            
                for (var i:int = 1; i < n; i++)
                {
                    thisLabel = _labels[base + dir * i];
                    spaceBetween =
                        Math.abs(thisLabel.position - prevLabel.position) *
                        axisLength;
                    requiredSpace = (thisLabel.width + prevLabel.width) / 2;
                    if (requiredSpace > spaceBetween)
                    {
                        skipCount++;
                    }
                    else
                    {
                        if (skipCount > maxSkipCount)
                        {
                            maxSkipCount = skipCount;
                            firstIntervalLabel = prevLabel;
                            lastIntervalLabel = _labels[base + dir * (i - 1)];
                        }                       
                        skipCount = 0;
                        prevLabel = thisLabel;
                    }
                }
    
                if (skipCount > maxSkipCount)
                {
                    maxSkipCount = skipCount;
                    firstIntervalLabel = prevLabel;
                    lastIntervalLabel = _labels[base + dir * (i - 1)];
                }                       
                
                if (maxSkipCount)
                {
                    // Here's where we increase the interval.
                    bLabelsReduced = reduceLabels(firstIntervalLabel.value,
                                                  lastIntervalLabel.value);
                }
                else
                {
                    bSkipRequired = false;
                    scalingRequired = false;                    
                }
            }
            while (bSkipRequired && bLabelsReduced);
        }
        
        if (scalingRequired)
        {
            if (adjustable.left == false)
            {
                horizontalScale = Math.min(horizontalScale,
                    (horizontalleftGutter +
                     firstLabel.position * axisLength) /
                    (firstLabel.width / 2));                
            }

            if (adjustable.right == false)
            {
                horizontalScale = Math.min(horizontalScale,
                    (horizontalrightGutter +
                     (1 - lastLabel.position) * axisLength) /
                    (lastLabel.width / 2));             
            }

            // Never mind, we'll have to scale it..
            prevLabel = _labels[0];
            n = _labels.length;
            for (i = 1; i < n; i++)
            {
                thisLabel = _labels[i];
                spaceBetween = (thisLabel.position - prevLabel.position) *
                               axisLength;
                requiredSpace = (thisLabel.width + prevLabel.width) / 2;
                horizontalScale = Math.min(horizontalScale,
                                           spaceBetween / requiredSpace);
                prevLabel = thisLabel;
            }
        }
        return { rotation: 0, 
                 left: horizontalleftGutter,
                 right: horizontalrightGutter,
                 scale: Math.max(0, horizontalScale), 
                 staggered: false };            
    }
    
    /**
     *  @private
     */
    private function calcStaggeredSpacing(width:Number,
                                          horizontalGutterData:Object,
                                          targetHeight:Number,
                                          firstLabel:ARLabelData,
                                          lastLabel:ARLabelData,
                                          canDropLabels:Boolean,
                                          adjustable:Object):Object
    {
        // We're assuming that we never can layout staggered
        // without being able to layout flat horizontal.
        var staggeredleftGutter:Number = horizontalGutterData.horizontalleftGutter;
        var staggeredrightGutter:Number = horizontalGutterData.horizontalrightGutter;
        var staggeredScale:Number;
        var axisLength:Number = width - staggeredleftGutter - staggeredrightGutter;
        
        // Check for scale to correct for max height violations.
        if (!isNaN(targetHeight))
            staggeredScale = Math.min(1, targetHeight / (2 * _maxLabelHeight));
        else
            staggeredScale = 1;

        var skipLabel:ARLabelData = firstLabel;
        lastLabel = _labels[1];

        if (adjustable.left == false)
        {
            staggeredScale = Math.min(
                staggeredScale,
                staggeredleftGutter / (firstLabel.width / 2));              
        }

        if (adjustable.right == false)
        {
            staggeredScale = Math.min(
                staggeredScale,
                staggeredrightGutter / (lastLabel.width / 2));              
        }

        // Now check for scaling due to overlap.
        // Note that we don't drop labels here...
        // if we can drop labels, then we always prefer horizontal
        // to staggered, and currently there's no way to force staggering.
        var n:int  = _labels.length;
        for (var i:int = 2; i < n; i++)
        {
            var thisLabel:ARLabelData = _labels[i];
            var spaceBetween:Number =
                (thisLabel.position - skipLabel.position) * axisLength;
            var requiredSpace:Number = (thisLabel.width + skipLabel.width) / 2;
            staggeredScale = Math.min(staggeredScale,
                                      spaceBetween / requiredSpace);
            skipLabel = lastLabel;
            lastLabel = thisLabel;
        }

        return { rotation: 0, 
                 left: staggeredleftGutter,
                 right:staggeredrightGutter,
                 scale: Math.max(0, staggeredScale), 
                 staggered: true };         
    }

    /**
     *  @private
     */
    private function measureAngledGutters(width:Number,
                                          labelRotation:Number,
                                          targetHeight:Number,
                                          firstLabel:ARLabelData,
                                          leftGutter:Number,
                                          rightGutter:Number,
                                          adjustable:Object):Object
    {
        var sint:Number;
        var cost:Number;
        var angle:Number;
        var angledleftGutter:Number = leftGutter;
        var angledrightGutter:Number = rightGutter;
        var axisLength:Number;
        var sigLabel:ARLabelData;
        var maxPosition:Number;
        var preferredPosition:Number;
        var minPosition:Number;
        var angledScale:Number = 1;
        var minDist:Number = 1;
        var lastLabel:ARLabelData = _labels[0];
        var n:int = _labels.length;
        var i:int;
        
        for (i = 1; i < n; i++)
        {
            var thisLabel:ARLabelData = _labels[i];
            minDist = Math.min(minDist,
                               thisLabel.position - lastLabel.position);
            lastLabel = thisLabel;
        }

        if (!isNaN(labelRotation))
            angle = labelRotation / 180 * Math.PI;
        else if (_horizontal == false)
            angle = Math.PI / 2;

        // This code now only applies if labelRotation is >= 0, or null.
        // We need to check the right side if angle is negative.
        if (adjustable.left == false &&
            (labelRotation >= 0 || isNaN(labelRotation)))
        {
            axisLength = width - angledleftGutter - angledrightGutter;

            if (isNaN(angle))
            {
                sint = _maxLabelHeight / (minDist * axisLength);

                if (sint >= 1)
                {
                    angle = Math.PI / 2;
                    sint = 1;
                    angledScale = Math.min(angledScale,
                        (firstLabel.position * axisLength + angledleftGutter) /
                        (firstLabel.height / 2));
                }
                else
                {
                    angle = Math.asin(sint);
                    if (Math.cos(angle) * firstLabel.width >
                        firstLabel.position * axisLength + angledleftGutter)
                    {
                        angle = Math.acos((firstLabel.position * axisLength +
                                          angledleftGutter) / firstLabel.width);
                        sint = Math.sin(angle);
                    }

                }
            }
            else
            {
                sint = Math.sin(angle);
                if (sint < 1)
                {
                    angledScale = Math.min(angledScale,
                        (firstLabel.position * axisLength + angledleftGutter) /
                        (Math.cos(angle) * firstLabel.width));
                }
                else
                {
                    angledScale = Math.min(angledScale,
                        (firstLabel.position * axisLength + angledleftGutter) /
                        (firstLabel.height / 2));
                }                   
            }
            
            // Mow check to see what angle we'd need to make sure
            // the leftmost label doesn't stick off the edge.
            if (!isNaN(targetHeight))
            {
                angledScale = Math.min(angledScale, targetHeight /
                    (_maxLabelWidth * sint +
                     _maxLabelHeight * Math.cos(angle)));
            }
        }
        else if (adjustable.right == false && (labelRotation < 0))
        {
            axisLength = width - angledleftGutter - angledrightGutter;

            sint = Math.sin(-angle);
            if (sint < 1)
            {
                angledScale = Math.min(angledScale,
                    ((1 - lastLabel.position) * axisLength +
                     angledrightGutter) /
                    (Math.cos(angle) * lastLabel.width));
            }
            else
            {
                angledScale = Math.min(angledScale,
                    ((1 - lastLabel.position) * axisLength +
                     angledrightGutter) /
                    (firstLabel.height / 2));
            }               
            
            // Now check to see what angle we'd need to make sure
            // the leftmost label doesn't stick off the edge.
            if (!isNaN(targetHeight))
            {
                angledScale = Math.min(angledScale,
                    targetHeight / (_maxLabelWidth * sint +
                    _maxLabelHeight * Math.cos(-angle)));
            }
            
        }
        else if (angle > 0)
        {
            sint = Math.sin(angle);
            cost = Math.cos(angle);

            sigLabel = firstLabel;

            if (!isNaN(targetHeight))
            {
                angledScale = Math.min(1,
                    targetHeight / (_maxLabelWidth * sint));
            }
            
            if (adjustable.right != false)
            {
                angledrightGutter = Math.max(angledrightGutter,
                    _labels[n - 1].height / 2 * angledScale);
            }
            
            axisLength = width - angledleftGutter - angledrightGutter;

            for (i = 0; i < n; i++)
            {
                sigLabel = _labels[i];

                // We should be scaling down if there's a max height.

                // First find out what the minimum position
                // this label is willing to be.
                minPosition = cost * sigLabel.width * angledScale +
                              sigLabel.height / 2 * angledScale * sint;
                
                // Now find out where the current gutters
                // wants this label to fall.
                preferredPosition = angledleftGutter +
                                    axisLength * sigLabel.position;
                if (minPosition > preferredPosition)
                {
                    // Adjust the left gutter accordingly.
                    axisLength = (width - angledrightGutter - minPosition) /
                                 (1 - sigLabel.position);
                    angledleftGutter = width - axisLength - angledrightGutter;
                }
            }
        }
        else if (angle < 0)
        {
            sint = Math.sin(-angle);
            cost = Math.cos(-angle);
            
            sigLabel = lastLabel;

            if (!isNaN(targetHeight))
            {
                angledScale = Math.min(1,
                    targetHeight / (_maxLabelWidth * sint));
            }

            if (adjustable.left != false)
            {
                angledleftGutter = Math.max(angledleftGutter,
                    _labels[0].height / 2 * angledScale);
            }
            
            axisLength = width - angledleftGutter - angledrightGutter;
            
            for (i = n - 1; i >= 0; i--)
            {
                sigLabel = _labels[i];
                
                // We should be scaling down if there's a max height.

                // First find out what the minimum position
                // this label is willing to be.
                maxPosition = width -
                              cost * sigLabel.width * angledScale -
                              sint * sigLabel.height / 2 * angledScale;
                
                // Now find out where the current gutters
                // wants this label to fall.
                preferredPosition = angledleftGutter +
                                    axisLength * sigLabel.position;
                if (maxPosition < preferredPosition)
                {
                    // Adjust the left gutter accordingly.
                    axisLength = (maxPosition - angledleftGutter) /
                                 sigLabel.position;
                    angledrightGutter = width - axisLength - angledleftGutter;
                }
            }
        }
        else
        {
            angledrightGutter = rightGutter;
            angledleftGutter = leftGutter;
			n = _labels.length;
            for (i = 0; i < n; i++)
            {
                sigLabel = _labels[i];

                var bOutsideBounds : Boolean = true;
                
                if (!isNaN(angle))
                {
                    bOutsideBounds = sigLabel.width * cost >
                        angledleftGutter + axisLength * sigLabel.position;
                }

                if (bOutsideBounds)
                {
                    var upperBound:Number = Math.PI / 2;
                    var lowerBound:Number = 0;

                    angle = upperBound;

                    do
                    {
                        sint = Math.sin(angle);
                        cost = Math.cos(angle);

                        if (!isNaN(targetHeight))
                        {
                            angledScale = Math.min(1, targetHeight /
                                (_maxLabelWidth * sint +
                                 _maxLabelHeight * cost));
                        }

                        minPosition = cost * sigLabel.width * angledScale;
                        
                        var currentPosition:Number = Math.max(minPosition,
                            leftGutter + (width - leftGutter -
                            rightGutter) * sigLabel.position);

                        axisLength =
                            (width - angledrightGutter - currentPosition) /
                            (1 - sigLabel.position);

                        angledleftGutter = Math.max(leftGutter,
                            width - axisLength - angledrightGutter);

                        var actualDistance:Number = minDist * axisLength;                   
                        var stackedDistance:Number =
                            _maxLabelHeight * angledScale / sint;

                        var diff:Number = actualDistance - stackedDistance;                     
                        if (diff > 0 && diff < 1)
                        {
                            break;
                        }
                        else if (actualDistance > stackedDistance)
                        {
                            // They're too far apart; let's lower the angle.
                            if (lowerBound >= angle)
                                break;
                            upperBound = angle;
                        }
                        else
                        {
                            // Too close; let's raise the angle.
                            if (upperBound <= angle)
                                break;
                            lowerBound = angle;
                        }
                        // sanity check.  sometimes, due to rounding errors, upper and lower bound never converge.
                        // if it gets below one one-hundred-thousands of a radian, that's probably close enough.
                        if (upperBound - lowerBound < .00001)
                            break;
                        angle = lowerBound + (upperBound - lowerBound) / 2;
                    }
                    while (1);
                }
            }

            // If the current suggested angle is null,
            // or pushes the current label out of bounds,
            // then binary search until we find an angle that matches
            // the angle suggested by the two closest labels.
            // Make sure we take into account scaling
            // as a result of the max height.
        }

        return { minimumAxisLength: width - angledleftGutter -
                                    angledrightGutter,
                 left: angledleftGutter,
                 right: angledrightGutter,
                 scale: angledScale,
                 rotation: angle,
                 sint: sint,
                 minDist: minDist };
    }

    /**
     *  @private
     */
    private function calcAngledSpacing(angledGutterData:Object):Object
    {       
        // At this point we know the AxisRenderer length,
        // and the distance between labels.
        // That means we can figure out how much we need to scale them down
        // to make sure they don't run into each other.

        var halfMaxStackedHeight:Number =
            angledGutterData.sint *
            angledGutterData.minDist *
            angledGutterData.minimumAxisLength;

        angledGutterData.scale = Math.max(0,
            Math.min(angledGutterData.scale,
            halfMaxStackedHeight / _maxLabelHeight));
        
        return angledGutterData;
    }

    /**
     *  @private
     */
    private function updateCaches():void
    {
        if (_cacheDirty)
        {
            /*
            _labelFormatCache = determineTextFormatFromStyles();

            var sm:ISystemManager = systemManager as ISystemManager;
            var embedFonts:Boolean = _canRotate =
                sm.isFontFaceEmbedded(_labelFormatCache);
            */
            
            if (!_labelRenderer)
            {
                _labelCache.properties =
                    { styleName: this};
            }
            else
            {
                _labelCache.properties = {};
            }           

            _cacheDirty = false;
        }       
    }

    /**
     *  @private
     */
    private function drawLabels(showLine:Boolean):Number
    {
        var axisStroke:IStroke = getStyle("axisStroke");

        var labelBottom:Number;     
        var labelY:Number;
        var xAdjustment:Number;
        var ldi:ARLabelData;
        var r:Number;
        
        renderLabels();
        
        var firstLabel:ARLabelData = _labels[0];

        var baseline:Number;
        if (_inverted)
        {
            baseline = _gutters.top -
                       Number(showLine == true ? axisStroke.weight : 0) -
                       tickSize(showLine);
        }
        else
        {
            baseline = unscaledHeight -
                       _gutters.bottom +
                       Number(showLine == true ? axisStroke.weight : 0) +
                       tickSize(showLine);
        }

        var scale:Number = _labelPlacement.scale;
        var n:int = _labels.length;
        
        // showLabels comes through CSS as a string
        var showLabelsStyle:Object = getStyle("showLabels");
        var showLabels:Boolean = showLabelsStyle != false &&
                                 showLabelsStyle != "false";
        
        if (showLabels == false)
            return baseline;
        
        // Place the labels.
        // If they have no rotation, we need to center them,
        // and potentially offset them (if they're staggered).
        var hscale:Number = scale;
        for (var i:int = 0; i < n; i++)
        {
            ldi = _labels[i];
            ldi.instance.scaleX = ldi.instance.scaleY = hscale;
        }
        
        var axisWidth:Number = unscaledWidth - _gutters.left - _gutters.right;
        var labelGap:Number = getStyle("labelGap");
        var alignOffset:Number = this.labelAlignOffset;

        if (_labelPlacement.rotation == 0)
        {
            var oddLabelYOffset:Number = 0;

            if (_labelPlacement.staggered)
            {
                oddLabelYOffset = scale * _maxLabelHeight *
                                  (Number(_inverted ? -1 : 1));
            }

            if (_inverted)
            {
                labelY = baseline - labelGap - _maxLabelHeight * scale;
                labelBottom = labelY - oddLabelYOffset;
            }
            else
            {
                labelY = baseline + labelGap;
                labelBottom = labelY +
                              _maxLabelHeight * scale +
                              oddLabelYOffset;
            }
            
            var staggerCount:int = 0;
            for (i = 0; i < n; i++)
            {
                var thisLabel:ARLabelData = _labels[i];
                
                thisLabel.instance.rotation = 0;
                thisLabel.instance.x = _gutters.left +
                                       axisWidth * thisLabel.position -
                                       thisLabel.width * scale * alignOffset;
                thisLabel.instance.y = labelY + staggerCount * oddLabelYOffset;
                
                staggerCount = 1 - staggerCount;
            }           
        }           
        else if (_labelPlacement.rotation > 0)
        {
            xAdjustment = 2 + Math.sin(_labelPlacement.rotation) *
                          firstLabel.height * scale / 2;
            
            var c:Number;
            var s:Number;
                        
            if (_inverted)
            {
                labelY = baseline - labelGap;

                if (_horizontal) // top, positive
                {
                    r = _labelPlacement.rotation / Math.PI * 180;
                    
                    c = Math.cos(Math.abs(_labelPlacement.rotation));
                    s = Math.sin(Math.abs(_labelPlacement.rotation));
                    
                    alignOffset = 1 - alignOffset;
                    
                    for (i = 0; i < n; i++)
                    {
                        ldi = _labels[i];

                        ldi.instance.rotation = r;

                        ldi.instance.x = _gutters.left +
                                         axisWidth * ldi.position -
                                         ldi.width * scale * c +
                                         ldi.height * alignOffset * scale * s;

                        ldi.instance.y = labelY -
                                         ldi.width * scale * s -
                                         ldi.height * alignOffset * scale * c;
                    }

                    labelBottom = labelY - _maxRotatedLabelHeight;
                }
                else // right, positive
                {
                    r = -90 -
                        (90 - ((_labelPlacement.rotation) / Math.PI * 180));
                    
                    c = Math.cos(Math.abs(_labelPlacement.rotation));
                    s = Math.sin(Math.abs(_labelPlacement.rotation));
                    
                    for (i = 0; i < n; i++)
                    {
                        ldi = _labels[i];

                        ldi.instance.rotation = r;

                        ldi.instance.x = _gutters.left +
                                         axisWidth * ldi.position -
                                         ldi.height * alignOffset * scale * s;

                        ldi.instance.y = labelY +
                                         ldi.height * alignOffset * scale * c;
						
                    }

                    labelBottom = labelY - _maxRotatedLabelHeight;
                }       
            }
            else // bottom or left, positive values
            {
                c = Math.cos(Math.abs(_labelPlacement.rotation));
                s = Math.sin(Math.abs(_labelPlacement.rotation));
                                
                r = -_labelPlacement.rotation / Math.PI * 180;
                labelY = baseline + labelGap;
				var sparkLabelClass:Class;
				try
				{
					if(getDefinitionByName("spark.components.Label"))
					{
						sparkLabelClass = Class(getDefinitionByName("spark.components.Label"));
					}
				}
				catch(e:Error)
				{
					// We need not do any thing here because we came here for projects which do not have spark.swc
					// It might be an MX-only or in compatible mode and hence using MX Label
				}
				for (i = 0; i < n; i++)
				{
					ldi = _labels[i];
					
					ldi.instance.rotation = r;
					
                    ldi.instance.x = _gutters.left +
                                     axisWidth * ldi.position -
                                     ldi.width * scale * c -
                                     ldi.height * alignOffset * scale * s;
					
					ldi.instance.y = labelY +
									 ldi.width * scale * s -
									 ldi.height * alignOffset * scale * c;
					
                    /*
					if(sparkLabelClass && ldi.instance is sparkLabelClass && layoutDirection == LayoutDirection.RTL)
					{
						ldi.instance.x = ldi.instance.x - ldi.width;
						ldi.instance.y = labelY;
					}*/
                }
                
                labelBottom = labelY + _maxRotatedLabelHeight;
            }
        }
        else // labelRotation < 0
        {
            if (_inverted)
            {
                if (_horizontal) //top, negative
                {
                    r = _labelPlacement.rotation / Math.PI * 180;
                    
                    c = Math.cos(Math.abs(_labelPlacement.rotation));
                    s = Math.sin(Math.abs(_labelPlacement.rotation));
                    
                    labelY = baseline - labelGap;

                    for (i = 0; i < n; i++)
                    {
                        ldi = _labels[i];

                        ldi.instance.rotation = r;
                        
                        ldi.instance.x = _gutters.left +
                                         axisWidth * ldi.position -
                                         ldi.height * alignOffset * scale * s;
                        
                        ldi.instance.y = labelY -
                                         ldi.height * alignOffset * scale * c;
                    }

                    labelBottom = labelY + _maxRotatedLabelHeight;
                }
                else // right, negative
                {
                    r = _labelPlacement.rotation / Math.PI * 180;
                    
                    c = Math.cos(Math.abs(_labelPlacement.rotation));
                    s = Math.sin(Math.abs(_labelPlacement.rotation));

                    labelY = baseline - labelGap;

                    for (i = 0; i < n; i++)
                    {
                        ldi = _labels[i];

                        ldi.instance.rotation = r;

                        ldi.instance.x = _gutters.left +
                                         axisWidth * ldi.position -
                                         ldi.height * alignOffset * scale * s;

                        ldi.instance.y = labelY -
                                         ldi.height * alignOffset * scale * c;
                    }
                }
            }
            else
            {
                if (_horizontal) // bottom, negative
                {
                    r = -_labelPlacement.rotation / Math.PI * 180;

                    c = Math.cos(Math.abs(_labelPlacement.rotation));
                    s = Math.sin(Math.abs(_labelPlacement.rotation));

                    labelY = baseline + labelGap;

                    for (i = 0; i < n; i++)
                    {
                        ldi = _labels[i];

                        ldi.instance.rotation = r;

                        ldi.instance.x =_gutters.left +
                                        axisWidth * ldi.position +
                                        s * ldi.height * scale * alignOffset;

                        ldi.instance.y = labelY -
                                         c * ldi.height * scale * alignOffset;
                    }

                    labelBottom = labelY + _maxRotatedLabelHeight;
                }
                else // left, negative
                {
                    r = -180 - _labelPlacement.rotation / Math.PI * 180;

                    c = Math.cos(Math.abs(_labelPlacement.rotation + Math.PI/2));
                    s = Math.sin(Math.abs(_labelPlacement.rotation + Math.PI/2));

                    labelY = baseline + labelGap;

                    for (i = 0; i < n; i++)
                    {
                        ldi = _labels[i];

                        ldi.instance.rotation = r;

                        ldi.instance.x = _gutters.left +
                                         axisWidth * ldi.position -
                                         ldi.height * alignOffset * scale * c +
                                         ldi.width * scale * s;

                        ldi.instance.y = labelY +
                                         ldi.height * alignOffset * scale * s +
                                         ldi.width * scale * c;
                    }
					labelBottom = labelY + _maxRotatedLabelHeight;
                }
            }
        }
        return labelBottom;
    }

    /**
     *  @private
     */
    private function renderLabels():void
    {
        var visCount:int = 0;
        var i:int;
        var labelData:ARLabelData;
        
        // showLabels comes through CSS as a string
        var showLabelsStyle:Object = getStyle("showLabels");
        var showLabels:Boolean = showLabelsStyle != false &&
                                 showLabelsStyle != "false";
		var sparkLabelClass:Class;
		try
		{
			if(getDefinitionByName("spark.components.Label"))
			{
				sparkLabelClass = Class(getDefinitionByName("spark.components.Label"));
			}
		}
		catch(e:Error)
		{
			// We need not do any thing here because we came here for projects which do not have spark.swc
			// It might be an MX-only or in compatible mode and hence using MX Label
		}
        
        if (showLabels == false)
        {
            _labelCache.count = 0;
        }
        else
        {
            _labelCache.count = _labels.length;
            var n:int = _labels.length;
            if (!_labelRenderer)
            {
                for (i = 0; i < n; i++)
                {
                    labelData = _labels[i];
                    labelData.instance = _labelCache.instances[visCount++];
					var label:Object = labelData.instance;// as Label;
                    
					if(label.hasOwnProperty("htmlText"))
						label.htmlText = labelData.text;
					else
                    label.text = labelData.text;
					if(sparkLabelClass && labelData.instance is sparkLabelClass)
					{
						label.setStyle("paddingTop", 5);
						label.setStyle("paddingLeft", 2);
					}
                    labelData.instance.width = labelData.width;
                    labelData.instance.height = labelData.height;
                }
            }
            else
            {
                for (i; i < n; i++)
                {
                    labelData = _labels[i];
                    labelData.instance = _labelCache.instances[visCount++];
                    
                    (labelData.instance as IDataRenderer).data =
                        labelData.value;
                    
                    (labelData.instance as IFlexDisplayObject).setActualSize(
                        labelData.width * _labelPlacement.scale,
                        labelData.height * _labelPlacement.scale);
                }           
            }
        }
    }

    /**
     *  @private
     */
    private function drawTitle(labelBottom:Number):void
    {
        // If we have a title, we need to create it here.
        if (_axis.title == "")
        {
            if (_titleField)
                _titleField.visible = false;
            return;
        }
        
        _titleField.visible = true;

        _titleField.setActualSize(_titleField.measuredWidth,
                                  _titleField.measuredHeight);
        
        /*
        var m:Matrix = _titleField.transform.matrix;
        m.a = Math.min(1,
            (unscaledWidth - _gutters.left - _gutters.right) /
            _titleField.measuredWidth);
        if (m.a < 0)
            m.a = 0;
        m.d = Math.min(1, 1.3 * m.a);
        _titleField.transform.matrix = m;
        */
        
        _titleField.y = Number(_inverted ?
                               labelBottom - _titleField.measuredHeight :
                               labelBottom);

        _titleField.x = _gutters.left + (unscaledWidth - _gutters.left -
                        _gutters.right - _titleField.measuredWidth/* * m.a*/) / 2;
    }

    /**
     *  @private
     */
    private function drawAxis(showLine:Boolean):void
    {
        var axisStroke:IStroke = getStyle("axisStroke");
        
        if (showLine == true)
        {
            var w:Number = Number(axisStroke.weight == 0 ?
                                  1 :
                                  axisStroke.weight);

            var baseline:Number = Number(_inverted ?
                                         _gutters.top - w :
                                         unscaledHeight - _gutters.bottom);

            graphics.lineStyle(0, 0, 0);

            var leftJoin:Number = 0;
            var rightJoin:Number = 0;

            if (_horizontal && _otherAxes)
            {
            	var n:int  = _otherAxes.length;
                for (var i:int = 0; i < n; i++)
                {
                    var otherAxis:IAxisRenderer = _otherAxes[i];
                    var otherLineStyle:IStroke;
                    
                    var otherShowLine:Boolean;
                    if (otherAxis is AxisRenderer)
                    {
                        otherLineStyle = AxisRenderer(otherAxis).getStyle("axisStroke");
                        otherShowLine = AxisRenderer(otherAxis).getStyle("showLine");
                    }
                    var placement:String = otherAxis.placement;
                    
                    if (otherLineStyle && otherShowLine)
                    {
                        if (placement == "right" || placement == "top")
                            rightJoin += otherLineStyle.weight;
                        else
                            leftJoin += otherLineStyle.weight;
                    }
                }
            }
            
            graphics.beginStroke();
            graphics.moveTo(_gutters.left - leftJoin,
                            baseline + w / 2);

            axisStroke.apply(graphics,null,null);
			
            graphics.lineTo(unscaledWidth - _gutters.right + rightJoin,
                            baseline + w / 2);
            graphics.endStroke();
        }
    }
    
    /**
     *  @private
     */
    private function drawTicks(showLine:Boolean):Number
    {
        var axisStroke:IStroke = getStyle("axisStroke");

        var axisWeight:Number = Number(showLine == true ?
                                       axisStroke.weight :
                                       0);

        var baseline:Number = Number(_inverted ?
                                     _gutters.top :
                                     unscaledHeight - _gutters.bottom);

        var w:Number;
        var a:Number;
        var left:Number;
        var right:Number;
        var axisStart:Number;
        var axisLength:Number;
        var tickStart:Number;
        var tickEnd:Number;
        var tickLen:Number = getStyle("tickLength");
        var tickPlacement:String = getStyle("tickPlacement");
        var oldWeight:Number;
        
        if (_inverted)
        {
            tickLen *= -1;
            axisWeight *= -1;
        }

        var tickStroke:IStroke = getStyle("tickStroke");
        
        switch (tickPlacement)
        {
            case "inside":
            {
                tickStart = baseline - tickLen;
                tickEnd = baseline;
                break;
            }

            case "outside": 
            default:
            {
                tickStart  = baseline + axisWeight;
                tickEnd = baseline + axisWeight + tickLen; 
                break;
            }

            case "cross":
            {
                tickStart = baseline -tickLen;
                tickEnd = baseline + axisWeight + tickLen;
                break;
            }

            case "none":
            {
                tickStart  = 0;
                tickEnd = 0;
                break;
            }
        }

        var tickCount:int = _ticks.length;
		var n:int;
        axisStart = _gutters.left;
        axisLength = unscaledWidth - _gutters.left - _gutters.right;

        var g:Graphics = graphics;
        
        if (tickStart != tickEnd)
        {
            oldWeight = tickStroke.weight;
            tickStroke.weight = _labelPlacement.scale *
                Number(tickStroke.weight == 0 ? 1 : tickStroke.weight);

            tickStroke.apply(g,null,null);
            tickStroke.weight = oldWeight;
			
			n  = tickCount;
            for (var i:int = 0; i < n; i++)
            {
                left = axisStart + axisLength * _ticks[i];
                g.beginStroke();
                g.moveTo(left, tickStart);
                g.lineTo(left, tickEnd);
                g.endStroke();
            }

        }   

        var minorTickStroke:IStroke = getStyle("minorTickStroke");

        axisStart = _gutters.left;
        axisLength = unscaledWidth - _gutters.left - _gutters.right;

        tickLen = getStyle("minorTickLength");
        tickPlacement = getStyle("minorTickPlacement");
        tickStart = tickEnd = 0;
        
        if (_inverted)
            tickLen *= -1;

        switch (tickPlacement)
        {
            case "inside":
            {
                tickStart = baseline - tickLen;
                tickEnd = baseline;
                break;
            }

            case "outside": 
            default:
            {
                tickStart  = baseline + axisWeight;
                tickEnd = baseline + axisWeight + tickLen; 
                break;
            }

            case "cross":
            {
                tickStart = baseline -tickLen;
                tickEnd = baseline + axisWeight + tickLen;
                break;
            }

            case "none":
            {
                tickStart  = 0;
                tickEnd = 0;
                break;
            }
        }

        if (tickStart != tickEnd)
        {
            var minorTicks:Array /* of Number */ = _minorTicks;
            tickCount = minorTicks ? minorTicks.length : 0;

            oldWeight = minorTickStroke.weight;
            minorTickStroke.weight = _labelPlacement.scale *
                Number(minorTickStroke.weight == 0 ? 1 : minorTickStroke.weight);

            minorTickStroke.apply(g,null,null);
            minorTickStroke.weight = oldWeight;
			
			n = tickCount;
            for (i = 0; i < n; i++)
            {
                left = axisStart + axisLength * minorTicks[i];
                g.beginStroke();
                g.moveTo(left, tickStart);
                g.lineTo(left, tickEnd);
                g.endStroke();
            }
        }

        return baseline + tickEnd;
    }

    /**
     *  @private
     */
    private function get labelAlignOffset():Number  
    {
        var result:Number;
        var labelAlign:String = getStyle("labelAlign");

        switch (labelAlign)
        {
            case "left":
            case "top":
            {
                result = 1;
                break;
            }

            case "right":
            case "bottom":
            {
                result= 0;
                break;
            }

            case "center":
            default:
            {
                result = 0.5;
                break;
            }
        }

        return result;
    }
    
    /**
     *  @private
     */
    private function updateRotation():void
    {
        rotation = Number(_horizontal ? 0 : 90);
    }

    /**
     *  @private
     */
    private function processAxisLabels(newLabelData:AxisLabelSet):Boolean
    {
        var n:int;
        var labelValues:Array /* of String */ = [];
        var bUseRenderer:Boolean =  (_labelRenderer != null);
        var i:int;
        
        _supressInvalidations++;
        n = newLabelData.labels.length;

        _labels = [];
        
        // Initialize the labelvalues with the text.
        for (i = 0; i < n; i++)
        {
            labelValues.push(newLabelData.labels[i].text);
        }

        if (newLabelData != _axisLabelSet)
        {
            if (_labelFunction != null)
            {
                labelValues = [];
                for (i = 0; i < n; i++)
                {
                    labelValues.push(_labelFunction(this,newLabelData.labels[i].text));
                }
            }
        }

        var maxLabelWidth:Number = 0;
        var maxLabelHeight:Number = 0;
        var ltext:AxisLabel; 
        var labelData:ARLabelData;
        
        if (!bUseRenderer)
        {       
            var systemManager:ISystemManager = systemManager as ISystemManager;
            var measuringField:IUITextField = _measuringField as IUITextField;
            if (!_measuringField)
            {
                measuringField = IUITextField(/*createInFontContext(UITextField)*/ new UITextField);
                _measuringField = UIComponent(measuringField);
                COMPILE::JS
                {
                    document.body.appendChild(_measuringField.element);
                    _measuringField.element.style.width="auto";
                    _measuringField.element.style.height="auto";
                    _measuringField.element.style.position="absolute";
                }
            }
            COMPILE::JS
            {
                _measuringField.element.style.display="block";
            }
            
            COMPILE::SWF
            {
            var tf:UITextFormat = determineTextFormatFromStyles();
            //measuringField.defaultTextFormat = tf;
            measuringField.setTextFormat(tf);
            //measuringField.multiline = true;

            // this information is carried around in the UITextFormat, but not automatically applied.
            // at some future date, this code should not need to set styles directly, but rather just inherit them through the style system.
            //measuringField.antiAliasType = tf.antiAliasType;
            //measuringField.gridFitType = tf.gridFitType;
            //measuringField.sharpness = tf.sharpness;
            //measuringField.thickness = tf.thickness;
            
            //measuringField.autoSize = "left";
            //measuringField.embedFonts =
            //    systemManager && systemManager.isFontFaceEmbedded(tf);
            }
        }
        else
        {
            var measuringLabel:IUIComponent = _measuringField as IUIComponent;
            if (!measuringLabel)
            {
                measuringLabel = _labelRenderer.newInstance();
                _measuringField = measuringLabel as UIComponent;
                if (measuringLabel is ISimpleStyleClient)
                    (measuringLabel as ISimpleStyleClient).styleName = this;
                measuringLabel.visible = false;
                addChild(UIComponent(measuringLabel));
            }

            var ilcMeasuringLabel:ILayoutManagerClient =
                measuringLabel as ILayoutManagerClient;

            var doMeasuringLabel:IDataRenderer =
                measuringLabel as IDataRenderer;
        }
        
        if (_horizontal)
        {
            for (i = 0; i < n; i++)
            {
                ltext = newLabelData.labels[i];
                labelData = new ARLabelData(ltext, ltext.position, labelValues[i]);
                
                if (!bUseRenderer)
                {
                    measuringField.htmlText = labelValues[i];
                    
                    labelData.width = measuringField.width + 5;
                    labelData.height = measuringField.height;
                }
                else
                {
                    doMeasuringLabel.data = ltext;
                    
                    if (ilcMeasuringLabel)
                        ilcMeasuringLabel.validateSize(true);

                    labelData.width = measuringLabel.measuredWidth + 5;
                    labelData.height = measuringLabel.measuredHeight;                                           
                }

                maxLabelWidth = Math.max(maxLabelWidth, labelData.width);
                maxLabelHeight = Math.max(maxLabelHeight, labelData.height);
                
                _labels[i] = labelData;                         
            }

            _ticks = newLabelData.ticks == null ?
                     [] :
                     newLabelData.ticks;

            _minorTicks = newLabelData.minorTicks == null ?
                          [] :
                          newLabelData.minorTicks;
        }
        else
        {
            var base:int = n - 1;
            for (i = 0; i < n; i++)
            {
                ltext = newLabelData.labels[i];
                labelData = new ARLabelData(ltext,1-ltext.position, labelValues[i]);

                if (!bUseRenderer)
                {
                    measuringField.htmlText = labelValues[i];
                    
                    labelData.width = measuringField.width + 5;
                    labelData.height = measuringField.height;
                }
                else
                {
                    doMeasuringLabel.data = ltext;
                    
                    if (ilcMeasuringLabel)
                        ilcMeasuringLabel.validateSize(true);
    
                    labelData.width = measuringLabel.measuredWidth + 5;
                    labelData.height = measuringLabel.measuredHeight;                                           
                }

                maxLabelWidth = Math.max(maxLabelWidth, labelData.width);
                maxLabelHeight = Math.max(maxLabelHeight, labelData.height);
                
                _labels[base - i] = labelData;                          
            }

            _ticks = [];
            if (newLabelData.ticks)
            {
                var forwardTicks:Array /* of Number */ = newLabelData.ticks;
                n = forwardTicks.length;
                for (i = n - 1; i >= 0; i--) 
                {
                    _ticks.push(1 - forwardTicks[i]);
                }
            }

            _minorTicks = [];
            if (newLabelData.minorTicks)
            {
                forwardTicks = newLabelData.minorTicks;
                n = forwardTicks.length;
                for (i = n - 1; i >= 0; i--) 
                {
                    _minorTicks.push(1 - forwardTicks[i]);
                }
            }
        }

        _maxLabelWidth = maxLabelWidth;
        _maxLabelHeight = maxLabelHeight;
        
        _forceLabelUpdate = false;

        _supressInvalidations--;

        COMPILE::JS
        {
            _measuringField.element.style.display="none";                
        }
        return newLabelData.accurate == true;
    }
    
    /**
     *  @private
     */
    private function reduceLabels(intervalStart:AxisLabel,
                                  intervalEnd:AxisLabel):Boolean
    {
        var newLabelData:AxisLabelSet =
            _axis.reduceLabels(intervalStart, intervalEnd);

        if (!newLabelData || newLabelData == _axisLabelSet || newLabelData.labels.length >= _axisLabelSet.labels.length)
            return false;

        processAxisLabels(newLabelData);

        _axisLabelSet = newLabelData;

        return true;
    }

    /**
     *  @private
     */
    private function tickSize(showLine:Boolean):Number
    {
        var tickLength:Number = getStyle("tickLength");
        var tickPlacement:String = getStyle("tickPlacement");
        var axisStroke:IStroke = getStyle("axisStroke");
        var rv:Number = 0;
        
        switch (tickPlacement)
        {           
            case "cross":
            {
                if (showLine)
                    rv = tickLength + axisStroke.weight;
                else
                    rv = tickLength;
                break;
            }

            case "inside":
            {
                rv = 0;
                break;
            }

            case "none":
            {
                rv = 0;
                break;
            }

            default:
            case "outside": 
            {
                rv = tickLength;
                break;
            }
        }

        return rv;
    }

    /**
     *  @private
     *  accessor function for automation
     */
    mx_internal function getAxisLabelSet():AxisLabelSet
    {
        return _axisLabelSet;
    }
    
    private function setupMouseDispatching():void
    {
        if (_highlightElements)
        {
            addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
            addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
            addEventListener(MouseEvent.MOUSE_MOVE, mouseOverHandler);
        }
        else
        {
            removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
            removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
            removeEventListener(MouseEvent.MOUSE_MOVE, mouseOverHandler);
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private function axisChangeHandler(event:Event):void
    {
        if (chart)
            chart.invalidateDisplayList();

        invalidateDisplayList();
    }

    /**
     *  @private
     */
    private function titleChangeHandler(event:Event):void
    {
        if (chart)
            chart.invalidateDisplayList();

        invalidateDisplayList();        
    } 
   
    
    /**
     *  @private
     */
    private function mouseOutHandler(event:MouseEvent):void
    {
        AxisBase(_axis).highlightElements(false);
    }
    
    /**
     *  @private
     */
    private function mouseOverHandler(event:MouseEvent):void
    {
        AxisBase(_axis).highlightElements(true);
    }
    
    override public function addedToParent():void
    {
        super.addedToParent();
        COMPILE::JS
        {
            element.style.position = "absolute";
        }
        commitProperties();
        measure();
        updateDisplayList(getExplicitOrMeasuredWidth(), getExplicitOrMeasuredHeight());
    }

}

}

////////////////////////////////////////////////////////////////////////////////

import mx.core.UIComponent;

import mx.charts.AxisLabel;
import mx.styles.ISimpleStyleClient;

/**
 *  @private
 */
class ARLabelData
{
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
    public function ARLabelData(value:AxisLabel, position:Number, text:String)
    {
        super();

        this.value = value;
        this.position = position;
        this.text = text;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    public var value:AxisLabel;

    /**
     *  @private
     *  Copied from value for performance.
     */
    public var position:Number;
    
    /**
     *  @private
     */
    public var width:Number;
    
    /**
     *  @private
     */
    public var height:Number;
    
    /**
     *  @private
     */
    public var instance:UIComponent;
    
    /**
     *  @private
     *  Modified version of value.text as part of AxisRenderer's label function
     */
    public var text:String;
}

