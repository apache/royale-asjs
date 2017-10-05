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
package org.apache.royale.charts.beads.models
{
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	
	import org.apache.royale.html.beads.models.ArraySelectionModel;
	
	import org.apache.royale.charts.core.IChartDataModel;
	import org.apache.royale.charts.core.IChartSeries;
	
	/**
	 *  The ArraySelectionModel class is a selection model for
	 *  a dataProvider that is an array. It assumes that items
	 *  can be fetched from the dataProvider
	 *  dataProvider[index].  Other selection models
	 *  would support other kinds of data providers.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ChartArraySelectionModel extends ArraySelectionModel implements IChartDataModel
	{
		public function ChartArraySelectionModel()
		{
			super();
		}
		
		private var _series:IChartSeries;
		public function get selectedSeries():IChartSeries
		{
			return _series;
		}
		public function set selectedSeries(value:IChartSeries):void
		{
			if (value != _series) {
				_series = value;
				dispatchEvent(new Event("selectedSeriesChanged"));
			}
		}
		
		private var _rollOverSeries:IChartSeries;
		public function get rollOverSeries():IChartSeries
		{
			return _rollOverSeries;
		}
		public function set rollOverSeries(value:IChartSeries):void
		{
			if (value != _rollOverSeries) {
				_rollOverSeries = value;
				dispatchEvent(new Event("rollOverSeriesChanged"));
			}
		}
	}
}
