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
	import org.apache.flex.charts.core.IChartSeries;
	import org.apache.flex.charts.supportClasses.BarSeries;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
	/**
	 *  The StackedBarChartLayout class calculates the size and position of all of the itemRenderers for
	 *  all of the series in a StackedBarChart. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class StackedBarChartLayout extends ChartBaseLayout implements IBeadLayout, ICartesianChartLayout
	{
		/**
		 *  constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function StackedBarChartLayout()
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
			var maxXValue:Number = 0;
			var seriesMaxes:Array = [];
			
			var xAxisOffset:Number = horizontalAxisBead == null ? 0 : horizontalAxisBead.axisHeight;
			var yAxisOffset:Number = verticalAxisBead == null ? 0 : verticalAxisBead.axisWidth;
			
			var useWidth:Number = chart.width - yAxisOffset;
			var useHeight:Number = ((chart.height-xAxisOffset) / n) - gap;
			var seriesHeight:Number = useHeight;
			var xpos:Number = xAxisOffset;
			var ypos:Number = chart.height - xAxisOffset - seriesHeight;
			
			var barValues:Array = [];
			var maxValue:Number = 0;
			var scaleFactor:Number = 1;
			
			for (var i:int=0; i < n; i++)
			{
				barValues.push({totalValue:0, scaleFactor:0});
				
				var data:Object = dp[i];
				
				for (var s:int = 0; s < chart.series.length; s++)
				{
					var bcs:BarSeries = chart.series[s] as BarSeries;
					var field:String = bcs.xField;
					
					var xValue:Number = Number(data[field]);
					barValues[i].totalValue += xValue;
				}
				
				maxValue = Math.max(maxValue, barValues[i].totalValue);
			}
			
			scaleFactor = useWidth/maxValue;
			
			for (i=0; i < n; i++)
			{
				data = dp[i];
				xpos = yAxisOffset;
				
				for (s=0; s < chart.series.length; s++)
				{
					bcs = chart.series[s] as BarSeries;
					
					var child:IChartItemRenderer = (chart.series[s] as IChartSeries).itemRenderer.newInstance() as IChartItemRenderer;
					chartDataGroup.addElement(child);
					child.itemRendererParent = chartDataGroup;
					child.data = data;
					child.fillColor = bcs.fillColor;
					xValue = Number(data[bcs.xField]);
					
					child.x = xpos;
					child.width = xValue*scaleFactor;
					child.y = ypos;
					child.height = seriesHeight;
					
					xpos += xValue*scaleFactor;
				}
				
				ypos -= gap + seriesHeight;
			}
			
			IEventDispatcher(chart).dispatchEvent(new Event("layoutComplete"));
		}
	}
}