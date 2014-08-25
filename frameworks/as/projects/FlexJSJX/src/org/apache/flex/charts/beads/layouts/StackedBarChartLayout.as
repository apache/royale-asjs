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
	import org.apache.flex.charts.core.IHorizontalAxisBead;
	import org.apache.flex.charts.core.IVerticalAxisBead;
	import org.apache.flex.charts.supportClasses.BarChartSeries;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IDataProviderItemRendererMapper;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
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
	public class StackedBarChartLayout implements IBeadLayout, ICartesianChartLayout
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
		private function changeHandler(event:Event):void
		{
			var layoutParent:ILayoutParent = _strand.getBeadByType(ILayoutParent) as ILayoutParent;
			
			var factory:ChartItemRendererFactory = _strand.getBeadByType(IDataProviderItemRendererMapper) as ChartItemRendererFactory;
			var n:int = factory.seriesRenderers.length;
			
			var maxXValue:Number = 0;
			var series:Array = IChart(_strand).series;
			trace("There are "+series.length+" series in this chart");
			var seriesMaxes:Array = [];
			
			var xAxis:IHorizontalAxisBead;
			if (_strand.getBeadByType(IHorizontalAxisBead)) xAxis = _strand.getBeadByType(IHorizontalAxisBead) as IHorizontalAxisBead;
			var xAxisOffset:Number = xAxis == null ? 0 : xAxis.axisHeight;
			var yAxis:IVerticalAxisBead;
			if (_strand.getBeadByType(IVerticalAxisBead)) yAxis = _strand.getBeadByType(IVerticalAxisBead) as IVerticalAxisBead;
			var yAxisOffset:Number = yAxis == null ? 0 : yAxis.axisWidth;
			
			var useWidth:Number = UIBase(_strand).width - yAxisOffset;
			var useHeight:Number = (UIBase(_strand).height / n) - gap - xAxisOffset;
			var seriesHeight:Number = useHeight;
			var xpos:Number = xAxisOffset;
			var ypos:Number = UIBase(_strand).height - xAxisOffset - seriesHeight;
			
			var barValues:Array = [];
			var maxValue:Number = 0;
			var scaleFactor:Number = 1;
			
			for (var i:int=0; i < n; i++)
			{
				barValues.push({totalValue:0, scaleFactor:0});
				
				for (var s:int = 0; s < series.length; s++)
				{
					var bcs:BarChartSeries = series[s] as BarChartSeries;
					var m:Array = factory.seriesRenderers[i] as Array;
					var item:IChartItemRenderer = m[s] as IChartItemRenderer;
					var data:Object = item.data;
					var field:String = bcs.yField;
					
					var yValue:Number = Number(data[field]);
					barValues[i].totalValue += yValue;
				}
				
				maxValue = Math.max(maxValue, barValues[i].totalValue);
			}
			
			scaleFactor = useWidth/maxValue;
			
			for (i=0; i < n; i++)
			{
				m = factory.seriesRenderers[i] as Array;
				xpos = yAxisOffset;
				for (s=0; s < m.length; s++)
				{
					var child:IChartItemRenderer = m[s] as IChartItemRenderer;
					data = child.data
					yValue = Number(data[child.yField]);
					
					child.x = xpos;
					child.width = yValue*scaleFactor;
					child.y = ypos;
					child.height = seriesHeight;
					
					xpos += yValue*scaleFactor;
				}
				
				ypos -= gap + seriesHeight;
			}
			
			IEventDispatcher(_strand).dispatchEvent(new Event("layoutComplete"));
		}
	}
}