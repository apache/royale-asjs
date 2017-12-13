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
package org.apache.royale.charts.core
{
	/**
	 *  The IChart interface is the basic interface for every chart component. All
	 *  charts have a least one "series" - a collection of data values for each
	 *  axis of the chart (a PieChart follows this pattern, too, since the total
	 *  number of items in its series represents 100% of the pie and each item
	 *  contributes some percentage). A Chart then uses a set of beads particular
	 *  to that chart type.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public interface IChart
	{
		/**
		 *  The collection of series for the chart. Each element of the
		 *  series array should be of type IChartSeries.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function get series():Array;
		function set series(value:Array):void;
	}
}
