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
package org.apache.royale.charts.supportClasses
{
    import org.apache.royale.core.IFactory;
    
	import org.apache.royale.charts.core.IChartSeries;
	
	/**
	 *  The BarSeries defines what field is being plotted from
	 *  the chart's dataProvider. For BarChartSeries, only the xField
	 *  is used. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class BarSeries implements IChartSeries
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function BarSeries()
		{
		}
		
		private var _xField:String = "x";
		
		/**
		 *  The name of the field corresponding to the X or horizontal value
		 *  for an item in the chart. 
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get xField():String
		{
			return _xField;
		}
		public function set xField(value:String):void
		{
			_xField = value;
		}
		
		private var _yField:String;
		
		/**
		 *  @private
		 */
		public function get yField():String
		{
			return null;
		}
		public function set yField(value:String):void
		{
			// not used
		}
		
		private var _itemRenderer:IFactory;
		
		/**
		 *  The class or class factory to use as the itemRenderer for each X/Y pair. The
		 *  itemRenderer class must implement the IChartItemRenderer interface.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get itemRenderer():IFactory
		{
			return _itemRenderer;
		}
		public function set itemRenderer(value:IFactory):void
		{
			_itemRenderer = value;
		}
	}
}
