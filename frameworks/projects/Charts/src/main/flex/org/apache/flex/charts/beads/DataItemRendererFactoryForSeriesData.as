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
package org.apache.flex.charts.beads
{
	import org.apache.flex.charts.core.IChart;
	import org.apache.flex.charts.core.IChartDataGroup;
	import org.apache.flex.charts.core.IChartItemRenderer;
	import org.apache.flex.charts.core.IChartSeries;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IDataProviderItemRendererMapper;
	import org.apache.flex.core.IItemRendererClassFactory;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.beads.IListView;
	
	/**
	 *  The DataItemRendererFactoryForSeriesData creates the itemRenderers necessary for series-based
	 *  charts. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class DataItemRendererFactoryForSeriesData implements IBead, IDataProviderItemRendererMapper
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function DataItemRendererFactoryForSeriesData()
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
			var selectionModel:ISelectionModel = value.getBeadByType(ISelectionModel) as ISelectionModel;
			selectionModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);
			
			dataProviderChangeHandler(null);
		}
		public function get strand():IStrand
		{
			return _strand;
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
		 */
		private function dataProviderChangeHandler(event:Event):void
		{
			var selectionModel:ISelectionModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
			var dp:Array = selectionModel.dataProvider as Array;
			if (!dp)
				return;
			
			var listView:IListView = _strand.getBeadByType(IListView) as IListView;
			var dataGroup:IChartDataGroup = listView.dataGroup as IChartDataGroup;
			dataGroup.removeAllElements();
			
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
						dataGroup.addElement(ir);
						ir.itemRendererParent = dataGroup;
						ir.index = i;
						ir.data = dp[i];
						ir.series = chartSeries;
					}
				}
				
			}
			
			IEventDispatcher(_strand).dispatchEvent(new Event("itemsCreated"));
		}
	}
}
