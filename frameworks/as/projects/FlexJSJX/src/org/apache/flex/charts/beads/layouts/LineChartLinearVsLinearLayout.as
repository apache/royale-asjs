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
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
	/**
	 *  The LineChartLinearVsLinearLayout displays a line graph of plot points
	 *  where both axes are numeric values. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class LineChartLinearVsLinearLayout extends ChartBaseLayout implements IBeadLayout, ICartesianChartLayout
	{
		public function LineChartLinearVsLinearLayout()
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
			
			var n:int = dp.length;
			var xAxisOffset:Number = horizontalAxisBead == null ? 0 : horizontalAxisBead.axisHeight;
			var yAxisOffset:Number = verticalAxisBead == null ? 0 : verticalAxisBead.axisWidth;
			
			var xpos:Number = yAxisOffset;
			var ypos:Number = xAxisOffset;
			var useWidth:Number = chart.width - yAxisOffset;;
			var useHeight:Number = chart.height - xAxisOffset;
			var itemWidth:Number =  useWidth/dp.length;
			
			var seriesMaxes:Array = [];
			
			for (var s:int = 0; s < chart.series.length; s++)
			{
				var aseries:IChartSeries = chart.series[s] as IChartSeries;
				seriesMaxes.push({minX:Number.MAX_VALUE,maxX:Number.MIN_VALUE,
					              minY:Number.MAX_VALUE,maxY:Number.MIN_VALUE,
								  scaleX:0,scaleY:0,points:[]});
				
				for (var i:int = 0; i < n; i++)
				{
					var data:Object = dp[i];
					var xfield:String = aseries.xField;
					var yfield:String = aseries.yField;
					
					var xValue:Number = Number(data[xfield]);
					seriesMaxes[s].minX = Math.min(seriesMaxes[s].minX,xValue);
					seriesMaxes[s].maxX = Math.max(seriesMaxes[s].maxX,xValue);
					var yValue:Number = Number(data[yfield]);
					seriesMaxes[s].minY = Math.min(seriesMaxes[s].minY,yValue);
					seriesMaxes[s].maxY = Math.max(seriesMaxes[s].maxY,yValue);
				}
				
				seriesMaxes[s].scaleX = useWidth/(seriesMaxes[s].maxX - seriesMaxes[s].minX);
				seriesMaxes[s].scaleY = useHeight/(seriesMaxes[s].maxY - seriesMaxes[s].minY);
			}
			
			// draw the itemRenderers at each vertex and build the points array for the
			// line segment.
			
			for (s=0; s < chart.series.length; s++)
			{
				aseries = chart.series[s] as IChartSeries;
				
				for (i=0; i < n; i++)
				{
					data = dp[i];
					xValue = Number(data[aseries.xField]);
					yValue = Number(data[aseries.yField]);
					
					var childX:Number = (xValue-seriesMaxes[s].minX)*seriesMaxes[s].scaleX + yAxisOffset;
					var childY:Number = useHeight - (yValue-seriesMaxes[s].minY)*seriesMaxes[s].scaleY;
					
					seriesMaxes[s].points.push( {x:childX, y:childY} );
					
					var child:IChartItemRenderer = chartDataGroup.getItemRendererForSeriesAtIndex(aseries,i);
					if (child) {
						child.x = childX - 5;
						child.y = childY - 5;
						child.width = 10;
						child.height = 10;
					}
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
					renderer.points = seriesMaxes[s].points;
				}
			}
			
			IEventDispatcher(chart).dispatchEvent(new Event("layoutComplete"));
		}
	}
}