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
package org.apache.royale.charts.beads.layouts
{
	import org.apache.royale.charts.core.ICartesianChartLayout;
	import org.apache.royale.charts.core.IChartItemRenderer;
	import org.apache.royale.charts.supportClasses.ColumnSeries;
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.ISelectionModel;
    import org.apache.royale.core.ILayoutHost;
    import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	
	/**
	 *  The StackedColumnChartLayout class calculates the size and position of all of the itemRenderers for
	 *  all of the series in a StackedColumnChart. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class StackedColumnChartLayout extends ChartBaseLayout implements IBeadLayout, ICartesianChartLayout
	{
		/**
		 *  constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
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
		override public function layout():Boolean
		{
			var selectionModel:ISelectionModel = strand.getBeadByType(ISelectionModel) as ISelectionModel;
			var dp:Array = selectionModel.dataProvider as Array;
			if (!dp)
				return false;
			
            var layoutParent:ILayoutHost = strand.getBeadByType(ILayoutHost) as ILayoutHost;
            var contentView:IParentIUIBase = layoutParent.contentView as IParentIUIBase;
			
			var n:int = dp.length;
            var useWidth:Number = contentView.width;
            var useHeight:Number = contentView.height;
			var itemWidth:Number = (useWidth - gap*(dp.length-1))/dp.length;
			var seriesWidth:Number = itemWidth;
			var xpos:Number = 0;
			var ypos:Number = 0;
			
			var maxYValue:Number = 0;
			var minYValue:Number = 0;
			var determineScale:Boolean = true;
			
			var barValues:Array = [];
			var scaleFactor:Number = 1;
			
			if (verticalAxisBead != null && !isNaN(verticalAxisBead.maximum)) {
				maxYValue = verticalAxisBead.maximum;
				determineScale = false;
			}
			if (verticalAxisBead != null && !isNaN(verticalAxisBead.minimum)) {
				minYValue = verticalAxisBead.minimum;
			}
			
			for (var i:int=0; i < n; i++)
			{
				barValues.push({totalValue:0});
				var data:Object = dp[i];
				
				for (var s:int = 0; s < chart.series.length; s++)
				{
					var bcs:ColumnSeries = chart.series[s] as ColumnSeries;
					var field:String = bcs.yField;
					
					var yValue:Number = Number(data[field]);
					barValues[i].totalValue += yValue;
				}
				
				if (determineScale) {
					maxYValue = Math.max(maxYValue, barValues[i].totalValue);
				}
			}
			
			scaleFactor = useHeight / (maxYValue - minYValue);
			
			for (i=0; i < n; i++)
			{
				data = dp[i];
				ypos = useHeight;
				
				for (s=0; s < chart.series.length; s++)
				{
					bcs = chart.series[s] as ColumnSeries;

					var child:IChartItemRenderer = chartDataGroup.getItemRendererForSeriesAtIndex(bcs,i);
					
					yValue = Number(data[field]) - minYValue;
					yValue = yValue * scaleFactor;
					
					child.x = xpos;
					child.width = itemWidth;
					child.y = ypos - Math.ceil(yValue);
					child.height = Math.floor(yValue);
					
					COMPILE::JS {
						child.element.style.position = "absolute";
					}
					
					ypos = child.y;
				}
				
				xpos += gap + itemWidth;
			}
			
			return true;
		}
	}
}
