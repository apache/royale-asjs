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
import mx.charts.chartClasses.ChartBase;
import mx.charts.chartClasses.DataDescription;
import mx.charts.chartClasses.IAxis;
import mx.charts.chartClasses.IBar;
import mx.charts.chartClasses.IChartElement;
import mx.charts.chartClasses.IStackable;
import mx.charts.chartClasses.IStackable2;
import mx.charts.chartClasses.Series;
import mx.charts.chartClasses.StackedSeries;
import mx.charts.series.items.BarSeriesItem;
import mx.core.UIComponent;
import mx.core.mx_internal;

use namespace mx_internal;

[DefaultProperty("series")]

/**
 *  A grouping set that can be used to stack or cluster BarSeries objects in any chart. A BarSet encapsulates the same grouping behavior that is used in a BarChart control, but it can be used to assemble custom charts that are based on
 *	the CartesianChart class.
 *  BarSets can be used to cluster any chart element type that implements the IBar interface. It can stack any chart element type that implements the IBar and IStackable interfaces. Because the BarSet class implements the IBar
 *	interface, you can use BarSets to cluster other BarSets to build more advanced custom charts.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class BarSet extends StackedSeries implements IBar
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
	public function BarSet()
	{
		super();
		_labelLayer = new UIComponent();
		_labelLayer.styleName = this;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

    /**
	 *  @private
     */	
	private var _perBarWidthRatio:Number;
	
    /**
	 *  @private
     */	
	private var _perBarMaxColumnWidth:Number;
	
    /**
	 *  @private
     */	
	private var _rightOffset:Number;
	
	/**
	 *  @private
	 */
	private var _labelLayer:UIComponent;
	
	//--------------------------------------------------------------------------
	//
	// Overridden Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
 	//  labelContainer
	//----------------------------------
 
 	/**
 	 *  @private
 	 */
 	override public function get labelContainer():UIComponent
 	{
 		return _labelLayer;
 	}
 	
 	//------------------------------------
 	//	series
 	//------------------------------------
 	
 	/**
 	 *  @private
 	 */
 	override public function set series(value:Array /* of Series */):void
 	{
 		super.series = value;
 		var g:IChartElement;
 		var n:int = value.length;
 		
 		for (var i:int = 0; i < n; i++)
 		{
			g = value[i] as IChartElement;
			if (!g)
				continue;
			if (g.labelContainer) 			
 				_labelLayer.addChild(value[i].labelContainer);
 		}
 	}
 	
	//----------------------------------
	//  type
	//----------------------------------
	
	[Inspectable(category="General", enumeration="stacked,100%,clustered,overlaid", defaultValue="clustered")]
	
	/**
	 * @private
	 */
	override public function set type(value:String):void
	{
		super.type = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  barWidthRatio
	//----------------------------------

    /**
	 *  @private
	 *  Storage for the barWidthRatio property.
     */	
	private var _barWidthRatio:Number = 0.65;
	
	[Inspectable(category="General")]
	
	/**
	 *  Specifies how wide to render the bars relative to the category width. A value of <code>1</code> uses the entire space, while a value of <code>.6</code> 
	 *  uses 60% of the bar's available space. 
	 *  You typically do not set this property directly.
	 *  The actual bar width used is the smaller of <code>barWidthRatio</code> and the <code>maxbarWidth</code> property
	 *  
	 *  @default 0.65
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get barWidthRatio():Number
	{
		return _barWidthRatio;
	}	
	
	/**
	 *  @private
	 */
	public function set barWidthRatio(value:Number):void
	{
		_barWidthRatio = value;
		
		invalidateSeries();
	}

	//----------------------------------
	//  maxBarWidth
	//----------------------------------

    /**
	 *  @private
	 *  Storage for the maxBarWidth property.
     */	
	private var _maxBarWidth:Number;
	
	[Inspectable(category="General")]
	
	/**
	 *  Specifies how wide to draw the bars, in pixels.  The actual bar width used is the smaller of this style and the <code>barWidthRatio</code> property.
	 *  Clustered bars divide this space proportionally among the bars in each cluster. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get maxBarWidth():Number
	{
		return _maxBarWidth;
	}	
	
	/**
	 *  @private
	 */
	public function set maxBarWidth(value:Number):void
	{
		_maxBarWidth = value;
		
		invalidateSeries();
	}

	//----------------------------------
	//  offset
	//----------------------------------

    /**
	 *  @private
	 *  Storage for the offset property.
     */	
	private var _offset:Number = 0;
	
	[Inspectable(category="General")]
	
	/**
	 *  Specifies how far to offset the center of the bars from the center of the available space, relative the category width. 
	 *  The range of values is a percentage in the range <code>-100</code> to <code>100</code>. 
	 *  Set to <code>0</code> to center the bars in the space. Set to <code>-50</code> to center the column at the beginning of the available space. You typically do not set this property directly.
	 *  
	 *  @default 0
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
		
		invalidateSeries();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------
	
    /**
	 *  @private
     */	
	override protected function customizeSeries(glyph:IChartElement,
												i:uint):void
	{
		var currentSeries:IBar = IBar(glyph);

		if (!isNaN(_perBarWidthRatio))
			currentSeries.barWidthRatio = _perBarWidthRatio;

		if (!isNaN(_perBarMaxColumnWidth))
			currentSeries.maxBarWidth = _perBarMaxColumnWidth;

		if (type == "clustered")		
			currentSeries.offset = _rightOffset - i * _perBarWidthRatio;
		else
			currentSeries.offset = offset;
			
		super.customizeSeries(glyph, i);
	}

    /**
	 *  @private
     */	
	override protected function buildSubSeries():void
	{
		var g:IChartElement;
		
		var series:Array /* of Series */ = this.series;
		
		if (type == "100%" || type == "stacked")
		{
			_perBarWidthRatio = barWidthRatio;
			_perBarMaxColumnWidth = maxBarWidth;
		}
		else
		{
			_perBarWidthRatio = barWidthRatio / series.length;
			_perBarMaxColumnWidth = maxBarWidth / series.length;
		}

		_rightOffset = offset + barWidthRatio / 2 - _perBarWidthRatio / 2;

		while (numChildren > 0)
		{
			removeChildAt(0);
		}
		
		var n:int  = series.length;
		for (var i:int = 0; i < n; i++)
		{
			g = IChartElement(series[i]);
			customizeSeries(g,i);
			addChild(g as UIComponent);
		}

		var s:ChartBase = chart;
		if (s)	
			s.invalidateSeriesStyles();
	}

	/**
	 *  @private
	 */
	override public function describeData(dimension:String, requiredFields:uint):Array /* of DataDescription */
	{
		var result:Array /* of DataDescription */ = [];

		updateStacking();
		validateData();

		var desc:DataDescription;
		var i:int;
		var n:int  = series.length;
		
		if (type == "100%")
		{
			if (dimension == CartesianTransform.HORIZONTAL_AXIS)
			{
				desc = new DataDescription();
				desc.min = 0;
				desc.max = 100;
				result = [desc];
			}
			else
			{
				for (i = 0; i < n; i++)
				{
					result = result.concat(series[i].describeData(dimension, requiredFields));
				}
			}
		}
		else if (type == "stacked")
		{
			if (dimension == CartesianTransform.HORIZONTAL_AXIS)
			{
				var hCache:Array /* of Object */ = [ { value:stackedMinimum }, { value:stackedMaximum } ];
				dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).mapCache(hCache,"value","number");
				
				desc = new DataDescription();
				desc.min = hCache[0].number;
				desc.max = hCache[1].number;			
				result = [desc];
			}
			else
			{
				for (i = 0; i < n; i++)
				{
					result = result.concat(series[i].describeData(dimension, requiredFields));
				}
			}
		}
		else
		{
			for (i = 0; i < n; i++)
			{
				result = result.concat(series[i].describeData(dimension, requiredFields));
			}
		}

		return result;		
	}

    /**
	 *  @private
     */	
	override protected function formatDataTip(hd:HitData):String
	{
		var dt:String = "";
		var elt:IStackable = IStackable(hd.element);

		var item:BarSeriesItem = BarSeriesItem(hd.chartItem);
		var percent:Number;		
		var total:Number = posTotalsByPrimaryAxis[item.yValue];
		// now compute the percentage
		if (type == "100%")
		{
			percent = Number(item.xValue) - Number(item.minValue);
			percent = Math.round(percent * 10) / 10;
		}
		else
		{
			if (type=="stacked" && allowNegativeForStacked)
			{
				if (isNaN(total))
					total = 0;
				total += isNaN(negTotalsByPrimaryAxis[item.yValue]) ? 0 : negTotalsByPrimaryAxis[item.yValue];
			}
			var size:Number = Number(item.xValue) - Number(item.minValue);
			percent = Math.round(size / total * 1000) / 10;
		}
		
		var n:String = (elt as Series).displayName;
		if (n != null && n.length>0)
			dt += "<b>" + n + "</b><BR/>";
		
		var hAxis:IAxis = dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS);
		var vAxis:IAxis = dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS);

		var yName:String = vAxis.displayName;
		if (yName != "")
			dt += "<i>" + yName + ":</i> ";
		dt += vAxis.formatForScreen(item.yValue) + "\n";

		var xName:String = hAxis.displayName;

		if (xName != "")
			dt += "<i>" + xName + ":</i> ";
		dt += hAxis.formatForScreen(Number(item.xValue) - Number(item.minValue)) + " (" +  percent + "%)\n";

		if (xName != "")
			dt += "<i>" + xName + " (total):</i> ";
		else
			dt += "<i>total:</i> ";
		dt += hAxis.formatForScreen(total);
		
		return dt;
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
	override public function stack():void
	{
		var n:int = series.length;
		var i:int;
		var ser:IStackable2;
		var obj:Object;

		posTotalsByPrimaryAxis = {}; //new Dictionary(false);
		negTotalsByPrimaryAxis = {}; //new Dictionary(false);
		stackedMaximum = 0;
		
		var previousSeries:IStackable2 = null;
		for (i = 0; i < n; i++)
		{
			ser = series[i];
			if (type == "stacked" && allowNegativeForStacked)
			{
				obj = ser.stackAll(posTotalsByPrimaryAxis,negTotalsByPrimaryAxis, previousSeries);
				stackedMaximum = Math.max(stackedMaximum, obj.maxValue);
				stackedMinimum = isNaN(stackedMinimum) ? obj.minValue : Math.min(stackedMinimum, obj.minValue);
			}
			else
			{
				stackedMaximum = Math.max(stackedMaximum,ser.stack(posTotalsByPrimaryAxis,previousSeries));
				if (type == "100%")
					stackedMinimum = 0;
				else
				{
					var cachedDataDescriptions:Array /* of DataDescription */ = Series(ser).describeData(CartesianTransform.HORIZONTAL_AXIS,
											DataDescription.REQUIRED_MIN_MAX | DataDescription.REQUIRED_BOUNDED_VALUES);
					if (cachedDataDescriptions.length)
						stackedMinimum = isNaN(stackedMinimum) ? cachedDataDescriptions[0].min : 
														Math.min(stackedMinimum, cachedDataDescriptions[0].min);
				} 
			}	
			previousSeries = ser;
		}

		var totals:Object = type == "100%" ? posTotalsByPrimaryAxis : null;
		
		for (i = 0; i < n; i++)
		{
			ser = series[i];
			ser.stackTotals = totals;
		}
	}

}


}
