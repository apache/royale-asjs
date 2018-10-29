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

import mx.core.UIComponent;

import mx.charts.HitData;
import mx.charts.chartClasses.CartesianTransform;
import mx.charts.chartClasses.ChartBase;
import mx.charts.chartClasses.IAxis;
import mx.charts.chartClasses.IChartElement;
import mx.charts.chartClasses.StackedSeries;
import mx.charts.series.items.AreaSeriesItem;
import mx.core.mx_internal;

use namespace mx_internal;

[DefaultProperty("series")]

/**
 *  A grouping set that can be used to stack AreaSeries objects in any chart. An AreaSet encapsulates the same stacking behavior that is used in an AreaChart control, but can be used to assemble custom charts that are based on
 *	the CartesianChart class.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class AreaSet extends StackedSeries							  
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
	public function AreaSet()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	// Properties
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	//  type
	//----------------------------------
	[Inspectable(category="General", enumeration="stacked,100%,overlaid", defaultValue="overlaid")]
	
	/**
	 * @private
	 */
	override public function set type(value:String):void
	{
		super.type = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	override protected function buildSubSeries():void
	{
		var i:int;
		var g:IChartElement;
		var n:int = series.length;
		
		while (numChildren > 0)
		{
			removeChildAt(0);
		}

		var series:Array /* of Series */ = this.series;
		if (type == "stacked" || type == "100%")
		{
			for (i = n - 1; i >= 0; i--)
			{
				g = IChartElement(series[i]);
				customizeSeries(g, i);
				addChild(g as UIComponent);
			}
		}
		else
		{
			for (i = 0; i < n; i++)
			{
				g = IChartElement(series[i]);
				customizeSeries(g, i);
				addChild(g as UIComponent);
			}
		}

		var s:ChartBase = chart;
		if (s)	
			s.invalidateSeriesStyles();
	}

	/**
	 *  @private
	 */
	override protected function formatDataTip(hd:HitData):String
	{
		var dt:String = "";
		var elt:AreaSeries = AreaSeries(hd.element);

		var item:AreaSeriesItem = AreaSeriesItem(hd.chartItem);
		var percent:Number;
		
		var total:Number = posTotalsByPrimaryAxis[item.xValue];
		
		// now compute the percentage
		if (type == "100%")
		{
			percent = Number(item.yValue) - Number(item.minValue);
			percent = Math.round(percent * 10) / 10;
		}
		else
		{
			if (type=="stacked" && allowNegativeForStacked)
			{
				if (isNaN(total))
					total = 0;
				total += isNaN(negTotalsByPrimaryAxis[item.xValue]) ? 0 : negTotalsByPrimaryAxis[item.xValue];
			}
			var size:Number = Number(item.yValue) - Number(item.minValue);
			percent = Math.round(size / total * 1000) / 10;
		}
		
		var n:String = elt.displayName;
		if (n != null && n.length > 0)
			dt += "<b>" + n + "</b><BR/>";
		
		var hAxis:IAxis = dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS);
		var xName:String = hAxis.displayName;
		if (xName != "")
			dt += "<i>" + xName + ":</i> ";
		dt += hAxis.formatForScreen(item.xValue) + "\n";

		var vAxis:IAxis = dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS);
		var yName:String = vAxis.displayName;

		if (yName != "")
			dt += "<i>" + yName + ":</i> ";
		dt += vAxis.formatForScreen(Number(item.yValue) - Number(item.minValue)) + " (" +  percent + "%)\n";
		if (yName != "")
			dt += "<i>" + yName + " (total):</i> ";
		else
			dt += "<i>total:</i> ";
		dt += vAxis.formatForScreen(total);		
				
		return dt;
	}
}

}
