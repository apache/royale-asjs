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
	 *  This class provides the basis for standard X-Y plots and anything
	 *  the requires a two-dimensional function graph. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class CartesianChart extends ChartBase
	{
		/**
		 *  constructor. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function CartesianChart()
		{
			super();
		}
		
		private var _xAxis:IHorizontalAxisBead;
		
		/**
		 *  The X Axis is typically the horizontal axis for a Cartesian chart.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get xAxis():IHorizontalAxisBead
		{
			return _xAxis;
		}
		
		public function set xAxis(value:IHorizontalAxisBead):void
		{
			_xAxis = value;
		}
		
		private var _yAxis:IHorizontalAxisBead;
		
		/**
		 *  The Y Axis is typically the vertical axis for a Cartesian chart.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get yAxis():IHorizontalAxisBead
		{
			return _yAxis;
		}
		
		public function set yAxis(value:IHorizontalAxisBead):void
		{
			_yAxis = value;
		}
	}
}
