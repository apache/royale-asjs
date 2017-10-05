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
	 *  The VerticalCategoryAxisBead displays a vertical axis with
	 *  tick marks corresponding to data points identified by the
	 *  categoryField property. This type of axis is useful for non-numeric
	 *  plots. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class VerticalCategoryAxisBead extends AxisBaseBead implements IBead, IVerticalAxisBead
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function VerticalCategoryAxisBead()
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

		private var _categoryField:String;
		
		/**
		 *  The name of field within the chart data to used to categorize each of the
		 *  axis data points.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
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
		public function get maximum():Number
		{
			return Number.NaN;
		}
		
		/**
		 * @private
		 */
		public function get minimum():Number
		{
			return 0;
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
			var itemHeight:Number = (useHeight - gap*(items.length-1)) / items.length;
			var xpos:Number = 0;
			var ypos:Number = useHeight - itemHeight/2;
			
			var numTicks:Number = items.length;
			var tickSpacing:Number = itemHeight + gap;
			
			for(var i:int=0; i < items.length; i++) 
			{				
				var label:Object = addTickLabel(items[i][categoryField], 0, ypos, 0, itemHeight);
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
