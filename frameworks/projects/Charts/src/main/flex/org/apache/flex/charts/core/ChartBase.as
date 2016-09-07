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
package org.apache.flex.charts.core
{
	import org.apache.flex.events.Event;
	import org.apache.flex.html.List;
	
	/**
	 *  The ChartBase class contains all of the properties common to most
	 *  charts. Some charts may not make any or full use of the properties
	 *  however.
	 * 
	 *  A chart is based on List which provides data and item renderers to
	 *  draw the chart graphics. Charts are essentially lists with a
	 *  different visualization.
	 * 
	 *  Similar to a List, the chart's layout provides the structure of
	 *  chart while the itemRenderers take care of the actual drawing.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class ChartBase extends List implements IChart
	{
		/**
		 *  constructor. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function ChartBase()
		{
			super();
		}
		
		private var _series:Array;
		
		/**
		 *  The collection of series for the chart. Each element of the
		 *  series array should be of type IChartSeries.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get series():Array
		{
			return _series;
		}
		public function set series(value:Array):void
		{
			_series = value;
			dispatchEvent(new Event("seriesChanged"));
		}
	}
}
