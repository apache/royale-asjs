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
package org.apache.flex.charts.beads.layouts
{
	import org.apache.flex.charts.core.ICartesianChartLayout;
	import org.apache.flex.charts.core.IChartItemRenderer;
	import org.apache.flex.charts.supportClasses.ColumnSeries;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
	/**
	 *  The StackedColumnChartLayout class calculates the size and position of all of the itemRenderers for
	 *  all of the series in a StackedColumnChart. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class StackedColumnChartLayout extends ChartBaseLayout implements IBeadLayout, ICartesianChartLayout
	{
		/**
		 *  constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function StackedColumnChartLayout()
		{
		}
		
		private var _gap:Number = 20;
		
		/**
		 *  The amount of space to leave between series. If a chart has several series,
		 *  the bars for an X value are side by side with a gap between the groups of
		 *  bars.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get gap():Number
		{
			return _gap;
		}
		public function set gap(value:Number):void
		{
			_gap = value;
		}
		
		/**
		 * @private
		 */
		override protected function performLayout():void
		{
			var selectionModel:ISelectionModel = chart.getBeadByType(ISelectionModel) as ISelectionModel;
			var dp:Array = selectionModel.dataProvider as Array;
			if (!dp)
				return;
			
			var n:int = dp.length;
			var xAxisOffset:Number = horizontalAxisBead == null ? 0 : horizontalAxisBead.axisHeight;
			var yAxisOffset:Number = verticalAxisBead == null ? 0 : verticalAxisBead.axisWidth;
			
			var xpos:Number = yAxisOffset;
			var ypos:Number = 0;
			var useWidth:Number = chart.width-yAxisOffset;
			var useHeight:Number = chart.height - xAxisOffset;
			var itemWidth:Number = (useWidth - gap*(dp.length-1))/dp.length;
			
			var maxYValue:Number = 0;
			
			var barValues:Array = [];
			var maxValue:Number = 0;
			var scaleFactor:Number = 1;
			
			for (var i:int=0; i < n; i++)
			{
				barValues.push({totalValue:0, scaleFactor:0});
				var data:Object = dp[i];
				
				for (var s:int = 0; s < chart.series.length; s++)
				{
					var bcs:ColumnSeries = chart.series[s] as ColumnSeries;
					var field:String = bcs.yField;
					
					var yValue:Number = Number(data[field]);
					barValues[i].totalValue += yValue;
				}
				
				maxValue = Math.max(maxValue, barValues[i].totalValue);
			}
			
			scaleFactor = useHeight/maxValue;
			
			for (i=0; i < n; i++)
			{
				data = dp[i];
				ypos = useHeight;
				
				for (s=0; s < chart.series.length; s++)
				{
					bcs = chart.series[s] as ColumnSeries;

					var child:IChartItemRenderer = bcs.itemRenderer.newInstance() as IChartItemRenderer;
					chartDataGroup.addElement(child);
					child.itemRendererParent = chartDataGroup;
					child.data = data;
					child.fillColor = bcs.fillColor;
					yValue = Number(data[bcs.yField]);
					
					child.x = xpos;
					child.width = itemWidth;
					child.y = ypos - yValue*scaleFactor;
					child.height = yValue*scaleFactor;
					
					ypos = child.y;
				}
				
				xpos += gap + itemWidth;
			}
			
			IEventDispatcher(chart).dispatchEvent(new Event("layoutComplete"));
		}
	}
}