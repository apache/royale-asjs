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
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IDataProviderItemRendererMapper;
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.IItemRendererClassFactory;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.ItemRendererClassFactory;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.DataItemRendererFactoryBase;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.utils.sendStrandEvent;

	/**
	 *  The DataItemRendererFactoryForSeriesData creates the itemRenderers necessary for series-based
	 *  charts. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DataItemRendererFactoryForSeriesData extends DataItemRendererFactoryBase
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DataItemRendererFactoryForSeriesData()
		{
            factory =  new ChartItemRendererClassFactory(this);
            itemRendererFactory = factory;
		}
		
        private var factory:IItemRendererClassFactory;
        private var chart:IChart;
        private var series:Array;
        private var dp:Array;
        
        override public function set strand(value:IStrand):void
        {
            super.strand = value;
            value.addBead(factory);
            value.addBead(new ChartItemRendererInitializer(this))
        }
        
        public var chartSeries:IChartSeries;
        
        private var blockItemsCreatedEvent:Boolean;
        
        /**
         * @private
         * @royaleignorecoercion org.apache.royale.core.ISelectionModel
         * @royaleignorecoercion org.apache.royale.html.beads.IListView
         * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         * @royaleignorecoercion org.apache.royale.charts.core.IChartDataGroup
         * @royaleignorecoercion org.apache.royale.charts.core.IChartItemRenderer
         * @royaleignorecoercion org.apache.royale.charts.core.IChartSeries
         * @royaleemitcoercion org.apache.royale.collections.Array
         */
        override protected function dataProviderChangeHandler(event:Event):void
        {
            dp = dataProviderModel.dataProvider as Array;
            chart = _strand as IChart;
            series = chart.series;
            
            var listView:IListView = _strand.getBeadByType(IListView) as IListView;
            var dataGroup:IChartDataGroup = listView.dataGroup as IChartDataGroup;
            
            blockItemsCreatedEvent = true;
            for (var s:int=0; s < series.length; s++)
            {				
                var n:int = dp.length; 
                chartSeries = series[s] as IChartSeries;
                if (chartSeries.itemRenderer)
                {
                    if (itemRendererFactory is ItemRendererClassFactory)
                        (itemRendererFactory as ItemRendererClassFactory).itemRendererFactory = chartSeries.itemRenderer;
                    super.dataProviderChangeHandler(event);
                }
            }
            blockItemsCreatedEvent = false;
            sendStrandEvent(_strand,"itemsCreated");
        }
        
        override protected function dispatchItemCreatedEvent():void
        {
            if (blockItemsCreatedEvent)
                return;
            super.dispatchItemCreatedEvent();
        }
        
        override protected function removeAllItemRenderers(parent:IItemRendererOwnerView):void
        {
            // do nothing.  We don't want to remove the renderers
            // between each series, we removed them all ourselves
            // earlier.
        }
        
        override protected function get dataProviderLength():int
        {
            return dp.length;
        }
        
        override protected function getItemAt(index:int):Object
        {
            return dp[index];
        }
    }
}

import org.apache.royale.charts.beads.DataItemRendererFactoryForSeriesData;
import org.apache.royale.charts.core.IChartItemRenderer;
import org.apache.royale.core.Bead;
import org.apache.royale.core.IDataProviderModel;
import org.apache.royale.core.IIndexedItemRenderer;
import org.apache.royale.core.IIndexedItemRendererInitializer;
import org.apache.royale.core.IItemRenderer;
import org.apache.royale.core.IItemRendererOwnerView;
import org.apache.royale.core.IStrand;
import org.apache.royale.core.SelectableItemRendererClassFactory;
import org.apache.royale.core.UIBase;
import org.apache.royale.html.beads.IListView;

class ChartItemRendererClassFactory extends SelectableItemRendererClassFactory
{
    private var owner:DataItemRendererFactoryForSeriesData;
    
    public function ChartItemRendererClassFactory(ref:DataItemRendererFactoryForSeriesData)
    {
        owner = ref;
        createFunction = createChartSeriesRenderer;
    }
    
    private function createChartSeriesRenderer():IItemRenderer
    {
        var ir:IChartItemRenderer = owner.chartSeries.itemRenderer.newInstance() as IChartItemRenderer;
        return ir;
    }
}


class ChartItemRendererInitializer extends Bead implements IIndexedItemRendererInitializer		
{
    private var owner:DataItemRendererFactoryForSeriesData;
    
    public function ChartItemRendererInitializer(ref:DataItemRendererFactoryForSeriesData)
    {
        owner = ref;    
    }
    
    private var _strand:IStrand;
    
    /**
     *  @copy org.apache.royale.core.IBead#strand
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     *  @royaleignorecoercion HTMLInputElement
     *  @royaleignorecoercion org.apache.royale.core.UIBase;
     */
    override public function set strand(value:IStrand):void
    {	
        _strand = value;
        
        var listView:IListView = _strand.getBeadByType(IListView) as IListView;
        var ownerView:IItemRendererOwnerView = listView.dataGroup as IItemRendererOwnerView;
    }
    
    private var ownerView:IItemRendererOwnerView;
    
    /**
     *  @private
     *  @royaleignorecoercion org.apache.royale.core.HTMLElementWrapper
     */
    public function initializeItemRenderer(ir:IIndexedItemRenderer, data:Object):void
    {
    }
    
    /**
     *  @private
     *  @royaleignorecoercion org.apache.royale.core.IChartItemRenderer
     */
    public function initializeIndexedItemRenderer(ir:IIndexedItemRenderer, data:Object, index:int):void
    {
        var chartIR:IChartItemRenderer = ir as IChartItemRenderer;
        chartIR.series = owner.chartSeries;
        chartIR.itemRendererOwnerView = ownerView;
        
        ir.index = index;
        initializeItemRenderer(ir, data);
    }        
}