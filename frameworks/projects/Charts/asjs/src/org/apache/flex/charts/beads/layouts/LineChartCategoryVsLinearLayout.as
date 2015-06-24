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
	import org.apache.flex.charts.supportClasses.ILineSegmentItemRenderer;
	import org.apache.flex.charts.supportClasses.LineSeries;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IViewport;
	import org.apache.flex.core.IViewportModel;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
	/**
	 *  The LineChartCategoryVsLinearLayout displays a line graph of plot points
	 *  where the horizontal axis is category value and the vertical axis is numeric. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class LineChartCategoryVsLinearLayout extends ChartBaseLayout implements IBeadLayout, ICartesianChartLayout
	{
		public function LineChartCategoryVsLinearLayout()
		{
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
			
			// this layout will use and modify the IViewportMode
			var viewport:IViewport = chart.getBeadByType(IViewport) as IViewport;
			var viewportModel:IViewportModel = viewport.model;
			
			var n:int = dp.length;
			var xAxisOffset:Number = 0;
			var yAxisOffset:Number = 0;
			
			var xpos:Number = yAxisOffset;
			var useWidth:Number = viewportModel.contentWidth-yAxisOffset;;
			var useHeight:Number = viewportModel.contentHeight - xAxisOffset;
			var itemWidth:Number =  useWidth/dp.length;
			
			var maxYValue:Number = 0;
			var minYValue:Number = 0;
			var scaleYFactor:Number = 1;
			var determineYScale:Boolean = true;
			var seriesPoints:Array = [];
			
			if (verticalAxisBead != null && !isNaN(verticalAxisBead.maximum)) {
				maxYValue = verticalAxisBead.maximum;
				determineYScale = false;
			}
			if (verticalAxisBead != null && !isNaN(verticalAxisBead.minimum)) {
				minYValue = verticalAxisBead.minimum;
			}
			
			for (var s:int = 0; s < chart.series.length; s++)
			{
				var aseries:IChartSeries = chart.series[s] as IChartSeries;
				seriesPoints.push({points:[]});
				
				for (var i:int = 0; i < n; i++)
				{
					var data:Object = dp[i];
					var field:String = aseries.yField;
					
					var yValue:Number = Number(data[field]);
					if (determineYScale) maxYValue = Math.max(maxYValue,yValue);
				}				
			}
			
			scaleYFactor = useHeight/(maxYValue - minYValue);
			
			// draw the itemRenderers at each vertex and build the points array for the
			// line segment.
			
			for (s=0; s < chart.series.length; s++)
			{
				aseries = chart.series[s] as IChartSeries;
				
				xpos = yAxisOffset + itemWidth/2;
				
				for (i=0; i < n; i++)
				{
					data = dp[i];
					yValue = Number(data[aseries.yField]) - minYValue;
					
					var childX:Number = xpos;
					var childY:Number = useHeight - yValue*scaleYFactor;
					
					seriesPoints[s].points.push( {x:childX, y:childY} );
					
					var child:IChartItemRenderer = chartDataGroup.getItemRendererForSeriesAtIndex(aseries,i);
					if (child) {
						child.x = childX - 5;
						child.y = childY - 5;
						child.width = 10;
						child.height = 10;
					}
					
					xpos += itemWidth;
				}
			}
			
			// draw the line segment
			
			for (s=0; s < chart.series.length; s++)
			{
				var lcs:LineSeries = chart.series[s] as LineSeries;
				
				if (lcs.lineSegmentRenderer)
				{
					var renderer:ILineSegmentItemRenderer = lcs.lineSegmentRenderer.newInstance() as ILineSegmentItemRenderer;
					chartDataGroup.addElement(renderer);
					renderer.itemRendererParent = chartDataGroup;
					renderer.data = lcs;
					renderer.points = seriesPoints[s].points;
				}
			}
			
			IEventDispatcher(chart).dispatchEvent(new Event("layoutComplete"));
		}
	}
}