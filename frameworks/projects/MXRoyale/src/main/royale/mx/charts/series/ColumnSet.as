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
import mx.charts.chartClasses.IAxis;
import mx.charts.chartClasses.IChartElement;
import mx.charts.chartClasses.IColumn;
import mx.charts.chartClasses.IStackable;
import mx.charts.chartClasses.Series;
import mx.charts.chartClasses.StackedSeries;
import mx.charts.series.items.ColumnSeriesItem;
import mx.core.UIComponent;
import mx.core.mx_internal;

use namespace mx_internal;

[DefaultProperty("series")]

/**
 *  ColumnSet is a grouping set that can be used to stack or cluster column series in any arbitrary chart. A ColumnSet encapsulates the same grouping behavior used in a ColumnChart, but can be used to assemble custom charts based on
 *	CartesianChart.
 *  ColumnSets can be used to cluster any chart element type that implements the IColumn interface. It can stack any chart element type that implements the IColumn and IStackable interfaces.  
 *	Since ColumnSet itself implements the IColumn interface, you can use ColumnSets to cluster other ColumnSets to build more advanced custom charts.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ColumnSet extends StackedSeries implements IColumn
{
//    include "../../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *	Constructor.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function ColumnSet()
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
	private var _perColumnWidthRatio:Number;

	/**
	 *  @private
	 */
	private var _perColumnMaxColumnWidth:Number;

	/**
	 *  @private
	 */
	private var _leftOffset:Number;
	
	/**
	 * @private
	 */
	private var _labelLayer:UIComponent; 
	
	
	//-------------------------------------------------------------------------
	//
	// Overridden Properties
	//
	//-------------------------------------------------------------------------
	
	//-----------------------------------
	//	labelContainer
	//-----------------------------------

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
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

    //----------------------------------
	//  columnWidthRatio
    //----------------------------------

	/**
	 *  @private
	 */
	private var _columnWidthRatio:Number = 0.65;

	[Inspectable(category="General")]
	
	/**
	 *  Specifies the width of columns relative to the category width. A value of <code>1</code> uses the entire space, while a value of <code>.6</code> 
	 *  uses 60% of the column's available space. 
	 *  You typically do not set this property directly. 
	 *  The actual column width used is the smaller of <code>columnWidthRatio</code> and the <code>maxColumnWidth</code> property
	 *  
	 *  @default 0.65
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

		invalidateSeries();
	}

    //----------------------------------
	//  maxColumnWidth
    //----------------------------------

	/**
	 *  @private
	 */
	private var _maxColumnWidth:Number;

	[Inspectable(category="General")]
	
	/**
	 *  Specifies the width of the columns, in pixels. The actual column width used is the smaller of this style and the <code>columnWidthRatio</code> property.
	 *  Clustered columns divide this space proportionally among the columns in each cluster. 
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

		invalidateSeries();
	}

    //----------------------------------
	//  offset
    //----------------------------------

	/**
	 *  @private
	 */
	private var _offset:Number = 0;

	[Inspectable(category="General")]
	
	/**
	 *  Specifies how far to offset the center of the columns from the center of the available space, relative to the category width. 
	 *  At the value of default <code>0</code>, the columns are centered on the space.
	 *  Set to <code>-50</code> to center the column at the beginning of the available space.
	 *  You typically do not set this property directly. The ColumnChart control manages this value based on 
	 *  its <code>columnWidthRatio</code> property.
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
	//  Overridden Methods
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
	override protected function customizeSeries(glyph:IChartElement,i:uint):void
	{
		var currentSeries:IColumn = IColumn(glyph);
		
		if (!isNaN(_perColumnWidthRatio))
			currentSeries.columnWidthRatio = _perColumnWidthRatio;

		if (!isNaN(_perColumnMaxColumnWidth))
			currentSeries.maxColumnWidth = _perColumnMaxColumnWidth;

		if (type == "clustered")		
			currentSeries.offset = _leftOffset + i*_perColumnWidthRatio;
		else
			currentSeries.offset = offset;
			
		super.customizeSeries(glyph,i);
	}

	/** 
	 *  @inheritDoc
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	override protected function buildSubSeries():void
	{
		var i:int;
		var g : IChartElement;
		
		var series:Array /* of Series */ = this.series;
		
		if (type == "100%" || type == "stacked")
		{
			_perColumnWidthRatio = columnWidthRatio;
			_perColumnMaxColumnWidth = maxColumnWidth;
		}
		else
		{
			_perColumnWidthRatio = columnWidthRatio / series.length;
			_perColumnMaxColumnWidth = maxColumnWidth / series.length;
		}
		_leftOffset = offset + (1-columnWidthRatio)/2 + _perColumnWidthRatio/2 - .5;


		while (numChildren > 0)
		{
			removeChildAt(0);
		}
	
		var n:int  = series.length;
		if (type == "stacked" || type == "100%")
		{
			for (i = n - 1; i >= 0;i--)
			{
				g = IChartElement(series[i]);
				customizeSeries(g,i);
				addChild(g as UIComponent);
			}
		}
		else
		{
			for (i = 0; i < n; i++)
			{
				g = IChartElement(series[i]);
				customizeSeries(g,i);
				addChild(g as UIComponent);
			}
		}
		
		var s:ChartBase = chart;
		if (s)	
			s.invalidateSeriesStyles();
	}

	/**
	 *  @inheritDoc
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	override protected function formatDataTip(hd:HitData):String
	{
		var dt:String = "";
		var elt : IStackable = IStackable(hd.element);
		var item:ColumnSeriesItem = ColumnSeriesItem(hd.chartItem);
		
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
		
			

		var n:String = (elt as Series).displayName;
		if (n != null && n.length>0)
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

	/**
	 *  @inheritDoc
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	override public function describeData(dimension:String, requiredFields:uint):Array /* of DataDescription */
	{
		var result:Array /* of DataDescription */ = super.describeData(dimension,requiredFields);
		if (dimension == CartesianTransform.HORIZONTAL_AXIS && result.length > 0)
		{
			result[0].padding = .5;	
		}
		return result;
	}
	
}


}