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
	import org.apache.flex.charts.core.IChartItemRenderer;
	import org.apache.flex.charts.core.IChartSeries;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IDataProviderItemRendererMapper;
	import org.apache.flex.core.IItemRendererClassFactory;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.staticControls.beads.IListView;
	
	public class ChartItemRendererFactory implements IBead, IDataProviderItemRendererMapper
	{
		public function ChartItemRendererFactory()
		{
		}
		
		private var selectionModel:ISelectionModel;
		protected var dataGroup:IItemRendererParent;
		
		private var _seriesRenderers:Array;
		public function get seriesRenderers():Array
		{
			return _seriesRenderers;
		}
		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			selectionModel = value.getBeadByType(ISelectionModel) as ISelectionModel;
			var listView:IListView = value.getBeadByType(IListView) as IListView;
			dataGroup = listView.dataGroup;
			//			selectionModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);
			
			var dp:Array = selectionModel.dataProvider as Array;
			if (!dp)
				return;
			
			_seriesRenderers = new Array();
			
			dataGroup.removeAllElements();
			
			var series:Array = IChart(_strand).series;
			
			for( var j:int=0; j < dp.length; j++)
			{
				var renderers:Array = new Array();
				
				for( var i:int=0; i < series.length; i++)
				{
					var s:IChartSeries = series[i] as IChartSeries;
					var k:IChartItemRenderer = s.itemRenderer.newInstance() as IChartItemRenderer;
					k.xField = s.xField;
					k.yField = s.yField;
					k.fillColor = s.fillColor;
					k.data = dp[j];
					k.index = j;
					
					renderers.push(k);
					
					dataGroup.addElement(k);
				}
				
				_seriesRenderers.push(renderers);
			}
			
			IEventDispatcher(_strand).dispatchEvent(new Event("itemsCreated"));
		}
		
		public function get itemRendererFactory():IItemRendererClassFactory
		{
			return null;
		}
		
		public function set itemRendererFactory(value:IItemRendererClassFactory):void
		{
		}
	}
}