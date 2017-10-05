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
	import org.apache.royale.core.IFactory;

	/**
	 *  The IChartSeries interface is the basic interface for any type of
	 *  chart data series. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public interface IChartSeries
	{
		/**
		 *  The name field that represents the X-axis value for the chart series.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function get xField():String;
		function set xField(value:String):void;
		
		/**
		 *  The name field that represents the Y-axis value for the chart series.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function get yField():String;
		function set yField(value:String):void;
		
		/**
		 *  The itemRenderer class or factory that produces an instance of that class. This
		 *  renderer uses the series data and properties to draw the representation for the
		 *  chart type (e.g., the BarChart draws a bar in the fillColor).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function get itemRenderer():IFactory;
		function set itemRenderer(value:IFactory):void;
	}
}
