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
	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.charts.core.IChart;
	import org.apache.royale.charts.core.IVerticalAxisBead;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.models.ArrayListSelectionModel;
	
	/**
	 *  The VerticalLinearAxisBead class provides a vertical axis that uses a numeric
	 *  range. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class VerticalLinearAxisForArrayListBead extends VerticalLinearAxisBead
	{
		public function VerticalLinearAxisForArrayListBead()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function handleItemsCreated(event:Event):void
		{
			var model:ArrayListSelectionModel = strand.getBeadByType(ISelectionModel) as ArrayListSelectionModel;
			var items:ArrayList;
			if (model.dataProvider is ArrayList) items = model.dataProvider as ArrayList;
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
					var item:Object = items.getItemAt(i);
					var value:Number = Number(item[valueField]);
					if (!isNaN(value)) minValue = Math.min(minValue,value);
					else minValue = Math.min(minValue,0);
				}
			} else {
				minValue = minimum;
			}
			if (isNaN(maximum)) {
				for(i=0; i < items.length; i++) {
					item = items.getItemAt(i);
					value = Number(item[valueField]);
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
