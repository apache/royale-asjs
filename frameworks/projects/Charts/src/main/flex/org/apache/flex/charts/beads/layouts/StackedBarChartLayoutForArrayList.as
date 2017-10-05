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
	import org.apache.royale.charts.core.IChartSeries;
	import org.apache.royale.charts.supportClasses.BarSeries;
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.collections.ArrayList;
	
	/**
	 *  The StackedBarChartLayoutForArrayList class calculates the size and position of all of the itemRenderers for
	 *  all of the series in a BarChart. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class StackedBarChartLayoutForArrayList extends StackedBarChartLayout
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function StackedBarChartLayoutForArrayList()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override public function layout():Boolean
		{
			var selectionModel:ISelectionModel = strand.getBeadByType(ISelectionModel) as ISelectionModel;
			var dp:ArrayList = selectionModel.dataProvider as ArrayList;
			if (!dp)
				return false;
			
			var layoutParent:ILayoutHost = strand.getBeadByType(ILayoutHost) as ILayoutHost;
			var contentView:IParentIUIBase = layoutParent.contentView as IParentIUIBase;
			
			var n:int = dp.length;			
			var maxXValue:Number = 0;
			var minXValue:Number = 0;
			var determineScale:Boolean = true;
			var seriesMaxes:Array = [];
			
			var useWidth:Number = contentView.width;
			var useHeight:Number = contentView.height;
			var itemHeight:Number = (useHeight - gap*(dp.length-1))/n;
			var seriesHeight:Number = itemHeight;
			var xpos:Number = 0;
			var ypos:Number = useHeight;
			
			var barValues:Array = [];
			var scaleFactor:Number = 1;
			
			if (horizontalAxisBead != null && !isNaN(horizontalAxisBead.maximum)) {
				maxXValue = horizontalAxisBead.maximum;
				determineScale = false;
			}
			if (horizontalAxisBead != null && !isNaN(horizontalAxisBead.minimum)) {
				minXValue = horizontalAxisBead.minimum;
			}
			
			for (var i:int=0; i < n; i++)
			{
				barValues.push({totalValue:0, scaleFactor:0});
				
				var data:Object = dp.getItemAt(i);
				
				for (var s:int = 0; s < chart.series.length; s++)
				{
					var bcs:BarSeries = chart.series[s] as BarSeries;
					var field:String = bcs.xField;
					
					var xValue:Number = Number(data[field]);
					barValues[i].totalValue += xValue;
				}
				
				if (determineScale) {
					maxXValue = Math.max(maxXValue, barValues[i].totalValue);
				}
			}
			
			scaleFactor = useWidth/(maxXValue - minXValue);
			
			for (i=0; i < n; i++)
			{
				data = dp.getItemAt(i);
				
				xpos = 0;
				
				for (s=0; s < chart.series.length; s++)
				{
					bcs = chart.series[s] as BarSeries;
					
					var child:IChartItemRenderer = chartDataGroup.getItemRendererForSeriesAtIndex(bcs,i);
					xValue = Number(data[bcs.xField]) - minXValue;
					xValue = xValue * scaleFactor;
					
					child.x = xpos;
					child.width = Math.floor(xValue);
					child.y = Math.floor(ypos - seriesHeight);
					child.height = seriesHeight;
					
					COMPILE::JS {
						child.element.style.position = "absolute";
					}
					
					xpos += xValue;
				}
				
				ypos -= (itemHeight + gap);
			}
			
			return true;
		}
	}
}
