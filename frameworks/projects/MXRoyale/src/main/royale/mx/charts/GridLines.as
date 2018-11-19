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
import org.apache.royale.geom.Rectangle;

import mx.charts.chartClasses.CartesianChart;
import mx.charts.chartClasses.ChartElement;
import mx.charts.chartClasses.ChartState;
import mx.charts.chartClasses.GraphicsUtilities;
import mx.charts.chartClasses.IAxisRenderer;
import mx.charts.styles.HaloDefaults;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.graphics.IFill;
import mx.graphics.IStroke;
import mx.graphics.SolidColorStroke;
import mx.graphics.Stroke;
import mx.styles.CSSStyleDeclaration;

use namespace mx_internal;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  Specifies the direction of the grid lines.
 *  Allowable values are <code>horizontal</code>,
 *  <code>vertical</code>, or <code>both</code>. 
 *  The default value is <code>horizontal</code>.  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="gridDirection", type="String", enumeration="horizontal,vertical,both", inherit="no")]

/**
 *  Specifies the fill pattern for alternating horizontal bands
 *  not defined by the <code>fill</code> property.
 *  Use the IFill class to define the properties of the fill
 *  as a child tag in MXML, or create an IFill object in ActionScript.  
 *  Set to <code>null</code> to not fill the bands.
 *  The default value is <code>null</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="horizontalAlternateFill", type="mx.graphics.IFill", inherit="no")]

/**
 *  Specifies the number of tick marks between horizontal grid lines.
 *  Set the <code>horizontalChangeCount</code> property to 3
 *  to draw a grid line at every third tick mark along the axis. 
 *  The fill style alternates at each grid line, so a larger
 *  <code>horizontalChangeCount</code> value results
 *  in large alternating bands. 
 *  The defaults value is <code>1</code>. 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="horizontalChangeCount", type="int", inherit="no")]

/**
 *  Specifies the fill pattern for every other horizontal band
 *  created by the grid lines.
 *  Use the IFill class to define the  properties of the fill
 *  as a child tag in MXML, or create a IFill object in ActionScript.  
 *  Set to <code>null</code> to not fill the bands.
 *  The default value is <code>null</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="horizontalFill", type="mx.graphics.IFill", inherit="no")]

/**
 *  Specifies the line style for the horizontal origin.
 *  Use the Stroke class to define the properties as a child tag in MXML,
 *  or create a Stroke object in ActionScript.  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="horizontalOriginStroke", type="mx.graphics.IStroke", inherit="no")]

/**
 *  Determines whether to draw the horizontal origin.
 *  If <code>true</code>, and the origin falls within the chart bounds,
 *  the grid lines draw it using the <code>horizontalOriginStroke</code> style.
 *  For ColumnChart, LineChart, PlotChart, BubbleChart, and AreaChart
 *  controls, the default value is <code>true</code>.
 *  For BarChart controls, the default value is <code>false</code>.
 *  This property does not apply to PieChart controls.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="horizontalShowOrigin", type="Boolean", inherit="no")]

/**
 *  Specifies the line style for horizontal grid lines.
 *  Use the Stroke class to define the properties as a child tag in MXML,
 *  or create a Stroke object in ActionScript.  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="horizontalStroke", type="mx.graphics.IStroke", inherit="no")]

/**
 *  Determines whether to align horizontal grid lines with tick marks.
 *  If <code>true</code>, horizontal grid lines are drawn aligned
 *  with the tick marks.
 *  If <code>false</code>, Flex draws them between tick marks.
 *  The default value is <code>true</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="horizontalTickAligned", type="Boolean", inherit="no")]

/**
 *  Specifies the fill pattern for alternating vertical bands
 *  not defined by the fill property.
 *  Use the IFill class to define the properties of the fill
 *  as a child tag in MXML, or create an IFill object in ActionScript.  
 *  Set to <code>null</code> to not fill the bands.
 *  The default value is <code>null</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="verticalAlternateFill", type="mx.graphics.IFill", inherit="no")]

/**
 *  Specifies the number of tick marks between vertical grid lines.
 *  Set <code>verticalChangeCount</code> to <code>3</code>
 *  to draw a grid line at every third tick mark along the axis. 
 *  The fill style alternates at each grid line, so a larger
 *  <code>verticalChangeCount</code> value results in large alternating bands. 
 *  The default value is <code>1</code>. 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="verticalChangeCount", type="int", inherit="no")]

/**
 *  Specifies the fill pattern for alternating vertical bands
 *  created by the grid lines.
 *  Use the IFill class to define the properties of the fill
 *  as a child tag in MXML, or create a IFill object in ActionScript.  
 *  Set to <code>null</code> to not fill the bands.
 *  The default value is <code>null</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="verticalFill", type="mx.graphics.IFill", inherit="no")]

/**
 *  Specifies the line style for the vertical origin.
 *  Use the Stroke class to define the properties as a child tag in MXML,
 *  or create a Stroke object in ActionScript.  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="verticalOriginStroke", type="mx.graphics.IStroke", inherit="no")]

/**
 *  Determines whether to draw the vertical Origin.
 *  If <code>true</code>, and the origin falls within the chart bounds,
 *  Flex draws it using the <code>verticalOriginStroke</code> style.
 *  For ColumnChart, LineChart, and AreaChart controls,
 *  the default value is <code>false</code>.
 *  For PlotChart, BubbleChart, and BarChart controls,
 *  the default value is <code>true</code>.
 *  This property does not apply to PieChart controls.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="verticalShowOrigin", type="Boolean", inherit="no")]

/**
 *  Specifies the line style for vertical grid lines.
 *  Use the Stroke class to define the properties as a child tag in MXML,
 *  or create a Stroke object in ActionScript.  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="verticalStroke", type="mx.graphics.IStroke", inherit="no")]

/**
 *  Determines whether to align vertical grid lines with tick marks.
 *  If <code>true</code>, Flex draws vertical grid lines aligned
 *  with the tick marks.
 *  If <code>false</code>, Flex draws them between tick marks.
 *  The default value is <code>true</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="verticalTickAligned", type="Boolean", inherit="no")]

/** 
 *  The GridLines class draws grid lines inside the data area of the chart.
 *  Flex can draw lines horizontally, vertically, or both. 
 *  
 *  <p>Flex draws grid lines aligned to the tick marks of the parent chart.
 *  By default, Flex draws one line for every tick mark
 *  along the appropriate axis.</p>
 *  
 *  <p>You typically use the GridLines class as a child tag
 *  of a chart control's <code>backgroundElements</code> property
 *  or <code>annotationElements</code> property.</p>
 *  
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:GridLines&gt;</code> tag inherits all the properties
 *  of its parent classes and adds the following properties:</p>
 *  
 *  <pre>
 *  &lt;mx:GridLines
 *    <strong>Styles</strong>
 *     gridDirection="horizontal|vertical|both"
 *     horizontalAlternateFill="null"
 *     horizontalChangeCount="1"
 *     horizontalFill="null"
 *     horizontalOriginStroke="<i>IStroke; No default</i>"
 *     horizontalShowOrigin="<i>Default depends on type of chart</i>"
 *     horizontalStroke="<i>IStroke; No default</i>"
 *     horizontalTickAligned="true|false"
 *     verticalAlternateFill="null"
 *     verticalChangeCount="1"
 *     verticalFill="null"
 *     verticalOriginStroke="<i>IStroke; No default</i>"
 *     verticalShowOrigin="<i>Default depends on type of chart</i>"
 *     verticalStroke="<i>IStroke; No default</i>"
 *     verticalTickAligned="true|false"
 *  /&gt;
 *  </pre>
 *
 *  @includeExample examples/GridLinesExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class GridLines extends ChartElement
{
//    include "../core/Version.as";

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
	public function GridLines()
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
//	private static var _moduleFactoryInitialized:Dictionary = new Dictionary(true);

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
		
		var gridLinesStyle:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, "mx.charts.GridLines");
		if (gridLinesStyle)
		{
			gridLinesStyle.setStyle("horizontalOriginStroke", new SolidColorStroke(0xB0C1D0, 1));
			gridLinesStyle.setStyle("horizontalStroke", new SolidColorStroke(0xEEEEEE, 0));
			gridLinesStyle.setStyle("verticalOriginStroke", new SolidColorStroke(0xB0C1D0, 1));
			gridLinesStyle.setStyle("verticalStroke", new SolidColorStroke(0xEEEEEE, 0));
		}
			
		var hgridLinesStyle:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, ".horizontalGridLines");
		if (hgridLinesStyle)
		{
			hgridLinesStyle.setStyle("horizontalFill", null);
			hgridLinesStyle.setStyle("verticalFill", null);
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
	override protected function updateDisplayList(unscaledWidth:Number,
												  unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		var len:int;
		var c:Object;
		var stroke:IStroke;
		var changeCount:int;
		var ticks:Array /* of Number */;
		var spacing:Array /* of Number */;
		var axisLength:Number;
		var colors:Array /* of IFill */;
		var rc:Rectangle;
		var originStroke:IStroke;
		var addedFirstLine:Boolean;
		var addedLastLine:Boolean;
		var n:int;
		
		if (!chart||
			chart.chartState == ChartState.PREPARING_TO_HIDE_DATA ||
			chart.chartState == ChartState.HIDING_DATA)
		{
			return;
		}
		
		var g:Graphics = graphics;
		g.clear();
		
		var gridDirection:String = getStyle("gridDirection");
		if (gridDirection == "horizontal" || gridDirection == "both")
		{
			stroke = getStyle("horizontalStroke");
			
			changeCount = Math.max(1, getStyle("horizontalChangeCount"));
			if ((changeCount * 0 != 0) || changeCount <= 1)
				changeCount = 1;

			var verticalAxisRenderer:IAxisRenderer;
			
			if (!(CartesianChart(chart).verticalAxisRenderer))
			{
				verticalAxisRenderer = CartesianChart(chart).getLeftMostRenderer();
				if (!verticalAxisRenderer)
					verticalAxisRenderer = CartesianChart(chart).getRightMostRenderer();
			}
			else
			    verticalAxisRenderer = CartesianChart(chart).verticalAxisRenderer;

			ticks = verticalAxisRenderer.ticks;

			if (getStyle("horizontalTickAligned") == false)
			{
				len = ticks.length;
				spacing = [];
				n = len;
				for (var i:int = 1; i < n; i++)
				{
					spacing[i - 1] = (ticks[i] + ticks[i - 1]) / 2;
				}
			}
			else
			{
				spacing = ticks;
			}
					
			addedFirstLine = false;
			addedLastLine = false;

			if (spacing[0] != 0)
			{
				addedFirstLine = true;
				spacing.unshift(0);
			}

			if (spacing[spacing.length - 1] != 1)
			{
				addedLastLine = true;
				spacing.push(1);
			}

			axisLength = unscaledHeight;
						
			colors = [ getStyle("horizontalFill"),
					   getStyle("horizontalAlternateFill") ];

			len = spacing.length;
			
			if (spacing[len - 1] < 1)
			{
				c = colors[1];
				if (c != null)
				{
					g.lineStyle(0, 0, 0);
					GraphicsUtilities.fillRect(g, 0, 
						spacing[len - 1] * axisLength, unscaledWidth,
						unscaledHeight, c);
				}
			}

			n = spacing.length;
			for (i = 0; i < n; i += changeCount)
			{
				var idx:int = len - 1 - i;
				c = colors[(i / changeCount) % 2];
				var bottom:Number = spacing[idx] * axisLength;
				var top:Number =
					spacing[Math.max(0, idx - changeCount)] * axisLength;
				rc = new Rectangle(0, top, unscaledWidth, bottom-top);

				if (c != null)
				{
					g.lineStyle(0, 0, 0);
					GraphicsUtilities.fillRect(g, rc.left, rc.top,
											   rc.right, rc.bottom, c);
				}
				
				if (stroke && rc.bottom >= -1) //round off errors
				{
					if (addedFirstLine && idx == 0)
						continue;
					if (addedLastLine && idx == (spacing.length-1))
						continue;

                    g.beginStroke();
					stroke.apply(g,null,null);
					g.moveTo(rc.left, rc.bottom);
					g.lineTo(rc.right, rc.bottom);
                    g.endStroke();

				}
			}
		}

		if (gridDirection == "vertical" || gridDirection == "both")
		{
			
			stroke = getStyle("verticalStroke");
			changeCount = Math.max(1,getStyle("verticalChangeCount"));
			
			if (isNaN(changeCount) || changeCount <= 1)
				changeCount = 1;

			var horizontalAxisRenderer:IAxisRenderer;
			
			if (!(CartesianChart(chart).horizontalAxisRenderer))
			{
				horizontalAxisRenderer = CartesianChart(chart).getBottomMostRenderer();
				if (!horizontalAxisRenderer)
					horizontalAxisRenderer = CartesianChart(chart).getTopMostRenderer();
			}
			else
			    horizontalAxisRenderer = CartesianChart(chart).horizontalAxisRenderer;
			
			ticks = horizontalAxisRenderer.ticks.concat();

			if (getStyle("verticalTickAligned") == false)
			{
				len = ticks.length;
				spacing = [];
				n = len;
				for (i = 1; i < n; i++)
				{
					spacing[i - 1] = (ticks[i] + ticks[i - 1]) / 2;
				}
			}
			else
			{
				spacing = ticks;
			}

			addedFirstLine = false;
			addedLastLine = false;
			
			if (spacing[0] != 0)
			{
				addedFirstLine = true;
				spacing.unshift(0);
			}

			if (spacing[spacing.length - 1] != 1)
			{
				addedLastLine = true;
				spacing.push(1);
			}
				
			axisLength = unscaledWidth;
							
			colors = [ getStyle("verticalFill"),
					   getStyle("verticalAlternateFill") ];

			n = spacing.length;
			for (i = 0; i < n; i += changeCount)
			{
				c = colors[(i / changeCount) % 2];
				var left:Number = spacing[i] * axisLength;
				var right:Number =
					spacing[Math.min(spacing.length - 1,
									 i + changeCount)] * axisLength;
				rc = new Rectangle(left, 0, right - left, unscaledHeight);
				if (c != null)
				{
					g.lineStyle(0, 0, 0);
					GraphicsUtilities.fillRect(g, rc.left, rc.top,
											   rc.right, rc.bottom, c);
				}

				if (stroke) // round off errors
				{
					if (addedFirstLine && i == 0)
						continue;
					if (addedLastLine && i == spacing.length-1)
						continue;
						
                    g.beginStroke();
					stroke.apply(g,null,null);
					g.moveTo(rc.left, rc.top);
					g.lineTo(rc.left, rc.bottom);
                    g.endStroke();
				}
			}
		}

		var horizontalShowOrigin:Object = getStyle("horizontalShowOrigin");
		var verticalShowOrigin:Object = getStyle("verticalShowOrigin");

		if (verticalShowOrigin || horizontalShowOrigin)
		{
			var cache:Array /* of Object */ = [ { xOrigin: 0, yOrigin: 0 } ];
			var sWidth:Number = 0.5;

			dataTransform.transformCache(cache, "xOrigin", "x", "yOrigin", "y");

			if (horizontalShowOrigin &&
				cache[0].y > 0 && cache[0].y < unscaledHeight)
			{
				originStroke = getStyle("horizontalOriginStroke");
                g.beginStroke();
				originStroke.apply(g,null,null);
				g.moveTo(0, cache[0].y - sWidth / 2);
				g.lineTo(unscaledWidth/*$width*/, cache[0].y - sWidth / 2);
                g.endStroke();
			}

			if (verticalShowOrigin &&
				cache[0].x > 0 && cache[0].x < unscaledWidth)
			{
				originStroke = getStyle("verticalOriginStroke");
                g.beginStroke();
				originStroke.apply(g,null,null);
				g.moveTo(cache[0].x - sWidth / 2, 0);
				g.lineTo(cache[0].x - sWidth / 2, unscaledHeight/*$height*/);
                g.endStroke();
			}
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
		invalidateDisplayList();
	}
	
	/**
	 *  @private
	 */
	override public function chartStateChanged(oldState:uint,
											   newState:uint):void
	{
		invalidateDisplayList();
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
        super.setActualSize(w, h);
        updateDisplayList(w, h);
    }

}

}
