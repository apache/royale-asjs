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
	import org.apache.flex.charts.core.IChart;
	import org.apache.flex.charts.core.IChartItemRenderer;
	import org.apache.flex.charts.supportClasses.PieChartSeries;
	import org.apache.flex.charts.supportClasses.WedgeItemRenderer;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IDataProviderItemRendererMapper;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
	public class PieChartLayout implements IBeadLayout
	{
		public function PieChartLayout()
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
		
		/**
		 * @private
		 */
		private function changeHandler(event:Event):void
		{
			var layoutParent:ILayoutParent = _strand.getBeadByType(ILayoutParent) as ILayoutParent;
			var chartArea:UIBase = layoutParent.contentView as UIBase;
			
			var factory:ChartItemRendererFactory = _strand.getBeadByType(IDataProviderItemRendererMapper) as ChartItemRendererFactory;
			var n:int = factory.seriesRenderers.length;
			
			var xpos:Number = 0;
			var useWidth:Number = UIBase(_strand).width;
			var useHeight:Number = UIBase(_strand).height;
			
			var maxYValue:Number = 0;
			var series:Array = IChart(_strand).series;
			trace("There are "+series.length+" series in this chart");
			var seriesMaxes:Array = [];
			var colors:Array = [0xFF0000, 0xFF9900, 0x00FF00, 0x00FFcc, 0x0000FF, 0xcc00FF, 0xFF00cc, 0x888888, 0x333333, 0xFFcc99];
			
			// determine the total value by adding up the dataField values.
			for (var s:int = 0; s < series.length; s++)
			{
				var pcs:PieChartSeries = series[s] as PieChartSeries;
				
				for (var i:int = 0; i < n; i++)
				{
					var m:Array = factory.seriesRenderers[i] as Array;
					var item:IChartItemRenderer = m[s] as IChartItemRenderer;
					var data:Object = item.data;
					var field:String = pcs.dataField;
					
					var yValue:Number = Number(data[field]);
					maxYValue += yValue;
					
					seriesMaxes.push( {yValue:yValue, percent:0, arc:0} );
				}
				
				for (i=0; i < n; i++)
				{
					var obj:Object = seriesMaxes[i];
					obj.percent = obj.yValue / maxYValue;
					obj.arc = 360.0*obj.percent;
					
					trace("dataPoint "+i+": value="+obj.yValue+"; percent="+obj.percent+"; arc="+obj.arc);
				}
				
				var start:Number = 0;
				var end:Number = 0;
				var radius:Number = Math.min(useWidth,useHeight)/2;
				var centerX:Number = useWidth/2;
				var centerY:Number = useHeight/2;
								
				for (i=0; i < n; i++)
				{
					obj = seriesMaxes[i];
					m = factory.seriesRenderers[i] as Array;
					var renderer:WedgeItemRenderer = m[s] as WedgeItemRenderer;
					
					end = start + (360.0 * obj.percent);
					var arc:Number = 360.0 * obj.percent;
					trace("Draw arc from "+start+" to "+(start+arc));
					renderer.fillColor = colors[i];
					renderer.drawWedge(chartArea,centerX, centerY, start*Math.PI/180, arc*Math.PI/180, radius);
					
					start += arc;
				}
			}
			// for each value, determine its %
			// use that % to determine the arc of the wedge
			
			// tell each wedge the data it needs so it can draw itself
			
			/*var pcs:PieChartSeries = series[0] as PieChartSeries;
			var m:WedgeItemRenderer = (factory.seriesRenderers[0] as Array)[0] as WedgeItemRenderer;
			
			for (var s:int = 0; s < series.length; s++)
			{
				var pcs:PieChartSeries = series[s] as PieChartSeries;
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
				
			}*/
			
			IEventDispatcher(_strand).dispatchEvent(new Event("layoutComplete"));
		}
	}
}