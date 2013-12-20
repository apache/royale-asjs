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
package org.apache.flex.html.custom.beads.layout
{	
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IDataProviderItemRendererMapper;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.custom.beads.ChartItemRendererFactory;
	import org.apache.flex.html.custom.beads.IChart;
	import org.apache.flex.html.custom.beads.IChartItemRenderer;
	import org.apache.flex.html.custom.supportClasses.BarChartSeries;
	
	public class BarChartLayout implements IBeadLayout
	{
		public function BarChartLayout()
		{
		}
		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			IEventDispatcher(value).addEventListener("widthChanged", changeHandler);
			IEventDispatcher(value).addEventListener("childrenAdded", changeHandler);
			IEventDispatcher(value).addEventListener("itemsCreated", changeHandler);
		}
		
		private var _gap:Number = 20;
		public function get gap():Number
		{
			return _gap;
		}
		public function set gap(value:Number):void
		{
			_gap = value;
		}
		
		private function changeHandler(event:Event):void
		{
			var layoutParent:ILayoutParent = _strand.getBeadByType(ILayoutParent) as ILayoutParent;
			
			var factory:ChartItemRendererFactory = _strand.getBeadByType(IDataProviderItemRendererMapper) as ChartItemRendererFactory;
			var n:int = factory.seriesRenderers.length;
			
			var xpos:Number = 0;
			var useWidth:Number = (UIBase(_strand).width / n) - gap;
			var useHeight:Number = UIBase(_strand).height;
			
			var maxYValue:Number = 0;
			var series:Array = IChart(_strand).series;
			trace("There are "+series.length+" series in this chart");
			var seriesMaxes:Array = [];
			
			for (var s:int = 0; s < series.length; s++)
			{
				var bcs:BarChartSeries = series[s] as BarChartSeries;
				seriesMaxes.push({maxValue:0,scaleFactor:0});
				
				for (var i:int = 0; i < n; i++)
				{
					var m:Array = factory.seriesRenderers[i] as Array;
					var item:IChartItemRenderer = m[s] as IChartItemRenderer;
					var data:Object = item.data;
					var field:String = bcs.yField;
					
					var yValue:Number = Number(data[field]);
					seriesMaxes[s].maxValue = Math.max(seriesMaxes[s].maxValue,yValue);
				}
				
				seriesMaxes[s].scaleFactor = useHeight/seriesMaxes[s].maxValue;
			}
			
			for (i = 0; i < n; i++)
			{
				m = factory.seriesRenderers[i] as Array;
				for (s=0; s < m.length; s++)
				{
					var seriesWidth:Number = useWidth/series.length;
					var child:IChartItemRenderer = m[s] as IChartItemRenderer;
					data = child.data
					yValue = Number(data[child.yField]);
					
					child.y = useHeight - yValue*seriesMaxes[s].scaleFactor;
					child.x = xpos;
					child.width = seriesWidth;
					child.height = yValue*seriesMaxes[s].scaleFactor;
					xpos += seriesWidth;
				}
				
				xpos += gap;
				
			}
			
			IEventDispatcher(_strand).dispatchEvent(new Event("layoutComplete"));
		}
	}
}