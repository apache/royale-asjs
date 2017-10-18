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
	
	public class PieSeries implements IChartSeries
	{
		public function PieSeries()
		{
		}
		
		private var _dataField:String;
		public function get dataField():String
		{
			return _dataField;
		}
		public function set dataField(value:String):void
		{
			_dataField = value;
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
		
		// todo: fillColors - one color for each wedge which will be repeated if necessary
		
		/*
		 * Properties ignored for PieChartSeries
		 */
		
		public function get xField():String
		{
			return null;
		}
		
		public function set xField(value:String):void
		{
		}
		
		public function get yField():String
		{
			return null;
		}
		
		public function set yField(value:String):void
		{
		}
	}
}
