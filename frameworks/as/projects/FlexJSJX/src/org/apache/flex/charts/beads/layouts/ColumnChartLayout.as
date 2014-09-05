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
	 *  The ColumnChartLayout arranges the graphics in vertical columns (or whatever shape
	 *  the renderer uses) using a category axis horizontally and a linear axis vertically. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class ColumnChartLayout extends ChartBaseLayout implements IBeadLayout, ICartesianChartLayout
	{
		public function ColumnChartLayout()
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
			var useWidth:Number = chart.width-yAxisOffset;;
			var useHeight:Number = chart.height - xAxisOffset;
			var itemWidth:Number =  (useWidth - gap*(dp.length-1))/dp.length;
			var seriesWidth:Number = itemWidth/chart.series.length;
			
			var maxYValue:Number = 0;
			var seriesMaxes:Array = [];
			
			for (var s:int = 0; s < chart.series.length; s++)
			{
				var bcs:ColumnSeries = chart.series[s] as ColumnSeries;
				seriesMaxes.push({maxValue:0,scaleFactor:0});
				
				for (var i:int = 0; i < n; i++)
				{
					var data:Object = dp[i];
					var field:String = bcs.yField;
					
					var yValue:Number = Number(data[field]);
					seriesMaxes[s].maxValue = Math.max(seriesMaxes[s].maxValue,yValue);
				}
				
				seriesMaxes[s].scaleFactor = useHeight/seriesMaxes[s].maxValue;
			}
			
			for (i = 0; i < n; i++)
			{
				data = dp[i];
				
				for (s=0; s < chart.series.length; s++)
				{
					bcs = chart.series[s] as ColumnSeries;
					
					var child:IChartItemRenderer = bcs.itemRenderer.newInstance() as IChartItemRenderer;
					child.itemRendererParent = chartDataGroup;
					child.data = data;
					child.fillColor = bcs.fillColor;
					yValue = Number(data[bcs.yField]);
					
					child.y = useHeight - yValue*seriesMaxes[s].scaleFactor;
					child.x = xpos;
					child.width = seriesWidth;
					child.height = yValue*seriesMaxes[s].scaleFactor;
					xpos += seriesWidth;
					
					chartDataGroup.addElement(child);
				}
				
				xpos += gap;
			}
			
			IEventDispatcher(chart).dispatchEvent(new Event("layoutComplete"));
		}
	}
}