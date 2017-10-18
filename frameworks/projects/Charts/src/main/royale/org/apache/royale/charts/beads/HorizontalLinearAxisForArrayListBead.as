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
	import org.apache.royale.charts.core.IHorizontalAxisBead;
	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.models.ArrayListSelectionModel;
	
	/**
	 *  The HorizontalLinearAxisForArrayListBead class provides a horizontal axis that uses a numeric
	 *  range. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class HorizontalLinearAxisForArrayListBead extends HorizontalLinearAxisBead
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function HorizontalLinearAxisForArrayListBead()
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
			
			var xpos:Number = 0;
			var useWidth:Number = UIBase(axisGroup).width;
			var series:Array = IChart(strand).series;
			var maxValue:Number = Number.MIN_VALUE;
			var minValue:Number = Number.MAX_VALUE;
			
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
			
			var numTicks:Number = 10; // should determine this some other way, I think
			var tickStep:Number = (maxValue - minValue)/numTicks;
			var tickSpacing:Number = useWidth/numTicks;
			var tickValue:Number = minValue;
			
			// place the labels below the axis enough to account for the tick marks
			var labelY:Number = 7;
			var lastX:Number = -1000;
			var lastWasHidden:Boolean = false;
			
			for(i=0; i < numTicks+1; i++) 
			{	
				var label:Object = addTickLabel(formatLabel(tickValue), xpos, labelY, tickSpacing, 0);
				label.x = xpos - label.width/2;
				
				// add a tick mark, too				
				addTickMark(xpos, 0, 0, 5);
				
				xpos += tickSpacing;
				tickValue += tickStep;
				
				if ((label.x-5) <= lastX && !lastWasHidden) {
					label.visible = false;
					lastWasHidden = true;
				} else {
					label.visible = true;
					lastWasHidden = false;
				}
				
				lastX = label.x + label.width;
			}
			
			// draw the axis and tick marks
			drawAxisPath(0, 0, useWidth, 0);
			drawTickPath(0, 1);
		}
	}
}
