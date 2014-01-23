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
package org.apache.flex.charts.supportClasses
{
	import org.apache.flex.core.IItemRendererFactory;
	
	import org.apache.flex.charts.core.IChartSeries;
	
	public class BarChartSeries implements IChartSeries
	{
		public function BarChartSeries()
		{
		}
		
		private var _xField:String = "x";
		public function get xField():String
		{
			return _xField;
		}
		public function set xField(value:String):void
		{
			_xField = value;
		}
		
		private var _yField:String;
		public function get yField():String
		{
			return _yField;
		}
		public function set yField(value:String):void
		{
			_yField = value;
		}
		
		private var _fillColor:uint;
		public function get fillColor():uint
		{
			return _fillColor;
		}
		public function set fillColor(value:uint):void
		{
			_fillColor = value;
		}
		
		private var _itemRenderer:IItemRendererFactory;
		public function get itemRenderer():IItemRendererFactory
		{
			return _itemRenderer;
		}
		public function set itemRenderer(value:IItemRendererFactory):void
		{
			_itemRenderer = value;
		}
	}
}