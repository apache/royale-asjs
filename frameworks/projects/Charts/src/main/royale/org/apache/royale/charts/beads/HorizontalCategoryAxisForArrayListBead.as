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
	import org.apache.royale.charts.core.IHorizontalAxisBead;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.models.ArrayListSelectionModel;
	
	/**
	 *  The HorizontalCategoryAxisForArrayListBead displays a horizontal axis with
	 *  tick marks corresponding to data points identified by the
	 *  categoryField property. This type of axis is useful for non-numeric
	 *  plots. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class HorizontalCategoryAxisForArrayListBead extends HorizontalCategoryAxisBead
	{
		public function HorizontalCategoryAxisForArrayListBead()
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
			
			// place the labels below the axis enough to account for the tick marks
			var labelY:Number = 7;
			var itemWidth:Number = (useWidth - gap*(items.length-1))/items.length;
			
			for(var i:int=0; i < items.length; i++) 
			{				
				var item:Object = items.getItemAt(i);
				addTickLabel(item[categoryField], xpos, labelY, itemWidth, 0);
				
				// add a tick mark, too		
				addTickMark(xpos + itemWidth/2, 0, 0, 5);
				
				xpos += itemWidth + gap;
			}
			
			// draw the axis and the tick marks
			drawAxisPath(0, 0, useWidth, 1);
			drawTickPath(0, 1);
		}
		
	}
}
