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
package org.apache.royale.charts.beads
{
	import org.apache.royale.charts.core.IChart;
	import org.apache.royale.charts.core.IVerticalAxisBead;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.models.ArraySelectionModel;
	
	/**
	 *  The VerticalLinearAxisBead class provides a vertical axis that uses a numeric
	 *  range. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class VerticalLinearAxisBead extends AxisBaseBead implements IBead, IVerticalAxisBead
	{
		public function VerticalLinearAxisBead()
		{
			super();
			
			placement = "left";
		}
		
		private var _strand:IStrand;
				
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			super.strand = value;
			
			// in order to draw or create the labels, need to know when the series has been created.
			IEventDispatcher(strand).addEventListener("layoutComplete",handleItemsCreated);
		}
		override public function get strand():IStrand
		{
			return _strand;
		}
		
		private var _axisWidth:Number = 50;
		
		public function get axisWidth():Number
		{
			return _axisWidth;
		}
		public function set axisWidth(value:Number):void
		{
			_axisWidth = value;
		}
		
		private var _valueField:String;
		
		/**
		 *  The name of field within the chart data the holds the value being mapped
		 *  to this axis. If values should fall within minimum and maximum but if
		 *  not, they will be fixed to the closest value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get valueField():String
		{
			return _valueField;
		}
		public function set valueField(value:String):void
		{
			_valueField = value;
		}
		
		private var _minimum:Number = 0;
		
		/**
		 *  The minimun value to be represented on this axis. If minimum is NaN,
		 *  the value is calculated from the data.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get minimum():Number
		{
			return _minimum;
		}
		public function set minimum(value:Number):void
		{
			_minimum = value;
		}
		
		private var _maximum:Number = Number.NaN;
		
		/**
		 *  The maximum value to be represented on this axis. If maximum is NaN,
		 *  the value is calculated from the data.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get maximum():Number
		{
			return _maximum;
		}
		public function set maximum(value:Number):void
		{
			_maximum = value;
		}
		
		/**
		 * @private
		 */
		protected function formatLabel(n:Number):String
		{
			var sign:Number = n < 0 ? -1 : 1;
			n = Math.abs(n);
			
			var i:int;
			
			if (0 <= n && n <= 1) {
				i = Math.round(n * 100);
				n = i / 100.0;
			}
			else {
				i = Math.round(n);
				n = i;
			}
			
			var result:String = String(sign*n);
			return result;
		}
		
		/**
		 * @private
		 */
		protected function handleItemsCreated(event:Event):void
		{
			var model:ArraySelectionModel = strand.getBeadByType(ISelectionModel) as ArraySelectionModel;
			var items:Array;
			if (model.dataProvider is Array) items = model.dataProvider as Array;
			else return;
			
			clearGraphics();
			
			var series:Array = IChart(strand).series;
			
			var useHeight:Number = UIBase(axisGroup).height;
			var useWidth:Number  = UIBase(axisGroup).width;
			var xpos:Number = 0;
			var ypos:Number = useHeight;
			var minValue:Number = Number.MAX_VALUE;
			var maxValue:Number = Number.MIN_VALUE;
			
			// determine minimum and maximum values, if needed
			if (isNaN(minimum)) {
				for(var i:int=0; i < items.length; i++) {
					var value:Number = Number(items[i][valueField]);
					if (!isNaN(value)) minValue = Math.min(minValue,value);
					else minValue = Math.min(minValue,0);
				}
			} else {
				minValue = minimum;
			}
			if (isNaN(maximum)) {
				for(i=0; i < items.length; i++) {
					value = Number(items[i][valueField]);
					if (!isNaN(value)) maxValue = Math.max(maxValue,value);
					else maxValue = Math.max(maxValue,0);
				}
			} else {
				maxValue = maximum;
			}
			
			var range:Number = maxValue - minValue;
			var numTicks:Number = 10; // should determine this some other way, I think
			var tickStep:Number = range/numTicks;
			var tickSpacing:Number = useHeight/numTicks;
			var tickValue:Number = minimum;
			
			// place the labels below the axis enough to account for the tick marks
			var labelY:Number = UIBase(axisGroup).height + 8;
			
			for(i=0; i < numTicks+1; i++) 
			{			
				var label:Object = addTickLabel(formatLabel(tickValue), 0, ypos, 0, tickSpacing);
				label.y = ypos - label.height/2;
			
				// add a tick mark, too.
				addTickMark(useWidth-6, ypos, 5, 0);
				
				ypos -= tickSpacing;
				tickValue += tickStep;
			}
			
			// draw the axis and the tick marks
			drawAxisPath(useWidth-1, 0, 0, useHeight);
			drawTickPath(useWidth-6, 0);
			
		}
		
	}
}
