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
	 *  The VerticalCategoryAxisForArrayListBead displays a vertical axis with
	 *  tick marks corresponding to data points identified by the
	 *  categoryField property. This type of axis is useful for non-numeric
	 *  plots. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class VerticalCategoryAxisForArrayListBead extends VerticalCategoryAxisBead
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function VerticalCategoryAxisForArrayListBead()
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
			var itemHeight:Number = (useHeight - gap*(items.length-1)) / items.length;
			var xpos:Number = 0;
			var ypos:Number = useHeight - itemHeight/2;
			
			var numTicks:Number = items.length;
			var tickSpacing:Number = itemHeight + gap;
			
			for(var i:int=0; i < items.length; i++) 
			{				
				var item:Object = items.getItemAt(i);
				var label:Object = addTickLabel(item[categoryField], 0, ypos, 0, itemHeight);
				label.y = ypos - label.height/2;
				
				// add a tick mark, too.
				addTickMark(useWidth-6, ypos, 5, 0);
				
				ypos -= tickSpacing;
			}
			
			// draw the axis and tick marks
			drawAxisPath(useWidth-1, 0, 0, useHeight);
			drawTickPath(useWidth-6, 0);
		}
	}
}
