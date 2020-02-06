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
	public class DataItemRendererFactoryForSeriesArrayListData extends DataItemRendererFactoryForSeriesData
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
		
        private var factory:IItemRendererClassFactory;
        private var chart:IChart;
        private var series:Array;
        private var dp:ArrayList;
		
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
		override protected function dataProviderChangeHandler(event:Event):void
		{
            dp = dataProviderModel.dataProvider as ArrayList;
            super.dataProviderChangeHandler(event);
        }
                
        override protected function getItemAt(index:int):Object
        {
            return dp.getItemAt(index);
        }
    }
}

