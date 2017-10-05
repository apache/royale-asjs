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
	 *  The ColumnSeries defines what field is being plotted from
	 *  the chart's dataProvider. For ColumnSeries, only the yField
	 *  is used. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ColumnSeries implements IChartSeries
	{
		public function ColumnSeries()
		{
		}
		
		/**
		 *  @private
		 */
		public function get xField():String
		{
			return null;
		}
		public function set xField(value:String):void
		{
			// not used
		}
		
		private var _yField:String;
		
		/**
		 *  The name of the field that provides the Y or vertical value for an
		 *  item in the chart.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get yField():String
		{
			return _yField;
		}
		public function set yField(value:String):void
		{
			_yField = value;
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
