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
package org.apache.royale.charts.beads
{
	import org.apache.royale.charts.core.IChartDataGroup;
	import org.apache.royale.charts.core.IChartItemRenderer;
	import org.apache.royale.charts.core.IChartSeries;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.events.utils.MouseUtils;
	import org.apache.royale.geom.Point;
	import org.apache.royale.html.accessories.ToolTipBead;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.utils.PointUtils;
	
	/**
	 *  The DataTipBead can be added to a chart to produce a helpful tip when the
	 *  moves over an itemRenderer.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DataTipBead extends ToolTipBead implements IBead
	{
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DataTipBead()
		{
		}
		
		private var _strand:IStrand;
		
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			_strand = value;
			
			IEventDispatcher(_strand).addEventListener("viewCreated", handleViewCreated);
		}
		
		private var _labelFunction:Function;
		
		/**
		 *  An optional function that can format the data tip text.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get labelFunction():Function
		{
			return _labelFunction;
		}
		public function set labelFunction(value:Function):void
		{
			_labelFunction = value;
		}
		
		/**
		 * @private
		 */
		private function handleViewCreated( event:Event ):void
		{
			// find the data group
			var chart:IListView = _strand.getBeadByType(IListView) as IListView;
			var dataGroup:IChartDataGroup = chart.dataGroup as IChartDataGroup;
			IEventDispatcher(dataGroup).addEventListener(MouseEvent.MOUSE_OVER, rollOverHandler);
		}
		
		/**
		 * @private
		 * Overrides the ToolTipBead's function to determine the text to display
		 * based on the chart series and current value.
		 */
		override protected function rollOverHandler( event:MouseEvent ):void
		{
			var renderer:IChartItemRenderer = findItemRenderer(event);
			if (renderer)
			{
				var series:IChartSeries = renderer.series;
				var result:String;
				
				if (labelFunction) {
					result = labelFunction(renderer);
				}
				else {
					if (series.xField) result = renderer.data[series.xField];
					else if (series.yField) result = renderer.data[series.yField];
				}
				this.toolTip = result;
				
				super.rollOverHandler(event);
			}
		}
		
		/**
		 * @private
		 * Override's the ToolTipBead's function to position the data tip just above
		 * the itemRenderer.
		 */
		override protected function determinePosition(event:MouseEvent, base:Object):Point
		{
			// always want above the renderer
			var pt:Point = new Point(0, -20);
			pt = PointUtils.localToGlobal(pt, base);
			return pt;
		}
		
		/**
		 * @private
		 */
		private function findItemRenderer(event:MouseEvent):IChartItemRenderer
		{
			var base:Object = MouseUtils.eventTarget(event);
			
			if (base is IChartDataGroup)
			{
				var dataGroup:IChartDataGroup = base as IChartDataGroup;
				var point:Point = new Point(event.localX, event.localY);
				var renderer:IChartItemRenderer = dataGroup.getItemRendererUnderPoint(point);
				return renderer;
			}
			else
			{
				var chain:UIBase = base as UIBase;
				while (chain != null && !(chain is IChartItemRenderer)) {
					chain = chain.parent as UIBase;
				}
				return chain as IChartItemRenderer;
			}
		}
	}
}
