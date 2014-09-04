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
	import org.apache.flex.charts.beads.ChartItemRendererFactory;
	import org.apache.flex.charts.core.ICartesianChartLayout;
	import org.apache.flex.charts.core.IChart;
	import org.apache.flex.charts.core.IChartItemRenderer;
	import org.apache.flex.charts.core.IChartSeries;
	import org.apache.flex.charts.core.IConnectedItemRenderer;
	import org.apache.flex.charts.core.IHorizontalAxisBead;
	import org.apache.flex.charts.core.IVerticalAxisBead;
	import org.apache.flex.charts.supportClasses.LineSegmentItemRenderer;
	import org.apache.flex.charts.supportClasses.LineSeries;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IContentView;
	import org.apache.flex.core.IDataProviderItemRendererMapper;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStrand;
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
	public class LineChartCategoryVsLinearLayout implements IBeadLayout, ICartesianChartLayout
	{
		public function LineChartCategoryVsLinearLayout()
		{
		}
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			IEventDispatcher(value).addEventListener("widthChanged", changeHandler);
			IEventDispatcher(value).addEventListener("childrenAdded", changeHandler);
			IEventDispatcher(value).addEventListener("itemsCreated", changeHandler);
			IEventDispatcher(value).addEventListener("layoutNeeded", changeHandler);
		}
		
		/**
		 * @private
		 */
		private function changeHandler(event:Event):void
		{
			var layoutParent:ILayoutParent = _strand.getBeadByType(ILayoutParent) as ILayoutParent;
			var contentView:IContentView = layoutParent.contentView as IContentView;
			contentView.removeAllElements();
			
			var selectionModel:ISelectionModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
			var dp:Array = selectionModel.dataProvider as Array;
			if (!dp)
				return;
			
			var series:Array = IChart(_strand).series;
			var n:int = dp.length;
			trace("There are "+series.length+" series in this chart");
			
			var xAxis:IHorizontalAxisBead;
			if (_strand.getBeadByType(IHorizontalAxisBead)) xAxis = _strand.getBeadByType(IHorizontalAxisBead) as IHorizontalAxisBead;
			var xAxisOffset:Number = xAxis == null ? 0 : xAxis.axisHeight;
			var yAxis:IVerticalAxisBead;
			if (_strand.getBeadByType(IVerticalAxisBead)) yAxis = _strand.getBeadByType(IVerticalAxisBead) as IVerticalAxisBead;
			var yAxisOffset:Number = yAxis == null ? 0 : yAxis.axisWidth;
			
			var xpos:Number = yAxisOffset;
			var useWidth:Number = UIBase(_strand).width-yAxisOffset;;
			var useHeight:Number = UIBase(_strand).height - xAxisOffset;
			var itemWidth:Number =  useWidth/dp.length;
			
			var maxYValue:Number = 0;
			var seriesMaxes:Array = [];
			
			for (var s:int = 0; s < series.length; s++)
			{
				var aseries:IChartSeries = series[s] as IChartSeries;
				seriesMaxes.push({maxValue:0,scaleFactor:0,points:[]});
				
				for (var i:int = 0; i < n; i++)
				{
					var data:Object = dp[i];
					var field:String = aseries.yField;
					
					var yValue:Number = Number(data[field]);
					seriesMaxes[s].maxValue = Math.max(seriesMaxes[s].maxValue,yValue);
				}
				
				seriesMaxes[s].scaleFactor = useHeight/seriesMaxes[s].maxValue;
			}
			
			// draw the itemRenderers at each vertex and build the points array for the
			// line segment.
			
			for (s=0; s < series.length; s++)
			{
				aseries = series[s] as IChartSeries;
				
				xpos = yAxisOffset + itemWidth/2;
				
				for (i=0; i < n; i++)
				{
					data = dp[i];
					yValue = Number(data[aseries.yField]);
					
					var childX:Number = xpos;
					var childY:Number = useHeight - yValue*seriesMaxes[s].scaleFactor;
					
					seriesMaxes[s].points.push( {x:childX, y:childY} );
					
					if (aseries.itemRenderer) {
						var child:IChartItemRenderer = aseries.itemRenderer.newInstance() as IChartItemRenderer;
						child.itemRendererParent = contentView;
						child.data = data;
						child.fillColor = aseries.fillColor;
						child.x = childX - 5;
						child.y = childY - 5;
						child.width = 10;
						child.height = 10;
						contentView.addElement(child);
					}
					
					xpos += itemWidth;
				}
			}
			
			// draw the line segment
			
			for (s=0; s < series.length; s++)
			{
				var lcs:LineSeries = series[s] as LineSeries;
				
				if (lcs.lineSegmentRenderer)
				{
					var renderer:LineSegmentItemRenderer = lcs.lineSegmentRenderer.newInstance() as LineSegmentItemRenderer;
					renderer.lineColor = lcs.lineColor;
					renderer.lineThickness = lcs.lineThickness;
					renderer.data = lcs;
					renderer.points = seriesMaxes[s].points;
					renderer.itemRendererParent = contentView;
					contentView.addElement(renderer);
				}
			}
			
			IEventDispatcher(_strand).dispatchEvent(new Event("layoutComplete"));
		}
	}
}