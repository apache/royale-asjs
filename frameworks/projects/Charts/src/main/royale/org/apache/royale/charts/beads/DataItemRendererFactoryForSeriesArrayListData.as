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
	import org.apache.royale.charts.core.IChart;
	import org.apache.royale.charts.core.IChartDataGroup;
	import org.apache.royale.charts.core.IChartItemRenderer;
	import org.apache.royale.charts.core.IChartSeries;
	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IDataProviderItemRendererMapper;
	import org.apache.royale.core.IItemRendererClassFactory;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.IListView;
	
	/**
	 *  The DataItemRendererFactoryForSeriesData creates the itemRenderers necessary for series-based
	 *  charts. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DataItemRendererFactoryForSeriesArrayListData implements IBead, IDataProviderItemRendererMapper
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DataItemRendererFactoryForSeriesArrayListData()
		{
		}
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			IEventDispatcher(_strand).addEventListener("initComplete", initComplete);
		}
		public function get strand():IStrand
		{
			return _strand;
		}
		
		private function initComplete(event:Event):void
		{
			var selectionModel:ISelectionModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
			selectionModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);
			
			dataProviderChangeHandler(null);
		}
		
		/**
		 * For series data, the 'global' itemRendererFactory is not used. Each series supplies
		 * its own itemRendererFactory.
		 */
		public function get itemRendererFactory():IItemRendererClassFactory
		{
			return null;
		}
		public function set itemRendererFactory(value:IItemRendererClassFactory):void
		{
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 * @royaleignorecoercion org.apache.royale.html.beads.IListView
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 * @royaleignorecoercion org.apache.royale.charts.core.IChartDataGroup
		 * @royaleignorecoercion org.apache.royale.charts.core.IChartItemRenderer
		 * @royaleignorecoercion org.apache.royale.charts.core.IChartSeries
		 * @royaleemitcoercion org.apache.royale.collections.ArrayList
		 */
		private function dataProviderChangeHandler(event:Event):void
		{
			var selectionModel:ISelectionModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
			var dp:ArrayList = selectionModel.dataProvider as ArrayList;
			if (!dp)
				return;
			
			var listView:IListView = _strand.getBeadByType(IListView) as IListView;
			var dataGroup:IChartDataGroup = listView.dataGroup as IChartDataGroup;
			dataGroup.removeAllItemRenderers();
			
			var chart:IChart = _strand as IChart;
			var series:Array = chart.series;
						
			for (var s:int=0; s < series.length; s++)
			{				
				var n:int = dp.length; 
				var chartSeries:IChartSeries = series[s] as IChartSeries;
				
				for (var i:int = 0; i < n; i++)
				{
					if (chartSeries.itemRenderer)
					{
						var ir:IChartItemRenderer = chartSeries.itemRenderer.newInstance() as IChartItemRenderer;
						dataGroup.addItemRenderer(ir, false);
						ir.itemRendererOwnerView = dataGroup;
						ir.index = i;
						ir.data = dp.getItemAt(i)
						ir.series = chartSeries;
					}
				}
				
			}
			
			IEventDispatcher(_strand).dispatchEvent(new Event("itemsCreated"));
			//TODO (Harbs) I think layoutNeeded is always dispatched when itemsCreated is handled.
			IEventDispatcher(_strand).dispatchEvent(new Event("layoutNeeded"));
		}
	}
}
