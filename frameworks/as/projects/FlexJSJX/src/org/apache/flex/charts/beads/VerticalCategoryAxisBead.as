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
package org.apache.flex.charts.beads
{
	import org.apache.flex.charts.core.IChart;
	import org.apache.flex.charts.core.IHorizontalAxisBead;
	import org.apache.flex.charts.core.IVerticalAxisBead;
	import org.apache.flex.core.FilledRectangle;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.Label;
	import org.apache.flex.html.beads.models.ArraySelectionModel;
	
	/**
	 *  The VerticalCategoryAxisBead displays a vertical axis with
	 *  tick marks corresponding to data points identified by the
	 *  categoryField property. This type of axis is useful for non-numeric
	 *  plots. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class VerticalCategoryAxisBead implements IBead, IVerticalAxisBead
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function VerticalCategoryAxisBead()
		{
		}
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			// in order to draw or create the labels, need to know when the series has been created.
			IEventDispatcher(_strand).addEventListener("layoutComplete",handleItemsCreated);
		}
		
		private var _categoryField:String;
		
		/**
		 *  The name of field within the chart data to used to categorize each of the
		 *  axis data points.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get categoryField():String
		{
			return _categoryField;
		}
		public function set categoryField(value:String):void
		{
			_categoryField = value;
		}
		
		private var _axisWidth:Number = 100;
		
		/**
		 *  The overall width of the axis.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get axisWidth():Number
		{
			return _axisWidth;
		}
		
		public function set axisWidth(value:Number):void
		{
			_axisWidth = value;
		}
		
		private var _gap:Number = 20;
		
		/**
		 *  The amount of space to leave between series. If a chart has several series,
		 *  the bars for an X value are side by side with a gap between the groups of
		 *  bars.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get gap():Number
		{
			return _gap;
		}
		public function set gap(value:Number):void
		{
			_gap = value;
		}
		
		/**
		 * @private
		 */
		private function handleItemsCreated(event:Event):void
		{	
			var model:ArraySelectionModel = _strand.getBeadByType(ISelectionModel) as ArraySelectionModel;
			var items:Array;
			if (model.dataProvider is Array) items = model.dataProvider as Array;
			else return;
			
			var series:Array = IChart(_strand).series;
			
			var xAxis:IHorizontalAxisBead;
			if (_strand.getBeadByType(IHorizontalAxisBead)) xAxis = _strand.getBeadByType(IHorizontalAxisBead) as IHorizontalAxisBead;
			var xAxisOffset:Number = xAxis == null ? 0 : xAxis.axisHeight;
			
			var yAxisWidthOffset:Number = axisWidth;
			var useHeight:Number = (UIBase(_strand).height-xAxisOffset) / items.length;
			var seriesHeight:Number = useHeight/series.length;
			var xpos:Number = yAxisWidthOffset;
			var ypos:Number = UIBase(_strand).height - xAxisOffset - seriesHeight - gap;
			
			// draw the vertical axis
			var horzLine:FilledRectangle = new FilledRectangle();
			horzLine.fillColor = 0x111111;
			horzLine.x = yAxisWidthOffset;
			horzLine.y = 0;
			horzLine.height = UIBase(_strand).height - xAxisOffset;
			horzLine.width = 1;
			UIBase(_strand).addElement(horzLine);
			
			// place the labels left of the axis enough to account for the tick marks
			var labelX:Number = 0;
			
			for(var i:int=0; i < items.length; i++) {				
				var label:Label = new Label();
				label.text = items[i][categoryField];
				label.x = 0;
				label.y = (ypos + useHeight/2) - label.height/2;
				label.width = yAxisWidthOffset;
				
				UIBase(_strand).addElement(label);
				
				// add a tick mark, too
				var tick:FilledRectangle = new FilledRectangle();
				tick.fillColor = 0x111111;
				tick.x = yAxisWidthOffset - 5;
				tick.y = ypos + useHeight/2;
				tick.width = 5;
				tick.height = 1;
				UIBase(_strand).addElement(tick);
				
				ypos -= useHeight;
			}
		}
	}
}